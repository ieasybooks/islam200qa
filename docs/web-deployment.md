# Web deployment

islam200qa.ieasybooks.com is the app's Flutter web build, served by the static assets of the `islam200qa-web` Worker (`wrangler.jsonc`), which has no script. [ieasybooks/infrastructure](https://github.com/ieasybooks/infrastructure) owns the `ieasybooks.com` zone, the Worker's custom domain, its deploy token and the vault's rules ("Islam in 200 Q&A website" in its README); this repository owns the Worker's assets, its Wrangler settings and its deploys. Netlify hosted the site before.

## The build

`bun run web:build` (`scripts/web-build.ts`) runs `flutter build web --release --no-web-resources-cdn` into `build/web`, then checks it. Nothing the site needs to start comes from Google's servers:

- **CanvasKit**, the engine's renderer, comes from `canvaskit/` rather than `www.gstatic.com`: `--no-web-resources-cdn` copies it into the build and tells the loader so (`useLocalCanvasKit` in `flutter_bootstrap.js`'s build config).
- **Fonts.** The app bundles Amiri, which covers every character of the book and the pages, and its icon fonts. CanvasKit also loads Roboto, its default font, every time it starts, and would fetch a Noto font for a character the app's fonts lack, both from `fonts.gstatic.com`. `web/flutter_bootstrap.js` sends those downloads to `fonts/` (the engine's `fontFallbackBaseUrl`), and `web/fonts` has the Roboto this engine asks for: the file `fonts.gstatic.com` serves, under the same path (`roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2`). That Roboto (2.137) is under the Apache License 2.0, as its name table says, so its license is next to it (`web/fonts/roboto/LICENSE.txt`). A character Amiri lacks would show as a box instead of reaching Google.
- `index.html` loads the app with `flutter_bootstrap.js`, which `flutter build` makes from `web/flutter_bootstrap.js`. Flutter's service worker (its default, offline-first) stays, so browsers that have Netlify's keep updating.

The build fails if either would reach Google again, such as after a Flutter upgrade whose engine asks for another Roboto: download the file it names from `https://fonts.gstatic.com/s/` into `web/fonts` under the same path, give it its own immutable rule in `web/_headers`, and remove the old one. It also fails if Cloudflare would serve the build otherwise than the hosting tests expect: a `_redirects` file (Cloudflare applies its rules before serving any file), an immutable rule that isn't one file, or a file over Cloudflare's 25 MiB.

The explanations are content, not part of starting the site: a question's YouTube video loads as the question opens (and `/` opens a question), and its Google Drive recording when its tab is chosen, as the privacy policy says.

## Serving

`wrangler.jsonc`:

- `not_found_handling: "single-page-application"`: an address that isn't a file answers with `index.html` and a 200, as Netlify's `web/_redirects` (`/* /index.html 200`) did. The app routes `/`, `/privacy`, `/support`, `/about` and the questions (`/1` to `/212`) itself. A missing asset gets `index.html` too; it's labelled HTML and never cached, and `nosniff` keeps a browser from running it as a script or a font.
- `workers_dev` and `preview_urls` are off, and there are no `routes`: Terraform owns the custom domain. Don't add routes here, or a Worker script resource to Terraform: each has one owner.

`web/_headers`, which `flutter build` copies into the build:

- Flutter's files have no hash in their names (`index.html`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `main.dart.js`, `canvaskit/`, `assets/`), so they keep Cloudflare's `public, max-age=0, must-revalidate`: a deploy shows at once, and the service worker's update fetches the new files. A file is cached for a year as immutable only when its path names its exact bytes, which is Roboto's, each by its own rule: a rule with `*` would also mark `index.html` immutable where it answers an address that isn't a file.
- Every answer gets `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY` and `Referrer-Policy: strict-origin-when-cross-origin` (the YouTube player needs the site's origin as its referrer).

The `ieasybooks.com` zone adds Cloudflare Web Analytics' beacon to the pages (`auto_install`), which the privacy policy describes as aggregate statistics without cookies. Don't add `Cache-Control: no-transform`, which would stop it.

## Checks

`.github/workflows/check.yml`'s Web job runs on pull requests, and on each commit pushed to main before it deploys; `mise run check:web` runs the same on a Mac:

1. `bun run test`: the scripts' unit tests (`scripts/*.test.ts`).
2. `bun run web:build`, with its checks.
3. `bun run web:test` (`scripts/test-hosting.ts`), against the build as Cloudflare serves it: `wrangler dev` on a free loopback port, without Cloudflare credentials.
   - Every file answers byte for byte without a redirect, with its type and caching, and the headers every answer gets; the app's addresses, a shared question link, and addresses that aren't files (a missing page, image, script, CanvasKit file and font, and `_headers`) answer with `index.html`, never cached (`scripts/hosting.ts`).
   - Headless Chromium opens `/`, `/privacy` and `/12`, each in a fresh profile, and waits for the app to show its page. Every request the page and its service worker make stays on the site, CanvasKit and Roboto among them, and every font loads. Requests to other sites are blocked; the only ones are the YouTube player each question embeds. `bun run web:test --online` lets them through and lists the hosts each page reached, by frame, without playing anything.
4. `bun run web:deploy:check`: Wrangler's dry run of the deploy.

The browser is the Chromium headless shell of the Playwright in `bun.lock`: install it once with `./node_modules/.bin/playwright install --only-shell chromium`. `bun run web:preview` serves the build at `http://127.0.0.1:8787` to look at.

## Deploys

Each commit pushed to main deploys once its checks pass. `.github/workflows/release-please.yml` runs `check.yml` on the pushed commit, marks it with a **Checks** status saying how they ended, and once they passed calls `.github/workflows/web.yml`, which:

1. builds the commit (`bun run web:build`);
2. gets `ISLAM200QA_WEB_DEPLOY_TOKEN` from the vault, a token that can deploy the `islam200qa-web` Worker and nothing else;
3. compares the commit with the one live (`scripts/deploy-order.ts`);
4. deploys it with `wrangler deploy --message <commit> --tag <its first 12 digits>`;
5. checks islam200qa.ieasybooks.com serves it (`scripts/check-live.ts`).

The site only moves forward along main. Each deploy records its full commit SHA as its Worker version's message, and `deploy-order.ts` reads the commit of the version serving all of the site's traffic, then asks GitHub how the new commit compares:

| The commit, against the live one | What happens |
| --- | --- |
| Newer | It deploys. |
| The same | Nothing uploads; the site is checked again, which is what re-running a deploy whose live check failed does. |
| Older | It's skipped: a newer commit is live. |
| Diverged, or the live version records no commit, or traffic is split between versions | The run fails; sort the site out by hand first. |

Deploys wait for each other in one queue (`queue: max`, up to 100) from reading the live commit to checking the site, so none can go live in between. GitHub starts queued runs roughly in order but doesn't promise it, so a commit that waited behind a newer one is skipped instead of putting the site back.

`check-live.ts` waits until the site serves the build's service worker, which lists every file with its hash, then checks what the hosting tests check over HTTP (`scripts/hosting.ts`): every file byte for byte, the app's addresses and addresses that aren't files. A deploy takes a few seconds to reach every location, so while anything is off it asks again every 10 seconds, for up to two minutes. It takes the zone's analytics beacon in the pages.

Deploying the website doesn't release the app: the stores get a version only when a release pull request is merged ([releasing](releasing.md)).

### Who deploys

The vault serves the deploy token only in runs Ali (AliOsm) started: his pushes to main, and his runs of the workflows by hand. When someone else pushes, the checks still run and set the status, and the run ends with a note instead of deploying. Re-running it doesn't help, as a re-run keeps the pusher's identity. Ali deploys it by running **Release web** on main (Actions, Run workflow, or `gh workflow run web.yml --ref main`), which deploys main's newest commit once its **Checks** passed.

### By hand

With your Wrangler login, from a clean checkout of a main commit:

```sh
mise exec -- bun run web:build
mise exec -- bun run web:deploy --message "$(git rev-parse HEAD)" --tag "$(git rev-parse --short=12 HEAD)"
mise exec -- bun scripts/check-live.ts
```

Always pass the full SHA as the message: without it, the next deploy stops because the live version doesn't record its commit.

To go back, revert the change on main: the revert is a new commit and deploys like any other. `mise exec -- ./node_modules/.bin/wrangler rollback` goes back at once, to a version that recorded its commit; the next push deploys main again.

### Vault access check

Run **Release please** on main with **access-check** ticked. It deploys nothing: it checks that the vault gives `web.yml`'s jobs the website's deploy token, and refuses them the store secrets, the upload key and other apps' deploy tokens.

## One-time setup

Set up infrastructure before merging the website deployment pull request: once it's merged, every main commit whose checks pass deploys.

1. Keep this repository on the deployment pull request's branch, clean, next to an ieasybooks/infrastructure checkout. From the infrastructure checkout, create the Worker with the infrastructure's token:

   ```sh
   mise run vault:run INFRASTRUCTURE_CLOUDFLARE_API_TOKEN=CLOUDFLARE_API_TOKEN -- \
     mise -C ../islam200qa exec -- bun scripts/web-bootstrap.ts
   ```

   It checks the Worker doesn't exist, fetches main, and builds main's newest commit in a temporary checkout with this branch's website files (the web shell, Wrangler and the scripts), which main doesn't have yet. It runs the hosting tests on that build, then deploys it with main's commit as its version's message. `workers.dev` and preview URLs stay off; the Worker has no public address until Terraform adds it. Creating a Worker needs the infrastructure's token: Cloudflare's Individual Workers Editor, the deploy token's role, can only name a Worker that exists.
2. Merge the infrastructure pull request and update its local main. Its plan replaces Netlify's CNAME with the Worker's custom domain, which Cloudflare refuses while the CNAME exists, so apply in two steps, the second right after the first: the site is down in between, and a resolver that asks then can remember the missing name for up to 30 minutes (the zone's SOA minimum). Follow its README ("Islam in 200 Q&A website"). This also creates `ISLAM200QA_WEB_DEPLOY_TOKEN` and the vault's rule for `web.yml`. The domain then serves the bootstrapped build.
3. Copy the token into the vault without printing it, from the infrastructure checkout:

   ```sh
   mise run tf -- show -json \
     | jq -r '.values.root_module.resources[] | select(.address == "cloudflare_account_token.worker_deploy[\"ISLAM200QA_WEB_DEPLOY_TOKEN\"]") | .values.value' \
     | mise run vault:set ISLAM200QA_WEB_DEPLOY_TOKEN
   ```

4. Merge the website deployment pull request. Its main run deploys once its checks pass: the merge is newer than the bootstrapped commit. Then run the vault access check above.
5. Remove the site from Netlify, so it no longer builds this repository.
