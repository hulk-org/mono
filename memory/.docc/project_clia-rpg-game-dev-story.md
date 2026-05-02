---
name: clia-rpg Game Dev Story mode
description: clia-rpg becomes a Game Dev Story-style management sim where agents are the dev team, directories are rooms, and Digikoma get visual representation in a navigable game world
type: project
---

clia-rpg evolves from a static dashboard into a **Game Dev Story-style management sim** for the substrate. The game is the UI layer over real agent work.

**Core mapping:**
- **Hire devs** = commission agents / spawn Tachikoma (Digikoma)
- **Pick genres** = choose which collective/package/directory to work on
- **Train staff** = agent expertise growth (memory/.docc/expertise)
- **Ship titles** = actual builds, deploys, PR merges
- **Chase review scores** = test results, bench numbers, App Store ratings

**Why:** This gives Digikoma a visual environment and representation. Instead of invisible CLI workers, they're pixel-art characters moving between rooms, picking up tasks, producing output. The operator sees the work happening spatially.

**Architecture:**
- **Main office** = entry point, shows the active party + current project
- **Doors** = directories in the collective the user chooses to explore
- **Rooms** = subdirectories, each rendered as a game room on the Metal canvas
- **Directory tree** = navigable game world (pan/zoom, enter/exit rooms)
- **Agents/Digikoma** = sprites that move between rooms as they work on tasks
- **Files** = objects/NPCs in rooms (swift files = code scrolls, .docc = books, Package.swift = workbench)

**Engine needs (metal-game-engine roadmap):**
1. Sprite/texture rendering (quad + texture atlas, not just colored quads)
2. Camera pan/zoom input (scroll/pinch gestures on the Metal canvas)
3. Hit testing (click on agent → inspect, click on door → enter room)
4. Text rendering (SDF font atlas for room names, agent labels, stats)
5. Tile map system (rooms as tile grids, doors as transitions)

**First milestone:** Main office with party sprites + one door that opens a real directory as a room. No text rendering yet — just colored quads as sprites, doors as glowing portals, files as small objects. Prove the navigation loop works on the Metal canvas before adding visual polish.

**How to apply:** This is the long-term vision for clia-rpg. Every engine feature (sprite rendering, hit testing, camera input, text) should be built as a reusable metal-game-engine capability, not clia-rpg-specific code. The 5 other consumers benefit from each addition.
