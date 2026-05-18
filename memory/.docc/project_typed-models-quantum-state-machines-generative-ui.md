---
name: typed-models-quantum-state-machines-generative-ui
description: The substrate's typed-everything work (constraints, NonEmpty, role-named protocols, same-shape doctrine, schema battle) is the precondition for QUANTUM STATE MACHINES and GENERATIVE UI — the long game is types-as-spec from which UI, verification, and visualization are mechanically derived.
type: project
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
The substrate's typed-everything investment (LinkRefModel.Target variants,
NonEmpty<T> wrappers, role-named protocols, schema battle, same-shape
doctrine, compile-time constraints) is **scaffolding for two converging end
states**:

1. **Quantum state machines** — state machines whose entire state space
   is enumerable at compile time. Every state, every event, every
   transition is typed and exhaustive. Curry-Howard applied to
   time-varying systems. From one typed declaration the substrate can
   mechanically generate: (a) state diagram visualization, (b) SwiftUI
   navigation flow, (c) "current state, possible next actions" UI panel,
   (d) formal verification report.

2. **Generative UI** — UI that is GENERATED from the type, not
   hand-coded against it. Stringly-typed models produce stringly-typed
   UIs (text fields). Typed models with exhaustive variants produce
   typed UIs (pickers, segment controls, state diagrams). Adding
   `NonEmpty<Target>` means the generated form knows the list must
   have at least one element — without anyone telling the UI generator.

**Why:** The user has been explicit that the substrate is converging
toward types-as-spec from which the UI surface is derived: "we want to
enable quantum state machines and swift data models which are very
specific + convey meaning that we can use to create generative UI."
This connects to the broader "ship 10 apps/day via FoundationModels"
project — typed models are what FoundationModels can reason over,
typed state machines are what generative UI can render.

**How to apply:**
- When designing a new schema/type, ask "what UI would be generated
  from this?" If the answer is "a text field" the type isn't typed
  enough — refine the variants until the generated UI is meaningful.
- WorkflowLifecyclePolicy is the immediate substrate refactor candidate:
  states should be typed enum cases, transitions should be a `case`
  exhaustive map, the engine should be able to render a graphviz/mermaid
  diagram from the declaration.
- Compile-time constraints (per
  feedback_constraints-belong-in-types-not-tests.md) are the
  precondition for this — generative UI can only safely generate from
  types that the compiler has already verified. Runtime preconditions
  don't compose into UI generation safely.
- This trajectory pairs with on-device Apple FoundationModels: the
  models that the typed substrate emits are what FoundationModels can
  reason over, render, and act on. Generative UI + typed models +
  on-device judgment is the ship-10-apps-a-day stack.
