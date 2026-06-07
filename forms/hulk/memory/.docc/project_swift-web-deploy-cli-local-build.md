---
name: swift-web-deploy-cli local build requires SPM_USE_LOCAL_DEPS=true
description: The remote swift-universal-main 3.0.7 lacks SemanticVersionable; only the local checkout has it, so the engine + tests only build with local deps
type: project
---

**Context:** `collectives/wrkstrm/private/universal/spm/domain/tooling/swift-web-deploy-cli/`
is the engine + CLI for the wrkstrm web sharing standard
(`*.share.json` publishing to gh-pages).

**Build requirements (as of 2026-04-08):**

- **`SPM_USE_LOCAL_DEPS=true`** is required for any swift build that
  depends on `swift-universal-main`'s `SemanticVersionable` protocol.
  The protocol exists locally at
  `swift-universal/.../SwiftUniversalMain/SemanticVersionable.swift`
  but the GitHub remote release `3.0.7` is behind and does not contain it.
  Building with `SPM_USE_LOCAL_DEPS=false` causes
  `LinkRef_Schemas_v000_002_000` (transitively pulled via
  `collective-profile-schemas`) to fail with
  `cannot find type 'SemanticVersionable' in scope`.

- **Local build is now green** after two fixes landed in commit
  `40a8de5c5` (wrkstrm collective):
  1. `swift-web-deploy-cli`'s `Package.swift` now points at
     `swift-directory-tool-cli` (was the stale `swift-directory-tools`)
     and uses an extended `localOrRemote(name:path:url:from:)` helper to
     keep the SPM identity stable across the local/remote branches.
  2. `main.swift:1353` now uses `Foundation.JSONEncoder()` (was bare
     `JSONEncoder()`, which resolved to the local `enum JSONEncoder`
     namespace at `main.swift:2863` and failed with "no accessible
     initializers").

**Open warning:** SPM emits two non-fatal `Conflicting identity for
swift-universal-main` warnings during the build, because
`collective-profile-schemas` and `entity-primitives-schemas` pull
swift-universal-main from GitHub while swift-web-deploy-cli pulls it
locally. SwiftPM resolves to local for now and will escalate to an
error in a future SwiftPM release. Coordinated upstream fix needed
(swift-universal-main 3.0.8 release with SemanticVersionable, then
collective-profile-schemas pin bump).

**How to verify local build:**

```bash
cd collectives/wrkstrm/private/universal/spm/domain/tooling/swift-web-deploy-cli
SPM_USE_LOCAL_DEPS=true swift build --product swift-web-deploy-cli
SPM_USE_LOCAL_DEPS=true swift run swift-web-deploy-cli --help
SPM_USE_LOCAL_DEPS=true swift test --filter SwiftWebDeployCoreTests
```

The pages-by-wrkstrm app's `ShareDeployView.runDeploy()` invokes the
CLI via `Process` after locating it with `which`; it surfaces a clear
error in the deploy log if the binary isn't on PATH.
