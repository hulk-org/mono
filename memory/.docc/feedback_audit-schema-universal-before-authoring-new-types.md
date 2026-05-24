---
name: Audit schema-universal for existing typed contracts before authoring new ones
description: before authoring any new schema, grep schema-universal for existing typed models that may already cover the contract; capital-domain families are SPM-Swift-first not JSON-Schema-first
type: feedback
originSessionId: 22a40768-80ea-4704-8439-570fe3664d99
---
Before authoring ANY new schema, audit schema-universal for existing typed contracts. The substrate consistently ships typed Swift models for new domains BEFORE the first consumer needs them, and rediscovering those by mistake creates parallel implementations that drift.

**Two specific patterns to check:**

1. **Existing typed model named after the first concrete instance, designed to generalize.** Example: `SpeedrunApplicationRecordModel` was named after Speedrun (the first program instance) but the shape (`programRef`, `applicantRef`, `subjectRefs`, `submittedAt`, `statusPageRef`, `submissionReceipts`, `evidenceRefs`) is generic to any VC funding application. The right move when adding a peer program (YC, On Deck) is to RENAME the model upward (`SpeedrunApplicationRecordModel` → `VCFundingApplicationRecordModel`) in a new family, then make speedrun-schemas depend on it. NOT to author a parallel `*Application*Model` from scratch.

2. **Domain-specific families are SPM-Swift-first, NOT JSON-Schema-first.** Inside `schema-universal/private/universal/domain/<X>/schema-families/<Y>/`, the canonical layout is:
   ```
   v0.1.0/spm/<family>-v000-001-000/
   ├── Package.swift                    (module name <Family>_Schemas_v000_001_000)
   ├── sources/<family>-v000-001-000/
   │   ├── <Model>Model.swift            (struct: Codable, Sendable, Hashable + diagnostics)
   │   ├── Known<X><Family>.swift        (typed instance catalog)
   │   ├── Known<X>LinkRefs.swift        (typed LinkRef constructors)
   │   └── <Family>Registry.swift        (id-keyed lookup table)
   └── tests/<family>-v000-001-000-tests/
       └── <Family>SchemaTests.swift
   ```
   Models embed validation as `var diagnostics: [Diagnostic]`, use compact CodingKeys (`"pr"`, `"ar"`), and reference cross-substrate records via `LinkRefModel` with `.vaultRecord(VaultTarget)` discriminated cases. Refinement primitives come from `CommonNonEmpty` in swift-universal.

**The flat `schema-families/<X>/v.../json/` layout exists ONLY for cross-cutting substrate primitives** (ideation, agenda, chronicle, worldline, character, path, specification, schema-family-schemas, schema-catalog-domain-descriptor-schemas, etc.) — NOT for domain-bucketed contracts.

**Why this matters:**
- Parallel implementations drift in CodingKeys, validation rules, and field semantics
- JSON-Schema-first loses the `diagnostics` validation methods that the Swift models embed
- LinkRef construction relies on typed `VaultTarget` builders — not raw `tg`-array JSON shapes
- The substrate's typed-everything doctrine is enforced through Swift compilation; bypassing into JSON Schema bypasses the enforcement

**How to apply — before authoring any new schema family or type:**

1. `find private/universal/substrate/collectives/schema-universal -name '*.swift' | xargs grep -l '<noun-of-domain>'` to find existing models
2. If a model exists that fits the shape with a generalized rename, refactor upward (rename + move to a more general family, make existing family depend on it)
3. If no model fits, author Swift-typed SPM package in the right family (domain-bucketed for domain-specific contracts; flat layout for cross-cutting primitives)
4. Author `*.schema.json` files ONLY when the family is in the flat `schema-families/` layout (cross-cutting primitives) — never inside `domain/<X>/schema-families/`
5. Match the canonical 4-field family descriptor (`displayName`, `firstSeenAt`, `lastModifiedAt`, `schemaVersion`); no extra fields

**The compounding lesson** (combines with `feedback_schemas-live-in-schema-universal-not-consumer-collective` + `feedback_filename-compound-suffix-disambiguates-overloaded-types`): the substrate has chosen Swift-typed canonical models with embedded diagnostics over JSON-Schema-first. New JSON Schema files belong only where the substrate ALREADY has them — in the flat cross-cutting layout. Domain-bucketed families are SPM-Swift, full stop.
