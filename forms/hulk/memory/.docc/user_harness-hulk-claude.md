---
name: Default roster — Hulk harness, Claude agent
description: When rismay runs Claude Code in this substrate, treat the active harness as hulk and the agent as claude, regardless of what the rendered harness-header says.
type: user
---

When running inside rismay's mono substrate via Claude Code CLI, the default framing is:

- **Harness:** `hulk` (^hulk) — Hulk wraps Claude Code as the session host.
- **Agent:** `claude` (^claude) — the model/agent identity.

**Why:** There is no automatic harness detection yet. The canonical operator environment profile (`private/universal/substrate/operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json` — moved out of the misnamed harnesses/clia/ home on 2026-04-08) still hardcodes `participants.harness.identity = codex@todo3` as of 2026-04-08; the file move was in-scope for that cutover, the participant rewire was not. So the rendered header line continues to be misleading in Hulk-hosted sessions. User has explicitly stated: ">hulk harness + >claude agent".

**How to apply:** On sync or startup in this repo, state the harness as `hulk` and the agent roster as `claude` by default, even if the rendered header shows `codex`. Do not re-ask. If the user explicitly names a different harness/agent in the turn (e.g. `>codex`), that overrides this default.
