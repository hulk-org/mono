---
name: cost-model-non-divergence-discipline
description: "Substrate forward discipline: every new cost-bearing typed primitive must EXPLICITLY name which inference-account-schemas types it composes with — not just 'composes with the cost layer.' Audit-first catches initial duplication ([[audit-schema-universal-before-authoring-new-types]]); non-divergence prevents future drift. Every cost-related authoring bead must enumerate its 'composesWithExistingTypes[]' list in the description. Test discipline: round-trip checks across cost-model boundaries detect divergence at build time. Operator-stated 2026-05-26 after the encumbrance audit revealed inference-account-schemas v0.2.0 already had 25+ typed primitives the new work would have duplicated."
metadata:
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-stated 2026-05-26 immediately after the encumbrance-doctrine cohort beaded: *"let's make sure that the encumbering and cost models in schema-universal do not diverge."* The concern is substrate-critical: cost-bearing primitives that semantically duplicate without explicit composition WILL drift, eventually producing disagreeing cost totals across layers.

## The rule

Every new cost-bearing typed primitive in schema-universal MUST:

1. **Audit first** per [[audit-schema-universal-before-authoring-new-types]] — discover what already exists.
2. **Compose explicitly, not parallel** — the new primitive's Codable shape references existing types (`InferenceUsageEvent`, `InferenceCostEstimate`, `InferenceQuota`, etc.), not redefines equivalent fields.
3. **Declare the binding in the bead description** — every cost-authoring bead carries an explicit "composesWithExistingTypes:" list naming the substrate types it builds on. Audit-then-author isn't enough; the binding must be SOURCE-DOCUMENTED so future agents reading the bead see the dependency.
4. **SPM-depend on the existing package** — at the Swift package layer, the new schema-family depends on inference-account-schemas (or whichever existing cost-family). Compilation enforces the binding.
5. **Round-trip tests across layers** — if Layer-B primitive aggregates Layer-A events, write a test that synthesizes Layer-A events + verifies Layer-B totals match. Behavioral check at build time.

## Why this matters

Substrate's `inference-account-schemas v0.2.0` already has 25+ typed cost primitives. The 2026-05-26 encumbrance work (`SessionStaminaCeiling`, `AbilityPerformanceInvoice`, etc.) was on track to duplicate ~7 of them — `InferenceUsageEvent`, `InferenceCostEstimate`, `InferenceQuota`, `InferenceRateLimit`, `InferenceCircuitBreaker`, `InferenceTokenPriceBand`, `InferenceContextClass`. If those duplications had shipped:

- substrate-side cost-reporting would have TWO sources of truth
- they'd inevitably diverge as either schema-family evolved independently
- cost totals in the encumbrance layer wouldn't match cost totals in the inference-account ledger
- substrate's "VC-pitchable economic legibility" thesis would fail at the first audit

The non-divergence discipline catches this at AUTHORING TIME by forcing explicit composition declarations BEFORE the new types ship.

## How to apply (the discipline)

**When authoring a new cost-related primitive:**

1. Run the audit per [[audit-schema-universal-before-authoring-new-types]] — read inference-account-schemas v0.2.0 + execution-cost-ledger-schemas + subscription-cost-schemas + inference-budget-gate.
2. For each field you'd add to the new primitive, ask: "Does this field equivalent already live in an existing type?"
3. If YES → COMPOSE — make the new primitive a wrapper / extension / aggregate that REFERENCES the existing type, doesn't redefine its fields.
4. If NO → author the new field, but document WHY no existing type captures it.
5. In the bead description that proposes the authoring, include:
   ```
   composesWithExistingTypes:
     - InferenceUsageEvent (sourced from inference-account-schemas v0.2.0)
     - InferenceCostEstimate (same)
     - InferenceQuota (same)
   newFieldsRationale: |
     <prose explaining why each NEW field doesn't have an existing equivalent>
   ```
6. SPM dependencies on existing packages MUST be declared. Compilation catches missing references.
7. Tests round-trip: synthesize existing-type events → verify new-type aggregation matches. Fails at build time if divergence introduced.

**When updating an EXISTING cost-related primitive:**

1. Search for downstream consumers: `grep -r 'InferenceUsageEvent' --include='*.swift'` etc.
2. If the change is breaking, EVERY downstream type must be updated synchronously. No "fix-later" updates.
3. Tests in BOTH the existing package AND all downstream packages must continue passing.

## The substrate-doctrine continuity

This is the FORWARD companion to [[audit-schema-universal-before-authoring-new-types]] (initial-state discipline):

- **Audit-first**: prevent INITIAL duplication when authoring new shapes
- **Non-divergence**: prevent FUTURE drift after initial alignment
- **[[same-shape-same-model]]**: two structs with identical field shapes are ONE model — the principle the discipline enforces
- **[[every-property-fights-for-its-life]]**: when an embedded property graduates to a typed family, the graduating primitive composes the existing family, doesn't parallel it

## Why bead descriptions matter (not just code review)

Substrate's bead descriptions are READ BY FUTURE AGENTS who may not remember (or may not have been alive for) the original audit. If the bead description says "compose with the cost layer" (vague), future-agent might re-derive the composition incorrectly. If the bead description says explicitly:

```
composesWithExistingTypes:
  - InferenceUsageEvent (v0.2.0) at .../inference-account-schemas/v0.2.0/sources/InferenceUsageEvent.swift
```

...future-agent knows EXACTLY which existing type to reach for, with version + path. The dependency is durable across context-compactions and inter-session handoffs.

## When NOT to apply

- **The new primitive genuinely captures a dimension nothing existing covers**: author it, document the rationale, add a forward-link from the existing nearby type to the new one.
- **Existing types are themselves due for deprecation/rewrite**: in that case, the AUTHORING bead becomes a REWRITE bead — refactor both surfaces together, don't pile new on top of doomed.
- **The new primitive is in a different domain from cost**: doctrine narrows to cost-related work. Other domain-pairs may have different convergence concerns.

## Related substrate doctrine

- [[audit-schema-universal-before-authoring-new-types]] — initial-state companion
- [[same-shape-same-model]] — the principle this discipline enforces
- [[every-property-fights-for-its-life]] — graduation-with-composition pattern
- [[substrate-sync-cost-pattern-2026-05-26]] — the canonical pattern this discipline protects from divergence
- [[ordinality-table-entries-immutable-once-released]] — freeze discipline complements non-divergence discipline (both prevent silent breakage)
- inference-account-schemas v0.2.0 — the 25-type cost-primitive surface every cost-related bead must explicitly reference
