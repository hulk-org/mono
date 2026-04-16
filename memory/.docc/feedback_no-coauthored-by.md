---
name: No Co-Authored-By in commits
description: Never add Co-Authored-By trailers to git commits — the operator is the one directing the work
type: feedback
---

Never append `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>` (or any Claude attribution trailer) to git commit messages.

**Why:** The operator is directing all the work; adding Claude's name implies co-authorship that isn't theirs to claim.

**How to apply:** Write commit messages without any trailing `Co-Authored-By` lines, always.
