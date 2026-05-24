---
name: savepoint-daemon-races-your-commits
description: "The substrate's savepointd + digikoma-savepoint pair commits in parallel with the active agent — destructive ops may land in someone else's commit before you can run `git commit`."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

The substrate ships a `savepointd` daemon (clia-org) + `digikoma-savepoint` worker (digikoma-org) pair that watches the filesystem for changes and commits them autonomously with substrate-typed provenance. As of v0.1 it runs one-shot; v0.2 will be long-running. **This means the working tree is NOT single-actor.** When you do destructive git operations (`git rm`, `git submodule deinit`, `update-index --force-remove`), the daemon may detect your changes and commit them mid-flight, bundled into whatever other operator work is in flight.

**Why:** caught on 2026-05-23 during the codex→chatgpt agent merge. I ran `git update-index --force-remove private/universal/substrate/agents/codex`. Within minutes, commit `631bc2a16d` ("Wave 4: bump digikoma-org + clia-org pins — savepoint pair shipped") landed in HEAD — its diff included `D private/universal/substrate/agents/codex` even though the commit message was entirely about the savepoint pair, not codex. The daemon swept my staged-but-uncommitted change into the operator's commit. The end state was correct (codex removed) but the *provenance* was confused — the codex removal landed in a commit with no codex context. My own follow-up commit (`eb7be3dfe5`) carried only the .gitmodules cleanup + chatgpt migration content.

**How to apply:**
- Treat the working tree as if other actors can commit your staged changes at any moment.
- Don't assume `git update-index` + `git commit` is atomic from your perspective — between those two steps, the daemon may run.
- For destructive ops with provenance you care about: stage everything you want bundled together FIRST, then commit in one go (don't leave staged work sitting). If the daemon races you, your stuff lands in another commit.
- `git log --oneline -5` between operations to detect daemon activity. If you see a commit you didn't make, treat the working tree state as possibly different from what you remember.
- Pairs with [[feedback_diff-cached-before-every-commit]] (substrate doctrine from hulk): always `git diff --cached --name-only` between `git add` and `git commit` to verify scope.
- The daemon is generally *helpful* — it captures work that would otherwise sit uncommitted. Just don't expect single-actor semantics.
