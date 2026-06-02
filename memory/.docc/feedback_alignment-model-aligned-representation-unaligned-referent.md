---
name: alignment-model-aligned-representation-unaligned-referent
description: "Substrate alignment doctrine: typed records are ALIGNED (in substrate); the actors they MODEL may be aligned or unaligned. AlignmentModel captures the relationship + engagement mode. Cures the polish-without-substance failure mode for webpage generation."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Alignment is a typed substrate concept, not just a flag.** Operator-stated 2026-05-30 (CLIA session):

> *"the entity in OUR substrate is ALIGNED. but the one in the wild is UNALIGNED... we use our aligned model to fight back against the [unaligned] model... when we speak to the entity in the real world, we must be clear to use the knowledge of our aligned model to help fight it."*

> *"I think we need an alignment model... not just an enum."*

> *"this explains WHY we havn't been able to create good webpages."*

## The doctrine in one line

**Substrate-typed records are always aligned (by being in substrate). The actors they MODEL may be aligned or unaligned. The typed AlignmentModel captures this asymmetry + the engagement mode the substrate uses to bridge the gap.**

## Typed shape (landed in identity-schemas v0.8.0)

```swift
public enum Alignment: String, Codable, CaseIterable, Sendable {
  case aligned    // shares substrate purposes
  case unaligned  // does not share substrate purposes
}

public enum EngagementMode: String, Codable, CaseIterable, Sendable {
  case cooperative   // typed model coordinates with aligned actor
  case defensive     // typed model defends against unaligned actor
  case observational // typed model learns neutrally
  case adversarial   // typed model actively opposes (reserved)
}

public struct AlignmentModel: Codable, Equatable, Sendable {
  public var representationAlignment: Alignment    // = .aligned always for substrate records
  public var referentAlignment: Alignment          // may differ from representation
  public var engagementMode: EngagementMode
  public var notes: [NoteModel]                    // typed NoteModel — author/blocks/slugs/links
}
```

The field uses `notes: [NoteModel]` (typed) not `notes: String` — per operator correction: "we have a notes model. use it." This carries author provenance, structured blocks, slug categorization, optional cross-substrate links.

## How it composes per character role

| character role × referent alignment | engagement mode | example |
|---|---|---|
| **(protagonist, aligned)** | cooperative | rismay, CLIA, Carrie — substrate's own actors |
| **(protagonist, unaligned)** | cooperative / observational | external aligned-but-not-controlled allies — partners we model but don't commission |
| **(antagonist, aligned)** | defensive | substrate-internal warnings — claptrap as CLIA's dark-timeline future, deprecated agents |
| **(antagonist, unaligned)** | defensive | **the-entity** — real-world adversaries we model defensively |

The typed combination produces actionable substrate behavior — copy generators, audience packets, audience-aware-copywriters check engagementMode to know HOW to engage.

## Why this unblocks webpage generation

Per operator's diagnosis 2026-05-30: webpages had been blocked because copy generation lacked the typed alignment-model layer. Without it:

- Webpages get written assuming friendly audience
- The unaligned reader (the-entity) extracts whatever's there
- Polish accumulates without structural alignment-aware defense
- The "Cool javascript page: WHO GIVES A FUCK!" failure mode triggers

With the typed alignment model + audience-stack + character-role chain:

```
1. AudiencePacket → resolved cohort (includes the-entity at stackOrdinal 1)
2. For each identity → read characterRoles + alignmentModel
3. From alignmentModel.engagementMode → substrate knows HOW to engage
   (cooperative with public-visitor; defensive against the-entity)
4. From alignmentModel.notes → substrate gets typed explanation of dynamics
5. Copy is generated that satisfies BOTH friendly-mustSee AND adversarial-mustNotSee
```

Each typed primitive (audience packet, identity, characterRole, alignmentModel, addressingProtocol) is necessary but not sufficient alone. **Together** they compose into substrate-correct copy generation.

## Concrete first canonical instance

The-entity Swift package at `substrate/collectives/the-entity/Sources/TheEntity/TheEntity.swift` declares:

```swift
TheEntity.identity.alignmentModel = AlignmentModel(
  representationAlignment: .aligned,
  referentAlignment: .unaligned,
  engagementMode: .defensive,
  notes: [
    NoteModel(
      author: "rismay",
      blocks: [
        NoteBlockModel(kind: "text", text: [
          "The substrate's typed model of the-entity is aligned tooling.",
          "...",
        ]),
        NoteBlockModel(kind: "text", text: [
          "The real-world adversarial extractors we model are unaligned.",
          "...",
        ]),
        NoteBlockModel(kind: "text", text: [
          "When substrate copy reaches the real-world referent, we use the",
          "knowledge from this aligned typed model to defend...",
        ]),
      ],
      slugs: ["alignment-doctrine", "defensive", "first-canonical-antagonist"]),
  ])
```

First canonical instance landed. Future identity packages can follow this pattern.

## How to apply

1. **Every identity record should carry an `alignmentModel`** (optional in v0.8.0 transitional state). When unset, downstream consumers can default to `.cooperative` engagement, but explicit is better.

2. **Substrate copy generators should consult `alignmentModel.engagementMode`** before producing prose. `defensive` mode triggers antagonist-aware copy generation; `cooperative` triggers friendly addressing.

3. **The (typed-representation, real-referent) asymmetry should be made visible in any substrate UI/dashboard.** "TheEntity (aligned model, unaligned referent, defensive engagement)" tells the reader the substrate's relationship with what's modeled — not just the actor's character role.

4. **Engagement-mode change requires deliberate operator decision** — substrate shouldn't auto-transition from defensive to cooperative just because an antagonist's behavior changes. The alignmentModel is operator-authored doctrine.

5. **Notes carry the audit trail.** When the alignment relationship shifts (e.g., a previously unaligned actor becomes aligned via partnership), add a new NoteModel rather than overwriting old notes. The accumulated notes show the substrate's evolving understanding.

## Related

- [[feedback_character-role-antagonist-protagonist-typed]] — characterRole is the narrative axis; alignment is the goal-congruence axis. Orthogonal + composing.
- [[feedback_web-always-has-antagonist-speak-as-such]] — the antagonist is always on the web; alignmentModel.engagementMode tells the substrate HOW to address that presence
- [[feedback_adversarial-audience-the-entity]] — the-entity is the substrate's named adversary; alignmentModel adds the typed engagement posture
- [[feedback_gates-points-scoring-zero-on-gate-fail]] — same "polish vs structural substance" failure mode the operator named via the "Cool javascript page" anti-pattern; alignment-model is the content-layer cure
- [[feedback_the-entity-is-a-collective-not-an-audience]] — the-entity is a collective; TheEntity Swift package is the substrate's first canonical antagonist with alignmentModel populated
- [[feedback_identity-profiles-are-swift-packages]] — TheEntity demonstrates identity-as-Swift-Package; alignmentModel ships as part of the typed identity record
