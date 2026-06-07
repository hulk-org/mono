---
name: only-reversible-actions
description: "AXIOM 2026-06-07 — only REVERSIBLE actions may be taken against the substrate. `rm` and equivalents (rm -rf, find -delete, truncate, clobber redirects, git reset --hard, git clean -fdx, git checkout -- <uncommitted>, force-push to published refs) are BANNED OUTRIGHT regardless of confirmation. Always substitute reversible primitives: `mv <path> ~/.Trash/`, `git rm` (history preserved), symlink replacement. Reversibility is a property of COMMAND CHOICE, not a property the operator can grant per-case."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 918952a9-4de0-42bf-8f7a-edb513fa994d
---

# Only reversible actions

**Rule:** Every action the agent takes against the substrate must be REVERSIBLE — recoverable from filesystem Trash, recoverable from git history, or undoable by a documented inverse action. `rm` is banned outright. The reversible substitute always exists for filesystem ops on macOS.

**Why:** Operator 2026-06-07 caught me proposing `rm /Users/sonoma/mono/.../agents/claude` to fix the Claude Code subagent registry bloat. I had walked through the prior axioms ([[Analysis before deletion]] + [[No deletion without explicit confirmation]] + [[Trash not rm -rf]]) — analysis was done, confirmation was being asked — and still landed at `rm` as the recommended command. That sequence shows the prior axioms were operating as PERMISSION-GATES, not COMMAND-CHOICE gates. Operator's correction: "never rm please.... just add that as an axiom: only reversable actions should be done. #axiom" — the gate moves from "may I rm?" to "use the reversible substitute."

**How to apply:**
- Never type `rm`, `rm -rf`, `find -delete`, `truncate -s 0`, clobbering redirects `> path`, `git reset --hard`, `git clean -fdx`, `git checkout -- <uncommitted-path>`, or force-push to a published ref in ANY Bash tool call.
- When the operator authorizes a "delete" intent, translate to the reversible primitive: `mv <path> ~/.Trash/` for filesystem ops, `git rm <path>` for tracked files (history retained), symlink-replacement for symlinks (move-and-recreate).
- Surface the REVERSIBLE command form FIRST when proposing a fix. Never present an irreversible command and ask if-okay — that bypasses command-choice gating.
- Validate reversibility BEFORE running: documented inverse? Undoable in ~5 minutes with at-hand tools (Finder Trash restore, `git reflog`, symlink recreate)?
- Explicit-confirmation gate from [[No deletion without explicit confirmation]] still applies IN ADDITION to reversible-command choice — confirmation does not unlock irreversible commands.
- Compose with [[savepoint]] — when in doubt, savepoint first.
- "go ahead and delete X" / "rm X" from the operator = authorization for the REVERSIBLE form (`mv X ~/.Trash/`), never authorization to type literal `rm`.

**Reversible-substitute table:**

| Irreversible (BANNED)              | Reversible substitute                                   |
| ---------------------------------- | ------------------------------------------------------- |
| `rm <path>`                        | `mv <path> ~/.Trash/`                                   |
| `rm -rf <dir>`                     | `mv <dir> ~/.Trash/`                                    |
| `git rm <tracked-file>` is OK      | (git history retains the file; this is reversible)      |
| `find <dir> -delete`               | iterate + `mv` to `~/.Trash/`                           |
| `truncate -s 0 <file>` / `> file`  | `mv <file> <file>.bak` then write fresh                 |
| `git reset --hard <ref>`           | `git stash` or branch + checkout                        |
| `git clean -fdx`                   | inspect with `--dry-run`, then `mv` untracked to Trash  |
| `git checkout -- <uncommitted>`    | `git stash` first                                       |
| force-push to published ref        | new branch + PR; never overwrite published history      |

**Composes with:**
- Parent: [[No deletion without explicit confirmation]] (gate-1: confirmation), [[Analysis before deletion]] (gate-0: analysis). This axiom adds gate-2: command-choice reversibility.
- Sibling: [[Trash not rm -rf]] — trash-as-substitute is exactly the reversible primitive this axiom mandates.
- Sibling: [[Stop defaulting to trash]] — they don't conflict: trash is the SUBSTITUTE when delete is warranted, NOT the default cleanup verb. Trash-as-substitute and trash-as-routine are different.
- Primitive: [[savepoint]] — substrate's reversibility primitive for in-flight work.
- Meta: [[capture-requires-typed-workflows-and-roles-not-just-memory]] — typed AxiomModel authored first at `kura-spaces/axioms/only-reversible-actions.axiom.su.json`; this memory is the downstream pointer.

**Source:** operator quote 2026-06-07 — "never rm please.... just add that as an axiom: only reversable actions should be done. #axiom" (substrate-CAPTURE invoked same turn per [[deferral-is-drift-do-it-now]]).
