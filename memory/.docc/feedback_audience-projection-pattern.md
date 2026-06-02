---
name: audience-projection-pattern
description: "Audience projection: one kura source projects to outputs framed for an AudienceProfileStack — an ORDERED SUM of typed AudienceProfiles. Audience is first-class organism content (substrate has audience-schemas + lens-packet-schemas). Each audience is itself a sum of constraints (caresAbout / mustSee / mustNotSee / trustChecks / proofOrder)."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**Audience projection** is the substrate's pattern for emitting *audience-appropriate views* of a kura source. The substrate already has typed models for this — audience-schemas + lens-packet-schemas — and the doctrine should compose with them, not reinvent.

It's a specialization of [[feedback_data-is-one-thing-rendering-is-projection]] with two structural refinements the operator named on 2026-05-26: *"we have models for audience projection and we need to take into account it's a sum."*

## The substrate's existing typed models

| Model | Location | Purpose |
|---|---|---|
| `AudienceModel` (audience-schemas v0.1.0) | `schema-universal/.../audience-schemas/v0.1.0/spm/.../AudienceModel.swift` | First-class organism: audience is `organismKind == "audience"` + `composition == "collective"`. Carries projectedVoice, membership, decisionModel, informationBoundary, conceptTranslations. |
| `AudienceAwareCopywriterCopyBriefModel` (lens-packet-schemas v0.1.0) | `schema-universal/.../lens-packet-schemas/v0.1.0/spm/.../AudienceAwareCopywriterCopyBriefModel.swift` | A surface-level brief: surface + requestingActor + writingActor + targetAudience + **AudienceProfileStack** + fiveWs + copyFrame + releaseSet. Used by the `audience-aware-copywriter` role for typed copy generation. |
| `LensPacketAudienceOrdinalityTable` | sibling | Ordinality table for typed audience kinds across the lens-packet family. |

When building audience-projection work, use these models — don't invent parallel typed shapes.

## The sum: AudienceProfileStack

The key insight the operator highlighted: **audience is a sum, not a single value**.

```swift
struct AudienceProfileStack {
  var mode: String          // "ordered-route-reader-stack"
  var source: String        // "audienceRegistry + audienceConformance.requiredAudienceSlugs"
  var profiles: [AudienceProfile]   // ← THE ORDERED SUM
}

struct AudienceProfile {
  var audienceSlug: String
  var stackOrdinal: Int     // position in the sum (1, 2, 3, ...)
  // ... each profile's own constraints:
  var caresAbout: [String]
  var requiredTrustCheckIDs: [String]
  var mustSee: [String]
  var mustNotSee: [String]
  var pageExpectation: String
  var desiredNextAction: String
}
```

A surface's audience isn't ONE audience — it's an **ordered stack of audiences** (the sum). Every URL/page/output has a stack of typed audience profiles, ordered by ordinal position. The projection must satisfy ALL stacked audiences simultaneously.

## The double sum

The "sum" property is actually two-layered:

1. **A surface has a sum of audience profiles** (AudienceProfileStack: `Σᵢ profile_i`).
2. **Each profile has a sum of constraints** (caresAbout[], mustSee[], mustNotSee[], requiredTrustCheckIDs[], proofOrder[]).

So a single surface's audience constraint set is:

```
audience_constraints(surface) = Σᵢ ( caresAbout_i ∪ mustSee_i ∪ mustNotSee_i ∪ trustChecks_i ∪ ... )
```

The lens that projects content for that surface must satisfy this combined set. It's not "project for one audience" — it's "project for the union of all stacked audiences' constraints."

## What the projection actually does

For each surface (one URL / one output):

1. Look up the `AudienceProfileStack` for that surface
2. Collect the sum: union of `mustSee` across all profiles (content the output MUST include), intersection of allowed framings across `mustNotSee` (forbidden across any profile), etc.
3. Walk the kura source
4. Emit content that satisfies the combined set
5. Cite typed `sourceRefs` so the generated output is reproducible

The `AudienceAwareCopywriterCopyBriefModel.releaseSet` plus `CopyFrame.proofOrder` and `CopyFrame.doNotSay` encode the OUTPUT shape that satisfies the audience stack. The brief IS the typed contract between kura content and rendered output.

## Composition: stacks compose

Because both layers are sums:

- **Adding an audience to a surface** = extending the AudienceProfileStack with a new ordinal-positioned profile. The lens auto-accumulates its constraints into the combined set.
- **Adding a concern to an audience** = appending to that audience's caresAbout[]. The lens auto-includes it.
- **Removing an audience or concern** = the inverse.

This is what makes audience projection *composable* and *editable without lens rewrites*. The lens code doesn't change when audiences change; only the stack data changes. The lens is generic over the stack.

## Canonical substrate example

The `about-me` collection at `operators/rismay/public/universal/kura/collections/about-me/`:

- **Source:** `about-me.md` — one comprehensive document
- **Surfaces (each with its own AudienceProfileStack):**
  - `public/readmes/public-readme/README.md` — GitHub README surface; stack includes developer/peer/recruiter audiences
  - rismay.me homepage `/about/` — personal-site visitor surface; stack includes general-visitor + curious-developer
  - laussat.studio `/about/` (when live) — work-engagement surface; stack includes prospective-client + collaborator
  - wrkstrm.com (when live) — venture surface; stack includes investor + customer + recruiter

Same source. Four surfaces. Each surface's projection satisfies its own stack-of-audiences. The lens (currently v0.1 identity-copy in my scratchpad) will evolve to consume AudienceProfileStack records and emit per-stack-satisfying output.

## Distinction from generic projection

| Generic projection ([[feedback_data-is-one-thing-rendering-is-projection]]) | Audience projection (this rule) |
|---|---|
| Differs by FORMAT (markdown / HTML / JSON / PDF) | Differs by AUDIENCE-STACK (sum of typed AudienceProfiles per surface) |
| One source, many surfaces | One source, many surfaces × per-surface audience stacks |
| No typed audience model required | Uses typed `AudienceModel` + `AudienceProfileStack` from substrate schemas |

Most real projections do both — they're surface-aware (format) AND audience-stack-aware (typed sum).

## When to use this pattern

Use audience projection when:
- The same source content has *multiple public surfaces*
- Surfaces have *different audience stacks* (each surface = sum of typed audiences)
- Audience constraints are explicit (cares-about, must-see, must-not-see) and can be encoded in typed AudienceProfiles

Don't audience-project for:
- Single-surface content (no stack variation)
- Content that genuinely differs per surface (those are different sources)
- Cases where audience is too informal to type (just write the content; don't model it)

## Adversarial audiences — The Entity is part of the sum

Every PUBLIC surface's AudienceProfileStack must include at least one **adversarial** audience profile, canonically named **The Entity** (per [[feedback_adversarial-audience-the-entity]] — Mission-Impossible-style extractor trying to steal the substrate's work).

The Entity's `mustSee == []` but its `mustNotSee` is rich — defending against scrapers, copycats, AI-training harvest, competitive intelligence, reverse-engineering, and cross-page synthesis. Adding The Entity to the stack means the lens must satisfy friendly `mustSee` AND respect adversarial `mustNotSee` simultaneously.

The sum has TWO halves:
- **Friendly half**: profiles with `desiredNextAction` aligned with the substrate (developer, peer, customer, investor, ...)
- **Adversarial half**: profiles with `desiredNextAction` conflicting (The Entity)

Both halves are load-bearing. A lens that only satisfies the friendly half leaks past the adversarial half.

## Pitfalls

- **Forgetting it's a sum.** Treating audience as a single value loses the stack structure. The lens then can't handle multi-audience surfaces correctly.
- **Inline audience modeling.** Building the lens with hardcoded audience constraints; the substrate already has typed AudienceModel records — point at them via LinkRef, don't redefine.
- **Drifting projections.** Editing the projection output instead of the source. Lens outputs are regenerated.
- **Forgetting The Entity.** Building stacks of only friendly audiences. Public surfaces have adversarial readers as a neutral fact; the typed audience system models them explicitly.

## History

Operator-stated 2026-05-26 across two clarifications:

1. *"we need to use this simple about-me as an example of audience projection!"* — established the doctrine with about-me as canonical example
2. *"we have models for audience projection and we need to take into account it's a sum."* — surfaced the existing AudienceModel + AudienceAwareCopywriterCopyBriefModel schemas + named the sum property (AudienceProfileStack as ordered sum of profiles; each profile a sum of constraints)

The doctrine now composes with the existing typed schemas rather than parallel-inventing a new abstraction.

## Related

- [[feedback_data-is-one-thing-rendering-is-projection]] — generic projection (format axis); audience projection is its specialization with typed audience-stack input
- [[feedback_content-lives-in-its-owners-home]] — where lens outputs live (audience's natural surface home)
- audience-schemas family: `schema-universal/.../audience-schemas/v0.1.0/spm/audience-schemas-v000-001-000/`
- lens-packet-schemas family: `schema-universal/.../lens-packet-schemas/v0.1.0/spm/lens-packet-schemas-v000-001-000/`
- audience-aware-copywriter role: `roles/audience-aware-copywriter/` — the role that operates this pattern in practice
- [[insights/lens-apps-substrate-pattern-2026-05-18]] — investor-app's founder-sublens + partner-sublens is an early instance
