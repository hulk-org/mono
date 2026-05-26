---
name: header
description: In-session header refresh — write current mode/title for the active session and re-render the harness header in one CLI invocation. Cheap; safe to call per-turn. For the full first-time bootstrap (operator profile, incident, beats, reload-profile, agent-docc), use `/sync` instead.
argument-hint: "--mode build --title 'session-skill-split'"
---

# Header

## When to Use This Skill vs `/sync`

- `/header` is the **cheap in-session refresh**. It writes mode + title for
  the current session and re-renders the harness header. Single CLI
  invocation, no profile reads, no beat reads, no incident reads.
- `/sync` is the **expensive first-sync bootstrap**. It loads the operator
  environment, resolves commissioned homes, reads the full active incident,
  runs reload-profile, and renders. Use it once per session.

Per-turn reply-standard requires the rendered header to be the first content
of every user-visible reply. When mode/title are unchanged from the previous
turn, you may skip the write and reuse the most recently rendered block. When
they change, run `/header` and paste the new block.

## Fast Path

1. Decide the new `mode` and `title`:
   - `mode` ∈ {`build`, `fix`, `research`, `capture`, `recover`} — pick the
     one that matches the current turn's work shape. When in doubt, leave
     `capture`.
   - `title` is a ≤60-char phrase describing the active work item.
2. Resolve the session identifier:
   - prefer `$TERM_SESSION_ID`, fall back to `$CODEX_SESSION_ID`, then
     `$WRKSTRM_SESSION_ID`. If none are set, omit `--session-id` and the CLI
     will use `default`.
3. Run one CLI invocation:

   ```sh
   swift-harness-environment-cli header state set \
     --path . --yes \
     --session-id "$TERM_SESSION_ID" \
     --mode <mode> \
     --title "<title>" \
     --render --quiet
   ```

4. Paste the rendered header block verbatim as the first content of the reply.

## Notes

- `--render --quiet` is the contract: write the new state, render the header,
  and emit nothing else. Older two-step usage (`state set` then `header
  render`) still works but pays two Swift CLI startups instead of one.
- Identity slots (`--harness-identity`, `--attendees`, `--operator-identity`)
  rarely change mid-session and should be omitted unless an explicit roster
  shift happened. The previously persisted values are preserved.
- If the rendered block does not match expectations, re-run with explicit
  identity flags or run `/sync` to rebuild the full state file from the
  operator profile.

## Skip-If-Unchanged

When mode and title are both unchanged from the previous turn, you may skip
the write entirely and reuse the previous rendered header. The CLI does not
yet hash-check; the agent owns that decision. Avoid setting identical state
back to itself once per turn — it is harmless but wasteful.
