---
name: Backdrop by wrkstrm
description: Live wallpaper app at desktopIconWindow-2; COLLIDE is first scene; particles represent real substrate events; separate from Desktop Utilities widget layer
type: project
originSessionId: 01c7da75-9b7a-4b0b-a238-5cc62638b1ed
---
Backdrop by wrkstrm = live Metal wallpaper layer. Slug backdrop-by-wrkstrm, bundle me.rismay.backdrop.

**Why:** Desktop Utilities owns the widget layer (desktopIconWindow - 1). Backdrop owns the wallpaper layer one step further back (desktopIconWindow - 2). Separate processes, separate concerns: Backdrop is GPU-heavy Metal rendering, Desktop Utilities is lightweight SwiftUI widgets.

**How to apply:** COLLIDE membrane visualization is the first scene. Particles must represent real substrate events — Ghost (purple descending) = intent/commands, Shell (green ascending) = results/receipts. Event sources: Beads tasks, Komo dispatch/receipt, WrkstrmFSEvent, git ops, build results, session telemetry, inference metrics. Calm when idle, storm when active. metal-collide-bench --desktop mode is the prototype.
