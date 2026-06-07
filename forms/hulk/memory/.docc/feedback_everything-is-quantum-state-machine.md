---
name: everything-is-quantum-state-machine
description: "The substrate's deepest synthesis — every typed entity IS a Samek QHsm. Sessions, workflows, roles, cascade-tasks, workstreams, tool invocations all collapse into typed states + events + transitions + RTC + orthogonal regions + compile-time exhaustive. Curry-Howard's program=proof shape IS the state-machine shape."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's unifying theory. Promoted to typed `AxiomModel.everything-is-quantum-state-machine` 2026-05-31.

Operator 2026-05-31 (end of substrate-game design session, after the tool→role→workflow dispatch graph closed): "everything is a state machine. everything is quantum."

**The statement:** every typed substrate entity — session, workflow, workstream, role, cascade-task, schema-family, packet, persona, organism, identity, tool-invocation, axiom — IS a Samek QHsm (Quantum Hierarchical State Machine, per Quantum Leaps LLC's pattern, NOT quantum mechanics).

**Why:** the substrate has been authoring QHsm fragments all session without naming the unifying shape. Each typed entity has states + events + transitions + run-to-completion + orthogonal regions composing. The axiom names what the substrate was already doing.

**Six+ confirmed instances** (cascade-pattern 3x-rule satisfied):

1. Sessions — substrate-session-state-machine.json (11 states + 15 events + 18 transitions + 3 orthogonal regions + RTC)
2. Workflows — every workflow.json has x-stages + events + transitions + per-stage RTC
3. Roles — role-surface-manifests with stateRefs + role-workflows with states + exitGate per state
4. Cascade-tasks — expectedPostCascadeState IS a typed state predicate; cascade-execution transitions toward it
5. Workstreams — spawn-software's 11 typed gates ARE states with failureDispositions = illegal-transition penalties
6. Tool invocations — exclusive-tool-invoked event triggers typed transitions; tool-exclusivity registry IS the event handler

**How to apply:**

- When authoring any typed entity, ASK: what are its states? events? transitions? RTC boundary? If unclear, the entity isn't typed enough yet.
- Express composition via QHsm hierarchy (states-within-states), not flat enums with discriminator fields.
- Use orthogonal regions for concurrent independent dimensions (per substrate-session-state-machine.json: minimization-tracker + error-inventory-tracker + audience-presence-tracker run concurrently with main session state).
- Enforce RTC: queue mid-stage operator directives; let current stage complete atomically; then transition.
- Every typed entity should be expressible as Swift enum + associated values + exhaustive switch — if it can't, refine until it can.
- Generative-UI readiness is the diagnostic test: if the entity DOESN'T enable mechanically-derived state diagrams + current-state panels + scoreboards, the typing isn't QHsm-complete yet.

**Curry-Howard connection**: types are propositions; programs are proofs. The QHsm shape inherits this — the typed state machine IS a proof that lawful transitions cover the state space. Swift exhaustive switch IS the proof check; unhandled case IS a compile error IS a proof-fails-to-type-check.

**What this axiom forbids:**

- Untyped any-fields in typed entities (partial proofs)
- Flat enums where QHsm hierarchy would express composition cleanly
- Mid-stage state-mutation (violating RTC)
- Authoring typed entities without naming states + events + transitions

**Composition**: this axiom is the substrate's TOP-LEVEL synthesis. All earlier axioms (cascade-pattern, typed-tribal-knowledge, tool-authoring-runs-spawn-software, retroactive-packetization, data-vs-projection-test-architecture) are state-machine fragments — specific transitions or illegal-states in specific entities. The substrate-game's win/loss conditions are typed predicates over trajectories. The dispatch graph is event-handler binding. Generative UI is rendering over typed state machine. All collapse into THIS axiom.

References:
- Axiom: substrate/collectives/spaces-universal/.../kura-spaces/axioms/everything-is-quantum-state-machine.axiom.su.json
- Doctrine page: substrate/collectives/spaces-universal/.../kura-spaces/substrate-game/v0.1.0/everything-is-quantum-state-machine.md
- Samek QHsm reference: reference_quantum-state-machines-samek.md (PSiCC book + Quantum Leaps github)
- Generative-UI long game: project_typed-models-quantum-state-machines-generative-ui.md

Composes with [[feedback_substrate-wide-cascade-pattern]] (3x rule that earned this promotion) + [[feedback_typed-axioms-as-typed-tribal-knowledge]] (the substrate naming what it was already doing) + every other typed-substrate doctrine — they're all state-machine fragments at lower abstraction layers.
