---
name: Next session pickup — digikoma-plant SwiftUI first
description: Wire digikoma-list into digikoma-plant SwiftUI, rewrite tree grouping by domain, add Run button with digikoma-stage-world, get SwiftUI right BEFORE moving to Metal visualization
type: project
originSessionId: 17bca72f-ee91-4f7a-8002-180df199eef5
---
**Pickup point from the 2026-04-12/13 marathon session.**

**SwiftUI first, Metal later.** Get the digikoma-plant SwiftUI world right
before moving to Metal game engine visualization.

1. **Wire digikoma-list into digikoma-plant** — replace InventoryStore's bundled
   75-entry ToolEvalManifestKit fixture with DigikomaListResult (42 Koma,
   6 domains). The InventoryStore calls digikoma-list or reads cached output.

2. **Rewrite tree explorer grouping** — change from AgenticSurface to
   domain (core/context/meta/directory/build/intelligence). Each domain
   is a disclosure group. Built Koma get green badges, scaffolded get gray.

3. **Add "Run" button to detail pane** — stages a world via
   digikoma-stage-world, dispatches the selected Koma, shows JSON result
   live in the detail pane.

4. **Add "Test" mode** — create custom fixture files in the UI, stage
   world, run Koma, see output. digikoma-stage-world powers this.

5. **Then build digikoma-need** — depends on digikoma-list.

**What's built (7 Koma):**
- core: echo, read-file, scan-directory, stage-world
- context: probe-context
- build: xcode-run
- meta: list

**What exists:**
- digikoma-org/mono submoduled at collectives/digikoma-org/
- CLIDE v2 with dispatch command
- 42 Koma total (7 built, 35 scaffolded) across 6 domains
- digikoma-plant at digikoma-org/apps/digikoma-plant/ (migrated from wrkstrm-app)
- digikoma-by-wrkstrm deleted from wrkstrm-app (single source of truth)
- Maestri (themaestri.app) is the UI reference for Architect by wrkstrm
- Metal engine, Agent RPG, Tetris, wrkstrm-metal-components all in place
