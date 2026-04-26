---
name: Clia app graduation
description: hex-grid-face teleprompter avatar system graduates to clia-app in clia-app-org as the real Clia
type: project
originSessionId: be58b7d8-d669-43ea-8d74-0bd27945a843
---
hex-grid-face IS Clia. The teleprompter avatar with 8 styles, 3 rooms,
genome-driven rendering, music visualization, speech transcription, head
tracking, gaze cursor, and the Swift AvatarKit composition layer needs
to graduate from `wrkstrm-performance/private/apple/apps/hex-grid-bench/`
to `clia-app-org` as `clia-app`.

**Why:** The operator declared "this is it. this is clia." The prototype
at hex-grid-bench proved the full stack in one session. Now it needs a
real home with proper build, bundle ID, menu bar, and distribution path.

**How to apply:**

Source location: `collectives/wrkstrm-performance/private/apple/apps/hex-grid-bench/`
Target location: `collectives/clia-app-org/private/apple/apps/clia-app/`

Files to move:
- `src/face.cpp` → main renderer
- `src/headtrack.h/mm` → camera head tracking
- `src/listener.h/mm` → speech recognition
- `src/textrender.h/mm` → Core Graphics text
- `src/gaze_cursor.mm` → overlay cursor
- `src/listen_tool.mm` → standalone transcriber
- `src/music_tool.mm` → FFT analyzer
- `Sources/AvatarKit/` → Swift composition layer
- `Sources/AvatarBridge/` → C bridge structs
- `Sources/AvatarCLI/` → genome CLI
- `CMakeLists.txt` → build system

New additions needed:
- NSStatusItem menu bar (facemenu.mm) with avatar/room/viz/genome pickers
- Proper app icon
- Bundle ID: `me.rismay.clia` or similar
- LaunchAgent for auto-start
- Integration with clia-app-org's existing structure

The hex-grid-bench originals (tile engine, physics, backgrounds) stay in
wrkstrm-performance. Only the face/avatar/sensor stack moves to clia-app.

Swift migration continues in the new home — AvatarKit grows, genome
interpreter evolves, Metal migration begins.
