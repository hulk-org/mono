---
name: Beads is the wrkstrm app work layer
description: gastownhall/beads is the task management backbone for wrkstrm apps — task graphs, dependencies, gates, agent-native concurrency via Dolt; Digikoma executes, Beads orchestrates
type: project
---

Beads (gastownhall/beads) is the work management layer for the wrkstrm app stack.
Commissioned collective at collectives/beads/.

**Why:** wrkstrm apps need task graphs with dependencies, coordination gates,
and multi-agent concurrency. Beads already provides all of this: Formula → Molecule
→ Gate lifecycle, hash-based IDs for collision-free multi-agent work, Dolt-backed
version-controlled SQL with cell-level merge.

**How to apply:** The full stack is wrkstrm app (UI) → Beads (what + when) →
Ghost (interprets, projects) → Digikoma (how — execution). Don't reinvent task/dependency
systems in wrkstrm apps — use Beads as the backbone. Digikoma pipelines execute individual
Beads steps. The Ghost bridges the two: reads a ready Beads issue, projects a Digikoma
work graph, executes, writes results back, closes the issue.

Dolt is the shared operational data layer for the substrate — same role as
git for code, but for work state. Per-org `.beads/` directories at
`collectives/<org>/private/universal/.beads/` hold the Dolt databases.
Dolt sync (push/pull) enables cross-org sharing. "One truth, many lenses":
molecules are the canonical data, views are per-consumer (Workflow for
operator, Clia Day for Pa, ready queue for agents).

Discovered 2026-04-20 during Swarm vs Digikoma investigation.
