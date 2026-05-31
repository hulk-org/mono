---
name: wd-extraction-targets-templates-not-runtime-instances
description: "/wd extraction targets WORKSTREAM-template and WORKFLOW-template (light typed contract shapes), NOT workflow.json runtime instances. Templates are the reusable doctrine surface; workflow.json is the heavy per-run binding."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

`/wd` extraction for surfaced doctrine targets typed TEMPLATES — `workstream-template.json` + `workflow-template.json` (or `workflow-series.json` for sequences) — NOT `workflow.json` runtime instances.

**Why:** the substrate has three related typed shapes that look similar but serve different layers:

1. **workstream-template.json** — STRUCTURAL contract of a reusable workstream. Required fields: `schemaVersion`, `slug`, `title`, `summary`, `deliverables[]`, `instructions[]`, `outcomes[]`, `reviewGates[]`, `tasks[]`, `doccPath`, `handoffOutputs[]`, `metrics[]`, `privacyRules[]`, `productPackages[]`. Optional but common: `childWorkstreamRefs[]`, `deliverableSchemaRefs[]`, `stewardRoleRefs[]`, `workflowSeriesRef`, `workflowStages[]`.
2. **workflow-series.json** — SEQUENCE of workflows in a workstream. Required fields: `id`, `kind`, `summary`, `title`, `workflows[]`, `workstreamRef`, `roleSurfaceRef`, `proofRefs[]`, `momentLinkSet`. Captures the ORDERED set, not the runtime binding.
3. **workflow.json** — RUNTIME-BINDING instance. 20+ required fields: `bindingProfiles`, `declaredBudget`, `executionStagePolicy`, `executionTarget`, `lifecyclePolicy`, `routineRef`, `runtimePolicy`, `scenarioRef`, `writebackPolicy`, etc. This is the per-run cast; NOT what doctrine extraction produces.

Operator 2026-05-31 (CLIA, after I filed workflow-typing as beads instead of authoring): "remember that we want to do workflow TEMPLATE extraction" + "and WORKSTREAM extraction". The correction is precise: doctrine surfaces as TEMPLATES; runtime instances are bound per-session.

**How to apply:** when /wd extracts a surfaced workflow/pattern doctrine to typed substrate:

- Author `<slug>.workstream-template.json` at `private/universal/substrate/collectives/wrkstrm/private/universal/kura-spaces/spaces/workstreams/collections/<slug>/` (top-level reusable workstreams) OR under `.../sub-workstreams/<parent>/sub-workstreams/<slug>/` (child of an existing workstream).
- Pair with `index.md` at the same path declaring the workstream's purpose, structural shape, and pointers to the gate-set + workflow-series if any.
- If the workstream has an ordered sequence of workflows, also author `<slug>.workflow-series.json` at `private/universal/substrate/collectives/wrkstrm/private/universal/kura-spaces/series/workflows/<slug>/`.
- DO NOT author workflow.json files during /wd extraction — those are per-run runtime instances, not doctrine. Workflow.json shape requires scenario/routine/binding profiles that are session-specific.
- Beads for workflow.json authoring are appropriate when the runtime binding is needed; beads for workstream-template/workflow-series authoring are NOT — those should land inline as part of /wd.

Composes with [[feedback_spawn-software-workstream-required-for-tool-authoring]] (the broader workstream-discipline doctrine) + [[feedback_typed-axioms-as-typed-tribal-knowledge]] (templates are typed tribal knowledge for workstream-shape).
