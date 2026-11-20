// Checks the build as Cloudflare serves it, on this machine: wrangler dev
// (wrangler.jsonc) on a free loopback port, without Cloudflare credentials.
// Build it first (bun run web:build).
//
//   bun scripts/test-hosting.ts            (bun run web:test)
//   bun scripts/test-hosting.ts --online   (let the pages reach other sites too, and list them)
//
// 1. Everything scripts/hosting.ts expects: every file, the app's addresses
//    and addresses that aren't files.
// 2. Headless Chromium opens /, /privacy and a question, each in a fresh
//    profile, and waits for the app to show its page. Every request the page
//    and its service worker make stays on the site, CanvasKit and Roboto among
//    them, and the engine loads every font. Requests to other sites are
//    blocked; the only ones are a question's YouTube player, an iframe the
//    page embeds (lib/widgets/video_player.dart), which loads as the question
//    opens. With --online they go through, and it lists every host each page
//    reached, by frame: nothing is played.
import { spawn } from "node:child_process";
import { createServer, type AddressInfo } from "node:net";
import { join } from "node:path";
import { chromium, type Browser, type Request } from "playwright";
import { ROOT, hostingProblems } from "./hosting.ts";

// The home page opens the bookmarked question, or the first.
export const PAGES = ["/", "/privacy", "/12"];

// The iframes the app embeds itself: a question's explanation.
const EMBEDS = [/^https:\/\/www\.youtube\.com\/embed\//, /^https:\/\/drive\.google\.com\/file\/d\//];

async function freePort(): Promise<number> {
  const socket = createServer();
  await new Promise<void>((done) => socket.listen(0, "127.0.0.1", done));
  const { port } = socket.address() as AddressInfo;
  await new Promise<void>((done) => socket.close(() => done()));
  return port;
}

// Starts wrangler dev; resolves with its address and a function that stops it.
async function serve(): Promise<{ site: string; stop: () => Promise<void> }> {
  const port = await freePort();
  const site = `http://127.0.0.1:${port}`;
  const server = spawn(
    join(ROOT, "node_modules/.bin/wrangler"),
    ["dev", "--local", "--ip", "127.0.0.1", "--port", String(port), "--inspector-port", "0"],
    { cwd: ROOT, env: { ...process.env, WRANGLER_SEND_METRICS: "false" }, stdio: ["ignore", "pipe", "pipe"] },
  );
  let logs = "";
  let failed: Error | undefined;
  server.stdout.on("data", (chunk) => (logs += chunk));
  server.stderr.on("data", (chunk) => (logs += chunk));
  server.on("error", (error) => (failed = error));
  const stopped = new Promise<void>((done) => server.on("close", () => done()));
  const stop = async () => {
    server.kill("SIGTERM");
    const force = setTimeout(() => server.kill("SIGKILL"), 5_000);
    await stopped;
    clearTimeout(force);
  };
  for (let i = 0; i < 240; i++) {
    if (failed) throw failed;
    if (server.exitCode !== null) throw new Error(`wrangler dev exited:\n${logs}`);
    try {
      const response = await fetch(`${site}/version.json`, { signal: AbortSignal.timeout(1_000) });
      await response.arrayBuffer();
      if (response.ok) return { site, stop };
    } catch {
      // Still starting.
    }
    await new Promise((done) => setTimeout(done, 250));
  }
  await stop();
  throw new Error(`wrangler dev didn't start:\n${logs}`);
}

type Seen = { url: string; by: string };

// Opens path in a fresh profile and records every request until the app has
// shown its page and the network has settled.
async function open(browser: Browser, site: string, path: string, online: boolean) {
  const context = await browser.newContext({ serviceWorkers: "allow" });
  const seen: Seen[] = [];
  const messages: string[] = [];
  try {
    const page = await context.newPage();
    // Who made a request: the page, its service worker, or an iframe the page
    // embeds (with anything inside it), by the address it opened.
    const by = (request: Request) => {
      if (request.serviceWorker()) return "service worker";
      let frame = request.frame();
      if (frame === page.mainFrame()) return "page";
      while (frame.parentFrame() && frame.parentFrame() !== page.mainFrame()) frame = frame.parentFrame()!;
      const opening = frame === request.frame() && request.isNavigationRequest();
      return `iframe ${opening ? request.url() : frame.url()}`;
    };
    context.on("request", (request) => seen.push({ url: request.url(), by: by(request) }));
    page.on("console", (message) => messages.push(message.text()));
    if (!online) await context.route((url) => !url.href.startsWith(site), (route) => route.abort());
    await page.goto(site + path);
    // The app removes the splash once it has shown its page (FlutterNativeSplash.remove()).
    const started = await page
      .waitForFunction(() => !document.getElementById("splash"), null, { timeout: 60_000 })
      .then(() => true, () => false);
    await page.waitForLoadState("networkidle", { timeout: 30_000 }).catch(() => {});
    await page.waitForTimeout(online ? 5_000 : 1_000);
    return { started, seen, messages };
  } finally {
    await context.close();
  }
}

export async function requestProblems(site: string, online = false): Promise<{ problems: string[]; report: string[] }> {
  const problems: string[] = [];
  const report: string[] = [];
  const browser = await chromium.launch();
  try {
    for (const path of PAGES) {
      const { started, seen, messages } = await open(browser, site, path, online);
      if (!started) problems.push(`${path}: the app didn't show its page within a minute`);
      const own = seen.filter((s) => !s.by.startsWith("iframe"));
      const embedded = seen.filter((s) => s.by.startsWith("iframe"));
      // The site's own addresses, and data and blobs the page made itself.
      const onSite = (url: string) => url.startsWith(`${site}/`) || url.startsWith(`blob:${site}/`) || url.startsWith("data:");
      for (const s of own) {
        if (!onSite(s.url)) problems.push(`${path}: the ${s.by} requested ${s.url}`);
      }
      for (const s of embedded) {
        const frame = s.by.slice("iframe ".length);
        if (!EMBEDS.some((embed) => embed.test(frame))) problems.push(`${path}: an iframe the app doesn't embed, ${frame}, requested ${s.url}`);
      }
      if (!own.some((s) => /\/canvaskit\/.*\.wasm$/.test(s.url))) problems.push(`${path}: CanvasKit didn't load from the site`);
      if (!own.some((s) => /\/fonts\/roboto\/.*\.woff2$/.test(s.url))) problems.push(`${path}: Roboto didn't load from the site`);
      for (const message of messages.filter((m) => /failed to load font/i.test(m))) problems.push(`${path}: ${message}`);

      const hosts = (list: Seen[]) => [...new Set(list.map((s) => new URL(s.url).host))].sort();
      const outside = hosts(own.filter((s) => !onSite(s.url)));
      report.push(
        `${path}: ${own.length} requests by the page and its service worker, to ${outside.length ? outside.join(", ") : "the site only"}; ` +
          (embedded.length
            ? `${embedded.length} by the YouTube player it embeds${online ? `, to ${hosts(embedded).join(", ")}` : " (blocked)"}`
            : "no embedded player"),
      );
    }
  } finally {
    await browser.close();
  }
  return { problems, report };
}

if (import.meta.main) {
  const online = process.argv.includes("--online");
  const { site, stop } = await serve();
  let failed = false;
  try {
    const problems = await hostingProblems(site);
    if (problems.length) {
      failed = true;
      console.error(`Cloudflare (wrangler dev) doesn't serve build/web as expected:\n${problems.map((p) => `  - ${p}`).join("\n")}`);
    } else {
      console.log("Hosting: every file, the app's addresses and addresses that aren't files are served as expected.");
    }
    const requests = await requestProblems(site, online);
    for (const line of requests.report) console.log(`  ${line}`);
    if (requests.problems.length) {
      failed = true;
      console.error(`The pages load something they shouldn't:\n${requests.problems.map((p) => `  - ${p}`).join("\n")}`);
    } else {
      console.log("Requests: the pages and their service worker load only from the site.");
    }
  } finally {
    await stop();
  }
  if (failed) process.exit(1);
}
