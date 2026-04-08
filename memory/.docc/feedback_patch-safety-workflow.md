---
name: Patch safety workflow for multi-chunk deletions
description: After large deletions or renames, grep-verify + diff-stat before commit; add Swift Testing invariants for durable refactors
type: feedback
---

For multi-chunk deletions, sweeping renames, or any patch that removes >50 lines of Swift source:

1. **Post-delete grep-verify pass.** After each chunk is deleted, run a grep check:
   - Symbols that should be gone (assert no matches)
   - Symbols that should remain (assert matches exist)
2. **`git diff --stat` eyeball before each commit.** Confirm line counts match intent. If you expected ~800 lines down and see 1,400, stop and investigate before committing.
3. **Build verification stays mandatory** after each logical change, not just at the end.
4. **For sustained refactors** (like the clia-mem divergence from clia-git): add a Swift Testing target (`import Testing` + `@Test` + `#expect`, never `XCTestCase`) with invariant tests that enumerate routes/types and assert expected shape. Tests make regressions loud during later carves.

**Why:** The build only catches compiler errors — it does NOT catch silent behavior loss from an over-greedy sed/replace_all, a wrong chunk deleted because line boundaries looked similar, or a switch case disappearing silently. Rismay explicitly flagged this risk after the large clia-mem deletions (~2000 lines removed across 5 commits, no test coverage behind them) and asked for tests to be part of the patch strategy.

**How to apply:** Treat grep-verify + diff-stat as non-optional for any multi-chunk patch. Name the removed/preserved symbols explicitly in the verification pass so the reader (and future me) can see what was actually checked. For refactors that span multiple commits, scaffold a Swift Testing target early so each commit gets run against invariants.
