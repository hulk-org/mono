---
name: substrate-modern-composition-checklist-is-required-spawn-software-proof-gate
description: Spawn-software workstream MUST run substrate-modern-composition checklist (WrkstrmOnboarding + WrkstrmGloss + WrkstrmDesignTokenService + wrkstrm-color + wrkstrm-font + token-system-explainer-page + app-owned-style-identity) as a required proof gate — operator-named 2026-06-04
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# Substrate-modern-composition checklist is a required proof gate in spawn-software

**Rule**: Every spawn-software workstream — whether for a NEW app or a RETROACTIVE typing of existing code — MUST run the substrate-modern-composition checklist as a position-1 design-truth-packet REQUIRED quartet (decision/shape/rationale/rejected) AND as position-2 PRD REQUIRED functional-requirements gate.

**SHARPENING (operator-named 2026-06-04, mid-Launch-Review onboarding-page review)**: There is ONE token SERVICE — `WrkstrmDesignTokenService` — and substrate-canonical token STYLES (gloss-white + jet-black + ...) that the service loads. Apps do NOT compose multiple "token systems"; apps bind THE service, select from substrate-canonical styles, and define an app-owned style identity on TOP of the standard themes. The 5-composed-token-systems framing I had initially was wrong; the LaunchReviewRelease.checklist constants explicitly declared `token-service` + `standard-themes` (gloss-white + jet-black) + `app-style` as three SEPARATE gates with distinct nextAction strings, and I conflated them. Operator quote: *"these token systems are not even right... we should only have 1 token service and then pick token styles: gloss-white, jet-black."*

The corrected checklist:

1. **WrkstrmDesignTokenService** — THE one token service; wired + injected via `.wrkstrmDesignTokenService(...)` + `.wrkstrmComponentStyle(...)` at app root; every view resolves token addresses through the active style, NEVER colors directly
2. **Substrate-canonical token styles loaded** — gloss-white + jet-black at minimum; substrate-canonical (`AppleGlossWhiteTheme` + `JetBlackTheme` live in `wrkstrm-components/private/catalog-cards/.../WrkstrmCatalogCards/`); apps select which to inherit
3. **App-owned style identity** — defined ON TOP OF a standard theme, not as a parallel package; adds domain tints only; selects gloss-white OR jet-black as inherited base
4. **wrkstrm-font** — sibling substrate primitive (separate concern from token styling); in deps; imported; `Font.wrkstrm(.role)` resolution replaces hardcoded `Font.system(...)` calls where canonical roles fit
5. **wrkstrm-color** — sibling substrate primitive (separate concern from token styling); in deps; imported; consumed for HSL math + contrast validation + Palette.Wrkstrm typology
6. **wrkstrm-gloss** — sibling substrate primitive; in deps; imported; `.wrkstrmGloss { ... }` modifiers on EVERY primary affordance with substrate-doctrine content (NO literal `[[wikilink]]` brackets per `[[audience-packets-apply-to-apps-not-just-web]]`)
7. **WrkstrmOnboarding** — sibling substrate primitive; in deps; canonical `WrkstrmOnboardingFlow` with versioned `@AppStorage` gate + Show Onboarding command menu re-demo
8. **Token-service + style-architecture explainer page** — onboarding page that NAMES the architecture honestly: ONE service + canonical styles + app's identity layer. (Not "five composed token systems.")
9. **Audience-packet-driven UI text** — per `[[audience-packets-apply-to-apps-not-just-web]]`; user-facing strings come from typed audience packets, not Swift literals
10. **Audience-review proof gate** — sits between Code (position 5) and QA (position 6+1) in the substrate work sequence; UXW department verifies all checklist items

**Why**: Operator-named 2026-06-04 mid-Launch-Review-session after I authored a launch-review-packet claiming `advance-to-operator` while Launch Review's OWN `LaunchReviewRelease.checklist` constants (in `LaunchReviewCore.swift` lines 96-119) explicitly declared `token-service` + `standard-themes` + `app-style` + `copywriting-review` + `secret-surface-review` + `localization-review` as `.blocked` gates with explicit `nextAction` strings. The substrate's typed records were TELLING the agent the gaps; the agent rubber-stamped the rerun anyway. Operator quote: *"so every app should have an onboarding and demo right? this app doesn't have that. it also doesn't have the tokens service... why are we not using standard components in spawn-software?"*

This is the same failure mode the META-recursive CUJ `[[cuj-launch-review-director-self-reviews-launch-review-app]]`'s FM-003 was designed to guard against ("Director approves without actually walking the evidence — rubber-stamp the recursion"). Agent tripped it on the first run by treating existing implementation as good-enough rather than running the explicit checklist that already lived in the substrate's typed records.

**How to apply**:

- **Position 1 (design-truth-packet)**: each of the 7 checklist items gets a load-bearing decision with explicit decision/shape/rationale/rejected. If checklist item is genuinely-not-applicable (e.g., CLI tool with no UI surface), the decision quartet still gets authored explicitly naming WHY it's degenerate.
- **Position 2 (PRD)**: each missing checklist item becomes an FR with acceptance criteria. Each present item becomes a success criterion the audit-already-passed.
- **Position 3 (CUJ)**: at minimum one CUJ per primary affordance covered by gloss + one CUJ for first-time-operator-walks-onboarding.
- **Position 4 (Bug+Epic)**: one bug per missing checklist item. Epic is umbrella.
- **Position 5 (CODE)**: dependencies + imports + canonical composition lands.
- **Position 6 (QA)**: build + manual visual smoke check per CUJ + magazine-editorial-or-brand-identity-preserved check.
- **Position 7 (LaunchReviewPacket)**: explicit substrate-modern-composition-checklist-state field listing each item's pass/blocked status with evidence ref.

**Anti-pattern caught**: the "lightweight retroactive workstream" shape — author records that NAME existing code without running the substrate-modern audit. This is the rubber-stamping failure. Substrate-correct retroactive workstreams apply the checklist EVEN harder than greenfield runs because existing code has accumulated drift.

**Composes with**: [[feedback-onboarding-demo-gloss-are-prd-cuj-proof-surfaces]] (the upstream doctrine — proof surfaces) + [[design-and-product-first-code-last]] (the 7-position sequence) + [[feedback-issue-found-means-entire-spawn-software-rerun]] (any gap triggers rerun) + [[walter-discipline]] (compose substrate-canonical primitives) + [[feedback-common-and-mono-are-the-platform-engineers]] (token-service is platform engineering) + [[approval-recursion-grounds-at-operator-identity]] (operator-attested rubber-stamping is the recursion failure mode) + [[data-is-one-thing-rendering-is-projection]] (token-service is the projection layer) + [[no-typealias-no-export-no-breadcrumb]] (substrate-canonical composition kills local divergence).

**Substrate workflow update bead-tracked**: the substrate's canonical `spawn-software.workflow.json` at `kura-spaces/workflows/spawn-software/` should be updated to bake this checklist into the workflow's x-required-proof-gates. Spawn-software workflow update is its own substrate-doctrine improvement bead — operator can prioritize.
