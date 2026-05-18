---
name: Release-tier feature CLI owns the build-time on/off matrix
description: Substrate apps gate features per release tier (debug/dogfood/testflight/release) via a Swift CLI that emits SWIFT_ACTIVE_COMPILATION_CONDITIONS and a generated ReleaseFeatures constants file, not scattered #if blocks
type: project
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
The substrate needs a **release-tier feature CLI** (a digikoma) that owns the
build-time on/off matrix for substrate apps. Today the matrix is duplicated
across three surfaces:

1. Swift `#if DEV / DOGFOOD / TESTFLIGHT` blocks in app sources
2. `project.yml` `SWIFT_ACTIVE_COMPILATION_CONDITIONS` per-config blocks
3. Operator memory ("which features are on in TestFlight?")

This drifts. The fix: a single `release-features.json` per app declaring
`{ feature: <name>, tiers: [debug, dogfood, testflight, release] }`, and a
CLI that emits the other two surfaces from it.

**Why:** rismay flagged this 2026-05-13 while pivoting Hello World to iOS
Catalyst — the existing `#if DEV / DOGFOOD / TESTFLIGHT` blocks in
`HelloWorldGoogleApp.swift` would have to be repeated in every new app, and
matching them against `project.yml`'s SWIFT_ACTIVE_COMPILATION_CONDITIONS is
a coordination cost that grows with the fleet.

**How to apply:**
- Release-tier feature gates are **build-time** (the binary either contains
  the code or doesn't). They are *distinct from* runtime feature flags
  (`common-feature-flags`), which are server-driven on a built binary. Don't
  conflate the two — both exist; runtime flags overlay on the build-time
  baseline.
- The CLI is doctrinally a digikoma: bounded, typed, replayable, no persona.
  It reads a per-app `release-features.json` and emits:
  - `SWIFT_ACTIVE_COMPILATION_CONDITIONS` block in project.yml configs
  - A generated `ReleaseFeatures.swift` file (typed constants like
    `ReleaseFeatures.firebaseRemoteConfig: Bool`) so app code uses
    `if ReleaseFeatures.firebaseRemoteConfig` instead of `#if DOGFOOD`
  - A bundle-resource manifest so `swift-launch-status-cli` (and the
    appStoreSnapshotReceipt gate) can audit per build which features ship
- Place under `clia-org` tooling SPM with the other release-operations CLIs,
  not in an app collective. Apps consume it as a dev dep + xcodegen-time
  pre-step.
- This collapses the three duplicate surfaces into one source of truth.
- Note: the `#if os(macOS)` and `#if targetEnvironment(macCatalyst)` guards
  are **platform shape** gates, not release-tier gates. The CLI should not
  try to own those — they're Swift-language-native conditional compilation
  and don't have the drift problem.
