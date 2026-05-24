---
name: Bead vs Thread vs Beat — distinct substrate shapes
description: Substrate has three distinct typed shapes for work artifacts. Beads are discrete work-units (burn-down). Threads are coordinating scopes (with boundary + crossings). Beats are compact tactical units (id/goal/status only). Don't author an overview record as a bead.
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
The substrate has three distinct typed shapes for work artifacts. They are NOT interchangeable.

## Bead (paperclip-issue-protocol-schemas)

A **discrete work-unit** — the thing you burn down. Lives at `<agenda>/beads/<slug>.{issue,bead}.json`. Carries:
- `id`, `title`, `description`, `issueType` (task/epic/doctrine/tracking)
- `status` (open/closed/blocked), `priority`, `closedAt`, `resolutionNote`
- `labels[]`, `relatedThread`, `sourceLocation`, `sourceType`

Each bead represents *one chunk of work*. The status flow (open → in-progress → closed/blocked) tracks completion. Beads are the substrate's Kanban-card equivalent.

## Thread (thread-schemas v0.3.0)

A **coordinating scope** — the container for a multi-bead workstream. Lives at `<agenda>/threads/<slug>.thread.json`. Carries:
- `slug`, `title`, `summary`, `status`, `priority`, `origin`, `participants[]`
- **`boundary`** with `knowledgeGraphRef` + `executionGraphRefs[]` + `frontierState` + `focusRefs[]` + `crossings[]`
- `derived[]` — slug list of child beads
- `activities[]` — milestone history
- `notes`

Threads have **structural richness beads don't**: the boundary captures knowledge↔execution refs, the crossings record doctrinal-to-executable moments, the focusRefs hold open architecture questions. A thread is *about* its beads; it isn't itself burned down.

## Beat (beat-schemas v0.1.0)

A **compact tactical unit** — much lighter than a bead. Lives at `<agenda>/beats/<slug>.beat.json`. Carries just:
- `id`, `goal`, `status` (active/done)

Beats are the substrate's smallest execution unit, used inside beat-journals and Hobonichi-techo cadences. They're tactical-scale: "today I am working on X." Beads can decompose into beats; threads contain beads.

## When to use which

| Shape | Use when | Avoid when |
|---|---|---|
| Bead | discrete work-unit that needs status + resolution tracking | the artifact is an overview/coordinator/scope-container |
| Thread | coordinating multiple beads with shared scope, doctrine, or knowledge-graph | tracking individual work; no boundary/crossings concept |
| Beat | tactical "doing this right now" unit inside a journal cadence | strategic or multi-step work — that's bead-or-larger |

## The mistake to avoid

**Don't author an overview record as a bead** — even with `issueType: "epic"`. The substrate's `epic` slot inside beads is for *large work-units that decompose*, not for *workstream coordinators*. If the record has `boundary`, `crossings`, `derived[]`, or `activities[]` semantics, it's a thread. If it has children but no execution status of its own, it's a thread.

**Why:** Operator correction 2026-05-23 during the role-cascade burn-down setup. The coordinator I authored as a bead was self-referencing as a `relatedThread` member while ALSO being the coordinator (circular) — exactly the structural mismatch that signals "wrong shape." Reshaped to a proper thread record at `collectives/clia-org/agenda/threads/role-cascade-2026-05-23.thread.json`. Operator's exact words: "see this im more like a thread or a beat right?"

**How to apply:**
- When authoring a multi-bead workstream, **start with the thread record**. The thread comes first; child beads reference it via `relatedThread: <thread-slug>`.
- If you find yourself writing "coordinator bead" or "epic bead with no concrete work" — stop. That's a thread.
- If you find yourself writing a status-trackable task — that's a bead.
- If you find yourself capturing one-line tactical intent for the current beat-of-work — that's a beat.
- Each shape lives in its own substrate dir (`<agenda>/threads/`, `<agenda>/beads/`, `<agenda>/beats/`) per the convention shown in castor and clia-org agendas.
