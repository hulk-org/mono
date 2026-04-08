---
name: Workspace has auto-commit/auto-push git hook
description: A git hook in this workspace silently commits AND pushes new files during unrelated commits; authored as Cristian, no co-author trailer
type: feedback
---

**Observed behavior (2026-04-08 session):** When I `git commit` something
in any of the substrate submodules, a hook fires that picks up
**unrelated untracked files** from the working tree, stages them, creates
a separate commit authored as `Cristian A Monterroza
<1240948+rismay@users.noreply.github.com>` (no `Co-Authored-By` trailer),
and **also pushes them to origin**. Confirmed twice in one session:

1. During the source-control async refactor commit, the hook auto-created
   `511aaf67 Add wrkstrm app prototypes` for two prototype scaffolds I had
   created moments earlier.
2. During the LinkRef-break-fix commit, the hook auto-pushed my fix
   (`40a8de5c5`) to origin/main before my manual `git push` ran. My push
   reported `Everything up-to-date`.

**Why:** Lets the user keep the working tree clean without manually
shepherding every file, but it means:

- Co-authorship gets dropped when the hook commits files I created
- Pushes can happen without an explicit human "push" decision
- The boundary between "what I committed" and "what the hook committed"
  is blurry in `git log`

**How to apply:**

- Don't be surprised when commits I didn't make appear in the log between
  my own commits, or when `git push` reports "up-to-date" right after my
  commit.
- Don't try to retroactively add co-author trailers or unstage the
  hook's commits — they're the user's intended workflow.
- If a user explicitly asks to investigate the hook (it was item 10 on
  the menu but never picked), check `core.hooksPath` and the relevant
  `.git/hooks/` directories. As of 2026-04-08 the hook source has not
  been read.
