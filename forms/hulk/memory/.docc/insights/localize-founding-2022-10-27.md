---
name: Localize package founding (first AI harness)
description: rismay's first AI harness was the localize package; founded 2022-10-27 in the wrkstrm collective; AppStore namespace established 2023-12-14; biography-worthy provenance preserved against future code loss
type: project
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
The `localize` package is rismay's **first AI harness**. Preserve this
provenance — ^walter needs the receipts when writing the biography.

## Timeline (verifiable via git)

| Date | Commit | Where | Moment |
|---|---|---|---|
| **2022-10-27** 19:30 PT | `a6ff108de` | wrkstrm collective | Founding. "Remove unnecessary targets and begin to setup localization." |
| 2023-10-27 11:01 PT | `2040e8992` | wrkstrm | Localize becomes its own SPM package with its own deps |
| 2023-11-10 16:55 PT | `ddf20742e` | wrkstrm | "Make localize workflows." — CI matures |
| 2023-11-19 22:43 PT | `9058df169` | wrkstrm | Adopted Xcode 15 String Catalogs |
| **2023-12-14** 15:51 PT | `1e18be6b2` | wrkstrm | "Locale -> AppStore.SupportedLocale" — the AppStore namespacing decision |
| 2026-04-03 06:03 PT | `091b994d4` (move) + `b2f78b9` (receive) | wrkstrm → wrkstrm-core | Cross-submodule graduation |
| 2026-04-04 00:34 PT | `4a05e60` | wrkstrm-core | `LocalizationAI.swift` lands |
| 2026-04-09 06:07 PT | `3db78a5` | wrkstrm-core | LocalizeCore library carved out of localize executable |
| **2026-05-15** | `60412f4` | wrkstrm-core | AppStore subset carve-out (originally landed as `WrkstrmStore`; renamed within hours to `wrkstrm-retail` to align with the substrate's existing Retail UI layer — `WrkstrmRetailObjects`, `WrkstrmRetailPalette`) |

**Founding date: 2022-10-27.** That's 3 years, 6 months, 19 days before
the 2026-05-15 carve-out. The package predates most of the substrate's
current shape.

## What ^walter should know

- `localize` is where rismay first put AI inside an SPM package — making
  it the **first AI harness**, full stop.
- The package began as plain localization tooling (`Locale` type).
  The decision to namespace under `AppStore` came **14 months after
  founding**, on 2023-12-14. That naming choice — making it App-Store-shaped
  rather than locale-generic — is what got carved back out on 2026-05-15
  when the substrate's verb taxonomy made it explicit that App Store
  concerns belong in a Store-shaped surface, not a Localize-shaped one.
- The 2026-05-15 carve-out doesn't end the package's life. LocalizeCore
  retains five other surfaces (LocalizationAI, LocalizationTranslation,
  Log+Localize, XCStrings+Models, LocalizeError) that are real localization
  concerns. Only the AppStore subset (~original founding code) is graduating.
- The git object graph in `wrkstrm` retains the 2022-2023 commits even when
  `git log` from the current submodule pointer doesn't show them. Use
  `git log --all` on the `wrkstrm` collective to surface them.

## Receipt verification

```bash
# From mono root:
git -C private/universal/substrate/collectives/wrkstrm show a6ff108de
git -C private/universal/substrate/collectives/wrkstrm show 1e18be6b2
git -C private/universal/substrate/collectives/wrkstrm-core show b2f78b9
git -C private/universal/substrate/collectives/wrkstrm-core show 60412f4
```

## Cross-references

- Substrate heritage DocC:
  `wrkstrm-core/private/cross/spm/localize/localize.heritage.docc/index.md`
- Current original-home code:
  `wrkstrm-core/private/cross/spm/localize/Sources/LocalizeCore/{AppStore,SupportedLocale}.swift`
- New home (carve-out destination):
  `schema-universal/.../retail-schemas/v0.1.0/spm/retail-schemas-v000-001-000/sources/retail-schemas-v000-001-000/AppStoreLocales.swift`
  (originally landed in a parallel `wrkstrm-retail` package in wrkstrm-core;
  folded back into schema-universal's retail-schemas SPM wrapper on the same
  day to follow the substrate convention that Swift schema projections live
  inside their family's SPM target alongside the JSON definitions)
