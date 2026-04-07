---
name: "open it" means launch the built app
description: When the user says "open it" / "open the app" for an Apple project, build and launch the .app, not open the xcodeproj in Xcode.
type: feedback
---

When the user says "open it" or "open the app" in the context of an Apple/Xcode project, they mean **launch the built `.app`**, not open the `.xcodeproj` in Xcode.

**Why:** Stated explicitly in 2026-04-06 session after I opened `mac-tabstrip.prototype.xcodeproj` in Xcode when they wanted the running app. They want to see the thing run, not the project source.

**How to apply:** For Apple targets, run `xcodebuild ... build`, locate the produced `.app` under DerivedData, then `open <path>.app`. Only open the `.xcodeproj` if they explicitly say "open in Xcode" or "open the project".
