---
name: AppStore.SupportedLocale lives in LocalizeCore (heavy deps)
description: Canonical 39-case ASC locale enum is at wrkstrm-core/.../localize/Sources/LocalizeCore/SupportedLocale.swift, but the package drags in CommonAI/CommonAIApple/etc.; lightweight consumers vendorize until the carve-out lands
type: reference
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
The canonical `AppStore.SupportedLocale` enum (39 cases for App Store
Connect locale codes) lives at:

```
private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/localize/
  Sources/LocalizeCore/AppStore.swift            // public enum AppStore {}
  Sources/LocalizeCore/SupportedLocale.swift     // extension AppStore { enum SupportedLocale ... }
```

**The dep is heavy.** LocalizeCore imports CommonAI, CommonAIApple,
CommonAIOpenAI, CommonLog as transitive deps because it does AI-assisted
translation work. Lightweight consumers (schema-only packages, etc.)
that just want the enum should not depend on LocalizeCore directly.

**How to apply:**
- **Heavy-dep-tolerant Swift app code**: import LocalizeCore directly
  and use `AppStore.SupportedLocale`.
- **Lightweight schema/data packages**: vendorize the 39-case enum
  locally, with a docstring pointing at LocalizeCore as the source of
  truth. Done in `schema-universal/.../app-store-metadata-schemas/.../sources/.../AppStoreLocale.swift`
  on 2026-05-14.
- **Future**: the bead `app-store-locale-carveout` tracks splitting
  `SupportedLocale` into its own micro-package so both LocalizeCore +
  lightweight consumers can dep on it without the AI weight.

**Drift watch:** the vendor copy in app-store-metadata-schemas must be
kept in sync with LocalizeCore. Apple adds ~1 ASC locale per year. Easy
to forget — bead the carve-out so this stops being a maintenance tax.
