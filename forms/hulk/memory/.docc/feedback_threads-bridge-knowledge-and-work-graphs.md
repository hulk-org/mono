---
name: threads-bridge-knowledge-and-work-graphs
description: "Threads are the substrate's typed canonical surface for the KNOWLEDGE-GRAPH ↔ WORK-GRAPH bridge. They reference prior knowledge artifacts (specs, designs, decisions, investigations) AND spawn work artifacts (beads, beats, derived[]). Crossings are bridge events. Boundary opens at one moment, closes at another. derived[] indexes the work-graph emissions. This is why threads warrant their own Kura tier alongside vaults/collections/series/timelines."
metadata:
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

The substrate has two distinct graph structures, and threads are the typed bridge between them. Operator-named 2026-05-25 during the Kura storage typology decision (Axis 2): *"threads are important because they juggle the knowledge graph and work graph."*

## The two graphs

**Knowledge graph (KG)** — what the substrate KNOWS:
- Specs, design documents, investigation outputs
- SOPs, operating protocols, architecture decisions
- Doctrine memories, schema definitions
- Prior threads (each closed thread becomes a KG node)
- Lessons captured in Shinji Techo expertise lanes

**Work graph (WG)** — what the substrate is DOING about it:
- Beads (discrete work units, burn-down)
- Beats (tactical units inside scenarios)
- Workstreams, scenarios, missions, workflows
- Active receipts, in-flight migrations
- Open threads themselves (a thread IS a WG coordinator until it closes)

## How threads bridge

A thread is the typed substrate-canonical record for a coordinating scope that spans both graphs:

- **`boundary`** opens at a moment + closes at a moment — the lifespan during which the thread is actively bridging
- **`knowledgeRefs[]`** — LinkRefs into the KG: prior specs / designs / investigations / decisions / closed threads this work depends on or extends
- **`workRefs[]`** — LinkRefs into the WG: beads / beats / workstreams / scenarios this thread spawns or coordinates
- **`crossings[]`** — bridge events: moments where a KG node becomes a WG node (e.g., a design doc spawns a bead) OR a WG node graduates into the KG (e.g., a closed bead becomes a captured-lesson)
- **`derived[]`** — flat index of artifacts the thread produced (per `[Bead vs Thread vs Beat]` memory)
- **`activities[]`** — ordered moments of agent activity within the thread's scope
- On close: the thread itself becomes a KG node — future threads can `knowledgeRefs[] -> closed-thread-X`

## How to apply

1. **When proposing a coordinating scope, ask: does it bridge KG and WG?** If yes, it's a thread. If it's purely KG (a design doc) it's a collection record. If it's purely WG (a bead, a workstream) it's not a thread.

2. **Author threads in the thread Kura tier** (per `[Kura storage typology]`): `<owning-home>/private/universal/kura/threads/<slug>.thread.json` for per-home threads, or `private/universal/kura/threads/<slug>.thread.json` for substrate-wide.

3. **Reference KG and WG via LinkRefs**. `knowledgeRefs[]` and `workRefs[]` are arrays of `LinkRefModel v0.3.0` instances. Targets vary: vault-record for KG artifacts (typed schema family + JSON pointer), relative-path for in-home WG records, vault-record for cross-substrate doctrine memories.

4. **Crossings carry both endpoints**. A crossing event names the KG node and the WG node + the moment + the agent that traversed (e.g., "design doc X → spawned bead Y at moment Z by agent A").

5. **Thread close is a KG promotion event**. When a thread closes (per the `thread-close` skill), the closed thread becomes a stable KG node. Future threads can reference it via `knowledgeRefs[]`. Closed thread's `derived[]` artifacts are now-stable WG outputs that have completed their bridge.

6. **A thread without crossings is a code smell**. If a thread opens but never crosses between graphs, it's actually a workstream (pure WG) or a collection (pure KG) mis-shaped as a thread. Refactor.

## Why this matters

Without the bridge model, the substrate has no typed surface for "we read these designs AND we did these specific work items AND here's where they connected." That sequence — knowledge → work → knowledge again — is the cognitive shape of substantial development effort. Threads are how the substrate writes it down typed end-to-end.

The 5th-tier Kura promotion (vaults/collections/series/timelines/threads) recognizes that the bridge role is structurally distinct from any of the other 4 access patterns. A timeline alone can't capture which KG nodes spawned which WG nodes. A collection alone can't capture the temporal boundary. A series alone can't capture cross-graph references. Threads need their own tier because they alone describe the bridge.

## Related memories

- [[kura-storage-typology]] — names the 5 tiers including threads
- [[bead-vs-thread-vs-beat-shapes]] — distinguishes the 3 work-item shapes; threads' WG-spawn role
- [[cross-agent-communication-via-documents]] — agents communicate via KG (documents), not WG (shared beads); threads bridge the two within an agent's own scope
- thread-schemas v0.3.0 — typed wire format
- thread-spin / thread-close skills — the lifecycle operations
