---
name: Schema families placeholder audit (2026-04-26)
description: Comprehensive audit of schema-universal — top-level schema-families/ is legacy; canonical home is domain/<area>/schema-families/; 36 placeholder.schema.json files all live in legacy
type: project
originSessionId: 8e2e8083-6e85-471f-958d-0599afb24d1b
---
## Comprehensive scope (corrected 2026-04-26)

Schema-universal layout — places schema content can live:

- `private/universal/schema-families/` — **LEGACY** flat list. All 36 placeholder
  files are here. SPM packages still bound by `core-triad-set v0.6.0` and
  `core-entity-set v0.9.0` Package.swift dependencies.
- `private/universal/domain/<area>/schema-families/<family>/` — **CURRENT**
  domain-organized layout. 43 families across `ai`, `apple`, `finance`,
  `identity`, `irc`, `learning`, `org`, `system`, `vault`. **Zero placeholders
  anywhere under `domain/`.**
- `private/universal/schema-migrators/` — actual migration packages, not
  schemas. No placeholders.
- `private/universal/schemas-sets/` — aggregator manifests + SPM bindings.
  Latest: `core-triads v0.6.0`, `core-entities v0.9.0`.
- `archive/`, `identity/`, `requests/`, `vaults/` — no schema content.

## What the web view exposed

Schema-lab's web view (compact / readable / uml hid this — they always drew
*some* shape ring even when the data was placeholder) honestly rendered each
empty family as `<family>.placeholder` types with `_placeholder/_family/_version`
properties. That's the literal FoundationSession scaffold output, and it's
still on disk for **36 versions across 19 families** in the legacy tree.

## Trigger

Commit `34078be` on 2026-04-03 ("refactor: split agenda support schemas into
dedicated packages") and `cb999f0` / `d68f4ec` on 2026-04-02 (the original
import + scaffold burst) created most of these dirs. The migration scaffolded
JSON placeholders + Swift sources, then the JSON layer was never authored.

## Current SPM bindings — load-bearing legacy families (need real schemas)

Bound by `core-triads v0.6.0` and/or `core-entities v0.9.0` Package.swift:

- `agenda-support-schemas` v0.5.0
- `chronicle-support-schemas` v0.1.0
- `entity-primitives-schemas` v0.1.0
- `expected-contributions-schemas` v0.1.0
- `horizon-schemas` v0.3.0
- `schema-set-schemas` v0.1.0
- `thread-link-schemas` v0.1.0
- `triad-primitives-schemas` v0.1.0 + v0.6.0

These eight family/version combos are **active in the build but JSON-empty**.
They need real schemas authored at the legacy paths or a migration to `domain/`
plus manifest update.

## Trash candidates — no current binding + has likely domain replacement

| Legacy family | Probable domain replacement |
|---|---|
| `backlog-item-schemas` | `system/paperclip-issue-schemas` (issue-tracker semantics) |
| `agent-interface-schemas` | `identity/actor-ref-schemas` + `identity-ref-model-schemas` |
| `ai-interchange-schemas` | `ai/agent-dialogue-schemas` / `ai/conversation-schemas` |
| `operating-rhythm-schemas` | `system/operating-protocol-schemas` |
| `schema-definition-schemas` | `system/schema-catalog-domain-descriptor-schemas` |
| `schema-family-schemas` | `system/schema-catalog-family-descriptor-schemas` |

Six families. Last referenced in pre-v0.7.0 manifests; never appeared in
v0.6.0 core-triads / v0.9.0 core-entities.

## Trash candidates — no current binding + no clear domain replacement

Probably orphan scaffolding from the 2026-04-02 burst, never refilled and
never replaced. Last touched only by the 2026-04-08 / 2026-04-13 sweep
commits (localOrRemote wrappers, burn-down chores) — no real authoring:

- `brand-identity-schemas`
- `location-storage-schemas`
- `milestone-schemas` (dropped after v0.7.0; no clear replacement)
- `schema-migrator-schemas`
- `scope-detail-schemas`

Five families. The operator should confirm none of these are intentional
roadmap holds before trashing.

## Older versions of active families — version-level trash candidates

These families have a *bound* version (kept) plus older unbound versions
that are pure dead JSON scaffolding:

- `agenda-support-schemas` — v0.1.0, v0.2.0, v0.3.0, v0.4.0 (only v0.5.0 bound)
- `horizon-schemas` — v0.1.0, v0.2.0 (only v0.3.0 bound)
- `triad-primitives-schemas` — v0.2.0, v0.3.0 (only v0.1.0 + v0.6.0 bound)

Seven unbound version directories. Trashing them shrinks the legacy footprint
without breaking any current SPM build.

## Reconciliation paths (no deletion — history stays)

Operator correction 2026-04-26: legacy version dirs ARE the historical
record. Even placeholder-only versions document "this version was scaffolded
but never authored before being superseded." They are not trash, they are
lineage. Apply `feedback_no-rewrite-history` and `feedback_reshape-preserves-data`.

1. **Author schemas at legacy paths** for the 8 load-bearing families that
   current SPM manifests still bind. Replaces placeholder JSON in place;
   manifests stay where they are.
2. **Annotate, don't delete**: drop a `deprecated.json` / `replaced-by.json`
   marker per legacy family that has a domain counterpart, so future
   readers see the lineage (`backlog-item-schemas → system/paperclip-issue-schemas`).
3. **Surface in schema-lab**: filter or dim placeholder-only versions in
   the web view. The audit signal stays useful inside the app while the
   historical files stay intact on disk.

Never trash legacy version directories, even when a family has been
replaced. Older versions are historical truth; treat them like git tags,
not scratch space.

## Counts (corrected)

- 36 `*.placeholder.schema.json` files (all in legacy)
- 19 distinct families with placeholder content (all in legacy)
- 8 families load-bearing in current manifests (need authoring)
- 11 families with no current binding (trash candidates: 6 likely-replaced + 5 unmatched)
- 7 unbound older version directories (clean-trash candidates)

Per substrate doctrine: never `rm -rf`. Use Trash. Walk schema-set manifests
+ identity refs once more before any deletion. Do not skip the auto-commit
hook check.
