---
name: Catalyst is one iOS bundle that runs on Mac
description: Cross-platform substrate apps are a single iOS target with SUPPORTS_MACCATALYST=YES, not iOS + macOS-native side by side
type: feedback
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
A Mac Catalyst bundle **is** an iOS bundle. It's not a separate platform target
that sits next to an iOS target — it IS the iOS target, with
`SUPPORTS_MACCATALYST = YES`. The same `.app` artifact runs on iPhone, iPad,
and Mac.

**Why:** rismay's doctrine for the substrate: *if something is cross-platform,
it's a Catalyst bundle.* That means cross-platform Apple apps in this
substrate ship as **one** iOS target — never `platform: iOS` + `platform: macOS`
side by side, never a native AppKit `NSApplication` target alongside the iOS
target. Mac is just another destination for the same iOS bundle.

**How to apply:**
- In `project.yml` / Xcode, a cross-platform app has exactly one app target:
  `platform: iOS`, with `SUPPORTS_MACCATALYST = YES` (and usually
  `SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO` so Catalyst is the only Mac path).
- In snapshot / build plans, the "macos" surface is the **Mac Catalyst
  destination** (`platform=macOS,variant=Mac Catalyst`) of that iOS bundle —
  not a `platform: macOS` AppKit binary.
- A native AppKit (`NSPrincipalClass: NSApplication`, `platform: macOS`) target
  is *not* Catalyst and *not* the cross-platform shape; treat it as
  single-surface unless explicitly converted.
- Don't describe Catalyst as "rewriting AppKit views as UIKit views." A
  proper cross-platform substrate app starts as a UIKit/SwiftUI-iOS target;
  there's no AppKit to rewrite because there shouldn't have been a native
  macOS target in the first place.
- Don't render `iOSSimulator` and `macCatalyst` as conceptually separate
  bundles in pipeline copy; they're separate **destinations** for the same
  iOS bundle.
