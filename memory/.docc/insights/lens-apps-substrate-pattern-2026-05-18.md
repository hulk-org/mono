---
name: Lens apps — substrate's app-studio doctrine
description: substrate's app studio is a LENS FACTORY. Each app is a lens on canonical typed data — one truth, many viewers, many lenses. investors.app is the first NAMED-AUDIENCE lens (the investor lens). Generalizes the existing one-truth-many-lenses doctrine (Pa lens in Today app, etc.) into the substrate's foundational app-studio framing — apps don't own data, they own perspectives.
type: insight
originSessionId: <speedrun-submission-2026-05-18>
---

# Lens apps — substrate's app-studio doctrine

## The realization

Rismay's exact phrasing 2026-05-18: *"see... this is a lens app. see the world through a particular lens... interesting. we have to capture this."*

The context: I had just scaffolded `investors.app` with a "two windows" architecture (Our Window for what-we-promised, Their Window for what-they-see). Rismay recognized the deeper structural pattern: **investors.app is a LENS APP** — it lets the operator see the substrate's canonical data through the *investor* perspective specifically.

This generalizes. The substrate's whole app studio is a **lens factory**.

## What this means

- **Substrate apps don't own data.** The canonical data is the vault — typed JSON records, Swift schemas, ordinality tables. Apps just render it.
- **Substrate apps own perspectives.** Each app is a viewer-function: it takes the same canonical data and renders it through one perspective's lens.
- **The lens IS the product.** Two apps with the same underlying data are still different products if their lenses are different — they answer different questions, surface different fields, run different filters.
- **New apps = new lenses, not new data.** Adding a new app to the studio means adding a new perspective on existing canonical data, not duplicating or forking the data.

## The pattern, generalized

```
canonical typed data (vault records, Swift schemas, ordinality tables)
            ↓
       lens function (per app)
            ↓
     rendered surface (UI / report / API response)
```

Each lens is a Swift module that:

1. Knows which canonical records it reads from
2. Knows which fields it surfaces, in what order, grouped how
3. Knows which queries/filters define its perspective
4. Renders to the viewer the data filtered through that lens

## Anchors in existing substrate doctrine

This insight is the **explicit generalization** of three pre-existing substrate doctrine threads:

- **`user_one-truth-many-lenses`** — *"canonical data is singular; the view is a function of who's looking (first product expression: Clia Day Collective view)"*. Rismay already established this principle; lens-apps is the app-studio-level application of it.
- **`user_today-app-real-customer`** — *"Today/clia-day Pa lens is for rismay reading AI end-of-session summaries; 'Pa' is design language not literal customer"*. Pa lens is the substrate's first named lens — it's not the customer, it's the perspective the customer-facing surface renders through.
- **`typed-ontology-vs-identity-politics-2026-05-17`** — the substrate's bet on typed rendering as the structural-strength mechanism. Lens apps are typed-ontology-as-UI: each lens is a typed view function over typed records.

## Existing lenses in the substrate

| Lens | App | Canonical data | Perspective |
|---|---|---|---|
| **Pa lens** | Today (`clia-day`) | session summaries, AI chronicles, beats | end-of-session AI summary read by rismay (Pa = design language, not customer) |
| **Investor lens** | investors.app (scaffold 2026-05-18) | venture-capital vault, typed answer packets, evidence maps, receipts | what we promised (founder sublens) + what they see (partner sublens) |
| **(future)** Director lens | clia-face / sprite-character apps | sprite avatars, character work, genome pipeline | creator-as-director per the Speedrun SD's *"designers and creators become directors"* claim |
| **(future)** Roster lens | roster CLI surface (existing) | commissioned agent homes, identity bundles | who is in the session, what they can do |
| **(future)** Chronicle lens | digikoma-chat-summary (existing) | session transcripts, summaries | session-history reader |

## investors.app as the first NAMED-AUDIENCE lens

The Pa lens is named for a *design archetype* (Pa = fatherly summary reader). The investor lens is named for a *named external audience*. That's a structural step: substrate apps can now declare their lens by naming the audience whose perspective they render.

Future named-audience lenses to anticipate:
- **Journalist lens** — how does the substrate's public surface render to someone Googling the founder?
- **Recruiter lens** — how do my apps + GitHub + LinkedIn look to a hiring manager?
- **Customer lens** — how does the wrkstrm catalog look to a creator considering wrkstrm products?
- **Partner-interview lens** — how does the application look to a partner mid-interview with the founder?
- **Diligence lens** — how does the substrate look to a partner doing 4-hour-deep-dive after the interview?

Each is a Swift module reading the same canonical data, filtered through the named audience's perspective.

## Lens stacking

Lenses compose. **Investor lens × Speedrun-form lens × dark-mode-display lens** = a SwiftUI view that renders the Speedrun-submitted application in dark mode from the investor's perspective. The substrate's typed-everything discipline means lens composition is mechanical: each lens is a function `(CanonicalData) -> RenderedData`, and `lens3 ∘ lens2 ∘ lens1` is just function composition.

## Substrate doctrinal implications

This isn't just an UX framing. It changes how the substrate thinks about app development:

- **Spec lensing first, build second.** Before scaffolding a SwiftUI view, declare the lens: who is the viewer, what perspective do they have, what filters / orderings / surface choices define their lens?
- **Lens registry.** The substrate may eventually maintain a typed catalog of lenses (an ordinality table or LinkRef vault) — each lens with its slug, audience, perspective description, canonical-data sources, and Swift module path.
- **Reusable lens primitives.** Filtering "all submitted applications," sorting by "review-window-deadline," grouping by "application-kind" — these are lens primitives that compose across apps.
- **Lens as deliverable.** Future client work might involve building a custom lens on substrate data (e.g., a custom-VC lens for one specific firm's intake process) without building a whole new app — just a new lens module that composes with the existing investor-lens infrastructure.

## Why this matters for the studio thesis

wrkstrm's Speedrun pitch said: *"a software factory powered by persistent AI personalities — we capture the creator's intent and style, then ship native apps."* The lens-apps doctrine is the *operating principle* behind that claim. The studio doesn't ship new data per app — it ships new lenses. The creator's intent + style + canonical data + AI personalities = a custom lens on shared data, rendered as a native app.

That makes the studio's marginal cost of the next app very different from a traditional studio's: traditional studios duplicate work per app; lens-factory studios compose lenses on shared canonical data, with most work being lens definition + composition rather than new data engineering.

## Capture date

This insight was captured by claude (sonoma session, 2026-05-18, immediately post-Speedrun-submission) at rismay's direction. The Speedrun application itself is the first investor-application data the substrate produced; investors.app is the first lens designed to render that data; this insight is the doctrinal generalization that the substrate's whole app studio operates on the lens pattern.
