@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Architecture — Paradigm Comparison")
}

# Swarm vs. Tachikoma (2026-04-10)

This is the architectural culmination of the `architecture.docc`
investigation. It places the entire swarm runtime documented in
<doc:secret-surfaces> alongside the Tachikoma organism ontology and
execution model documented in the wrkstrm-app substrate. The
conclusion: they are not competing implementations of the same idea.
They are two fundamentally different paradigms for agent work, and
the substrate has chosen the second one.

## The one-line difference

**Swarm = lateral scaling of chat agents.**
**Tachikoma = structured work-graph execution by bounded autonomous
units under Ghost direction, in isolated worlds, with no memory
drift.**

## Side-by-side

| Axis | Swarm (`utils/swarm/`) | Tachikoma (CLIA ontology) |
| --- | --- | --- |
| **Subject** | "teammate" — a full Claude agent with accumulated conversation | タチコマ — bounded execution unit, no mid-term memory |
| **Identity** | Same agent, cloned N times | Named species presets with composable anatomy |
| **Memory model** | Accumulates `allMessages`, compacts when threshold hit | Context only (mission, frontier, visited set). Wiped between runs. |
| **Spawning** | Leader spawns teammates; teammates self-schedule from shared task list | Only Ghosts spawn Tachikoma. Tachikoma never create Tachikoma. Recursion forbidden. |
| **Self-direction** | Autonomous: claims tasks, polls mailbox, decides whether to accept shutdown | None: traverses the projected work graph. Ghost set the graph; Tachikoma walks it. |
| **Communication** | File-based mailbox (JSON inbox per agent, lockfile concurrency), teammate-message XML in model context | None between Tachikoma. Results exported → Ghost curates → memory updated. |
| **Permission model** | Leader permission bridge: all teammates share one operator consent surface | No permissions. Tachikoma operate in a closed world with no host access. |
| **Execution world** | Host process (in-process), host terminal (tmux/iTerm pane), or remote (teleport) — all on the real filesystem | Staged disposable world: temp dir → Apple Containerization → Firecracker microVM → smolBSD/Unikraft |
| **Model** | Claude (any model via API) | Apple Foundation Models on-device for Ghost. Tachikoma are **not LLM agents** — they are deterministic graph traversers. Optional cognition bridge for bounded inference. |
| **Improvement** | Conversation history + compaction = organic drift | "You don't teach Tachikoma by letting them remember — you teach them by sending them back out better." Ghost-driven spec refinement + version lineage. |
| **Determinism** | Non-deterministic (LLM output) | Deterministic: same graph + same spec = same traversal |
| **Abort model** | Two-layer: lifecycle abort (kill teammate) + per-turn work abort (Escape) | Budget exceeded → killed. No conversation to interrupt. |
| **Anatomy** | Ad-hoc per `TeammateSpawnConfig` | Composable from 6 organs: traversal core, memory organ, selection organ, temporal envelope, trick, control budget |
| **Species** | None | Ant (BFS/queue), Hound (DFS/stack), Fox (priority/heap), Spider (adjacency), Owl (ring buffer/sliding window) — presets over anatomy axes |
| **Isolation** | None (shares host filesystem, API keys, MCP connections) | Absolute: `/world/` with read-only graph, writable out/tmp, no host access, no network unless bridge permits |
| **Wire format** | Anthropic SDK messages + teammate-message XML | VFS: `bin/clia-worker` + `etc/spec.json` + `graph/` + `out/` + `tmp/`. Standard files. `ls`, `diff`, `git` for free. |
| **Scale** | N teammates in one process or N terminal panes | N disposable worlds, each booting in ~0ms (temp dir) to ~125ms (Firecracker) |
| **LOC in-tree** | ~7,500 (swarm) + ~3,000 (backends) + ~1,000 (teleport) + ~500 (ultraplan) = ~12,000 | Design + architecture docs in place; app shell built; worker binary not yet implemented |

## The projection pipeline

This is the key architectural insight that makes Tachikoma
categorically different from swarm. From `work-graph-projection.md`:

```
Knowledge Graph (infinite, semantic, open-world)
         │
    Ghost interprets
         │
         ▼
Work Graph (finite, operational, closed-world)
         │
    Shell materializes as VFS
         │
         ▼
Execution World (temp dir / microVM / container)
         │
    Tachikoma traverses
         │
         ▼
Results exported → Ghost curates → memory updated
```

This is structurally a **compiler pipeline**:
- Ghost = front-end (semantic analysis)
- Work graph = intermediate representation
- Tachikoma = passes over the IR

Swarm has no equivalent. The swarm leader doesn't project a work
graph — it writes a prompt string and sends it to a teammate that
runs an open-ended conversation. The teammate can do anything:
create files, call APIs, spawn sub-agents, reject shutdown requests.
There is no IR, no closed world, no deterministic traversal.

## The worker contract

From `work-graph-projection.md`, the Tachikoma worker is:

```bash
./bin/clia-worker \
  --spec ./etc/spec.json \
  --root ./graph \
  --out ./out
```

The spec encodes: traversal strategy, predicates, trick binding,
budget. The graph is read-only. Output goes to `/out`. Scratch to
`/tmp`. No access outside `/world`. No network unless the spec
explicitly permits a callback bridge. Hard CPU / memory / wall-clock
limits. Killed on violation.

Compare to swarm's teammate, which is:

```ts
runAgent({
  agentDefinition,
  promptMessages,
  toolUseContext,        // full tool suite including Bash, Write, etc.
  canUseTool,            // permission check per tool call
  forkContextMessages,   // accumulated conversation history
  model,                 // remote LLM
  ...
})
```

The teammate can read/write the host filesystem, execute shell
commands, call remote APIs, send messages to other teammates, claim
tasks from a shared list, and run indefinitely until aborted or
shut down by the leader. It operates in the real world with real
consequences.

## The cognition bridge

Tachikoma are not stupid — they can call back to the Ghost for
bounded inference when they hit an ambiguity boundary:

- Request: task kind + local graph slice + strict token budget
  required output schema
- Response: labels, priorities, small summaries, dispatch decisions
- The Ghost runs a small Reverie via Foundation Models on the host
- The result is a compact structured answer, not an open-ended
  conversation

This is the inverse of swarm's permission bridge. In swarm, the
teammate asks the leader for permission to act. In Tachikoma, the
executor asks the Ghost for judgment to decide. Permission is
irrelevant because the world is closed — there's nothing dangerous
to permit.

## The anatomy system

Tachikoma anatomy maps **algorithms to body parts**. This is not
metaphor — it is a composable selection system:

| Organ | Data structure | Species preset |
| --- | --- | --- |
| Queue core | FIFO queue (BFS) | Ant |
| Stack core | LIFO stack (DFS) | Hound |
| Heap core | Priority queue | Fox |
| Adjacency | Edge iterator | Spider |
| Ring buffer | Sliding window | Owl |
| Hash gland | Hash set / bloom filter | (organ, not species) |

Plus: selection organ (filters/predicates/priority functions),
temporal envelope (when the unit can act), trick binding (which
atomic action per node), control budget (hard limits).

Species are **presets** over these axes, not fixed types. The "151
Tachikoma" research question asks whether a combinatorial system
can generate 151+ valid configurations with ~12–20 named as
canonical presets. The answer to that question determines whether
the anatomy DSL compiles down to `SelectionSpec` /
`TemporalSpec` / `TraversalSpec` or stays at the spec level.

Swarm has nothing equivalent. All teammates are the same species
with the same anatomy. The only differentiation axis is the prompt.

## The federated inventory

Tachikoma (the app) catalogs **all agentic surfaces** in the
substrate through nine federated inventory files:

1. Foundation Models Tools (~41)
2. Claude Code Skills (~32)
3. Codex Commands (~10)
4. MCP Servers (~2+)
5. Shell CLIs (~45)
6. Sub-agents (~5)
7. Paperclip Adapters (TBD)
8. Agent Personas (~10)
9. Hooks (~5)

Total: ~175–200 endpoints. Each inventory is owned by its
collective, uses a shared base schema from `ToolEvalManifestKit`,
and carries surface-specific required fields. The app composes
them into a unified sidebar grouped by `AgenticSurface`.

This is the trick catalog that Tachikoma species traverse. A Fox
(priority-heap traverser) running a `validate` trick across the
Foundation Models inventory is a qualitatively different operation
from a chat agent reading the same inventory through a prompt.

## The execution-world ladder

| Phase | Substrate | Boot time | Isolation |
| --- | --- | --- | --- |
| Now | Staged temp directories on macOS | ~0 ms | Process-level |
| Next | Apple Containerization (Linux guest on macOS) | Lightweight | Container-level |
| Later | Firecracker microVM | ~125 ms | Hardware VM |
| R&D | smolBSD (~10 ms boot) / Unikraft (~1–10 ms boot) | Ultra-fast | VM / unikernel |

The worker binary and spec format are identical across all
substrates. Only the isolation boundary changes. This is the
inverse of swarm, where adding a new backend (tmux → iTerm →
in-process) required new `PaneBackend` / `TeammateExecutor`
implementations, detection logic, and fallback chains.

Key decision: **Apple Intelligence stays on the host.** Foundation
Models is an Apple OS framework; dragging it into a Linux/BSD guest
would lose the "no separate model download" advantage. Ghost stays
on the Apple host; Tachikoma run in the guest; the cognition bridge
is a thin host-side daemon.

## The two apps

- **Tachikoma by wrkstrm** (`me.rismay.tachikoma`) — the
  maintenance bay. Browse, test, evaluate, promote agentic tools.
  Phase 1 app shell built with `ModernSharedAppShell`
  `WrkstrmMeshGradientHeader` + `WrkstrmTreeExplorerSwiftUI`.
  Design system fully specified in
  `tachikoma-by-wrkstrm.design.docc/` with organism-grounded
  visual language (indigo for Ghost, teal for Sprite, green/orange/
  red for Tachikoma, gray for Shell, inherited for Trick).

- **Architect by wrkstrm** — the flagship. Operator draws apps on a
  Metal 4 canvas using substrate organisms as primitives. Output is
  a running application. The ~175+ agentic endpoints are the palette.
  Tachikoma feeds Architect; they share the ontology and inventory
  but diverge on interaction model (browse + test vs. draw
  connect).

## What swarm taught us that Tachikoma needs

The swarm deep-read was not wasted. Several patterns in the
12,000-LOC runtime are directly useful for Tachikoma's implementation:

1. **The `TeammateSpawnConfig` shape.** Tachikoma's spec file
   (`etc/spec.json`) is the analogous config surface. The shape
   — identity, prompt, model, permissions, working directory,
   worktree — is a good starting checklist for what the spec
   schema needs to carry.

2. **The mailbox's lockfile concurrency.** While Tachikoma don't
   talk to each other, the Ghost needs to read results from N
   parallel Tachikoma. The file-based lockfile pattern from
   `teammateMailbox.ts` (10 retries, 5–100 ms backoff) is the
   right shape for `/out` directory collection.

3. **The backend registry's detection + fallback pattern.** The
   execution-world ladder (temp dir → container → microVM) needs
   the same shape: detect available substrate, cache result,
   fall back gracefully.

4. **The `workerBadge` concept.** In swarm, the badge shows which
   teammate is requesting permission. In Tachikoma, the analogous
   surface shows which species is running, what trick it's
   performing, and its current graph position. The badge is the
   runtime identity — species + anatomy + progress.

5. **Compaction as a design pressure.** Swarm's autocompact exists
   because chat agents accumulate unbounded conversation. Tachikoma
   avoid this entirely — no mid-term memory, no compaction needed.
   But the *existence* of autocompact in swarm validates the
   Tachikoma invariant: "Tachikoma carry working context, not
   memory."

## What Tachikoma changes about everything else

If Tachikoma is the target execution model, several surfaces
documented earlier in this bundle need reframing:

- **`utils/swarm/`** is not the persona-hosting runtime. It is the
  **legacy chat-agent multiplexer** that Tachikoma replaces for
  structured work. Swarm may remain useful for open-ended
  collaborative sessions (brainstorming, code review, pair
  programming) where deterministic traversal doesn't apply. But for
  work that can be expressed as a graph, Tachikoma wins.

- **`utils/teleport/`** is still relevant. Shipping a work graph to
  a remote execution world is teleport with a different payload (VFS
  instead of git bundle). The `EnvironmentKind` taxonomy
  (`anthropic_cloud | byoc | bridge`) maps to the execution-world
  ladder.

- **`utils/ultraplan/`** is a prototype of the projection pipeline.
  "Send a plan request to a remote Claude in plan mode and wait for
  the approved plan" is a chat-shaped approximation of "Ghost
  projects work graph, Tachikoma traverses it." Ultraplan is what
  you build before you have a real compiler.

- **`buddy/`** is orthogonal. Buddy is a companion character in the
  UI — it is a Sprite (sensory, reactive, event-triggered), not a
  Tachikoma. Quipsnip watches and comments; it does not traverse
  work graphs.

- **`memdir/`** and **`services/SessionMemory/`** are Ghost surfaces.
  They hold durable cross-session memory — exactly what Ghosts carry
  and Tachikoma do not.

## The founding-breach insight, revisited

The founding-breach insight at
`harnesses/hulk/memory/.docc/insights/founding-breach-2026-04-05.md`
says hulk is the carrier and claude is one persona it can host. The
swarm investigation suggested persona-aware teammates as the
implementation. The Tachikoma ontology gives a cleaner answer:

- **Hulk is the Shell.** Runtime container, hosts Ghosts, wires
  Sprites, controls Tachikoma.
- **Claude is one Ghost persona.** Persistent cognition + identity,
  operates on the knowledge graph, projects work graphs.
- **Quipsnip is a Sprite.** Sensory watcher, event-driven, does
  not act.
- **The swarm teammates would be Tachikoma** — if they were
  redesigned as bounded, memoryless, deterministic graph traversers
  in isolated worlds. Today they are not. Today they are chat agents
  that happen to run in parallel.

The carrier-vs-persona split is not "hulk hosts multiple chat agents."
It is "hulk (Shell) hosts one or more Ghosts, which project work
graphs into execution worlds traversed by Tachikoma, observed by
Sprites, and composed into applications on the Architect canvas."

## Status

This investigation is complete. The swarm runtime is fully documented
(see <doc:secret-surfaces>). The Tachikoma ontology, execution model,
work-graph projection, anatomy system, execution-world ladder, and
federated inventory are documented in the wrkstrm-app architecture
and design bundles. The comparison is recorded here.

What remains is implementation: the `clia-worker` binary, the spec
schema, the VFS materializer, the cognition bridge daemon, and the
Apple Containerization integration. Those are Phase 6–7 on the
Tachikoma roadmap.
