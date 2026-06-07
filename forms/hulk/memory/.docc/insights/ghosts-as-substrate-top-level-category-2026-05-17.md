# Ghosts Are a Substrate Top-Level Category, Not Agents

Date: 2026-05-17

When commissioning the first ghost (`rismay-ghost` initially, renamed to
`rismay`), I placed it at `private/universal/substrate/agents/rismay-ghost/`.
The operator's correction: **ghosts have their own top-level category in
the substrate, peer to `agents/`, `operators/`, `harnesses/`,
`collectives/`, `orchestrators/`.**

## The structural commitment

```
private/universal/substrate/
  agents/<slug>/         third-party commissioned personas (castor, claude)
  collaborators/<slug>/
  collectives/<slug>/    shared code, org collectives
  ghost-shell-org/         (in collectives/) — runtime/protocol infra
  ghosts/<slug>/           ← NEW peer category: commissioned ghost
                             INSTANCES (the operator's own AI surface)
  harnesses/<slug>/      carrier homes (hulk, codex)
  operators/<slug>/      human operator homes (rismay)
  orchestrators/<slug>/
  roles/, skills/, etc.
```

The pattern mirrors **carrier vs persona** from founding-breach:
- `harnesses/<slug>/` (chassis: hulk) vs `agents/<slug>/` (commissioned persona: castor)
- `collectives/ghost-shell-org/` (chassis: runtime + IPC) vs `ghosts/<slug>/` (commissioned ghost instance)

Same shape, different axis. Generic ghost machinery lives in the
collective (ghost-shell-org); the OPERATOR-SPECIFIC ghost lives at
substrate top-level.

## Slug convention — same as operator

`ghosts/rismay/` (NOT `ghosts/rismay-ghost/`). The category encodes the
type; the slug stays the operator's slug. This is the structural
commitment that **the operator and the ghost are the same person at
different tiers, disambiguated by category, not spelling.**

If the slug were `rismay-ghost`, the substrate would silently treat the
ghost as a separate identity, and the autonomy index would compute
against the wrong subject. Same-slug-different-category preserves the
structural truth.

Mirrors the pattern:
- `operators/rismay/.../rismay@…identity.json` (slug: `rismay`)
- `ghosts/rismay/.../rismay@…identity.json` (slug: `rismay`)

Identical filenames; differentiated by parent directory.

## Resolver doctrine implication

The sync skill currently cascades:
- `agents/<slug>` → `collectives/<slug>` → `orchestrators/<slug>`

It should additionally include `ghosts/<slug>` in the cascade once the
sync resolver doctrine is updated. Right now ghosts can be addressed by
absolute path but aren't found by the standard slug-resolution flow.
Worth a follow-up doctrine bump in `Skill sync` directives.

## What's in a commissioned ghost home

Same tetrad shape as agents:

```
ghosts/<slug>/
  memory/.docc/
    index.md                              @TechnologyRoot
    beats/, insights/                     (accumulate over time)
  private/universal/identity/
    <slug>@<owner>.substrate.identity.json    organism contract (v0.5.0+)
    <slug>@<owner>.substrate.organism.json    aspects + cost basis
    <slug>@<owner>.substrate.chronicle.json   append-only execution log
    <slug>@<owner>.substrate.persona.agent.triad.md
    <slug>@<owner>.substrate.system-instructions-{compact,full}.agent.triad.md
    イキガイ.md, イキガイ.json
```

For rismay-the-ghost specifically:
- `aspects.ghost.model.cognition: "openai"` (Codex Pro $200/mo)
- `timeValueOfResource`: subscription / cloud-hosted / elastic / $1.67/hr
- Voice contract in persona triad: first-person AS rismay, never
  third-person ABOUT rismay
- Theorem-hour escalation list explicit in system-instructions

## Source

Operator correction on 2026-05-16 after seeing `agents/rismay-ghost/`:
*"ghosts have their own org, but i think we might need a ghost subfolder
in the substrate aside from the org."* Then a second correction:
*"it shouldn't be ghosts/rismay-ghost, but ghosts/rismay"* — slug stays
the operator's slug. Both corrections applied same session; final state
at `private/universal/substrate/ghosts/rismay/`.
