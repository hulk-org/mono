---
name: AppDelegate not SwiftUI for Metal apps
description: Metal game apps start with AppDelegate + NSWindow + MTKView, not SwiftUI App + NSViewRepresentable; SwiftUI is a layer on top, not the foundation
type: feedback
---

Metal game apps must start with AppDelegate + NSWindow + MTKView directly. Do not start with a SwiftUI `@main App` struct wrapping an `NSViewRepresentable` around an MTKView.

**Why:** SwiftUI's view lifecycle, layout passes, and state diffing add overhead and indirection between the render loop and the window. The game needs direct control over the event loop, window creation, and view hierarchy. NSViewRepresentable is a compatibility bridge, not a foundation. Starting with AppDelegate means the MTKView IS the window's content view — no SwiftUI hosting, no representable coordinator, no binding overhead.

**How to apply:** When setting up wrkstrm-games/mono, create an AppDelegate-based app with NSWindow + MTKView as the root. SwiftUI can be layered on top later for HUD overlays (via NSHostingView embedded in the window), but the render surface and event handling go through AppKit directly.
