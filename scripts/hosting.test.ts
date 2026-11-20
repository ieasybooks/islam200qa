import { afterAll, describe, expect, it } from "bun:test";
import { checkLive, LiveError, waitForBuild } from "./check-live.ts";
import { cloudflare, fakeBuild, FILES, FONT, HEADERS, SITE, removeFakeBuilds } from "./fake-site.ts";
import { appAddresses, buildFiles, hostingProblems, immutablePaths, lastSection, REVALIDATE } from "./hosting.ts";

afterAll(removeFakeBuilds);

describe("immutablePaths", () => {
  it("lists the rules that cache as immutable, and only those", () => {
    expect(immutablePaths(HEADERS)).toEqual([`/fonts/${FONT}`]);
    expect(immutablePaths("/*\n  X-Frame-Options: DENY\n/a.js\n  cache-control: public, immutable\n# /b.js\n")).toEqual(["/a.js"]);
  });
});

describe("the app's addresses", () => {
  it("run from / to the last question in lib/constants.dart", () => {
    const { root } = fakeBuild();
    expect(lastSection(root)).toBe(3);
    expect(appAddresses(root)).toEqual(["/", "/privacy", "/support", "/about", "/1", "/12?utm_source=share", "/3"]);
  });

  it("match the repository's", () => {
    expect(lastSection()).toBe(212);
  });
});

describe("hostingProblems", () => {
  it("finds nothing wrong with the build as Cloudflare serves it", async () => {
    const { root, build } = fakeBuild();
    const { fetchFn, asked } = cloudflare(build);
    expect(await hostingProblems(SITE, build, fetchFn, root)).toEqual([]);
    // Every file but _headers, which Cloudflare reads instead of serving.
    expect(buildFiles(build)).not.toContain("_headers");
    for (const file of buildFiles(build)) {
      expect(asked).toContain(file === "index.html" ? `${SITE}/` : `${SITE}/${file}`);
    }
    expect(asked).toContain(`${SITE}/no-such-page`);
    expect(asked).toContain(`${SITE}/_headers`);
  });

  it("takes the live site's analytics beacon in index.html", async () => {
    const { root, build } = fakeBuild();
    const beacon = `<script defer src='https://static.cloudflareinsights.com/beacon.min.js' data-cf-beacon='{"token": "x"}'></script>`;
    const page = FILES["index.html"]!.replace("</body>", `${beacon}</body>`);
    const html = { "content-type": "text/html; charset=utf-8", "cache-control": REVALIDATE, "x-content-type-options": "nosniff", "x-frame-options": "DENY", "referrer-policy": "strict-origin-when-cross-origin" };
    const { fetchFn } = cloudflare(build, { "/": { status: 200, body: page, headers: html }, "/privacy": { status: 200, body: page, headers: html } });
    expect(await hostingProblems(SITE, build, fetchFn, root)).toEqual([]);
  });

  it("reports a file that's missing, redirected, mistyped or cached otherwise", async () => {
    const { root, build } = fakeBuild();
    const { fetchFn } = cloudflare(build, {
      "/main.dart.js": { status: 200, body: "old", headers: { "content-type": "text/javascript", "cache-control": REVALIDATE } },
      "/canvaskit/canvaskit.wasm": { status: 307, headers: { location: "/canvaskit/" } },
      [`/fonts/${FONT}`]: { status: 200, body: "font", headers: { "content-type": "font/woff2", "cache-control": REVALIDATE } },
      "/assets/data/sections/1.txt": new Error("The operation timed out."),
      "/no-such-page": { status: 404, body: "", headers: {} },
    });
    const problems = await hostingProblems(SITE, build, fetchFn, root);
    expect(problems).toEqual(
      expect.arrayContaining([
        expect.stringMatching(/^\/main\.dart\.js: .*not this build's/),
        "/canvaskit/canvaskit.wasm: HTTP 307 to /canvaskit/, not 200",
        expect.stringMatching(new RegExp(`^/fonts/${FONT}: Cache-Control public, max-age=0, must-revalidate`)),
        "/assets/data/sections/1.txt: The operation timed out.",
        "/no-such-page: HTTP 404, not 200",
      ]),
    );
    expect(problems.find((p) => p.startsWith("/main.dart.js"))).toContain("x-frame-options none");
  });

  it("reports an immutable rule for an address that isn't a file", async () => {
    const { root, build } = fakeBuild({ _headers: `${HEADERS}\n/fonts/roboto/v32/gone.woff2\n  Cache-Control: public, max-age=31536000, immutable\n` });
    const problems = await hostingProblems(SITE, build, cloudflare(build).fetchFn, root);
    expect(problems).toContain("web/_headers caches /fonts/roboto/v32/gone.woff2 as immutable, which isn't a file of the build");
  });
});

describe("check-live", () => {
  const noWait = async () => {};

  it("waits for the build's service worker, then checks the site", async () => {
    const { root, build } = fakeBuild();
    let deployed = false;
    const { fetchFn } = cloudflare(build);
    const old = { status: 200, body: "const RESOURCES = {};" };
    const switching = async (url: string) => {
      if (url.includes("/flutter_service_worker.js") && !deployed) {
        deployed = true;
        return new Response(old.body, { status: old.status });
      }
      return fetchFn(url);
    };
    expect(await checkLive(SITE, build, switching, noWait, 3, root)).toBe(buildFiles(build).length);
  });

  it("gives up after its tries, saying what it found", async () => {
    const { build } = fakeBuild();
    const stale = async () => new Response("const RESOURCES = {};", { status: 200 });
    const waiting = waitForBuild(SITE, build, stale, noWait, 2);
    await expect(waiting).rejects.toThrow(LiveError);
    await expect(waiting).rejects.toThrow(`${SITE} still serves another build after 2 tries: /flutter_service_worker.js is another build's service worker.`);
  });

  it("reports what's still wrong once the build is live", async () => {
    const { root, build } = fakeBuild();
    const { fetchFn } = cloudflare(build, { "/privacy": { status: 404 } });
    await expect(checkLive(SITE, build, fetchFn, noWait, 2, root)).rejects.toThrow("/privacy: HTTP 404, not 200");
  });
});
