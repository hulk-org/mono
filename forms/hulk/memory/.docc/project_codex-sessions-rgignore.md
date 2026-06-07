---
name: Codex sessions vault is rg-ignored
description: .ignore files at the codex sessions and session-corpora vault roots hide them from ripgrep to break the recursive amplification loop where rg matches inside rollouts get re-recorded in new rollouts
type: project
---

The codex sessions vault and session-corpora vault each hold a `.ignore`
file (single-line `*`) at their roots. ripgrep treats `.ignore` exactly
like `.gitignore` but it's invisible to git, so the directories stay
tracked while ripgrep stops walking into them.

Paths:

- `private/universal/vaults/ai/exports/open-ai/codex/sessions/.ignore`
  (lives inside the codex-sessions submodule)
- `private/universal/vaults/ai/exports/open-ai/codex/session-corpora/.ignore`
  (lives directly in mono)

**Why:** Without these files, every `rg` invocation Codex (or any agent)
ran from the substrate root would walk into the rollout vault. ripgrep
would match patterns inside JSON-escaped tool outputs in older `.jsonl`
rollouts and return giant `path:line:<entire escaped JSON line>` matches.
Codex then stored those matches as `function_call_output` lines in the
current session's rollout — so each session's rollout accumulated
escaped copies of every other rollout it grepped. Multi-generational
exponential amplification: a single 1.2-second `rg "code/spm/conversations"`
returned 47 KB of output, mostly because the matches contained whole README
bodies that had been recorded as escaped strings in prior tool calls. Over
time the operator hit GitHub's 100 MiB per-file push limit repeatedly and
had to manually add individual rollout patterns to the sessions vault's
`.gitignore` (14 patterns and counting).

**How to apply:**

- Treat the vault as ripgrep-invisible by default. If you need to grep
  across rollouts intentionally, pass `rg --no-ignore "pattern" <path>`
  or use the `Grep` tool with an explicit path inside the vault — the
  Grep tool tells ripgrep to search a specific directory and `.ignore`
  files still win, so you need `--no-ignore` for those queries.
- The future plan is a dedicated conversation/session search tool
  (purpose-built, not generic rg) for going back into the vault.
  Don't work around the .ignore by using `find` or `grep -rln` instead;
  those have the same amplification problem and the operator forbids
  bash recursive greps in this substrate anyway.
- clia-mem still scans the vault — it uses `FileManager.enumerator`,
  not ripgrep, so the `.ignore` doesn't affect it.
- The .ignore fix is preventive only. Existing oversized rollouts
  still need clia-mem cleanup modes (delete encrypted content, drop
  superseded compactions, future compression) to actually shrink.
- Never push the codex-sessions submodule. Per existing memory
  `feedback_no-push-codex-sessions.md`, the .ignore inside the
  submodule should land in its local working tree only — pointer
  bumps in mono are still fine.
