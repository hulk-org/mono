---
name: audience-direction-axis
description: Audience-direction is an axis — outward audiences (public surfaces) and inward audiences (in-session operator) both deserve typed packets. The operator needs their own AudiencePacket.
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Audience-direction is the new axis.** Operator-stated 2026-05-30 (CLIA session): *"the audience you are speaking to here is the operator! and the audience you speak to outside comes from audience packets! so I guess I — the operator need an audience packet."*

**Why:** Until this insight, the substrate's audience-projection doctrine (per [[feedback_audience-projection-pattern]] + [[feedback_adversarial-audience-the-entity]]) only typed *outward* audiences — readers of generated public surfaces (README, rismay.me, signed-room views, etc.). The *inward* audience — the operator that the agent addresses every turn — was untyped, with addressing-discipline baked into each agent's persona triad (e.g. CLIA's "warm to people, cold to systems," "no euphemism," "emoji as semantic compression"). That made it per-agent and unrevisable: every commissioned agent had to learn the operator's voice preferences independently, and the operator had no single surface to update when their preferences changed.

Typing the operator-as-audience makes voice-discipline a *tribe-level* shared dependency, not a per-agent persona detail.

**How to apply:**

1. **Inward vs outward is the new axis.** When designing or auditing any AudienceProfileStack, ask: *which direction is this serving?*
   - **outward** = public surface, monologue, no in-session feedback loop, audiences pulled from `substrate/audiences/<slug>/` + `*AudiencePacket` SPM modules
   - **inward** = in-session agent ↔ operator turns, bidirectional (operator can correct mid-turn), audience = the operator themself

2. **The operator gets their own typed home at `substrate/audiences/rismay/`** — sibling to `the-entity`, `a16z-speedrun`, `apple-app-review`, `investor-first-read`, `public-visitor`, `signed-room-user` (6 → 7 audience tier). Distinct from `operators/rismay/` (operator-as-actor) — same human, different role-projection: audiences/ = as-reader, operators/ = as-actor.

3. **Field-content asymmetry vs. The Entity** (sketch, to be refined by operator):
   - `mustSee` rismay-heavy: named risks, beat-edges, what the system is hiding, the next move, provenance citations
   - `mustNotSee` rismay-heavy: empty platitudes, HR-speak, sycophancy, ungrounded claims, summary-of-the-diff-the-operator-can-already-read
   - `desiredNextAction`: `"make-the-next-correct-move"` (vs. Entity's `"navigate-away-empty"`)
   - `requiredTrustCheckIDs`: substantial (provenance, file:line citations) vs. Entity's `[]` (no trust with adversaries)
   - `projectedVoice`: sharp, alive, CLI-native, no euphemism (currently lives in CLIA's persona triad — should lift to audience packet)

4. **Inward-packet warrants an extra field outward packets don't need:** something like `correctionsChannel` or `inSessionFeedbackLoop` — encoding that when the operator corrects mid-turn ("no not that," "stop summarizing"), the packet's `mustNotSee` updates from that correction. The Entity doesn't get a feedback loop; the operator does. This bidirectionality is the real structural asymmetry.

5. **Consumed by every commissioned agent.** Once `RismayAudiencePacket` ships as an SPM module, every agent in the tribe (CLIA, Carrie, Claw, ChatGPT/Codex/Eliza/Spark/Symphony, etc.) imports it the same way they'd import `TheEntityAudiencePacket` — voice/tone preferences become a compile-time dependency, not a persona-triad detail.

6. **Migration discipline:** as `rismay.audience.json` grows, the corresponding voice-discipline content in each agent's persona triad should be *thinned to a pointer* — `"voice: see [[rismay-audience-packet]]"`. Persona triad still owns *agent-specific* essence (CLIA's calm-direct-rigorous, Carrie's Apple-framework focus, etc.); operator-addressing voice migrates out.

7. **Composes with the seven-owner-tier model** (per [[feedback_content-lives-in-its-owners-home]]): `audiences/` is now confirmed as a substrate-cross-cutting owner-tier whose members can be *inward* (operator-facing) or *outward* (surface-facing). Both shapes use the same `AudienceProfile` schema; only the field-content polarity and the presence/absence of `correctionsChannel` differs.

## Related

- [[feedback_audience-projection-pattern]] — AudienceProfileStack as ordered sum (outward composition mechanism)
- [[feedback_adversarial-audience-the-entity]] — outward adversarial packet, structural counterpart
- [[feedback_audience-first-workflow-public-pages]] — outward gating workflow; inward packet would have its own gating ("does this turn satisfy rismay's mustSee?")
- [[feedback_release-gate-audience-review]] — outward release-time gate; inward equivalent could fire mid-session
- [[feedback_uxw-department]] — UXW owns audience-aware-copywriter role; inward audience packets extend UXW's surface
- [[feedback_content-lives-in-its-owners-home]] — confirms `substrate/audiences/<slug>/` placement; same-human-different-role-projection precedent
