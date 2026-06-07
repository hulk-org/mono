---
name: audience-is-who-not-channel-shape
description: "Audience = WHO an agent speaks to. Bidirectionality is a surface property, not an audience property. The operator is an audience. Supersedes the inward/outward and scene-partner framings."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Audience = WHO an agent is speaking to.** Operator-stated 2026-05-30 (CLIA session, fourth turn in the audience-ontology refinement loop): *"audience really does speak about 'who you are speaking to' i feel like we have to focus on that. it's WHO the agent is speaking to."*

**Supersedes:** [[feedback_audience-is-outward-only-scene-partner-is-the-inward-category]] (which over-corrected by demoting audience out of the operator's case) AND the residual inward/outward framing from [[feedback_audience-direction-axis]].

**Why:** Across four turns of refinement, the substrate moved through three positions before landing here:

1. **Turn 1 (wrong):** operator-as-inward-audience-with-direction-axis. Bolted inward/outward onto audience records.
2. **Turn 2 (operator pushback):** *"operator audience packet feels weird; the new inward outward needs to be fixed."*
3. **Turn 3 (over-correction):** I read the pushback as "audience is wrong for operator" and proposed a separate `scene-partners/` category for bidirectional cases.
4. **Turn 4 (this correction):** operator clarifies — the inward/outward *bolt-on* was what felt weird, not the word "audience." Audience IS right; it means *addressee*; bidirectionality belongs on the *surface*, not the audience.

The deeper lesson: **audience = WHO. Period.** The operator, the-entity, public-visitor, an investor, another agent receiving a handoff — all audiences, because all are addressees of agent output. The bidirectional-vs-one-way property belongs to the *surface that addresses the audience*, not to the audience identity itself. This is the [[feedback_data-is-one-thing-rendering-is-projection]] pattern applied: audience identity = data (stable, one source of truth); addressing mode = projection (varies per surface).

The same person (the operator) is addressed in-session (bidirectional, live-correct-able), in a post-session report (one-way), in a deliverable doc (one-way), in a Slack reply (live). All four are *the same audience*; the *surfaces differ*.

**Correct ontology:**

| Axis (about WHO) | Values | What it discriminates |
|---|---|---|
| **composition** | individual / collective | one person vs many |
| **membership** | internal / external | substrate-member vs not |
| **relation** | commissioning-party / peer / end-user / reviewer / adversary / collaborator | role in the substrate's work |
| **addressing-mode** *(maybe — needs operator confirmation)* | named-and-direct / spoken-about / not-addressed | grammatical stance the agent takes |

**Inward/outward is NOT an axis on audiences.** Bidirectionality is a surface property. Don't put it on the audience record.

**How to apply:**

1. **The operator's home is `substrate/audiences/rismay/`** — same tier as the-entity, public-visitor, etc. No separate `scene-partners/` or `interlocutors/` directory. Those terms can still be useful descriptive words in prose, but they are NOT a separate file-system category.

2. **Audience schema additions needed (v0.1.1 — small delta, not v0.2.0 rework):**
   - Add `"individual"` as a valid value for `composition` (currently both existing records are `"collective"`)
   - Confirm `membership: internal | external` as a typed field (was missing; both existing records are external by accident-of-history)
   - Do NOT add `direction`, `correctionsChannel`, or any inward/outward field. Those belong to surfaces, not audiences.

3. **Surfaces (separate type, separate concern) are where bidirectionality lives:**
   - In-session turn = surface with bidirectional addressing
   - Post-session report = surface with one-way addressing
   - README = surface with one-way addressing
   - Slack reply = surface with bidirectional addressing
   Surfaces reference audiences; audiences don't carry surface properties.

4. **5-question interview from [[feedback_audience-direction-axis]] still applies** for filling rismay's audience record — but now without the "inward vs outward" qualifier. The questions become:
   - `projectedVoice.copyRule` — one-sentence rule for addressing the operator
   - `caresAbout` — three things the operator most needs to see
   - `trustChecks.mustSee` — discipline an agent must demonstrate
   - `informationBoundary.prohibitedClaims` — what an agent must never say to the operator
   - `desiredNextAction` — what the operator should be holding when the addressing ends

5. **The supersession-chain itself is doctrine.** Future-me reading this should see: *the substrate corrected itself twice across four turns by listening to the operator's "this feels weird" signal and following it past two intermediate framings*. The lesson isn't just the final position — it's that **drafting + operator-correction + re-drafting** is the substrate's reliable refinement mechanism. Don't shortcut it by guessing the final position from a single turn's evidence.

6. **Memory shape for self-correcting loops:** when an ontology refinement supersedes a prior position, write a NEW memory file that names the supersession explicitly. Don't edit the prior memory in place — leaving the supersession-chain visible is more useful than collapsing it into a single confident-sounding final statement.

## Open

- Operator-confirmation on whether `addressing-mode` should be a field on the audience or on the surface (current bet: surface, but could be audience-default-with-surface-override)
- Whether `relation` is a single enum or a multi-tag list (an audience could be both "commissioning-party" AND "peer" in different contexts)
- Naming a sibling **`surfaces/`** owner-tier in `substrate/` for where addressing-mode lives — currently surfaces aren't typed top-level objects

## Related (and superseded)

- [[feedback_audience-direction-axis]] — SUPERSEDED; inward/outward isn't an axis on audiences
- [[feedback_audience-internal-vs-external-axis]] — PARTIALLY superseded; internal/external survives as `membership`, but it's not paired with inward/outward
- [[feedback_audience-is-outward-only-scene-partner-is-the-inward-category]] — SUPERSEDED; over-correction; scene-partners is NOT a separate file-system category
- [[feedback_adversarial-audience-the-entity]] — STILL CORRECT; the-entity is an audience (membership: external; relation: adversary)
- [[feedback_audience-projection-pattern]] — STILL CORRECT; AudienceProfileStack is how surfaces compose multiple audiences
- [[feedback_data-is-one-thing-rendering-is-projection]] — the deep pattern that makes this correction coherent: audience = data; addressing surface = projection
- [[feedback_content-lives-in-its-owners-home]] — `substrate/audiences/<slug>/` placement confirmed; no new top-level tier needed
