---
name: Substrate's vault layer + factorio doctrine arc
description: Mid-May 2026 session shipped composed-hash naming sweep (105 CLIs + 109 apps), two production vaults, factorio operating doctrine, foundry vault integration
type: insight
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
# Substrate's vault layer + factorio doctrine — 2026-05-17

A long session that ended a long arc. The substrate moved from "a collection of typed models in JSON files" to "a typed-vault-backed factory base with foundry's data layer ready to render." Worth memorializing because the components were built up over weeks; this session is when they cohered.

## What landed

**Composed-hash naming** — substrate primitive. Applied across the fleet:
- 105 CLIs renamed (`.executable(name: "<hash>-cli")` in Package.swifts)
- 109 apps renamed (`PRODUCT_NAME: <hash>` in project.yml)
- Hash function: `SHA256(SHA256(slug)[:6] + SHA256(version)[:6])[:8]`
- Imitation-game property: outside observers see opaque hashes, substrate-internal queries go through vaults

**Two production vaults shipped:**
- SubstrateRegistryVault (CLI + apps registry) — 9/9 tests passing
- SubstrateWorkspaceVault (xcworkspace contents) — 7/7 tests passing
- Same architectural pattern: file-backed (JSON / XML), atomic save + `.bak` rotation, typed find/upsert/remove API
- Both integrated into wrkstrm-identifier (replacing local duplicate types)
- Both wired into foundry-app-lib via `FoundryFleet` @MainActor ObservableObject facade

**Substrate-as-factorio doctrine** — committed bundle. The operating metaphor (factory base, supply chain, recipe browser, research tiers, rocket victory at 10 apps/day) is now official operator vocabulary, structural in operator surfaces (Foundry UI, doctrine), neutral in code.

**wrkstrm-identifier subcommand suite** — now 13 verbs: app/install-path/patch-install-path/scaffold-display-manifest/generate-icons/hash-name/bootstrap-registry/emit-aliases/install-cli/discover-clis/apply-cli-renames/discover-apps/apply-app-renames/workspace-sync/workspace-validate. Default `--dry-run` on every mutating verb. `eadaac6f-cli` post-rename.

**Substrate xcworkspace healthier:** synced 265 missing packages (669 → 934 FileRefs), then pruned 14 broken refs (920 final).

**mono-xcode-cli upgraded:** default path bumped to substrate layout, list-schemes un-stubbed via Foundation Process directly, common-shell dep removed.

**Foundry discovered to already have substantial architecture:** 4 sidebar routes, discovery model, dependency graph panel, operator queue, status panel. The next-session task became "add Fleet route + bind to FoundryFleet", not "scaffold foundry from scratch."

## The long debugging dead-end

Spent meaningful time on a misdiagnosed "xcodebuild trips on .swiftpm/xcode cache" thread before realizing xcodebuild's warnings are on stderr and don't block JSON emission on stdout. Lesson committed to feedback memory. The substrate workspace's "0 schemes" return is truthful — SPM-only workspaces don't surface schemes via `xcodebuild -list` until Xcode opens them.

## Operationally what this means

The substrate's data layer is mature enough that the application layer (foundry) becomes the next narrow deliverable. FleetView in foundry binds to FoundryFleet binds to the two vaults binds to the on-disk JSON/XML. When the operator opens foundry, they'll see the substrate's 105 CLIs + 109 apps as cards with kind borders, install status, click-through to recipe details. The factorio "recipe browser" finally has a recipe browser.

## What's deferred for next session

- Foundry's `.fleet` sidebar route + FleetView (30 min)
- InstallReceiptsVault (third vault, operator-local install state)
- CFBundleDisplayName sweep so Finder labels survive PRODUCT_NAME hashing
- Tier 1 hardening sweep (build settings for strip/disable-reflection)
- common-shell `Executable`/`EnvironmentModel`/`ProcessLogOptions` implementation (unblocks swift-package-graph-cli)
