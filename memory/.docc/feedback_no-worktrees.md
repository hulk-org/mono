---
name: No git worktrees in this substrate
description: Don't reach for `git worktree add` to work around dirty trees. Use submodules + directories — worktrees lose work via weird branches.
type: feedback
---

Do not use `git worktree add` as a workaround for dirty working trees, blocked checkouts, or cherry-pick operations.

**Why:** Worktrees create floating branches that are easy to lose track of. Work gets stranded on weird branch names that no one remembers to clean up. The substrate model uses **submodules + directories** as the unit of separation — that pattern is the canonical way to isolate state, not worktrees.

**How to apply:** When the working tree is dirty and a checkout is blocked:
1. Investigate WHY it's dirty (live runtime state? real work? accidental bleed?)
2. Address the dirty files at their source — commit what's real, ignore what's runtime, clean up what's accidental
3. Use submodules to isolate state that belongs to a different scope
4. Use directories to isolate state within the same repo
5. NEVER spawn a worktree on a branch you might forget about

For cherry-picks across submodule pointer conflicts: resolve the conflict in place by stashing or by using `git update-index --cacheinfo` after a clean reset.

The hulk contract should also reflect this: a harness that writes live runtime state to the working tree (Claude Code's session jsonls, Codex's sqlite logs) makes in-place git operations dangerous. The harness contract should isolate that runtime state into a directory that git workflows can ignore — not push the operator into worktrees as a workaround.
