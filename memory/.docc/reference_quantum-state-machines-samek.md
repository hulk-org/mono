---
name: quantum-state-machines-samek
description: "Quantum state machines" is Miro Samek's Quantum Leaps / QHsm (Quantum Hierarchical State Machine) pattern — Harel statecharts implementation, NOT quantum mechanics; "Quantum" is the company name; first published in Embedded Systems Programming August 2000.
type: reference
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
When someone says **"quantum state machine"** in a software context, they
almost certainly mean **Miro Samek's Quantum Leaps QHsm** pattern — a
**Harel statechart** implementation with hierarchy, orthogonal (concurrent)
regions, and run-to-completion semantics. The "Quantum" is the company
name (Quantum Leaps LLC), not quantum mechanics, and not formal
verification by itself.

**Canonical sources:**
- [state-machine.com](https://www.state-machine.com/) — Quantum Leaps
- [GitHub: QuantumLeaps/State-Oriented-Programming](https://github.com/QuantumLeaps/State-Oriented-Programming) — original code
- [Practical Statecharts in C/C++ (PSiCC) — book PDF](https://www.state-machine.com/doc/PSiCC.pdf) — Samek's book
- First published in *Embedded Systems Programming*, August 2000
- [CHSM — Concurrent Hierarchical Finite State Machine](https://chsm.sourceforge.net/) — sibling implementation

**Substance:**
- Hierarchical states (states-within-states; nested behavior inheritance)
- Orthogonal regions (concurrent state machines within one composite state)
- Run-to-completion (RTC) — events are processed atomically, no interleaving
- Active Object framing — the state machine is an actor with its own queue
- Used heavily in embedded systems (real-time, deterministic)

**Why it matters in this substrate:**
- Swift's `enum` + associated values + exhaustive `switch` is unusually
  close to QHsm in expressive power; far cleaner than C++ vtable hacks
  Samek had to ship.
- `WorkflowLifecyclePolicy` is the substrate's de-facto state machine
  surface today; lifting it to a typed enum-of-states + typed-event +
  typed-transition map is a "quantum state machine" in this sense.
- Adopting Harel statechart vocabulary (states/hierarchy/regions/RTC)
  inherits a 30-year body of formal semantics + tooling (UML statecharts,
  SCXML).

**What it is NOT:**
- Not quantum mechanics
- Not formal verification by itself (you can layer SMT/model-checking on top)
- Not concurrency theory (CSP, π-calculus) — it sits in the
  state-machine/statechart family
