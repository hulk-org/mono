---
name: koma-plant コマプラント
description: The Koma factory app — visual test environment for the entire fleet. Ancestor is koma-by-wrkstrm in wrkstrm-app (Phase 1 inventory viewer). Phase 2 adds CLIDE dispatch, live invocation, Metal canvas, beat visualization.
type: project
---

**koma-plant** (コマプラント) — the factory where Komo are built, tested, dispatched, and observed.

**Ancestor:** `wrkstrm-app/private/apple/apps/koma-by-wrkstrm/` — Phase 1 catalog viewer with ToolEvalManifestKit, WrkstrmTreeExplorer sidebar, InventoryDetailView, ModernSharedAppShell.

**Target:** `koma-org/apps/koma-plant/`

**Phase 1 (existing):** Static inventory of 75 entries grouped by AgenticSurface + InventoryStatus. SwiftUI app.

**Phase 2 (koma-plant):**
- Migrate from wrkstrm-app to koma-org
- Add CLIDE dispatch (invoke any Komo through the daemon)
- Add live result streaming (JSON output rendered in the detail pane)
- Add composition testing (chain Komo, see pipeline results)
- Add provider comparison (same prompt → claude/codex/foundation-models)
- Add Metal canvas layer for spatial fleet visualization
- Add beat visualization (ephemeral execution traces)

**How to apply:** Migrate the existing SwiftUI views (KomaRootView, InventoryStore, InventoryDetailView) as Phase 1 baseline. Layer the live dispatch and Metal canvas on top. AppDelegate root once Metal canvas becomes primary.
