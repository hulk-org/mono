---
name: Preserve historical data
description: Never rewrite contents of harvest snapshots, receipts, or vault archives when paths change — they were correct at capture time.
type: feedback
---

Do not modify historical/archival files (harvest shadows, receipts, session logs) when renaming or moving identity homes.

**Why:** These are point-in-time captures. The paths inside them were correct when written. Rewriting them falsifies the historical record.

**How to apply:** When doing path migrations, explicitly exclude `vaults/harvest/`, `receipts/publish-queue/`, session logs, and similar archival directories from bulk replacements. Move the directories themselves if needed, but leave their contents intact.
