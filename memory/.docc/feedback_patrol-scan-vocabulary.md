---
name: Patrol/scan vocabulary
description: Digikoma patrol chartered routes (macro-verb) and scan at each station (micro-verb); action is the schema-field name; anatomy is the traversal preset; imprints gated on bookend receipts
type: feedback
originSessionId: d8bf83a5-6455-41dc-86b8-ec518edcee54
---
The canonical vocabulary for digikoma behavior:

- **Patrol** (macro-verb) — the recurring chartered journey. A digikoma is on patrol when a routine owns its recurrence: routine fires → patrol begins → train rolls along the chartered route → digikoma rides → debark + receipt → next routine fire restarts the patrol. A one-shot manual run is a *tour*, not a patrol.
- **Scan** (micro-verb) — the per-station inspection. What the digikoma performs at each stop on its patrol. A scan is bounded, mutation-free in the field-world, and its findings live in the offboarding receipt until the host applies the imprint.
- **Action** — the schema-field name (per `koma-org` `spec.json` and `KomaAction` in core-entity-set v0.9.0 organism-schemas v0.4.0). Catalog values: fetch, clean, mark, trace, validate, index, watch.
- **Anatomy** — the traversal preset (Ant, Hound, Fox, Spider, Owl), composable from algorithms + data structures (queue, stack, heap, adjacency, ring buffer).

**Why:** 2026-04-29 the operator locked the architecture stack: routine charters traversal → factory mints digikoma → conveyor boards them onto a train → digikoma patrols the chartered route → at each station performs a scan → debark with bookend receipts (onboarding + offboarding) → host applies imprint conditional on both stamps. The macro/micro split makes ownership crisp: routines own patrol cadence; digikoma own scan execution. Changing patrol frequency doesn't touch the scan contract; upgrading scan logic doesn't touch routine config.

**How to apply:**
- Use **patrol** when describing the journey-shape ("the banned-aliases digikoma is on patrol of Swift-source stations").
- Use **scan** when describing the per-station act ("at each Swift-source station it scans for `public typealias X = Other.X`").
- Use **action** for the schema-slot/catalog noun.
- Use **anatomy** for traversal presets.
- Imprints on substrate state require both onboarding and offboarding receipts; a digikoma that crashes mid-patrol leaves no debark receipt and produces no imprint — the substrate stays clean and the half-journey trace is itself the evidence for repair.
- Per-patrol budget replenishes between patrols, not between stations (Suikoden rune-charge shape).
