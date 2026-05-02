---
name: Source Control next session
description: Source Control app needs submodule commit history view, concurrent commit detection, and cross-submodule timeline
type: project
---

Source Control (wrkstrm-app) next priorities as of 2026-04-13:

1. **Submodule commit history**: show `git log --oneline -N` per discovered submodule, not just dirty/clean status. The `SourceControlWorkspaceScanner` already discovers all `.git` roots.
2. **Concurrent commit awareness**: detect `index.lock` presence per repo, show which repos have active git operations. This session hit a lock conflict when digikoma-git and another agent committed simultaneously.
3. **Cross-submodule timeline**: unified commit log across mono + all submodules sorted by timestamp. Each entry shows which repo it came from.

**Why:** Multiple agents/sessions committing to the same substrate creates conflicts. The operator needs a single surface to see what's happening across all repos in real time.

**How to apply:** Start from `SourceControlWorkspaceOverview.swift` — extend `scanRepository` to also capture recent commits and lock status. Add a new lane or expand Overview.
