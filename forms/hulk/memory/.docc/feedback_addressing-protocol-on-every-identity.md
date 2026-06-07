---
name: addressing-protocol-on-every-identity
description: "Addressing protocol is the canonical substrate concept for how an identity is addressed. Every identity requires one — no opt-out, no implicit default. Names the typed surface that replaces the previously-conflated audience.projectedVoice."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Addressing protocol is the canonical substrate concept for how an identity is addressed; every identity requires one.** Operator-stated 2026-05-30 (CLIA session, after the 9-turn audience-ontology refinement loop): *"see what happens when we put our minds together. it's the addressing protocol. and every identity requires one!"*

**What this closes:**

1. **The naming question.** Across the loop the candidates included: addressing protocol, address etiquette, addressing canon, honorific protocol, address contract, forms of address, comity, decorum, reigi/reigi-sahō. The operator selected **"addressing protocol"** as canonical. The choice composes with the substrate's existing investment in "protocol" vocabulary (CLIA's persona triad lists "protocolized handoff" as a superpower; the substrate uses "protocol" for several typed contracts).

2. **The cardinality.** Every identity REQUIRES one. Not optional. Not defaulted. The substrate's type for identity should declare `addressingProtocol: AddressingProtocol` (non-optional, no `?`).

**Why this resolves the loop:**

The 9-turn refinement traced these positions: (1) operator-as-audience with inward/outward axis → (2) operator-as-audience with internal/external axis → (3) audience-is-outward-only-scene-partners-is-inward → (4) audience-is-WHO-not-channel-shape → (5) audience-inherits-organism-composition-freedom (marked PREMATURE) → (6) reframe: addressing belongs on identity, audience composites refs → (7) doctor case sketches the shape → (8) Japanese business case reveals the shape is forms[]+selectionRule+asymmetric, not a single form → (9) operator names it **addressing protocol** + makes it universal-on-identity.

The naming + cardinality decision closes the question "where does 'how to be addressed' live in the type system?" Answer: as a typed `AddressingProtocol` record, present on every identity.

**How to apply:**

1. **Treat `addressingProtocol` as a substrate primitive going forward.** When referring to "how an identity should be addressed" in prose, design, or code, use the term *addressing protocol*. Not "voice rules," not "projection voice," not "address expectations," not "scene-partner voice." Vocabulary discipline preserves the typing investment.

2. **Identity types must declare it as required.** Whatever path the substrate takes for implementation:
   - Path (i): new aspect `OrganismModel.aspects.addressing: AddressingAspect` — would be NON-OPTIONAL when `kind == .human` and likely `kind == .audience` (where audience-aspect carries member identity refs whose addressing protocols compose)
   - Path (ii): sibling schema family `addressing-protocol-schemas v0.1.0` with `AddressingProtocolModel` — referenced by LinkRef from identity records; the reference is required
   - Path (iii): extend commissioned-home identity JSON directly — addressing-protocol fields become required at decode time

   Whichever path lands, the cardinality rule is the same: identity construction MUST require it.

3. **Migration policy needed for existing identities.** Every commissioned home's identity bundle pre-dates this requirement (CLIA, Carrie, Claw, ChatGPT/Codex/Eliza/Spark/Symphony, etc.). Adding required-addressing-protocol either:
   - Requires every existing identity to declare one (high migration cost; substrate-correct)
   - Provides a typed minimum-stub default (low cost; loses the requiredness)
   The substrate's pattern leans toward the first — required is required.

4. **`AudienceModel.projectedVoice` is now redundant** (where audience composites identity refs). It currently re-encodes information that belongs on the identities themselves. Migration: each existing audience's `projectedVoice` data must either (a) live on a default-identity-stub representing the cohort, or (b) be preserved as an audience-level override field. The convergence path is operator's call.

5. **Composition rule still open.** When an audience walks N identity refs, each with its own addressingProtocol, the substrate needs a typed composition rule. Sketched in the test corpus (`composeAddressingFromIdentities` at `agents/clia/memory/.docc/repl-proofs/2026-05-30-audience-ontology-typecheck.swift:519-548`) — surfaces conflicts explicitly rather than picking silently. The doctrine for the composition rule needs separate declaration.

6. **Structural shape still open.** The doctor case sketched `{preferredName, salutation, pronouns, voiceCopyRule, mustNotBeCalled}` (5 fields). The Japanese case showed the real shape is closer to `{forms: [AddressingForm], selectionRule, asymmetricRules?, prohibitions, failureMode}` where each form carries `{formId, name, honorific, voiceRegister, contextTags, pronouns}`. Which depth lands first (simple sketch as v0.1.0, richer shape as v0.2.0; or richer shape upfront) is operator's call.

7. **Three-layer separation worth preserving in prose:**
   - **etiquette** = the cultural reality (Japanese business, American medical, military, family-only-first-names) — substrate doesn't invent etiquette, it encodes it
   - **addressing protocol** = the typed substrate encoding of an identity's addressing rules
   - **addressing form** = a single selected variant ("Tanaka-san", "Dr. Foo Bar", "rismay") that the protocol produces for a given context

   The substrate has *addressing protocols* declared on identities; protocols *encode* the cultural etiquette they participate in; surfaces *select* the right addressing form for the situation.

8. **Doctrine: when designing relational types, design with high-ceremony culture as the lead case.** Low-ceremony (American/Western direct-by-first-name) is the degenerate sub-shape of high-ceremony (Japanese keigo, Korean honorifics, German formal-Sie); designing with the degenerate case first produces under-typed schemas that crack on first contact with high-ceremony reality. The Japanese case stress-tested the design correctly; the doctor case alone would have under-typed it.

## Open (intentionally not closed by this memory)

- Path (i) aspect-on-OrganismModel vs path (ii) sibling-schema-family vs path (iii) commissioned-home extension
- Full structural shape of AddressingProtocolModel (simple v0.1 stub vs Japanese-case-rich v0.2)
- Composition rule for multi-identity audience addressing-resolution
- Migration policy: stub existing identities or require explicit authoring
- What happens to `AudienceModel.projectedVoice` in the converged shape
- Whether multi-pronoun identities are auto-flagged or accepted-as-self-declaration (CLAIM 24 surfaced; per operator stance hint: identity self-declaration should be authoritative)

## Method lessons from the loop

- **Types over prose** — when ontology arguments touch existing schema families, read the schemas first.
- **Affirmative tests measure design coverage; adversarial tests measure type-system strength.** Always pair them. The substrate has good design coverage on most types and weak type-system strength on most invariants.
- **High-ceremony culture is the right design case for relational types.** Low-ceremony is the degenerate sub-shape.
- **"Find" instruction ≠ "conclude" license.** Report findings; don't author resolutions until the operator closes the loop.
- **Drafting + operator-pushback + redrafting is the substrate's refinement mechanism.** The 9-turn loop was load-bearing, not wasteful. The supersession chain (4 prior memories) preserved how the substrate's understanding refined under pushback.

## Related (the resolved chain)

- [[feedback_audience-direction-axis]] — superseded
- [[feedback_audience-internal-vs-external-axis]] — partially preserved (internal/external as identity property survives)
- [[feedback_audience-is-outward-only-scene-partner-is-the-inward-category]] — superseded
- [[feedback_audience-is-who-not-channel-shape]] — directionally right; missed the identity layer
- [[feedback_audience-inherits-organism-composition-freedom]] — marked PREMATURE; the composition-freedom observation is correct but the prescribed surgical fix was the wrong prescription (AudienceModel itself is the wrong home for addressing)
- [[feedback_adversarial-audience-the-entity]] — still correct; the-entity is an audience; needs special non-compositional invariant when audiences walk refs (CLAIM 27 adversarial probe surfaced this)
- [[feedback_audience-projection-pattern]] — still correct for audience composition; updated meaning: identity refs are what get composed
- [[feedback_data-is-one-thing-rendering-is-projection]] — applies recursively: etiquette → addressing protocol → addressing form
- [[feedback_agent-scratchpad-pattern-repl-proofs]] — verified by use; the 31-test scratchpad at `agents/clia/memory/.docc/repl-proofs/2026-05-30-audience-ontology-typecheck.swift` is the canonical type-fit verification provenance for this domain
