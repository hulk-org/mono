---
name: feedback-onboarding-demo-gloss-are-prd-cuj-proof-surfaces
description: "Onboarding + demoing + gloss-on-every-actionable-element are the substrate's typed PRD/CUJ proof surfaces. They aren't UX polish — they're the AGENT'S CONCRETE EVIDENCE that every product requirement (PRD) + every critical user journey (CUJ) has been implemented. If all three exist and are complete, the implementation matches the design; if any is missing or incomplete, the agent has identified the precise gap. Operator-attested 2026-06-04 mid-Presense-spawn-software-retrofit. Every substrate package/app must ship the triad before launch-review."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

Onboarding + demoing + tooltips/gloss are the substrate's TYPED PRD/CUJ PROOF SURFACES. The agent's certainty that "this app implements what we designed" comes from the three surfaces existing AND being complete.

**Operator-attested verbatim 2026-06-04** (delivered after I authored Presense's retroactive spawn-request-packet):

> "so, we need to make sure that onboarding, demoing, tooltips, etc are all built so that YOU can also know that you built all the PRD and CUJs"

**The doctrinal reframe:**

PRD (Product Requirements Document) and CUJ (Critical User Journey) are not separate authored documents that live in some bead-track. They are the UNION of three rendered surfaces:

| Surface | What the surface IS | What its completeness PROVES |
|---|---|---|
| **Onboarding** (multi-step walkthrough on first launch or operator-invoked from menu) | Step-by-step demonstration of every CUJ | Every critical user journey has a walkthrough → CUJs are implemented end-to-end |
| **Demoing** (demo mode / demo content with example entries) | Example data exercising every feature path with sample inputs | No dead code, no orphan UI surfaces, no "you'd need real data to see this" gaps |
| **Gloss** (persistent-not-tooltip explanatory hover/tap text on every actionable element — wrkstrm-gloss, not .help) | Per-element purpose declaration | Every button/badge/control/chip/state-marker has a documented purpose → no mystery affordances |

**The substrate-coherent agent posture for any new app:**

When the agent thinks "did I implement everything?" — the answer comes from checking the triad:
1. Can I onboarding-walkthrough every CUJ? If not, which step is missing? → that's the missing implementation
2. Can demo mode exercise every feature path? If not, which path lacks demo data? → that's the orphan UI OR the missing feature
3. Does every actionable element have a gloss? If not, which control lacks an explanation? → that's the un-designed affordance OR the un-purposed feature

The triad gives the agent a STRUCTURAL self-audit that doesn't require reading external PRD documents. The substrate's typed agentic discipline IS the triad.

**Composes with the existing substrate Package shape:**

This doctrine RETROACTIVELY EXPLAINS the wrkstrm-components canonical Package shape that the substrate has been using:

- Every wrkstrm-components package ships: SPM library + demo-app + onboarding-walkthrough + .docc index
- The demo-app structure (Package.swift + Sources/<...> + project.yml + demo .docc) is exactly the substrate's triad
- The onboarding flow inside the demo (5-step walkthrough → demo surface) is the CUJ proof
- The hover/tap glosses on demo elements are the affordance proof

Every substrate package has been DOGFOOD-ING this doctrine without it being named. The operator-attested doctrine is the explicit naming.

**For app-level substrate Apps (not just library packages):**

A launch-review-ready substrate App MUST ship:
1. First-launch onboarding flow (or operator-menu-invocable replay) walking through every CUJ
2. Demo mode toggle exposing the App's full feature surface against synthetic data
3. WrkstrmGloss (or equivalent persistent-tap-to-show explanatory surface) on every interactive element

If the App lacks any of these, the spawn-software workstream's spawn-readiness gate REFUSES to pass + the LaunchReviewPacket cannot be submitted.

**Applied immediately to Presense:**

Presense.app currently has:
- ✅ WrkstrmOnboarding package dependency wired (project.yml carries WrkstrmOnboarding product)
- ❌ NO onboarding flow ever authored using it — the dep is dormant
- ❌ NO demo mode — Presense reads real share records from rismay's gh-pages directory
- ⚠️ PARTIAL WrkstrmGloss coverage — added gloss to Annotate + SORTED legend earlier this session; toolbars/filters/badges/verdict UI/etc. don't have gloss

Per this doctrine, Presense CANNOT pass spawn-readiness OR submit LaunchReviewPacket until the triad is complete. The retroactive spawn-request-packet I just authored should be updated to reflect this requirement.

**Composes with:**

- [[spawn-software-workstream-required-for-tool-authoring]] — the workstream this doctrine extends; spawn-readiness gate REQUIRES the triad
- [[release-gate-audience-review]] — launch-review's audience review check now includes the triad's existence
- [[wrkstrm-gloss vs tooltip]] — gloss is the right shape for the "purpose declaration" surface; .help() is wrong shape
- [[App asks must reach launch review]] — the chain from operator-asks-for-app to launch-review-submitted runs through the triad
- [[per-scene-independent-spm-packages]] — packages ship onboarding+demo+gloss as part of their canonical shape
- [[wrkstrm canonical one-liner — app studio for creators]] — substrate's app-studio doctrine; every shipped App proves itself via the triad

**Implementation order for any new App:**

1. Author PRD-as-CUJ-list — bullet list of every critical user journey the App enables
2. Author spawn-request-packet enumerating CUJs + feature surfaces
3. Implement CORE FEATURES first
4. Wire WrkstrmGloss on every actionable element with purpose-explanation glosses
5. Author demo mode toggle + demo content exercising each CUJ
6. Author onboarding flow walking through each CUJ with arrow pointers to actual UI elements
7. Audit: can the agent demonstrate every CUJ via the onboarding flow? If yes → spawn-readiness passes
8. Submit LaunchReviewPacket with the triad as evidence
