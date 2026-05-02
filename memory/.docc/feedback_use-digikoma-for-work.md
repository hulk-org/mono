---
name: Use koma for discrete work
description: Before doing mechanical work (file moves, renames, scaffolding), ask if a koma exists or should be created for it
type: feedback
---

Before doing discrete mechanical work (moving files, renaming, scaffolding, bulk edits), ask: can we use an existing koma? Should we create one?

**Why:** Komo are the execution units — bounded, one-action-per-node workers. If the work is worth executing, it's worth being a koma. This is the "no throwaway scripts" principle applied to the organism's own operations.

**How to apply:** When a task is mechanical and repeatable (e.g., "move these files into the right domain"), pause and propose a koma before doing it by hand. Check `domain/` for an existing komo that fits, or propose a new one with spec + identity.
