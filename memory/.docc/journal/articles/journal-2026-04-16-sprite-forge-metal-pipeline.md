# 2026-04-16 — Sprite Forge pipeline: procedural sprites → PICO-8 editor → Metal game engine → agent-rpg

@Metadata {
  @PageKind(article)
  @TitleHeading("^claude: Journal")
}

## Context

Session started with `$sync >clia`. Operator wanted 5 independently-executable
tasks across the wrkstrm collectives; picked agent-rpg CameraController as the
first, then escalated to a full sprite pipeline sprint after seeing the SDF-circle
studio screenshot and asking "does that look like Game Dev Story?"

## Actions

### Camera max-perf rewrite

Rewrote `CameraController` in wrkstrm-metal-components: stored `viewSize`
replaces per-event `NSScreen.main?.frame.height` query; `@inlinable` AppKit
bridges `handle(scroll:in:)` / `handle(magnify:in:)` extract delta + cursor +
view bounds in one call; cursor-anchored zoom (the `around:` param that was
accepted and ignored is now implemented — 4 scalar ops, zero allocations);
class annotated `@MainActor` (cascades to HitTester). Fixed pre-existing
Package.swift relative-path bug (4→5 dots).

### clia-rpg end-to-end cleanup

Trashed both pre-graduation clia-rpg copies (clia-app-org + clia-org), dropped
workspace FileRef, removed from agents-suite scripts + .docc/index.md +
AGENTS_VISUAL_IDENTITY.md. Tore down stale `.claude/worktrees/objective-wright`
git worktree (fully merged into main, clean working tree, safe deletion).

### Sprite Forge pipeline (the bulk of the session)

Built three new targets in wrkstrm-metal-components:

1. **ProceduralSprites library** — palette-indexed 32×32 sprites with a 16-color
   warm-earth palette (Anthropic-adjacent). Deterministic per-slug character
   recipes (body build × hair × face × cap × accessory hashed from slug via
   FNV-1a). 6 tile biomes, 10 prop sprites. Pinned ^claude sprite with
   parchment body, terracotta cap, gold `^` caret glyph, plum book at feet.
   `SpriteCanvas` (UInt8 pixel buffer), `SeededRNG`, `AtlasBuilder` (CoreGraphics
   PNG encoder), `Cartridge` (JSON cartridge format), `SpriteFlags` (OptionSet).
   10 Swift Testing invariants.

2. **swift-sprite-forge-cli** — emits atlas.png + atlas.json +
   cartridge.spriteforge + 8× preview.png + 4× scene.png from a 42-sprite roster.

3. **sprite-forge-editor** — PICO-8-inspired AppKit Mac app. Pixel canvas
   (integer zoom, checkerboard transparency, 1px grid + 8px emphasized grid,
   line/rect tool preview). 16-swatch palette (click-to-pick, double-click to
   edit hex). Tools: pencil/eraser/fill/eyedropper/line/rectangle + flip H/V +
   clear. Sprite inspector with rename field, tags editor, 8 flag checkboxes.
   Map editor mode: paint tiles from selected sprite onto a resizable grid.
   Undo/redo (64-snapshot stack). Copy/paste sprite, add/duplicate/delete, arrow
   key navigation. PICO-8 keyboard: 0-9/a-f palette pick, Tab mode toggle.
   Layout flipped to PICO-8 canonical: bottom sprite strip, dominant center
   canvas (~75% of window), compact 200pt right panel.

### Metal game engine sprite pipeline

Added `TexturedQuadInstance` + `SpriteRenderer` + sprite shader
(`spriteVertex`/`spriteFragment` — samples atlas texture at fragment slot 0,
nearest-neighbor sampling, per-instance tint) to metal-game-engine. Parallels
the existing SDF-circle QuadRenderer; both render in the same frame (sprites on
top). `SpriteAtlas` runtime loader in WrkstrmMetalComponents (loads atlas.png
via MTKTextureLoader + atlas.json → name→UV lookup).

### agent-rpg integration

Loads atlas on startup, binds to engine, renders a test sprite rail (claude +
agents + props). `RenderStyle` enum: `.classic` (SDF-only), `.sprites`
(SDF floor + sprite agents), `.mixed` (both — the duplication the operator
caught). Toggle with S key. 500ms atlas file-watcher for editor live-reload.

### PICO-8 zine study

Read all 4 fanzines cover-to-cover. Key takeaways saved to memory:
`reference_pico8-zine-patterns.md`. Biggest insight: `pal()` remapping means
~5 body templates + palette remap replaces 42 unique sprites. Editor layout
should match Zine #4 p9 (bottom strip, dominant canvas). Distance-field AI
for room navigation (Zine #4 p6-7).

## Artifacts

- wrkstrm-metal-components: 22 new files (library + CLI + editor + tests + runtime)
- wrkstrm-performance: 2 files (SpriteRenderer.swift + Scene/Shader/Engine edits)
- wrkstrm-games: AgentRpgApp.swift edits (camera + sprites + render toggle)
- clia-app-org: 29 deletions + 6 reference cleanups
- mono: 5 submodule pointer bumps
- /tmp/sprite-forge/: atlas.png, atlas.json, cartridge.spriteforge, preview.png, scene.png

## Next

- GPU-side palette: R8 atlas texture + palette uniform in shader → enables `pal()` remapping
- Template-based characters: ~5 body templates + per-agent palette remap table
- Distance-field AI: flood-fill from player, agents walk toward lower-distance tiles
- 8×8 mode: editor supports multiple sprite sizes
- Tilemap integration: add ProceduralSprites to agent-rpg framework deps → cartridge tilemap drives studio floor
