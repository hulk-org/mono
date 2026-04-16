---
name: PICO-8 zine design patterns
description: Technical patterns from PICO-8 fanzines 1-4 — palette remapping, sprite flags, map collision, animation, cartridge format, game state machines. Reference for sprite-forge-editor + agent-rpg game engine.
type: reference
---

Key patterns extracted from picozine 1-4 (August 2015 – 2017):

**Palette system (pal/palt):**
- `pal(c0, c1)` remaps draw color c0 → c1 without changing sprite data; enables recoloring characters from a single sprite.
- `palt(c, true)` makes palette color c transparent at draw time. Default: color 0 (black) is transparent. Any color can be toggled.
- Two palettes: draw palette (remaps at draw) vs screen palette (remaps at display). Enables color cycling effects.

**Sprite flags:**
- 8 flags per sprite (bits 0-7). `fget(spriteID, flagNum)` checks a flag.
- Convention: flag 0 = solid, flag 1 = hazard, flag 2-7 = custom.
- Collision: `fget(mget(tileX, tileY), 0)` checks if the map tile at (x,y) has its solid flag set. This is the canonical PICO-8 collision pattern.

**Animation:**
- Manual frame cycling: `spr(base + t % numFrames, x, y)`.
- Frames laid out horizontally (sprites 0-3) or vertically (0, 16, 32, 48) in the sprite bank.
- No built-in animation system; all index math.

**Map system:**
- Tile grid, each cell = a sprite index (0-255).
- `mget(x,y)` returns sprite index at tile (x,y); `mset(x,y,id)` sets it.
- Map + sprite flags = declarative collision/behavior without code per-tile.

**Game loop:**
- `_init()`, `_update()`, `_draw()` — the three entry points.
- State machines: `state` variable + if/switch dispatch for menu/play/pause/gameover.
- Object pooling: preallocate entity tables, reuse by active flag.

**Cartridge format (.p8):**
- Text file with sections: `__lua__` (code), `__gfx__` (sprites as hex, 4 bits/pixel), `__gff__` (flags as hex), `__map__` (tile indices as hex), `__sfx__`, `__music__`.
- Human-diffable. Our `.spriteforge` JSON is structurally equivalent.

**Constraints that define the aesthetic:**
- 128×128 screen, 16 colors, 128 sprites (8×8 each), 8192 tokens of code.
- The constraints ARE the identity. Expanding them loses the feel.

**How to apply:** sprite-forge-editor should support pal() remapping (palette slot editing already works), palt() per-color transparency toggle, flag-based collision queries in the runtime, and horizontal-strip animation frame grouping. Agent-rpg's map renderer should use `fget(mget(x,y), .solid)` for collision.
