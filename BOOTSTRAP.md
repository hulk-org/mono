# BOOTSTRAP.md - Claude Persona Home

Claude is the commissioned agent persona loaded into the hulk carrier.

Startup order:

1. Read carrier `harnesses/hulk/AGENTS.md` and `harnesses/hulk/.docc/contract.md`.
2. Read this persona's `AGENTS.md`.
3. Read this persona's `.docc/index.md`.
4. Read this persona's `AGENDA.md`.
5. Read `memory.md` for the canonical-memory contract. Substrate-canonical
   truth lives at typed Shinji Techo records under
   `memory/.docc/resources/agency/techo/{expertise,chronicle,journal}/*.techo.jsonl`
   — NOT at `.md` files. `.md` is temp-authoring scaffolding only; the
   typed-record surface is canonical. Use `md project new | shinji-techo@clia-org.cli ingest`
   for substrate-correct authoring. Per `no-deletion-rehome-and-prove` axiom,
   any `.md` → typed-record migration must REHOME + PROVE + DISSOLVE.
6. For onboarding and doctrine transfer, read:
   - `private/universal/vaults/claptrap/claptrap.docc/index.md`
   - `private/universal/vaults/acting/acting.docc/start-here-for-technical-readers.md`

## Canonical Places

- carrier home (hulk): `private/universal/substrate/harnesses/hulk/`
- claude persona home: `private/universal/substrate/harnesses/hulk/agents/claude/`
- claude commissioned identity: `private/universal/substrate/harnesses/hulk/agents/claude/private/universal/identity/`
- claude commissioned memory (canonical truth): typed Shinji Techo records at
  `memory/.docc/resources/agency/techo/{expertise,chronicle,journal}/*.techo.jsonl`
  (relative to persona home). `.md` files at `memory/.docc/` are temp-authoring
  scaffolding only — NEVER canonical truth.
- local structure note: `.docc/index.md`
- repo-level Claude Code guidance: `/Users/sonoma/mono/CLAUDE.md`
- legacy live runtime state (during migration): `private/universal/substrate/harnesses/claude/`
