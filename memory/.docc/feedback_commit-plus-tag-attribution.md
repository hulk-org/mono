---
name: Commit plus-tag attribution
description: mono repo records operator+agent pairing via cmonterroza+<agent>@wrkstrm.com in git Author; digikoma-git commit resolves the tag dynamically from the synced-agents roster
type: feedback
---

In `/Users/sonoma/mono`, commits carry operator+agent attribution via the email
plus-tag convention `cmonterroza+<agent>@wrkstrm.com`. `user.name` stays
`Cristian A Monterroza` globally; only the email's plus-tag varies per active
pairing. There are two wires in play:

1. **Repo-local default** in `mono/.git/config`:
   `user.email = cmonterroza+claude@wrkstrm.com` (set 2026-04-16).
   Applies to any `git commit` run inside mono regardless of entry point.

2. **Session-aware override** in `digikoma-git commit` (digikoma-org, extended
   2026-04-16): when invoked with a `--session-id` (or a
   `KOMA_GIT_SESSION_ID` / `CLIA_SESSION_ID` / `CODEX_SESSION_ID` env var),
   digikoma-git reads `<repo>/.wrkstrm/tmp/synced-agents.jsonl`, finds the matching
   `{sessionId, attendees}` record, strips any existing `+tag` from the repo's
   `user.email`, and reattaches `+<first-attendee>` before invoking git via
   `git -c user.email=...`. Falls through silently when the file is missing,
   the record is absent, attendees is empty, or the computed tag equals the
   repo's current email (no-op).

**Why:** rismay rejected `Co-Authored-By:` trailers (they pollute commit
messages and get dragged around by auto-commit hooks) but still wants every
commit to record which agent they were paired with at the time. Git's native
Author field + plus-addressing is the trailer-free solution. The session-aware
override keeps the tag accurate even when pairings change mid-repo (claude ->
codex etc.) without requiring manual `.git/config` mutations.

**How to apply:**
- Prefer `digikoma-git commit` over direct `git commit` (consistent with the
  existing "Digikoma commits, not agent" feedback). Pass `--session-id <id>` or
  set `KOMA_GIT_SESSION_ID` so the roster lookup can fire.
- Pass `--no-plus-tag` to suppress the override when you specifically want the
  repo-local default to win (rare - usually only for scripted back-dated
  commits the operator is running manually).
- If a different agent joins the session mid-stream, update the synced-agents
  roster (via `/sync >codex` etc.); the next `digikoma-git commit` will pick up
  the new tag automatically. No `.git/config` edit needed.
- When editing `digikoma-git` itself: `AgentRoster.swift` has the roster reader +
  plus-tag resolver as pure functions covered by tests in
  `AgentRosterTests.swift`. The integration point is
  `plusTagConfigArgs(repo:sessionID:disablePlusTag:)` in `DigikomaGitTool.swift`,
  which returns `["-c", "user.email=..."]` or `[]`.

**Scope / limits:**
- Mono-local only. Submodules (`wrkstrm-app`, `clia-app-org`, etc.) still
  inherit the global noreply identity. Do not extend to submodules without
  explicit authorization.
- Global `~/.gitconfig` is NOT touched. Operator manual commits outside mono
  still use the GitHub privacy address.
- Rollback of local default: `git config --local --unset user.email` in mono.
- Rollback of digikoma-git plus-tag: revert the commit that added `AgentRoster.swift`
  and its integration in `digikoma-git-cli/main.swift` + `DigikomaGitTool.swift`.

**Still open:**
- Auto-commit hook referenced in earlier memory is not in
  `~/.claude/settings.json`. When located, verify it routes through
  `digikoma-git commit` so the session-aware tag logic applies.
- Submodule coverage is a separate decision.
