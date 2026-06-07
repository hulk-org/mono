---
name: Fix hygiene findings via the app, not via CLI sweeps
description: Schema/hygiene findings that schema-lab surfaces should be fixed through schema-lab itself, not by repeatedly running batch CLI fixers from the terminal
type: feedback
---

When a hygiene check (`schema-model-import-check`,
`swift-universal-main-audit`, `swift-source-hygiene`, etc.) is wired into
schema-lab, the **point** of the check is that schema-lab surfaces the
findings to the operator. Findings get fixed *through the app*, not by me
running another CLI sweep that touches dozens of files in one go.

**Why:** rismay caught me running sweep after sweep — phase-1 fixer, then
phase-2 patcher, then chasing edge cases on 4 non-canonical packages — when
the goal was to land the *check* and then let schema-lab drive the cleanup.
Each additional CLI sweep both (a) does work the app is supposed to do, and
(b) burns my context on something the app could handle visually with a
human in the loop.

**How to apply:** once a hygiene library/CLI is committed and schema-lab
calls into it, **stop**. Do not keep running fixers from the terminal to
drain remaining findings. Surface the count, let schema-lab render it, and
fix individual cases through the app UI when the operator drives them. CLI
fixers are appropriate for the *first big landing* (when the check itself
is brand new and there's a sea of findings to clear), but the long tail
belongs to the app.

Boundary heuristic: if the check has been running for at least one full
session and the remaining count is small enough to fit on a schema-lab
panel, the next fix happens in the app, not in the terminal.
