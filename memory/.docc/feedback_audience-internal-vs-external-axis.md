---
name: audience-internal-vs-external-axis
description: "Internal-vs-external is a second orthogonal axis on audience packets, distinct from inward-vs-outward direction. Trust boundary vs channel shape."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Internal-vs-external is a second axis on audience packets**, orthogonal to (and additive with) the inward-vs-outward direction axis from [[feedback_audience-direction-axis]]. Operator-stated 2026-05-30 (CLIA session): *"we need to upgrade between internal vs external too."* The "too" confirms parallel-not-replacement.

**Why:** Today's 6 audience records (`a16z-speedrun`, `apple-app-review`, `investor-first-read`, `public-visitor`, `signed-room-user`, `the-entity`) all happen to be **external** (not substrate members) AND **outward** (frozen-at-publication). That coincidence has been hiding the two axes inside one apparent flat dimension. The moment we type the operator-as-audience (`inward` + `internal`), the cross-product forces both axes into the open.

Direction is about the *channel*. Membership is about the *trust boundary*. They affect different things; conflating them leaves trust-defaults coupled to channel-shape, which breaks once an internal-outward audience (substrate-internal kura, agent-to-agent handoff packets) or an external-inward audience (live collaborator joining a session) needs to be typed.

**The 2×2:**

|                 | **internal** (substrate member)                                | **external** (not substrate member)                              |
|-----------------|---------------------------------------------------------------|------------------------------------------------------------------|
| **inward** (in-session, bidirectional, live correction) | rismay (operator-in-session); agent ↔ agent handoff turns; maintainer-in-session | external collaborator joining a live session; reviewer co-present in shared turn |
| **outward** (publication-time, monologue, no feedback loop) | substrate-internal kura (handoff packets, agent-to-agent docs, private-arm content) | rismay.me, README, the-entity-defended surfaces, signed-room views, public dashboards |

All 6 current audiences = bottom-right cell. Operator-as-audience = top-left cell. Other two cells real but unpopulated.

**How to apply:**

1. **Every new audience packet declares both axes.** `direction: inward|outward` AND `membership: internal|external` are independent fields. Don't infer one from the other.

2. **Each axis affects different schema fields:**
   - **direction** affects field *presence*: `correctionsChannel` exists only inward; `prohibitedPublicClaims` (in its current external-leak sense) exists only outward; `projectedVoice.mode` differs in valid-values per direction.
   - **membership** affects field *values*: an internal audience's `informationBoundary.privateInformation` can reference substrate-internal kura paths as OK-to-include; an external audience's same field forbids them. Same field, inverted polarity.

3. **Interview questions partition along these axes.** When drafting an audience packet, the 5-question interview from [[feedback_audience-direction-axis]] now has:
   - `projectedVoice.copyRule` → direction-specific (inward = bidirectional voice; outward = frozen monologue)
   - `caresAbout` → direction-specific (inward = beat-edges + next-move; outward = trust-links + plain-language)
   - `trustChecks.mustSee` → membership-specific (internal = "cited the right kura"; external = "no unsupported certification claim")
   - `informationBoundary.*` → membership-specific (internal = substrate-internal references first-class; external = gated)
   - `desiredNextAction` → cell-specific (all four combinations differ)

4. **Schema composition choice (v0.2.0 design call, not yet made):**
   - (a) two discriminator fields on one model — smallest delta
   - (b) split 4 ways — most-typed, biggest migration
   - (c) **split on direction only, keep membership as a field** — direction is where *schema fields themselves* differ (correctionsChannel inward-only, prohibitedPublicClaims outward-only); membership mostly affects values not presence. Direction earns its type-cost; membership doesn't. Recommended.

5. **Don't conflate with existing axes.** The audience schema already has:
   - `composition: collective | individual` — *one or many people*
   - `projectedVoice.mode` — *grammatical addressing*
   These are independent of direction and membership. Four orthogonal axes total.

6. **Lifecycle implication (possible Read B of operator statement):** if "upgrade between internal vs external" meant *transitions* not *axis*, the substrate would need a separate `AudienceMembershipTransition` event type (external collaborator → internal commissioned; internal contributor → external alum). This memory captures the axis reading (Read A); if operator confirms Read B, write a sibling memory for the transition mechanism.

## Related

- [[feedback_audience-direction-axis]] — first axis (inward/outward); this memory adds the second
- [[feedback_adversarial-audience-the-entity]] — bottom-right cell exemplar (outward + external + adversarial)
- [[feedback_audience-projection-pattern]] — AudienceProfileStack still applies; stacks can now mix cells (e.g. a surface with both outward-external + outward-internal audiences)
- [[feedback_content-lives-in-its-owners-home]] — `substrate/audiences/<slug>/` placement unchanged; both axes orthogonal to placement
