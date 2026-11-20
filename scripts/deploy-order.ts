// Decides whether a commit may deploy to islam200qa.ieasybooks.com, against
// the commit that's live: each deploy records its commit as its Worker
// version's message (`wrangler deploy --message <sha>`), so the site only
// moves forward along main. The web workflow runs it while it holds the
// production deploy group, so no other deploy can go live between this read
// and its deploy.
//
//   bun scripts/deploy-order.ts <sha>    (in GitHub Actions: GH_TOKEN, CLOUDFLARE_API_TOKEN)
//
// It prints why, and writes action=deploy|recheck|skip to $GITHUB_OUTPUT:
//
//   ahead of the live commit   deploy
//   the live commit            recheck: skip the upload, check the site again
//   behind it                  skip: a newer commit is live
//   diverged, or no record     fail
import { spawnSync } from "node:child_process";
import { appendFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT } from "./hosting.ts";

export type Action = "deploy" | "recheck" | "skip";
export type Run = (command: string, args: string[]) => string;

export class OrderError extends Error {}

const SHA = /^[0-9a-f]{40}$/;

// The commit of the version serving all of the site's traffic.
export function liveCommit(run: Run): string {
  const status = JSON.parse(run("wrangler", ["deployments", "status", "--json"])) as {
    versions?: { version_id: string; percentage: number }[];
  };
  const versions = status.versions ?? [];
  if (versions.length !== 1 || versions[0]!.percentage !== 100) {
    throw new OrderError(
      `the site isn't one version at 100% (${JSON.stringify(versions)}); finish or roll back that deployment by hand first`,
    );
  }
  const version = JSON.parse(run("wrangler", ["versions", "view", versions[0]!.version_id, "--json"])) as {
    annotations?: Record<string, string>;
  };
  const message = version.annotations?.["workers/message"] ?? "";
  if (!SHA.test(message)) {
    throw new OrderError(
      `the live version ${versions[0]!.version_id} doesn't record its commit (message ${JSON.stringify(message)}); deploy one by hand with --message <sha> first`,
    );
  }
  return message;
}

export function decide(sha: string, live: string, compareStatus: string): Action {
  // GitHub's compare base...head: head (the candidate) relative to base (live).
  switch (compareStatus) {
    case "ahead":
      return "deploy";
    case "identical":
      return "recheck";
    case "behind":
      return "skip";
    case "diverged":
      throw new OrderError(`${sha} and the live ${live} have diverged: neither is on the other's history`);
    default:
      throw new OrderError(`GitHub compared ${live}...${sha} as ${JSON.stringify(compareStatus)}`);
  }
}

export function order(sha: string, repo: string, run: Run): { action: Action; why: string } {
  if (!SHA.test(sha)) throw new OrderError(`${JSON.stringify(sha)} isn't a full commit SHA`);
  const live = liveCommit(run);
  const status = run("gh", ["api", `repos/${repo}/compare/${live}...${sha}`, "--jq", ".status"]).trim();
  const action = decide(sha, live, status);
  const why = {
    deploy: `${sha} is ahead of the live ${live}: deploying it`,
    recheck: `${sha} is already live: checking the site again`,
    skip: `${sha} is behind the live ${live}, a newer commit: not deploying it`,
  }[action];
  return { action, why };
}

// Wrangler as the repository installed it, with wrangler.jsonc's Worker.
function run(command: string, args: string[]): string {
  const wrangler = command === "wrangler";
  const result = spawnSync(wrangler ? join(ROOT, "node_modules/.bin/wrangler") : command, args, {
    encoding: "utf8",
    cwd: ROOT,
  });
  if (result.status !== 0) {
    const detail = (result.stderr || result.stdout || String(result.error)).trim().split("\n").slice(-3).join(" ");
    throw new OrderError(`${command} ${args.slice(0, 2).join(" ")} failed: ${detail}`);
  }
  return result.stdout;
}

if (import.meta.main) {
  const [sha] = process.argv.slice(2);
  try {
    const { action, why } = order(sha ?? "", process.env.GITHUB_REPOSITORY ?? "ieasybooks/islam200qa", run);
    console.log(why);
    if (process.env.GITHUB_OUTPUT) appendFileSync(process.env.GITHUB_OUTPUT, `action=${action}\n`);
  } catch (error) {
    if (!(error instanceof OrderError)) throw error;
    console.error(`::error::${error.message}`);
    process.exit(1);
  }
}
