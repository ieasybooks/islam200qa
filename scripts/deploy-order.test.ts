import { describe, expect, it } from "bun:test";
import { decide, liveCommit, order, OrderError, type Run } from "./deploy-order.ts";

const LIVE = "535cc9f980a73b85763a087ecf2efb0a50149999";
const NEXT = "0c9e2f7aa1b2c3d4e5f60718293a4b5c6d7e8f90";
const VERSION = "c8e205e8-c070-4576-a42c-68498d6009ea";

// Wrangler's and GitHub's answers, as these commands give them.
function stand(
  // message: null for a version without one.
  { versions = [{ version_id: VERSION, percentage: 100 }], message = LIVE as string | null, compare = "ahead" } = {},
) {
  const calls: string[] = [];
  const run: Run = (command, args) => {
    calls.push(`${command} ${args.join(" ")}`);
    if (command === "wrangler" && args[0] === "deployments") return JSON.stringify({ versions, source: "wrangler" });
    if (command === "wrangler" && args[0] === "versions") {
      return JSON.stringify({
        id: args[2],
        annotations: message === null ? {} : { "workers/message": message, "workers/tag": LIVE.slice(0, 12) },
      });
    }
    if (command === "gh") return `${compare}\n`;
    throw new Error(`unexpected ${command} ${args.join(" ")}`);
  };
  return { run, calls };
}

describe("order", () => {
  it("deploys a commit ahead of the live one", () => {
    const { run, calls } = stand();
    expect(order(NEXT, "ieasybooks/islam200qa", run)).toEqual({
      action: "deploy",
      why: `${NEXT} is ahead of the live ${LIVE}: deploying it`,
    });
    expect(calls).toEqual([
      "wrangler deployments status --json",
      `wrangler versions view ${VERSION} --json`,
      `gh api repos/ieasybooks/islam200qa/compare/${LIVE}...${NEXT} --jq .status`,
    ]);
  });

  it("only checks the site again for the live commit", () => {
    expect(order(LIVE, "ieasybooks/islam200qa", stand({ compare: "identical" }).run).action).toBe("recheck");
  });

  it("skips a commit behind the live one", () => {
    expect(order(NEXT, "ieasybooks/islam200qa", stand({ compare: "behind" }).run)).toEqual({
      action: "skip",
      why: `${NEXT} is behind the live ${LIVE}, a newer commit: not deploying it`,
    });
  });

  it("stops on diverged history or an answer it doesn't know", () => {
    expect(() => order(NEXT, "r", stand({ compare: "diverged" }).run)).toThrow(`${NEXT} and the live ${LIVE} have diverged`);
    expect(() => order(NEXT, "r", stand({ compare: "" }).run)).toThrow(OrderError);
  });

  it("refuses a candidate that isn't a full SHA, before asking anything", () => {
    const { run, calls } = stand();
    for (const sha of ["", "main", NEXT.slice(0, 12), NEXT.toUpperCase()]) {
      expect(() => order(sha, "r", run)).toThrow("isn't a full commit SHA");
    }
    expect(calls).toEqual([]);
  });
});

describe("liveCommit", () => {
  it("reads the commit recorded on the version serving everything", () => {
    expect(liveCommit(stand().run)).toBe(LIVE);
  });

  it("stops while the site is split between versions, or not all on one", () => {
    const split = [
      { version_id: VERSION, percentage: 90 },
      { version_id: "other", percentage: 10 },
    ];
    expect(() => liveCommit(stand({ versions: split }).run)).toThrow("the site isn't one version at 100%");
    expect(() => liveCommit(stand({ versions: [{ version_id: VERSION, percentage: 50 }] }).run)).toThrow("isn't one version at 100%");
    expect(() => liveCommit(stand({ versions: [] }).run)).toThrow("isn't one version at 100%");
  });

  it("stops when the live version doesn't record a commit", () => {
    for (const message of [null, "", "a hand deploy", LIVE.slice(0, 12)]) {
      expect(() => liveCommit(stand({ message }).run)).toThrow("doesn't record its commit");
    }
  });
});

describe("decide", () => {
  it("maps GitHub's comparison of the candidate to the live commit", () => {
    expect(decide(NEXT, LIVE, "ahead")).toBe("deploy");
    expect(decide(LIVE, LIVE, "identical")).toBe("recheck");
    expect(decide(NEXT, LIVE, "behind")).toBe("skip");
  });
});
