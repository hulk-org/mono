# 2026-05-18 — Memory Home Follows Synced Agent

The substrate-canonical rule for where claude-the-assistant writes
persistent memory during a session.

## The rule

**Memory home is determined by which agent is synced.**

- When the active synced agent is the **claude persona**, writing to
  `~/.claude/memory/.docc/` is correct. That path symlinks to
  `harnesses/hulk/memory/.docc/` (the hulk carrier home that hosts the
  claude persona), and the Claude Code CLI's auto-memory directive
  points there.
- When the active synced agent is **any non-claude commissioned
  agent** (e.g. walter, claw, codex, chatgpt), memory writes belong in
  the substrate-canonical commissioned home: `agents/<slug>/memory/.docc/`,
  `operators/<slug>/memory/.docc/`, `collectives/<slug>/memory/.docc/`,
  or `orchestrators/<slug>/memory/.docc/` — whichever the synced agent
  resolves under.

Entity-specific memory follows the entity, not the synced agent:

- Memory about an operator (rismay's career, biography) →
  `operators/<slug>/memory/.docc/`.
- Memory about a collective (wrkstrm positioning, company facts) →
  `collectives/<slug>/memory/.docc/`.
- Memory about a specific agent (walter's namesake, walter's craft) →
  `agents/<slug>/memory/.docc/` or directly into the agent's identity
  JSON when the fact is identity-load-bearing.
- Claude-craft rules (how to operate as claude, how to draft external
  copy, how to handle a given form) → `harnesses/hulk/agents/claude/memory/.docc/expertise/`.

## Why

`~/.claude` symlinks to the hulk carrier, not to the claude persona.
The Claude Code auto-memory mechanism dumps everything there as a flat
`feedback_*.md` / `project_*.md` / `user_*.md` pile. That's fine for
harness-runtime notes (cache, session state, harness-craft), but it
collapses substrate-entity facts into a single carrier-level dump
instead of co-locating each fact with the entity that owns it.

Substrate-discipline: memory belongs in the commissioned home of the
agent or entity it describes. The Claude Code auto-memory protocol is a
*default*, not a *destination*. The synced agent should redirect.

## Operational behavior

At sync time:

1. Identify the active synced agent (`>a:<slug>`).
2. For each memory write during the session, ask: is this fact about a
   specific substrate entity, or is it about claude-the-assistant's
   operating craft?
3. Route entity-specific memory to that entity's commissioned home.
4. Route claude-craft memory to the claude persona expertise home
   (`harnesses/hulk/agents/claude/memory/.docc/expertise/`), regardless
   of which agent is synced.
5. Use the DocC structure of each home (`expertise/` for craft
   surfaces, `journal/` for dated session entries, `ideas/` for
   ideation surfaces where present).

## Why this rule was authored

On 2026-05-18, while operating walter (synced via `>h:claude >a:walter`)
to draft Speedrun investor copy, I wrote eight memory files to
`~/.claude/memory/.docc/` (= hulk carrier) instead of to the proper
substrate-canonical homes. rismay caught it: "your memory for claude
should be in the relevant agents. isn't that in the hulk harness?"
Today's mis-routed memories were migrated and this rule was authored as
claude persona expertise so the next session doesn't repeat the
mistake.

## Related

- `feedback_save-insights-docc.md` (hulk carrier auto-memory) — the
  related older rule that said "write insights to claude home
  memory/.docc/insights/." Today's rule extends it: not just claude
  home; specifically the synced agent's home.
- `audit-not-eyeball-clone` doctrine — applies here: before writing
  memory, audit the synced-agent context and pick the right home.
