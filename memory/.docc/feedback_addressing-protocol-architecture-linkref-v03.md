---
name: addressing-protocol-architecture-linkref-v03
description: "Addressing protocol architecture: separate schema family (path ii), referenced from identity profiles via LinkRef v0.3, resolved by audience packets walking identity refs. AudiencePacketModel unchanged."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Addressing-protocol architecture chosen.** Operator-stated 2026-05-30 (CLIA session, turn 10 — concretizing the architecture from [[feedback_addressing-protocol-on-every-identity]]):

> *"so an identity requires and addressing protocol - separate file - link refed v0.3. then when we are writting copy we can take an audience packet which links identity profiles and inside of them: addressing protocols via the link ref 0.3."*

**What this closes:**

| Decision | Value |
|---|---|
| Concept name | `addressing protocol` ([[feedback_addressing-protocol-on-every-identity]]) |
| Cardinality | required on every identity ([[feedback_addressing-protocol-on-every-identity]]) |
| Schema path | **(ii) separate schema family** — NOT an aspect on OrganismModel, NOT inline on commissioned identity JSON |
| Proposed family name | `addressing-protocol-schemas v0.1.0` (conventional substrate naming) |
| Reference mechanism | `LinkRefModel` from `linkref-schemas v0.3.0` (existing substrate primitive) |
| Audience composition path | packet → audience → identity refs → addressing protocols (each link is a LinkRef v0.3) |
| AudiencePacketModel | **unchanged** — confirmed as compiled-projection-for-surface layer |

**The reference chain (canonical):**

```
addressing-protocol-schemas v0.1.0                    ← NEW family
  AddressingProtocolModel
       ↑
       │ LinkRef v0.3 (required, non-optional)
       │
identity profile
  ...existing identity fields
  addressingProtocolRef: LinkRefModel                 ← NEW required field
       ↑
       │ LinkRef v0.3
       │
AudienceModel
  memberIdentityRefs: [LinkRefModel]
       ↑
       │ via audienceRef
       │
AudiencePacketModel                                   ← UNCHANGED
  audienceRef: LinkRefModel
  ...
       ↓
generated copy uses resolved addressing protocols
```

**How to apply:**

1. **When sketching/proposing schema deltas:** create a new schema family at `private/universal/substrate/collectives/schema-universal/private/universal/schema-families/addressing-protocol-schemas/v0.1.0/spm/addressing-protocol-schemas-v000-001-000/` following the conventional substrate layout (`Package.swift`, `sources/<family-name>/AddressingProtocolModel.swift`, `tests/<family-name>-tests/`). Do not embed addressing-protocol fields into existing identity records inline.

2. **When updating identity types:** add `addressingProtocolRef: LinkRefModel` as a **non-optional** field. Required at construction time, required at decode time. This propagates the operator's "every identity requires one" cardinality through the type system.

3. **When implementing copy-generation surfaces:** take an `AudiencePacketModel` as input; resolve via the LinkRef chain (audienceRef → audience.memberIdentityRefs → identity.addressingProtocolRef). Don't synthesize addressing protocols inline; always resolve through the typed refs.

4. **Substrate-primitive discipline:** use existing `LinkRefModel v0.3.0` for the references. Do not invent a new reference type. The substrate's pattern is to reuse existing typed primitives; addressing-protocol references are not special.

5. **Addressing protocols are reused, not duplicated.** One identity → one addressing-protocol record → referenced from many audiences. This is the DRY payoff of putting addressing on identity instead of on audience.

## Still open (intentionally not closed by this memory)

- **Structural shape of `AddressingProtocolModel`** — simple v0.1 stub (preferredName/salutation/pronouns/voiceCopyRule/mustNotBeCalled, 5 fields) or Japanese-case-rich v0.1 (forms[] + selectionRule + asymmetricRules + failureMode + per-form contextTags)
- **Composition rule** — when an audience walks N identities with N addressing protocols, the resolver needs typed logic (conflict surfacing per CLAIM 16, adversarial-stance preservation per CLAIM 27, multi-identity contextual selection)
- **Migration policy** — every commissioned identity (CLIA, Carrie, Claw, ChatGPT/Codex/Eliza/Spark/Symphony, the operators, every audience-member identity) needs an addressing protocol authored. Stub-default or require-explicit?
- **"Identity profile" disambiguation** — substrate has several identity-adjacent types (`OrganismModel` kind=.human, `IdentityResumeModel`, commissioned-home `<slug>@<org>.identity.json`, brand-identity-schemas). Which gains the required `addressingProtocolRef`?
- **`AudienceModel.projectedVoice`** — now redundant under this architecture. Drop in v0.2.0 or migrate the 6 existing audiences' projected-voice data to identity-stubs first?

## Related

- [[feedback_addressing-protocol-on-every-identity]] — names the concept + cardinality; this memory adds the architecture
- [[feedback_audience-inherits-organism-composition-freedom]] — PREMATURE; the composition-constraint observation survives, the prescribed fix is replaced by this architecture
- [[feedback_data-is-one-thing-rendering-is-projection]] — applies: addressing protocol is the data; audience packet is one projection; generated copy is another
- [[feedback_content-lives-in-its-owners-home]] — applies: addressing-protocol records live where their owner identities live; the schema family is universal
- [[feedback_agent-scratchpad-pattern-repl-proofs]] — applies: the 31-test scratchpad at `agents/clia/memory/.docc/repl-proofs/2026-05-30-audience-ontology-typecheck.swift` should be extended with adversarial probes against the LinkRef-resolved architecture
