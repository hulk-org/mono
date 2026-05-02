---
name: Digikoma commits, not agent
description: Never run git commit directly — invoke digikoma-git commit instead; the komo owns mechanical git operations
type: feedback
---

Do not run `git add` / `git commit` directly. Invoke `digikoma-git commit` via `swift run` instead. The komo owns all mechanical git operations.

**Why:** Same principle as digikoma-xcode-run — mechanical work belongs to the tool, not the agent. The agent decides what to commit; the komo executes it.

**How to apply:** When it's time to commit, invoke:
```
swift run --package-path .../digikoma-org/.../digikoma-git digikoma-git commit --path <repo> --message <msg> --apply
```
Stage specific files first if needed via `digikoma-git add`.
