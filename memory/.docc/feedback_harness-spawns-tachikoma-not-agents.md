---
name: Harness spawns Tachikoma, not big agents
description: Carriers should spawn bounded Tachikoma for discrete work instead of heavy agent sub-sessions that pollute context and waste tokens
type: feedback
originSessionId: d8bf83a5-6455-41dc-86b8-ec518edcee54
---
The harness's job is to REMOVE responsibility from agents, not pile it on.
When work can be decomposed into discrete actions (fetch, clean, validate,
index, watch), the carrier should spawn a Tachikoma — a bounded execution
unit with context but no mid-term memory — instead of a full agent
sub-session.

**Why:** Heavy agent spawns (subagents, background agents, explore agents)
carry the full system prompt, pollute the parent's context window with
results, and burn tokens on inference that doesn't need judgment. A
Tachikoma traverses a closed work graph, performs one scan per station, and
returns a result. No system prompt overhead, no context pollution, no
wasted tokens. See `feedback_patrol-scan-vocabulary.md` for the macro/micro
verb pair.

**How to apply:**
- When designing carrier features (S-5 self-awareness, heartbeat checks,
  file watches, bootstrap validation), reach for a Tachikoma first
- Only spawn a full agent when the task genuinely needs judgment,
  personality, or multi-turn reasoning
- The carrier is the orchestrator — it decides when to spawn a Tachikoma
  vs when to hand work to the agent. The agent should not have to manage
  its own resource queries or background sweeps
- This is the architectural thesis: FoundationModels on-device as the
  Ghost judgment layer, Tachikoma as the execution layer, carrier as the
  orchestrator between them
