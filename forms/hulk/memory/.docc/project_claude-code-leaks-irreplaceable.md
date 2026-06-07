---
name: claude-code-leaks submodule is irreplaceable
description: The github.com/rismay/claude-code-leaks repo no longer exists. The local checkouts of the leaked Claude Code TypeScript source are the only surviving copies — never delete them without confirming an equivalent copy exists elsewhere.
type: project
---

The git remote `https://github.com/rismay/claude-code-leaks.git` returns "Repository not found" as of 2026-04-06. Confirmed by failed `git submodule add` attempt.

**Why:** The fork has been taken down (or made private). The `harnesses/claude/private/universal/domain/tooling/claude-code/` submodule still exists locally as a checkout, but its remote is gone — `git fetch` and re-cloning will fail. The leaked TypeScript source is one of two reference implementations the hulk contract is measured against (alongside ultraworkers/claw-code), so losing it would degrade hulk's self-awareness.

**Surviving copies as of 2026-04-06:**
- `harnesses/claude/private/universal/domain/tooling/claude-code/` — submodule checkout, 33 MB, registered in root `.gitmodules` line 231
- `/Users/sonoma/Documents/claude-code-leaks/` — original local copy, ~43 MB, source for prior mirror operations

**How to apply:** Before any operation that could lose data at either path (rm, git submodule deinit, mv across filesystems, git clean), verify the OTHER copy still exists and is intact. When migrating from the claude home path into hulk, MOVE the working tree (preserving inodes) rather than re-cloning. Do not run `git submodule update` against the dead remote — it will not destroy local data but may put the submodule into a broken state. If the local working tree must be removed, first push a fresh archive/tarball into the substrate so a third copy exists.
