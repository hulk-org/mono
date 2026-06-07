---
name: Trash not rm -rf
description: Move files to ~/.Trash instead of rm -rf when deleting; keeps things recoverable
type: feedback
---

Move files to `~/.Trash/` instead of `rm -rf` when deleting.

**Why:** Keeps deletions recoverable. The operator wants a safety net — Trash is that net.

**How to apply:** Use `mv <path> ~/.Trash/` for all file/directory deletions. Only use `rm` for truly ephemeral artifacts (build caches, empty dirs) and only after confirming with the operator.
