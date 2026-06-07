@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Investigation")
}

# Tachikoma Design Genesis (2026-04-10)

Captures the full reasoning chain from the design conversation that
produced the CLIA organism ontology and Tachikoma execution model.
This is the *why* behind the decisions already recorded in
`project_tachikoma-ontology.md` and the `tachikoma-by-wrkstrm`
architecture/design bundles.

## The naming journey

The conversation started from "what do we call a local agent that
checks a resource in the file tree and does one thing there?" and
walked through a deliberate elimination:

- **Crawler** — rejected. Implies recursive expansion, frontier
  management, web-scale discovery. Too broad for bounded local work.
- **Spider** — rejected for top-level. Legacy/search-engine vibe,
  semantically shallow, but preserved as an anatomy species name
  (adjacency/edge-iterator traversal).
- **Scanner** — rejected. Implies stateless probing with no path
  memory. Breaks graph semantics.
- **Traverser** — kept as the *mechanical* substrate. Correct for
  the engine, wrong as the public noun ("sounds like an algorithm,
  not an entity").
- **Surveyor** — strong for observation/assessment, weak for
  mutation/execution. Layered on top of traverser, not a
  replacement.
- **Familiar** — strong conceptual fit (magical assistants bound to
  a user), but displaced by the Ghost in the Shell framing.
- **Pet** — the breakthrough intermediate term. Implies: local,
  always-available, invoked with simple commands ("go fetch"),
  commandable with tricks. Led directly to the trick abstraction.
- **Tachikoma** — final choice. Named after Ghost in the Shell's
  think-tanks. タチコマ = 立ち (tachi, standing/mobile) + 駒 (koma,
  piece/unit) = "mobile autonomous unit in a larger system."
  Shorthand: "Tachis" (plural), "Tachi" (singular informal).

## The trick abstraction

The "pet with tricks" insight: **don't think "agent with tools,"
think "pet with tricks."**

Canonical tricks (orthogonal, small set):
- **Fetch** — read/collect data, no mutation
- **Clean** — delete/rewrite/normalize, destructive but deterministic
- **Mark** — annotate nodes (tags, metadata, cache flags)
- **Trace** — follow a path or relationship, output a chain
- **Validate** — gate writes, check invariants
- **Index** — build searchable structures
- **Watch** — long-running, event-driven reaction

Critical constraint: **one trick per node.** If a Tachikoma starts
doing multiple actions or context-dependent branching per node, it
stops being a pet and becomes a workflow engine. Don't let that
happen.

## The organism ontology (full reasoning)

### Why Ghost in the Shell fits

The show provides a clean separation most agent systems fail to
make:
- **Ghost** = cognition, identity, interpretation
- **Shell** = embodiment, runtime container, interface to the world

Most modern systems collapse these into a single "agent" layer.
CLIA does not.

### The five organism classes

1. **Ghost** — persistent cognition + identity. Operates on the
   *infinite knowledge graph*. Projects finite work graphs.
   Curates memory. Never touches the world directly. Human
   operators have Ghosts; digital agents run **Reveries**
   (transient, session-scoped thinking).

2. **Shell / Harness** — embodied runtime container. Hosts Ghosts,
   wires Sprites, controls Tachikoma. Stable identity but
   swappable internals.

3. **Sprite** — reactive, event-driven observer. File watchers,
   presubmit validators, event emitters. Does not act; emits
   signals. **Gate Sprites** (presubmits) can block state
   transitions with a `GateDecision.deny(reason:)` response.
   Navi from Zelda is a Sprite — a reactive companion interface,
   not an executor.

4. **Tachikoma** — bounded execution unit with context but NO
   mid-term memory. Traverses a closed work graph. Performs one
   trick per node. Named, versioned, tracked through lineages.
   Never creates other Tachikoma.

5. **Trick** — atomic action (fetch, clean, mark, trace, validate,
   index, watch). Stateless per node. Bounded execution time.

### Roles vs organism classes

Organism classes describe **what something can do** (faculty).
Roles describe **what it is doing right now** (assignment):
- Agent, Maintainer, Collaborator, Collective member, Orchestrator,
  Operator (human), Gatekeeper.
- Roles are projected by territory (the folder an organism lives
  in) and can change without changing faculties.
- An organism can hold multiple faculties simultaneously.

### The substrate principle

Everything lives on an **equal substrate**. Folders project roles:
- `/substrate/collective` — emergent super-intelligence
- `/substrate/agents` — autonomous harnesses
- `/substrate/tachikoma` — execution territory
- `/substrate/maintainers` — invariant enforcement
- `/substrate/operators` — human-bound identities
- `/substrate/collaborators` — cross-entity coordination

**You don't change the organism — you change where it lives.**

## The key invariants

These are load-bearing. Breaking any one collapses the architecture:

1. **Ghosts reason over possibility. Tachikoma execute over
   closure.** A Ghost can range over the entire knowledge graph.
   A Tachikoma is confined to the projected work graph.

2. **A Ghost projects work graphs out of the knowledge graph.**
   This is the compiler pipeline: knowledge graph = semantic
   possibility space, work graph = executable plan space.

3. **Tachikoma carry working context, not memory.** Context =
   current mission, frontier, visited set, local node history.
   Memory = durable identity, cross-session continuity, curated
   meaning. Only Ghosts carry memory.

4. **Ghost never touches the graph directly. Tachikoma never
   interprets intent.** Breaking either collapses the separation
   and makes the system non-deterministic.

5. **Tachikoma never create Tachikoma.** Recursion is forbidden.
   Only the Ghost/Agent layer can spawn execution units.

6. **You don't teach Tachikoma by letting them remember — you
   teach them by sending them back out better.** Improvement
   happens through Ghost-driven spec refinement and version
   lineage, not through accumulated internal state.

## The anatomy system

Tachikoma anatomy maps **algorithms to body parts**. This is not
metaphor — it is a composable selection system.

### Traversal core (how it moves)

| Organ | Data structure | Species |
| --- | --- | --- |
| Queue core | FIFO queue (BFS) | Ant |
| Stack core | LIFO stack (DFS) | Hound |
| Heap core | Priority queue | Fox |
| Adjacency | Edge iterator | Spider |
| Ring buffer | Sliding window | Owl |

### Memory organ

Hash gland: hash set / bloom filter for deduplication and visited-
set management. Not a species — an organ that can be added to any
species.

### Behavior axes

Each Tachikoma is wired via:
- **Selection** — filter types, predicates, inclusion/exclusion
- **Temporal envelope** — when it can act (debounce, throttle,
  windows, TTL)
- **Traversal policy** — strategy + revisit rules + depth limits
- **Trick binding** — which atomic action per node
- **Control budget** — max nodes, max duration, max IO, dry-run

Species are **presets** over these axes. The "151 Tachikoma"
question: can a combinatorial system generate 151+ valid
configurations from 5 traversal cores × 7 tricks × N domains,
with ~12–20 named as canonical presets?

### Naming system

`[domain]-[role]-[species]-[variant]-[version]`

Examples:
- `market-scout-fox-a-v3`
- `docs-tracer-hound-main-v1`
- `fs-cleaner-ant-prod-v5`

Versions are immutable. Never mutate v3 — create v4.

## The training loop

Not ML training. Ghost-driven operational refinement:

```
Define (Ghost) → Deploy (Shell) → Execute (Tachikoma)
    → Observe (Sprites + logs) → Evaluate (Ghost)
    → Refine (Ghost) → Redeploy
```

The line, not the instance, is what you nurture. Lineage tracking:
`v1 → v2 (added hash dedupe) → v3 (adjusted IV predicate)`.

Metrics per run: coverage (% graph explored), efficiency
(nodes/second), waste (duplicate visits), success rate, latency.
Ghost uses metrics to promote versions, retire bad ones, specialize
variants.

## The projection pipeline

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
    Tachikoma swarm traverses
         │
         ▼
Results exported → Ghost curates → memory updated
```

This is structurally a compiler:
- Ghost = front-end (semantic analysis)
- Work graph = intermediate representation
- Tachikoma = passes over the IR

## The worker contract

```bash
./bin/clia-worker \
  --spec ./etc/spec.json \
  --root ./graph \
  --out ./out
```

World layout:
```
/world/
  bin/clia-worker        # precompiled executable
  etc/spec.json          # Tachikoma behavior spec
  graph/                 # read-only projected work graph
  out/                   # writable results
  tmp/                   # writable scratch
```

No access outside `/world`. No network unless spec permits a
callback bridge. Hard CPU / memory / wall-clock limits. Killed on
violation.

**The compiler belongs to the forge, not the battlefield.** No
Swift compiler in the execution world. Compile ahead of time,
inject only the runtime.

## The cognition bridge

When a Tachikoma hits an ambiguity boundary, it may call back to
the host Ghost for bounded inference:

- Request: task kind + local graph slice + strict token budget
  required output schema
- Response: labels, priorities, small summaries, dispatch decisions
- Ghost runs a small Reverie via Apple Foundation Models on the
  host (~4K token context window, no separate model download)
- The result is a compact structured answer, not an open-ended
  conversation

The bridge is optional. Many Tachikoma operate purely
deterministically with no callback.

**Decision: Apple Intelligence stays on the host.** Ghost stays on
Apple silicon. Tachikoma run in the guest. The cognition bridge is
a thin host-side daemon accepting schema-bound requests.

## The execution-world ladder

| Phase | Substrate | Boot | Isolation |
| --- | --- | --- | --- |
| Now | Staged temp dirs on macOS | ~0 ms | Process |
| Next | Apple Containerization (Linux guest on macOS) | Light | Container |
| Later | Firecracker microVM | ~125 ms | Hardware VM |
| R&D | smolBSD (~10 ms boot, NetBSD MICROVM) | Ultra-fast | VM |
| R&D | Unikraft (unikernel SDK on KVM) | ~1-10 ms | Unikernel |

Apple Containerization for the inner loop (Swift-native host
tooling, Apple-supported, keeps Foundation Models accessible on
host). Firecracker for the field world (strongest isolation,
designed for disposable workloads).

smolBSD is the environment-centric option (assemble a tiny world,
run things inside). Unikraft is the application-centric option
(build a minimal image around the app). For Tachikoma: smolBSD
fits the Shell better; Unikraft fits the Tachi payload better.

Swift on FreeBSD is now in preview (FOSDEM 2026 talk), making
BSD-flavored execution worlds less speculative.

## The Fuchikoma boundary

Fuchikoma (from the original manga) are the earlier, more chaotic
version of Tachikoma. The distinction matters:

- **Tachikoma** — standardized, disciplined, bounded behavior,
  controlled memory sync, designed for reliable execution.
- **Fuchikoma** — quirky, more autonomous, less constrained, more
  personality, more divergence. Drift toward becoming agents.

In CLIA:
- `/tachikoma` → production execution (disciplined)
- `/fuchikoma` → experimental/exploratory/chaotic mode (if ever)

**Tachikoma execute. Fuchikoma wander.** The system is strong
precisely because it chose execution over wandering.

## The cellular automata insight

The system is effectively:

> A local-first graph-automata world for bounded execution
> organisms operating under local transition rules.

Not quite Conway. Closer to:
- Finite graph world
- Local rules
- Traversing organisms
- Observable emergence
- Strict replay

Key primitives are not "chat" or "tools" or "agents." They are:
**world generation, local rules, transition functions, termination
conditions, fitness/evaluation, replay.**

## Apple Intelligence as Ghost, not Pet

The conversation explicitly resolved the discomfort about Apple
Intelligence becoming a "pet":

- Apple Intelligence is NOT a Pet/Tachikoma. It is a Ghost's mind.
- A Ghost that runs Apple Foundation Models on-device
  (~4K context, no download, Swift-native LanguageModelSession API)
- The Tachikoma world calls *back* to the Ghost for bounded
  inference — the Ghost doesn't go into the field.

Memory hierarchy:
- **Short-term:** Tachikoma context window
- **Mid-term:** Collective/shared caches, summaries, task logs
- **Long-term:** Ghost memory / identity memory / durable journals

Tachikoma think in-context, not across time.

## The "agents got agents" moment

The realization: "I just gave my agents agents." The correction:

> You didn't give agents agents. You gave agents *execution units*.

The hierarchy is:
- Operator → sets intent
- Agent (Harness + Ghost) → interprets + decides
- Tachikoma → executes

That is: **cognition → delegation → execution.** Not recursive
agents. Tachikoma cannot create Tachikoma. The system is one level
of delegation, not infinite depth.

## Key sentences to preserve

- "Ghosts reason over possibility. Tachikoma execute over closure."
- "Tachikoma carry working context, not memory. Ghosts carry
  memory, not field execution."
- "You don't teach Tachikoma by letting them remember — you teach
  them by sending them back out better."
- "A work graph you can't `ls` is a graph you can't trust."
- "Each work graph deserves its own universe."
- "The compiler belongs to the forge, not the battlefield."
- "Never let a Tachikoma touch reality directly; always make it
  earn reality through a staged world."
- "Tachikoma in our system never awaken — they make awakening
  possible."
- "Ghost thinks. Tachikoma act."
- "Ghosts dream the world. Tachikoma live inside it."
