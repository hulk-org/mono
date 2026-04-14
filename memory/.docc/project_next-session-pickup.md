---
name: Next session pickup — koma-plant SwiftUI first
description: Wire koma-list into koma-plant SwiftUI, rewrite tree grouping by domain, add Run button with koma-stage-world, get SwiftUI right BEFORE moving to Metal visualization
type: project
---

**Pickup point from the 2026-04-12/13 marathon session.**

**SwiftUI first, Metal later.** Get the koma-plant SwiftUI world right
before moving to Metal game engine visualization.

1. **Wire koma-list into koma-plant** — replace InventoryStore's bundled
   75-entry ToolEvalManifestKit fixture with KomaListResult (42 Komo,
   6 domains). The InventoryStore calls koma-list or reads cached output.

2. **Rewrite tree explorer grouping** — change from AgenticSurface to
   domain (core/context/meta/directory/build/intelligence). Each domain
   is a disclosure group. Built Komo get green badges, scaffolded get gray.

3. **Add "Run" button to detail pane** — stages a world via
   koma-stage-world, dispatches the selected Komo, shows JSON result
   live in the detail pane.

4. **Add "Test" mode** — create custom fixture files in the UI, stage
   world, run Komo, see output. koma-stage-world powers this.

5. **Then build koma-need** — depends on koma-list.

**What's built (7 Komo):**
- core: echo, read-file, scan-directory, stage-world
- context: probe-context
- build: xcode-run
- meta: list

**What exists:**
- koma-org/mono submoduled at collectives/koma-org/
- CLIDE v2 with dispatch command
- 42 Komo total (7 built, 35 scaffolded) across 6 domains
- koma-plant at koma-org/apps/koma-plant/ (migrated from wrkstrm-app)
- koma-by-wrkstrm deleted from wrkstrm-app (single source of truth)
- Maestri (themaestri.app) is the UI reference for Architect by wrkstrm
- Metal engine, Agent RPG, Tetris, wrkstrm-metal-components all in place
