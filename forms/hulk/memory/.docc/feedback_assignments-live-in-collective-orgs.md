---
name: Assignments live in collective org Kura
description: substrate doctrine — `<role>-<agent>` assignment homes live at `collectives/<org>/private/universal/kura/assignments/<slug>/`, INSIDE the org's Kura instance (not as a peer to it); the OLD pattern (`/private/universal/assignments/`) is itself legacy now
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
Substrate assignments belong inside their owning collective org's **Kura
instance**, at:

```
collectives/<org>/private/universal/kura/assignments/<role>-<agent-slug>/
```

The `kura/assignments/` segment is required. Assignments are now a Kura
shape tier alongside the original 5 (`vaults/`, `collections/`, `series/`,
`timelines/`, `threads/`) — making 6 canonical Kura shape tiers. The
prior assumption that the 5-tier list was closed was wrong; the operator
extended it 2026-05-26 with: "assignments should live in the new kura
directory: kura/assignments/*".

**Why:** an assignment is a typed binding of role × actor × scope. The
scope is the owning org. The org already carries its own Kura instance.
Putting the assignment inside that Kura tree makes the binding *part of
the org's knowledge graph* (typed, queryable, set-membered) rather than a
peer surface. It also composes naturally with [[insights/agents-have-forms-2026-05-25]]
and [[feedback_forms-outside-kura-own-kura-instance]] — forms also live
outside the parent's Kura for the same reason (forms are their own homes
with their own Kuras), while assignments live *inside* an org's Kura
because they ARE org-scoped knowledge, not their own homes.

**Doctrinal evolution (chronological):**
- 2026-05-22 (origin): "assignments belong in collective orgs" — out of the
  flat `substrate/assignments/` legacy dir, into `collectives/<org>/`.
- 2026-05-23 (depth lock): "...at `private/universal/assignments/`" — the
  deep substrate-internal segment is required, not the shallow path.
- **2026-05-26 (Kura promotion):** "...should live in the new kura directory:
  `kura/assignments/*`" — assignment is a Kura shape tier (6th).

Each step preserved the *fire* (assignments are org-scoped typed bindings)
and corrected the *ash* (specific path expression). Tradition preserves
fire, not ashes — see [[insights/tradition-preserves-fire-not-ashes-2026-05-25]].

**How to apply:**
- When commissioning a new assignment, place at
  `collectives/<org>/private/universal/kura/assignments/<role>-<agent-slug>/` from the start.
- When relocating an agent home into assignment shape (e.g. walter →
  biographer-carrie in wrkstrm), the destination is the org's Kura
  assignments tier, never the legacy peer-of-Kura `/assignments/`.
- The OLD pattern at `collectives/<org>/private/universal/assignments/`
  (without the `kura/` segment) is itself legacy now. Existing entries
  (~10 across wrkstrm/wrkstrm-finance/google/todo3) need a corrective
  sweep — same shape as the forms-outside-kura sweep landed 2026-05-26.
- The deeper top-level legacy at `private/universal/substrate/assignments/`
  (flat, no org) is doubly-wrong and must also migrate.

Cohort to migrate (as of 2026-05-26):
- wrkstrm: 5 entries (3 dirs, 2 `.org-assignment.json` records)
- wrkstrm-finance: 5 entries (1 dir, 4 records)
- google: 1 dir (design-system-steward-castor)
- todo3: 1 dir (maintenance-reliability-steward-catch)
- substrate-root flat: 1 dir (public-surface-steward-tau) + 5 records at `roles/assignments/`
