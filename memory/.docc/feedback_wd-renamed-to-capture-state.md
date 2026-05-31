---
name: wd-renamed-to-capture-state
description: "wd skill renamed to capture-state per the wd-as-capture (Pokémon ball throw) doctrine. The skill name now reflects the substrate's verb-genealogy completion (winddown → write-down → capture). Full cascade tracked as typed cascade-task instance."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The wd skill is renamed to **`capture-state`**.

Operator 2026-05-31 (immediately after the wd-as-capture Pokémon ball doctrine + event-is-chat-turn landed): "we should rename wd to 'capture state'".

**Verb-genealogy completion:** winddown → write-down → CAPTURE. The skill name now reflects the doctrine. Three reframes across the substrate's life:

1. **wd v1** = winddown (passive end-of-session bookkeeping)
2. **wd v2** = write-down (active verb but still passive intent — recording facts)
3. **capture-state v3** = CAPTURE (active state transition — throw the Pokémon ball at the wild workflow moment before it escapes)

**Why "capture-state" specifically (not just "capture")**: per `everything-is-quantum-state-machine` axiom, the substrate is a QHsm. State is the QHsm vocabulary; capture is the transition verb. "Capture state" = "transition the workflow moment from un-captured-wild state to typed-substrate-record state." The compound name carries both the action (capture) AND the substrate's QHsm framing (state).

**Cascade scope**: substantial. Touches:

- 3 axioms (canonical-write-surface-is-techo, wd-does-not-report-derived-metrics, winddown-incomplete-until-committed)
- 1 workflow directory (kura-spaces/workflows/winddown-execution-graph-extraction/ → capture-state-execution-graph-extraction/)
- 1 deprecated operating-protocol (wd.operating-protocol.json)
- substrate-session-state-machine.json state slug + transitions
- tool-exclusivity-registry.json owningWorkflow refs
- tool kura space files (agent-timeline-cli-append-winddown-*.tool.json)
- substrate/skills/wd/ → substrate/skills/capture-state/
- AGENTS.md references
- Multiple feedback memories at ~/.claude/memory/.docc/

**Typed cascade-task authored 2026-05-31** at `kura-spaces/workflows/cascade-task-creation/instances/wd-to-capture-state-rename.cascade-task.json` with:

- `errorInventory`: 2 entries (contract-clarity, layer-confusion)
- `expectedPostCascadeState`: buildClean + testsPass + jsonValidates + additionalChecks (no-stale-wd-references + capture-state-typed-records-exist)
- `submoduleGroups`: 3 (spaces-universal, wrkstrm, hulk)
- `monoRootGroup`: AGENTS.md + skills/ + roles/
- `operatorApproved: false` — pending operator confirmation before cascade-execution runs
- This cascade-task IS the perfect dogfood test case for the cascade-task-creation + cascade-execution workflow pair authored same session.

**Immediate updates landed inline (2026-05-31)** before full cascade:

- substrate-session-state-machine state slug `wd` → `capture-state` with `renamedSubStates` block + previousStateId markers + Pokémon-ball metaphor in state description
- Transition `* + context-limit-approaching → capture-state` (previously → wd)

**Per breaks-are-good-no-transition-shims axiom**: full rename is hard cut. No aliases. The cascade-execution will sweep stale references; consumers break; we walk the compile/grep errors.

**Composition**: this rename is the **substrate capturing its own name into typed truth** — the wd skill name was a wild Pokémon escaped from the doctrine for too long; this cascade catches it. Beautiful recursion.

Composes with [[feedback_wd-is-capture-pokeball-throw]] (the doctrine that motivated the rename) + [[feedback_everything-is-quantum-state-machine]] (state-machine framing of "capture state") + [[feedback_breaks-are-good-no-transition-shims]] (hard-cut discipline) + [[feedback_substrate-wide-cascade-pattern]] (multi-submodule cascade per cascade-task).
