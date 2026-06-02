---
name: character-role-antagonist-protagonist-typed
description: "Identities carry an optional CharacterRole (antagonist | protagonist). Hard-coded for now; future-extensible. The-entity = antagonist. Substitutes typed check for the resolver's hardcoded the-entity slug special-case."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Identities carry an optional `CharacterRole` typed as `{ protagonist, antagonist }`.** Operator-stated 2026-05-30 (CLIA session, turn 12, after the 64-test scratchpad surfaced that the resolver was hardcoding `the-entity` by slug to preserve its adversarial-stance invariant):

> *"damn... i think we need to hard code antagonist and protagonist for now. we can make it optional. but the entity is for sure an antagonist."*

**What this closes:**

- Antagonist/protagonist becomes **typed substrate doctrine** instead of folklore.
- Hard-coded TWO values for now (`protagonist`, `antagonist`). Future extensible (the enum can grow); operator's "for now" leaves room.
- **Optional** cardinality — `characterRole: CharacterRole?` — three states: protagonist / antagonist / neither (nil).
- The-entity carries `.antagonist` as a concrete data point.
- Substitutes the resolver's hardcoded `if ref.targetSlug == "the-entity"` special-case with a typed `if identity.characterRole == .antagonist` check.

**Where it lives (proposed; subject to operator confirmation):**

On the **identity** layer, not on AddressingProtocol. Antagonist/protagonist is a character-role claim about WHO the identity is; AddressingProtocol stays focused on HOW to address them. Separation of concerns mirrors [[feedback_addressing-protocol-architecture-linkref-v03]]'s split.

**Why the enum, not two booleans:**

`characterRole: CharacterRole?` (enum) over `isProtagonist: Bool?` + `isAntagonist: Bool?` (two flags) because:
- Operator's phrasing ("hard code antagonist and protagonist") reads as TWO NAMED VALUES, which is enum-shaped
- "Both true" is structurally meaningless; the enum makes it unrepresentable
- Future extensibility: adding `.mentor`, `.witness`, `.foil` etc. is one enum case addition vs. proliferating booleans

**How the resolver changes:**

```swift
// BEFORE (turn 11 scratchpad, hardcoded special-case)
if ref.targetSlug == "the-entity" {
  nonComp.append(ref.targetSlug)
  continue
}

// AFTER (turn 12 proposal, typed)
if identity.characterRole == .antagonist {
  nonComp.append(identity.slug)
  continue
}
```

The substrate-doctrine invariant "antagonists are non-compositional with protagonists in any audience" becomes a type-system property instead of a string-equality check in the resolver. Generalizes to any future antagonist (not just the-entity) without resolver-code changes.

**How to apply:**

1. **When sketching identity schemas:** add `characterRole: CharacterRole?` as optional. Default value is `nil` (neither protagonist nor antagonist) — legitimate.

2. **When constructing the-entity's identity record:** `characterRole: .antagonist`. Concrete data point.

3. **When constructing identity records for the operator (rismay), agents (CLIA, Carrie, …), or friendly audience-members:** likely `characterRole: .protagonist`, but operator hasn't enumerated explicit assignments — confirm per identity.

4. **When implementing audience-resolution code:** check `.characterRole == .antagonist` before composing with protagonist refs. Surface the conflict rather than silently composing.

5. **Migration policy:** existing identities default to `nil` (neither). The-entity gets explicit `.antagonist`. Authoring is per-identity; no auto-classification.

6. **Cross-layer consistency:** an identity declaring `.protagonist` should not also carry antagonist-flavored prohibitions in their AddressingProtocol (e.g., "never address directly"). Adversarial probe needed for this.

7. **Doctrine framing:** "antagonist" and "protagonist" are *substrate-defined character roles* drawn from narrative vocabulary. They're not the same as `OrganismKind` (which is about substrate-existence: human/audience/software/organization) or `OrganismComposition` (singular/collective). Three orthogonal type axes on the identity layer:
   - **kind** (what kind of organism)
   - **composition** (one or many)
   - **characterRole** (narrative-role in the substrate's storyworld)

## Still open

- **Field placement** — identity layer is the proposed home; operator confirms?
- **Enum vs two-booleans** — proposed enum; operator confirms?
- **Future extensibility** — operator's "hard code … for now" leaves room for more roles (mentor, witness, foil, etc.); when to widen?
- **Existing identities** — every commissioned agent + operator + audience-member identity needs `characterRole` reviewed (or left nil). Per-identity authoring; no bulk default.
- **Non-compositional semantics** — current proposal: antagonists are flagged-not-composed when in an audience. Should protagonists also have invariants? E.g., a protagonist-only audience can compose freely; a mixed audience always flags?

## Related

- [[feedback_addressing-protocol-architecture-linkref-v03]] — the architecture this extends; characterRole lives on identity, separate from AddressingProtocol
- [[feedback_addressing-protocol-on-every-identity]] — universal-on-identity cardinality (required); characterRole is OPTIONAL on identity (cardinality differs by axis)
- [[feedback_adversarial-audience-the-entity]] — the-entity as adversarial; this memory makes the adversarial-stance TYPED instead of folklore
- [[feedback_agent-scratchpad-pattern-repl-proofs]] — extending the 64-test scratchpad with character-role probes is the next step if operator confirms
- [[feedback_data-is-one-thing-rendering-is-projection]] — applies: characterRole is data; resolver-behavior is projection
