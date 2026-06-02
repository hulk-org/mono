---
name: tool-to-role-to-workflow-dispatch-graph
description: "The substrate's typed dispatch graph closes via kura-spaces/tools/. Each tool file carries owningWorkflowRef + usedByWorkflows + usedByRoles. Combined with role-surface-manifest.digikomaToolRefs (reverse) and workflow.x-tools-by-stage, all 6 lookup directions over the tool↔role↔workflow graph are typed."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's typed dispatch graph closes when tool → role → workflow lookups are all typed. Per operator 2026-05-31: "basically we can begin to build a kura space of tool to role. role performs workflow. BOOM."

**The six lookup directions over the dispatch graph (all typed as of 2026-05-31):**

| Direction | Source |
|---|---|
| Tool → Workflow (forward) | `kura-spaces/tools/<slug>.tool.json` `owningWorkflowRef` + `usedByWorkflows[]` AND `kura-spaces/substrate-game/v0.1.0/tool-exclusivity-registry.json` |
| Workflow → Tool (reverse) | each workflow's `x-tools-by-stage` extension |
| Tool → Role (the new direction) | `kura-spaces/tools/<slug>.tool.json` `usedByRoles[]` |
| Role → Tool (canonical reverse) | each role's `role-surface-manifest.json` `digikomaToolRefs[]` |
| Workflow → Role (reverse derivation) | each workflow's `x-roles-back-derived-from-tools` extension |
| Role → Workflow (canonical) | each role-workflow's `workflowRef` |

**Why:** before the tools kura space, the substrate had Workflow→Tool, Workflow→Role, Role→Tool, and Role→Workflow typed. But Tool→Workflow (the auto-classifier) and Tool→Role (the dispatcher) were only IMPLICIT — derivable from forward records but not directly queryable. Adding the tools kura space gives the substrate one-hop lookups in all 6 directions, which means dispatch is mechanical: observe a tool, look up its role + workflow, transition state machine accordingly.

**How to apply:** when authoring a new tool:

1. Create `kura-spaces/tools/v0.1.0/<tool-slug>.tool.json` with:
   - `slug`, `name`, `kind`, `command`
   - `exclusivity` (1.0 = auto-classifier; <0.9 = shared)
   - `owningWorkflowRef` (LinkRef to the canonical workflow home)
   - `usedByWorkflows[]` (LinkRefs)
   - `usedByRoles[]` (LinkRefs to META-ROLEs; forward-pointing OK if META-ROLE not yet back-derived)
2. Update the workflow's `x-tools-by-stage` extension to include this tool
3. Update the role's `role-surface-manifest.digikomaToolRefs[]` if the META-ROLE exists
4. Update `tool-exclusivity-registry.json` (or note it's derivable from the kura space)
5. State machine event `exclusive-tool-invoked` auto-fires on invocation; transition to `owningWorkflow` is mechanical

**Per-file substrate doctrine**: tools explode into individual files per `role-classes-as-files-not-catalog`. One file per tool — not one catalog JSON with all tools embedded.

**The substrate's dispatch is now mechanical:** observe tool → lookup file → derive role + workflow → state machine transition. No more silent classification possible at the type level.

**Worked example (2026-05-31)**: 8 canonical classifier-grade tools authored as individual files at `kura-spaces/tools/v0.1.0/`. 11 additional tools (mix of classifier + shared) remain in `tool-exclusivity-registry.json` tracked by bead `back-fill-substrate-tools-kura-space`. Per share-by-default: tools home is community-shared at spaces-universal, not personal.

**Composition**: closes the loop with [[feedback_tool-exclusivity-as-classification-trigger]] (the mechanism that consumes this data) + [[feedback_tools-back-derive-roles-reverse-derivation]] (the reverse direction this kura space supports) + [[feedback_role-classes-as-files-not-catalog]] (the per-file-not-catalog doctrine) + [[feedback_share-by-default-skills-and-protocols]] (tools home is community).
