---
name: ordinality-table-entries-immutable-once-released
description: "Substrate doctrine refined 2026-05-26: the freeze invariant on ordinality table entries is a GRADIENT, not binary. Freezing engages at FIRST EXTERNAL PERSISTENCE — not first commit. Substrate-internal renumbering remains safe AS LONG AS substrate maintains a typed migration mapping layer that translates old-ordinal → new-ordinal on read. Once data leaves substrate (downstream consumer persists a value substrate doesn't control), the freeze becomes absolute. Same wire-format-freeze rule as protobuf field numbers — but with substrate's corpus-mapping pattern, substrate buys itself a wider design window than a strict per-commit freeze would allow."
metadata:
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-stated 2026-05-26 (initial): "remember that when you add a new model family, to a table... if we release it. IT MAY NEVER CHANGE."

Operator-refined 2026-05-26 (later): "as long as we have mappings, we can keep unfrozen until we SHIP that to the outside world."

The refinement matters. The freeze isn't a single binary moment — it's a gradient with three distinct states substrate moves through.

## The freeze gradient (three states)

| state | who depends on the ordinals | can substrate renumber? | discipline required |
|---|---|---|---|
| **substrate-internal pre-shipped** | nobody persists; in-memory only | ✓ freely | none |
| **substrate-internal with mapping layer** | substrate corpus persists, but substrate owns the migrator | ✓ with discipline | write the typed migration mapping; run corpus-migrator |
| **externally shipped** | downstream code substrate doesn't control persists | ✗ frozen absolute | accept the constraint |

## The mapping layer (the substrate-internal-renumber pattern)

When substrate wants to renumber AFTER data has been persisted in substrate's own corpus (state 2), it does NOT just edit the table. The procedure:

1. **Author the renumber** in the ordinality table file (update the entries to their new ordinals).
2. **Add a typed `Migration` entry** in the mapping layer module (e.g., `AIModelFamilyOrdinalityMappings.migrations`) recording `from: oldOrdinal → to: newOrdinal` plus `sinceVersion`.
3. **Codable read-path applies the migration** automatically: when decoding a persisted ordinal, run it through `AIModelFamilyOrdinalityMappings.migrate(ordinal:)` before resolving against the table.
4. **Run the JSON CRISPR corpus migrator** (per `[[json-crispr-corpus-migrator-pattern]]`) to physically update any persisted ordinals if substrate prefers stable-on-disk over migration-at-read.

The migration map is APPEND-ONLY. Each renumber adds an entry; entries never get removed (otherwise pre-migration data stops resolving).

## When the freeze engages (the "external shipping" question)

Substrate must treat the table as frozen once ANY of these conditions hold:

- A public-API consumer (open-source library, npm package, public schema) starts persisting ordinals.
- A non-substrate-controlled JSON store (third-party app, partner integration, external customer's data) contains ordinals substrate cannot migrate.
- A wire-protocol freeze commitment has been made (e.g., shipped a v1.0.0 typed contract that documents the ordinal mapping as stable).

For substrate-INTERNAL consumption (substrate's own Codable types, substrate's own corpus, substrate's own harnesses running substrate-owned code), the mapping layer keeps the table malleable.

## What CAN change per state

**Pre-shipped (state 1)**:
- ordinal positions
- slugs
- enum case mappings
- bit positions in adjacent OptionSet fields
- removal of entries
- reordering of entries

Everything is malleable.

**Substrate-internal with mapping layer (state 2)**:
- ordinal positions — renumber with Migration entry
- slugs — slug-rename requires a slug-migration entry (lookup-by-slug becomes lookup-with-rename-map)
- enum case mappings — same pattern
- per-row values (cost shape changes, durability class changes, deployment-status mutations) — always mutable
- deprecation markers added — always
- removal of entries — only after `deprecatedSinceVersion` cycle completes

Most mutations require corresponding migration entries.

**Externally shipped (state 3)**:
- per-row values mutate freely (Anthropic exposes fine-tuning → flip the bit; substrate ships H2 2026 → flip the roadmap-status)
- `displayName`, `description` mutate freely (presentation)
- `deprecatedSinceVersion` added when retiring (entry stays in values[])
- new entries APPEND only (next-ordinal-after-highest-existing)

Nothing else changes.

## Why bother with the mapping layer

Without it, every commit-level "release" would freeze the surface. Substrate iterates rapidly during design — a strict-per-commit freeze would close design space before the design is mature. The mapping layer buys substrate the window it needs to converge.

Trade-off: substrate accepts the discipline cost of maintaining the migration table forever (memory cost is trivial; ergonomic cost is non-zero — every renumber requires the matching Migration entry).

## Pitfalls

1. **"It's substrate-internal, just renumber"**: doesn't escape the discipline. Substrate-internal corpus persists ordinals; renumbering without a Migration entry corrupts substrate's own corpus. The mapping layer is what makes "substrate-internal-mutable" safe — not the absence of external consumers.
2. **"We'll add the Migration later"**: when later? The substrate's own automation reads the corpus immediately; the migration must exist BEFORE the renumber commit lands (or paired with it in the same commit).
3. **"Mapping table will get huge over time"**: only if substrate renumbers frequently. Append-only growth in proportion to renumber events. Even substantial reorganizations produce ~10s of entries total. Memory cost is trivial.
4. **"External consumers don't matter, we control everything"**: until substrate publishes its first public schema, ships its first SDK to a customer, or open-sources a package downstream code consumes. Then they matter retroactively. Better discipline now than retrofit later.

## How to apply

**For the AI model family table (current state, May 2026)**:
- Substrate-internal, no external consumer yet → state 1 (pre-shipped)
- Renumbering currently safe with NO mapping required
- Will move to state 2 when IdentityModel v0.7.0 ships with `acceptedModelFamilies: [Int]` (substrate-internal corpus starts persisting ordinals)
- Will move to state 3 when substrate ships its first public-facing schema referencing these ordinals

**Whenever authoring or modifying any substrate ordinality table**:
- Identify the table's current freeze state (1 / 2 / 3)
- For state 1: iterate freely
- For state 2: pair every renumber commit with a Migration entry; run the corpus migrator
- For state 3: never renumber — append, deprecate, document

## Related memories

- [[json-ordinality-tables-not-enums]] — parent doctrine establishing ordinality tables as substrate's typed-catalog primitive
- [[json-crispr-corpus-migrator-pattern]] — the corpus-migration tooling the mapping-layer leverages
- [[three-valued-logic-open-catalogs]] — validation discipline; consumers must tolerate unknown ordinals (forward-compat with newer tables)
- [[class-name-equals-json-key-discriminator]] — version-discrimination pattern; same find-all-consumers-before-changing rule
- [[every-property-fights-for-its-life]] — when an embedded property graduates to a typed family, the ordinality table that types it inherits this freeze discipline
- [[model-families-as-dna-2026-05-26]] — current canonical user of this doctrine
- Protobuf field-number freeze (cross-discipline analog)
- gRPC field reservation pattern (`reserved` keyword)
