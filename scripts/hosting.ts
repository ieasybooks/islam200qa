// What islam200qa.ieasybooks.com serves, as Cloudflare serves the build in
// build/web (wrangler.jsonc, web/_headers). scripts/test-hosting.ts checks it
// against wrangler dev, and scripts/check-live.ts against the site after each
// deploy. See docs/web-deployment.md.
//
// - Every file of the build answers at its address, byte for byte, without a
//   redirect, with its type and caching, and the headers web/_headers gives
//   every answer.
// - The app's addresses (/, /privacy, a question) answer with index.html.
// - So does an address that isn't a file, a missing asset's included, with a
//   200 as Netlify's /* /index.html 200 did: never cached, and labelled HTML,
//   which nosniff keeps a browser from running as a script or font.
import { createHash } from "node:crypto";
import { readdirSync, readFileSync } from "node:fs";
import { extname, join } from "node:path";

export const SITE = "https://islam200qa.ieasybooks.com";
export const ROOT = join(import.meta.dirname, "..");
export const BUILD = join(ROOT, "build/web");

// Cloudflare's own caching for static assets, which web/_headers keeps for
// every file without a hash in its name.
export const REVALIDATE = "public, max-age=0, must-revalidate";
export const IMMUTABLE = "public, max-age=31536000, immutable";

// What web/_headers' /* rule adds to every answer.
export const EVERY_ANSWER: Record<string, string> = {
  "x-content-type-options": "nosniff",
  "x-frame-options": "DENY",
  "referrer-policy": "strict-origin-when-cross-origin",
};

// Files Cloudflare reads instead of serving them.
const NOT_SERVED = new Set(["_headers", "_redirects", ".assetsignore"]);

const TYPES: Record<string, RegExp> = {
  ".html": /^text\/html/,
  ".js": /^(application|text)\/javascript/,
  ".json": /^application\/json/,
  ".wasm": /^application\/wasm/,
  ".png": /^image\/png/,
  ".ttf": /^font\/ttf/,
  ".otf": /^font\/otf/,
  ".woff2": /^font\/woff2/,
  ".css": /^text\/css/,
  ".txt": /^text\/plain/,
};

// The beacon the ieasybooks.com zone's Web Analytics adds to the live site's
// pages for browsers.
const BEACON = /<script[^>]*static\.cloudflareinsights\.com[^>]*><\/script>/g;

// The questions are /1 to /lastSection (lib/constants.dart).
export function lastSection(root = ROOT): number {
  const match = /const int lastSection = (\d+);/.exec(readFileSync(join(root, "lib/constants.dart"), "utf8"));
  if (!match) throw new Error("lib/constants.dart has no lastSection");
  return Number(match[1]);
}

// The app's own addresses (lib/router/routes.dart), the first and last
// questions among them, and one as a shared link opens it.
export function appAddresses(root = ROOT): string[] {
  return ["/", "/privacy", "/support", "/about", "/1", "/12?utm_source=share", `/${lastSection(root)}`];
}

// Addresses that aren't files: a page the app doesn't have, assets that don't
// exist, a font next to the one that's cached as immutable, and _headers.
export const NOT_FILES = [
  "/no-such-page",
  "/assets/assets/images/no-such-image.png",
  "/main.dart.js.map",
  "/canvaskit/no-such-file.wasm",
  "/fonts/roboto/v32/no-such-font.woff2",
  "/_headers",
];

// The build's files, as paths relative to it.
export function buildFiles(build = BUILD): string[] {
  return readdirSync(build, { recursive: true, withFileTypes: true })
    .filter((entry) => entry.isFile())
    .map((entry) => join(entry.parentPath, entry.name).slice(build.length + 1))
    .filter((file) => !NOT_SERVED.has(file))
    .sort();
}

// The paths web/_headers caches as immutable. Each names one file: a rule
// with * or a :placeholder would also match addresses that aren't files.
export function immutablePaths(headers: string): string[] {
  const paths: string[] = [];
  let path = "";
  for (const line of headers.split("\n")) {
    if (!line.trim() || line.trim().startsWith("#")) continue;
    if (!/^\s/.test(line)) path = line.trim();
    else if (/^\s*cache-control:.*immutable/i.test(line)) paths.push(path);
  }
  return paths;
}

const sha256 = (bytes: Uint8Array) => createHash("sha256").update(bytes).digest("hex");

type Fetch = (url: string, init?: RequestInit) => Promise<Response>;
const get = (fetchFn: Fetch, url: string) => fetchFn(url, { redirect: "manual", signal: AbortSignal.timeout(30_000) });

type Want = { bytes: Uint8Array; type?: RegExp; cache: string; html?: boolean };

// What's wrong with how site serves the build: each problem as a line.
export async function hostingProblems(site: string, build = BUILD, fetchFn: Fetch = fetch, root = ROOT): Promise<string[]> {
  const problems: string[] = [];
  const immutable = new Set(immutablePaths(readFileSync(join(build, "_headers"), "utf8")));
  const index = readFileSync(join(build, "index.html"));

  async function check(path: string, want: Want): Promise<void> {
    let response: Response;
    let bytes: Uint8Array;
    try {
      response = await get(fetchFn, site + path);
      bytes = new Uint8Array(await response.arrayBuffer());
    } catch (error) {
      problems.push(`${path}: ${(error as Error).message}`);
      return;
    }
    const header = (name: string) => response.headers.get(name) ?? "none";
    const wrong: string[] = [];
    if (response.status !== 200) {
      const to = response.headers.get("location");
      wrong.push(`HTTP ${response.status}${to ? ` to ${to}` : ""}, not 200`);
    } else {
      if (want.type && !want.type.test(header("content-type"))) wrong.push(`Content-Type ${header("content-type")}`);
      if (header("cache-control") !== want.cache) wrong.push(`Cache-Control ${header("cache-control")}`);
      for (const [name, value] of Object.entries(EVERY_ANSWER)) {
        if (header(name) !== value) wrong.push(`${name} ${header(name)}`);
      }
      const served = want.html ? Buffer.from(new TextDecoder().decode(bytes).replace(BEACON, "")) : bytes;
      if (sha256(served) !== sha256(want.bytes)) wrong.push(want.html && path !== "/" ? "not index.html" : "not this build's");
    }
    if (wrong.length) problems.push(`${path}: ${wrong.join(", ")}`);
  }

  const files = buildFiles(build);
  for (let i = 0; i < files.length; i += 8) {
    await Promise.all(
      files.slice(i, i + 8).map((file) => {
        const path = file === "index.html" ? "/" : `/${file}`;
        return check(path, {
          bytes: readFileSync(join(build, file)),
          type: TYPES[extname(file)],
          cache: immutable.has(path) ? IMMUTABLE : REVALIDATE,
          html: file === "index.html",
        });
      }),
    );
  }
  for (const path of immutable) {
    if (!files.includes(path.slice(1))) problems.push(`web/_headers caches ${path} as immutable, which isn't a file of the build`);
  }
  for (const path of [...appAddresses(root), ...NOT_FILES]) {
    await check(path, { bytes: index, type: TYPES[".html"], cache: REVALIDATE, html: true });
  }
  return problems;
}
