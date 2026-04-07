# Migration Status — `harnesses/claude/` → `harnesses/hulk/`

## What this is

The "claude home" was the original conflated name for what is now split into
the **hulk carrier** and the **claude agent persona**. The founding-breach
incident of 2026-04-05 named the carrier `hulk` for the first time, and this
migration is the on-disk realization of that split.

This file tracks the in-flight migration so a session interruption doesn't
leave it in an unknown state.

## Migration date

Started: 2026-04-06.

## Layout decision

```
harnesses/hulk/                       — carrier home (the impenetrable hull)
├── .docc/CONTRACT.md                 — bones + skin clauses
├── .docc/index.md                    — hulk technology root
├── .gitignore                        — runtime state ignore patterns (staged)
├── memory/.docc/                     — hulk's carrier-level memory
│   └── insights/founding-breach-2026-04-05.md
├── private/universal/identity/
│   └── hulk@rismay.substrate.identity.json
├── private/universal/domain/tooling/
│   └── claude-code/                  — claude-code TS reference impl (was a submodule, dead remote, now plain content)
├── private/universal/substrate/collectives/ultraworkers/private/
│   └── claw-code/                    — claw-code Rust+Python reference impl (still a live submodule)
├── agents/claude/                    — the claude agent persona home
│   ├── .docc/index.md                — persona profile root
│   ├── AGENDA.md, AGENTS.md, BOOTSTRAP.md, HEARTBEAT.md
│   ├── IDENTITY.md, SOUL.md, USER.md, TOOLS.md, memory.md
│   └── private/universal/identity/
│       ├── claude.commission.json
│       ├── claude.resume.json
│       ├── claude@rismay.substrate.{identity,agenda,chronicle}.json
│       ├── claude@rismay.substrate.persona.agent.triad.md
│       ├── claude@rismay.substrate.reveries.agent.triad.md
│       └── claude@rismay.substrate.system-instructions-{compact,full}.agent.triad.md
└── README.md, SOUL.md, USER.md, IDENTITY.md, AGENDA.md, AGENTS.md
                                      — hulk's own carrier doctrine
```

## Done in 2026-04-06 session

- ✅ `claude-code` reference implementation moved from
  `harnesses/claude/private/universal/domain/tooling/claude-code/` (which
  was a submodule with the now-dead remote `github.com/rismay/claude-code-leaks.git`)
  to `harnesses/hulk/private/universal/domain/tooling/claude-code/` as plain
  content. The submodule entry was removed from the parent's `.gitmodules`
  and the parent's index. Three safety tarballs exist outside the substrate
  in case of corruption.
- ✅ `claw-code` second implementation added to hulk as a live submodule at
  `harnesses/hulk/private/universal/substrate/collectives/ultraworkers/private/claw-code/`,
  registered in hulk's own `.gitmodules`.
- ✅ All 9 top-level persona docs (AGENDA, AGENTS, BOOTSTRAP, HEARTBEAT,
  IDENTITY, SOUL, TOOLS, USER, memory.md) moved from `harnesses/claude/`
  to `harnesses/hulk/agents/claude/`.
- ✅ All 9 identity bundle files moved from
  `harnesses/claude/private/universal/identity/` to
  `harnesses/hulk/agents/claude/private/universal/identity/`.
- ✅ `.docc/index.md` moved and rewritten for the persona-vs-carrier split.
- ✅ Internal sourcePath / link / inherits / persona / system-instructions
  references in the moved identity bundles updated to the new paths.
- ✅ Hulk's own AGENDA, AGENTS, IDENTITY, README, SOUL, USER preserved at
  `harnesses/hulk/` root (they were authored after the founding breach with
  the correct carrier framing and were already correct).
- ✅ Root `CLAUDE.md` updated to point at the new hulk + persona paths.
- ✅ Hulk identity bundle authored with `emoji: 💪` and persona/carrier
  framing.
- ✅ Founding-breach insight already lives at
  `hulk/memory/.docc/insights/founding-breach-2026-04-05.md`.

## Deferred (not in this session — risk)

These items must be done in a fresh Claude Code session, after the live one
that performed the partial migration has ended cleanly. The reason: Claude
Code is actively reading and writing these paths during the live session,
and moving them under the running process is unsafe.

- ⏳ **Memory tree** (`harnesses/claude/memory/.docc/`) — currently has
  ~12 files (feedback_*, project_*, user_*, MEMORY.md, beats/, expertise/,
  insights/, journal/). The auto-memory MEMORY.md is being actively
  written via `~/.claude/memory/.docc/MEMORY.md` (system reminders confirm
  mid-session writes). Move plan: union-merge claude/memory/.docc into
  hulk/memory/.docc, with persona-specific entries (claude-journal,
  claude-expertise) optionally factored into hulk/agents/claude/memory/.docc.
- ⏳ **Runtime state** — `backups/`, `cache/`, `file-history/`, `history.jsonl`,
  `mcp-needs-auth-cache.json`, `plugins/`, `projects/` (live session JSONLs),
  `session-env/`, `sessions/`, `shell-snapshots/`, `tasks/`, `settings.json`.
  These all live under `harnesses/claude/` and are referenced via the
  `~/.claude` symlink. Move all of them to `harnesses/hulk/` and re-point
  `~/.claude` → `mono/private/universal/substrate/harnesses/hulk` (the
  symlink target lives at `/Users/sonoma/.claude`).
- ⏳ **Nested runtime under `claude/private/`** — `file-history/` (per-session
  scratch) and `session-env/` directories. Same class as above.
- ⏳ **`claude/skills` symlink** — already exists as `../skills`, which still
  resolves to `harnesses/skills`. Will become orphaned when `claude/` is
  retired. Hulk already has its own `harnesses/hulk/skills -> ../skills` so
  no work needed beyond removing the orphan.
- ⏳ **Retire `harnesses/claude/`** — once empty, either delete it entirely
  or replace with a symlink → `../hulk/` for legacy compat. Remove from
  parent's index.
- ⏳ **Update `~/.claude` symlink** — currently
  `lrwxr-xr-x  /Users/sonoma/.claude -> mono/private/universal/substrate/harnesses/claude`
  (relative). Re-point to `mono/private/universal/substrate/harnesses/hulk`.
- ⏳ **Sync the claude persona memory file `user_harness-hulk-claude.md`** —
  currently in `~/.claude/memory/.docc/` (parent's mono claude memory) AND
  in claude home memory. Should canonicalize at the new hulk path.

## Safety state

Three surviving copies of the claude-code-leaks TS source tree (the dead
remote means losing the local checkout = losing the data):

1. `harnesses/hulk/private/universal/domain/tooling/claude-code/` (33 MB
   working tree, plain content, gitdir pointer dropped)
2. `~/Documents/claude-code-leaks/` (43 MB original local copy)
3. `~/Documents/claude-code-leaks-2026-04-06-from-claude-home.tar.gz`
   (8.6 MB compressed working tree)
4. `~/Documents/claude-code-leaks-2026-04-06-gitdir.tar.gz` (9.3 MB
   compressed git history — preserves the lineage of the dead remote)

If any of those four are gone, restore from another before proceeding.
