---
name: Tachikoma organism ontology
description: Full CLIA organism hierarchy — Ghost/Shell/Sprite/Tachikoma/Trick with execution worlds, Apple Intelligence as host-side Ghost, work-graph projection model
type: project
---

CLIA organism ontology decided 2026-04-09/10. This is foundational doctrine.

## Organism hierarchy

- **Substrate** — equal ground, all organisms live here, folders project roles
- **Collective** — emergent super-intelligence over substrate (the app surface)
- **Ghost** — persistent cognition + identity, operates on the infinite knowledge graph, projects finite work graphs. Human operators have ghosts; digital agents run reveries (transient thinking)
- **Harness (Shell)** — embodied runtime container, hosts ghosts, wires sprites, controls pets
- **Sprite** — sensory organism, file watchers, presubmit validators, event emitters. Gate Sprites can block state transitions
- **Tachikoma (Pet)** — bounded execution unit with context but NO mid-term memory. Traverses a closed work graph, performs one trick per node. Named after Ghost in the Shell think-tanks. Shorthand: "Tachis"
- **Trick** — atomic action (fetch, clean, mark, trace, validate, index, watch)

## Key invariants

- Ghosts reason over possibility. Tachikoma execute over closure.
- A Ghost projects work graphs out of the knowledge graph. Tachikoma traverse those projections.
- Tachikoma carry working context, not memory. Ghosts carry memory, not field execution.
- Tachikoma never create Tachikoma. Only Ghosts/Agents can spawn them.
- Ghost never touches the graph directly. Pet never interprets intent.
- You don't teach Tachikoma by letting them remember — you teach them by sending them back out better.
- Factory direction: carriers should mint Tachikoma from specs, staged worlds,
  trick bindings, budgets, and receipts. See `project_tachikoma-factory.md`.

## Tachikoma anatomy = algorithms + data structures

Traversal core: queue (BFS/Ant), stack (DFS/Hound), heap (priority/Fox), adjacency (Spider), ring buffer (Watcher)
Memory organ: hash set (dedupe)
Behavior wired via: filter types, predicates, temporal rules, traversal policy, trick binding, budget/limits
Species are presets; anatomy is composable.

## Execution worlds

- Ghost stays on Apple host with Foundation Models (no separate model download)
- Tachikoma run in staged disposable worlds (not the real host filesystem)
- Apple Containerization for the inner loop on Mac
- Firecracker + guest Linux for field world isolation later
- smolBSD / Unikraft as research lane for tiny ephemeral universes
- The guest can call back to the host Ghost for bounded inference via a thin bridge

## Apps

- **Tachikoma by wrkstrm** (was Generable Studio) — the maintenance bay / workbench where agents introspect, test, evaluate, and promote their own tools. Bundle: me.rismay.tachikoma
- **Architect by wrkstrm** — the flagship. Operator draws apps on a Metal 4 canvas using substrate organisms as primitives. Output is a running application. The 75+ agentic endpoints are the palette.

## Etymology

タチコマ (katakana) = 立ち (tachi, standing/mobile) + 駒 (koma, piece/unit) = "mobile autonomous unit in a larger system"

**How to apply:** Every design decision about tool surfaces, execution boundaries, memory architecture, and app structure should trace back to this ontology. If something doesn't fit cleanly into Ghost/Shell/Sprite/Tachikoma/Trick, the ontology needs extending — don't work around it.
