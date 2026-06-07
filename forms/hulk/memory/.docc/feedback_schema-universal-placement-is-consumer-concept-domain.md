---
name: schema-universal-placement-is-consumer-concept-domain
description: "Founder-stated 2026-06-05 across 3 successive placement-correction rounds: schema-family placement at schema-universal/domain/<X>/ MUST match the CONSUMING WORKFLOW concept-domain, NOT the data topical-surface. GitHub stars + Safari bookmarks + site-captures + substrate-stars + creative-selection-candidate all consolidated under domain/creative-selection/ (the consuming workflow) — not scattered across domain/platforms/ + domain/source-control/github/ + domain/workflows/ (data topical surfaces). Sharpens [[shape-tier-vs-org-domain]] from 'domain=concept' to specifically 'domain=consumer-concept'."
metadata:
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words across 3 correction rounds (2026-06-05):**

> Round 1: "we need to move these to a more canonical location. especially since vault is not a thing anymore it's kura org"
>
> Round 2: "github-stars-vault-schemas + imessage-vault-schemas — that is not the right domain for those"
>
> Round 3: "we need this to be in creative-selection with the web page bookmarks i think"

3 rounds = 3x-rule confirmed in single session. Each round corrected a placement instinct I'd applied (data-topical-surface naming).

## Rule

When authoring a new typed schema family at `schema-universal/private/universal/domain/<X>/schema-families/<family>/`:

- **Place at `<X>` = CONSUMING WORKFLOW concept-domain**, not at data topical-surface.
- GitHub stars schemas live at `domain/creative-selection/` (consuming workflow = creative-selection candidate ingestion), NOT at `domain/source-control/github/` (data topical surface).
- Safari bookmarks schemas live at `domain/creative-selection/`, NOT at `domain/platforms/`.
- Site-capture schemas live at `domain/creative-selection/`, NOT at `domain/platforms/`.
- Shape-tier primitives (vault-schemas / collection-schemas defining the shape itself) live at `domain/kura/`.

## Why

The substrate's typed-everything investment is wasted if schemas are mis-placed by data topical-surface. Agents looking for "who consumes this typed family" must find it under the consumer-concept-domain. The substrate's existing related axioms ([[shape-tier-vs-org-domain]] + [[Audit schema-universal for existing typed contracts before authoring new ones]] + [[All schemas live in schema-universal, not in the consuming collective]]) name domain=concept + audit-before-author + schemas-live-at-schema-universal — but none of them sharpen specifically that consumer-concept wins over data-topical-surface when they conflict.

This axiom names that.

## How to apply

1. **Before authoring a new schema family, ask: "What WORKFLOW consumes this typed data?"** Not "What software/platform is this data ABOUT?" The answer to the workflow question is the concept-domain placement target.

2. **Resist the data-topical-surface naive instinct.** A Safari schema feels like it belongs at `domain/platforms/` because Safari is an Apple platform. That's the WRONG INSTINCT. Safari bookmarks are typed CREATIVE-SELECTION CANDIDATES; they live with the consuming workflow.

3. **Audit existing `domain/` dirs (`ls schema-universal/private/universal/domain/`) for the consumer-concept BEFORE placing.** If `domain/creative-selection/` exists, use it. If it doesn't, create it — don't co-opt an adjacent topical domain.

4. **When multiple consumer-concepts use the same typed family, place at the most STABLE consumer-concept.** Substrate-starred-site-schemas is used by creative-selection (as candidate ingestion) AND potentially by other future workflows; creative-selection is the most stable consumer this session, so that's the home.

5. **Shape-tier primitives go to `domain/kura/`.** Generic `vault-schemas`, `collection-schemas`, `series-schemas` (defining the shape itself, not a specific data set) belong at `domain/kura/schema-families/` per the kura-shape-tier convention.

6. **Cascade relocation cleanly** per [[breaks-are-good-no-transition-shims]] — no transition typealiases, no legacy path forwards; update consumers as they break in the same commit cycle.

## Topical-surface still has a role — in NAMING and ENUMS, not in DOMAIN PLACEMENT

The topical surface IS legitimate vocabulary for:
- Schema FAMILY NAMES: `safari-bookmarks-schemas`, `github-stars-vault-schemas` — the name names the data-source-platform.
- Schema FIELD ENUMS: `originSourceKind` enum values like `'safari-reading-list'`, `'github-star'`, `'manual'`.
- Schema TITLES + descriptions.

What's wrong is using topical-surface for the parent DIRECTORY placement.

## Typed substrate-canonical record

This memory entry POINTS AT the typed `AxiomModel` at:

`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/schema-universal-placement-is-consumer-concept-domain.axiom.su.json`

Step 3.5 validation: typed against `axiom-schemas v0.1.0` JSON Schema; required fields (AxiomModel + slug + title + statement + obligations + sourceRefs + contextRefs + projectionAnchors) all present; LinkRefs conform to `link-ref-schemas v0.3.0`; discriminator `"AxiomModel": "0.1.0"` present.

## Substrate-architecture-evolution gaps surfaced this /capture

- **typed `schema-family-placement-decision-record-schemas`** — would mechanize the placement-decision audit trail and make placement-correction cycles diagnosable. NEW substrate-architecture-evolution gap. Bead-tracked.
- All 11 prior /capture gaps remain open (typed `Role` schema-family + release-gate-schemas + work-surface-requirement-schemas + receipt-schemas + audience-language-pack-schemas + region-schemas + observation-record-schemas + agent-side-commit-emit-schemas + skill-protocol-tool-reference-schemas + typed-record-validator-cli + executable-workflow-harness).
- This session's gaps that landed FIXED: 4 new typed families authored (safari-bookmarks-schemas + site-capture-schemas + substrate-starred-site-schemas + distribution-lane-waiver-schemas + release-action-schemas), plus apple-platform-launch-readiness-baseline canonical instance. github-stars-schemas v0.1.0 duplicate caught + removed (existing github-stars-vault-schemas v0.2.0 already covered).
- Workflow + Role records for this session HONESTLY BEAD-TRACKED — same dependency gap as prior /capture invocations this session (releaseGateRefs / surfaceRequirements / receiptRefs typed contracts missing).

## Composes with

- [[shape-tier-vs-org-domain]] — parent doctrine; this axiom sharpens domain=concept to specifically domain=consumer-concept
- [[Audit schema-universal for existing typed contracts before authoring new ones]] — sibling; existence audit + this axiom adds placement audit
- [[All schemas live in schema-universal, not in the consuming collective]] — parent; schemas live AT schema-universal + this axiom adds WHERE inside
- [[breaks-are-good-no-transition-shims]] — composes for cascade-cleanup discipline
- [[creative-selection-merges-typed-feeds-into-substrate-stars]] — sibling axiom from same session; creative-selection IS the consumer-concept-domain that pulled Safari + GitHub stars + site-captures + substrate-stars under one umbrella
- [[component-bugs-file-at-component-home-not-consumer]] — related doctrine: placement matters at schema-universal AND at component-home/consumer levels
- [[deferral-is-drift-do-it-now]] — fixed the placement THIS session across 3 successive correction rounds
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — the typed AxiomModel IS the substrate-canonical record this memory points at
