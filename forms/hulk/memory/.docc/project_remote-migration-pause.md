---
name: GitHub remote migration in progress - no push
description: Substrate is mid-migration to a new GitHub remote; do not git push to existing remotes until the new remote is established and the user explicitly authorizes
type: project
originSessionId: d8bf83a5-6455-41dc-86b8-ec518edcee54
---
The substrate is in a window where a new GitHub remote is being established to replace the current ones. **Do not run `git push` against any submodule or mono outer until the user explicitly says the new remote is live.**

**Why:** Pushing to the old remote during the migration window risks (a) wasting work that would need to be re-pushed to the new remote, (b) confusing whichever automation watches the old remote, and (c) duplicating commits across the two remote endpoints. Per the user 2026-04-30: "no push - we are trying to establish a new remote from github..."

**How to apply:**
- Continue committing locally as normal — digikoma-git/digikoma-git commits are fine, the auto-commit hook is fine, submodule pointer bumps are fine.
- Skip ALL push-related steps until the user explicitly clears the constraint. Don't ask "should I push?" each turn — assume the answer is no.
- When the user does signal the migration is done, watch for new remote URLs in `.git/config` or `git remote -v` before re-engaging push paths.
- This applies across all repos in the substrate (mono outer, clia-org, schema-universal, digikoma-org, clia-agent-cli, hulk, etc.).
