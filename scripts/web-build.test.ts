import { afterAll, describe, expect, it } from "bun:test";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { fakeBuild, FILES, FONT, HEADERS, removeFakeBuilds } from "./fake-site.ts";
import { ROOT } from "./hosting.ts";
import { buildProblems, FLUTTER_BUILD } from "./web-build.ts";

afterAll(removeFakeBuilds);

describe("buildProblems", () => {
  it("passes a build that serves CanvasKit and Roboto itself", () => {
    expect(buildProblems(fakeBuild().build)).toEqual([]);
  });

  it("refuses Netlify's _redirects, which Cloudflare would apply before every file", () => {
    const { build } = fakeBuild({ _redirects: "/*    /index.html    200" });
    expect(buildProblems(build)).toEqual([expect.stringContaining("_redirects: Cloudflare would apply it before serving any file")]);
  });

  it("refuses a build that would load CanvasKit or fonts from Google", () => {
    const cdn = FILES["flutter_bootstrap.js"]!.replace('"useLocalCanvasKit":true', '"useLocalCanvasKit":false');
    expect(buildProblems(fakeBuild({ "flutter_bootstrap.js": cdn }).build)).toEqual([
      expect.stringContaining("CanvasKit would load from www.gstatic.com"),
    ]);
    const noLocal = FILES["flutter_bootstrap.js"]!.replace(',"useLocalCanvasKit":true', "");
    expect(buildProblems(fakeBuild({ "flutter_bootstrap.js": noLocal, "canvaskit/canvaskit.wasm": null }).build)).toEqual([
      expect.stringContaining("CanvasKit would load from www.gstatic.com"),
      "canvaskit/canvaskit.wasm: missing; build with --no-web-resources-cdn",
    ]);
    const gstatic = FILES["flutter_bootstrap.js"]!.replace('config: { fontFallbackBaseUrl: "fonts/" }', "");
    expect(buildProblems(fakeBuild({ "flutter_bootstrap.js": gstatic }).build)).toEqual([
      expect.stringContaining("fonts would load from fonts.gstatic.com"),
    ]);
  });

  it("refuses the legacy loader, which ignores flutter_bootstrap.js's settings", () => {
    const legacy = '<script src="flutter.js" defer></script><script>_flutter.loader.loadEntrypoint({})</script>';
    expect(buildProblems(fakeBuild({ "index.html": legacy }).build)).toEqual([
      expect.stringContaining("index.html: load the app with flutter_bootstrap.js"),
    ]);
  });

  it("needs the Roboto the engine asks for, cached as immutable", () => {
    const upgraded = "roboto/v33/NEWFILE.woff2";
    expect(buildProblems(fakeBuild({ "main.dart.js": `var b="${upgraded}";` }).build)).toEqual([
      expect.stringContaining(`fonts/${upgraded}: this engine loads Roboto from here; put https://fonts.gstatic.com/s/${upgraded} at web/fonts/${upgraded}`),
    ]);
    const uncached = "/*\n  X-Content-Type-Options: nosniff\n";
    expect(buildProblems(fakeBuild({ _headers: uncached }).build)).toEqual([
      `web/_headers: cache /fonts/${FONT} as immutable, as fonts.gstatic.com does`,
    ]);
    expect(buildProblems(fakeBuild({ "main.dart.js": "" }).build)).toEqual([expect.stringContaining("main.dart.js names no Roboto font")]);
  });

  it("refuses an immutable rule that matches more than one file", () => {
    const wildcard = `${HEADERS}\n/canvaskit/*\n  Cache-Control: public, max-age=31536000, immutable\n`;
    expect(buildProblems(fakeBuild({ _headers: wildcard }).build)).toEqual([
      "web/_headers: /canvaskit/* caches every address it matches as immutable; name each file instead",
    ]);
  });
});

describe("the repository's web shell", () => {
  it("builds with CanvasKit from the site", () => {
    expect(FLUTTER_BUILD).toEqual(["build", "web", "--release", "--no-web-resources-cdn"]);
  });

  it("has no Netlify redirects, and the Roboto its _headers caches", () => {
    const headers = readFileSync(join(ROOT, "web/_headers"), "utf8");
    expect(headers).toContain(`/fonts/${FONT}\n  Cache-Control: public, max-age=31536000, immutable`);
    expect(() => readFileSync(join(ROOT, "web/_redirects"))).toThrow();
    expect(readFileSync(join(ROOT, `web/fonts/${FONT}`)).length).toBeGreaterThan(0);
  });
});
