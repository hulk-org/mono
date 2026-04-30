---
name: Tachikoma traverser vocabulary and field worlds
description: Durable notes captured from hulk paste-cache a6426c920fff2a14 on 2026-04-10: traverser vs surveyor naming, Tachikoma as bounded graph workers, and host-ghost vs field-world execution doctrine
type: project
originSessionId: d8bf83a5-6455-41dc-86b8-ec518edcee54
---
This note preserves the durable parts of the large paste capture now promoted
to:

- `captures/tachikoma-traverser-field-worlds-2026-04-10.raw.txt`

Original cache source:

- `private/universal/substrate/harnesses/hulk/paste-cache/a6426c920fff2a14.txt`

Captured 2026-04-10. The promoted raw file is ~11.8k lines; this note saves
the stable ideas for fast recall.

## Durable vocabulary decisions

- **`Traverser`** is the strongest core abstraction for the engine layer.
  It implies explicit graph traversal, frontier management, visited sets,
  weighting, heuristics, and bounded movement across a closed work graph.
- **`Surveyor`** is a good consumer / report role layered on top of a traverser.
  It implies measurement, mapping, and aggregate outputs rather than mutation.
- The clean split is:
  - **Traverser = engine**
  - **Surveyor = observer / aggregator**
- Public naming can stay more animate than the mechanical core. Internally,
  `Traverser` is still the most precise substrate term.

## Tachikoma model restated

- Tachikoma are **bounded execution units**, not memory-bearing agents.
- They traverse a **closed projected work graph**, not the infinite knowledge
  graph.
- They carry **working context**, not durable memory.
- They should perform **one scan per station** against the projected world. (Vocabulary refined 2026-04-29: "scan" replaces "trick" as the per-station verb. See `feedback_no-pet-no-trick`.)
- The right mental model is not "full agent in a shell" but "local actor with
  bounded context inside a finite universe."

## Host / field split

- **Ghost on the host. Tachikoma in the field.**
- Host-side Ghost cognition should stay on Apple hardware with Foundation
  Models / Apple Intelligence.
- Tachikoma should execute inside **staged disposable worlds**, not directly
  on the real host filesystem.
- The work graph is the world Tachikoma inhabit. Host cognition produces the
  graph first; field execution consumes it.

## Execution-world direction

- Near-term inner loop:
  - Apple host
  - local staged filesystem / temp overlays
  - Apple Containerization as the practical first real field-world boundary
- Longer-term field isolation:
  - Firecracker + guest Linux is the strongest likely production direction
  - smolBSD / Unikraft stay research lanes for tiny worlds
- The important architectural rule is that the guest does **not** need full
  model access. It can call back to the host Ghost through a bounded bridge if
  needed.

## Why this matters

- It reinforces the existing ontology in
  `project_tachikoma-ontology.md` rather than replacing it.
- It sharpens the language boundary between:
  - Ghost reasoning
  - harness/world construction
  - Tachikoma traversal/execution
  - survey/report layers over traversal
- It supports the doctrine already recorded in hulk memory that **the harness
  spawns Tachikoma, not full agents**, for discrete bounded work.

## Follow-up

- The raw paste has been promoted to a named stable capture path. Future work
  should cite that promoted file, not the anonymous paste-cache hash.
