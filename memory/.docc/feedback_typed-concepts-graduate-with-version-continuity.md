---
name: typed-concepts-graduate-with-version-continuity
description: "Substrate doctrine: typed family-sets RENAME at version boundaries when substrate's understanding sharpens about what is being typed. Version line stays continuous (no v0.1.0 restart); the NAME catches up to what substrate actually types. Historical versions stay at the old name as preserved record. Substrate's typed vocabulary GRADUATES with substrate's understanding."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Typed family-sets graduate with substrate-understanding.** Operator-stated 2026-05-31 (CLIA session, core-entities → core-identity rename at v1.0.0):

> *"now that we discovered entities... we know they have IDENTITIES... we have to switch the core set name for 1.0.0 to core-identity!"*

> *"i went from triads to entities... a LONG time ago."*

> *"we need to move 1.0.0 to core-identity - singular - now that we know that a singular identity can have many schema."*

## The doctrine in one line

**When a family-set's substrate-understood object-of-typing sharpens, the family-set RENAMES at the next version boundary. The version line stays continuous (no v0.1.0 restart); the NAME catches up to what the substrate ACTUALLY types. Historical versions stay at the old name as preserved record of substrate's prior understanding.**

## Substrate's name-graduation precedent

The substrate has now done this TWICE in the same family-set lineage:

| Versions | Family-set name | What it typed | Why graduated |
|---|---|---|---|
| **v0.1.0 – v0.6.0** | `core-triads/` | Agent + Agenda + Agency triad-as-the-unit | The original substrate-frame: typed as TRIADS of three things |
| **v0.7.0 – v0.9.0** | `core-entities/` | The broader "entity" frame: triadic structure + other shapes | The triad-frame became too narrow — substrate added audiences, collectives, characters, ghosts, digikomas, etc. that weren't triadic. The "entity" word generalized. |
| **v1.0.0** | `core-identity/` (SINGULAR) | One logical IDENTITY composed of many typed-aspect schemas | "Entities have identities" — what substrate actually TYPES is one entity's identity-composition. The set holds typed RECORDS describing one identity (singular), not multiple entities. Plural was misframing. |

Each graduation is **more precise about what the family-set actually types**. Substrate's vocabulary gets more precise over time as substrate types more and the relationships between typed concepts become clearer.

## Two distinct moves that compose

| Move | Examples |
|---|---|
| **Naming graduation** (rename at version boundary) | triads → entities at v0.7.0; entities → identity at v1.0.0 |
| **Content refresh** (bump family pins within a version) | v0.7.0 → v0.8.0 → v0.9.0 stayed entities-named, refreshed family pins |
| **Both at the same boundary** (full graduation) | v1.0.0 renamed entities→identity AND refreshed family pins (identity-schemas v0.7.0 → v0.8.0, added addressing-protocol + personality-archetype, bumped organism + operating-protocol + org-role + s-type-standards + contribution-composition) |

The substrate-correct move: when BOTH the name and content need to evolve, do them in one coherent release-version landing.

## Why version continuity matters

The substrate could have started a fresh family-set at v1.0.0 (e.g., `core-identity` at v0.1.0). It DIDN'T. Reasons:

1. **The set is the same conceptual line** — same composition lineage, same audit trail, just sharper framing
2. **Version-line continuity preserves substrate-understanding** — readers see "this is the SAME line, just maturing" rather than "two unrelated sets"
3. **Migration story stays coherent** — substrate has `schema-migrators/core-entity-migrations/v0.9.0-to-v1.0.0/` that documents the upgrade path; new-name + new-version-line would lose that
4. **Substrate doctrine: discontinuities are load-bearing** — version graduations preserve continuity through name changes (per `[[feedback_breaks-are-good-no-transition-shims]]`'s "the break IS the typed work" pattern adapted to the SET layer)

## Preservation of historical versions

Older versions stay at the OLD name:
- `core-triads/v0.1.0` – `v0.6.0` still exist at `core-triads/` directory
- `core-entities/v0.7.0` – `v0.9.0` still exist at `core-entities/` directory  
- v1.0.0+ lives at `core-identity/` directory

This is substrate-doctrine: **historical typed-data stays at the path where it was authored.** Renaming the current version doesn't backdate the historical versions. Consumers loading historical cuts use the OLD paths/filenames; consumers loading current cuts use the NEW. Test loaders that need both must encode this rename in their path-resolution logic (e.g., `if version.hasPrefix("1.") { use newName } else { use oldName }`).

## How to apply

1. **Before naming a NEW family-set**, ask: "What does this set ACTUALLY type? Is there an existing line I'm continuing under a sharper name?" If yes, graduate the existing line rather than starting a new one.

2. **When renaming**, do it AT a version boundary (not in-place mid-version). The version increment carries the rename + content refresh together.

3. **Version line continues**: v0.6.0 ends in old name, v0.7.0 begins in new name. No version reset.

4. **Old versions stay at old paths**: don't backdate the rename to historical cuts.

5. **Test code that loads multiple versions** needs version-aware path resolution. Hardcode the rename boundary in the load function: `let isCurrentName = version.hasPrefix("1.")`.

6. **Doc references update**: incident docs, spec docs, doctrine memories that reference the current set should update to the new name. Historical-doc references to the prior names stay (they describe the prior state).

7. **External dependents break**: per `[[feedback_breaks-are-good-no-transition-shims]]`, downstream consumers of the SPM package's product name (`CoreEntity_Set_v001_000_000` → `CoreIdentity_Set_v001_000_000`) will break and need updating. The break is the substrate-correct mechanism for surfacing consumers that need to migrate.

## Anti-pattern to catch in self

When a typed family-set's name no longer matches what it types, watch for:

- "The set name says X but it actually types Y" — that's the graduation signal
- "We've been adding members that don't fit the name" — name was too narrow; needs broadening
- "We've been excluding members that DO fit the name" — name was too broad; needs sharpening
- "The plural-form name suggests N things but the set holds 1 thing composed of N aspects" — the substrate's just-surfaced singular-vs-plural distinction (one identity, many composing schemas)

When operator surfaces a "we need to rename this" intuition, the substrate move is: identify the graduation (what UNDERSTANDING has sharpened?), pick the next version boundary, do the rename + content refresh together, preserve historical at old paths.

## Concrete first-canonical-instance log

The v1.0.0 graduation landed 2026-05-31 with:

- **Rename**: `private/universal/schemas-sets/core-entities/v1.0.0/` → `private/universal/schemas-sets/core-identity/v1.0.0/` (git mv preserving history)
- **SPM module rename**: `CoreEntity_Set_v001_000_000` → `CoreIdentity_Set_v001_000_000`
- **Inner directory rename**: `core-entity-set-v001-000-000/` → `core-identity-set-v001-000-000/`
- **Manifest filename rename**: `core-entity-set-v1.0.0.json` → `core-identity-set-v1.0.0.json`
- **Source filename rename**: `core-entity-set-exports.swift` → `core-identity-set-exports.swift`
- **Slug rename**: `core-entity-set-v1.0.0` → `core-identity-set-v1.0.0`
- **Content refresh**: identity-schemas v0.7.0→v0.8.0 + organism-schemas v0.7.0→v0.8.0 + operating-protocol v0.1.0→v0.2.0 + org-role v0.4.0→v0.5.0 + s-type-standards v0.3.0→v0.4.0 + contribution-composition v0.1.0→v0.2.0
- **New families added**: identity-addressing-protocol-schemas v0.1.0 + personality-archetype-schemas v0.1.0
- **Test path resolution updated**: `HistoricalCoreEntityCut.load(version)` now version-aware (1.x → core-identity/core-identity-set-vX.json; 0.x → core-entities/core-entity-set-vX.json)
- **External dependents** (clia-org CLIs, schema-migrators) NOT updated this session per stop-at-schema-universal-edge scoping; they will surface as compiler errors and get walked in a focused follow-up
- **53 tests** in the v1.0.0 set package pass green

## Related

- [[feedback_enums-vs-models-substantive-knowledge]] — same doctrine of substrate-vocabulary sharpening, applied at the typed-concept level (use models not enums for substantive knowledge)
- [[feedback_inherent-vs-relational-typing-split]] — same doctrine of substrate-vocabulary sharpening, applied at the typed-axis level (inherent + relational as separate orthogonal axes)
- [[feedback_typed-axioms-as-typed-tribal-knowledge]] — meta-doctrine: substrate types implicit patterns as explicit data. Name graduation is the substrate-vocabulary version of this — sharpening the name typed-records use as substrate understands more
- [[feedback_breaks-are-good-no-transition-shims]] — the rename causes downstream breaks; walking those breaks is the substrate-correct mechanism. No typealiases or shim layers
- [[feedback_role-classes-as-files-not-catalog]] — substrate's "type what's USED" pattern; the rename is substrate typing what the set ACTUALLY types vs what its name USED to suggest
