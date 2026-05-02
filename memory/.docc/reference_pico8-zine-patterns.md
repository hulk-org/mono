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

**Editor layout (from Zine #4 p9 screenshot — the canonical reference):**
- Sprite strip at BOTTOM (not left sidebar), horizontally scrollable
- Pixel canvas DOMINATES center (~70% of window)
- Palette: compact 4×4 grid, top-right corner
- Tools: tiny icon buttons (pen/stamp/select/copy/fill/circle/rect/line) — NOT text labels
- Flags: 8 colored dots in a row at bottom-right (not checkboxes)
- Page buttons [0][1][2][3] for sprite bank pages

**pal() as character reuse pattern (Zine #3 Succer):**
- ONE player sprite template → draw N times with different pal() remaps → entire team
- Eliminates per-agent procedural generation; ~5 body templates + palette remap table replaces 40 unique sprites
- Atlas shrinks dramatically; palette remap is 3 bytes vs 1024 bytes per sprite

**Distance-field AI (Zine #4 p6-7):**
- Flood-fill distance from hero position, gated by `fget(mget(x,y), .solid)`
- Monsters check 4 neighbors, move toward lower distance
- Simple, no A* needed for most room-scale navigation
- Directly applicable to agent-rpg Digikoma movement in rooms

**How to apply:** sprite-forge-editor layout should match the PICO-8 canonical layout (bottom strip, dominant canvas, compact palette). The procedural character generator should move to template + pal() remap model. Agent-rpg room navigation should use distance-field AI with fget+mget pattern. The cartridge is a creative artifact, not a config file.
