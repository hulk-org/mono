---
name: workflow-json-is-canonical-operating-protocols-deprecated
description: Substrate standardized on workflow.json shape (substrate/workflows/) for typed discipline + execution-graph contracts. operating-protocol-schemas deprecated 2026-05-31. Do NOT author new operating-protocol.json instances.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's canonical typed contract for session-level disciplines + execution-graphs is the `.workflow.json` shape at `private/universal/substrate/workflows/`. The `operating-protocol-schemas` family is **deprecated 2026-05-31**.

**Why:** operator 2026-05-31 (CLIA): "we standardized on workflows though... this might be outdated." Confirmed via question: workflows is canonical, operating-protocols deprecated. Evidence: 15+ `.workflow.json` files at `substrate/workflows/` vs 3 `.operating-protocol.json` files; three workflow schema families (role-workflow-schemas, workflow-graph-doctrine-schemas, workflow-run-metrics-schemas) actively maintained; the existing `winddown-execution-graph-extraction.workflow.json` was authored 2026-05-30 22:23 — 2 hours after operating-protocol-schemas v0.2.0 was cut — already absorbing what wd.operating-protocol.json was trying to be.

**How to apply:**

- **Do NOT author new `.operating-protocol.json` files.** Use the `workflow.json` shape at `substrate/workflows/<version>/<slug>.workflow.json`. Required fields per the workflow.json shape: `bindingProfiles`, `declaredBudget`, `executionStagePolicy`, `executionTarget`, `lifecyclePolicy`, `routineRef`, `runtimePolicy`, `scenarioRef`, `writebackPolicy`, `workSurface`, `workflowId`, `extensions` (where substrate-specific x-prefixed fields go).
- **Substrate-specific discipline lives in `extensions`** — `x-extraction-buckets`, `x-schemaInstancePolicy`, `x-workflow-stages`, `x-error-taxonomy`, `x-manifest-or-refine-step`, `x-template-extraction-discipline`, `x-axiom-citations`, `x-superseded-by`. The wd migration 2026-05-31 added 4 new extension keys to the canonical winddown workflow.
- **For existing operating-protocol.json instances** (wd, thread-spin, wrkstrm-operating-beliefs): mark `deprecated: true` + `supersededBy: { kind: "workflow", path: ... }` at top level; do not refine further. Migration of content to extensions on the corresponding workflow.json tracked as typed bead `substrate-operating-protocol-to-workflow-migration`.
- **Schema-family descriptor marker**: when deprecating a schema family, add `deprecated: true`, `deprecatedAt`, `deprecationNote`, `supersededBy: { schemaFamilyRefs, instanceHome }` to `schema-catalog.family.descriptor.json`. Each version string should also be suffixed with `DEPRECATED <date>`.

**Diagnostic for which schema family is canonical:**

- More existing instances + more recent file modifications = stronger canonical signal.
- Existence of multiple sibling schema families with overlapping purpose = transition state; ask the operator.
- Cross-references in extensions (`routineRef`, `scenarioRef`, etc.) point at the canonical layer; the deprecated layer typically has dangling self-references.

**This session's error sequence**:
1. Authored wd refinements at agents/claude/.../skills/wd/ (personal home — share-by-default error)
2. Moved to collectives/wrkstrm/.../operating-protocols/ (correct community move per wrkstrm-operating-beliefs precedent BUT to the deprecated layer)
3. Operator surfaced "workflows is canonical, operating-protocols deprecated"
4. Migrated content into winddown-execution-graph-extraction.workflow.json's extensions; marked operating-protocol-schemas family deprecated; left wd.operating-protocol.json as snapshot

Each step recovered the prior error; the final state has the doctrine at the canonical workflow layer.

Composes with [[feedback_share-by-default-skills-and-protocols]] (the prior recovery in the same chain) + [[feedback_error-taxonomy-maps-to-workstream-layer]] (this is layer-confusion + contract-clarity in the taxonomy) + [[feedback_wd-extraction-targets-templates-not-runtime-instances]] (the 3-shape ladder — workflow.json at the runtime-binding layer; wd's content sits at the extensions layer of the workflow).
