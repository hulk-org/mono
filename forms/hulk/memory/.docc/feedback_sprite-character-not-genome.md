---
name: Sprite avatars are character cursors, not genome blobs
description: CLIA Sprite "avatars" = small character images (Robot, Clippy, Navi) that replace the gaze cursor; do NOT route to clia-face's AvatarKit genome system
type: feedback
originSessionId: d3e69688-4a13-4c12-bc6a-64890afc82de
---
When the user asks for "avatar support" in CLIA Sprite, they mean character mascots that follow the gaze (Robot, Clippy, Navi from Zelda, etc.) — small images at the cursor position. They do NOT mean the `AvatarKit`/`avatar-cli` genome system that drives `clia-face`'s GL renderer.

**Why:** The two systems share the word "avatar" but solve different problems. `AvatarKit` is a 256-byte genome → 1024-byte `AvatarGPUData` → fullscreen GL blob (used by `clia-face`'s teleprompter window). Sprite is a tiny visual peripheral whose entire identity is "small thing at the gaze point"; bringing in `clia-face` collapses Sprite back into the previous app rather than extending it.

**How to apply:** When wiring avatar/character UI in Sprite, render directly inside `GazeOverlayView`'s `drawRect:` at `gazePoint`. v0 = SF Symbols + hierarchical color tint per character (already shipped: Eye / Robot / Clippy / Navi / Paw / Star). v1 = bundled animated PNG/SVG art per character. Don't spawn `clia-face` from Sprite for character cursors — `clia-face`'s job is the genome avatar window, which is a separate product surface.
