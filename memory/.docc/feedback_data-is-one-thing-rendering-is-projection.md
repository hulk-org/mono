---
name: data-is-one-thing-rendering-is-projection
description: "Substrate doctrine in its sharpest form: the data is ONE thing, the webpage / app / view / export is a PROJECTION of that data. Storage and rendering are separate concerns. Storage owns truth; renderings are lenses."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**The data is one thing. The webpage is a PROJECTION of that data.**

This is the substrate's unifying principle for storage-vs-rendering. It applies to any case where typed records get displayed, served, exported, or otherwise consumed:

- **Storage** (kura collections, vaults, typed records) holds the canonical truth.
- **Rendering** (websites, apps, dashboards, exports, generated docs, terminal output) is a projection — a function that walks the storage and emits a view.
- The same storage can support many projections; the same projection can swap storage backends.
- Storage does not depend on rendering. Rendering depends entirely on storage.

## What follows from this

1. **One source of truth.** A piece of content exists at exactly one canonical path. Sites, apps, exports, and other consumers READ from that path; none of them own a copy.

2. **Many lenses are normal.** A typed kura collection can be rendered as a website, an internal dashboard, a JSON export for an external collaborator, a static gh-pages site, a printable PDF — all from the same storage, all without forking the data.

3. **Adding a projection is cheap.** Building a new view doesn't require restructuring the data. It's just another lens. The substrate's marginal cost is new lenses, not new data ([[insights/lens-apps-substrate-pattern-2026-05-18]]).

4. **Storage tier ≠ projection tier.** Storage might be a `collection` (atemporal set); a projection might present it as a timeline view if it has date-anchored items. The storage tier doesn't dictate the projection shape.

5. **Renderers are interchangeable.** The site's HTML+JS doesn't care WHERE the data comes from, only that the projection layer hands it a known shape. Swapping the data backend (e.g., one big JSON catalog → walked kura tree) leaves the renderer untouched.

## Anti-pattern: data-owned-by-renderer

Many web tooling stacks default to "this app's data lives inside this app." That collapses storage and rendering into one thing. The price is paid later when:

- You want a second view of the same data → you fork the data
- You change the canonical data → you have to remember to update copies in every renderer
- You ask "what's the real source of truth?" and the answer is "depends on which app you trust"

The substrate explicitly rejects this. **Sites/apps don't own data. They project it.**

## Application to rismay.me

Current state (2026-05-26):
- `data/rismay-axis-catalog.json` — the site's local data
- `data/axis-site-projection.json` — a projection the renderer consumes
- The catalog IS the source of truth, lives inside the site

Target state:
- `operators/rismay/public/universal/kura/collections/<axis-slug>/` — the canonical kura storage
- A build step walks kura → emits `data/axis-site-projection.json`
- The renderer (HTML+JS) reads the projection, unchanged
- The local catalog goes away; kura becomes the truth

## Application beyond rismay.me

This rule applies to every substrate consumer of typed records:

- agent identity / agenda / chronicle / organism → kura-shaped storage + projections (docs, profile renders, audit reports)
- digikoma-prove TestRunReport → typed storage in the receipt ledger + projections (CI reports, dashboards, summary emails)
- Substrate roster → kura collection of commissioned-home records + projections (`roster list`, `roster analyze`, `roster suggest` are all projections on the same data)
- A future investors-app, partner-view, archival export → all projections on kura storage

## How to apply

When designing a new substrate consumer (site, app, dashboard, export, terminal view):

1. Identify the data it consumes
2. Locate (or create) the canonical kura storage for that data
3. Build the consumer as a *projection layer* — a function that walks kura + emits the view shape
4. Do NOT let the consumer own the data
5. If the data doesn't exist canonically yet, create it in kura FIRST, then build the projection

When refactoring an existing consumer:

1. Find what data it currently owns
2. Migrate that data to kura
3. Replace the owned data with a projection layer that re-emits it
4. Delete the local copy

## History

Operator-stated 2026-05-26 after the rismay.me kura-migration discussion crystallized:
*"so the data is one thing and the webpage is a PROJECTION of that data. so that's the key here."*

This distills the lens-apps doctrine into its most general, most quotable form — applicable to anything that renders typed substrate data, not just substrate apps specifically.

## Related

- [[insights/lens-apps-substrate-pattern-2026-05-18]] — the app-specific version of this principle (apps own perspectives, not data)
- [[feedback_kura-public-vs-private-placement]] — public kura is what website-projections read from
- [[feedback_kura-tier-axis-definitions]] — storage tier (collection/series/timeline) is independent of projection shape
- [[feedback_definitions-are-json-not-markdown]] — typed JSON is the canonical storage; markdown rendering is one projection
