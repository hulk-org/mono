---
name: Purpose strings must be honest
description: iOS Info.plist usage-description strings must describe real behavior; never write disclaimer/boilerplate strings and never assume a permission is only a transitive requirement without asking
type: feedback
---

Info.plist usage-description strings (NSSpeechRecognitionUsageDescription, NSMicrophoneUsageDescription, NSCameraUsageDescription, etc.) are shown to the user in the system permission dialog at the moment the API is actually invoked. They must describe what the app *actually does* with the permission, in user-facing language.

Never do either of these:

1. Write disclaimer/boilerplate strings like "This app does not use X; this key is required because a bundled dependency references the API." If the user ever sees the dialog, the string is a lie at the worst possible moment. It also trips Apple reviewer rejection patterns.
2. Assume a permission is only triggered by a transitive dependency without asking the operator. The app may genuinely use the feature — e.g. Today actually uses speech recognition for voice input to capture moments. Guessing "it's probably transitive" and writing a dismissive string is doubly wrong.

**Why:** Specific failure on 2026-04-08 — ITMS-90683 flagged missing NSSpeechRecognitionUsageDescription for Today (clia-day-ios). I wrote a disclaimer string ("does not use speech recognition... required because a bundled dependency...") *in the same message* where I warned that Apple rejects that pattern, then rismay corrected me twice: first that the string was self-contradictory nonsense, then that the app does in fact use speech recognition for voice input.

**How to apply:** Before writing any NS*UsageDescription string: (a) ask the operator whether the feature is actually used and how, or confirm from product context; (b) write the string as a user-facing sentence explaining what the app does with the data; (c) when one permission is added, check whether adjacent permissions will also be needed at runtime (e.g. speech recognition almost always needs mic access too — flag it proactively).
