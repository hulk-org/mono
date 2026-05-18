---
name: definitions-are-json-not-markdown
description: Canonical definitions live in typed JSON (or maybe Apple PKL), never plain Markdown — JSON parses into typed Swift code, MD is briefing surface only.
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
Canonical type, policy, contract, schema, and workflow definitions live in
**typed JSON** (or maybe Apple PKL / Pickle). Never plain Markdown.

**Why:** Curry-Howard discipline — JSON parses into a typed Swift model
(e.g., `workflow-schemas v0.1.0 / WorkflowModel`), which gives correct,
verifiable, fast codegen. Markdown is unverifiable human prose; it drifts,
can't be type-checked, and can't compile into anything load-bearing.
Treating an `.md` file as the definitional source ("where X is defined") is
OpenAI-slop posture in a typed substrate. The user has been very explicit:
"we are json people because that can be turned into code correctly and
quickly. MAYBE we adopt the Apple pickle language, but not this."

**How to apply:**
- When sourcing truth for a contract/policy/schema/workflow, look for the
  typed JSON sibling (e.g., `*-orchestrator-default.workflow.json`,
  `*.identity.json`, `*.schema.json`) and read THAT as authoritative.
- Cite the companion MD only as a briefing/walkthrough surface, not as the
  definition.
- When proposing new doctrine, propose the JSON shape (or PKL) first.
  Never propose Markdown as the definition layer.
- When kicking off multi-step substrate-wide work (renames, scaffolds,
  audits), model it as a typed `WorkflowModel` + binding profile and emit
  typed receipts — do not ad-hoc it as a series of MD authoring steps.
