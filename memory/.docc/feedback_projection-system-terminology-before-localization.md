---
name: projection-system-terminology-before-localization
description: "Substrate's schema-projection answer to the diffusion-LLM grounding problem. Three composable projection layers stack ON TOP of versioned source schemas — schema-version → terminology → localization. Terminology comes before localization because it selects the conceptual frame; localization translates within it. Move forward, not backwards — additive projection layer, never retroactive renaming."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

## Problem the projection system answers

Substrate doctrine `class-name = JSON-key discriminator` puts versioned type names on every wire shape (`"NoteModel": "0.4.0"`, Swift module `Note_Schemas_v000_004_000`). This is *correct* for round-trip integrity: it makes wrong-version data hit wrong-version decoders loudly, and lets multiple versions coexist as separate Swift modules during migrations.

But it is **toxic for diffusion-LLM grounding**: structured outputs / constrained decoding / @Generable / tool-input schemas all need ONE canonical name per concept. An LLM grounded on a versioned schema can't reliably emit `Note_Schemas_v000_004_000_NoteModel` instead of `NoteModel_v0_4_0` instead of `Note`. The version-encoded names that protect substrate decoders break the exact use cases (generative UI, structured outputs, codegen) where schemas need to be stable handles.

## The wrong fix

**Retroactive rename of all schemas to unversioned types.** Fails on three fronts:

1. **Discriminator's purpose vanishes** — version mismatch becomes silent drift instead of loud error.
2. **CRISPR round-trip equality breaks** — every substrate migrator uses Codable round-trip as the correctness witness; unversioned types defeat that.
3. **Swift module coexistence breaks** — `Note_Schemas_v000_003_000` and `Note_Schemas_v000_004_000` need to co-import during migrations.

## The right fix — projection layer

Add a projection system **alongside** the versioned source. Source stays versioned + discriminated; projections render unversioned views. Translator layer bridges them at LLM I/O boundaries.

Operator 2026-05-26: "i think we have to move forward right? not backwards." Forward means additive projection layer, never retroactive renaming.

## Three composable projection layers

```
SOURCE                         versioned Swift module + JSON schema
                               Note_Schemas_v000_004_000.NoteModel
                                       ↓
LAYER 1: SCHEMA-VERSION        unversioned name, version-stripped discriminator
         PROJECTION             "Note as of core-entity-set-v1.0.0"
                                       ↓
LAYER 2: TERMINOLOGY           rename to vocabulary
         PROJECTION             substrate-canonical:  Note
                                investor-vocab:       Insight
                                academic-vocab:       Annotation
                                <industry>-vocab:     <whatever>
                                       ↓
LAYER 3: LOCALIZATION          translate within vocabulary
         PROJECTION             en_US:  Note / Insight / Annotation
                                ja_JP:  ノート / 洞察 / 註釈
                                es_MX:  Nota / Visión / Anotación
```

Full projection pipeline composes:

```
project(source, set: "core-entity-set-v1.0.0", vocab: "investor-vocab", locale: "en_US")
   → Insight (unversioned, English, investor terminology)
```

## Why terminology MUST precede localization

Operator 2026-05-26: "we will have terminology projections BEFORE localization. so it can be like dick pick industries. and we can then localize."

If you localize first then re-vocabulary, you're translating the wrong words. Compare:

- **WRONG**: `Note → ノート → ホットテイク` — localizes then tries to find "hot take" equivalent in Japanese, but Japanese "hot take" isn't the projection of ノート — it's its own native concept.
- **RIGHT**: `Note → HotTake (re-vocab) → ホットテイク (localize HotTake)` — the localization-table knows HotTake's Japanese form because the vocabulary was decided first.

**Terminology selects the conceptual frame. Localization translates within that frame.** Doing them in the other order conflates "what we call this thing" with "what language we call it in."

## The substrate already does this at the verb register

`SUMMON` (operator/mythic) vs `Forge` (substrate/industrial) per [[summon-vs-forge-two-registers-2026-05-17]] is a verb-level terminology projection without a localization axis. Schema-projection generalizes the same pattern to type-name level.

## Architecture

```
schema-universal/private/universal/projections/
├── terminology/                                # TERMINOLOGY tables
│   ├── substrate-canonical.terminology.json    # identity mapping (default)
│   ├── investor-vocab.terminology.json
│   ├── academic-vocab.terminology.json
│   └── <industry-x>-vocab.terminology.json
│
├── localization/                               # LOCALIZATION tables (per terminology)
│   ├── substrate-canonical-ja_JP.locale.json
│   ├── investor-vocab-ja_JP.locale.json
│   └── ...
│
└── rendered/                                   # OUTPUT cache (cartesian product)
    └── <schema-set>/<terminology>/<locale>/<Type>.schema.json
```

Typed primitives (live in `schema-universal/.../schema-families/projection-schemas/v0.1.0/`):

- **`TerminologyProjectionModel`** — `vocabulary: String, mappings: [String: String], sinceVersion: String?, notes: [NoteModel]?, extensions: [String: JSON.Value]?`
- **`LocaleProjectionModel`** — `vocabulary: String, locale: String, mappings: [String: String], sinceVersion: String?, notes: [NoteModel]?, extensions: [String: JSON.Value]?`

Both follow the open-catalog discipline: new vocabularies + new locales append as records; three-valued logic on consumer references.

## Translator layer at LLM I/O boundary

When an LLM emits projected JSON (no version discriminator), the translator:

1. Identifies which `(set, vocabulary, locale)` triple grounded the LLM
2. Looks up the reverse map: projected name → canonical substrate name
3. Stamps the version discriminator (`"NoteModel": "0.4.0"` etc. — using the set's pin)
4. Routes through the versioned decoder
5. Substrate-internal world stays versioned-and-discriminated

The translator is the contact patch between the LLM-facing unversioned world and the substrate-internal versioned world.

## What this unlocks

1. **Diffusion-model grounding** — ground LLM on `(set, substrate-canonical, en_US)` projection; output names are clean `Note`/`LinkRef`/`Form`.
2. **Audience-specific schemas** — investor-facing tooling grounds on `(set, investor-vocab, en_US)`; same shapes, different conceptual frame.
3. **Future localization** — when substrate goes multilingual, each terminology gets its own per-locale table; layered evolution.
4. **Tradition preserves fire** — three independent evolution surfaces (schemas at source, vocabularies at terminology, languages at locale). Each layer evolves without disturbing the others. The substrate keeps the fire in three nested chambers.

## Related

- [[summon-vs-forge-two-registers-2026-05-17]] — verb-level terminology precedent that prefigures the type-level system
- [[feedback_class-name-equals-json-key-discriminator]] — why source stays versioned (round-trip protection)
- [[feedback_json-crispr-corpus-migrator-pattern]] — round-trip equality as correctness witness (preserved by keeping source versioned)
- [[feedback_three-valued-logic-open-catalogs]] — TRUE/FALSE/UNKNOWN validation pattern that applies to terminology + locale references
- [[insights/tradition-preserves-fire-not-ashes-2026-05-25]] — projections preserve schema-fire across version evolution + vocabulary frames + language locales
