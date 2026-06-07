---
name: Naming evolution from Pet to Koma
description: Records the full naming journey for execution units — Pet/Trick/Species vocabulary retired in favor of Koma/Action/Anatomy; preserves the reasoning so dead terms don't resurface
type: insight
originSessionId: 17bca72f-ee91-4f7a-8002-180df199eef5
---
# Naming Evolution: Pet → Koma (2026-04-12)

## The journey

The bounded execution unit went through three naming eras in one
design conversation (2026-04-10):

### Era 1: Traverser (mechanical)

- **Traverser** = the engine
- **Surveyor** = observation layer
- **Scanner** / **Inspector** = detection variants
- Rejected as top-level name: "sounds like an algorithm, not an
  entity"

### Era 2: Pet + Trick (companion metaphor)

- **Pet** = the execution unit
- **Trick** = atomic action ("go fetch," "go clean," "go mark")
- **Species** = traversal presets (Ant, Hound, Fox, Spider, Owl)
- **Familiar** = proposed "what lives next to your agent"
- This era produced the trick vocabulary:
  - fetch, clean, mark, trace, validate, index, watch
- And the species-as-animal vocabulary:
  - Ant (BFS/queue), Hound (DFS/stack), Fox (priority/heap),
    Spider (adjacency), Owl (ring buffer)

**Why it died:** When Apple Intelligence entered the picture, "Pet"
collapsed. You can't call Apple Intelligence a pet. The metaphor
forced everything into a cute/companion frame that didn't hold
under the weight of the real system. The operator said: "I hate
that I'm going to make Apple Intelligence seem like a Pet though."
That was the kill signal.

### Era 3: Koma (コマ) — current

- **Koma** (コマ) = short for Tachikoma (タチコマ = 立ち駒, mobile
  autonomous unit)
- **Action** = what the unit does per node (replaces "trick")
- **Anatomy** = algorithms as composable body parts (replaces
  "species")
- **Spec** = the full behavior envelope (selection, temporal,
  traversal, action, control)
- **Lineage** = version chain (v1 → v2 → v3, Ghost-driven
  refinement)

## What was killed and why

| Dead term | Replaced by | Why |
| --- | --- | --- |
| Pet | Koma (コマ) | Can't call Apple Intelligence a pet. The unit is a mobile autonomous piece, not a companion. |
| Trick | Action | "Trick" implies a pet doing a cute thing on command. An action is what a system unit performs per node. |
| Species (Ant/Hound/Fox/Spider/Owl) | Anatomy presets (deferred) | Animal names were v1 placeholders. Real species names come from the anatomy system when it produces real code, not from a zoo metaphor. |
| Familiar | killed | Displaced by Ghost in the Shell framing. |
| Surveyor | kept as a layer concept | Surveyor sits above traverser — observes + assesses. Not killed, just not the top-level name. |

## What survived

| Term | Status | Notes |
| --- | --- | --- |
| Traverser | alive (internal) | The mechanical substrate. Koma IS a traverser internally. |
| Fetch/Clean/Mark/Trace/Validate/Index/Watch | alive as action values | The vocabulary survived; only the "trick" wrapper died. |
| BFS/DFS/Priority/Adjacency/Ring buffer | alive as anatomy modules | The algorithms survived; only the animal names died. |
| Spec | alive | The behavior envelope. Action is one field inside it. |
| Lineage | alive | Version chain. Ghost-driven refinement. |

## The invariant that holds across all eras

Regardless of naming:

> The execution unit carries working context, not memory. It
> performs one action per node. It traverses a closed work graph.
> It never creates other execution units. All improvement is
> Ghost-driven spec refinement, not internal learning.

That invariant was true when they were "pets with tricks" and it's
true now that they're コマ with actions. The naming changed. The
physics didn't.
