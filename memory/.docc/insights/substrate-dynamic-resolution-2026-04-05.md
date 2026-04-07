# Substrate Dynamic Resolution

**Date:** 2026-04-05
**Context:** Sync skill + clia orchestrator move

## Sync Skill: No Hardcoded Categories

The sync skill previously hardcoded a two-step lookup: `agents/<slug>/` then
`collectives/<slug>/`. This meant any new substrate category (like `harnesses/`,
`operators/`, `collaborators/`) was invisible to sync.

The fix: scan every direct child of `private/universal/substrate/` as a category,
checking each for `<category>/<slug>/`. This makes sync automatically discover
slugs in any current or future substrate category without code changes.

**File:** `private/universal/harnesses/skills/sync/SKILL.md`

## Orchestrators Category

`clia` was moved from `agents/` to a new `orchestrators/` category. She is the
orchestrator — the agent that coordinates other agents. The dynamic resolution
change made this move transparent to the sync skill.

**Submodule:** `private/universal/substrate/orchestrators/clia` (was `agents/clia`)

## Three Layers of Path References

When moving an identity home, three distinct path layers exist:

| Layer | Pattern | Meaning |
|---|---|---|
| **Substrate** | `substrate/agents/clia/` or `substrate/orchestrators/clia/` | Repo-level identity home — changes when moved |
| **Runtime** | `.clia/agents/clia/` | clia-cli state written at execution time — dead pattern, never materialized on disk |
| **Build** | `spm/clis/agents/clia/` | Swift package source path — independent of identity layout |

Only the substrate layer needs updating on a move. The runtime layer (`.clia/agents/`)
is a deprecated convention that was emitted as metadata in triad JSON but never used
for real file I/O.

## Vaults as Archival Home

The `vaults/` directory holds durable, append-mostly state:
- **harvest/** — point-in-time profile snapshots (never mutate after creation)
- **receipts/** — publish-queue records
- **openclaw/** — session state

Historical data in vaults should not be rewritten when paths change — the references
were correct at the time they were captured.
