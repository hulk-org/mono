---
name: Foundry already has substantial existing architecture
description: foundry.mac.app at wrkstrm-app/.../apps/foundry/ has full SwiftUI sidebar (4 routes), discovery model, dependency graph panel, status panel, operator queue — May 2026 task is INTEGRATING vaults, not scaffolding from scratch
type: project
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
`foundry.mac.app` at `wrkstrm-app/private/apple/apps/foundry/` is the substrate's cockpit / map view in factorio terms. **NOT** to be scaffolded from scratch — it already exists with substantial architecture:

**Surfaces:**
- `foundry.mac.app/` — main macOS app (native AppKit + SwiftUI; `platform: macOS`, deploymentTarget 26.0)
- `foundry.status.mac.app/` — status-bar variant
- `foundry.app.xcodeproj/` — generated xcodeproj
- `spm/foundry-app-lib/` — FoundryAppLib SPM package (typed core)
- `foundry.display.json` — `brand: "Foundry"`

**Existing sidebar routes** (FoundrySidebarRoute in FoundryContentView.swift):
- `.discovery` — labeled "Workspace" — bound to FoundryDiscoveryModel that walks substrate live
- `.dependencyGraph` — bound to FoundryDependencyGraphPanel
- `.status` — bound to status panel
- `.operatorQueue` — bound to FoundryOperatorQueue

**Existing dependencies** (in project.yml `packages:`): ModernMacAppShell, ModernSharedAppShell, TauStatusMenuKit, SwiftDirectoryTools, ForceDirectedGraph, MetalGameEngine.

**As of May 2026 session, FoundryAppLib also depends on:** SubstrateRegistryVault, SubstrateWorkspaceVault, plus exposes `FoundryFleet` @MainActor ObservableObject facade with 11 typed query methods (find by slug/alias/execHash; entries by collective; workspace groups).

**Next-session task:** Add `.fleet` (or `.registry` / `.catalog` — name pending) sidebar route + FleetView.swift that binds `@StateObject var fleet = FoundryFleet()` to a SwiftUI List over `fleet.aliasedRegistryEntries`. Complementary to `.discovery` — discovery walks disk live; fleet renders the typed canonical registry. ~30 min scope.

**How to apply:** When the substrate work seems to need "a UI for X", check foundry first — there's likely an existing route or place to add one, and the FoundryAppLib facade pattern is the right integration shape.
