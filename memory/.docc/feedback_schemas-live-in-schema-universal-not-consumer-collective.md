---
name: All schemas live in schema-universal, not in the consuming collective
description: canonical home for ALL substrate schema definitions is the schema-universal collective; consumer collectives reference via LinkRef and never host their own `schemas/` directory
type: feedback
originSessionId: 22a40768-80ea-4704-8439-570fe3664d99
---
All substrate schema definitions live in `private/universal/substrate/collectives/schema-universal/`. Consumer collectives (investors-app, clia-org, todo3, wrkstrm-doctrine, etc.) reference schemas via LinkRef into schema-universal and MUST NOT host their own `schemas/` directory.

**Why:** schema-universal is the canonical-data substrate doctrine in action — one source of truth, many consumers. Mirroring schemas inside each collective would:
- Re-create the same overload/drift problem the substrate's typed-everything discipline is supposed to solve
- Make cross-collective LinkRefs ambiguous (which copy of the schema is authoritative?)
- Force every consumer to vendor-update independently when the schema family evolves

**The two canonical layouts inside schema-universal:**

1. **Flat / substrate-primitive layout** — for cross-cutting primitives that aren't bucketed to a single domain (ideation, path, agenda, chronicle, worldline, character):
   ```
   schema-universal/private/universal/schema-families/<family>/v<version>/json/<name>.schema.json
   ```

2. **Domain-bucketed layout** — for schemas that belong to a named substrate domain (capital, identity, credentials, ai, etc.):
   ```
   schema-universal/private/universal/domain/<domain>/schema-families/<family>/
   ├── schema-catalog.family.descriptor.json
   └── v<version>/
       ├── json/<name>.schema.json                    (JSON-canonical schemas)
       └── spm/<family>-v000-001-000/                  (Swift-typed sources + tests)
   ```
   Existing capital-domain families: capital-legibility-schemas, speedrun-schemas, vc-funding-application-schemas.

**How to apply:**

- At the moment you reach for a `schemas/` directory inside a consumer collective, stop. The schema belongs in schema-universal.
- Decide layout: cross-cutting primitive → flat; named domain → bucketed.
- Author the `schema-catalog.family.descriptor.json` alongside the family directory.
- Place `*.schema.json` files under `v<version>/json/`, and Swift sources (when authored) under `v<version>/spm/<family>-v000-001-000/`.
- In the consumer collective, replace the local `schemas/` path with LinkRefs that target the schema-universal location:
  - `vt: "schema-universal"`
  - `vr: "private/universal/substrate/collectives/schema-universal"`
  - `sf: "<family-name>"`
  - `sv: "<version>"`
  - `sk: "<TypedKindName>"`
  - `st: "private/universal/domain/<domain>/schema-families/<family>/v<version>/json/<name>.schema.json"` (or the spm path for Swift)
- Keep consumer-collective data files (instances, claims, identities, applications, threads, beads) in the consumer collective — only schema *definitions* move to schema-universal.

**Heuristic for the boundary:** if a file ends in `.schema.json` or `.schema.<lang>` it lives in schema-universal. If it's an instance OF a schema (e.g. an identity.json, a vc-funding.application.json, a claim record) it lives in the consuming collective.
