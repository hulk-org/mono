---
name: git-apply-cached-for-splitting-mixed-hunk-files
description: "When a single tracked file has hunks from multiple work threads (yours + operator's pre-existing edits), `git apply --cached` with a hand-crafted patch is the substrate-native way to stage only your hunks without bundling."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

Standard `git add <file>` is all-or-nothing for that file — it stages every unstaged hunk. When a file like `.gitmodules` or a shared config has hunks authored by multiple threads (your work plus the operator's pre-existing in-progress edits), `git add` would bundle them all into your commit, claiming authorship of work that isn't yours.

Solution: write a hand-crafted patch file containing ONLY your hunks (with correct line numbers matching the file's current index/HEAD state), then `git apply --cached <patch>` to stage just that diff. The operator's pre-existing hunks remain unstaged in the working tree, available for them to commit separately.

**Why:** caught on 2026-05-23 during the codex→chatgpt agent merge. `.gitmodules` had two threads of work overlapping: the operator's pre-existing removal of `clia-claw`, `clia-wrkstrm`, `agents/main` submodule sections (unstaged at session start), and my new removal of the `agents/codex` section. `git diff .gitmodules` showed all four removals as one mixed unstaged blob. `git rm <submodule>` refused because of dirty `.gitmodules`. The fix was to write `/tmp/codex-submodule-removal.patch` with only my codex hunk and apply it via `git apply --cached`. The operator's three other hunks stayed unstaged in the working tree, where they belonged.

**How to apply:**
- Get HEAD's file content (`git show HEAD:<file>`) to find correct line numbers for the hunk header.
- Hunk header format: `@@ -<oldStart>,<oldLines> +<newStart>,<newLines> @@`. Three lines of context before + three after the deletion is standard.
- `git apply --cached --check <patch>` first to validate the patch applies cleanly.
- After: `git diff --cached <file>` shows only your hunk, `git diff <file>` shows the leftover operator hunks. Both states coexist.
- Commit your work, then the operator can stage and commit theirs separately.
- This technique generalizes to ANY file with mixed-author hunks — schema.json conflicts, shared package manifests, multi-thread CHANGELOG edits.
