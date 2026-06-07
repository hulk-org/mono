---
name: codex-runtime-state-is-metadata
description: "Codex CLI runtime files under ~/.codex (log/codex-tui.log, logs_2.sqlite, history.jsonl, state_5.sqlite, goals_1.sqlite, sessions/) are METADATA — durable observability/session record, not disposable cache. Do not move, rotate, archive, or truncate them as a diagnostic shortcut."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

When `codex` hangs or misbehaves, do NOT treat large runtime-state files under `~/.codex/` as disposable just because they're heavy:

- `~/.codex/log/codex-tui.log` (can grow to GB scale)
- `~/.codex/logs_2.sqlite` + `-shm` + `-wal`
- `~/.codex/state_5.sqlite` + `-shm` + `-wal`
- `~/.codex/goals_1.sqlite`
- `~/.codex/history.jsonl`
- `~/.codex/sessions/`
- `~/.codex/.codex-global-state.json` (+ `.bak`)

**Why:** these are the operator's durable session/observability record across the entire codex history. They're not scratch caches and the operator considers them irretrievable metadata. Touching them as a "make the symptom go away" move is the wrong reflex — corrected 2026-05-26 when I proposed archiving `codex-tui.log` to test a hang hypothesis.

**How to apply:**
- Diagnose codex hangs by *observing* what the binary is reading (sample, fs_usage, opensnoop, lsof) rather than thinning the haystack.
- Broken symlinks under `~/.codex/agents/<slug>` ARE fair game — those are pointer files with no payload (see [[feedback_codex-agent-symlinks-broken-by-form-moves]] if/when authored).
- For genuine size remediation, ask the operator first and propose a rotation contract (with the new file taking new writes, the old file preserved) — never silent move-asides.
- If the operator approves rotation, prefer renaming the file in place (preserving inode metadata) rather than moving to a different directory.

**Boundary:**
- Configuration files like `config.toml` and its `.bak/.bak2` rotations ARE diff-able, ARE editable, and don't fall under this protection.
- Pointer surfaces (`~/.codex/agents/<slug>` symlinks, `~/.codex/skills` symlink, etc.) are not metadata — they're routing and can be repaired when stale.
