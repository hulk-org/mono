# Beads + wrkstrm + Koma: The Full Stack (2026-04-20)

## The Insight

Beads (gastownhall/beads) is the missing work management layer for
wrkstrm apps. Discovered during the Swarm vs Koma investigation when
comparing how different frameworks handle task graphs vs execution graphs.

## The Stack

```
wrkstrm app (UI — what the operator sees)
     │
     │  display molecules, gates, progress
     │  operator approves gates, pins work to agents
     │
     ▼
Beads (WHAT + WHEN — task graph)
     │
     │  Formula → Molecule → Gate lifecycle
     │  Hash IDs, Dolt-backed, multi-agent safe
     │  "Design the feature" → "Implement" → "Test"
     │
     ▼
Ghost (INTERPRETS — bridges plan to execution)
     │
     │  reads ready Beads issue
     │  projects a Koma work graph
     │  writes results back, closes issue
     │
     ▼
Koma (HOW — execution graph)
     │
     │  Spec → Traversal → FM cognition at each node
     │  fetch → split → summarize → synthesize
     │  process-per-tool, bounded, replayable
     │
     ▼
Results → Ghost → Beads → wrkstrm app
```

## Why This Matters

wrkstrm apps don't need to invent their own task/dependency/workflow
system. Beads already provides:

- **Formulas** — declarative TOML/JSON workflow templates
- **Molecules** — instantiated work graphs with parent-child issues
- **Gates** — async coordination (human approval, timers, GitHub events)
- **Wisps** — ephemeral operations that auto-expire
- **Dolt** — version-controlled SQL with cell-level merge for concurrent agents
- **Hash IDs** — collision-free multi-agent work
- **Compaction** — semantic summarization of closed tasks

Koma already provides the execution layer. The Ghost already bridges
planning to execution. Beads fills the gap between "what needs to happen"
and "make it happen."

## The Three Systems Compared

| | Beads | Ghost | Koma |
|---|---|---|---|
| Concern | Task management | Interpretation | Execution |
| Question | What + when? | What does this mean? | How? |
| Graph type | Dependency (needs) | Knowledge → work projection | Traversal (BFS/DFS/priority) |
| Persistence | Dolt SQL, versioned | Memory, identity | None (ephemeral, replayable) |
| Coordination | Gates | Projection decisions | Budget enforcement |
| Identity | Issue hash IDs | Ghost persona | Koma slug + version + lineage |

## Prior Art in the Session

- Swarm (christopherkarani/Swarm) comparison showed that Koma's
  separation of navigation from execution is the key architectural
  advantage. Beads takes this further by separating *planning* from
  both navigation and execution.
- The research pipeline experiment (fetch → summarize → synthesize)
  proved that Koma pipelines work as execution graphs. Beads would
  be the system that decides *when* to run that pipeline and *which*
  issues it serves.

## Commissioned Surface

Beads already has a commissioned collective at
`collectives/beads/` with identity, vaults, and workspace contract.
The upstream repo is `github.com/gastownhall/beads`.
