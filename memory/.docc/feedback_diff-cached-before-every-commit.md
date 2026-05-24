---
name: diff-cached-before-every-commit
description: "Always run `git diff --cached --name-only` (or --stat) before EVERY commit to verify scope matches intent — scoped `git add` doesn't protect against pre-staged changes piggybacking"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

`git add <specific-path>` only adds those paths. But `git commit` (without `-a`) commits **everything in the index**, including pre-staged changes from prior operations or other sessions. Scoped `git add` is necessary but not sufficient.

**Always run a scope check between `git add` and `git commit`:**
```bash
git diff --cached --name-only  # or --stat
```

If the list contains anything you didn't intend, STOP. Either:
- `git reset HEAD <unwanted-path>` to unstage and proceed
- Investigate what the pre-staged change is and decide explicitly

**Why:** caught on 2026-05-23. My Wave 4 commit `631bc2a16d` was meant to bump only `clia-org` + `digikoma-org` submodule pins. It ALSO captured a pre-staged deletion of the `agents/codex` submodule that was already in mono's index from prior work in another session. Scoped `git add` didn't protect me because the deletion was already staged before my add ran.

Operator chose to leave the deletion (intentional in-progress work), but the failure mode is real: a smaller-stakes commit could have swept in something harder to recover from (e.g., a destructive submodule removal that wasn't intended at all).

**How to apply:**
- After `git add <paths>`, ALWAYS run `git diff --cached --name-only` and visually verify every line matches the intended commit scope.
- If the list is long, use `git diff --cached --stat` instead.
- For multi-repo commits (per-submodule + mono pin bump), check both the submodule's `--cached` AND mono's `--cached` separately — each has its own index.
- The check costs ~1 second. The cost of an unintended commit is hours of recovery + potential data loss.
- This pairs with [[feedback_stop-defaulting-to-trash]] — pre-staged deletions are exactly the kind of "things I shouldn't accidentally make official" that this check catches.
