---
name: Analysis before deletion
description: Destructive actions require analysis first — scan, inspect, select, review, then confirm; never auto-show trash buttons before results are reviewed
type: feedback
---

Destructive actions require analysis first. The flow must be:
Scan → Inspect → Select → Review → Confirm → Execute.

**Why:** Session Lab's Sandbox panel showed trash buttons on every row immediately after scan. A 126GB research specimen was deleted (likely by accidental tap) before the user could inspect it. No confirmation existed.

**How to apply:**
- Default UI is analysis-only (scan + reveal + inspect)
- Trash/delete buttons only appear AFTER the user enters a cleanup mode
- Cleanup mode shows a selection queue — user picks items to delete
- Before executing, show a summary: "Delete N items totaling X GB?"
- Never auto-delete. Never show delete buttons inline with scan results.
- The analysis view and the cleanup view are separate states, not mixed.
