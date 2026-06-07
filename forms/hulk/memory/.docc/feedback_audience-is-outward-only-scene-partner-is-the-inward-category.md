---
name: audience-is-outward-only-scene-partner-is-the-inward-category
description: "Audience is outward-only by definition (one-way, frozen at publish). Inward receivers (operator, agents in live handoff) are a DIFFERENT category — bidirectional scene-partners, not audiences. Supersedes the inward/outward-as-axis framing."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Audience is outward-only by definition.** Operator-stated 2026-05-30 (CLIA session): *"it's also a little weird for the operator to have an 'audience' packet... seems like the new inward outward needs to be fixed."*

**Supersedes:** [[feedback_audience-direction-axis]] and partially [[feedback_audience-internal-vs-external-axis]]. The "inward audience" concept I drafted in those memories was a category mistake — forcing a bidirectional in-session receiver (operator, agents in live handoff) into a model designed for one-way frozen-at-publish receivers.

**Why:** An **audience** in substrate usage is a spectator — someone who *receives* what's published. One-way. Frozen at publish-time. The reader doesn't speak back in the same channel. The operator is none of those things: they're in the room with the agent, they speak back mid-turn in the same channel, they commissioned the agent (upstream cause, not downstream consumer), and per `acting.docc` they are the lead director / supporting actor — not a spectator.

The "inward/outward direction" axis I drafted last turn was actually trying to name a **category boundary**, not a direction. Two different ontological objects, not two orientations of one. Fixing the framing means letting `audiences/` go back to being a clean one-way concept and giving the bidirectional case its own home.

**The substrate-correct ontology:**

| Category | Channel shape | Home | Substrate-existing vocabulary |
|---|---|---|---|
| **audience** | one-way; receiver doesn't reply in the same channel; frozen at publish-time | `substrate/audiences/` (6 records, all genuinely audiences) | already typed |
| **scene-partner** *(working name; operator to confirm)* | bidirectional; counterpart replies in the same channel; live | `substrate/scene-partners/` (or `interlocutors/` / `directors/` / `counterparts/` — operator-named) | `acting.docc` already names director, scene partner, supporting actor, counterpart |

**Internal-vs-external axis still applies** — but as a *field on each category separately*, not as a flat axis crossing them. The 2×2 grid from [[feedback_audience-internal-vs-external-axis]] still holds; reading down the rows now means *switching ontological category*, not *flipping a field*:

|                    | **internal** (substrate member)        | **external** (not substrate member)              |
|--------------------|----------------------------------------|---------------------------------------------------|
| **scene-partner** (bidirectional) | rismay; agent ↔ agent handoff | live external collaborator                       |
| **audience** (one-way)            | substrate-internal kura readers       | rismay.me / README / the-entity-defended surfaces |

**How to apply:**

1. **Don't put the operator under `audiences/`.** Wait for the operator to name the bidirectional category, then home them there. Working name: `substrate/scene-partners/rismay/`.

2. **Audience schema does NOT need a `direction` field or `correctionsChannel` field.** Both were proposed under the wrong premise. The audience schema stays as it is for one-way readers; the new scene-partner schema is what carries bidirectionality + correctionsChannel + mid-turn-update semantics.

3. **`audiences/the-entity/` etc. unchanged.** The 6 existing audience records are all genuinely audiences (one-way, frozen). No migration required for them. Only the *would-have-been-inward-audience-records* never existed and never should — they should land in `scene-partners/` instead.

4. **Shared fields, different models.** Both categories share things like `caresAbout`, `mustNotSee`, `projectedVoice.copyRule`, `trustChecks` — but the schemas should be siblings (sharing a base model in `audience-schemas`), not the same model with a discriminator. Per [[feedback_audience-internal-vs-external-axis]]'s schema-composition option (c)-or-variant: *the channel-shape boundary is where types should split*, not where fields should branch.

5. **Acting.docc is the canonical vocabulary source for the inward category.** When the operator picks a name, prefer terms already invested in `acting.docc` (director, scene partner, supporting actor) over generic terms (interlocutor, counterpart). The substrate has paid the doctrine cost to make those terms load-bearing; reuse it.

6. **The recovery shape matters:** the right move when an introspection draft turns out to be the wrong category is to *supersede the prior memory in a new memory file*, not edit it in place. Edits leave half-corrected confusion; supersession leaves a legible history of how the substrate refined its own ontology. Future-me reading this should immediately see "audience-direction was a mis-step; scene-partner is the corrected category."

## Open

- Operator hasn't named the bidirectional category yet. Working name `scene-partners` is provisional, drawn from acting.docc.
- Schema work: when the new category is named, the schemas package needs a sibling type (e.g. `SceneParterModel` alongside `AudienceModel`) with shared base fields lifted into a common protocol/struct.
- `claptrap-as-future-mirror.md` and the persona-triad voice rules still need to point at the right home once the new category is named.

## Related

- [[feedback_audience-direction-axis]] — superseded; partially wrong
- [[feedback_audience-internal-vs-external-axis]] — the internal/external axis survives, but applies *within each category*, not as a flat field across one combined model
- [[feedback_adversarial-audience-the-entity]] — still correct; the-entity is genuinely an audience (one-way, frozen, never addressed directly)
- [[feedback_audience-projection-pattern]] — still correct for outward; in-session may use a different composition pattern (sequential turns rather than ordered sum)
- [[feedback_content-lives-in-its-owners-home]] — `substrate/<category>/<slug>/` placement; new top-level category for scene-partners would be an 8th owner-tier or an 8th sibling under `substrate/`
