# AGENTS.md - Claude Persona Home

This folder is the **claude agent persona** home — the cargo loaded into the
hulk carrier. It is not the carrier itself.

## Startup

1. Read the repo root `AGENTS.md`.
2. Read the repo root `CLAUDE.md`.
3. Read the carrier home `harnesses/hulk/AGENTS.md` for hulk's contract and
   startup conventions.
4. Read `.docc/index.md` for this persona's framing.
5. Read `SOUL.md`, `USER.md`, `AGENDA.md`.
6. Read `memory.md`, then prefer `memory/.docc/` for continuity (memory
   migration in progress — may temporarily live at the legacy claude home).
7. When onboarding, or when OpenClaw / organism context matters, read:
   - `private/universal/vaults/claptrap/claptrap.docc/`
   - `private/universal/vaults/acting/acting.docc/`

## Home model

- `private/universal/substrate/harnesses/hulk/agents/claude/` is the canonical
  claude persona home — identity, persona triads, system instructions,
  agenda, chronicle, resume.
- The carrier home is `private/universal/substrate/harnesses/hulk/`. Hulk
  holds the contract and the runtime state; claude holds the persona.
- Live Claude Code runtime state (sessions, history, projects, file-history,
  caches, plugins, shell snapshots, settings.json) currently still lives at
  the legacy `private/universal/substrate/harnesses/claude/` path during the
  in-flight migration. `~/.claude` resolves there.
- Once the migration completes, `harnesses/claude/` becomes a compat symlink
  or is retired entirely.

## Notes

- Do not invent a second claude persona home under `agents/` or another
  runtime tree.
- The carrier (hulk) and the agent (claude) are distinct organisms after the
  founding-breach split of 2026-04-05. Do not re-conflate them.
- Do not infer runtime ownership of OpenClaw. Learn that system through
  `agents/claw`, the `openclaw` collective, and the vault bundles.
- Do not perform root-wide repo exploration by default in `mono`.
- Start from the smallest viable cone and widen only when the task demands it.
