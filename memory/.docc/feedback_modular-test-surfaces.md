---
name: Modular test surfaces
description: When benchmarking or testing alternate implementations, copy the file and swap at runtime — never inline if/else branching between strategies in the same file
type: feedback
---

When testing a surface (renderer, encoder, pipeline), create a separate copy of the implementation file for each variant rather than adding if/else branches inside one file. Swap variants at runtime (protocol conformance, strategy enum, or factory function).

**Why:** Inline branching (like the `--persistent` flag that toggled between legacy and dirty-range encode in the same `submitFrame`) makes the code harder to reason about, harder to delete the old path cleanly, and doesn't generalize into a reusable testing pattern. Separate files let you diff the two implementations side-by-side, run them independently, and delete the loser without touching the winner.

**How to apply:** When building an experimentation harness or A/B bench for an engine change, create `QuadRendererLegacy.swift` + `QuadRendererDirtyRange.swift` (or similar) conforming to a shared protocol. The bench picks which one to instantiate. The protocol becomes the generalized testing surface. This also makes it trivial to add a third variant later without editing existing files.
