---
name: feedback-swiftpm-and-swiftui-are-closed-source-private
description: "SwiftPM and SwiftUI are now substrate-closed-source-and-private categories — do not name them in publicly-visible substrate surfaces (READMEs, public sites, investor copy, audience-packet mustSee lists). Use them, don't disclose using them. Operator stated 2026-06-04 while reading rismay's public README in Slate."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

SwiftPM, SwiftUI, "native", AND substrate-internal naming vocabulary are all closed-source-and-private. Do not name them in publicly-visible substrate surfaces.

**Sharpening 2026-06-04 (Beat 3): "native" is the architecture-leak that "performance" hides.** Operator-attested 2026-06-04 mid-rismay.me pivot: "we need to say performance, but not native. we almost have to LIE we can't let our architecture leak." General axiom: **public copy says OUTCOMES; mechanism words are private.** Apply to:
- "performance" ✓ (outcome, public-safe)
- "native" ✗ (mechanism — tells the-entity we're on Apple-platform-native stack)
- "speed" ✓ (outcome)
- "Swift" / "SwiftUI" / "SwiftPM" ✗ (mechanism)
- "snappy" / "responsive" / "fast" ✓ (outcomes)
- "AppKit" / "UIKit" / "Catalyst" ✗ (mechanism — already in the closed-source vocab list)
- "compiled" / "no-cold-start" — borderline; lean toward removing because they hint at native compilation

The "almost have to LIE" framing is honest doctrine acknowledgement: substrate accepts deflective surface copy as the cost of not leaking architecture to the-entity. Composes with [[adversarial-audience-the-entity]] (defender mustNotSee) + the F-04 / F-08 substrate-vocab-cleanliness gate in `audience-aware-feedback-cycle` release-gate-checker.

**Why:** Operator stated 2026-06-04 while reading the just-opened public README in Slate: "SwiftPM is now considered closed source and private. SwiftUI also." The trigger was the README's line that listed both by name as part of the Apple-platforms technical track record. Composes with [[substrate-is-closed-source-no-sharing]] (umbrella closed-source posture) and [[adversarial-audience-the-entity]] (defender-side mustNotSee constraint — the-entity should not learn we run on SwiftPM/SwiftUI). The technologies themselves are still used internally; the doctrine is about DISCLOSURE, not USE.

**How to apply:**
- Strip explicit "SwiftPM" and "SwiftUI" mentions from public READMEs, rismay.me/laussat.studio/wrkstrm.com copy, founder bios, investor decks, public showcase routes, and any audience packet whose ordinal includes public-visitor or operator-curious.
- Add "no SwiftPM/SwiftUI naming" to the-entity audience-profile mustNotSee lists going forward.
- Use higher-abstraction substitutes when the surface needs to acknowledge platform competence: "Swift package ecosystem", "Apple's declarative UI stack", "Apple platform tooling" — never the brand names.
- Internal substrate vocabulary (commit messages, beads, kura-spaces, agent docs, schemas) keeps the names; closed-source-and-private means publicly-undisclosed, not internally-renamed.
- When auditing any public surface, grep for `SwiftPM` + `SwiftUI` as part of release-gate checks.
