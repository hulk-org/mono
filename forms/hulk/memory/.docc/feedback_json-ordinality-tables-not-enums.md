---
name: JSON enums are bad — use ordinality tables instead
description: Substrate-wide JSON schema doctrine. JSON Schema's `enum` keyword is supported but bad for extensibility surfaces — closed value lists, no typed metadata, breaking-change-on-evolution. Substrate's pattern is ORDINALITY TABLES: integer ordinal field in the consumer model + separate typed ordinality-table schema with one record per ordinal carrying name + description + metadata + version provenance. Companion principle to feedback_swiftui-protocol-pattern-over-enums.md (which covers the Swift side); this covers the JSON side.
type: feedback
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
# JSON enums are bad — use ordinality tables instead

**Root principle (rismay, 2026-05-17):** JSON is the substrate's UNIVERSAL SERIALIZATION FORMAT. The substrate's typing primitives must work WITHIN JSON's expressive constraints, not smuggle in language-specific conveniences (Swift enums, Protobuf oneOf, GraphQL union types) as the wire format. Swift conveniences (Codable, SwiftUI Forms, generic constraints) sit ON TOP of the JSON layer; they cannot BE the typing layer.

The JSON-native typing primitives the substrate uses across all schemas:
- **Ordinality tables** (typed records keyed by integer ordinal) instead of `enum: [...]`
- **LinkRefs** (`{ k, v, vt, vr, sf, sv, sk }`) instead of language-typed references
- **Required + minItems non-empty** for structural constraints instead of post-hoc validation
- **Supersession chains via `sp` field** for evolution instead of versioning hacks
- **Integer / string / boolean / null primitives + objects + arrays + `$ref`** — that's the whole expressive surface; substrate works WITHIN it

This sibling rule (ordinality tables, not JSON enums) follows directly from the root principle.

## When to use ordinality table vs LinkRef (rismay 2026-05-17)

The substrate has TWO JSON-native typed-catalog patterns, and the choice between them depends on the catalog's evolution profile:

| Pattern | Use when catalog is | Substrate examples |
|---|---|---|
| **Ordinality table** (integer ordinal field in consumer; separate ordinality-table schema with one typed record per ordinal) | **CLOSED + CONDENSABLE + small + stable + well-known**. Adding values is rare. The whole set fits in a small integer space. | ideationKind (`k` field: 1=exploration, 2=brainstorm, 3=concept, 4=hypothesis, 5=alternative); status ordinals; LLevel ladder (L3-L9); lifecycle phases |
| **LinkRef** (`{ k, v, vt, vr, sf, sv, sk }` reference in consumer pointing at a typed record in a vault) | **OPEN + EXTENSIBLE + each value is itself a typed record** that needs to grow independently. Values are added often. Each value carries rich metadata that doesn't fit in an ordinal table. | Spark refs (`sR`); explorationRef (`eR`); conceptRefs (`cR`); hypothesisRefs (`hR`); evidence refs (`ev`); and — for the substrate's open-extensible role catalog — Role refs |

**The choice is empirical:** if the catalog WILL grow + each value WILL want to carry rich metadata, choose LinkRef. If the catalog is small + closed + condensation into an integer is genuinely fine, choose ordinality table. Ordinality tables are GOOD when condensing; LinkRef is GOOD when each value is itself a record.

Rismay's framing: "ordinality tables are good when condensing, but i think link ref has the right model for cases."

## Application to substrate's Google-character-quantization typing

Revised proposal (correcting earlier draft):

- **LLevel** (L3-L9, well-defined ladder, rarely changes) → ordinality table, integer ordinal 3-9 in consumer `lLevelOrdinal` field; separate `l-level-ordinality-table.schema.json` with typed records.
- **Role** (open + extensible; Google catalog plus substrate-quantization additions plus future domain-specific roles) → **LinkRef** from consumer `roleRef` field pointing at typed Role records in a role-catalog vault. Each Role record carries description, googleRoleReference, substrateQuantizationNotes, expectedScope, examples, etc.

NOT both ordinality-table — the open case wants LinkRef.

**Rule:** When designing a substrate JSON Schema with a typed value catalog (roles, ladders, kinds, statuses, lifecycle phases, etc.), use an ORDINALITY TABLE for the closed-condensable case OR a LINKREF for the open-extensible case. Never use a JSON Schema `enum`.

**Why:** Closed JSON enums have multiple structural failures:

1. **No typed metadata.** A JSON enum is just a literal value list. Each enum value cannot carry description, since-version, deprecated-at, examples, substrate-quantization-of, or any other typed metadata. Ordinality tables make each value a typed record.
2. **Breaking on evolution.** Adding a new enum value can break strict consumers; removing always does. Ordinality tables grow by appending new records, leaving existing ordinals untouched.
3. **Not extensible by consumers.** Consumers can't add their own values without forking the schema. Ordinality tables can be extended via supersession chains or via consumer-local ordinality-table-extension records.
4. **No payload.** Enum values can't reference other schemas (LinkRefs, foreign keys, etc.). Ordinality-table records can carry full LinkRef arrays to related records.

This is the JSON-side companion to `feedback_swiftui-protocol-pattern-over-enums.md`. Same principle, applied to JSON:

- Swift side: protocol pattern (View / ViewModifier / EnvironmentKey)
- JSON side: ordinality table (typed records keyed by ordinal, referenced from consumer model via integer field)

## Substrate's canonical ordinality-table examples

The substrate's `ideation-schemas/v0.1.0/json/` family already implements this pattern:

- `ideation-kind-ordinality-table.schema.json` — typed records for ideationKind (1=exploration, 2=brainstorm, 3=concept, 4=hypothesis, 5=alternative)
- `ideation-status-ordinality-tables.schema.json` — typed records for status ordinals per ideationKind

Consumer models (ConceptModel, HypothesisModel, ExplorationModel) reference these tables via integer `k` and `st` fields rather than via JSON enums.

## How to apply

When designing a substrate schema with a typed value catalog:

1. Author the consumer model's value field as `integer` (or `linkRef` for richer cases), NOT as `enum: [...]` of strings.
2. Author a separate `<value-domain>-ordinality-table.schema.json` with one typed record per valid value: required fields like `ordinal: integer`, `slug: string`, `name: string`, `description: string`; optional fields like `sinceVersion`, `deprecatedAtVersion`, `supersedes`, plus domain-specific metadata.
3. Reference the ordinality table from the consumer model's documentation, but DO NOT inline-validate the integer against the table at the JSON Schema level — let the substrate's schema-lab tooling validate that the integer matches a known ordinal at typecheck time, rather than baking validation into the JSON Schema (which would re-introduce the breaking-change problem).
4. Provide the typed catalog as the source of truth; substrate code reads the ordinality table at startup to populate runtime enum-equivalents in Swift.

## Concrete application: Role + LLevel typing for substrate's Google-character-quantization

The 2026-05-17 wrkstrm-doctrine Concept `substrate-quantizes-googles-hilbert-space-of-organizational-concepts` named the catalog (SWE / SRE / TL / EM / TPM / Fellow / Approver / Code Reviewer / Build Cop / On-Call; L3-L9 ladder). The right substrate-doctrinal way to TYPE this catalog is:

- `agent-schemas/v0.X.0/json/role-ordinality-table.schema.json` — typed records, each with `ordinal`, `slug`, `name`, `googleRoleReference`, `substrateQuantizationNotes`, `expectedScope`
- `agent-schemas/v0.X.0/json/l-level-ordinality-table.schema.json` — typed records, each with `ordinal` (3 through 9), `slug` ("L3", "L4", ...), `ladderSemantics`, `substrateQuantizationNotes`
- The existing `agent.schema.json`'s `role: string | null` and `lLevel: string | null` slots either stay as documented references to the ordinality tables (loose typing) or migrate to `roleOrdinal: integer | null` + `lLevelOrdinal: integer | null` (strict typing matching ideation-schemas pattern).

NOT `role: { enum: ["swe", "sre", "tl", ...] }` — that's the JSON enum trap.

## Lesson for future sessions

When proposing a typed catalog in a substrate schema, default-design as an ordinality table. The word "enum" is a red flag for substrate-pattern drift. Use "ordinality table" + "ordinal field" + "typed record per ordinal" as the substrate vocabulary. Cross-link the table from the consumer model's documentation, not from its JSON Schema validation.
