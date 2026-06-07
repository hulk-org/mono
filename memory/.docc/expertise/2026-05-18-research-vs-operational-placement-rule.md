# 2026-05-18 — Research vs Operational Placement Rule

A claude-craft rule for where to author files in the substrate.

## The rule

**Research-grade artifacts (schemas, render lenses, preview
demonstrations, prototype scripts, doctrine drafts) land in
`wrkstrm-research` under the appropriate campus (or a new one if none
fits).**

**Operational records (submission text, application-specific catalogs
of typed data, biographical chronicles, journal entries, the file that
*was actually submitted to a partner*) stay in the originating
collective's operational archive.**

The cleavage question is: *"Is this exploration, or is this submission
record?"* Exploration moves to research; records stay where they
originated.

## Why

`wrkstrm-research` exists so all substrate explorations stay in sync.
When schemas live in the wrkstrm collective and the render lens lives
elsewhere and the deploy receipt is in a third place, future agents
(and rismay himself) can't assemble the picture without crawling four
directories. Co-locating research artifacts under one campus lets the
cross-references compound: the `index.md` in the campus root pulls all
pieces together.

Operational records, by contrast, are dated submission artifacts. They
*are* the record of what was sent to a specific recipient on a specific
date. They shouldn't be sliced up across multiple campuses; they're
the operational truth of a single transaction.

## How to apply

When authoring a new artifact, ask in order:

1. **Is this an exploration, a schema, a prototype, a doctrine, a
   render lens, a preview, a test harness, an investigation?** →
   `wrkstrm-research/.../<campus>/<venue>/` where `<venue>` is one of
   `gym/zoo/museum/school/threads/catalogs/identity` per the campus
   pattern.
2. **Is this a record of something that was sent to an external
   recipient (an application submission, a press release, a contract,
   a deliverable)?** → `<originating-collective>/private/applications/`
   or similar operational archive in the collective that owns the
   relationship.
3. **Is this an instance of typed data that belongs to a specific
   transaction (a per-application claims catalog, an invoice, a
   purchase order)?** → operational archive alongside the submission
   record, with `schemaRef` and `ordinalityTableRef` fields that point
   at the canonical typed contracts in `wrkstrm-research`.

## What this rule was authored from

On 2026-05-18, while building the typed-claims + render-lens stack for
the a16z Speedrun application, I authored schemas, an ordinality
table, a catalog, a render script, and a preview output directly in
the wrkstrm collective (`wrkstrm/private/schemas/investible-case/v0.1.0/`
and `wrkstrm/private/applications/2026-05-18-a16z-speedrun/`).

rismay flagged it: "we need to make sure that you are working in
wrkstrm-research so that all our explorations are in sync."

The migration that followed: created a new campus
`wrkstrm-research/.../application-evidence/` and moved schemas →
`gym/typed-claims/v0.1.0/`, render lens → `zoo/claims-renderer/`,
preview → `museum/`. Kept submission.md / claims-to-prove.md /
claims-catalog.json in `wrkstrm/private/applications/...` (operational
records).

## Adjacent rules

- `2026-05-18-memory-home-follows-synced-agent.md` — memory placement
  follows the synced agent. This file applies the parallel logic to
  code/data placement: research artifacts follow the substrate's
  research home, not the synced agent.
- `feedback_save-insights-docc.md` — write insights to memory/.docc/.
  This rule extends it: write *research code* to wrkstrm-research, not
  to the collective whose operational records you're working with.

## Open follow-ups

- The application archive in `wrkstrm/private/applications/` still
  contains claims-catalog.json which is application-instance typed
  data. There's a judgment call about whether per-application instance
  catalogs should move to `application-evidence/catalogs/` (as
  research-grade) or stay alongside the operational record (as
  per-submission). Current placement is alongside the operational
  record; revisit if cross-application analysis becomes common.
- The render lens is currently a single .mjs file. As more lenses are
  authored (founder-sublens, partner-sublens, terminal-sublens), they
  should live as sibling subdirectories under `zoo/`.
