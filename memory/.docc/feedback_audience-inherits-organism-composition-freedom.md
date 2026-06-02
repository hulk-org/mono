---
name: audience-inherits-organism-composition-freedom
description: "Audience-kind organisms should inherit organism-layer composition freedom (singular OR collective). The \"collective-only\" constraint at the audience kind is a false invariant from when no one had typed an individual audience. Resolves the four-turn audience-ontology refinement loop."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**The audience kind should inherit organism-layer composition freedom.** Operator-stated 2026-05-30 (CLIA session, 5th turn — resolving the audience-ontology refinement loop): *"just like we recognize an individual is an organism and a collective is an organism - same conceptually - we need that for audience model. but also we need to be able to define HOW the organism likes to be spoken to. i guess what I missed is that the entity IS a collective, and so are those other audience packets..."*

**Resolves and supersedes (converges into one position):**
- [[feedback_audience-direction-axis]] — inward/outward was the wrong axis; *individual vs collective composition* was the real one we were dancing around
- [[feedback_audience-internal-vs-external-axis]] — internal/external is a real WHO-axis (composition is a different WHO-axis)
- [[feedback_audience-is-outward-only-scene-partner-is-the-inward-category]] — over-correction; no new top-level category needed
- [[feedback_audience-is-who-not-channel-shape]] — directionally right but missed the organism layer

**Why this is the resolution (and not just turn #5):**

Verified via `swift check` of the existing types:

1. **Organism layer already supports both compositions** (`organism-schemas v0.7.0`, `OrganismModel.swift` lines 164-174):
   ```swift
   public enum OrganismComposition: String, ... { case singular, collective }
   ```
   Both `.singular` and `.collective` are first-class organism compositions. The operator's claim "individual is an organism, collective is an organism — same conceptually" is *already encoded* at the organism layer.

2. **Audience kind explicitly overrules that freedom** (`OrganismModel.swift` lines 257-262 + enum case at line 200):
   ```swift
   case audienceKindWithoutCollectiveComposition
   if kind == .audience, composition != .collective {
     warnings.append(.init(code: .audienceKindWithoutCollectiveComposition,
       message: "An audience organism must use collective composition 
                 even when copy projects one reader voice."))
   }
   ```
   The constraint is intentional but a false invariant. It was written when every typed audience was a cohort; rismay-as-individual is the first counter-example.

3. **`AudienceModel` double-locks** (`audience-schemas v0.1.0`, `AudienceModel.swift` lines 13, 58-62, 92):
   ```swift
   public static let composition = "collective"
   precondition(composition == AudienceOrganismContract.composition)
   ```
   So even if the organism warning were a soft warning, the audience-model construction would still crash on rismay.

4. **"HOW the organism likes to be spoken to" already typed** as `AudienceProjectedVoiceModel` (mode, grammaticalPerson, singularLabel, copyRule). Works equally well for singular and collective audiences — it's organism-property, not surface-property, and it's been waiting for the composition lock to release.

**The fix (small, surgical, no new tiers/axes/schemas):**

| Move | Where | Cost |
|---|---|---|
| Remove `audienceKindWithoutCollectiveComposition` warning case + validation | `organism-schemas v0.7.0 → v0.7.1` (or v0.8.0): `OrganismModel.swift` lines 200, 257-262 | low; removes a false invariant |
| Drop `AudienceOrganismContract.composition = "collective"` hardcode + precondition | `audience-schemas v0.1.0 → v0.1.1`: `AudienceModel.swift` lines 13, 58-62, 92 | low; accept "singular" or "collective" |
| (Future) Migrate `composition` field from `String` to `OrganismComposition` enum | future v0.2.0 | unblocks compile-time discrimination |

**How to apply:**

1. **Stop inventing new top-level tiers** when the existing organism+audience layers already encode the needed dimensions. The four-turn loop kept proposing new categories (`scene-partners/`, `interlocutors/`, `surfaces/` as a sibling to `audiences/`); the right move was *aligning audience-kind with organism-kind freedom*, not adding siblings.

2. **Rismay-as-audience is a valid construction** once the composition lock releases:
   ```
   OrganismModel(kind: .audience, composition: .singular,
     aspects: OrganismAspects(audience: AudienceAspect(
       AudienceModel(slug: "rismay", composition: "singular",
         projectedVoice: AudienceProjectedVoiceModel(
           mode: "named-direct",        // new mode, or use existing "singular-projected"
           grammaticalPerson: "second-person",
           singularLabel: "rismay",
           copyRule: "address rismay directly; sharp, no euphemism, ..."),
         membership: AudienceMembershipModel(
           cohortKind: "individual",     // or "single-named-person"
           memberRefs: [<rismay-operator-link-ref>],
           inclusionRule: "rismay specifically"),
         ...)))
   ```
   The substrate-correct home is still `substrate/audiences/rismay/` — same tier as the-entity, no new category.

3. **Six existing audiences are correctly typed as collectives.** They describe reader cohorts: `the-entity` (adversarial extractors as a class), `public-visitor` (anyone visiting wrkstrm.com), `a16z-speedrun` (the a16z partners), `apple-app-review` (the review team), `investor-first-read` (target investor class), `signed-room-user` (anyone with access). No migration needed for any of them. The composition-only-collective assumption was *correct for those six*; it was wrong as a *constraint on the type*.

4. **Bidirectionality / correctionsChannel / inward-outward concerns** are still valid concerns, but they belong on the future-typed `SurfaceModel` (or whatever the substrate types as the addressing-surface concept). The `AudiencePacketModel.surfaceRefs` field already references surfaces — those references will become typed when `SurfaceModel` exists. Until then, surface-shape lives implicitly in `AudiencePacketModel`'s `accessBranch`/`privacyTier`/`outputContract`/`guardrails`.

5. **Method generalization — "types over prose":** when an ontology argument touches an existing schema family, *read the schemas first* (especially the organism-layer when working with audience/agent/operator/etc., since organism is the unifying root). Four turns of prose ontology rediscovered an architecture that was already typed. The substrate's "Swift over Python" rule has a stronger version: **types are the substrate's pre-existing opinions; prose should respond to them, not invent next to them.** Reading `OrganismModel.swift` at turn 1 would have shortened the loop by four turns.

6. **`swift check` as a method**: when prose is going in circles on an ontology question, write a one-shot Swift scratchpad under `<agent-home>/memory/.docc/repl-proofs/` that *tries to construct the disputed object* through the existing types and let the compiler/preconditions/diagnostics show what refuses what. Per [[feedback_agent-scratchpad-pattern-repl-proofs]], the scratchpad is saved provenance — future readers see what the type system enforced, not just what the prose argued.

## Open

- Schema work: `organism-schemas v0.7.1` (or v0.8.0) to lift the audience-collective-only constraint; `audience-schemas v0.1.1` to lift the precondition. Operator decision on version policy.
- Whether `composition: "individual"` or `"singular"` is the right string value (organism layer uses `.singular`; audience layer might want either)
- `SurfaceModel` schema family — not yet typed; would absorb `accessBranch`/`privacyTier`/`outputContract`/`guardrails`/(future)`interactionModel: bidirectional|oneWay`
- Whether `AudienceMembershipModel.cohortKind` should grow an `internal | external` enum or stay free-form

## Related (resolved chain)

- [[feedback_audience-direction-axis]] — superseded; the real axis was composition, not direction
- [[feedback_audience-internal-vs-external-axis]] — partially preserved (internal/external as a WHO-property survives)
- [[feedback_audience-is-outward-only-scene-partner-is-the-inward-category]] — superseded; over-correction
- [[feedback_audience-is-who-not-channel-shape]] — directionally right but missed organism layer
- [[feedback_adversarial-audience-the-entity]] — correctly typed as collective; unchanged
- [[feedback_data-is-one-thing-rendering-is-projection]] — audience identity = data; surface = projection
- [[feedback_agent-scratchpad-pattern-repl-proofs]] — method for one-shot type-fit verification
