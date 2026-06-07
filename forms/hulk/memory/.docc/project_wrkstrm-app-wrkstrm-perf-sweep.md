---
name: wrkstrm-app + wrkstrm-performance sweep 2026-04-21
description: App hygiene sweep across wrkstrm-app and wrkstrm-performance — merges, moves, TouchUpCore removal, chess UX fixes
type: project
originSessionId: be58b7d8-d669-43ea-8d74-0bd27945a843
---
Sweep completed 2026-04-21:

- **architect + architect-by-wrkstrm-catalyst merged** into single `architect/` folder with two xcodegen targets (macOS native + iOS Catalyst). Catalyst sources at `Sources/catalyst-app/`.
- **spiders trashed** — empty shell, zero sources.
- **tree-traversal-benchmark moved** from wrkstrm-app to wrkstrm-performance (performance bench, not a product app).
- **metal-tetris moved** from wrkstrm-performance to wrkstrm-games (playable game, not a bench). pbxproj path for metal-game-engine updated to cross-collective.
- **TouchUpCore removed** from both `wrkstrm-mac-touch-draw.mac.app` and `wrkstrm-mac-touch-core.mac.demo` — enum case, driver class, pipeline flows 1–3, acquisition path logic, experiment detail views. Only wrkstrmHID driver remains.
- **wrkstrm-chess fixes**: label maxW 120→400, loading bar quad→line (SDF ellipse fix), filled glyphs on intro, piece contrast discs (dark behind white, light behind black), animation duration 0.35→2.0s, ~Copyable AnimationSnapshot for frame-consistent state, animation wired into both onMoveApplied callbacks (new-game path was missing it).

**Why:** collective hygiene — apps in the right home, dead code removed, playable games verified.

**How to apply:** when revisiting these collectives, the tracked build artifact cleanup (~2.4 GB in wrkstrm-performance, ~145 MB foundry + desktop-utilities .derived-data in wrkstrm-app) is still pending.
