// Builds the website as it deploys, into build/web, then checks it:
//
//   bun scripts/web-build.ts             (bun run web:build)
//   bun scripts/web-build.ts --no-build  (only the checks, on build/web as it is)
//
// Nothing the site needs to start comes from Google's servers:
// --no-web-resources-cdn serves CanvasKit from canvaskit/ instead of
// www.gstatic.com, and web/flutter_bootstrap.js sends the engine's font
// downloads to fonts/ instead of fonts.gstatic.com. CanvasKit always loads
// Roboto, so web/fonts has the one this engine asks for. The checks fail the
// build if either would reach Google again (after a Flutter upgrade, say), or
// if Cloudflare would serve it otherwise than the hosting tests expect. See
// docs/web-deployment.md.
import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";
import { BUILD, ROOT, buildFiles, immutablePaths } from "./hosting.ts";

export const FLUTTER_BUILD = ["build", "web", "--release", "--no-web-resources-cdn"];

// Workers Static Assets' limits.
const MAX_FILE_BYTES = 25 * 1024 * 1024;
const MAX_FILES = 20_000;
const MAX_HEADER_RULES = 100;

const CANVASKIT = ["canvaskit/canvaskit.js", "canvaskit/canvaskit.wasm", "canvaskit/chromium/canvaskit.js", "canvaskit/chromium/canvaskit.wasm"];

// What's wrong with build/web for deploying it: each problem as a line.
export function buildProblems(build = BUILD): string[] {
  const problems: string[] = [];
  const read = (file: string) => readFileSync(join(build, file), "utf8");
  const files = buildFiles(build);

  // Cloudflare applies _redirects before serving files: Netlify's
  // /* /index.html 200 would answer every file with index.html.
  if (existsSync(join(build, "_redirects"))) {
    problems.push("_redirects: Cloudflare would apply it before serving any file; wrangler.jsonc's not_found_handling serves the app's addresses");
  }

  const index = read("index.html");
  if (!index.includes('src="flutter_bootstrap.js"') || index.includes("loadEntrypoint")) {
    problems.push("index.html: load the app with flutter_bootstrap.js (web/flutter_bootstrap.js), which configures the engine, not with flutter.js's loadEntrypoint");
  }
  const bootstrap = read("flutter_bootstrap.js");
  const config = /_flutter\.buildConfig = (\{.*?\});/.exec(bootstrap)?.[1];
  let local = false;
  try {
    local = config !== undefined && (JSON.parse(config) as { useLocalCanvasKit?: boolean }).useLocalCanvasKit === true;
  } catch {}
  if (!local) problems.push("flutter_bootstrap.js: CanvasKit would load from www.gstatic.com; build with --no-web-resources-cdn");
  if (!/fontFallbackBaseUrl:\s*"fonts\/"/.test(bootstrap)) {
    problems.push('flutter_bootstrap.js: fonts would load from fonts.gstatic.com; web/flutter_bootstrap.js must pass config.fontFallbackBaseUrl "fonts/"');
  }
  for (const file of CANVASKIT) {
    if (!files.includes(file)) problems.push(`${file}: missing; build with --no-web-resources-cdn`);
  }

  // The fonts the engine downloads by itself: Roboto, its default, always.
  const headers = read("_headers");
  const immutable = immutablePaths(headers);
  const fonts = [...new Set(read("main.dart.js").match(/roboto\/v\d+\/[A-Za-z0-9_-]+\.woff2/g) ?? [])];
  if (!fonts.length) problems.push("main.dart.js names no Roboto font to check: see how this Flutter's engine loads its default font");
  for (const font of fonts) {
    if (!files.includes(`fonts/${font}`)) {
      problems.push(`fonts/${font}: this engine loads Roboto from here; put https://fonts.gstatic.com/s/${font} at web/fonts/${font}, and cache it as immutable in web/_headers (docs/web-deployment.md)`);
    } else if (!immutable.includes(`/fonts/${font}`)) {
      problems.push(`web/_headers: cache /fonts/${font} as immutable, as fonts.gstatic.com does`);
    }
  }

  // An immutable rule names one file: one with * or a :placeholder would
  // also mark index.html immutable, answering an address that isn't a file.
  for (const path of immutable) {
    if (/[*:]/.test(path)) problems.push(`web/_headers: ${path} caches every address it matches as immutable; name each file instead`);
    else if (!files.includes(path.slice(1))) problems.push(`web/_headers: ${path} is cached as immutable, but isn't a file of the build`);
  }
  const rules = headers.split("\n").filter((line) => line.trim() && !line.startsWith("#") && !/^\s/.test(line)).length;
  if (rules > MAX_HEADER_RULES) problems.push(`web/_headers: ${rules} rules, more than Cloudflare's ${MAX_HEADER_RULES}`);

  for (const file of files) {
    const bytes = statSync(join(build, file)).size;
    if (bytes > MAX_FILE_BYTES) problems.push(`${file}: ${bytes} bytes, over Cloudflare's 25 MiB for a file`);
  }
  if (files.length > MAX_FILES) problems.push(`${files.length} files, over Cloudflare's ${MAX_FILES}`);
  return problems;
}

if (import.meta.main) {
  if (!process.argv.includes("--no-build")) {
    console.log(`flutter ${FLUTTER_BUILD.join(" ")}`);
    const flutter = spawnSync("flutter", FLUTTER_BUILD, { cwd: ROOT, stdio: "inherit" });
    if (flutter.error) throw flutter.error;
    if (flutter.status !== 0) process.exit(flutter.status ?? 1);
  }
  const problems = buildProblems();
  if (problems.length) {
    console.error(`build/web isn't ready to deploy:\n${problems.map((problem) => `  - ${problem}`).join("\n")}`);
    process.exit(1);
  }
  console.log(`build/web is ready to deploy: ${buildFiles().length} files, with CanvasKit and Roboto served from the site.`);
}
