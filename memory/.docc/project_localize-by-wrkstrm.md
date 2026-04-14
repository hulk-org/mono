---
name: Localize app distribution
description: localize-by-wrkstrm — wrkstrm-owned mac app distributed via rismay's personal App Store account; bundle me.rismay.localize
type: project
---

`localize-by-wrkstrm` (display name "Localize") is owned by **wrkstrm Inc** but ships through **rismay's personal App Store account** (team `BM6B69ZQSR`), same pattern as Clia Day Pa distribution.

- Slug: `localize-by-wrkstrm`
- Bundle ID: `me.rismay.localize`
- Display name: `Localize`
- Type prefix: `LocalizeByWrkstrm`
- Home: `private/universal/substrate/collectives/wrkstrm-app/private/apple/apps/localize-by-wrkstrm/`
- Shell: `ModernSharedAppShell` + `WrkstrmMeshGradientHeader`
- Library it links: `LocalizeCore` (carved out of `wrkstrm-core/.../spm/localize` 2026-04-09)

**Why:** wrkstrm doesn't yet have its own paid Apple developer account in production for this app; rismay's account is the interim distribution channel.

**How to apply:** never assume the App Store team must match the legal owner. Bundle id stays `me.rismay.*` because the signing identity belongs to rismay personal, even though copyright/legal is wrkstrm.
