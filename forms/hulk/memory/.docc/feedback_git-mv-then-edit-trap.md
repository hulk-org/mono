---
name: git mv + Edit pre-staging trap
description: After git mv, Edit changes only modify the working tree; the index still holds the old content. Must git add after editing or the commit will only capture the rename.
type: feedback
---

`git mv old new` stages a rename **with the old content**. If you then use the
Edit tool to change `new`, the working tree is updated but the index still has
the original content from the rename. A subsequent `git commit` (without `git
add`) will commit a pure rename — your content edits silently won't land.

**Why:** Bit me on the Source Control rebrand (2026-04-08). I `git mv`'d
38 files (Swift, DocC, project.yml, Info.plist, scripts) then ran replace_all
edits on each. xcodegen + xcodebuild succeeded because they read the working
tree, but the commit only captured the renames. Anyone cloning HEAD got
`AgentGitApp` Swift structs inside files named `SourceControlApp.swift`, plus
a project.yml that still said `name: clia-git` while the xcodeproj said
`source-control-by-wrkstrm`. Required a follow-up commit to land the actual
content.

**How to apply:** Whenever a workflow combines `git mv` with subsequent Edit /
Write calls on the same files:

1. Do all the renames first
2. Do all the content edits next
3. **Always `git add` the renamed paths after editing them, before committing**
4. Verify with `git diff --cached <one-of-the-files>` that the staged content
   actually contains the new edits, not the pre-rename content

If the workflow has more than ~5 renamed-and-then-edited files, prefer doing
content edits **before** the git mv (the renames will then be detected at
commit time as renames-with-modify). Or just be disciplined about the
post-edit `git add`.
