---
name: tool-exclusivity-as-classification-trigger
description: "Tool-exclusivity is a classification trigger. If a tool can ONLY be used by workflow X, invoking that tool IS the signal that the session is in workflow X. Auto-classify on exclusive-tool-invoked event; audit silent classification by walking the tool-invocation log."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate classifies sessions into known workflows via TWO mechanisms:

1. **Operator-directive pattern matching** (forward): operator words → candidate workflow via `unknown-workflow.x-candidate-workflow-mapping.patterns[]`
2. **Tool-exclusivity observation** (reverse): tool invocation → owning workflow via `tool-exclusivity-registry.json`

Operator 2026-05-31: "so to begin with we add the required tools to unknown workflow instances... and if we know a tool can ONLY be used by a specific workflow, then that is the trigger that we are actually in a known workflow."

**Why this matters:**

- **Classification without explicit declaration**: tool-use auto-classifies even when the operator never used a named trigger (`/wd`, `/cascade`). An agent invoking `agent-timeline-cli append --kind winddown.session` IS in wd, declared or not.
- **Silent-classification detection**: audit query — walk a session's tool-invocation log; any exclusivity >= 0.9 tool invoked outside the corresponding workflow state is a typed `silent-classification` error per `unknown-workflow.x-error-taxonomy`.
- **Minimization composability**: tool-exclusivity-detection drops `residence-turn-count` to zero — the moment an exclusive tool fires, the session is OUT of `unknown-workflow`. Operator-named triggers (`/wd`, `/cascade`) are themselves exclusive tools in this framing.

**How to apply:**

- **Define exclusivity per tool** in a typed registry. Exclusivity is `1.0 / N` where N is the number of distinct workflows that use the tool. `>= 0.9` is auto-classifier grade.
- **Examples of exclusive tools (classifier grade)**:
  - `agent-timeline-cli append --kind winddown.{session,journal,expertise}` → wd
  - writing `isRetroactive: true` packets → retroactive-packetization
  - creating typed packets at `spawn-software/instances/` → spawn-software
  - creating new `workflow.json` files at `kura-spaces/workflows/<slug>/v<X.Y.Z>/` → workflow-creation
  - executing pre-approved cascade-task commits → cascade-execution
  - moving pure-function files from `sources/<exe>/` to `sources/<lib>/` → library-extraction-for-testability
  - operator-named triggers (`/wd`, `/cascade`, `%thread-spin`) → their respective workflows
- **Shared (non-classifier) tools**: `git status`, `swift build`, `swift test`, `jq` — these contribute as ONE signal among many, not as auto-classifiers.
- **Composition with candidate-workflow-mapping**: both run; whichever produces a confident match first triggers the transition. When both produce matches, they must AGREE; otherwise that's an inconsistency error.
- **Auditing**: substrate can mechanically detect silent classification by walking tool-invocation logs vs declared workflow state.

**Registry home**: `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/substrate-game/v0.1.0/tool-exclusivity-registry.json`

**Mechanism extension on unknown-workflow**: `x-classification-via-tool-exclusivity` carries the mechanism (read registry → observe tool invocations → auto-transition on exclusivity >= 0.9).

**State machine event + transitions**:
- `exclusive-tool-invoked` event added (kind: tool-classifier)
- Transition `unknown-workflow + exclusive-tool-invoked → owningWorkflow` (kind: tool-exclusivity-auto-classification)
- Transition `informal-mode + exclusive-tool-invoked → owningWorkflow` (kind: tool-exclusivity-re-entry; logs silent-classification error)

**Future work**:
- Most workflows lack `x-tools-by-stage` data; registry is forward-pointing for them. Back-derive tools per workflow → populate registry.
- Substrate-wide silent-classification audit tool walking tool-invocation logs is a candidate skill.

Composes with [[feedback_tools-back-derive-roles-reverse-derivation]] (same x-tools-by-stage source data) + [[feedback_error-taxonomy-maps-to-workstream-layer]] (silent-classification is workstream-skip + contract-clarity) + [[feedback_share-by-default-skills-and-protocols]] (operator-named triggers are themselves community-defined exclusive tools).
