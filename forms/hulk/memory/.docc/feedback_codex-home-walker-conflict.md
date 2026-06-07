---
name: codex-home-walker-conflict
description: "Codex 0.134.0's tier-1 FS walker doesn't honor .gitignore and follows symlinks recursively, so CODEX_HOME cannot host bulk content OR symlinks into substrate submodules. Slimming required to fix `codex doctor` hangs."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 80d30d4d-f88b-458d-977f-2015247c8a52
---

**Substrate ↔ codex walker collision** — codex 0.134.0's state walker is tier-1 (raw FS, doesn't honor `.gitignore`, follows symlinks). When CODEX_HOME is `private/universal/substrate/harnesses/codex/` (per the carrier-vs-persona doctrine), three classes of bloat make `codex doctor` spin forever with **zero output**:

1. **Bulky CODEX_HOME files** — `logs_2.sqlite` (~450 MB), `state_5.sqlite` (~18 MB), `goals_1.sqlite`, `log/codex-tui.log.archived-*` (~1.4 GB), `sessions.bak.*` (~190 MB). Walker enumerates every byte.
2. **`agents/` forward-symlinks in CODEX_HOME** — `harnesses/codex/agents/<slug> → ../../../agents/<slug>` (the 12 carrier-vs-persona forwards). Walker follows the symlink into each agent home and descends into each submodule's `.git/objects/` tree (thousands of git objects per agent).
3. **`active-workspace-roots: ["/Users/sonoma/mono"]` in `.codex-global-state.json`** — would route the walker into the entire monorepo (272 `.build/` + 3,568 `__pycache__/` + 8.4 GB DerivedData + node_modules + venvs). May or may not be a separate walk path from CODEX_HOME-recursive; needs more testing.

**Why:** Operator-debugged 2026-05-26 ("codex is still not loading"). After purging 272 `.build/` directories (irreversible) AND moving bulky CODEX_HOME content to `kura/collections/ai/exports/open-ai/codex/sqlite-snapshots/2026-05-26-pre-slim/`, doctor STILL hung — walker was descending into agent-symlink submodules. Stashing the 12 forward-symlinks to the same kura snapshot dir made doctor complete in seconds (exit 0, 13 ok · 1 idle · 2 notes · 0 warn · 0 fail).

## What was actually fixed 2026-05-26

| Step | Action | Outcome |
|---|---|---|
| 1 | Purged all 272 `.build/` dirs via `find -rm -rf` (irreversible — should have used `digikoma-build-clean`) | Reduced FS-only fractal bloat substrate-wide |
| 2 | Moved bulk CODEX_HOME content to `kura/.../sqlite-snapshots/2026-05-26-pre-slim/` (logs_*.sqlite*, state_*.sqlite*, goals_*.sqlite*, log/, sessions.bak.20251001120314/) | Slimmed CODEX_HOME top size from 1.4 GB → 51 MB |
| 3 | Stashed the 12 `harnesses/codex/agents/<slug>` forward-symlinks to `.../2026-05-26-pre-slim/codex-agents-symlinks/agents-from-codex-home/` | Stopped walker from following symlinks into submodule `.git/objects/` trees |

After step 3: `codex doctor` completes in seconds; websocket to chatgpt.com connects (HTTP 101); all green except two notes (rollouts size + mixed auth signals).

## Doctrine implications

- **CODEX_HOME cannot be a substrate-walked path**. The carrier-vs-persona forward-symlinks need a different home (e.g., `.docc/agent-forwards/` that codex doesn't recognize as a workspace dir; or moved to a `.codex-doctrine/` sibling outside CODEX_HOME walk; or eliminated entirely and discover-via `swift-agent-cli roster` calls `agents/` directly).
- **Bulky operational content** (sqlites, logs, sessions backups) should live OUTSIDE CODEX_HOME and harvest into typed kura records. The harvest-later destination at `kura/collections/ai/exports/open-ai/codex/sqlite-snapshots/2026-05-26-pre-slim/` is intake-staging; future work: build `digikoma-codex-harvest` to convert these raw bytes into typed kura records (logs_2 → timeline, state_5/threads → timeline, goals_1 → collection).
- **active-workspace-roots in `.codex-global-state.json`** should NOT be the full mono root. Operator workflow needs `/Users/sonoma/mono` for actual editing context, but doctor's walker should be scoped narrower. Possibly a codex CLI flag or env override needed.
- **codex doctor IS the canary** — if doctor hangs, codex sessions will eventually hit the same walker. Doctor as fast feedback loop for "is CODEX_HOME tractable?"

## How to apply

- **Before treating `~/.codex` as a normal home directory**, audit what's reachable via FS walk: bulk files, symlinks (especially into git submodules), workspace-roots state.
- **When operator reports "codex is not loading"** and the binary works: suspect the walker. Test with `CODEX_HOME=/tmp/scratch-home` + just config.toml + auth.json to confirm.
- **When slimming CODEX_HOME**, peel layers in this order: (1) bulk files (sqlites, logs); (2) symlinks into git submodules; (3) workspace-roots configuration. Test doctor between each layer to identify which is actually load-bearing.
- **Don't `rm -rf` the sqlites** — they hold real runtime history (120k log rows, every thread's structural metadata, every goal's status). Move to kura harvest-later destination first; build typed harvester later.
- **Composes with [[feedback_seasonal-digikoma-forms]]** — a future `digikoma-codex-harvest` (potentially Halloween-themed: "harvest the souls from the crypts of sqlite") would close this loop by emitting typed kura records.
- **Composes with [[feedback_data-is-one-thing-rendering-is-projection]]** — codex's sqlite is a runtime projection; kura should own truth so we can reload after slimming.
- **Composes with [[feedback_digikoma-build-clean-exists]]** — use `digikoma-build-clean` for `.build/` cleanup (recoverable), not raw `find -rm -rf` (irreversible — substrate lost ~10 GB of build artifacts that won't be back without rebuild).
