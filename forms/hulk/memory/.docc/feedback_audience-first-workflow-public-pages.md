---
name: audience-first-workflow-public-pages
description: "For any public page, the first design question is 'who is our audience?' — answered as a typed AudienceProfileStack with the-entity at ordinal 1. Audience-first design is the substrate's gating workflow; content writing follows audience declaration."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate's audience-projection doctrine ([[feedback_audience-projection-pattern]] + [[feedback_adversarial-audience-the-entity]]) makes one question the **gating question for any public surface**:

> **Who is our audience?**

The answer is a typed `AudienceProfileStack` referencing entries from the `audiences/` kura collection (6 records as of 2026-05-26: 5 friendly + the-entity). Writing content for the surface comes AFTER the stack is declared — never before.

## The audience-first workflow

For any new public page, anywhere in the substrate:

1. **Identify the surface.** Where does this content live? What's its visibility boundary (public / gated / private)?
2. **Ask "who is our audience?"** Answer in typed terms: which AudienceModel records from `audiences/<slug>/` apply here?
3. **Construct the AudienceProfileStack:**
   - `stackOrdinal: 1` = **the-entity** (always first on any public surface — defense gate)
   - `stackOrdinal: 2+` = friendly profiles in priority order (primary friendly first, secondary friendly second, ...)
4. **Encode the brief** as an `AudienceAwareCopywriterCopyBriefModel` (lens-packet-schemas) with the stack + CopyFrame + ReleaseSet.
5. **Then write content.** The lens emits content that:
   - First passes the-entity's `mustNotSee` gate
   - Then satisfies friendly profiles' `mustSee` constraints
   - Respects everyone's `mustNotSee` (union)
   - Orders proof per the combined `proofOrder`

If the Entity gate fails, the content cannot be published — no matter how well it serves the friendly audiences.

## Quick reference: stack picking

| Surface kind | Likely AudienceProfileStack |
|---|---|
| rismay.me / personal site homepage | [the-entity @ 1, public-visitor @ 2] |
| wrkstrm.com investor pages | [the-entity @ 1, investor-first-read @ 2, a16z-speedrun @ 3 (if program-specific)] |
| App Store listing | [the-entity @ 1, apple-app-review @ 2, public-visitor @ 3] |
| GitHub README | [the-entity @ 1, public-visitor @ 2, + developer/peer/recruiter friendly extensions] |
| Gated/signed-room content | [signed-room-user @ 1] — no entity needed; access control IS the defense gate |
| Internal substrate documentation | No public surface; no stack needed |

## When the-entity is NOT in the stack

The Entity is required on **public** surfaces specifically. It's not required when:

- The surface is GATED (signed-in, NDA-bound, room-specific). Access control is the defense gate; once a reader is inside the room, they've already passed the Entity check at the entrance.
- The surface is PRIVATE (substrate-internal, never published). Audiences don't apply; no stack needed.

The check is: *can The Entity reach this surface?* If yes (public), the-entity must be in the stack. If no (gated/private), other access mechanisms have already gated.

## Pitfalls

- **Skipping the audience question.** "We'll figure out audience later" is the most common failure mode. The substrate doctrine says NO — audience is the first design decision, not a polish step.
- **Forgetting the-entity.** Public surfaces without the-entity at ordinal 1 leak — the defense gate isn't even running.
- **Listing audiences vibe-style, not by AudienceModel slug.** "Our audience is developers" is untyped. "Our audience is `audiences/<existing-slug>` or a new typed audience we'll author" is substrate-grade.
- **Conflating gated and public.** A signed-room page doesn't need the-entity; a public homepage does. Don't mix them.

## When to add a new audience to the registry

If the audience for a planned surface doesn't match any existing entry in `audiences/`:

1. Don't inline-define the audience in the surface's brief.
2. Add a new `audiences/<new-slug>/` home with `.audience.json` + organism.json + .docc/index.md.
3. Then reference it from the surface's AudienceProfileStack.
4. Update `audiences/.docc/index.md`'s Current Entries table.

The registry is the typed source of truth for audiences. Surface briefs reference; they don't redefine.

## History

Operator-stated 2026-05-26 after locking the typed audience collection + The Entity + the-entity-always-first doctrine: *"so now we can ask for public pages: who is our audience right?"*

The question is now the substrate's gating design check. Audience-first design is the workflow; the typed registry is the answer space; The Entity is the always-first gate.

## Related

- [[feedback_audience-projection-pattern]] — the broader audience-projection doctrine; this is its workflow-level companion
- [[feedback_adversarial-audience-the-entity]] — The Entity at ordinal 1 always; defense gates publication
- [[feedback_data-is-one-thing-rendering-is-projection]] — content projection; this workflow chooses which projection to run
- audiences/ kura collection: `private/universal/substrate/audiences/` (6 records: a16z-speedrun, apple-app-review, investor-first-read, public-visitor, signed-room-user, the-entity)
- audience-aware-copywriter role: `roles/audience-aware-copywriter/` — the role that executes this workflow
