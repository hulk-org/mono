---
name: form-is-universal-binding-pattern
description: "Form is a universal variant-binding pattern that applies to ANY organism kind (agent, audience, collective, human-operator) — not just agents. Operator-stated doctrine 2026-05-30."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c5a791f0-7c27-4647-986a-a89122fc8571
---

**Form is universal across organism kinds.** Operator-stated 2026-05-30: "the reason i feel like ghost should be a form is because I see the collective - for example - the entity working like this. or a digital agent."

The form pattern is a variant-binding axis that applies polymorphically across ANY organism kind. The substrate had grasped HALF of this (form-axes/ kura collection already enumerates capacity-binding, evolutionary, information-flow), but the FormModel itself encoded the wrong constraint: `parentAgentRef: LinkRefModel` baked in "form is for agents only."

**Why:** Three forcing examples falsify the agent-only constraint:
1. **rismay-ghost** = form-of-rismay (human-operator) via `ghost-projection` form-axis
2. **The Entity variants** = forms-of-the-entity (audience/collective) via something like `adversary-specialization` form-axis (silicon-valley-extractor, competitor-replicator, etc.)
3. **Digital agent runtime forms** = forms-of-agent via `runtime-specialization` form-axis (claude-coder, claude-reviewer)

Plus the already-known capacity-binding pattern: codex/eliza/spark/symphony as forms-of-chatgpt.

**How to apply:**
- `FormModel.parentAgentRef` must generalize to `parentRef: LinkRefModel` in form-schemas v0.2.0, accepting any organism kind as the form's parent.
- New form-axes get added to `kura/collections/form-axes/` as they're identified. Each form-axis names a kind of variance.
- ghost-projection is the form-axis for AI-projections of human operators; rismay-ghost is the canonical example.
- DON'T model ghost as an OrganismAspect or a separate OrganismKind. It's a form-binding.
- DO add a `ghost-summoner` role-class for the accountability shape of producing/supervising ghost-forms.
- The form pattern is the substrate's typed answer to "this thing is a variant of that underlying thing" across any axis of variance.

Composes with [[feedback_codex-is-a-form-of-chatgpt]] (canonical agent-form precedent) and [[feedback_seasonal-digikoma-forms]] (canonical digikoma-form precedent — themed/seasonal axis). Both fit the universal pattern.

Doctrine reframe: ghost is not its own organism kind, not an aspect — it's a form-binding. The substrate's ontology pares down: aspect retires `ghost` and `orchestrator` slots; class catalog gains `orchestrator` and `ghost-summoner`; form-schemas v0.2.0 generalizes `parentAgentRef` → `parentRef`.
