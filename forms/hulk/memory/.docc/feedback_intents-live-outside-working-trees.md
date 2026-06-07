---
name: intents-live-outside-working-trees
description: Push/commit intents must be staged OUTSIDE the working trees they target — otherwise the intent file itself shows up as untracked and trips the dirty-working-tree safety rail
metadata:
  node_type: memory
  type: feedback
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

The substrate's vcs-operation intents (CommitRequestModel, PushIntentModel,
and future kin) carry a `workingTreePath` that the worker operates against
with safety checks like `git status --porcelain` for cleanness.

**Rule:** intent JSON files must live OUTSIDE any working tree they reference.

**Why:** if the intent is written to a path inside its own `workingTreePath`,
git sees it as `?? path/to/x.intent.json` (untracked), the worker's
cleanness check fails, and the operation is rejected with
`PushError.dirtyWorkingTree` / equivalent. This bit DigikomaGitPushToolTests
on first run — using the work-tree as a "convenient scratch dir" for the
intent file looked harmless but broke the test in a way that looked like a
bug in the cleanness check.

**How to apply:** canonical production location is the per-`.git` queue dir
under `~/.local/share/savepointd/queues/<git-dir-hash>/pending/`. Tests
should write intents to a separate tmp dir (e.g. `makeTmpDir("...-intent")`
distinct from the work dir). Same rule applies to artifacts (we already
write them next to the intent, which preserves the discipline). Same
discipline applies to fs-touch events: emit-side queue path, not the
working tree.

Related: [[savepoint-vs-forge-two-registers-2026-05-17]] (savepoint queue
pattern), [[same-shape-same-model]] (commit/push share queue infra).
