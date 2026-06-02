---
name: workflow-run-shapes-of-software-development-2026-05-26
description: "Substrate's 4 typed workflow run-shapes (single-run, multi-run, recurring, indefinite) map cleanly to how software actually ships — inaugural ship, features, maintenance, bug-fixes-and-content; children are usually single-run regardless of parent shape; the shape categorizes the parent"
metadata: 
  node_type: memory
  type: insight
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

Session 2026-05-26 operator-direct taxonomy cut. Substrate workflows
come in four typed run-shapes that map to **how software actually ships**
— not abstract categories, concrete substrate-real patterns.

## The four shapes with concrete substrate examples

### Single-run — one-shot, terminal after one receipt

**Example: kickoff for inaugural ship.**

Happens once per product. Ceremonial. The first launch of a new app or
feature or vault or schema family. After it completes, the same workflow
never runs again — successors are different workflows (feature ships,
maintenance ships) under the same parent goal.

Concrete substrate instances:
- The kickoff for `kanban-app v0.1.0` (when authored)
- The founding mission statement for clia-org (just shipped this session
  at `clia-org@rismay.substrate.mission.json`)
- An inaugural App Store submission

### Multi-run — bounded iterations with known termination

**Example: features for an app.**

Each feature is a bounded packet. An app has N features (not 1, not
infinite). The termination is "all roadmap features shipped or
explicitly de-prioritized." Each individual feature is a single-run
child workflow under this parent.

Concrete substrate instances:
- The push-factory dogfood drained 14 agent submodules this session
  (cadence, cameron, ... tau) — bounded multi-run, terminated when
  all 14 received their push receipts
- The substrate-wide founding-mission-statement sweep bead (`substrate-
  org-mission-statements-founding-sweep.issue.json`) is multi-run
  bounded by `~35 substrate-owned orgs`

### Recurring — scheduled cadence, indefinite duration

**Example: maintenance ships for OS changes.**

External cadence triggers them (Apple ships macOS 27 → assess→fix→ship→
verify per app). Same shape every run; new instance each cycle. No
defined end as long as the upstream cadence continues.

Concrete substrate instances:
- Autonomous-sync agents producing `chore: sync local changes` commits
  on cadence (observed live this session — 27 commits landed on mono
  root while we were typing)
- The `/wd` skill applied at every session end
- CI pipeline runs on every commit

### Indefinite — runs forever by design

**Example: bug fixes, content updates.**

No defined end. As long as the app/product is operated, the flow
continues. Each individual bug or content update is a single-run child
workflow under this parent.

Concrete substrate instances:
- hack-nu's bug-fix flow: `3b7c0e784` 2022-06-21 → App Store build 984
  on 2026-05-01 = 4 years of indefinite-shape workflow proving this is
  the natural shape, not a degenerate case
- Operational monitoring
- Incident readiness watch (the typed `IncidentModel` from this session
  participates in the indefinite ops-watch workflow)

## The structural rule

**Children are usually single-run regardless of parent shape.**

- Indefinite bug-fix-flow → spawns single-run child per bug
- Recurring maintenance → spawns single-run child per OS version
- Multi-run features → spawns single-run child per feature

The four shapes categorize the **parent** workflow. The shape names the
lifecycle of the workflow ITSELF, not its children. This is why the
substrate's typed `WorkflowRunShape` ordinality (when authored in
workflow-schemas v0.2.0) needs to be a parent-level field, not a per-
node field.

## Why this matters for substrate tooling

Without typed run-shape, the substrate can't distinguish:
- "workflow done" (single-run, receipt landed, terminal)
- "workflow that just hasn't fired today vs ever" (recurring, between
  fires)
- "workflow that never finishes by design" (indefinite, running)

All three look identical without the typed contract. With the typed
contract, each renders with its own visual + behavioral semantics in
substrate UI surfaces (kanban app, fleet view, roster, audit).

## Related work this session

- `[[clia-bundle-architecture-2026-05-26]]` — `<slug>.<kind>.clia`
  executable-assistant primitive; each bundle declares its work-graph
  node identity, which may participate in any run-shape
- `[[incident-vs-bead-vs-thread-taxonomy-2026-05-26]]` — beads/threads/
  incidents distinction; orthogonal to run-shape (a thread can be any
  run-shape; a bead is implicitly single-run; an incident is implicitly
  indefinite-until-resolved)

## Open follow-up

`workflow-schemas v0.2.0` should add a typed
`WorkflowRunShapeOrdinalityTable` (4 records: single-run / multi-run /
recurring / indefinite) plus a `runShapeOrdinal: Int` field on
`WorkflowModel`. Deferred from this session because WorkflowModel has 24
fields and the v-bump deserves its own focused authoring session.
Captured here so the doctrine survives the gap.

Concrete substrate examples per shape are durable enough to validate the
v0.2.0 design against — when WorkflowModel gets bumped, the test fixtures
can directly reference the substrate-real instances cited above (hack-nu
flow, push-factory dogfood, autonomous-sync cadence, founding mission).
