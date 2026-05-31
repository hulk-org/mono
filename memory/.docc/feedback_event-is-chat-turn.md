---
name: event-is-chat-turn
description: "The substrate's fundamental event quantum IS the chat turn. One chat turn = one event arriving at the session-state-machine. RTC semantics ground out at the chat-turn level. Tool invocations within a turn are sub-events observed by orthogonal regions."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's fundamental event quantum IS the chat turn.

Operator 2026-05-31 (during everything-is-quantum-state-machine + capture-doctrine teach-me-Curry-Howard session): "also, the event... is the chat turn."

**Why this matters:**

In Samek QHsm vocabulary, events are the discrete signals that drive transitions. The substrate's QHsm runtime semantics needed to specify WHAT counts as an event. Per this doctrine: **one chat turn = one event at the session-state-machine level.**

**RTC consequence**: per `everything-is-quantum-state-machine` axiom's run-to-completion semantics — the agent's response to a chat turn completes atomically before the next turn's event fires. Operator interrupts mid-response are queued; not interleaved. This is the substrate's discipline against state corruption.

**Event hierarchy:**

- **Chat-turn level**: one operator message ↔ one agent response. This is the substrate's RTC boundary. State transitions named in `substrate-session-state-machine.transitions[]` fire here.
- **Sub-event level**: within a single chat turn, the agent may invoke multiple tools. Per `tool-exclusivity-registry`, each tool invocation is an `exclusive-tool-invoked` event observed by orthogonal regions (minimization-tracker, error-inventory-tracker, audience-presence-tracker). Sub-events do not violate RTC at the session level because they're inside one chat-turn's RTC boundary.
- **Priority events**: `context-limit-approaching` and `session-close` are priority events that can preempt the normal turn-by-turn flow.

**Minimization consequence**: `x-minimization-program.residence-turn-count` is measured in CHAT TURNS because chat turns ARE the events. Reducing residence-turn-count means "classify in fewer chat-turn events." This is why operator-named triggers (`/wd`, `/cascade`) drop residence to 1 turn — they're single-turn classification.

**Pattern matching examples:**

| Chat-turn event | State-machine transition |
|---|---|
| Operator says "/wd" | unknown-workflow → wd (via operator-says-wd named-trigger event) |
| Operator names a tool to author | unknown-workflow → spawn-software (pattern-classification handoff) |
| Operator surfaces "you skipped X workstream" | spawn-software → retroactive-packetization (mid-workflow recovery) |
| Agent invokes `agent-timeline-cli append --kind winddown.session` within a turn | exclusive-tool-invoked sub-event → auto-classify session to wd |
| Agent's response completes | turn-complete event → ready for next chat-turn-event |

**Composition**: completes the substrate's QHsm runtime semantics. The state machine had typed states + typed events + typed transitions; this doctrine specifies that "event" is grounded at the chat-turn level. The substrate's atomic time unit is the chat turn — not wall-clock seconds, not CPU cycles, but the discrete operator-agent exchange.

**How to apply:**

- When designing new workflows, ask "is each stage one chat turn or multiple?" If multiple, are the intermediate states queryable/auditable mid-flight?
- When measuring metrics, count CHAT TURNS not wall-clock time — the substrate's clock is operator-agent exchange, not seconds.
- When debugging state machine drift, replay the chat turn log; each turn is one event; the transition is deterministic from (state, event).

Composes with [[feedback_everything-is-quantum-state-machine]] (chat-turn-as-event completes the QHsm runtime semantics) + [[feedback_wd-is-capture-pokeball-throw]] (wd captures the chat-turn events that drove transitions into typed records) + [[feedback_tool-exclusivity-as-classification-trigger]] (sub-events within a chat turn classify the session via tool-exclusivity).
