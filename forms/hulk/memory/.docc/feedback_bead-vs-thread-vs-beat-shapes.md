---
name: Bead vs Thread vs Phase vs Beat — distinct substrate work-shapes
description: "Substrate has FOUR distinct typed shapes for work artifacts (originally three; Phase added 2026-05-26). Thread = coordinator scope. Phase = ordered sub-coordinator within a thread, groups beads with entry/exit criteria. Beat = compact tactical activity moment. Bead = atomic burnable work-unit. Don't author an overview as a bead; don't conflate phases with threads."
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---

The substrate has FOUR distinct typed shapes for work artifacts. They are NOT interchangeable. The original three-shape vocabulary (Bead / Thread / Beat) was extended 2026-05-26 with **Phase** when the typelift-substrate-modernization thread surfaced the need: multi-phase coordination where each phase groups multiple beads with sequencing and entry/exit criteria.

## Hierarchy (largest → smallest)

```
Thread (coordinator)
  ├── boundary, knowledgeGraphRef, executionGraphRefs, frontierState, crossings
  └── phases[] (optional, ordered sub-coordinators) — NEW 2026-05-26
        ├── entry/exit criteria, status, blockedBy
        └── derived[] (bead slugs in this phase)
  └── activities[] (tactical moments — these are Beats)
  └── derived[] (flat union of all phase derived[], or standalone beads if no phases)

Bead (atomic work-unit, burnable)
  └── id, title, description, status, priority, assignee
```

## Thread (thread-schemas v0.3.0)

A **coordinating scope** — the container for a multi-bead workstream. Lives at `<agenda>/threads/<slug>.thread.json`. Carries:
- `slug`, `title`, `summary`, `status`, `priority`, `origin`, `participants[]`
- **`boundary`** with `knowledgeGraphRef` + `executionGraphRefs[]` + `frontierState` + `focusRefs[]` + `crossings[]`
- `derived[]` — slug list of child beads (flat)
- `phases[]` — typed ordered sub-coordinators (NEW; optional)
- `activities[]` — typed Beat moments (milestone history)
- `notes`

Threads have **structural richness beads don't**: the boundary captures knowledge↔execution refs, the crossings record doctrinal-to-executable moments, the focusRefs hold open architecture questions. A thread is *about* its beads; it isn't itself burned down.

## Phase (NEW 2026-05-26, thread-schemas v0.3.0+)

An **ordered sub-coordinator within a thread** — sequenced chunks of work with entry/exit criteria. Lives INSIDE `thread.phases[]` (not a top-level record kind). Carries:
- `slug` (kebab-case within thread)
- `title`
- `ordinal` (sequencing)
- `summary`
- `status` (pending / inProgress / complete / blocked)
- `derived[]` (bead slugs belonging to this phase)
- `entryCriteria[]` / `exitCriteria[]`
- `blockedBy[]` (other phase slugs)

Phases sit between threads and beads. A thread with 1 phase is just a thread (drop the phase). A thread with 3+ phases benefits from typed sequencing — burndown dashboards can render phase-by-phase progress, dependency-blocking is structural rather than implicit-in-prose.

**Canonical example**: the `typelift-substrate-modernization-2026-05-26` thread has 3 phases (Phase A vendor, Phase B audit, Phase C fork), each grouping multiple beads, each blocking on the previous.

**When does a thread NEED phases?**
- 3+ sequenced chunks of work where order matters
- Each chunk has its own entry/exit criteria
- Beads naturally cluster into chunks by sequencing

**When does a thread NOT need phases?**
- 1-2 beads — flat `derived[]` is fine
- Beads aren't sequenced (any order works) — flat `derived[]`
- The work is genuinely one chunk — single-phase is overhead

## Beat (substrate currently as thread.activities[])

A **compact tactical activity moment** — much lighter than a bead. Today substrate encodes beats as `ThreadActivity` records inside `thread.activities[]`:
- `slug`, `title`, `summary?`, `momentRefs[]`

Beats are the substrate's smallest typed activity unit — "what happened at moment T in the thread." Tactical-scale: "today I am working on X" or "operator-decided Y." Beats don't contain beads; beads don't contain beats. Beats are activity-moments; beads are work-units.

The original 2026-05-23 memory mentioned standalone `<agenda>/beats/<slug>.beat.json` files; in practice substrate has moved toward beats-as-thread-activities (the typed `ThreadActivity` shape). Standalone beat files may exist for legacy reasons; the modern pattern is `thread.activities[]`.

## Bead (paperclip-issue-protocol-schemas)

A **discrete work-unit** — the thing you burn down. Lives at `<agenda>/beads/<slug>.{issue,bead}.json`. Carries:
- `id`, `title`, `description`, `issueType` (task/epic/doctrine/tracking/investigation)
- `status` (open/closed/blocked), `priority`, `closedAt`, `resolutionNote`
- `labels[]`, `sourceType`, `sourceLocation`
- `sourceThreadId` (when bead was spawned by a thread phase/beat)
- `sourceBeatId` (when bead was spawned by a specific activity within a thread)
- `dependencies[]` (typed blockers)

Each bead represents *one chunk of work*. The status flow (open → in-progress → closed/blocked) tracks completion. Beads are the substrate's Kanban-card equivalent.

## When to use which (refined 2026-05-26)

| Shape | Use when | Avoid when |
|---|---|---|
| Thread | coordinating multiple beads with shared scope, doctrine, knowledge-graph | tracking individual work; no boundary/crossings concept |
| **Phase** | thread has 3+ sequenced chunks with entry/exit criteria | thread has flat unsequenced beads — keep `derived[]` flat |
| Beat | capturing tactical activity moments inside a thread | the artifact has status/priority/burnable semantics (that's a bead) |
| Bead | discrete work-unit needing status + resolution tracking | the artifact is an overview/coordinator (that's a thread) OR an activity-moment (that's a beat) |

## The mistakes to avoid

1. **Don't author an overview record as a bead** — even with `issueType: "epic"`. If the record has boundary/crossings/derived/activities semantics, it's a thread.

2. **NEW: Don't conflate phases with sub-threads.** A phase lives INSIDE a thread; a thread is a top-level record. A multi-phase thread is ONE thread with `phases[]`, not multiple threads.

3. **Don't conflate phases with beats.** A phase groups multiple beads and has entry/exit criteria. A beat is a single activity moment with `summary`. Phase ≠ Beat.

4. **Don't author phases for trivially-flat threads.** If your thread has 1-2 beads or unsequenced beads, leave `phases[]` empty — flat `derived[]` is fine. Phases add value when sequencing matters.

## How to apply

- When authoring a multi-bead workstream: **start with the thread record first**. Child beads reference it via `sourceThreadId: <thread-slug>`.
- If the work has natural sequencing (3+ chunks where order matters): **add `phases[]`** with typed entry/exit criteria, each phase grouping its beads via `phase.derived[]`. The thread's flat `derived[]` becomes the union of all phases' derived (for backward compat with phase-unaware consumers).
- If the work is unsequenced: **keep `derived[]` flat**, no phases.
- For tactical moments (operator decisions, discovery events, milestones): **add `ThreadActivity` records to `thread.activities[]`** (these are Beats in substrate vocabulary).
- For status-trackable atomic units: **author a Bead** with `sourceType: thread-beat`, `sourceThreadId`, and optional `sourceBeatId`.

## Why phases earned their own typed shape (2026-05-26 origin)

The typelift-substrate-modernization thread surfaced 3 natural phases (vendor / audit / fork), each grouping 2-4 beads, each blocking on the previous. Without typed phases, the sequencing lived in naming convention ("phase-a / phase-b / phase-c" slugs) and dependency-blocking was implicit. Operator-observed: "phases are more than beads right? threads?" Answer: phases are structurally between threads and beads — a sub-coordinator with sequencing semantics. Added as the 4th typed work-shape to substrate's vocabulary.

## Related memories

- [[bead-vs-thread-vs-beat-shapes]] — this memory (was 3-shape, now 4-shape)
- [[threads-bridge-knowledge-and-work-graphs]] — threads bridge KG↔WG via knowledgeRefs/workRefs
- [[cross-agent-communication-via-documents]] — phases don't change this; cross-agent coordination still flows through typed documents, not shared beads
- [[ordinality-table-entries-immutable-once-released]] — PhaseStatus enum case mappings freeze on first release
- typelift-substrate-modernization-2026-05-26 thread — canonical example of multi-phase coordination
