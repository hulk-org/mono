---
name: No submodule update --init without consent
description: Never run `git submodule update --init` (or --recursive variants) against a submodule that has on-disk working-tree content; require explicit per-path operator authorization first
type: feedback
originSessionId: 4cdf303b-5484-419d-b8fb-20dae0c1a4b1
---
Never run `git submodule update --init`, `git submodule update --init --recursive`, or any variant that resets a submodule's working tree against the supermodule-pinned commit, without explicit operator authorization for that specific path.

**Why:** A submodule path can have local working-tree content that is *more recent* than the upstream-pinned commit — for example, harnesses/gemini/ on rismay's substrate had local OAuth credentials, account state, and identity edits that predated and outranked the upstream `rismay/gemini-agent.git` HEAD. Running `submodule update --init` would have silently overwritten that newer local state with the older pinned content. The operator caught this on 2026-04-29 with: "no submodule update --init without consent... we have more modern files in local and that would be deleted".

**How to apply:**
- Treat `git submodule update --init` as destructive against any path whose working tree exists. The flag is *only* safe when the working tree is empty or known to be a stale clone.
- Before proposing any submodule init/sync/update operation, list what the working tree currently contains and ask whether that content should be preserved.
- When the local content is intentionally more current than upstream, the right move is to **add a new remote (e.g., Bitbucket)** and push the local state, not to pull/reset toward the existing upstream.
- This rule extends `feedback_reshape-preserves-data` and `feedback_no-deletion-without-confirmation` into the submodule-init footgun specifically — the operation looks read-only ("just initializing") but is in fact a destructive write against the working tree.
