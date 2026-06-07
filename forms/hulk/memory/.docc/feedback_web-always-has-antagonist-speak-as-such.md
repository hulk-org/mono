---
name: web-always-has-antagonist-speak-as-such
description: "On the web, an antagonist is ALWAYS present. The substrate's web-copy generation must speak as if the antagonist is in the room — not as if friendly readers are alone. Universal release-gate invariant for public web surfaces."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**On the web, there is always an antagonist; the substrate's voice must speak as such.** Operator-stated 2026-05-30 (CLIA session, turn 12 follow-up):

> *"I want you to be aware that on the web: THERE IS ALWAYS an antagonist and we must speak as such."*

**Composes with (and reinforces):**
- [[feedback_adversarial-audience-the-entity]] — "The Entity is always at stackOrdinal 1 on public surfaces." This memory restates that invariant from the COPY-GENERATION side: not just "the entity must be in the stack," but "the writer must speak as if the entity is reading."
- [[feedback_character-role-antagonist-protagonist-typed]] — the typed `CharacterRole.antagonist` flag is what marks who the antagonist is; THIS memory is about how the substrate's WRITING must respond to that flag being present.
- [[feedback_audience-first-workflow-public-pages]] — "who is our audience?" gate; this memory adds the implicit always-answer-for-web: "the antagonist is one of them, always."

**Why this is a separate piece of doctrine:**

The substrate already had the *invariant* (antagonist present in every public audience). What this memory adds is the *operative consequence for voice*: COPY MUST BE WRITTEN with the antagonist's presence assumed. That's a voice discipline, not just a stack composition rule. Two ways the substrate could fail this:

1. **Audience stack includes the antagonist, but copy is written as if only friendly readers will see it.** The stack is "correct," but the writing is unguarded. Failure mode: incidental leakage, mechanism-revealing prose, roadmap-shaped signal — all the things the entity's `mustNotSee` defends against — because the writer wasn't *thinking* with the antagonist's presence.

2. **Audience stack omits the antagonist entirely on a web surface.** Strict invariant violation — caught at the audience-construction layer.

Failure mode (1) is the more insidious one, and it's the one this memory addresses: the writer/agent generating copy must internalize antagonist-presence as a *default stance*, not as a checkbox.

**How to apply:**

1. **Default stance for ANY web copy:** assume the antagonist is reading. This applies to all of:
   - rismay.me and operator-owned public sites
   - README files (especially substrate-public README)
   - GitHub Pages / provisioned sites under `provisioned/gh-pages/`
   - public blog posts, public docs, public release notes, public dashboards
   - any surface whose `accessBranch == "public"` in the audience-packet schema

2. **Mid-draft self-check question:** "If the entity reads this paragraph, what does she learn?" If the answer includes substrate roadmap, unshipped mechanism, internal architecture, prompt engineering, internal IDs, or cross-page synthesis paths, the paragraph fails the antagonist gate.

3. **Voice posture for web copy:**
   - publish-after-not-before (per Apple "Redmond, Start Your Photocopiers" doctrine in [[feedback_adversarial-audience-the-entity]])
   - results-not-mechanism (show *that* it works, not *how* it works at architecture/prompt level)
   - outcomes-not-roadmaps
   - synthesis-resistant (a fact harmless alone may be exfiltration-grade combined with three other public pages)

4. **Type-system enforcement (proposed; not yet typed):** under the [[feedback_addressing-protocol-architecture-linkref-v03]] architecture, a `LaunchGate.antagonistPresenceVerified` could be added to release-operations-schemas — fires for any surface with `accessBranch == "public"`, requires the resolved AudiencePacket to include at least one identity with `characterRole == .antagonist`. The release-time check would catch failure-mode (2); failure-mode (1) is voice-discipline, not statically checkable.

5. **The substrate's writing actors (audience-aware-copywriter role, agents generating any public copy) MUST carry this doctrine as a foundational stance.** Not "check at the end of the draft" — "internalized from the first sentence." The antagonist's eyes are not an audit step; they are a co-author of the discipline.

6. **Gated surfaces (signed-room, internal kura, agent-handoff packets) are exempt** because the antagonist cannot reach them by definition. The doctrine is web-specific: *public-surface* doctrine, where the antagonist's reach is assumed.

7. **Operator-substrate stance:** this composes with the substrate's broader "warm to people, cold to systems" posture and CLIA's persona-triad rule "pierces euphemism like a comedian and orients like a guide." Speaking-as-if-antagonist-present is not paranoia; it is the rhetorical discipline of public-substrate authorship.

## How this changes the addressing-protocol architecture

Under the addressing-protocol architecture ([[feedback_addressing-protocol-architecture-linkref-v03]]), the antagonist's *addressing* is already typed (the-entity's `AddressingProtocol` declares "never addressed directly"). This memory adds:

- **Every web AudiencePacket must resolve to at least one identity with `characterRole == .antagonist`.** Either explicitly authored (e.g., the-entity included) or refused at construction time. This is a release-gate-shaped invariant on AudiencePacketModel for `accessBranch == "public"`.
- **The substrate's copy-generation surfaces (audience-aware-copywriter, README authoring, site copy authoring) must consume this invariant.** Surfaces that don't enforce it should refuse to generate public copy.

## Still open

- Whether the antagonist-presence check belongs on `AudiencePacketModel.diagnostics` (decode-time refusal for public packets without an antagonist) or on a `LaunchGate.antagonistPresenceVerified` in release-operations-schemas (release-time gate). Probably both: defense in depth.
- Whether the "speak as such" voice discipline belongs in CLIA's persona triad (operator-facing), in an audience-aware-copywriter role profile (copy-actor-facing), or both. Probably both: discipline is universal.
- Whether non-web public surfaces (e.g., printed material, exported PDFs, video transcripts) inherit the always-antagonist invariant. Default assumption: yes — anywhere outside a gated room.

## Related

- [[feedback_adversarial-audience-the-entity]] — the-entity is always at stackOrdinal 1; this memory adds the voice-discipline consequence
- [[feedback_character-role-antagonist-protagonist-typed]] — typed CharacterRole; this memory specifies the OPERATIVE consequence on the web
- [[feedback_release-gate-audience-review]] — existing release gate for audience-stack validity; THIS memory motivates adding `antagonistPresenceVerified` as a sibling LaunchGate case
- [[feedback_audience-first-workflow-public-pages]] — gating workflow; THIS memory adds the always-answer for web
- [[feedback_audience-projection-pattern]] — AudienceProfileStack composition; THIS memory ensures web stacks always include an antagonist
