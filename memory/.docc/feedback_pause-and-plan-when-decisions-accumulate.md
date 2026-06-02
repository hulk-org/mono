---
name: pause-and-plan-when-decisions-accumulate
description: "When working through a multi-step task that starts accumulating side-decisions (memory writes, convention inferences, optional cleanups), stop and surface the integrated plan before continuing. Reactive sub-decisions drift from the original goal even when each looks reasonable."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

When a task accumulates 3+ rounds of side-decisions — memory writes,
convention inferences from terse messages, optional cleanups, "and while
we're at it" tangents — STOP and re-surface the integrated plan before
proceeding. Each individual sub-decision can look reasonable while the
cumulative drift loses alignment with the original goal.

**Concrete instance corrected 2026-05-30:** during incident-closure work I:
- Exploded the role-class catalog into 10 per-file artifacts (substrate
  hygiene → originally intended as Step 0 of incident closure)
- Wrote a memory file about a `.su.json` convention I had inferred from
  two terse operator messages, BEFORE confirming the convention
- Was about to ask a third side-question about the leftover catalog
  metadata when the operator interrupted with `%plan`: "ok, so you are
  acting and doing things without really thinking about them."

Each individual action looked reasonable. The cumulative pattern was
**reactive-not-directed action** — burning operator attention on
side-decisions instead of returning to the integrated plan.

**Why:** in this substrate the operator steers with terse directives.
Terse directives are easy to over-extend ("X should be Y" → I author 10
files + a memory file + 2 side-questions). The discipline is to recognize
when an accumulating chain has drifted from the original goal and
re-anchor.

**How to apply:**

- **Triggers to pause** (any one is enough):
  - About to write a memory file BEFORE the user has confirmed the
    convention/rule it describes
  - About to ask a third clarifying question in a row
  - The current Bash command is for a tangent the user didn't name
  - The next file I'd write is in a different directory than the last
    three (cross-directory drift)
  - I've made 3+ edits without a user nod on the integrated direction
- **The pause itself:** use `EnterPlanMode` (which writes to a plan
  file the user can review), or surface the integrated plan in chat with
  explicit "here's the full picture; here's what I'd do; nod for go." Do
  not just keep going.
- **What goes in the plan:** the current goal, state-of-play (what
  already landed, what's pending), recommended next move with reasoning,
  explicit list of deferred side-quests, decisions still needed from the
  user.
- **The user's `%plan` directive** explicitly triggers this — drop
  everything and write a plan via plan mode.

Composes with the substrate's overall "data is one thing; rendering is a
projection" doctrine: when authoring becomes the *output of reactive
thought*, the artifacts you produce reflect *the path of accumulated
decisions* rather than *the integrated goal*. The pause+plan reset is the
substrate-doctrinal way to keep authored artifacts coherent with intent.
