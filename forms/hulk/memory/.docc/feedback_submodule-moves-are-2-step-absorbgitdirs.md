---
name: feedback-submodule-moves-are-2-step-absorbgitdirs
description: "Git submodule moves are a 2-step process — both the parent's gitlink/.gitmodules AND the in-tree .git linkage to .git/modules/ must stay in sync. The canonical fix is absorbgitdirs, NEVER deinit+add."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c5a791f0-7c27-4647-986a-a89122fc8571
---

**Git submodule moves are a 2-step process.** Both layers must stay in sync:

1. **Parent's submodule pointer** — the gitlink entry in the parent's tree + the `.gitmodules` file entry's `path = <new-path>`
2. **Submodule's internal .git linkage** — the in-tree `.git` should be a FILE containing `gitdir: ../../...../.git/modules/<submodule-path>`, pointing at the parent's `.git/modules/<path>/` directory which holds the actual git data

**Symptom of broken submodule:** the in-tree `.git` is a DIRECTORY (with config, objects, COMMIT_EDITMSG inline) instead of a FILE. The repo is functional standalone but is decoupled from the parent's submodule machinery. `git submodule update --init` could try to re-clone and clobber uncommitted work.

**Why:** Operator (rismay) 2026-05-31 surfaced this concern after I claimed "physical submodule moves can't be fixed via gitlink updates" — they pushed back that submodule moves ARE possible via gitlink + careful .git relocation, but it's a 2-step process and naive operations break it. Investigation found 32 of 143 substrate submodules in this broken state, including all 6 from the recent operators/→collaborators/ rename (jakor, johnwhitecastle, tkoh, khegh, amanda-champagne, natashenough).

**How to apply:**
- **DO use `git submodule absorbgitdirs <path>`** — the canonical, non-destructive 2-step fix. Moves the in-tree `.git/` into `.git/modules/<path>/` and replaces the in-tree `.git` with a file pointer. Preserves all data, no re-clone.
- **NEVER use `git submodule deinit <path>` + `git submodule add <url> <path>`** — would wipe the standalone .git data including any unpushed work.
- Before absorbgitdirs: verify the submodule's working tree is clean, HEAD matches parent's pointer, and `.git/modules/<path>/` doesn't already exist (would indicate partial prior absorb).
- After absorbgitdirs: verify in-tree `.git` became a FILE pointing at `.git/modules/<path>/` and `git submodule status` is anomaly-free.

**Diagnostic one-liner** to find broken submodules across a repo:
```bash
for sm in $(git submodule status | awk '{print $2}'); do
  [ -d "$sm/.git" ] && echo "BROKEN: $sm"
done
```

**Substrate state at 2026-05-31**: 32 standalone submodules tracked in bead `repair-32-standalone-submodules-via-absorbgitdirs` at `claude/agenda/beads/` (commit `ccc42a95aa`). Documented but not yet executed — operator chose document-only since substrate was in heavy concurrent state.

Composes with [[feedback_substrate-wide-cascade-pattern]] (absorbgitdirs sweep itself is a substrate-wide cascade; per-category commits + verification gate) + [[feedback_breaks-are-good-no-transition-shims]] (don't add transition shims for submodule layout — fix the root cause via absorbgitdirs).
