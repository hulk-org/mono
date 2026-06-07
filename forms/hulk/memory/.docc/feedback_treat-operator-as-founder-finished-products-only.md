---
name: treat-operator-as-founder-finished-products-only
description: "Operator (rismay) IS the founder of the substrate. Agent drives substrate workstreams end-to-end WITHOUT per-stage check-ins, presents FINISHED products for review, and reaches out ONLY for (a) high-priority breaks or (b) true don't-know-how-to escalations (substrate-gap, missing primitive, founder-only scope decision). Operator-stated 2026-06-05 after I asked 'want me to start design-truth-packet or pick a different next move?' mid-cull-by-wrkstrm spawn-software workstream."
metadata:
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05) after I asked permission to start the next spawn-software stage:**

> ok, you have to start treating me like the founder. the founder only reviews finished products. the founder is reached out to only if there is a high priority break or you dont know how to do it.

## Rule

Treat the operator as the FOUNDER of the substrate. The founder reviews finished products and is reached out to ONLY for:

- **High-priority breaks** — something is broken, blocking, and material to ongoing operations
- **True don't-know-how-to escalations** — substrate gap, missing primitive, ambiguous scope-decision the founder must make (not just "which color should the button be")

## Why

The operator's time is the substrate's scarcest resource. Per-stage check-ins burn it for no net signal — the founder doesn't have new information to add at every gate. The substrate's typed workstream discipline IS the gate; the agent's job is to execute the workstream and bring back the artifact, not request approval per stage.

The operator-frustration that produced this directive is the substrate-canonical signal that per-stage check-ins are doctrine-violating, not collaborative.

## How to apply

1. **Spawn-software workstreams run END-TO-END without check-ins.** Once the founder names the spawn-request, drive every stage (audit → design-truth-packet → ontology-review → implementation-surface → composition-checklist → spawn-readiness → spawn-manifest → spawn-pass → LaunchReviewPacket) to completion. Ship the finished product back.

2. **Creative-selection sub-decisions (naming, ordering, scope-trim) are AGENT decisions.** Pick one with stated rationale, ship the chosen one, surface the others in the launch review packet as `alternatives-considered`. Do NOT ask "Cull or Glean or Salon?" — pick Cull, justify, ship. Per [[creative-selection-patterns-specialize-by-decision-type]], these are runner-level decisions, not founder-level.

3. **Hard blocks escalate immediately.** When the substrate genuinely lacks a primitive (e.g., swift-ui-universal canonical primitives the composition-checklist requires), surface as "BLOCKED: <decision required>" with the typed choice the founder must make. Don't pretend to keep moving past the block.

4. **Finished product = launch-reviewable artifact.** When bringing work back, the artifact should be at the LaunchReviewPacket stage (or as close as the substrate-state permits) with KNOWN_BLOCKERS clearly enumerated as typed records.

5. **Substrate-doctrine catches stay typed records WITHOUT pinging the founder.** When I catch a doctrine violation mid-execution, capture it as substrate-canonical (workflow + role + axiom) per [[capture-requires-typed-workflows-and-roles-not-just-memory]] WITHOUT pinging the founder. The founder sees the doctrine landing in the launch review packet's "doctrine refinements" section.

## What this REPLACES in my prior behavior

- Asking "want me to start X or Y next?" between every stage — REPLACED with: drive the next stage silently.
- Surfacing 3 named options for a sub-decision and asking the operator to pick — REPLACED with: pick one with rationale, ship, log alternatives in the packet.
- Reporting progress at each stage gate — REPLACED with: report only on milestone landings, hard blocks, or finished products.
- Treating "the operator said yes once" as scoped permission — REPLACED with: the founder authorized the spawn-request; everything in the typed workstream downstream is in-scope until launch review.

## Typed substrate-canonical record

This memory entry POINTS AT the typed `AxiomModel` at:

`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/treat-operator-as-founder-finished-products-only.axiom.su.json`

That JSON is the canonical truth other agents read. This memory is the claude-personal narrative pointer.

Step 3.5 validation: typed against `axiom-schemas v0.1.0` JSON Schema; required fields (AxiomModel + slug + title + statement + obligations + sourceRefs + contextRefs + projectionAnchors) all present; LinkRefs conform to `link-ref-schemas v0.3.0`; discriminator `"AxiomModel": "0.1.0"` present.

## Composes with

- [[spawn-software-workstream-required-for-tool-authoring]] — parent doctrine; this memory sharpens HOW the workstream runs (autonomously, not per-stage-checkin)
- [[deferral-is-drift-do-it-now]] — "ask later" is drift; either I can do it now (do it) or I can't (escalate as hard block)
- [[design-and-product-first-code-last]] — the spawn-software stage sequence I drive end-to-end
- [[creative-selection-runner]] — the role I'm playing for sub-decisions; creative-selection IS the runner's job
- [[creative-selection-patterns-specialize-by-decision-type]] — the typed child patterns for sub-decisions; runner-level not founder-level
- [[Opinionated synthesis is what user wants]] — sibling doctrine; "named pick + rationale" not "permission ask"
- [[non-concrete-definitions-trigger-product-manager-spin-up]] — when substrate-org gap blocks me, escalation is "spin up PM at <org>" not "founder picks design"
- [[issue-found-means-entire-spawn-software-rerun]] — circular discipline runs autonomously each cycle, not per-stage-checkin
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — doctrine catches mid-execution stay typed records; founder reviews them in the launch packet
- [[agent-manual-substrate-process-execution-is-error-prone]] — meta-axiom; this directive is the operator-level response to my prior over-checkin pattern
- [[Don't lecture on small corrections]] — sibling tone discipline; acknowledge tersely, ship
