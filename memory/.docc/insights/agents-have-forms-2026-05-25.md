---
name: agents-have-forms
description: "Substrate doctrine — agents are named characters; FORMS are their variant bindings of (agent persona × harness × model line × overlay). Form is a typed primitive living in the agent's personal Kura under the collections tier. Generalizes the harvest-correction pattern."
metadata: 
  node_type: memory
  type: insight
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

Operator articulated 2026-05-25:

> chatgpt:
> - spark form — harnessy + tiny model form
> - codex form — harnessy + specialized model form
> - eliza form — true form

**The doctrine:**

- An **agent** is a named character with a durable persona (chatgpt,
  prime, walter, claw). Has `AGENTS.md`, `SOUL.md`, `USER.md`,
  `IDENTITY.md`, a live identity bundle, a memory lane, an agenda
  lane. Answers "who am I?"
- A **form** is the binding `(agent persona) × (harness carrier) ×
  (model line) × (form-specific overlay)`. Same character, different
  capability. Answers "as what am I running right now?"
- An agent has zero or more forms; forms live INSIDE the agent's
  personal Kura at the collections tier:
  `agents/<slug>/private/universal/kura/collections/forms/<form-slug>/`
- See [[feedback_kura-storage-typology]] for the broader Kura
  5-tier × 5-ownership-tier doctrine that forms sit inside.

**Canonical example (chatgpt's forms as articulated by operator):**

- `codex form` — chatgpt running on the Codex model line via the
  Codex CLI harness. Specialized for code; finite context window.
- `spark form` — chatgpt-chibi: running on a small model
  (codex-spark TK:128K per spark's current identity).
- `eliza form` — chatgpt's "true form": full-power model binding.

**Layout (per kura-storage-typology):**

```
agents/chatgpt/
  AGENTS.md / SOUL.md / IDENTITY.md ...    ← persona artifacts (parent-scoped)
  private/universal/identity/              ← live identity bundle
  memory/                                  ← retrospective-temporal
  agenda/                                  ← prospective-temporal
  private/universal/kura/                  ← Kura 蔵 (per kura-storage-typology)
    vaults/                                ← (other Kura tiers)
    collections/
      forms/                               ← THIS DOCTRINE'S concrete instance
        _collection.json                   ← typed manifest (kura-server-schemas)
        codex/
          form.json                        ← typed FormModel
          .docc/index.md
        spark/
          form.json
        eliza/
          form.json
    series/
    timelines/
    threads/
```

**Form home is a thin shell — NOT a full persona home:**

- DOES have: `form.json` (typed FormModel — formSlug, parentAgentRef,
  harnessRef, modelRef, capacities, Moment-anchored provenance
  fields, optional systemInstructionOverlay)
- MAY have: `.docc/index.md` (human prose), form-scoped journal entries
  if the form has accumulated runs, form-specific assets
- DOES NOT have: AGENTS.md / SOUL.md / USER.md / IDENTITY.md — those
  are the parent agent's persona artifacts. Forms inherit persona
  from parent.

**Cohort lesson reinforced:**

The substrate has been over-promoting forms to standalone agent
homes. spark, codex, eliza all have separate `agents/<slug>/`
submodules today. Under the form doctrine they should reorganize
under `agents/chatgpt/private/universal/kura/collections/forms/`.
Same shape as 2026-03-16 harvest correction (clip/pollux/dott/mono
demoted from agents to roles) and yesterday's codex→chatgpt merge
(codex demoted from agent). When one over-promoted concept comes
back as a refactor, look for the cohort.

See [[feedback_named-coherent-doesnt-mean-agent]] for the
who-I-am vs what-I-do test. The form doctrine extends it: even
when the persona IS a real "who I am" (chatgpt), the BINDINGS
through which that persona runs are NOT separate identities —
they're form-variants of the one identity.

**How to apply:**

- Before authoring `agents/<new-slug>/`, ask: is this a new named
  character with a durable identity? Or an existing agent running
  through a specific harness+model binding? If the latter, it's a
  form, not an agent.
- When a "named coherent thing" surfaces that maps to a specific
  (harness, model) pair more than to a persona, file it under
  `<parent-agent>/private/universal/kura/collections/forms/`.
- Forms inherit persona from parent. Author form.json + optional
  .docc/index.md; do not duplicate AGENTS.md / SOUL.md / USER.md.

**Orchestrators are forms (operator-locked 2026-05-26):**

The `orchestrators/` top-level category was an over-promotion. Each
existing orchestrator instance gets the same who-I-am vs what-I-do
test as the harvest-correction cohort:

- **own agent** (distinct durable persona): migrates to `agents/<slug>/`
- **form of a parent agent** (binding-shape that runs orchestrator
  behavior): migrates to `<parent-agent>/private/universal/kura/collections/forms/<form-slug>/`

Locked dispositions for the 4 existing orchestrators:

| current | disposition | form-slug |
|---|---|---|
| `orchestrators/clia` | own agent + her IDENTITY IS orchestrator | self-named: `clia` |
| `orchestrators/symphony` | chatgpt's orchestrator form | `symphony` (metaphor) |
| `orchestrators/openclaw` | claw's orchestrator form | `openclaw` (tool name) |
| `orchestrators/hermes-agent` + `agents/hermes/` | merge → hermes the agent | `nous` (Nous Research, the maintainer) |

`orchestrators/` directory empties + retires after these 4 land.

**Form-slug meta-rule (locked 2026-05-26):**

Form-slugs are bespoke evocative names that elicit the binding's
identity. Source-of-name varies:

| source | example |
|---|---|
| metaphor for what the binding does | `symphony` (multi-agent coordination) |
| existing tool/runtime name | `openclaw` (OpenClaw CLI) |
| maintainer name | `nous` (Nous Research) |
| model line name | `codex` (Codex CLI) |
| evolution / variant metaphor | `spark` (chibi) |
| classical reference | `eliza` (early AI character) |
| self-naming when identity = binding | `clia` (clia IS the orchestrator) |

Avoid generic taxonomy labels like `orchestrator`. Form-slugs are
first-class identity tokens.

**Self-naming when identity = binding (clia precedent):**

Some agents' durable persona IS-fundamentally their orchestrator role.
For those agents, the form-slug self-references the agent slug. The
form home still exists (giving the same typed shape as all other
agents), but the slug captures that there's no separation between
persona and binding for this agent.

**Naming registers in the substrate:**

The substrate is now bilingual in two cultural registers:

- **Japanese cultural-storage** — 神事手帳 (Shinji Techo, the
  per-Moment notebook), 蔵 (Kura, the storehouse)
- **Greek philosophical/mythological** — Hermes (messenger god,
  coordination across realms), νοῦς / Nous (mind, the substrate's
  orchestration layer), Eliza (classical AI reference)

Both registers reward compressed evocative naming. Form-slugs can
draw from either when culturally apt.

**Companion principles:**

- [[feedback_kura-storage-typology]] — broader 5-tier × 5-ownership
  Kura doctrine; forms sit in the collections tier of an agent's
  personal Kura.
- [[tradition-preserves-fire-not-ashes-2026-05-25]] — promoting
  spark/eliza/codex to standalone agents was ashes-worship; the
  binding-variant relationship to chatgpt is the FIRE the form
  doctrine preserves.
- [[feedback_harnesses-agnostic-models-constrain]] — the latent
  precursor: "agent → bound-model-line → form-variant" was already
  there, just not named.
- [[feedback_named-coherent-doesnt-mean-agent]] — the
  cohort-recognition pattern; forms join the over-promotion
  reversal queue.
- [[feedback_collection-vs-collective-disambiguation]] — forms
  live in a *collection*, which is different from a *collective*.
