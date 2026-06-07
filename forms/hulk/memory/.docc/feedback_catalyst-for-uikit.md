---
name: Build Catalyst targets when UIKit is needed
description: When user asks for UIKit Dynamics on macOS, set up the Catalyst target immediately — don't create a stub that prints "not available"
type: feedback
---

When the user says "UIKit Dynamics" for a macOS benchmark, they mean build the Catalyst target so it actually runs. Don't create a `#if canImport(UIKit)` stub with an else-branch that prints "not available" — that's not useful. Set up the xcodebuild Catalyst invocation or a project.yml target right away.

**Why:** The user already told me we need Catalyst. Creating a no-op stub wastes a round trip.

**How to apply:** When UIKit is needed on macOS, create an Xcode project (via project.yml + xcodegen) with `SUPPORTS_MACCATALYST: YES` so xcodebuild can produce a Catalyst binary. Don't rely on `swift run` — it doesn't support Catalyst.
