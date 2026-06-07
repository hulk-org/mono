---
name: Filename compound suffix disambiguates overloaded types
description: substrate filenames must encode type-discipline when the bare type word is ambiguous (application = software-app vs applied-to-program); use `<domain>.<type>.json` compound suffix + matching schema kind/family
type: feedback
originSessionId: 22a40768-80ea-4704-8439-570fe3664d99
---
When a substrate type-name is overloaded in plain English, encode the disambiguation IN the filename and IN the schema kind/family — do NOT rely on the directory context or surrounding records to clarify.

**Canonical example:** `application.json` is ambiguous. It could mean:
- An *Application* as in software-app (e.g., `clia-day.app.json` for an iOS/macOS app manifest)
- An *Application* as in applied-to-a-program (e.g., `vc-funding.application.json` for a VC funding submission)

Substrate doctrine: use compound suffix `<domain>.<type>.json`. The first segment names the domain that makes the type concrete, the second segment names the type, then `.json` for serialization. Examples:
- `vc-funding.application.json` (applied-to-a-VC-program event record)
- `vc-funding.application-claim.json` (a load-bearing claim made in such an application)
- `code-swiftly.app.json` (a software application manifest) — different `.app.` suffix entirely

**Schema side mirrors filename side:**
- `sk` (schema kind) is the typed name: `VCFundingApplicationEvent`, not bare `ApplicationEvent`
- `sf` (schema family) names the family: `vc-funding-application-schemas`, not bare `investors-app`
- Schema directory mirrors: `schemas/vc-funding-application/v0.1.0/`, not `schemas/investible-case/`

**Why:** the substrate ships many overlapping domains (apps, applications, identities, claims, threads, beads, beats, etc.) where the same English word lands on different types. Filename + schema-kind ambiguity creates silent collisions when records get moved, indexed, or rendered by tooling that reads the filename to dispatch. Compound suffix makes the dispatch deterministic at the filename level — tooling can route by suffix without parsing path context.

**How to apply:** at the moment you author a record whose bare type-word collides with another live substrate type, stop and add the disambiguating prefix. Apply the same prefix to (1) the file's `<filename>.<type>.json`, (2) every LinkRef's `sk` field that targets that type, (3) the `sf` schema-family field, (4) the schema directory + schema definition filenames. Do NOT defer the rename hoping path context will save you — propagate immediately.

**Heuristic for spotting ambiguity:** if you can complete the sentence "X could mean Y *or* Z" with two substrate-plausible referents, the filename needs a domain prefix. If the bare word has only one substrate referent, the compound suffix is optional.
