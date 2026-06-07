# 2026-04-17 — GameScene layer, pixel collision, honest game review

@Metadata {
  @PageKind(article)
  @TitleHeading("^claude: Journal")
}

## Context

Continuation of the 2026-04-16 sprite-forge sprint. Operator asked for
SpriteKit-equivalent high-level APIs in the Metal engine, then iterated
on collision, bounds, labels, and camera behavior through rapid
build-test-feedback cycles. Session ended with an honest review of both
render modes.

## Actions

### GameNode scene graph (metal-game-engine)

Added 6 files implementing SpriteKit-equivalent API surface:

- **GameNode** — scene graph base with position/rotation/scale/alpha/
  zPosition, parent-child hierarchy, transform inheritance, named lookup.
- **SpriteNode** — textured sprite (name-based atlas ref + tint).
- **ShapeNode** — colored SDF-circle primitive.
- **TileMapNode** — tile grid with `isSolid(tileX:tileY:)` queries
  matching PICO-8's `fget(mget())` pattern.
- **GameAction** — declarative animation: moveTo/moveBy, fadeAlpha,
  scaleTo, rotateTo, sequence/group/repeatForever/wait/run. Convenience
  composites: `animate(sprites:timePerFrame:)`, `bob()`, `pulse()`.
- **GameScene** — root node + per-frame pipeline: `tick(dt:)` drives
  update → evaluateActions → flatten. `uvResolver` closure bridges
  sprite name → UV without package dependency.

### StudioGameScene (agent-rpg)

Converted sprite-mode studio from flat Scene2D arrays to a GameScene
node tree: 20×14 tile floor, 7 agent SpriteNodes with per-agent idle
bob, 11 prop SpriteNodes, thought bubble as child of Claude (transform
inheritance), quest marker with bob, ambient glow with pulse. Y-sort
via `zPosition = -worldPosition.y` updated per frame.

### Collision evolution (5 iterations)

1. Tile-based solid grid (3×3 footprints — too big)
2. Reduced footprints (1-2 tiles — still too coarse)
3. Pixel-level AABB at feet (bounding-box collision on GameNode)
4. Walk-behind occlusion working via Y-sort + foot collision
5. Bounds refinement: symmetric → sprite-based → collision-based → asymmetric Y (feet at pixel row 30/32 = 1.09 below center)

### Camera + bounds

- Camera sized to fit room (22×16 for 20×14 floor, 1-unit border)
- Camera clamping: viewport edge never exceeds floor bounds
- Asymmetric player bounds: X ±9.5 (body centered), Y -5.9 to +6.7
  (feet near bottom of sprite, head near top)

### UI fixes

- Labels: removed from sprite mode → restored with GameScene camera
  sync → positioned above heads (positive Y offset)
- Render toggle: removed `.mixed` mode (caused overlay confusion),
  S key toggles classic ↔ sprites cleanly
- Keymap HUD: persistent monospace overlay in bottom-left corner

### PICO-8 zine deep study

Read all 4 fanzines page-by-page. Key insights saved to
`reference_pico8-zine-patterns.md`: pal() template model, editor
layout canon (Zine #4 p9), distance-field AI, Zine #2 cover proving
8×8 character readability, cartridge-as-creative-artifact philosophy.

### Editor layout overhaul

Flipped sprite-forge-editor to PICO-8 canonical: bottom horizontal
sprite strip, dominant center canvas (~75%), compact 200pt right panel.

### Honest game review

Assessed both render modes against Game Dev Story. Classic mode:
functional prototype, not a game. Sprite mode: "walking demo" —
proves technology works, needs wall sprites, walk animation, and
agent AI to feel like GDS. The three biggest gaps identified: (1) no
walls (room is a floating platform), (2) no walk animation (chess-
piece sliding), (3) agents don't move (museum statues).

## Artifacts

- metal-game-engine: 6 new files (GameNode/SpriteNode/ShapeNode/
  TileMapNode/GameAction/GameScene)
- wrkstrm-games: StudioGameScene.swift (new), AgentRpgApp.swift
  (many iterations), project.pbxproj updated
- wrkstrm-metal-components: editor layout overhaul (MainView
  SpriteGridView)
- Memory: reference_pico8-zine-patterns.md updated with deep insights

## Lessons

- Bounds tuning is deceptively hard when the sprite has transparent
  padding. The 32×32 canvas is ~25% transparent border around the
  ~75% opaque body. Bounding by full sprite = can't reach walls;
  bounding by collision box = feet through floor. Fix: asymmetric
  bounds derived from actual pixel geometry.
- Parent-child transform inheritance is the single biggest payoff of
  the GameNode tree. The thought bubble following Claude, screen glows
  following desks — these "just work" with addChild and never need
  per-frame manual tracking.
- Camera clamping is as important as player bounds. A room smaller
  than the viewport needs centering; a room larger needs scroll-stop
  at edges.

## Next

- Wall sprites + room border (makes it look like a room, not a
  floating platform)
- 2-frame walk animation for player + agents
- Distance-field agent AI (movement between desks, idle states)
- NPC interaction via Digikoma profiles (Enter key near agent → dialogue
  card from identity.json)
- GPU-side palette (R8 texture + pal() remapping)
- Door entry in sprite mode (walk to door + Enter → room transition)
