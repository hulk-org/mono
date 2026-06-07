---
name: app-asks-must-reach-launch-review
description: "When the operator asks for an app, the work is not done at \"scaffold landed\" or \"builds green\" — the agent must take it all the way through the substrate's launch-review release gate before reporting complete"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

When the operator asks for an app, the work is **not done** until the app
has been driven through the substrate's full launch-review gate.

**Operator's exact words (2026-06-04, mid-cascade for web-browser.app):**
> all. remember when we ask for an app. YOU HAVE TO TAKE IT ALL THE WAY
> TO LAUNCH REVIEW!

**The full chain for any app ask:**

1. Scaffold (Package.swift / project.yml / Sources / Info.plist /
   display.json / design.docc).
2. Commit via savepoint so the cascade is preserved per
   [[savepoint-daemon-races-your-commits]] + [[Commit like you tweet —
   small and often]].
3. `xcodegen` (or SwiftPM resolve) so the build surface is real.
4. `xcodebuild` to a green build.
5. `Close, delete, then launch` per [[Close, delete, then launch]] —
   clean install cycle, no stale `.app` bundles.
6. Real-world verification: load the app, exercise the golden-path UX,
   confirm it behaves per spec.
7. Register the app via `wrkstrm-identifier workspace-sync --execute`
   and the AppDisplayManifest pipeline ([[wrkstrm-identifier subcommand
   suite]]).
8. Run the substrate's **launch-review** release gate
   (`wrkstrm-app/.../apps/launch-review/`). Per
   [[release-gate-audience-review]] this requires:
   - UXW review pass (audience-packet stack with `the-entity` at
     ordinal 1 per [[adversarial-audience-the-entity]]
     [[audience-packet-must-precede-content-reference]]).
   - Brand-doc per-field audit per [[brand-docs-must-reflect-rendered-site]].
   - LaunchGate.uxwReviewPassed flag.
9. Report complete with the launch-review receipt path, not just "I
   built the scaffold."

**Why:** Stopping at "scaffold landed" is the [[deferral-is-drift-do-it-now]]
failure mode applied to app authoring — the substrate's whole point is
typed-everything end-to-end, including release readiness. A scaffold
without launch-review certification is *unverified work*; the operator
shouldn't have to chase me through 7 follow-up steps.

**How to apply:** When the operator says "scaffold X" / "build X" /
"give me an app for X" / "make X an app," scope the work as the full
9-step chain above. Bead-track each step on TaskCreate so the chain is
visible to the operator. If something blocks (signing, dep resolution,
missing kit), surface the blocker and quote the exact substep — do not
silently report "scaffold landed."

**Cross-references:**

- [[deferral-is-drift-do-it-now]] — the umbrella anti-drift axiom this
  feedback specializes.
- [[Build Catalyst targets when UIKit is needed]] — when the app needs
  UIKit, scaffold the Catalyst target in the same pass, not after.
- [[Close, delete, then launch]] — the verification discipline at step 5.
- [[Verify product after context compaction]] — for similar reasons:
  product verification before bookkeeping.
- [[release-gate-audience-review]] — what the launch-review gate
  actually checks.
- [[Install paths use /Applications/categories/<kebab-id>]] — install
  destination during step 5–6.
- [[Bundle IDs are derived by wrkstrm-identifier]] — bundle ID
  discipline at step 7.
- [[savepoint-daemon-races-your-commits]] — why each scaffold landing
  needs an explicit commit pass.
