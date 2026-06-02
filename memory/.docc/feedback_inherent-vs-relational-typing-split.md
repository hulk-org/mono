---
name: inherent-vs-relational-typing-split
description: "Substrate doctrine: inherent typing (what something IS) and relational typing (what something DOES in some system) are orthogonal axes. Type both separately rather than conflating them. Diagnostic for any new typed field: is this about what the thing IS, or about what the thing DOES in some system? If both, split."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Inherent and relational typing are orthogonal axes.** Operator-surfaced 2026-05-30 (CLIA session, character-archetype refinement):

> *"PersonalityArchetype (Jungian psychic pattern — what they ARE) ← future, separate axis. this is SOOO good and so thought out. that I think we extract this and we work around this."*

The operator's "extract this and work around this" promotes the substrate's previously-implicit splitting-pattern into named doctrine.

## The doctrine in one line

**Inherent typing (what something IS) and relational typing (what something DOES in some system) are orthogonal typed axes. Don't conflate them. When designing a typed field, ask: "this is a {classification} OF WHAT?" If the answer requires hedging across what-it-is and what-it-does, split into two typed axes.**

## Diagnostic question for any new typed field

Before adding `var foo: FooKind` or `var foo: [FooKind]` to a model, ask:

1. **Is `Foo` describing what the thing IS?** (psychic pattern, intrinsic property, persistent characteristic)
2. **Is `Foo` describing what the thing DOES?** (functional role, position in a system, relational stance)
3. **If BOTH senses are present**, the field is conflating two axes. SPLIT.

The split usually looks like:

- `inherentXxx` (or just `Xxx`) — what the thing IS
- `relationalYyy` (or `roleYyy`, `engagementYyy`, `castYyy`) — what the thing DOES in some named context

## Why this matters

| Symptom of conflation | What goes wrong |
|---|---|
| **Same field has cases at different abstraction levels** | "mentor" (relational — to whom?) sits next to "shadow" (Jungian — inherent) in same enum |
| **Field overload** | The single field tries to mean two things; consumers can't tell which sense applies |
| **Future axes blocked** | Once `Foo` is named broadly, can't add a SECOND `Foo`-flavored axis without confusion |
| **Composition impossible** | Can't query "actors with INHERENT pattern X who happen to play ROLE Y" because both live in one field |
| **Doctrine drift** | Reader can't tell whether a value is making an inherent-claim or a relational-claim about the actor |

## Why orthogonality is the type-system feature

Two-axis composition gives the substrate diagnostic capabilities single-axis enums can't express:

- **Mismatch detection**: a `.contemporaryFool` CastRole composed with a wished-for `.ruler` PersonalityArchetype IS the diagnostic signature of "surface confidence masking shallow depth." Single-axis can't express the mismatch.
- **Cross-axis queries**: "which actors with inherent `.outlaw` are PLAYING `.protagonist` in substrate's story?" requires both axes typed independently.
- **Independent evolution**: each axis can refine its case set without disturbing the other. Adding a new Jung archetype (substrate-original) doesn't touch CastRole; adding a new narrative function doesn't touch PersonalityArchetype.

## Where substrate has been (semi-consciously) applying this doctrine

The substrate has been splitting along inherent-vs-relational lines in several prior moves without naming the pattern:

| Concept | Inherent axis | Relational axis | Status |
|---|---|---|---|
| **Alignment** ([[feedback_alignment-model-aligned-representation-unaligned-referent]]) | `referentAlignment` (actor's actual alignment in the world) | `engagementMode` (how substrate engages with them) + `representationAlignment` (whose POV the typed record encodes) | ✓ already split |
| **Audience addressing** ([[feedback_addressing-protocol-architecture-linkref-v03]]) | `IdentityModel` (who the actor is — inherent) | `AddressingProtocolModel` (how substrate addresses them — relational/cultural-contextual) | ✓ already split — separate schema families joined by LinkRef |
| **Audience composition** ([[feedback_addressing-protocol-on-every-identity]]) | identity profiles (inherent — who) | audience packets reference them per surface (relational — for-this-cohort) | ✓ already split via reference layering |
| **CharacterRole vs PersonalityArchetype** (this doctrine's first concrete instance) | `PersonalityArchetypeRef` — Jung's 12 archetypes (what they ARE) | `CharacterRole` (what they DO in substrate's story) | ✓ split landed 2026-05-30 |
| **Identity vs identity-projection** | identity facts (inherent — who the actor is) | how substrate projects/addresses identity per audience (relational) | ✓ already split via addressing-protocol layer |

Making the doctrine explicit means future typed additions get the SPLIT decision proactively, not via reactive correction.

## What this doctrine PREDICTS (substrate-future)

Other typed concepts that may benefit from the same split as substrate grows:

| Concept | Possible inherent axis | Possible relational axis |
|---|---|---|
| **OperationMode** | inherent capability (what the agent CAN do) | relational engagement (what mode substrate currently runs it in) |
| **Trust** | actor's inherent trustworthiness (psychic / track-record) | substrate's relational trust-level (currently granted / currently revoked) |
| **Authority** | formal authority (e.g., institutional title) | substrate-granted authority (what substrate lets this identity decide) |
| **Skill** | inherent capability (the actor can DO X) | relational permission (substrate ASKS this actor to do X) |
| **Status** | inherent state (active/archived/deceased) | relational state (engaged-with / paused / sidelined for this substrate) |

When any of these get typed, run the diagnostic. If both senses are present, split.

## How to apply

1. **Before adding any typed field** to a substrate schema, run the diagnostic. If you can't cleanly answer "this is a {classification} OF WHAT?" without hedging, split.

2. **Naming pattern**: inherent axis usually keeps the bare concept name (`PersonalityArchetype`); relational axis takes a qualifying prefix or suffix (`CharacterRole`, `EngagementMode`, `CastRole`, `referentAlignment`, `bindingNote`).

3. **Compose via cross-field queries**, not via single-field discrimination. Substrate code reads BOTH axes when making decisions: `if identity.castRole.contains(.antagonist) && identity.personalityArchetypeRef.title == "outlaw" { ... }`.

4. **Schema layering**: inherent typing often lives in the schema family for the concept itself (e.g., `personality-archetype-schemas`); relational typing often lives on the consumer schema (e.g., `IdentityModel.characterRole`). The two reference each other via LinkRef.

5. **Memory test**: a future-session agent should be able to read the schema and tell whether each typed field is making an inherent-claim or a relational-claim about its subject. If they can't tell, the field needs renaming, splitting, or doc-clarification.

## Anti-pattern to catch in self

When proposing a typed field, watch for these symptoms of conflation:

- "We need a field that says whether this actor is X" — but X is sometimes-inherent-sometimes-relational depending on context
- "Let's add `kind` / `type` / `category`" — these generic names often paper over an inherent/relational split
- Operator pushes back: "wait, is this about who they ARE or what they DO?" — that's the diagnostic the doctrine surfaces.

Any one of these = pause and ask the diagnostic. Better to split early than to overload-then-refactor.

## Related

- [[feedback_enums-vs-models-substantive-knowledge]] — sibling doctrine; tells you the SHAPE (model not enum) once you've decided WHICH axis (inherent vs relational) needs typing
- [[feedback_alignment-model-aligned-representation-unaligned-referent]] — concrete instance of the doctrine landed earlier in same session
- [[feedback_addressing-protocol-architecture-linkref-v03]] — concrete instance: identity (inherent) + addressing-protocol (relational) split via LinkRef
- [[feedback_addressing-protocol-on-every-identity]] — same separation: WHO the actor is vs HOW substrate addresses them
- [[feedback_typed-axioms-as-typed-tribal-knowledge]] — meta-doctrine: substrate types implicit patterns as explicit data. Inherent-vs-relational split is an instance of typing what's been implicit.
- [[feedback_data-is-one-thing-rendering-is-projection]] — orthogonal but related: data is one thing, rendering is projection. Inherent typing is closer to data; relational typing is closer to projection.
