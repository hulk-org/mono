---
name: No throwaway code — make a Digikoma
description: Never write throwaway scripts, heredocs, or one-off pipelines; if a task is worth executing, create or invoke a Komo with spec, lineage, and tests
type: feedback
---

Never write throwaway code. No python heredocs, no bash pipelines, no one-off Swift scripts. If a task is worth executing, it's worth being a Komo.

**Why:** Throwaway code is invisible, unreplayable, unversioned. A Komo is named, versioned, tested, and replayable. The substrate grows more capable with every task instead of more cluttered with dead scripts.

**How to apply:**
1. Before writing any ad-hoc code, check if a Komo exists for this task
2. If yes: invoke it (`digikoma-<slug> --payload ... [--prompt ...]`)
3. If no: create the Komo (spec, lineage, katakana files, Tool + CLI, tests)
4. The Komo lives forever in digikoma-org. Next time anyone needs this operation, it's there.

**The test:** if you're about to write `cat file | grep | awk` or a Swift heredoc, stop. That's a Komo that doesn't have a name yet.
