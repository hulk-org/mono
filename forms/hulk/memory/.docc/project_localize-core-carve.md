---
name: LocalizeCore library carve
description: localize CLI package now ships LocalizeCore library product alongside the localize executable; pure model + AI dispatch lives in core
type: project
---

The `localize` SwiftPM package at
`private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/localize/`
was split on 2026-04-09 into two products:

- **`LocalizeCore`** library — `Sources/LocalizeCore/`
  - `AppStore.SupportedLocale` (no `ArgumentParser` conformance)
  - `XCStrings` Codable models
  - `LocalizationTranslationRequest` / `LocalizationTranslationResult` (+ `@Generable` shape for FoundationModels)
  - `LocalizationAI` (Apple/OpenAI dispatch via `CommonAI`)
  - `LocalizeError`
  - Internal `Log.localize`
  - Deps: `common-ai`, `common-log` only
- **`localize`** executable — `Sources/localize/` — now imports `LocalizeCore` and adds the `ExpressibleByArgument` conformance for `SupportedLocale` in `SupportedLocale+ArgumentParser.swift`. Owns `Localize.swift`, `Commands/{XCStrings,Fastlane,Legacy+Genstrings}.swift`, `CLIs/GenstringsCLI.swift`, `FileManager+Localization.swift`, `String+Loading.swift`.

**Why:** `localize-by-wrkstrm` mac app needed to embed the localize logic without dragging in `ArgumentParser`/`CommonShell`/`TSCBasic`.

**How to apply:** any future SwiftUI/host that wants xcstrings parsing or AI translation should depend on `LocalizeCore`, never the `localize` executable. Don't re-merge the targets.

**Caveat:** the package's transitive dep graph (`common-ai` → `google-ai-swift` → `common-log`) currently fails to resolve from a clean state; this is the schema-universal-wrapper-sweep / legacy localOrRemote issue, not anything introduced by the carve. The carve itself is source-clean; blocked on resolver fix.
