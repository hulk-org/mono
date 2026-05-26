---
name: sync
description: First-sync bootstrap — reload operator profile, resolve commissioned home(s), read active incident in full, run reload-profile + agent-docc, then write+render the header in one CLI invocation. For in-session header re-renders use the `/header` skill instead.
argument-hint: ">h:hulk >a:chatgpt"
---

# Sync

## When to Use This Skill vs `/header`

- `/sync` is the **first sync of a session**. It is the expensive, one-time
  bootstrap that loads the operator environment, resolves commissioned homes,
  reads the full active incident into context, runs the merged profile reload
  and (when relevant) the agent DocC regen, then writes the header state and
  renders it.
- `/header` is the cheap in-session **header refresh**. It just writes mode +
  title for the current session and re-renders. It does not re-read the
  incident, the operator profile, beats, or the chronicle.

Rule of thumb: run `/sync` once per session. Run `/header` (or rely on
reply-standard rule 7) every turn that needs a different mode/title.

## Load Budget

This skill is a kernel. Do not load long doctrine, beat journals, route tables,
or generated profile mirrors by default. Use `reference.md` only when an edge
case below is actually present.

## Fast Path (first-sync bootstrap)

1. Parse `$ARGUMENTS` as roster tokens: `>h:<slug>` selects the harness,
   `>a:<slug>` selects an agent, `>o:<slug>` selects an operator, and bare
   `>slug` is agent shorthand only when unambiguous. Operator-only bare slugs,
   such as `>rismay`, are ghost/self sessions.
2. Default Codex harness sessions to `>h:codex >a:chatgpt` only when no
   explicit agent or operator-only ghost session is present.
3. Load the operator environment profile first:
   `private/universal/substrate/operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json`
4. Resolve requested commissioned homes in this order:
   `private/universal/substrate/agents/<slug>/`,
   `private/universal/substrate/collectives/<slug>/`,
   `private/universal/substrate/orchestrators/<slug>/`.
5. Resolve harnesses from `private/universal/substrate/harnesses/<slug>/`.
   Never resolve `>h:codex` through `agents/codex`; that path is the historical
   commissioned Codex profile and requires explicit `>a:codex`.
6. Read minimal commissioned-home surfaces: local `AGENTS.md`, identity JSON,
   first available beat surface, and last chronicle entry for header title.
7. **Read the active incident in full** from
   `.wrkstrm/incidents/active.incident.wrkstrm.json` when present. The full
   file is loaded once on first sync so that `affectedPaths`, `doNotModify`,
   `blockedTools`, and `severity` are in working context for the rest of the
   session. Subsequent `/header` refreshes rely on the rendered banner alone.
8. Run the directive's combined profile + DocC reload when the commissioned
   home supports it (see `## Combined Reload` below). Treat failures as
   non-fatal and report them in the sync output.
9. Persist header state and render in **one** CLI invocation using
   `header state set --render --quiet` (see `## Canonical Commands`). Use
   `--session-id "$TERM_SESSION_ID"` (or `$CODEX_SESSION_ID` /
   `$WRKSTRM_SESSION_ID` when present) to keep parallel sessions independent.
10. Make the rendered header block the first sync output.

## Canonical Commands

Use the installed executable when present:
`~/.swiftpm/bin/swift-harness-environment-cli` and
`~/.swiftpm/bin/swift-agent-cli`. Otherwise fall back to repo-local SwiftPM.

### Combined state-set + render (one invocation)

```sh
swift-harness-environment-cli header state set \
  --path . --yes \
  --session-id "$TERM_SESSION_ID" \
  --mode <mode> \
  --title "<title>" \
  --harness-identity <harness-identity> \
  --attendees <comma-separated-identities> \
  --render --quiet
```

`--render` prints the resolved header to stdout after writing state. `--quiet`
suppresses the `header state saved:` confirmation lines so the rendered block
is the only output — paste it verbatim as the first content of your reply.

### Combined reload (profile + directives + incident view)

```sh
swift-agent-cli v000_008_000 reload-profile \
  --slug <slug> --path . --format text
```

### Agent DocC refresh (only when regenerated docs matter to the task)

```sh
swift-agent-cli v000_008_000 agent-docc generate \
  --slug <slug> --path . --merged --write
```

## Beat Surfaces

After the commissioned home resolves, read profile-owned beats only from that
home. Prefer:

1. `<home>/memory/.docc/beats/working-beats.md`
2. `<home>/memory/.docc/beats/index.md`
3. `<home>/memory.docc/beats/working-beats.md`
4. `<home>/memory.docc/beats/index.md`

Beats are retrospective memory rhythm surfaces. Beads are prospective
open-work issue artifacts under `<home>/agenda/beads/*.issue.json`; do not read
beads during sync unless the user asks for a bead perspective.

## Header Mode

The header mode defaults to `capture` (sometimes called "capture / plan") on
first sync. The operator's intent is that sync establishes a calm, capture
posture; the agent switches to a more specific mode (`build`, `fix`,
`research`, `recover`, etc.) when the work actually demands it — usually via
`/header` mid-session.

If the commissioned chronicle exists at
`<home>/private/universal/identity/<slug>@rismay.substrate.chronicle.json`,
the last entry's title may be used as the header title (truncated to 60
chars). Do not infer mode from chronicle tags; the chronicle records past
work, not the current turn's mode. If the chronicle is unavailable, leave
existing tmp state alone and let the CLI defaults apply.

## Output Contract

The final sync result should be short. Put the rendered header block first
(verbatim from `--render --quiet`), then report:

- active harness and commissioned roster
- repo/session root + session ID file
- commissioned profile path (identity/agenda/chronicle bundle)
- beat surface path when present
- operator environment profile
- workspace contract family (`$`-directives)
- active incident summary line plus `blockedTools` if any

## Load `reference.md` Only For

- ambiguous bare slugs or duplicate home names
- ghost/self session debugging
- role-autoload or skill-routing decisions
- generated DocC failure recovery
- workspace-bearing collective/operator edge cases
- detailed sync-output audits
