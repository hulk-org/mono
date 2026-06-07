---
name: harnesses-agnostic-models-constrain
description: "Harnesses can host any agent persona; the binding/modification axis is the MODEL, not the harness"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

Harnesses (hulk, codex, gemini, clide, apple-pi, digikoma, pi, ...) are **agent-agnostic carriers** — any of them can host any agent persona. They don't modify the persona; they just provide the runtime environment.

**The real constraint axis is the MODEL.** When an agent (chatgpt, claude, spark, ...) is bound to a specific model line, that binding forces capacity, context, and evolution constraints. Sometimes an agent persona CANNOT swap to a different model — the model IS what makes the persona viable at that form.

**Why:** Substrate's founding-breach split treats carrier (harness) and persona (agent) as orthogonal. The harness contract says "I can host this persona"; the model contract says "this persona can run on this model line at these capacities." Conflating the two leads to misrepresenting model-line constraints as harness-modification semantics — a category error.

**How to apply:**
- In any UI/data shape: represent harnesses as carriers without per-agent deltas. Don't author a "harness modifies agent" view.
- The `extensions.x-*` fields on agents like spark (`x-parent-agent: chatgpt`, `x-model-line-id: codex-spark`, `x-form-class: chibi`, `x-capacity-class: compact`, `x-context-class-id: TK:64K`, `x-evolution-level: -2`, `x-agent-form-binding: <path>`) encode **model-line + form constraints**, not harness-applied deltas. The relationship to render is `agent -> bound-model-line -> form-variant`, not `agent + harness -> modified-persona`.
- When discussing the substrate's modification semantics: speak of model constraints, not harness modifications. Reserve "harness" vocabulary for "which carrier is currently running this persona right now" (a runtime-state question, not an identity question).
- The substrate has first-class model entities at `private/universal/substrate/models/<slug>/` (e.g., `anthropic-claude-3-5-sonnet`). The agent ↔ model edge lives there + in agent extension fields, not on the harness.

Related: [[reference_apple-generable-canonical-architecture]] (Apple's @Generable enforces this same orthogonality at the API surface — the model is the constraint dial, the runtime host is interchangeable).
