---
name: Assignments live in collective orgs
description: substrate doctrine — `<role>-<agent>` assignment homes live at `collectives/<org>/assignments/`, NOT the flat top-level `private/universal/substrate/assignments/` dir; that flat surface is mis-shaped legacy
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
Substrate assignments belong inside their owning collective org, at
`private/universal/substrate/collectives/<org>/private/universal/assignments/<role>-<agent-slug>/`.
The deeper `private/universal/` segment is required — it is the standard
substrate-internal layout (mirrors `private/universal/identity/`,
`private/universal/vaults/`, etc.). Without it the assignment ends up in
the collective's "public" surface area, which is wrong.

They do NOT belong at the top-level flat `private/universal/substrate/assignments/`
directory — that surface (currently holding `documentation-tooling-steward-carrie`,
`maintenance-reliability-steward-catch`, `public-surface-steward-tau`) is
mis-shaped legacy and should migrate into its owning collectives over time.

**Why:** assignments express a contract between an agent and a *collective scope*
(Google design-system, Apple public-surface, etc.). Putting them under the
collective makes that scope structural, not just lexical-in-slug. It also keeps
the collective's full operating surface (code + assignments + maintainer
profile) co-located, so descending into a collective gives the whole picture.
Operator's exact words 2026-05-22: "the assignments are supposed to be in the
collective orgs."

**How to apply:**
- When commissioning a new assignment, place the home at
  `collectives/<org>/private/universal/assignments/<role>-<agent-slug>/` from the start. Do not skip the `private/universal/` segment.
- When relocating an agent home into assignment shape (e.g. pollux → castor's
  Google assignment), the destination is `collectives/<org>/private/universal/assignments/`, never the flat dir.
- Do NOT propose the flat `assignments/` shape as an option, even when there's
  on-disk precedent for it — the precedent is the thing being phased out.
- If a task touches one of the three legacy top-level assignments, flag the
  migration opportunity but don't relocate without operator sign-off.
- The roster CLI currently shows these under "related profiles" (`--include-related`);
  after migration they'll surface under their owning collective.
