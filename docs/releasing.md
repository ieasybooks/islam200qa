# Releasing

The Android app is released to Google Play and AppGallery: [release-please](https://github.com/googleapis/release-please) versions it from the commit messages, and each version goes to both stores, whose reviewers publish it. iOS isn't released. The website, islam200qa.ieasybooks.com, isn't part of this: Netlify builds and hosts it.

The version is `pubspec.yaml`'s, without a `+build` suffix. `release-please-config.json` sets the app up as the repository's one component, and `.release-please-manifest.json` holds its released version. The Android version code follows from the version ([ieasybooks/release](#the-shared-release-tooling): 1.2.3 builds as 1002003), so a release never needs one raised by hand. Builds take both from `ieasybooks-release release-info --app .` (`--build-name` and `--build-number`). Version 1.0.0 shipped by hand as version code 14, so the first release from here, 1.0.1, jumps to 1000001.

## Commit messages

Commit titles follow [Conventional Commits](https://www.conventionalcommits.org/), and they decide the versions, whether a commit comes through a pull request or is pushed to main. With rebase merges every commit title counts; with squash merges, the pull request's title.

- `fix:` raises the patch version (1.0.0 → 1.0.1), and `feat:` the minor one (1.0.0 → 1.1.0). A breaking change (`feat!:`, or a `BREAKING CHANGE:` footer) raises the major one.
- `chore:`, `docs:`, `test:`, `ci:`, `build:`, `refactor:` and `style:` release nothing. A title that isn't a Conventional Commit releases nothing either, so a change to the app under one never reaches the stores until a later `fix:` or `feat:` does.

The **Commits** check on pull requests (`.github/workflows/commits.yml`, `ieasybooks-release routing`) checks that every releasing commit, and a releasing title across the pull request's files, changes a component of `release-please-config.json`.

## Releasing

1. Merge commits to main. After each push, the **Release please** workflow (`.github/workflows/release-please.yml`) opens or updates the release pull request, **chore: release main**, with the new version in `pubspec.yaml` and `CHANGELOG.md`.
2. Write that version's store release notes in `store/release-notes/<version>/ar.txt` (at most 500 characters), and anything else in `store/` that should change, in an ordinary pull request (`docs: …`, which releases nothing). The release pull request's **Release check** status fails until main has them. `bun run store:check` checks the same on your Mac, once `pubspec.yaml` has the new version.
3. Ali (`AliOsm`) squash-merges the release pull request. release-please tags the app (`v<version>`) and creates its GitHub release. In the same run, the workflow runs every check (`check.yml`) on the commit it tagged, marks the commit with a **Checks** status saying how they ended, and once they passed releases the app (`release.yml`). Each release job checks out exactly that commit, never the tag by name, and first checks that the tag still points at it and that no newer release exists.

GitHub's checks on the release pull request wait for someone to approve them, since GitHub Actions opened it. They're not needed: the merge is checked on main before anything ships, and its **Release please** run sets the **Release check** status.

Only Ali's merge ships, because the vault serves the release secrets only in runs he started. If someone else merges the release pull request, the tag, the GitHub release and the checks still run, and the run ends with a note instead of shipping. Ali then runs **Release app** (with **dry-run** unticked) on the `v` tag from the Actions tab.

Pushing a version tag by hand releases too: `v<version>`. The tag must match `pubspec.yaml`'s version on that commit, the commit's **Checks** status must say main's checks passed on it, so tag a commit from main, and no newer release may exist.

## What the release workflow does

| Job           | What it does                                                                                                                                                                                                                                                                   |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Check         | Checks that the tag points at the commit being released (and, for a tag pushed by hand, that main's checks passed on it) and that no newer release exists, then checks the version and `store/` with the version's release notes.                                               |
| Build Android | Builds the AAB and APK with the Flutter that `mise.toml` pins, signed with the upload key the ieasybooks apps share (`android/app/build.gradle`), and checks the signer. Google Play knows it as the app's upload key, and it signs the live AppGallery APK.                       |
| Google Play   | Sends the AAB to the production track with the listing, release notes and changed images (fastlane supply). Managed Publishing is off, so Google publishes it once approved.                                                                                                    |
| AppGallery    | `ieasybooks-release appgallery publish`: uploads the APK, updates the texts and any changed images, and submits the version, released once approved. While a version is still in review it stops before changing anything: cancel that review in AppGallery Connect and re-run. |

Every job runs on GitHub's Linux runners. The store jobs are independent: one failing doesn't stop the other. The Android build runs only here, in releases and dry runs; `check.yml` runs Flutter's analysis and tests, `store check` and checks that fastlane loads the lane.

## When a release fails

A re-run keeps the identity of whoever started the run, so it gets the release secrets only for a run Ali started. Every job that uploads first checks that no newer release exists (`ieasybooks-release not-superseded`), and stops if one does.

| What failed                          | What to do                                                                                                                                                                                                                        |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The checks on the release commit     | If it was a flaky check, **Re-run failed jobs** in that run: it re-runs the checks, then the release. If the commit is broken, fix it with a `fix:` commit and release the next version.                                          |
| Build Android                        | Fix the cause and **Re-run failed jobs**: it builds again, and nothing has reached a store.                                                                                                                                      |
| Google Play                          | **Re-run failed jobs** uploads the AAB again in a new edit. That works when the failed run's edit wasn't committed; once Google has the version code, it refuses it, and the next version is the way out.                          |
| AppGallery                           | **Re-run failed jobs** uploads and binds the APK again. While a version is in review it stops before changing anything: cancel that review in AppGallery Connect, then re-run.                                                   |
| Nothing shipped: someone else merged | Run **Release app** (dry-run unticked) on the `v` tag.                                                                                                                                                                           |

The stores don't take an older version than one they have, so fix forward with a `fix:` commit and release the next version. A version still in review can be pulled out in Google Play Console or AppGallery Connect.

## Dry runs

Any other `v*` tag is a dry run: push a throwaway one, such as `git tag v0-dry-run && git push origin v0-dry-run`, on the commit to test. Running the **Release app** workflow by hand on a `v*` tag is a dry run too, unless **dry-run** is unticked. A dry run builds and signs the app and checks everything without releasing: Google Play checks the AAB and listing in an edit it never commits, and AppGallery reports what it would upload, change and submit, and issues an upload URL without taking the APK. It needs the release notes of `pubspec.yaml`'s version, as `store check` does. Delete the throwaway tag afterwards: `git push origin :v0-dry-run && git tag -d v0-dry-run`.

## The store listing

`store/` holds everything Google Play and AppGallery show besides the app itself, in Arabic, in [ieasybooks/release](https://github.com/ieasybooks/release)'s format (its README lists every file and limit). Each release sends it to both stores and overwrites edits made in their consoles, so change the listing here.

- `store.json`: the app's name in messages, the stores (`googlePlay`, `appGallery`), the Arabic listing's locale in each, and the AppGallery app ID.
- `ar/`: the name, short description and description, as they were on Google Play and AppGallery on 19 November 2026.
- `release-notes/<version>/ar.txt` and `review-notes/appgallery.txt`.
- `screenshots/`: Google Play's icon, feature graphic, and phone, 7-inch and 10-inch screenshots, and AppGallery's icon and phone screenshots, from the live listings. Google Play's icon and feature graphic were served as JPEG and are stored as PNG; its phone screenshots are widened from 1080x2400 to 1200x2400 by extending their edges, as Google Play now takes at most 2:1; AppGallery's icon is scaled from 512x512 to the 216x216 it takes. The first release uploads those images again; the others are the stores' own files.

## Secrets

The release workflow gets everything from the ieasybooks vault through [`ieasybooks/vault`](https://github.com/ieasybooks/vault). `cloudflare/vault-secrets.tf` in ieasybooks/infrastructure gives the app its callers (`local.release_apps.islam200qa`): the store secrets and the shared upload key go to `release.yml`, on `v*` tags and as called by `release-please.yml` on main, in runs Ali started.

| Secret                                                        | Used for                                                                   |
| ------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `ANDROID_UPLOAD_KEYSTORE`, `ANDROID_UPLOAD_KEYSTORE_PASSWORD` | Signing the AAB and APK: the upload key the ieasybooks apps share (alias `upload`) |
| `GOOGLE_PLAY_SERVICE_ACCOUNT`                                 | Google Play                                                                |
| `APPGALLERY_CONNECT_SERVICE_ACCOUNT`                          | AppGallery                                                                 |

To check those rules, run **Release please** by hand on main with **access-check** ticked (`gh workflow run release-please.yml --ref main -f access-check=true`). It releases nothing: `release.yml`'s access check asks the vault for its own secrets, which must be served, and for other apps' keys and tokens, which must be refused because no rule matches. Run it after changing the vault's rules.

## The shared release tooling

The release commands come from [ieasybooks/release](https://github.com/ieasybooks/release), which ieasybooks apps share, pinned to one commit as `@ieasybooks/release` in `package.json` (and `bun.lock`). The root `package.json` only installs it: the app's version stays in `pubspec.yaml`. The workflows run the command from `node_modules/.bin`, never through `bunx` or `npx`, which would download whatever npm has under that name if the package were missing. To take a newer version, change the commit in `package.json` and run `mise exec -- bun install`. Its README describes each command and the store folder's format.

## Running the steps on a Mac

`mise install` installs the pinned Flutter, Bun, Ruby and Java, then `mise exec -- bun install` and `mise exec -- bundle install`. `mise run check` runs what `check.yml` does. With the secrets from `mise run vault:run` in ieasybooks/infrastructure, `bundle exec fastlane android publish aab:<aab> dry_run:true` and `node_modules/.bin/ieasybooks-release appgallery publish --app . <apk> --dry-run` check a release as the workflow does.

Flutter builds Android with Android Studio's Java when it finds it, which may be newer than the project's Gradle (8.7) runs on; `flutter config --jdk-dir "$(mise where java)"` points it at the pinned Java 21.
