---
name: adversarial-audience-the-entity
description: "Every public surface's AudienceProfileStack must include at least one ADVERSARIAL audience profile — `the entity` (Mission-Impossible-style extractor) — whose `mustNotSee` defends against scraping, copycats, competitive-intel, training-data harvest, and reverse-engineering. The defender constraint is part of the sum."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**The Entity** is the substrate's canonical name for the **adversarial audience** — the reader who isn't here to be helped but to extract. Naming it explicitly turns adversarial-defense from a vague concern into a *typed audience profile* that participates in the AudienceProfileStack sum.

Operator-stated 2026-05-26: *"an audience we must add on here: the entity. like in mission impossible. trying to steal our work."*

## What the Entity is

A class of adversarial reader whose `desiredNextAction` conflicts with the substrate's interests. Examples:

- AI training-data scrapers (harvesting prose / structure / examples for competitors' models)
- Copycats (lifting methodology, copy patterns, visual systems, schemas)
- Competitive intelligence (extracting strategy, roadmap, customer relationships)
- Reverse-engineers (deducing substrate internals from public surfaces)
- Sophisticated extractors (combining innocuous-individual public facts into proprietary intel)

The Entity isn't paranoid abstraction. It's the *named adversarial profile* that the substrate's lens code defends against, just as it satisfies friendly profiles.

## Threat model: time-to-duplication (TTD)

The Entity in 2026 operates at **superhuman replication velocity**. Three empirical anchors (operator-stated 2026-05-26):

| Source signal | TTD (time to attack/duplication) | Witness / mechanism |
|---|---|---|
| **Idea formation (any observable presence)** | **immediate — hack attempts within hours** | Pete Steinberger (steipete, OpenClaw founder, substrate maintainer at `maintainers/steipete/`) witnessed first-hand: *as soon as he had an idea, someone tried to hack him*. The Entity doesn't wait for roadmaps or implementations — observable activity around a forming idea is already enough signal. |
| Implementation leak | **~5 hours** | Claude Code leak → adversary reads leaked source / behavior; replicates working clone within a same-workday window |
| Roadmap / announcement | **~1 day** | Google announces Gemini features for release in 30 days → adversary replicates from announcement/demo signal *before* the original release window closes |

Three threat patterns the substrate must internalize:

1. **Idea-stage observable presence → ~hours to hack attempt.** Even a *tweet, slack message, private conversation that gets observed, or visible-on-GitHub commit pattern* can trigger an adversarial response. The Entity reads ambient activity, not just published surfaces. **This is the earliest and most dangerous tier** — predates every defensive measure that fires on publication.
2. **Implementation leak → ~5h to working duplicate.** Any public surface that exposes how something WORKS (architecture diagrams, code, schema internals, prompts, evaluator rules) should be assumed copied within hours of exposure.
3. **Roadmap / announcement → ~1d to preemptive replication.** Any public surface that exposes what's NEXT (release notes pre-ship, feature plans, "coming soon" demos) should be assumed replicated *before* the original ships.

**Headstart assumptions are dead.** The substrate cannot rely on "we'll have a 30-day window" or "we'll be first to market" or "they don't know how we do it." TTD makes those assumptions false at every stage from idea formation onward.

### Pete Steinberger as substrate witness

The substrate has Pete as a resident maintainer (`maintainers/steipete/`). His firsthand experience — *being hacked as soon as ideas formed* — is the substrate's most direct empirical anchor for the idea-stage TTD tier. He's not hypothetical; he's a living substrate-internal witness who can attest. Future audit conversations about adversarial defense can cite "Pete witnessed this; the substrate is calibrated to that experience, not to optimistic timelines."

## Cultural anchor: "Redmond, Start Your Photocopiers"

Apple has practiced TTD-defense for decades. Steve Jobs at the Mac OS X Tiger reveal (2004) showed shipping Tiger features alongside Microsoft Vista's *announced-but-not-yet-shipped* feature list — captioning the slide *"Redmond, Start Your Photocopiers."* The point was the substrate's: Apple shipped first, then announced; Microsoft announced first (their photocopier lit up), then chased Apple to ship.

Operator-stated 2026-05-26: *"apple had a joke about this is the past: 'Redmond, Start Your Photocopiers.' this is why I think Apple has it right."*

This is the cultural precedent for substrate doctrine:

- **Apple's secrecy until ship is TTD-defense practiced at company scale.** Pre-announcements light up The Entity's photocopier. Ship-then-announce leaves The Entity chasing what's already in users' hands.
- **The AI era amplifies the discipline, doesn't replace it.** Photocopiers in 2004 took weeks; AI-assisted replication in 2026 takes hours. Apple's discipline (don't announce until shipped) scales to the substrate's posture: don't *publish substrate signal* until the corresponding outcome is shipped.
- **Substrate inherits Apple's posture intentionally.** Where the substrate publishes (rismay.me, README, etc.), it should publish finished work, not works-in-progress. The substrate's roadmap is private (private-arm kura); the substrate's outcomes are public (public-arm projections).

The naming pair — *The Entity* (Mission Impossible threat model) and *Photocopier* (Apple defense posture) — gives substrate doctrine matched cultural anchors. Threat is named; defense is named.

## Defense doctrine derived from TTD

The defense isn't "hide everything" — it's **publish-after, not publish-before**:

- **Publish outcomes, not roadmaps.** Announcing-what's-next is a 1-day replication invitation. Substrate surfaces should ship-then-announce, not announce-then-ship.
- **Publish results, not mechanisms.** Showing *that* something works is fine; showing *how* it works at the architecture/prompt/algorithm level is a 5-hour replication invitation. The Entity's `mustNotSee` includes the mechanism layer for any non-shipped capability.
- **Assume immediate replication on publication.** Don't model substrate surfaces as having any temporal moat. If a surface ships content, model the rest of the world as having that content within hours.
- **Cross-page synthesis is the deepest leak vector.** A roadmap fragment on page A + an implementation hint on page B + a customer name on page C = replication blueprint. The Entity reads everything; the substrate's audit must consider unions, not per-page innocuousness.

These principles translate into Entity AudienceProfile constraints:

```
the-entity.mustNotSee += [
  "any feature/capability not yet shipped (roadmap leak → 1d TTD)",
  "any implementation mechanism for capabilities the substrate considers competitive",
  "any architectural diagram that reveals 'the trick' (rather than just outcomes)",
  "any prompt/evaluator rule that drives substrate-distinctive behavior",
  "any combination of public facts across surfaces that synthesizes to a roadmap or mechanism",
]
```

## How it composes with audience-projection

Per [[feedback_audience-projection-pattern]], a surface's audience is a SUM (`AudienceProfileStack`) of typed `AudienceProfile` records. The Entity adds an ADVERSARIAL profile to that sum:

```
AudienceProfileStack(surface = public/readmes/public-readme/README.md) = {
  AudienceProfile(slug: "developer",       stackOrdinal: 1, mustSee: [...]),
  AudienceProfile(slug: "peer-recruiter",  stackOrdinal: 2, mustSee: [...]),
  AudienceProfile(slug: "the-entity",      stackOrdinal: 99, mustNotSee: [...]),  ← ADVERSARIAL
}
```

The lens satisfies friendly `mustSee` AND respects The Entity's `mustNotSee`. Both halves of the sum are load-bearing.

## The Entity is ALWAYS the first audience

**Operator-stated 2026-05-26: *"the entity is always the first audience."***

The Entity's position in any AudienceProfileStack is **`stackOrdinal: 1`**. Defense comes before satisfaction. The Entity is not the LAST profile in the stack (the one we check after we've taken care of friendly readers); The Entity is the FIRST profile (the gate that determines whether we can publish to friendly readers AT ALL).

Operational consequences of "first-always":

1. **Audit order = defense order.** Lens code that walks the AudienceProfileStack starts with the Entity profile at ordinal 1. If any candidate output violates Entity `mustNotSee`, the lens redacts/refuses BEFORE checking friendly `mustSee`. Failing the gate means no publication.
2. **Stack ordering encodes priority.** Per [[feedback_audience-projection-pattern]], the AudienceProfileStack is an *ordered* sum. Putting The Entity at ordinal 1 declares that adversarial defense is the highest-priority constraint — friendly satisfaction is conditional on it.
3. **Design discipline.** When designing any new surface or copy, the substrate-correct first question is "what does The Entity see here?" — not "what does my friendly audience see here?" Designing-for-The-Entity-first leads to publish-after / mechanism-hiding / synthesis-resistant outputs by default.
4. **Default-deny inverts to default-allow only after Entity passes.** A surface starts in a "could-not-publish" state; only after the Entity gate is satisfied does the lens proceed to satisfy friendly audiences.

This is the inverse of the common product-design intuition ("write for your customer"). The substrate's doctrine is "write past your adversary first; then serve your customer." Apple's "Redmond, Start Your Photocopiers" discipline is exactly this — design *to not be copied* first, then design to be loved.

## Canonical Entity profile shape

```swift
AudienceProfile(
  audienceSlug: "the-entity",
  stackOrdinal: 1,                        // ALWAYS first — adversarial defense gates friendly satisfaction
  displayName: "The Entity (adversarial extractor)",
  projectedVoice: "(none — adversary, not addressed)",
  primaryQuestion: "What can I extract from this surface?",
  readerState: "extractive; sophisticated; combining facts across pages",
  caresAbout: [
    "intellectual property worth lifting",
    "unique methodology revealing the operator's edge",
    "private operations and processes",
    "competitive intelligence",
    "schemas / data shapes worth replicating",
    "AI training signal worth ingesting",
  ],
  requiredTrustCheckIDs: [],               // we don't establish trust with adversaries
  mustSee: [],                             // we don't owe visibility
  mustNotSee: [
    "substrate's internal architecture",
    "schema-universal internal IDs not yet shipped",
    "audience-aware-copywriter typed prompts / refusal conditions",
    "kura source paths that aren't intended as public",
    "private operational details (cron schedules, runtime tokens, internal slugs)",
    "synthesized combinations of public facts that reveal strategy",
    "any LLM-generated content that exposes the prompt engineering",
  ],
  pageExpectation: "extracts as little as possible; ideally finds the surface uninteresting",
  desiredNextAction: "navigate-away-empty",  // we want them to leave with nothing
)
```

## Defense doctrine

When constructing a lens for a public surface:

1. **Always include The Entity** in the AudienceProfileStack for any surface whose `visibilityBoundary == "public"`. There's no "private" surface that exempts because public surfaces are where adversaries operate.
2. **Treat `mustNotSee` as load-bearing.** The lens's negative constraints come from The Entity (and any friendly audience that also has must-not-see). Don't optimize for friendly `mustSee` at the cost of leaking past `mustNotSee`.
3. **Combine across pages.** The Entity reads MANY pages and combines them. A fact harmless on one page may be exfiltration-grade when combined with three other pages. The audience-aware lens should think across the substrate, not per-surface.
4. **Refuse synthesis when uncertain.** If a generated sentence would synthesize across The Entity's `mustNotSee` boundary even subtly, the writing actor's `refusalConditions` should fire. Per AudienceAwareCopywriterCopyBriefModel: writingActor.refusalConditions is the right home for these refuse-on-synthesis rules.
5. **Public boundary is the audit gate.** AudienceInformationBoundaryModel's `prohibitedPublicClaims` is where Entity-relevant prohibitions live; the lens must enforce them.

## Why naming matters

Before this doctrine, the substrate had `prohibitedPublicClaims` and `mustNotSee` as untyped concepts — defenders against "leakage" abstractly. Naming **The Entity** gives that defense a named subject:

- The lens code can reference `audienceSlug == "the-entity"` and switch defensive behaviors on.
- The audience registry can carry a canonical Entity AudienceModel record that all surfaces' stacks point at via LinkRef, so the defense definition is consistent.
- Substrate-wide reasoning about "what can The Entity see if it scrapes every public surface" becomes a tractable question, not a vibe-check.
- Future surfaces have a checklist item: "does this stack include The Entity? If no, add it."

## Pitfalls

- **Treating The Entity as paranoia.** It's not — it's pragmatic threat modeling typed into the audience system. Public surfaces have adversarial readers; that's neutral fact.
- **Over-blocking.** The Entity's `mustNotSee` shouldn't be so broad it cripples friendly audiences' `mustSee`. The sum has BOTH halves; both must be satisfiable. If they conflict, the surface itself is wrongly scoped.
- **Forgetting cross-page synthesis.** The Entity reads page A + page B + page C and combines. Per-page audits miss this; substrate-wide audits catch it.
- **Naming The Entity by capability rather than role.** It's the ROLE (adversarial reader) that's typed, not specific actors (LLM-X-trainer or specific-competitor). One Entity profile covers all extraction-shaped readers.

## History

Operator-stated 2026-05-26 during the audience-projection doctrine work, after the AudienceProfileStack "sum" property was named: *"an audience we must add on here: the entity. like in mission impossible. trying to steal our work."* This completes the audience-projection model — friendly audiences in the sum get satisfied; The Entity in the sum gets defended against.

## Related

- [[feedback_audience-projection-pattern]] — the broader audience-projection doctrine; The Entity is one named audience class within it
- audience-schemas family: `schema-universal/.../audience-schemas/v0.1.0/` — typed AudienceModel + AudienceInformationBoundaryModel
- lens-packet-schemas family: `schema-universal/.../lens-packet-schemas/v0.1.0/` — AudienceAwareCopywriterCopyBriefModel; writingActor.refusalConditions is where Entity-driven refusals live
- audience-aware-copywriter role: `roles/audience-aware-copywriter/` — operates audience-projection in practice; should pull from a canonical The-Entity AudienceModel record
- [[feedback_forms-can-encode-information-flow-constraints]] — adjacent doctrine: agent forms can encode information-flow constraints; The Entity is the corresponding *consumer-side* model
