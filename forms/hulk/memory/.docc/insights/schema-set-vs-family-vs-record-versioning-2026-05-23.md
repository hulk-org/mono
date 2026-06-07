---
name: schema-set-vs-family-vs-record-versioning-2026-05-23
description: "Substrate schema versioning has three distinct axes — set version, family version, record discriminator — and they're independent dials, not synonyms"
metadata:
  node_type: memory
  type: insight
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

The substrate's schema system has three independent versioning axes. Conflating them produces wrong upgrades.

**1. Set version** — a coordinated bundle pinned by name+version.
- Declared by a consumer in `schemaSetRefs[0].set` (e.g. `core-entity-set-v1.0.0`).
- Backed by a manifest at `collectives/schema-universal/private/universal/schemas-sets/<domain>/<version>/<set>-<version>.json`.
- The manifest enumerates member families and pins each member's version.
- Roster reads this declaration to compute the `0.6→1.0 !` marker for stale homes.

**2. Family version** — each member family in the set has its own version.
- A v1.0.0 set bundles many families, each at their own version (identity-schemas v0.5.0, agenda-schemas v0.4.0, chronicle-schemas v0.3.0, organism-schemas v0.7.0, ...).
- The consumer's file-level `schemaVersion` field is the FAMILY version of the file's primary type (e.g., identity.json's `schemaVersion: "0.5.0"` = identity-schemas v0.5.0).
- Decoders strict-validate this (`guard decodedSchemaVersion == Self.semanticVersion`). Skew throws.

**3. Record discriminator** — per-record (per-type) version field encoded by SemanticVersionable types.
- Coding key looks like `case modelSchemaVersion = "IdentityModel"`. Each record encodes its type name as a string field whose value is the family version.
- Decoder uses `validateModelLineVersion` which only checks IF present, so discriminator is optional on decode but always-present on encode.
- Nested types (PersonaRefs, SystemInstructionsRefs, SectionModel, IkigaiModel, ...) each emit their own discriminator.

**Why this matters** — bumping a set is NOT just a string change in `schemaSetRefs[0].set`. The manifest pins each family's version, so bumping the set forces every member-family version to match. The consumer's file-level `schemaVersion` must update; nested record discriminators (PersonaRefs, etc.) must update; and any field whose contract changed needs migration.

**Critical: set RENAMES happen.** `core-triad-set` → `core-entity-set` between v0.6.0 and v1.0.0 reflects a doctrine shift (3-doc triad → richer organism entity model). When upgrading, the path/name might change, not just the version. Read the new manifest's `domain` field to detect this.

**How to apply**:
- Before authoring upgrades, READ the target set's manifest in full to know all member family versions.
- READ each affected family's Swift source in `schema-families/<family>/v<version>/spm/.../sources/...` to know what `schemaVersion` constant the decoder expects and which discriminators get encoded.
- Use the typed SPM source as the canonical contract; never eyeball-clone a sibling agent's JSON ([[feedback_audit-not-eyeball-clone]]).
- After the edit, run `swift-agent-cli doctor --slug <slug> --kind <agent|agenda|chronicle>` on each kind in the bundle; only commit when status:ok and error-count:0 on every kind.

**Concrete example** (claude bump 2026-05-23):
- Set: `core-triad-set-v0.6.0` → `core-entity-set-v1.0.0` (rename + bump)
- identity-schemas: v0.3.0 → v0.5.0 (added required `agentRefs[]`/`digikomaRefs[]` execution edges)
- agenda-schemas: v0.1.0 → v0.4.0
- chronicle-schemas: v0.1.0 → v0.3.0
- IdentityModel discriminator added at root
- PersonaRefs/SystemInstructionsRefs discriminators added in nested blocks
- Doctor passes clean on all three kinds → safe to commit

Related: [[project_v05-retired-identity-fields]] (forward-retirement map for legacy fields in v0.5+; not enforced retroactively — v0.5 decoder still accepts `inherits`/`operationModes`/`systemInstructions`/`sections`/`checklists`/`notes`).
