// Creates the islam200qa-web Worker, once, before Terraform can give it a
// deploy token: Cloudflare's Individual Workers Editor names Workers that
// exist. workers.dev and preview URLs stay off, and the Worker has no public
// address until Terraform adds islam200qa.ieasybooks.com. From an
// ieasybooks/infrastructure checkout next to this one, with this checkout
// clean on the website deployment branch (docs/web-deployment.md, One-time
// setup):
//
//   mise run vault:run INFRASTRUCTURE_CLOUDFLARE_API_TOKEN=CLOUDFLARE_API_TOKEN -- \
//     mise -C ../islam200qa exec -- bun scripts/web-bootstrap.ts
//
// It checks that the Worker doesn't exist, then builds main's newest commit in
// a temporary checkout, with this checkout's website files (WEB_FILES: the web
// shell, Wrangler and these scripts), which main doesn't have yet, checks the
// build as Cloudflare serves it, and deploys it with that commit as its
// version's message. The deploy workflow's first run then finds a commit to
// compare with (scripts/deploy-order.ts).
import { execFileSync, spawnSync } from "node:child_process";
import { cpSync, mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { ROOT } from "./hosting.ts";

const ACCOUNT = "aaed7434338705aa46de5e4e3575e02b";
const WORKER = "islam200qa-web";
const API = `https://api.cloudflare.com/client/v4/accounts/${ACCOUNT}/workers/scripts/${WORKER}`;

// What main needs from this checkout to build and deploy as the workflow does.
export const WEB_FILES = ["package.json", "bun.lock", "wrangler.jsonc", "scripts", "web"];

const git = (...args: string[]) => execFileSync("git", args, { cwd: ROOT, encoding: "utf8" }).trim();

const token = process.env.CLOUDFLARE_API_TOKEN;
if (!token) throw new Error("Run it through the infrastructure vault (vault:run), which supplies CLOUDFLARE_API_TOKEN");
const cloudflare = (path = "") =>
  fetch(API + path, { headers: { Authorization: `Bearer ${token}` }, signal: AbortSignal.timeout(30_000) });

git("diff", "--exit-code");
git("diff", "--cached", "--exit-code");
git("fetch", "origin", "main");
const commit = git("rev-parse", "origin/main");

const existing = await cloudflare("/settings");
if (existing.status !== 404) {
  throw new Error(
    existing.ok
      ? `${WORKER} already exists; the web workflow deploys it`
      : `Couldn't check that ${WORKER} doesn't exist (HTTP ${existing.status})`,
  );
}

const temporary = mkdtempSync(join(tmpdir(), "islam200qa-bootstrap-"));
try {
  const checkout = join(temporary, "source");
  execFileSync("git", ["clone", "--shared", "--no-checkout", ROOT, checkout], { stdio: "inherit" });
  execFileSync("git", ["checkout", "--detach", commit], { cwd: checkout, stdio: "inherit" });
  for (const path of WEB_FILES) {
    rmSync(join(checkout, path), { recursive: true, force: true });
    cpSync(join(ROOT, path), join(checkout, path), { recursive: true });
  }

  // Installing and building don't need the token.
  const env: Record<string, string | undefined> = { ...process.env, WRANGLER_SEND_METRICS: "false" };
  delete env.CLOUDFLARE_API_TOKEN;
  const run = (command: string, args: string[]) => execFileSync(command, args, { cwd: checkout, stdio: "inherit", env });
  run(process.execPath, ["install", "--frozen-lockfile"]);
  run("./node_modules/.bin/playwright", ["install", "--only-shell", "chromium"]);
  run("flutter", ["pub", "get", "--enforce-lockfile"]);
  run(process.execPath, ["scripts/web-build.ts"]);
  run(process.execPath, ["scripts/test-hosting.ts"]);

  console.log(`Creating ${WORKER} with main's ${commit}`);
  // A new Worker can take a moment to appear in Cloudflare's settings API
  // after its assets are uploaded; deploying the same build again is safe.
  for (let attempt = 1; ; attempt++) {
    const deploy = spawnSync(
      "./node_modules/.bin/wrangler",
      ["deploy", "--message", commit, "--tag", commit.slice(0, 12)],
      { cwd: checkout, stdio: "inherit", env: { ...process.env, WRANGLER_SEND_METRICS: "false" } },
    );
    if (deploy.error) throw deploy.error;
    if (deploy.status === 0) break;
    if (attempt === 3) throw new Error("The first deploy failed");
    await new Promise((done) => setTimeout(done, 2_000));
  }
} finally {
  rmSync(temporary, { recursive: true, force: true });
}

// wrangler.jsonc keeps workers.dev and preview URLs off; check Cloudflare agrees.
const subdomain = (await (await cloudflare("/subdomain")).json()) as { result?: { enabled?: boolean; previews_enabled?: boolean } };
if (subdomain.result?.enabled !== false || subdomain.result?.previews_enabled !== false) {
  throw new Error(`${WORKER} answers on workers.dev or preview URLs: ${JSON.stringify(subdomain.result)}`);
}
console.log(`${WORKER} is created, without a public address. Apply Terraform and copy its deploy token into the vault (docs/web-deployment.md).`);
