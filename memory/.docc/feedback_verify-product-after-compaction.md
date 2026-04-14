---
name: Verify product after context compaction
description: After context compaction, build and verify the product works BEFORE doing any bookkeeping (winddown, journal, etc.)
type: feedback
---

After a context compaction, the first action must be build + verify the
product, not bookkeeping. The winddown can wait.

**Why:** On 2026-04-10, picked up from a compacted session and
immediately wrote winddown entries. The operator had to ask "did you
build the product again?" — answer was no. When built, the app was
broken (SwiftUI eating events). Should have caught this before writing
journal entries about the previous session's progress.

**How to apply:** When resuming from a compacted context, always:
1. Build the product
2. Launch and verify it works
3. Report status to the operator
4. THEN do bookkeeping if needed
