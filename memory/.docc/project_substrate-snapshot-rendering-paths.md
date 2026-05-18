---
name: Two snapshot rendering paths, not one
description: Substrate has both macOS NSHostingView and iOS/Catalyst SwiftUI-based snapshot rendering — neither is the future of the other; apps pick per platform shape
type: project
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
The substrate ships **two complementary SwiftUI-snapshot rendering paths**, not
one with a planned migration:

- **macOS-side, AppKit-backed:** `NSHostingView` → `NSImage` → PNG. Used by
  apps that have a native AppKit shape, or by standalone design-QA test
  bundles that don't need to TEST_HOST an iOS app. Reference example today:
  `hello-world-google.demo` snapshot-tests bundle (`platform: macOS`,
  offscreen renders of every Dynamic Type × locale × palette permutation;
  reference PNGs live at `qa-receipts/`).
- **iOS/Catalyst-side, SwiftUI-native:** `SwiftUI.ImageRenderer` (iOS 16+,
  macOS 13+) or `UIHostingController` + `UIGraphicsImageRenderer`. Used by
  iOS / Catalyst apps whose snapshot-tests run in the iOS test runtime.

**Why:** when the app shape is iOS+Catalyst (the substrate default), an
AppKit-backed snapshot bundle can't TEST_HOST the iOS app. When the app
shape is honest AppKit (the doctrinal exception), the NSHostingView path is
natural. Both will exist long-term across the fleet — neither is the future
of the other.

**How to apply:**
- Don't propose porting NSHostingView → ImageRenderer as a substrate-wide
  migration. Working PNG references at `qa-receipts/` stay reference-stable.
- When scaffolding snapshot-tests for a new app, pick the rendering path
  that matches the app's platform shape — not whichever path the closest
  sibling app uses.
- Both paths target the same on-disk PNG convention so they can feed the
  same downstream consumers (App Store snapshot pipeline, design-system
  diff tooling, accessibility audits).
- The new App Store snapshot pipeline
  (`WrkstrmAppStoreSnapshot` + `digikoma-capture-app-store-screenshots`) is a
  third, *separate* path that uses XCUITest + `XCUIScreen.main.screenshot()`
  to capture the **running app's actual window** — that's distinct from
  offscreen-rendering test bundles and serves a different purpose
  (App-Store-Connect-shaped marketing assets, not design-QA regression).
