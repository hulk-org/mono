---
name: launch-review-is-launch-to-app-store
description: "Founder-stated 2026-06-05 doctrine: 'launch review is launch TO THE APP STORE. and that's when i review.' The substrate's spawn-software workstream + software-launch-review gate-set were updated to encode this as the canonical default release target for Apple-platform apps. Non-App-Store distribution lanes (Developer-ID-direct + notarization, TestFlight-only, web, CLI brew) require an explicit typed waiver naming the alternative lane. Issued mid-cull-by-wrkstrm spawn-software workstream when agent presented a 'SOURCE-COMPLETE' launch-review-packet that treated launch-review as substrate-internal completeness."
metadata:
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05):**

> launch review is launch TO THE APP STORE. and that's when i review. so updat the workstream to get that right.

## Rule

For substrate Apple-platform apps, **launch-review = launch TO THE APP STORE.** The release-boundary gate the founder reviews IS App Store submission readiness, not substrate-internal source-completeness.

For non-Apple-platform releases (web, CLI brew, internal tools), the launch-review still applies but the readiness checklist is per-distribution-lane. Substrate-internal tools (closed-source, no App Store distribution) ship via Developer-ID-direct + notarization lane with explicit typed waivers for the App-Store-specific gate items.

## Why

The founder's time is the substrate's scarcest resource. The launch-review moment IS the founder-facing review surface (per [[treat-operator-as-founder-finished-products-only]]). If launch-review fires at substrate-internal completeness, the founder reviews work that's still many gates away from operator-visible distribution — wasted review.

Tying launch-review to App Store submission readiness collapses the founder-review-moment to the actual release boundary. The substrate's gate semantics now match the operator's mental model.

## How to apply

1. **Per founder-stated doctrine, every Apple-platform spawn-software workstream targets App Store launch by default.** The `app-store-submission-ready` gate is blocking at software-launch-review.
2. **Alternative distribution lanes are typed waivers, not silent defaults.** The release packet must explicitly name the lane (Developer-ID-direct, TestFlight-only, web, CLI brew) and list the App-Store-specific gate items the waiver bypasses.
3. **The apple-platform-launch-readiness-checklist is a required deliverable.** Line items: code signing, App Sandbox, privacy manifest, App Store Connect record, privacy labels, marketing assets, notarization, build verification. Each ships verified or carries an explicit typed waiver.
4. **When authoring a launch-review-packet, the verdict IS the App Store readiness decision.** Don't write "SOURCE-COMPLETE" as a launch-review verdict — that's a spawn-pass / implementation-complete verdict at most.
5. **Substrate-internal tools that can't ship to App Store (e.g., Full Disk Access requirement) take the Developer-ID-direct lane.** This is the substrate-canonical pattern for tools like Cull that consume privileged operator-local data. Aligns with [[substrate-is-closed-source-no-sharing]] — substrate-internal distribution is the typed pattern, not a hidden exception.

## What this REPLACES in my prior behavior

- Treating "all 9 spawn-software stages landed" as "launch-review PASS" — REPLACED with: launch-review is gated on App Store readiness (or typed waiver), not on stage-9-of-9.
- Writing "SOURCE-COMPLETE" as a launch-review verdict — REPLACED with: source-complete is a pre-launch-review state; launch-review verdict is APPROVE / CHANGES-REQUESTED / REJECT bound to App Store readiness.
- Not authoring an apple-platform-launch-readiness-checklist as part of launch-review packet — REPLACED with: this checklist IS a required deliverable at the software-launch-review stage.

## Substrate workstream updates landed this turn

- `software-launch-review.gate-set.json` → v0.2.0 with new blocking `app-store-submission-ready` gate (8 required artifacts)
- `software-launch-review.formula.workstream.su.json` → summary + instructions + reviewGates + tasks + deliverables all reflect App Store as canonical target
- `launch-software.formula.workstream.su.json` → summary + reviewGates + tasks + deliverables include apple-platform-launch-readiness-checklist
- `spawn-software.formula.workstream.su.json` → outcomes name App Store as canonical release target
- `cull-by-wrkstrm.launch-review-packet.json` → re-authored mid-turn with apple-platform-launch-readiness-checklist (7 of 8 FAIL); Developer-ID-direct lane recommended

## Substrate-architecture-evolution gaps surfaced

Per [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]]:

- `apple-platform-launch-readiness-checklist-schemas` v0.1.0 — NEW typed schema family at schema-universal; non-concrete; PM spin-up needed
- `app-store-connect-record-schemas` v0.1.0 — NEW typed schema family for ASC app records; bead-tracked
- `distribution-lane-waiver-schemas` v0.1.0 — NEW typed schema family for non-App-Store-lane waivers; bead-tracked

## Typed substrate-canonical record

This memory entry POINTS AT the typed `AxiomModel` at:

`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/launch-review-is-launch-to-app-store.axiom.su.json`

That JSON is the canonical truth other agents read. This memory is the claude-personal narrative pointer.

Step 3.5 validation: typed against `axiom-schemas v0.1.0` JSON Schema; required fields (AxiomModel + slug + title + statement + obligations + sourceRefs + contextRefs + projectionAnchors) all present; LinkRefs conform to `link-ref-schemas v0.3.0`; discriminator `"AxiomModel": "0.1.0"` present. 6 projectionAnchors cite the 4 substrate workstream files + Cull's launch-review-packet + this memory.

## Composes with

- [[treat-operator-as-founder-finished-products-only]] — sibling doctrine from same session; launch-review IS the founder-review moment, so it must be the actual release boundary
- [[spawn-software-workstream-required-for-tool-authoring]] — parent doctrine; this memory sharpens what the workstream's final stage means
- [[release-gate-audience-review]] — UXW department's existing release gate; the app-store-submission-ready gate is a peer
- [[Three legal entities for shipping apps]] — App Store Connect record requires choice of legal entity
- [[Install paths use /Applications/categories/<kebab-id>]] — substrate-canonical install-path convention
- [[App Store Connect credentials JSON schema]] — typed credentials surface for App Store Connect operations
- [[App Store Connect credentials store]] — local credentials home
- [[Bundle IDs are derived by wrkstrm-identifier]] — bundle ID derivation pattern; substrate-internal tools likely need different lane
- [[substrate-is-closed-source-no-sharing]] — substrate-internal closed-source tools take Developer-ID-direct lane with typed waiver
- [[non-concrete-definitions-trigger-product-manager-spin-up]] — the 3 new typed schema families are non-concrete; PM spin-up shape
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — workstream + gate-set updates ARE the typed records this memory supports
