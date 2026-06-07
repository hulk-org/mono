---
name: enums-vs-models-substantive-knowledge
description: "Substrate doctrine: enums encode symbols without substance. When a typed concept has substantive knowledge (descriptions, traits, sources, function), use a MODEL with typed instances on disk — not an enum. Knowledge that lives only in chat memory is doctrine-decayable; substrate writes it down as typed data."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Enums encode symbols without substance.** Operator-stated 2026-05-30 (CLIA session, PersonalityArchetype design):

> *"enums are almost always the wrong abstraction. don't we need to create actual models for these 12 which explain what they are and how they function, etc."*

> *"we can't leave all the jung stuff in memory we have to write it all down."*

> *"the simple link ref NAME will give us the context that we need as the enum would have given us."*

## The doctrine in one line

**When a typed concept has substantive knowledge attached (descriptions, traits, sources, function, behavior), define a MODEL and instantiate it as typed files on disk — DO NOT collapse to an enum. The LinkRef's `title` field preserves the symbolic-name clarity an enum case would have given (`title: "outlaw"` reads identically to `.outlaw`), without sacrificing the substantive content the enum would have erased.**

## Diagnostic question for any proposed typed field

Before writing `enum Foo { case a, case b, case c }`, ask:

1. **Does each case carry substantive knowledge?** (description, traits, function, sources, examples)
2. **Will future sessions need to QUERY that knowledge?** ("which archetypes share trait X?", "what does this case mean in practice?")
3. **Is the knowledge currently living in chat memory or in agent context that will decay at session boundaries?**

If YES to any: build a MODEL, not an enum. Author typed instances on disk. Reference via LinkRef.

## When enum IS the right abstraction (the exception)

Enums are appropriate when the cases are PURE DISCRIMINATORS without semantic content:

- **Status flags**: `status: active | inactive | archived` — pure state, no substantive knowledge per case
- **Compositional axes**: `composition: singular | collective` — pure typing, no rich content
- **Closed binary discriminators**: `direction: inward | outward` — flag-only
- **Mode selectors**: `engagementMode: cooperative | defensive | observational | adversarial` — borderline; could promote to model if each mode warrants description+applicability+tonal-implications

Rule of thumb: **if the case name is the entirety of what you'd ever want to say about that case, enum is fine. If you'd want to write a paragraph about each case, you need a model.**

## What the substrate gives up by using enum-instead-of-model

| Loss | Cost |
|---|---|
| **Substantive knowledge** | Description, traits, sources, examples — all live in chat memory or doc prose; not typed-queryable |
| **Citeable provenance** | No `sourceRefs` per case → can't trace where the concept came from |
| **Compositional queries** | "Which archetypes share trait X?" requires data; enum gives only membership |
| **Cross-case relationships** | `oppositePoles`, `complementaryArchetypes` — invisible to enum |
| **Substrate-doctrine accumulation** | Doctrine learned about a case stays in agent memory; substrate can't accumulate typed notes |
| **Knowledge audit** | No structured trail of what substrate knows about each case |

## The LinkRef-name preserves enum-grade clarity

The operator's key insight: **the LinkRef's `title` field (or slug) gives the same human-readable symbolic clarity an enum case would.**

```swift
// Enum approach (rejected):
identity.personalityArchetype == .outlaw

// LinkRef-to-model approach (correct):
identity.personalityArchetypeRef?.title == "outlaw"
// + resolving the ref gets the full PersonalityArchetypeModel with all the knowledge
```

Reading either is symbol-grade clear. The LinkRef gives us BOTH the symbol AND the queryable substance. Zero cost vs enum on the human-grading side, infinite gain on the substrate-knowledge side.

## Pattern landed before this doctrine was named

The substrate has been UNCONSCIOUSLY following this pattern in several prior moves:

| Concept | Wrong abstraction (almost taken) | Right abstraction (landed) |
|---|---|---|
| `notes: String` | Raw string per identity | `notes: [NoteModel]` — typed blocks, author, slugs, links |
| `Alignment` (enum) | 4-case enum (aligned/unaligned/cooperative/defensive) | `AlignmentModel` struct with representationAlignment + referentAlignment + engagementMode + notes |
| `roleClass` (enum) | Enum with 10 cases | 10 per-file `<slug>.class.su.json` instances at `substrate/roles/classes/` ([[feedback_role-classes-as-files-not-catalog]]) |
| `axiomCategory` (enum) | Enum with 6 cases | 6 per-file `<slug>.category.su.json` instances at `kura-spaces/axioms/categories/` |
| `PersonalityArchetype` (enum) | 12-case Jung enum | 12 per-file `<slug>.personality-archetype.su.json` instances at `kura-spaces/personality-archetypes/` |

Each of these the operator caught when I proposed the enum form. This doctrine names the pattern explicitly so it's not re-derivable-by-correction next session.

## How to apply

1. **Before declaring any new typed enum**, run the diagnostic above. If the cases carry substantive knowledge, build a model.

2. **Model shape includes the substance**: description, traits, function, sources, examples, oppositePoles/complementary cross-refs, notes. Don't strip-mine the knowledge into a thin schema and hope the prose lives elsewhere.

3. **Typed instances on disk** at the appropriate kura-space (per [[feedback_typed-axioms-as-typed-tribal-knowledge]] + [[feedback_role-classes-as-files-not-catalog]]). Naming convention: `<slug>.<type>.su.json` ([[feedback_su-json-typed-suffix-convention]]).

4. **Reference via LinkRef** from consumer types. `LinkRefModel.title` carries the symbol-grade clarity; resolving the ref carries the substance.

5. **Categories as sibling typed-model**: when the N instances group naturally, create a Category model + per-category instance files in a `categories/` subdirectory. Each instance references its category via `categoryRef: LinkRefModel?`.

6. **Doctrine landing checklist**: schema family in `schema-universal/`, typed instances in `spaces-universal/kura-spaces/<typed-category>/`, `index.md` at the kura-space root, optional `categories/` subdirectory.

## Anti-pattern to catch in self

When proposing a typed enum, watch for these symptoms that mean you should split to a model:

- "Each case has a meaning that takes a sentence to explain"
- "I keep wanting to add comments next to each case to describe it"
- "The cases have cross-references" (foil-of, opposite-of, complement-to)
- "Different sources cite these differently" (multiple sourceRefs per case)
- "Substrate will accumulate notes about each case over time"
- "A non-expert reader couldn't tell the cases apart from the symbol alone"

Any one of these = MODEL, not enum.

## Related

- [[feedback_typed-axioms-as-typed-tribal-knowledge]] — the meta-doctrine: substrate types implicit team-doctrine as explicit, articulated, persistent, queryable, citeable data. Models with typed instances are the structural form this takes.
- [[feedback_role-classes-as-files-not-catalog]] — first concrete instance: role-classes exploded from catalog-enum into per-file models. Same pattern.
- [[feedback_su-json-typed-suffix-convention]] — `<slug>.<type>.su.json` filename pattern for typed instances.
- [[feedback_alignment-model-aligned-representation-unaligned-referent]] — Alignment was almost an enum; became a model. Same doctrine in action.
- [[feedback_data-is-one-thing-rendering-is-projection]] — typed instances are the data; any catalog/index is a projection. Don't conflate.
- [[feedback_inherent-vs-relational-typing-split]] — orthogonal doctrine; tells you WHICH typed axis to put the model in (inherent vs relational).
