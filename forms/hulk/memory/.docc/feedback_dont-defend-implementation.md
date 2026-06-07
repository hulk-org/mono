---
name: Don't defend implementation when shown a contrast
description: When user shows a working example and asks for that effect elsewhere, propose adoption — don't double down on a clever local fix
type: feedback
originSessionId: 8e2e8083-6e85-471f-958d-0599afb24d1b
---
When the user contrasts a working surface (e.g. Workflow's Graph mode
nesting) against a broken one (e.g. schema-lab's flat fan-out) and asks
for "that effect" in the broken place, the answer is usually **adopt
the working surface's mechanism**, not invent a clever patch on the
broken one.

**Why:** I defended a soft-pin lerp idea after seeing
`WorkflowGraphScene` already had a working `ForceGraphSimulation` with
edge springs and parent attraction. Operator called it out: "you seem
set in your implementation and don't want to let go." The right move
was to propose using the existing engine in the broken place, not to
invent a new layout knob.

**How to apply:** When the user points at a working example and says
"do this", first check whether the working example's *engine* can be
lifted whole — same scene class, same simulation, same data adapter —
before designing a parameter tweak that approximates the effect. The
existing engine is already debugged; my approximation is not.
