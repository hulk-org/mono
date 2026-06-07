---
name: feedback-schema-universal-is-the-substrates-typed-knowledge-repository
description: "Schema-universal is the substrate's TYPED KNOWLEDGE REPOSITORY — not a schema dump but a structured archive whose directory shape is substrate-canonical. The placement of each schema family within schema-universal carries semantic load: primitives/schema-primitives/ houses typed primitives other schemas reference; system/schema-families/ houses system-domain concrete representations; etc. Misplacing a family degrades the knowledge surface. Operator-attested 2026-06-04 mid-Presense-self-review after I dropped web-destination-schemas in the wrong subtree: \"we have to make sure to keep the right shape of schema universal... it's an amazing place for knowledge.\""
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

Schema-universal is the substrate's **TYPED KNOWLEDGE REPOSITORY**. The directory shape is substrate-canonical and load-bearing — where a schema family lives IS part of what the family MEANS.

**Operator-attested 2026-06-04** (delivered after I split this session's four schema-family contributions across two inconsistent subtrees):

> "we have to make sure to keep the right shape of schema universal... it's an amazing place for knowledge"

**The doctrine in one frame:**

Schema-universal isn't a JSON dump. It's the substrate's typed-knowledge ARCHIVE. Each schema family is a typed atom of substrate knowledge. The directory tree tells future agents HOW the knowledge is organized; where a family lives BROADCASTS what category of knowledge it represents; misplacing a family DEGRADES the navigability of the substrate's most valuable structured asset.

**The shape that must be preserved:**

The substrate-canonical placement convention (observed via existing well-placed families):

| Subtree | What lives there | Example families |
|---|---|---|
| `domain/primitives/schema-primitives/` | **Typed primitives** other schemas reference — LinkRef, KuraSpace, KuraAxis, PublishGatePolicy, PublishAttestation, WebDestination | kura-space-schemas, link-ref-schemas, kura-axis-schemas (this session), publish-attestation-schemas (this session), publish-gate-policy-schemas (this session) |
| `domain/system/schema-families/` | **System-domain concrete representations** — GitHub repos, GitHub stars vaults, github desktop metadata | github-repository-schemas, github-stars-vault-schemas, github-desktop-metadata-schemas |
| `schema-families/<topic>-schemas/` | **Topic-area knowledge families** — audience packets, agency entries, mythos, ideation, persona, ontology | audience-schemas, mythos-schemas, ideation-schemas, dozens more |
| `domain/<verticalized-domain>/<schema-families>/` | **Verticalized schemas** specific to a substrate domain | domain/vault/schema-families/github-stars-vault-schemas, domain/source-control/github/schema-families/* |

**The mistake to never make again:**

I authored four schema families this session. Three (kura-axis-schemas, publish-attestation-schemas, publish-gate-policy-schemas) landed correctly under `domain/primitives/schema-primitives/`. ONE (web-destination-schemas) landed in `domain/system/schema-families/` because I noticed `github-repository-schemas` was there and picked it as the wrong neighbor — github-repository-schemas REPRESENTS a github repo (system-domain concrete), while web-destination-schemas is a TYPED PRIMITIVE OTHER SCHEMAS REFERENCE (URL kind + reachability state). I picked structural similarity at the wrong layer. Per the operator: "these type of things are schema-universal models" + "we have to make sure to keep the right shape."

**The pre-authoring check that prevents this:**

Before placing any new schema family in schema-universal, ASK:
1. **What KIND of knowledge does this family represent?**
   - A typed primitive other schemas will reference → `domain/primitives/schema-primitives/`
   - A concrete representation of a system concept → `domain/system/schema-families/` (or its verticalized cousin like `domain/source-control/github/schema-families/`)
   - A topic-area knowledge family → `schema-families/<topic>-schemas/` at the family-tier root
2. **Walk the existing families in each candidate subtree and identify which neighbor BEST MATCHES the new family's KNOWLEDGE CATEGORY** — not just which neighbor lives in the directory you happened to find first.
3. **If unsure, surface the placement decision to the operator BEFORE writing the schema files.**

**Composes with:**

- [[All schemas live in schema-universal, not in the consuming collective]] — the umbrella discipline this sharpens
- [[Audit schema-universal for existing typed contracts before authoring new ones]] — placement check is part of the audit
- [[common-and-mono-are-the-platform-engineers]] — schema-universal is the platform team's typed-knowledge surface; the agent must honor its shape
- [[substrate-composes-typed-idea-molecules]] — schema-universal is where the substrate's typed atoms live; placement = ontology
- [[Audit, don't eyeball-clone organism files]] — same anti-eyeball-clone discipline applies to schema-family placement
- [[Substrate quantizes Google's organizational Hilbert space onto one machine]] — schema-universal is the substrate-quantized version of Google's central schema/ontology repository

**This session's schema-universal contributions (post-fix):**

All four under `domain/primitives/schema-primitives/`:

1. `kura-axis-schemas` v0.1.0 — KuraAxisModel for owner-home kura-axis meta-descriptors
2. `publish-attestation-schemas` v0.1.0 — PublishAttestationModel for App-signed approval records
3. `publish-gate-policy-schemas` v0.1.0 — PublishGatePolicyModel + GateDecisionModel with chat-attestation-FORBIDDEN enum
4. `web-destination-schemas` v0.1.0 — WebDestinationKind + WebDestinationReachabilityState + WebDestinationModel (MOVED from system/schema-families/ in this fix)
