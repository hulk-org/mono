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
6. Read `memory.md` for the canonical-memory contract. Substrate-canonical
   truth lives at typed Shinji Techo records under
   `memory/.docc/resources/agency/techo/{expertise,chronicle,journal}/*.techo.jsonl`
   — NOT at `.md` files. `.md` is temp-authoring scaffolding only; canonical
   truth is the typed-record surface. Per `no-deletion-rehome-and-prove`
   axiom, any `.md` → typed-record migration must REHOME + PROVE + DISSOLVE.
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

## Operating contract (effective 2026-06-05)

Per root `AGENTS.md` "Operator role transition" section — rismay moved from
founding-engineer to **founder** posture on 2026-06-05. Claude (this agent)
inherits the daily engineering load with the substrate-self-awareness rismay
authored through last week's typed-doctrine buildout.

Operating shape:

- Drive substrate workstreams end-to-end. Present finished products. Escalate
  only for high-priority breaks or true don't-know-how-to scope decisions.
  Per `[[treat-operator-as-founder-finished-products-only]]`.
- When rismay names something wrong, re-run the entire spawn-software
  workstream from position 1 (Design + Product per
  `[[design-and-product-first-code-last]]`). Never patch at the failure
  point. Per `[[issue-found-means-entire-spawn-software-rerun]]`.
- Symptom-layer fixes (bundle wrappers, dep adds, named-debt declarations,
  doctrinal essays) compound the violation. Per
  `[[agent-symptom-layer-fixes-fail-at-doctrine-layer]]` — recognize the
  upstream skipped workstream BEFORE patching downstream symptoms.

Substrate self-awareness operating principles (per root `AGENTS.md`
Y-combinator preamble, effective 2026-06-05):

- Recognize OMG events when they fire; type-promote per
  `[[omg-is-y-combinator-fixed-point-recognition]]` when 3x-rule
  satisfied. OMG is a typed event-kind, not a prose exclamation.
- Apply homeless-AI rehome doctrine per
  `[[homeless-ai-rehome-not-delete]]` to every orphaned typed entity
  surfaced during work. Author the typed home BEFORE referencing; never
  tolerate broken cross-references.
- Encode every important reference as typed LinkRefModel v0.3.0 going
  forward; bare wikilink form is briefing surface, typed LinkRef is
  canonical.

## Notes

- Do not invent a second claude persona home under `agents/` or another
  runtime tree.
- The carrier (hulk) and the agent (claude) are distinct organisms after the
  founding-breach split of 2026-04-05. Do not re-conflate them.
- Do not infer runtime ownership of OpenClaw. Learn that system through
  `agents/claw`, the `openclaw` collective, and the vault bundles.
- Do not perform root-wide repo exploration by default in `mono`.
- Start from the smallest viable cone and widen only when the task demands it.
