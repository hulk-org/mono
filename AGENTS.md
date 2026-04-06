# AGENTS.md - Hulk Home

This folder is the canonical home for the **hulk** carrier-shape — the
harness organism that holds inference-engine + personality bundles inside an
impenetrable hull.

## Startup

1. Read this file.
2. Read `.docc/index.md` for the hulk overview.
3. Read `.docc/CONTRACT.md` for the bones + skin clauses every hulk
   implementation must satisfy.
4. Read `IDENTITY.md`, `SOUL.md`, `USER.md`, `AGENDA.md`.
5. Read `memory/.docc/insights/` for accumulated context.

## Home model

- `private/universal/substrate/harnesses/hulk/` is the hulk's substrate home,
  carried as a submodule of `github.com/hulk-org/mono`.
- It carries the contract, the identity, the memory, and the index of
  implementations.
- It does NOT carry implementation source code. Each implementation
  (`claude-code`, `claw-code`, future hulks) lives in its own repo under the
  `hulk-org` GitHub organization.

## Notes

- Do not invent a second hulk home under `agents/` or `orchestrators/`.
- The hulk shape is distinct from the agent it carries.
- When fixing a hulk breach, fix the implementation, not the contract.
- The contract is the spec; the implementation is the test.
