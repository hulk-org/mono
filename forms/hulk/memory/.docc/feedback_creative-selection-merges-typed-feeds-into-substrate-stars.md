---
name: creative-selection-merges-typed-feeds-into-substrate-stars
description: "Founder-stated 2026-06-05 doctrine: substrate-typed creative-selection ingests from typed feeds (Safari ALL styles + GitHub stars + site-captures + manual) into a typed substrate-star primitive (SubstrateStarredSiteModel — GitHub-stars-shaped, persistently stored, tagged, optionally backed by SiteCaptureModel). Multiple substrate-stars merge into typed CreativeSelectionCandidatePoolModel for the creative-selection-runner role's verdict pass. 5 typed schema families landed this turn."
metadata:
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05):**

> all safari bookmark styles right? and we want to have schema and then we want to have the ability to capture the sites! and then store them like github stars. these two sets are eventually going to be merged in some type of creative selection sets.

## Rule

Substrate creative-selection ingests candidates from MULTIPLE typed feeds and merges them into typed pools for the runner role's verdict pass:

1. **Safari ALL bookmark styles** — typed `SafariBookmarkEntryModel` with `style` enum covering ALL Safari surfaces (bookmarks-bar, bookmarks-menu, favorites, frequently-visited, pinned-tab, cloud-tab, shared-with-you, history, reading-list-via-sibling-model)
2. **Site capture** — typed `SiteCaptureModel` for capturing actual site CONTENT (HTML, readable text, screenshot, PDF, full archive); separable from bookmarking — operator can capture any URL
3. **GitHub stars** — typed `GitHubStarEntryModel` + `GitHubStarsSnapshotModel` ingested via REST/GraphQL/export
4. **Substrate-typed stars** — typed `SubstrateStarredSiteModel` — the UNIFIED typed-star primitive collapsing Safari-any-style + GitHub + manual + site-capture origins into one substrate-canonical persistent marker. GitHub-stars-shaped (URL + starred-at + tags + metadata + optional SiteCaptureRef for content).
5. **Creative-selection pool** — typed `CreativeSelectionCandidatePoolModel` — the merged pool consuming multiple typed feed sources via typed `sourceKind` enum + `feedRef` LinkRef + typed deduplication rule

## Why

The substrate's typed-everything investment requires:
- (a) every Safari surface to be a typed source, not just the obvious ones
- (b) site-capture as a typed substrate primitive (the substrate's archive-of-record for URLs)
- (c) substrate-typed-stars as the unified marker (so 'starred on GitHub' + 'bookmarked in Safari' collapse to one substrate primitive)
- (d) typed pools for the runner role's verdict consumption (so Cull doesn't need to know how to walk every feed source; it consumes typed pools)

GitHub stars are the well-known consumer-internet shape — per [[Arm the fluff]] the substrate adopts the mass-cultural surface for its typed primitive. Same shape (URL + starred-at + tags + metadata), substrate-canonical content underneath.

## How to apply

1. **Cull's SafariBookmarksReader Swift code MUST cover all Safari bookmark styles.** The typed `style` enum is `SafariBookmarkEntryModel.style`; the walker filters Bookmarks.plist containers by style and emits one entry per visited URL.
2. **Site-capture is a NEW typed primitive — not bundled with bookmarks.** When the founder wants 'capture this site' that's a SiteCaptureModel emission, not a bookmark addition. Site-captures can be triggered from any origin (substrate-star, Safari bookmark walk, GitHub star walk, manual operator action, RSS feed).
3. **SubstrateStarredSite is the persistent registry.** Per-feed snapshots are ingest records (SafariBookmarksSnapshot + GitHubStarsSnapshot are point-in-time captures). Substrate-stars persist across snapshots and aggregate `originSourceRefs[]` so the same URL starred via multiple feeds carries the union of provenance.
4. **CreativeSelectionCandidatePoolModel is the runner's input.** The pool's `feedSources[]` declares the typed feed snapshots merged; `deduplicationRule` is typed (`url-exact` / `url-normalized` / `no-deduplication` / `operator-curated`); the pool's `candidates[]` is the merged operand for verdict pass.
5. **Cull v0.2 scope adds these typed surfaces** — author Cull's design-truth-packet to scope ingest from all Safari styles + GitHub stars + manual; render typed CreativeSelectionCandidatePoolModel as central content; emit typed CreativeSelectionVerdictModel per candidate; emit typed CreativeSelectionDecisionRecordModel for downstream substrate consumers.

## Typed substrate-canonical records (landed this turn)

This memory entry POINTS AT:

- **AxiomModel** at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/creative-selection-merges-typed-feeds-into-substrate-stars.axiom.su.json`
- **safari-bookmarks-schemas v0.1.0** (EXPANDED) — SafariBookmarkEntryModel.style enum now covers ALL Safari bookmark styles
- **site-capture-schemas v0.1.0** (NEW) — SiteCaptureModel + SiteCaptureBatchModel
- **github-stars-vault-schemas v0.2.0** (EXISTING — DO NOT DUPLICATE) at `schema-universal/.../domain/creative-selection/schema-families/github-stars-vault-schemas/v0.2.0/` — 7 typed schemas: github-stars + github-repositories + github-stars-dashboard + github-stars-radar + github-star-cards + github-star-health + github-star-link-audit. Substrate-stars + creative-selection pools COMPOSE AGAINST this family. (Initial attempt to author a new github-stars-schemas v0.1.0 at domain/platforms/ was caught as a DUPLICATE per [[Audit schema-universal for existing typed contracts before authoring new ones]] and REMOVED.)
- **substrate-starred-site-schemas v0.1.0** (NEW) — SubstrateStarredSiteModel (the unified typed-star)
- **creative-selection-candidate-schemas v0.1.0** (EXTENDED) — added CreativeSelectionCandidatePoolModel

Step 3.5 validation: typed AxiomModel conforms to `axiom-schemas v0.1.0` JSON Schema; required fields present; LinkRefs conform to `link-ref-schemas v0.3.0`.

## Substrate-architecture-evolution gaps surfaced

- Substrate-stars need a persistent home — substrate-shared kura collection at `substrate-starred-sites` tier (operator-private). Bead-tracked.
- Site-capture execution backend — typed `site-capture-action` primitive that triggers HTML fetch / Reader-mode extraction / screenshot / PDF / Wayback save. Bead-tracked.
- GitHub stars ingest backend — typed CLI / digikoma that walks `GET /users/{user}/starred` (with `Accept: application/vnd.github.v3.star+json` for `starred_at`) and emits typed `GitHubStarsSnapshotModel`. Bead-tracked.
- Cull v0.2 scope expansion — design-truth-packet update to add CUJ for all Safari styles + GitHub stars + pool authoring + verdict rendering. Bead-tracked.

## Composes with

- [[creative-selection-is-two-layer]] — parent axiom; this axiom names the BOTTOM-layer's substrate-determinative ingest primitives
- [[creative-selection-patterns-specialize-by-decision-type]] — sibling; child patterns consume pools
- [[data-is-one-thing-rendering-is-projection]] — typed feed snapshots are data; substrate-stars and pools are projections
- [[All schemas live in schema-universal, not in the consuming collective]]
- [[Arm the fluff]] — substrate-stars adopt the GitHub-stars consumer surface as the typed primitive shape
- [[treat-operator-as-founder-finished-products-only]] — substrate-stars + pools are typed surfaces the founder sees in the Launch Review app / Cull app, not chat narration
- [[launch-review-renders-as-app-with-go-button]] — sibling pattern; Cull renders typed pools, Launch Review renders typed launch-review-packets
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — the 5 typed schema families ARE the typed records this memory supports
