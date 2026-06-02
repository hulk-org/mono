---
name: substrate-sync-cost-pattern-2026-05-26
description: "Substrate's canonical cost-sync pattern, extracted from the practiced inference-control implementation (commit 2be1bb9bc4 2026-05-22). Generalized: every cost-bearing substrate operation declares typed cost, emits typed invoices per invocation, writes to an append-only ledger that composes with inference-account-schemas v0.2.0. The pattern's first practiced expansion is inference-control sync-cost observability. Future expansions: ability invocations, vault-app calls, lens-app renders, form instantiations, harness operations. Operator-stated 2026-05-26 after the ability-cost-doctrine discussion: 'we want to use this pattern I just described and basically expand on it!'"
metadata:
  node_type: memory
  type: insight
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Substrate's first practiced cost-sync implementation shipped 2026-05-22 (commit `2be1bb9bc4 wd 2026-05-22: sync-cost observability`) on the wrkstrm-app inference-control surface, backed by `inference-account-schemas v0.2.0`. The operator named this work as the canonical pattern substrate should EXPAND across every cost-bearing operation — not a one-off.

This memory extracts the pattern as substrate-doctrine in its own right. Ability-cost (per [[agent-abilities-pokemon-mechanics-with-topology-2026-05-26]]) is the first scheduled expansion; others follow.

## Encumbrance refinement (operator-stated 2026-05-26 immediately after pattern memory)

Operator extended the pattern with TES (Elder Scrolls) encumbrance framing: per-invocation invoices answer "what did this call cost?" — but sessions accumulate WEIGHT against a STAMINA CEILING. 5-hour stamina stints are a real substrate constraint, not metaphor. Substrate needs typed visibility into "how close to the wall?" so behavior can adjust (acquire / discharge / auto-winddown).

Key refinement: the **SessionStaminaCeiling is COMPOSITE** — depends on `(harness × model × operator-policy)`. NOT a fixed number. Computed from:
- **HarnessStaminaProfile** — per-harness rate-limits, session-wall-clock conventions
- **AIModelFamilyOrdinalityTable** DNA traits — `inferenceCostShape`, future `contextWindowSizeClass` (already beaded earlier today), provider rate-limits
- **OperatorPolicy** — substrate-side caps, user budget preferences, dailies

Encumbrance becomes Layer 5 of the canonical pattern. Substrate response varies by pressure level (idle / light / moderate / heavy / at-ceiling / over-ceiling) — at `heavy`+ substrate auto-discharges unused abilities; at `at-ceiling` substrate auto-triggers winddown.

## The pattern (canonical form)

Every cost-bearing substrate operation declares the same FIVE typed layers:

1. **Typed cost declaration** — what does this operation cost?
   - composes existing primitives: `AIModelFamilyInferenceCostShape`, `subscription-cost-schemas`, `execution-cost-ledger-schemas`, `inference-account-schemas`
   - declared once per operation type (e.g., wd ability declares context-weight + per-invocation compute + financial)
   - frozen or operator-mutable depending on stability

2. **Typed invoice per invocation** — what did this specific run actually cost?
   - emitted at the moment of invocation completion
   - carries: operation slug, agent slug, invoked-at timestamp, measured cost (tokens consumed, USD spent, wall-clock seconds, context-weight loaded)
   - typed Codable record (per operation-type, e.g., AbilityPerformanceInvoice, LensRenderInvoice)
   - immutable after emit

3. **Append-only ledger** — timeline of invoices per scope
   - per-agent, per-session, per-day, per-substrate aggregations
   - lives in kura-timeline-tier per [[kura-storage-typology]]
   - format: JSONL stream of typed invoices (same shape as Shinji Techo lanes — proven substrate pattern)
   - composes with `inference-account-schemas v0.2.0` as the account-side accumulator

4. **Diagnostic surface** — queryable cost intelligence
   - per-agent: "claude spent $X today across N invocations"
   - per-operation: "wd costs avg $Y per run; range $Y_low - $Y_high"
   - cross-cutting: "this session has consumed Z% of operator's daily budget"
   - feeds into [[lens-apps-substrate-pattern]] as a typed lens-app rendering the cost data

5. **Session encumbrance** (NEW 2026-05-26 — TES framing per operator)
   - cumulative cost against `SessionStaminaCeiling`
   - ceiling COMPOSED from (HarnessStaminaProfile × AIModelFamilyOrdinalityTable DNA × OperatorPolicy) — NOT fixed
   - per-axis encumbrance: context-weight % + financial % + wall-clock % + rate-limit %
   - typed `EncumbrancePressureLevel` ordinal (idle / light / moderate / heavy / at-ceiling / over-ceiling)
   - substrate-policy responses: heavy → discharge unused abilities; at-ceiling → auto-winddown; over-ceiling → refuse new work
   - operator-visible `SessionEncumbranceLens` per [[lens-apps-substrate-pattern-2026-05-18]]
   - composes with AIModelFamilyInferenceCostShape (electricity-only families have effectively no financial ceiling; mid-per-token families consume financial encumbrance fastest)
   - composes with AIModelFamilyContextWindowSizeClass (beaded earlier today) — bigger context = higher context-weight ceiling

## What inference-control practiced (the precedent)

- **Code location**: `private/universal/substrate/collectives/wrkstrm-app/private/apple/apps/inference-control/` (mirrored at `kura-org/private/apple/apps/inference-control/`)
- **Typed surface**: `inference-account-schemas v0.2.0`
- **Operator-captured expertise**: `agents/chatgpt/memory/.docc/expertise/inference-control-gemini-shader-pacing.md` — the lessons learned during implementation
- **Hulk project memory**: `harnesses/hulk/memory/.docc/project_inference-control.md` + `project_inference-control-nerv-session.md`
- **Substrate-tracked bead**: `sync-cost-weekly-session-drilldown.issue.json`

These artifacts are the substrate-doctrine REFERENCE MATERIAL. Future cost-sync expansions read them first.

## Scheduled expansions (per the doctrine)

Substrate has many cost-bearing operations that should adopt this pattern. Listing the ones already-doctrinally-aware:

| operation domain | doctrine memory | expansion status |
|---|---|---|
| Inference calls (LLM) | inference-account-schemas v0.2.0 + inference-control app | ✓ PRACTICED (2026-05-22 precedent) |
| Ability invocations (per-skill execution) | [[agent-abilities-pokemon-mechanics-with-topology-2026-05-26]] | 🟡 BEADED (this session) |
| Vault-app calls (MCP replacement) | same memory + [[kura-storage-typology]] | 🟡 BEADED (this session) |
| Lens-app renders (per-lens execution) | [[lens-apps-substrate-pattern-2026-05-18]] | ⚪ NOT YET BEADED |
| Form instantiations (per-form materialization) | [[agents-have-forms-2026-05-25]] | ⚪ NOT YET BEADED |
| Harness operations (per-harness lifecycle event) | [[harnesses-agnostic-models-constrain]] | ⚪ NOT YET BEADED |
| Digikoma executions (per-bounded-executor invocation) | [[substrate-is-digikoma-factory-2026-05-23]] | ⚪ NOT YET BEADED |

Each row eventually adopts the same 4-layer pattern. The cost surface becomes substrate-wide queryable economics.

## How to apply (for any new expansion)

1. **Read the precedent** — inference-control implementation + inference-account-schemas v0.2.0 + chatgpt's expertise memory. Internalize the gotchas before authoring.
2. **Identify the cost dimensions** for the new operation — token consumption? wall-clock? USD? context-weight? combination?
3. **Author the typed cost declaration** — composes existing primitives; does NOT define new cost-event semantics from scratch.
4. **Author the typed invoice shape** — extends/parallels InferenceAccount cost-sync events with operation-specific fields.
5. **Author the append-only ledger** — kura-timeline-tier; same shape as Shinji Techo + AbilityAcquisitionLedger.
6. **Wire the diagnostic surface** — lens-app-style queries over the ledger; per-agent, per-session, cross-cutting aggregations.

## Why this works as substrate doctrine

- **Pattern-replication beats novel architecture**: substrate has practiced cost-sync once successfully. Mirroring the pattern is cheaper, lower-risk, more legible to future agents than re-inventing per domain.
- **Composability**: every cost-bearing operation feeds the same account model. Substrate-wide cost reporting becomes a single query over the union of all ledgers.
- **VC-narrative scalability**: per the [[model-families-as-dna-2026-05-26]] DNA doctrine, substrate's "fixed-cost compute → unbounded form production" thesis depends on substrate-quantifiable per-operation economics. Sync-cost pattern is the substrate-tooling that makes the narrative substantively true.
- **Operator visibility**: every cost-bearing surface becomes operator-diagnosable. "Where did my spend go this week?" becomes a typed query over the ledger union.

## When NOT to apply

- **Trivial-cost operations** (read a file, compute a hash, query an in-memory data structure) — the invoice overhead exceeds the cost being tracked. Substrate-doctrine reserves cost-sync for operations with non-trivial economic footprint.
- **Operations substrate doesn't own** (third-party APIs called by substrate-external code) — substrate can't authoritatively measure cost it didn't pay. Reference the external surface; don't shadow-track.
- **Pre-commit / pre-release exploratory work** — the cost-sync doctrine applies to shipped substrate operations. Research scaffolding may skip until the surface stabilizes.

## Related substrate doctrine

- [[agent-abilities-pokemon-mechanics-with-topology-2026-05-26]] — first scheduled expansion; ability-cost composes this pattern
- [[lens-apps-substrate-pattern-2026-05-18]] — future expansion; per-form economics depends on this pattern
- [[agents-have-forms-2026-05-25]] — forms are cost-bearing instantiations; this pattern applies
- [[substrate-is-digikoma-factory-2026-05-23]] — bounded executors with typed cost; same pattern
- [[model-families-as-dna-2026-05-26]] — substrate's VC narrative depends on per-form economic legibility this pattern enables
- [[audit-schema-universal-before-authoring-new-types]] — apply BEFORE every expansion; the existing surface usually composes with substrate's cost primitives
- [[ordinality-table-entries-immutable-once-released]] — freeze discipline applies to enum case mappings within cost shapes
- inference-control implementation (commit `2be1bb9bc4`) — the PRACTICED reference
- agents/chatgpt/memory/.docc/expertise/inference-control-gemini-shader-pacing.md — operator-captured lessons
