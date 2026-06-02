---
name: agenda-is-high-level-not-task-ledger
description: "In substrate v0.6+ identity-schemas / agenda-schemas, **Agenda** is the HIGH-LEVEL coordinator (long-running intent, scope, direction), NOT the task ledger. Task ledgers are a separate, lower-level construct."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate's agenda concept is **high-level** in the v0.6+ doctrine. An agenda records *what this organism is here to do at the level of intent, scope, and direction* — not the granular work-units that move that intent forward.

## Two distinct constructs — don't conflate

| Construct | Level | What it records | Examples |
|---|---|---|---|
| **Agenda** | high-level coordinator | durable intent, scope, direction, multi-cycle goals | "host commissioned agents for the rismay workspace," "produce typed digikomas for substrate adoption," "evolve the cost-sync ledger toward production" |
| **Task ledger** | lower-level | granular work-units, beads, burnable items, in-progress actions | individual beads, threads, in-progress edits, scheduled invocations |

If you find yourself listing concrete actions or in-progress work in an agenda — STOP. That belongs in the task ledger (likely beads, threads, agency entries, or the runtime work-graph). The agenda stays terse, intent-oriented, and stable across many task-ledger cycles.

## Why this matters

- **Agendas evolve slowly; ledgers churn constantly.** Conflating them produces an agenda that's noisy, hard to read at a glance, and constantly stale. The high-level reader (operator, scheduler, lineage system) loses signal.
- **Task ledgers compose with the work-graph; agendas compose with the knowledge-graph.** Different consumers, different rates of change, different invariants. Same doctrine as [[feedback_threads-bridge-knowledge-and-work-graphs]].
- **The schema split mirrors the conceptual split.** AgendaModel in v0.4+ is intentionally compact; bead/thread/agency schemas carry the work-unit detail.

## How to apply

When **creating a new agenda** for an organism:
- Think "what is this organism *here for*" not "what is it doing right now"
- Use intent-shaped sentences (verbs of purpose: *host*, *evolve*, *produce*, *steward*)
- Keep entries durable — they should still read true a year from now
- DO NOT enumerate beads, threads, in-progress tasks, or scheduled items
- DO NOT use the agenda as a TODO list

When **reviewing an existing agenda**:
- If it reads like a TODO list, it's been overloaded — push the granular items into the right work-graph surface (beads / threads / agency)
- If it reads like a manifesto with no concrete intent, it's been under-specified — add 1–3 typed intent records

## History

Operator-stated 2026-05-26 during cleanup of hulk's missing `agenda.json`: "we moved to json - yes. remember Agenda is now the high level thing now the task ledgers." The hulk identity needs an agenda packet, and the agenda should be the high-level coordinator (host commissioned agents, run the carrier-shape contract) — not a ledger of pending work.

## Related

- [[feedback_threads-bridge-knowledge-and-work-graphs]] — threads bridge KG ↔ WG; agendas are KG-side
- [[feedback_bead-vs-thread-vs-beat-shapes]] — work-graph shapes (beads, threads, beats) — these are the task-ledger surfaces
- [[feedback_cross-agent-communication-via-documents]] — agents have PRIVATE agendas; cross-agent coordination flows through typed documents
