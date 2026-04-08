---
name: Never push codex-sessions submodule
description: The codex sessions vault submodule must never be pushed to its remote, even when batch-pushing other submodules
type: feedback
---

Never `git push` the `private/universal/vaults/ai/exports/open-ai/codex/sessions` submodule (remote: `rismay/codex-sessions`).

**Why:** User explicitly corrected me after I included it in a batch push round of submodules. The codex sessions vault holds session export JSONL files, accumulates large objects, and is intentionally kept local-only. Pushes are not part of the routine "push everything we can" sweep even when the user says "push the submodules too."

**How to apply:** When asked to commit/push submodules in batches from `~/mono`, exclude `private/universal/vaults/ai/exports/open-ai/codex/sessions` from any push step. Pointer bumps in the parent `mono` repo for this submodule are still fine; only the submodule's own `git push` is forbidden. If a user explicitly names this submodule and asks to push it, confirm before doing so.

**Note from the incident:** When I first violated this, the push to `rismay/codex-sessions` errored mid-upload (`HTTP 500`, `send-pack: unexpected disconnect`) so nothing actually landed on the remote. The failure was luck, not policy. This means:

1. `rismay/codex-sessions` is known to reject or choke on large pushes.
2. The local vault keeps accumulating unpushed commits that should be left alone, not "fixed" by retrying.
