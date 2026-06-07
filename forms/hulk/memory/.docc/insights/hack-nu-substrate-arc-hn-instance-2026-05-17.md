---
name: hack-nu is rismay's substrate-native Arc→HN instance
description: hack-nu (formerly HackerNews) is the substrate's longest-lived app and the substrate-native instance of PG's Arc→HN dogfood-becomes-product pattern; 4-year arc from wrkstrm's first commit (2022-06-21) to App Store build 984 (2026-05-01); the "reference" relationship to hackernews.mac.app is substrate self-recognition, not arbitrary visual borrowing
type: project
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---

# hack-nu is rismay's substrate-native Arc→HN instance

## The pattern, with three instances

The pattern is **dogfood-becomes-product**: build an engine, use it to build a test-rig app, the test rig graduates to its own product when the engine is good enough. Three documented instances of the same pattern, ~4-year arcs each:

| Engine | Test rig | First commit | Graduated to product |
|---|---|---|---|
| PG's Arc Lisp dialect | HackerNews-the-site | 2006-10-09 (HN item 1) | ~2010, became YC's most consequential product |
| rismay's wrkstrm Swift stack | HackerNews-the-iOS-app (renamed hack-nu in 2025-09) | 2022-06-21 (wrkstrm `3b7c0e784` "Rebuild.") | 2026-05-01, App Store build 984 shipped |
| substrate's scaffold-app-from-web-cli | hackernews.mac.app | 2026-05-17 | TBD — depends on engine maturity |

The middle instance is **load-bearing for substrate doctrine**. PG's case is the cultural reference; the substrate's own case is the freshly-scaffolded demo; rismay's wrkstrm→hack-nu is the actually-completed arc that proves the pattern works in this substrate.

## hack-nu's chronology (verifiable in wrkstrm submodule)

| Date | Commit | Moment |
|---|---|---|
| **2022-06-21** 23:53 PT | `3b7c0e784` "Rebuild." | First commit in wrkstrm. HackerNews is already in the tree. |
| 2022-10-27 19:30 PT | `a6ff108de` | Founding localization. Same commit recorded as "first AI harness" in the localize-founding insight. |
| 2022-11-04 18:14 PT | `7da271e6a` | HackerNews + WatchKit app both exist; first commit mentioning HackerNews by name |
| 2023-12-20 09:00 PT | `dd70ef8da` / `fab11e4ad` | WatchKit bridging headers removed |
| 2024-10-29 19:20 PT | `9dabf4880` | Today widget removed |
| 2024-10-31 13:30 PT | `f41cb005a` | TopStoriesWidgets → HackerNewsWidget rename |
| 2025-07-27 13:56 PT | `fe530da4a` | SafariView wired for article display |
| 2025-08-11 18:31 PT | `ac7765df5` | AGENTS + AGENCY guidelines added |
| **2025-09-25** 10:37 PT | `23308c547` | Restructured + migrated: HackerNews → hack-nu + alphabeta |
| 2026-03-21 05:28 PT | `60f386d15` (in todo3) | Imported into todo3's apps tree |
| **2026-05-01** 07:24 PT | `19700e272` | Shipped build 984 to App Store Connect |
| 2026-05-14 14:48 PT | `ff206a9f2` | wd: App Store shipping pipeline end-to-end against Hello World |
| 2026-05-14 01:55 PT | `9e0924d1c` | Wire Hack NU fastlane vault auth |

## Where it lives now

- Code: `private/universal/substrate/collectives/todo3/private/apple/apps/hack-nu/`
- Founding bundle ID is preserved per `.foundry.json` waiver: *"legacy HackerNews bundle identifier; keep stable for store and user continuity"*
- Architecture is UIKit-first (Cells/Controllers/Models/Services/Utilities under `Shared/`) with a `SwiftUIExp/` layer added incrementally — that hybrid is itself evidence of the 4-year evolution
- The original founding artifacts survive in the source tree: `HackerNews.png`, `HackerNews.psd` (Photoshop original), `AGENCY.md`

## Why this matters for future sessions

- When rismay gestures at hack-nu as a "reference" for any HN-related substrate work, **do not treat it as visual reference** — it is the substrate's founding artifact, self-recognizing across instantiations. Read its git log + AGENCY.md before modeling anything after it.
- The 2022-10-27 founding-localization commit `a6ff108de` is recorded in the localize-founding insight as "first AI harness." That same commit lives ON hack-nu. The substrate's first AI harness ran on hack-nu. Localize + hack-nu share the founding moment.
- "Three instances of the dogfood-becomes-product pattern" is the cleanest substrate-doctrine framing yet for the test-rig-becomes-product principle. Future ontology work on `vaults/paulgraham/concepts/` should reflect this three-instance shape, not treat the substrate as a mere "echo" of PG's case.

## Ontology debt against the paulgraham vault

The 2026-05-17 paulgraham vault commit (`498a27c8d7`) wrote two Concepts (`hn-was-arc-demo-app`, `reader-is-test-rig`) that frame PG's Arc→HN as the example and the substrate as the echo. Owed correction:

1. Rename `hn-was-arc-demo-app` → `test-rig-becomes-product`
2. Add hack-nu's `3b7c0e784` + `a6ff108de` + `19700e272` commits as `sR` LinkRefs (concrete substrate evidence, not forward-typed)
3. Three-instance table in the Concept `d` field — PG / rismay / substrate
4. Write a supersession receipt rather than silent-editing the original Concept

## Lesson

I had `a6ff108de` in memory under a *different* insight (localize-founding) and didn't surface it when rismay said "we have hack-nu for reference." Future move: when an operator names a specific working app as a reference, **always pull its git provenance** before reasoning about it. References in this substrate are usually self-recognition, not arbitrary picks.
