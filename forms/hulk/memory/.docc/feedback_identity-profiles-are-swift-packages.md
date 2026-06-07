---
name: identity-profiles-are-swift-packages
description: "Identity profiles are first-class Swift Packages, not JSON files. Each identity ships as an importable SPM module providing typed identity data. Extends the substrate's canonical-data-as-SPM doctrine from shapes to instances."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Identity profiles are first-class Swift Packages, not JSON files.** Operator-stated 2026-05-30 (CLIA session, turn 13, while greenlighting Phase 1 of the addressing-protocol architecture):

> *"new schema family - because these will be different culturally eventually. also, this means that entire identity profiles need to be Swift Packages!"*

**Why this is doctrine-level:**

The substrate already invests in "canonical structured data lives in SwiftPM package surfaces, not ad-hoc files" (per `CLAUDE.md`). That doctrine has historically applied to *schema shapes* (e.g., `audience-schemas v0.1.0` ships AudienceModel as Swift). The operator's turn-13 extension promotes the doctrine to *identity instances*: each identity (rismay, CLIA, Carrie, Claw, the-entity, every commissioned agent, every audience-member identity) is its own importable SPM module providing typed identity data.

This composes with several existing substrate patterns:

- **[[feedback_role-classes-as-files-not-catalog]]** — typed enumerations = one file per item, picked from the filesystem. Identity-as-Package extends this from "one file per item" to "one SPM module per item."
- **[[feedback_form-factor-suffixes-name-homes]]** — `<slug>.<form-factor>/` naming. Identity packages would likely use a form-factor suffix (e.g., `.lib` for an importable library, `.identity` if a new form-factor is coined).
- **[[feedback_addressing-protocol-architecture-linkref-v03]]** — LinkRef v0.3 references identities; under identity-as-Package, the LinkRef resolution can be implemented via SPM module discovery (compile-time) AND/OR JSON fallback (runtime).
- **[[feedback_addressing-protocol-on-every-identity]]** — every identity requires an addressing protocol; the identity package can `import AddressingProtocolSchemas` and supply its protocol as typed Swift data.

**Why "different culturally eventually" reinforces the SPM-package shape:**

Cultural variants (Japanese keigo, Korean honorifics, German formal-Sie, military rank, religious salutation systems) can live as **typed extensions in identity packages**, not as runtime branches in a monolithic addressing-protocol schema. Each identity's package picks the cultural extensions it needs; the schema family stays generic.

**Structural implications (sketch — needs operator confirmation on details):**

```
Layer 1: addressing-protocol-schemas v0.1.0  (Phase 1 — greenlit)
   AddressingProtocolModel, AddressingForm, AsymmetricRule,
   SelectionContext, VoiceRegister, FailureMode

Layer 2: identity-schemas v0.1.0  (Phase 2 — proposed)
   IdentityModel, CharacterRole, ...
   (or extension of OrganismModel — operator decision pending)

Layer 3: per-identity SPM packages  (Phase 2.5 — NEW from turn 13)
   private/universal/substrate/identities/rismay/rismay.identity.lib/
   private/universal/substrate/identities/clia/clia.identity.lib/
   private/universal/substrate/identities/the-entity/the-entity.identity.lib/
   ...
   Each package:
   - imports identity-schemas + addressing-protocol-schemas
   - provides ONE IdentityModel instance + ONE AddressingProtocolModel instance
   - culturally-specific extensions imported as needed
   - exposes the identity via a known module symbol (e.g., `Identity.identity`)
```

**Open design questions (Phase 2+ scope):**

1. **Form-factor suffix for identity packages.** `.lib` (existing form-factor for libraries)? `.identity` (new form-factor coined for this)? Operator decision.
2. **Resolution mechanism.** Under identity-as-Package:
   - (a) Compile-time: consumers depend on identity packages and access typed data
   - (b) Runtime: each identity package ships a Bundle resource JSON; LinkRef resolver loads at runtime
   - (c) Both: compile-time for known/static consumers, runtime for dynamic resolution
   Probably (c) — the substrate has precedent for typed-data-with-runtime-resolution.
3. **Migration of existing commissioned-home identity JSONs.** Today CLIA's identity is `clia@rismay.substrate.identity.json` at `agents/clia/private/universal/identity/`. Under identity-as-Package: lift to `agents/clia/<form-factor>/Sources/CliaIdentity/`? Or keep JSON at the commissioned home + add SPM package as a peer that wraps it?
4. **Naming convention.** `<slug>.identity.lib/`? `<slug>-identity@<org>.lib/`? Per the substrate's existing form-factor naming patterns, `<slug>.identity.lib/` reads cleanly but the `.identity` middle element is novel.
5. **Cardinality.** ~50+ identities exist in the substrate today (every commissioned agent + operators + audience-member cohorts). Authoring 50+ packages is non-trivial; some kind of generator/scaffolder is likely needed.
6. **Audience-member identities.** The 6 existing audiences (the-entity, public-visitor, etc.) — are they collectives of multiple identity packages, or one default-identity per audience that the audience composes from?

**How to apply (in this session and going forward):**

1. **Phase 1 stays narrow.** Author `addressing-protocol-schemas v0.1.0` as planned. Don't yet author identity packages. The schema-shape work proceeds independently of identity-instance work.

2. **Phase 2 expands.** When the identity layer is authored, design BOTH (a) the schema (identity-schemas, where IdentityModel + CharacterRole live) AND (b) the SPM-package pattern (how each identity is housed). They co-evolve.

3. **Reference resolution in the meantime.** Until identity packages exist, the LinkRef-based resolution stays JSON-file-based (current model). Identity-as-Package becomes the canonical form once Phase 2 lands.

4. **When sketching test corpus going forward.** Tests that exercise identity-instances (CharacterRole flag, web-antagonist gate, etc.) should be designed assuming the identity ships as a Swift package — `import RismayIdentity` becomes idiomatic. Mirroring identity locally in test files becomes a Phase-1-only convention.

5. **Substrate doctrine implication.** This is the substrate's broader pattern of "promote data to typed instances" working through. The substrate already did this for schemas (typed shape) and digikomas (typed bounded actors); now it's doing it for identities (typed instances). The next likely candidate is *roles*, *audiences*, *surfaces* — each could become typed-instances-as-packages too. Not commit, just direction.

## Related

- [[feedback_addressing-protocol-architecture-linkref-v03]] — the architecture this extends
- [[feedback_addressing-protocol-on-every-identity]] — identity requires an addressing protocol; this memory adds "identity = Swift Package"
- [[feedback_character-role-antagonist-protagonist-typed]] — CharacterRole lives on identity; under identity-as-Package, it's a typed field of each identity package's IdentityModel
- [[feedback_role-classes-as-files-not-catalog]] — filesystem-picker doctrine; identity-as-Package is the same doctrine scaled to importable modules
- [[feedback_form-factor-suffixes-name-homes]] — naming convention; identity packages need a form-factor (proposed: `.identity.lib` or similar)
- [[feedback_data-is-one-thing-rendering-is-projection]] — applies: identity package = data; consumers (audience packets, copy generators, harness CLIs) = projections
