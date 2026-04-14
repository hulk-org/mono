@Metadata {
  @PageKind(article)
  @TitleHeading("claude (agent persona)")
}

# claude

The Claude agent persona — the cargo, not the carrier. Lives inside the
`hulk` carrier home as one of several possible agent personas hulk can host.

## Purpose

- `private/universal/substrate/harnesses/hulk/agents/claude/` is the canonical
  claude persona home.
- It carries the commissioned identity bundle, persona triads, system
  instructions, agenda, chronicle, and resume — everything that defines
  *claude as an agent*, separate from the carrier hulk loads it into.
- Hulk is the carrier. Claude is the cargo. The two are distinct organisms.

## Lineage

Before the founding-breach response of 2026-04-05, this content lived at
`private/universal/substrate/harnesses/claude/` where the carrier and the
agent were conflated under a single "claude" name. The 160 GB host RAM leak
that triggered the hulk org and the harness contract also revealed that the
*carrier* (hulk) and the *agent persona* (claude) needed separate homes.
This directory is the agent half of that split.

## Tracking policy

- Commissioned docs, memory, and identity inside this directory are tracked.
- Runtime state (sessions, history, caches, plugins, shell snapshots) lives
  in the carrier home (`harnesses/hulk/`), not here.

## Adjacent surfaces

- Carrier home (hulk): `private/universal/substrate/harnesses/hulk/`
- Hulk contract: `private/universal/substrate/harnesses/hulk/.docc/contract.md`
- Founding insight: `private/universal/substrate/harnesses/hulk/memory/.docc/insights/founding-breach-2026-04-05.md`
- Repo-global Claude guidance: `CLAUDE.md`
- Legacy claude home (live runtime state during migration):
  `private/universal/substrate/harnesses/claude/`
