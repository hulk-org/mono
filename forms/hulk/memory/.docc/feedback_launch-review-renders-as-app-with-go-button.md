---
name: launch-review-renders-as-app-with-go-button
description: "Founder-stated 2026-06-05 doctrine closing the launch-review arc: launch-review surfaces as a Mac app (existing scaffold at wrkstrm-core/private/apple/apps/launch-review/). The app loads the typed launch-review-packet as central content, aggregates signoffs from all upstream gates, and surfaces a GO button that triggers the actual release execution (xcodebuild archive + notarytool + upload-to-ASC for App Store, or typed-waivered alternative-lane equivalent). REJECT + CHANGES-REQUESTED buttons are peers. Founder-review IS the moment GO is enabled-or-not."
metadata:
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05):**

> so launch review goes like this: you open the app with the packet brought up.
>
> the packet is going to have the signoff's from all the gates.
>
> then that app will have a button which will let me launch the release ready, QA'ed app.

## Rule

The substrate's `software-launch-review` workstream surfaces as a typed Mac app. The launch-review experience is:

1. **Open the app with the packet brought up** — the typed `<slug>.launch-review-packet.json` loads as the app's central content
2. **The packet shows signoffs from all gates** — the signoff aggregator pulls typed gate verdicts (PASS / PARTIAL / BLOCKED / DEFERRED with evidence + nextAction) from the upstream spawn-software stage records
3. **The app has a GO button** — when all blocking gates PASS (or carry typed waivers for alternative distribution lanes), GO triggers the substrate-canonical release-action primitive that orchestrates the actual distribution (App Store: xcodebuild archive + notarytool + upload-to-ASC; Developer-ID-direct: archive + notarytool + substrate-internal channel; TestFlight / web / CLI brew: lane-specific execution)
4. **REJECT + CHANGES-REQUESTED are peer buttons** — per the explicit-decision-recorded gate, all three decisions are atomic (single screen, single press, typed record)

## Why

The founder reviews finished products (per [[treat-operator-as-founder-finished-products-only]]) at the launch-review moment (per [[launch-review-is-launch-to-app-store]]). The CONCRETE surface where the founder enacts this review must itself be a substrate-typed app — not a JSON file, not a CLI, not a chat exchange. The Launch Review app IS the founder-review surface, fully realized.

The substrate already has the app scaffolded at `wrkstrm-core/private/apple/apps/launch-review/` with LaunchReviewCore + LaunchReviewApp modules + typed `LaunchReviewReleaseGate` (status / evidence / nextAction / blocksPublicRelease fields) + DEVELOPMENT_TEAM set for real App Store distribution. v0.2 is the founder-named SHAPE: packet renderer + signoff aggregator + GO button + release-action primitive.

## How to apply

1. **The Launch Review app at `wrkstrm-core/private/apple/apps/launch-review/` is the substrate-canonical surface.** Other apps' typed launch-review-packets are OPENED IN THIS APP, not viewed inline in a JSON editor.
2. **The packet IS central content** per [[chrome-over-content-is-substrate-doctrine-violation]]. The packet renderer reads the typed JSON and renders sections (summary + audienceReviewVerdict + whatShipped + alternativesConsidered + founderDecisionsRequired + knownBlockers + doctrineRefinementsLandedThisSession + applePlatformLaunchReadinessChecklist + verdictForFounderReview + founderActions) in operator-readable form.
3. **The signoff aggregator walks the `predecessorRef` chain.** Each upstream typed record (universal-best-practices-audit-receipt → design-truth-packet → ontology-review-receipt → implementation-surface-receipt → composition-checklist → spawn-readiness → spawn-manifest → spawn-pass) contributes its gate verdict to the aggregator.
4. **The GO button enables ONLY when all blocking gates PASS (or carry typed waivers).** GO press: records typed `software-launch-review-decision` per gate-set v0.2.0 + triggers the typed `release-action` primitive for the declared distribution lane.
5. **The release-action primitive is lane-specific.** For App Store: xcodebuild archive + notarytool + upload-to-ASC. For Developer-ID-direct: archive + notarytool + substrate-internal channel. For other lanes: per-lane execution.
6. **Spawn-software workstreams output launch-review-packets the app can render.** Cull's `cull-by-wrkstrm.launch-review-packet.json` is the FIRST typed packet matching this shape (already authored with applePlatformLaunchReadinessChecklist + founderDecisionsRequired + verdictForFounderReview).

## Typed substrate-canonical record

This memory entry POINTS AT the typed `AxiomModel` at:

`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/launch-review-renders-as-app-with-go-button.axiom.su.json`

That JSON is the canonical truth other agents read. Companion typed records this turn:

- `private/universal/substrate/collectives/wrkstrm/private/universal/kura-spaces/workstream/formula/spawn-software/instances/launch-review-app-v0.2.spawn-request-packet.json` — spawn-request packet for the v0.2 increment (packet renderer + signoff aggregator + GO button + release-action primitive)

Step 3.5 validation: typed against `axiom-schemas v0.1.0` JSON Schema; required fields all present; LinkRefs conform to `link-ref-schemas v0.3.0`.

## Substrate-architecture-evolution gaps surfaced

Per [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]]:

- `release-action-schemas v0.1.0` — NEW typed schema family for the lane-specific release-execution primitive (App Store / Developer-ID-direct / TestFlight / web / CLI brew dispatch); bead-tracked at schema-universal
- `launch-review-app-packet-rendering-schemas v0.1.0` — typed contract for what the app loads + renders; bead-tracked
- All prior gaps from earlier this session carry forward (apple-platform-launch-readiness-checklist-schemas + app-store-connect-record-schemas + distribution-lane-waiver-schemas + safari-bookmarks-schemas + creative-selection-candidate-schemas + 11 prior /capture gaps)

## Composes with

- [[launch-review-is-launch-to-app-store]] — parent doctrine; this axiom names the APP-form realization
- [[treat-operator-as-founder-finished-products-only]] — sibling doctrine; this app IS the founder-review surface
- [[chrome-over-content-is-substrate-doctrine-violation]] — packet IS central content; signoffs + GO button are functional surface
- [[dual-consumer-for-ghost-touching-surfaces]] — launch-review has both app (human) + CLI/digikoma (agent) projections; launch-review-cli + launch-review-digikoma already scaffolded at wrkstrm-research/.../gym/
- [[data-is-one-thing-rendering-is-projection]] — packet is data; app is projection
- [[Lens packet — substrate vocabulary for rendered sublens output]] — app emits typed lens-packets for the projection
- [[release-gate-audience-review]] — audience-review gate composes with app-store-submission-ready gate
- [[Install paths use /Applications/categories/<kebab-id>]] — launch-review installs at /Applications/categories/productivity/
- [[Bundle IDs are derived by wrkstrm-identifier]] — me.rismay.launch-review.macos.release follows the substrate-canonical pattern
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — workstream + spawn-request packet ARE the typed records this memory supports
