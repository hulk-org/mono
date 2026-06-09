@Metadata {
  @PageKind(article)
  @TitleHeading("claude (agent persona)")
}

# claude

The Claude agent persona — the cargo, not the carrier. It is commissioned here
and carried by the Claude hulk harness form during runtime.

## Purpose

- `private/universal/substrate/agents/claude/` is the canonical commissioned
  Claude agent home.
- It carries the commissioned identity bundle, persona triads, system
  instructions, agenda, chronicle, and resume — everything that defines
  *claude as an agent*, separate from the carrier hulk loads it into.
- Hulk is the carrier. Claude is the commissioned agent. The two are distinct
  organisms.

## Lineage

Before the founding-breach response of 2026-04-05, the runtime and agent
surfaces were conflated under a single "claude" name. The 160 GB host RAM leak
that triggered the hulk org and the harness contract also revealed that the
*carrier* (hulk) and the *commissioned agent* (claude) needed separate homes.
This directory is the agent half of that split; `harnesses/claude/forms/hulk/`
is the carrier half.

## Tracking policy

- Commissioned docs, memory, and identity inside this directory are tracked.
- Runtime state (sessions, history, caches, plugins, shell snapshots) lives in
  the carrier home (`harnesses/claude/forms/hulk/`), not here.

## Adjacent surfaces

- Carrier home (hulk): `private/universal/substrate/harnesses/claude/forms/hulk/`
- Hulk compatibility alias: `private/universal/substrate/harnesses/hulk/`
- Hulk contract: `private/universal/substrate/harnesses/claude/forms/hulk/.docc/contract.md`
- Founding insight: `private/universal/substrate/harnesses/claude/forms/hulk/memory/.docc/insights/founding-breach-2026-04-05.md`
- Repo-global Claude guidance: `CLAUDE.md`
- Vanilla Claude Code form:
  `private/universal/substrate/harnesses/claude/forms/claude-code/`
