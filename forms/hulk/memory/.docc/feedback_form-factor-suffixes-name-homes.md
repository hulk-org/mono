---
name: form-factor-suffixes-name-homes
description: "Substrate form-factor suffixes (`.cli` / `.sd` / `.lib` / `.app`) name HOMES that contain one or more items of that shape — not singletons. `savepoint.app/` houses BOTH the main Savepoint macOS app AND the resident-status menu-bar app. `savepoint.cli/` may ship multiple executable targets. `savepoint.sd/` ships both savepointd and savepoint.sd executables. Operator-clarified 2026-05-26."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**Substrate form-factor suffixes name HOMES, not singletons.** Operator-stated 2026-05-26 in response to the savepoint.app rename: *"this is going to be home to all the relevant app bundles right? not just 1 app."*

A directory named `<slug>.<form-factor>/` is the home for **one or more items** of that form-factor for that discipline. The macOS / Apple convention where `.app` is a single bundle name doesn't apply at the package-directory level — at the substrate package level, `.app` means "this package is the home for app-form-factor surfaces of `<slug>`."

## What "home for one or more" looks like concretely

Canonical instance: `kura-org/private/universal/tools/savepoint.app/` contains:

- `Sources/mac-app/` — main Savepoint macOS app
- `Sources/mac-status-app/` — resident-status menu-bar app
- `tools/icon-gen/` — support CLI for generating the apps' icon sets
- `savepoint.xcodeproj` — shared Xcode project that builds all of the above as separate app bundles + targets
- Multiple `.docc` bundles (app-store, architecture, design, specs) — documentation for the whole app-family

At build time, the Xcode project produces multiple `.app` bundles (Savepoint.app, SavepointStatus.app, possibly more). The package-level naming `savepoint.app/` doesn't predict the number — it just names the home that hosts them.

## Generalizes to every form-factor

| Form-factor | Home shape | Can house |
|---|---|---|
| `.cli` | one or more executable CLI binaries | per-subcommand binaries (e.g. `savepoint-cli` + `savepoint-pin`); cli-helper variants |
| `.sd` | one or more sleeping-daemon binaries | legacy + new daemon-interface co-existence (current `savepoint.sd/` has both `savepointd` and `savepoint.sd` executables during the v0.1→v0.2 transition) |
| `.lib` | one or more libraries | per-domain modules sharing a core (e.g. SavepointCore + SavepointEmitterCore from one package) |
| `.app` | one or more app bundles | main app + menu-bar app + share extension + watch app — all under the same product family |
| `.daemon` | one or more always-running daemons | (rare) primary + supervisor pair |

The home doesn't enforce singularity. The discipline does — if `savepoint.app/` ends up with 14 unrelated app bundles, it's no longer a "home for savepoint app-form-factor surfaces"; it's a junk drawer. But up to the point where the apps stay within the discipline's gravity, they belong in the same home.

## Why this matters for naming decisions

Without this doctrine, an author might think:
- "I need to add a watch app — guess I'll create `savepoint-watch.app/` as a sibling package"

With this doctrine:
- "savepoint.app/ already hosts app-form-factor surfaces; the watch app is one more bundle inside it"

Same for CLIs:
- "I'm adding a savepoint-pin subcommand — should it be a sibling `savepoint-pin.cli/` package?"
- No — `savepoint.cli/` is the home; add an executable target inside that package (or a sibling subcommand binary)

## When to spin a new package vs add to the existing home

Add to existing home (`<slug>.<form-factor>/`) when:
- The new item shares the discipline + form-factor
- Build artifacts can sensibly share the Xcode/SPM project
- Operators reading "savepoint.app/" would expect to find the new item there

Spin a new home (`<new-slug>.<form-factor>/`) when:
- The discipline is genuinely different (e.g. `savepoint` vs `savepoint-debug` — separate disciplines)
- Build coupling would be unhealthy (different deploy cadence, different licensing, different ownership)
- An operator looking for the item would NOT expect it under the existing home's name

## Pitfalls

- **Treating `.app` as the macOS app-bundle convention.** At the package-directory level, `.app` is the substrate form-factor suffix; at the build-artifact level, individual `.app` bundles (Savepoint.app, SavepointStatus.app) live inside. Two different meanings of `.app`; don't confuse them.
- **Auto-spinning a new package for every new variant.** Watch app, share extension, widget — these belong in the same `.app` home as the main app unless there's a real reason to split.
- **Naming the package with the singular bundle name.** Wrong: `kura-org/.../tools/Savepoint.app/` (capitalized like a single Mac bundle). Right: `kura-org/.../tools/savepoint.app/` (lowercase substrate-discipline home naming).

## How to apply

- When authoring a new package: pick the slug + form-factor suffix; remember the package is a HOME, not a single thing
- When adding a new item to an existing discipline: default to adding inside the existing home; only spin a new package when the discipline-coupling justifies a split
- When reviewing a package directory: a `<slug>.<form-factor>/` containing 1 item is fine; containing N coherent items is also fine; containing N incoherent items is a sign to split

## History

Operator-clarified 2026-05-26 immediately after the savepoint.app rename landed: *"this is going to be home to all the relevant app bundles right? not just 1 app."* The clarification ratifies what was already structurally true — savepoint.app already housed both mac-app and mac-status-app — but makes the doctrine explicit so future packages don't accidentally treat `.app` as a singleton.

## Related

- [[feedback_sd-sleeping-daemon-form-factor]] — `.sd` is one of the form-factors that follows this rule; savepoint.sd ships multiple daemon binaries
- [[feedback_executable-naming-slug-at-org-dot-form]] — `<slug>@<org>.<form-factor>` discipline (when @org infix is needed)
- [[feedback_substrate-dotted-form-factor-vocabulary]] — the broader form-factor vocabulary
- [[insights/medium-is-the-message-substrate-2026-05-26]] — naming-as-medium; package names communicate home shape, not singleton identity
- Canonical instance: `kura-org/private/universal/tools/savepoint.app/` (mac-app + mac-status-app + tools/icon-gen)
