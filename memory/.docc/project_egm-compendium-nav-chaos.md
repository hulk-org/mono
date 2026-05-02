---
name: EGM Compendium navigation needs standardization
description: navigation across the EGM Compendium app's detail pages is inconsistent ("chaotic"); standardization sweep is open work
type: project
originSessionId: a0cdddaa-f001-4f3b-a3f8-28aa502f7ad6
---
The EGM Compendium app has detail pages for several entity types (Game / Magazine Asset / Developer / Genre / Era / Ranking-list) but the navigation surfaces — section ordering, header treatment, back/up affordances, cross-links — are inconsistent across them.

**Why:** rismay flagged this on 2026-04-30 while looking at the Super Metroid detail page. Symptoms visible in that screenshot:
- No top-level header bar / no breadcrumb / no clearly-rendered back-affordance.
- Hero image carries editorial layout (rank badge, magazine-styled caption) but the wrapper page repeats the same text as a separate description block (OCR-quality, garbled).
- Ranking is buried as footer metadata while the magazine treats it as hero.
- "Magazine Asset" sub-header, page reference, and era tag appear in different positions across detail types (no consistent skeleton).

**How to apply:** when working on the EGM Compendium app, treat detail-page nav as a coherent design surface, not per-screen ad-hoc. Pick a single skeleton (header + hero + identity stripe + body + cross-links) and render every entity type through it. Rank/score is hero. Magazine page numbers, era tags, developer/genre are cross-link pills, not unstyled text labels. Description blocks should never duplicate text already legible in the hero image.
