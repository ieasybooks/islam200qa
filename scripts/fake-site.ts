// A small build/web and Cloudflare serving it, for the unit tests.
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, extname, join } from "node:path";
import { EVERY_ANSWER, IMMUTABLE, REVALIDATE, immutablePaths } from "./hosting.ts";

export const SITE = "https://islam200qa.ieasybooks.com";
export const FONT = "roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2";

export const HEADERS = `# Comment
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Referrer-Policy: strict-origin-when-cross-origin

/fonts/${FONT}
  Cache-Control: public, max-age=31536000, immutable
`;

export const FILES: Record<string, string> = {
  "index.html": '<!DOCTYPE html><html><body><script src="flutter_bootstrap.js" async></script></body></html>',
  "flutter_bootstrap.js": `_flutter.buildConfig = {"engineRevision":"abc","builds":[{"compileTarget":"dart2js","renderer":"canvaskit","mainJsPath":"main.dart.js"},{}],"useLocalCanvasKit":true};\n_flutter.loader.load({ config: { fontFallbackBaseUrl: "fonts/" } });\n`,
  "flutter_service_worker.js": 'const RESOURCES = {"main.dart.js": "0123"};',
  "main.dart.js": `var a="https://fonts.gstatic.com/s/",b=a+"${FONT}";`,
  "canvaskit/canvaskit.js": "",
  "canvaskit/canvaskit.wasm": "wasm",
  "canvaskit/chromium/canvaskit.js": "",
  "canvaskit/chromium/canvaskit.wasm": "wasm",
  [`fonts/${FONT}`]: "font",
  "assets/data/sections/1.txt": "المقدمة",
  _headers: HEADERS,
};

const scratch = join(tmpdir(), `islam200qa-web-${process.pid}`);

// Removes every fake build; each test file calls it after its tests.
export const removeFakeBuilds = () => rmSync(scratch, { recursive: true, force: true });

// A build/web with files (null leaves one out), in a new folder, and a
// repository root around it whose lib/constants.dart has three questions.
export function fakeBuild(files: Record<string, string | null> = {}): { root: string; build: string } {
  mkdirSync(scratch, { recursive: true });
  const root = mkdtempSync(join(scratch, "root-"));
  const build = join(root, "build/web");
  mkdirSync(join(root, "lib"), { recursive: true });
  writeFileSync(join(root, "lib/constants.dart"), "const int lastSection = 3;\n");
  for (const [path, text] of Object.entries({ ...FILES, ...files })) {
    if (text === null) continue;
    mkdirSync(dirname(join(build, path)), { recursive: true });
    writeFileSync(join(build, path), text);
  }
  return { root, build };
}

const TYPES: Record<string, string> = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".wasm": "application/wasm",
  ".woff2": "font/woff2",
  ".txt": "text/plain; charset=utf-8",
};

export type Answer = { status: number; body?: string; headers?: Record<string, string> };

// The site as Cloudflare serves build (wrangler.jsonc): its files, and
// index.html for any other address. answers replace what a path gets.
export function cloudflare(build: string, answers: Record<string, Answer | Error> = {}) {
  const asked: string[] = [];
  const immutable = new Set(immutablePaths(readFileSync(join(build, "_headers"), "utf8")));
  const fetchFn = async (url: string) => {
    asked.push(url);
    const { pathname } = new URL(url);
    const answer = answers[pathname];
    if (answer instanceof Error) throw answer;
    if (answer) return new Response(answer.body ?? "", { status: answer.status, headers: answer.headers });
    if (pathname === "/index.html") return new Response(null, { status: 307, headers: { location: "/" } });
    const file = pathname === "/" ? "index.html" : pathname.slice(1);
    const served = file !== "_headers" && existsSync(join(build, file)) ? file : "index.html";
    return new Response(readFileSync(join(build, served)), {
      status: 200,
      headers: {
        "content-type": TYPES[extname(served)] ?? "application/octet-stream",
        // _headers' rules match the address, whatever answers it.
        "cache-control": immutable.has(pathname) ? IMMUTABLE : REVALIDATE,
        ...EVERY_ANSWER,
      },
    });
  };
  return { fetchFn, asked };
}
