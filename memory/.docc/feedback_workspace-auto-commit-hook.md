---
name: Workspace has auto-commit/auto-push git hook (intelligent + sometimes sweeps)
description: A git hook in this workspace auto-commits my edits with coherent messages + Co-Authored-By trailers and auto-bumps submodule pointers; it also still sometimes sweeps unrelated working-tree state into my own commits
type: feedback
---

## Two layers of behavior

**Layer 1 — Intelligent auto-commit on my edits (observed 2026-04-08
evening, env-profile cutover session):** When I edit a file in any
substrate submodule, the hook (or whatever the user has running)
frequently fires before I get a chance to `git commit` myself. It:

- Stages just the files I touched (not random unrelated items)
- Generates a coherent commit message related to the actual scope of
  the change (e.g. `env(codex): cutover references to operator
  environment profile path`, `clia-agent-cli: wire agent-schemas v0.1.0
  dependency across targets`, `memory(hulk/claude): chronicle the env
  profile cutover session + tool name fix`)
- Includes a `Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>`
  trailer
- Bumps the parent mono submodule pointer in a separate
  `chore(submodules): bump <slug> for <reason>` commit

This is a significant evolution from the older behavior captured below.
When my own `git add` + `git commit` ran AFTER the hook fired, the
result was often `nothing to commit, working tree clean` because the
hook had already shipped my edits.

**Layer 2 — Still sometimes sweeps unrelated files (older behavior,
still active):** The hook can also pick up unrelated untracked or
modified files in the working tree and bundle them into MY explicit
commits without warning. Confirmed both in 2026-04-08 morning sweeps
(prototype scaffolds, LinkRef fix push) and again in 2026-04-08 evening
(my `chore(submodules): bump hulk for env profile cutover winddown`
commit `0759894e20` accidentally bundled `maintainers/shueber/.docc/index.md`
addition, `maintainers/simonbs` submodule deletion + new `.docc/index.md`,
and `maintainers/shueber/public/touch-up` submodule addition — none of
which I touched).

The hook also pushes to origin in some scenarios — `git push` from me
afterward reports `Everything up-to-date`.

## Why

The user wants the working tree to stay clean without manually
shepherding every file. The newer Layer 1 behavior gives meaningful
auto-commits with proper authorship; the older Layer 2 behavior keeps
the workspace from accumulating untracked drift but blurs the boundary
between "what I committed" and "what the hook committed."

## How to apply

- **Don't be surprised** when commits I didn't manually make appear in
  `git log` between my own commits, when `git push` reports
  `up-to-date` right after my commit, or when my `git commit` reports
  `nothing to commit, working tree clean` because the hook already
  shipped my edits.
- **The hook's auto-commits DO carry the Co-Authored-By trailer now**
  — don't try to retroactively add it.
- **Pre-flight check submodule dirty state** at the start of work so you
  know what's "mine" vs "preexisting drift the hook might sweep into
  one of my commits." This is especially important in submodules with
  active unrelated work (wrkstrm-app, hulk, schema-universal,
  codex-agent during cutover sessions).
- **Use specific `git add <path>` only** in submodules with unrelated
  dirty state. Never `git add .` or `git commit -a`.
- **Verify with `git diff --staged`** before running a commit — if the
  staged set includes files you didn't touch, decide whether to keep
  them or unstage before committing. You may not have time to react
  before the hook's own commit fires though.
- **Don't try to retroactively reword hook commits or unstage the
  hook's pointer bumps** — they're the user's intended workflow.
- If asked to investigate the hook itself, check `core.hooksPath` and
  the relevant `.git/hooks/` directories. As of 2026-04-08 evening the
  hook source has still not been read.
