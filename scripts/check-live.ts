// Checks that islam200qa.ieasybooks.com serves the build in build/web. The web
// workflow runs it after each deploy, and for a commit that's already live;
// run it after deploying by hand too.
//
//   bun scripts/check-live.ts [https://islam200qa.ieasybooks.com]
//
// - The service worker is this build's. It lists every file with its hash, so
//   it differs whenever any file does. A deploy takes a few seconds to reach
//   every location, so while it's another build's, it asks again every 10
//   seconds, for up to two minutes.
// - Then everything scripts/hosting.ts expects: every file byte for byte, with
//   its type and caching, the app's addresses and addresses that aren't files.
//   While anything is off, it asks again every 10 seconds, for up to two
//   minutes.
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { BUILD, ROOT, SITE, buildFiles, hostingProblems } from "./hosting.ts";

export class LiveError extends Error {}

type Fetch = (url: string, init?: RequestInit) => Promise<Response>;

const wait = (ms: number) => new Promise<void>((done) => setTimeout(done, ms));

// Waits until the site serves the build's service worker.
export async function waitForBuild(site: string, build = BUILD, fetchFn: Fetch = fetch, sleep = wait, attempts = 12): Promise<void> {
  const expected = readFileSync(join(build, "flutter_service_worker.js"), "utf8");
  let served = "";
  for (let attempt = 1; ; attempt++) {
    try {
      const response = await fetchFn(`${site}/flutter_service_worker.js?release-check=${Date.now()}`, {
        redirect: "manual",
        signal: AbortSignal.timeout(30_000),
      });
      const body = await response.text();
      if (response.status === 200 && body === expected) return;
      served = response.status === 200 ? "another build's service worker" : `HTTP ${response.status}`;
    } catch (error) {
      served = (error as Error).message;
    }
    if (attempt === attempts) {
      throw new LiveError(`${site} still serves another build after ${attempts} tries: /flutter_service_worker.js is ${served}.`);
    }
    await sleep(10_000);
  }
}

// Waits for the build, then checks the rest until it's right; throws what's
// still wrong after the last try. Returns the number of files checked.
export async function checkLive(site: string, build = BUILD, fetchFn: Fetch = fetch, sleep = wait, attempts = 12, root = ROOT): Promise<number> {
  await waitForBuild(site, build, fetchFn, sleep, attempts);
  for (let attempt = 1; ; attempt++) {
    const problems = await hostingProblems(site, build, fetchFn, root);
    if (!problems.length) return buildFiles(build).length;
    if (attempt === attempts) {
      throw new LiveError(
        `${site} serves this build's service worker, but after ${attempts} tries:\n${problems.map((p) => `  - ${p}`).join("\n")}`,
      );
    }
    await sleep(10_000);
  }
}

if (import.meta.main) {
  const site = (process.argv[2] ?? SITE).replace(/\/+$/, "");
  try {
    const files = await checkLive(site);
    console.log(`${site} serves this build: its ${files} files, the app's addresses, and index.html for addresses that aren't files.`);
  } catch (error) {
    if (!(error instanceof LiveError)) throw error;
    console.error(error.message);
    process.exit(1);
  }
}
