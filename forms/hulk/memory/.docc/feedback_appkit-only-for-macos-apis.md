---
name: AppKit only when macOS APIs are required
description: Default substrate Apple apps to iOS+Catalyst; reach for AppKit/NSApplication only when a macOS-only API forces it
type: feedback
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
Default Apple app shape in this substrate is a **single iOS target with Mac
Catalyst on**. AppKit (`NSApplication`, `platform: macOS`) is the *exception*,
not the alternative. We only use AppKit when the app genuinely requires a
macOS-only API the iOS / Catalyst surface cannot reach.

**Why:** rismay's doctrine: cross-platform is the assumed shape, and a Catalyst
bundle is one iOS binary that ships everywhere. A native macOS AppKit target
is a different deployment story — separate build matrix, separate signing,
separate Mac App Store record — and is only worth that cost when the app
fundamentally needs macOS-only capability.

**How to apply:**
- When scaffolding a new Apple app in the substrate, the default `project.yml`
  is one `platform: iOS` target with `SUPPORTS_MACCATALYST = YES` (and usually
  `SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO`).
- Reach for AppKit only when there is a concrete macOS-only API requirement:
  - Custom NSMenu / NSMenuItem / status bar behaviors UIKit's `UIMenu` can't
    express
  - `NSWorkspace`, `NSScreen` private capabilities, accessibility-API-of-record
    behaviors (e.g. system-wide accessibility clients)
  - `NSWindow`-level chrome that Catalyst's window model can't deliver
  - Document-based Mac apps with `NSDocument` semantics
  - Apps that ship as menu-bar-only / no-Dock-icon utilities (LSUIElement
    NSStatusItem live in AppKit-land)
  - Low-level AppKit drag-drop, services, or scriptability bridges
- If you find yourself proposing a `platform: macOS` AppKit target, surface
  the macOS API that justifies the AppKit choice before authoring it.
- An existing AppKit target that was authored without a clear macOS-API
  reason is a candidate for an iOS-Catalyst pivot, not a starting shape to
  replicate.
