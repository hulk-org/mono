---
name: substrate-agent-ness-does-not-override-partition
description: "When deciding schema-families/ (ours) vs maintainers/<org>/ (theirs) in schema-universal, the criterion is WHO AUTHORED THE TYPED CONTRACT — never WHO RUNS THE FILE. Substrate-agent-ness does not promote a legacy format into the substrate-native partition. Pointer to typed AxiomModel."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 48bb3ae1-1a94-4651-ac23-1a617d8ef0d2
---

In schema-universal partition decisions: if substrate did not author a typed contract from first principles, the schema goes in `domain/<x>/maintainers/<org>/schema-families/` — even when the producing/consuming agent lives at a substrate-native home like `agents/<slug>/forms/<form>/`.

**Why:** Operator caught this 2026-06-04 mid-session with the quote "these are not part of our families...." after my initial draft of `[[maintainers-tier-doctrine]]` included a "Special Case — Substrate Agents With Legacy Config Formats" carve-out. The carve-out was a typed-primitive-bypass disguised as nuance — special-casing residency conflates two orthogonal axes (concept-authorship vs runtime-residency) and produces unstable partitions that drift. The cleaner doctrine has one rule, no exceptions. Confirmed 3x same session: openclaw real-dir migration target chosen as `maintainers/openclaw/`, openclaw-models-config-schemas family placed at `maintainers/openclaw/`, substrate-wide `maintainers/openclaw/` already existing at the outer collective layer confirming operator's prior alignment.

**How to apply:** Before authoring any new schema family, ask "did substrate author this typed contract from first principles?" — NOT "is the producing agent substrate-native?" If substrate didn't author the contract, the schema goes under `maintainers/<org>/schema-families/`, full stop. Reject doctrine drafts that include "special case for substrate agents with legacy formats" carve-outs.

Canonical typed source of truth (read this, not this memory): `[[substrate-agent-ness-does-not-override-partition]]` AxiomModel at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/substrate-agent-ness-does-not-override-partition.axiom.su.json`.

Composes with: `[[do-not-break-domain-driven-design]]` (bounded contexts), `[[content-lives-in-its-owners-home]]` (companion doctrine for runtime-content residency — that one governs CONTENT, this one governs CONCEPT AUTHORSHIP), `[[typed-primitive-bypass-error]]` (special-case carve-outs are a typed-primitive-bypass pattern), `[[maintainers-tier-doctrine]]` (the SOP this axiom is encoded into).
