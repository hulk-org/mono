# background-memory

Files listed in CLAUDE.md Background Memory section. Read silently at session start, never surfaced to the user. These belong to a different commissioned home (clia-carrie).

### ✓ `private/universal/substrate/agents/clia-carrie/memory/.docc/ios-app-from-scratch.md`
3,541 bytes · ~885 tok

```markdown
# iOS App From Scratch

A repeatable checklist for starting a new iOS app in this substrate.

## Project Setup

- Use `xcodegen` with a `project.yml` spec as the single source of truth for
  the xcodeproj. Never hand-edit pbxproj directly except for surgical additions
  (entitlements, signing, SPM package references).
- Add the app to `private/universal/substrate/rismay-substrate.xcworkspace`
  immediately. All apps share a build cache through the 900+ package workspace.
- Bundle ID pattern: `me.rismay.<slug>` for personal/rismay-distributed apps.
  Laussat Studio uses `me.laussat.<slug>`. wrkstrm uses `me.rismay.<slug>` with
  team `BM6B69ZQSR`.
- Set `CODE_SIGN_STYLE = Automatic`, `DEVELOPMENT_TEAM = BM6B69ZQSR`,
  `CODE_SIGNING_ALLOWED = YES` from day one. Unsigned apps trigger macOS
  keychain password prompts on every access.

## Entitlements

- Create `Sources/mac-app/<slug>.entitlements` immediately with at minimum:
  ```xml
  <key>keychain-access-groups</key>
  <array>
    <string>$(AppIdentifierPrefix)group.me.rismay.tau.alphabeta</string>
  </array>
  ```
- Wire `CODE_SIGN_ENTITLEMENTS` in both Debug and Release target configs.
- The shared access group runtime string is `BM6B69ZQSR.group.me.rismay.tau.alphabeta`.
  Use the literal string in Swift code — `$(AppIdentifierPrefix)` is build-time
  only and resolves as a literal in Swift.

## SPM Structure

- One app target, dependencies via SPM only. No CocoaPods, no Carthage.
- Narrow dependencies: each import points at the source-of-truth package for
  that symbol. No kitchen-sink super-packages.
- Local deps: `Package.swift` uses `localOrRemote(...)` pattern —
  `SPM_USE_LOCAL_DEPS=true` routes to local paths; default is remote URLs.
  Default must be `false`. Never invert.
- `launchctl setenv SPM_USE_LOCAL_DEPS true` before xcodebuild when using local
  deps, then `unsetenv` after. The sandbox strips env vars set via prefix.

## Source Layout

```
Sources/
  mac-app/          ← or ios-app/
    <App>App.swift
    <App>RootView.swift
    Info.plist
    <slug>.entitlements
```

No `Sources/shared/` unless there is a genuine second target (e.g. a status bar
app or login item). Don't pre-create shared layers for hypothetical reuse.

## Secrets

- All credentials go in Keychain. Never `UserDefaults`.
- Use `WrkstrmKeychain` with `service: "WrkstrmIntegrations"` and
  `accessGroup: "BM6B69ZQSR.group.me.rismay.tau.alphabeta"` for anything that
  should be readable by the other wrkstrm apps (Vault, inference-metrics,
  Source Control, Collectives).
- For app-local secrets (account index, display metadata): use a separate
  service without an access group.
- `hasSecret(for:)` → `loadSecret(for:)` → `saveSecret(_:for:)` is the
  standard read/write pattern. Never store raw tokens in Published state.

## FoundationModels

Dual-branch declarations are required — `swift build` does not have the
FoundationModels Xcode toolchain plugin:

```swift
#if canImport(FoundationModels)
import FoundationModels
@Generable struct MyOutput { ... }
#else
struct MyOutput { ... }
#endif
typealias MyOutput = MyOutput
```

This satisfies both CLI compilation and koma-audit syntax probes.

## Graduation Policy

Apps start in clia-org if they are operator-internal. Once an app becomes
broadly useful (not operator-only), it graduates to wrkstrm. The precedent:
clia-git → Source Control (2026-04-08). Consumer-viable signals: no codex
session deps, no agent identity deps, no XPC/VM config — only standard SwiftUI
plus wrkstrm components.
```

### ✓ `private/universal/substrate/agents/clia-carrie/memory/.docc/app-architecture.md`
3,948 bytes · ~987 tok

```markdown
# App Architecture

Patterns that apply across iOS/macOS apps in this substrate.

## View Model Layer

- `@MainActor final class SomeStore: ObservableObject` is the standard shape.
- Published state flows down to views. User actions flow up via methods — not
  closures stored as properties.
- View models do not hold raw secrets or credentials. They hold display state
  derived from Keychain reads. Keep `loadSecret(for:)` calls in the store, not
  in views.
- One store per domain. Do not aggregate unrelated published state into a single
  god store.

## Model Layer

- Value types (`struct`, `enum`) for all model data. `class` only when identity
  or shared mutable state is genuinely required.
- `Identifiable`, `Codable`, `Sendable` on every model that crosses a
  persistence or concurrency boundary.
- Date fields: `createdAt`, `updatedAt` on every mutable record.
- Status enums (`AccountStatus`, etc.) are `CaseIterable` — UI pickers derive
  from `allCases`, never a hardcoded list.

## Concurrency

- `async`/`await` + `Task` + `Actor` throughout. No completion handlers in new
  code unless bridging to a legacy callback API.
- `@MainActor` on the store; `nonisolated` on pure helpers.
- `AsyncThrowingStream` for live data (FSEvents, streaming process output).
  Prefer `Subprocess` backend over `Process` for streaming.

## Persistence

- **SwiftData** for new relational schemas. Core Data only when the schema is
  already established.
- **Keychain** for secrets — `WrkstrmKeychain` wrapper, shared access group
  `BM6B69ZQSR.group.me.rismay.tau.alphabeta`.
- **UserDefaults** for UI preferences only (tab selection, last-used filter).
  Never for credentials, tokens, or anything security-adjacent.
- **Append-only event logs** for audit trails. Never mutate past events.

## UI Patterns

- `NavigationSplitView` for three-column Mac layouts (sidebar / list / inspector).
- `ModernSharedAppShell` for the wrkstrm shell chrome.
- `WrkstrmMeshGradientHeader` for the header band.
- Semantic palette: define all colors as named slots (`surfaceWash`, `cardFill`,
  `cardBorder`, `textPrimary`, `textSecondary`) in an enum. Never scatter
  `.opacity(0.08)` literals across views.
- `ContentUnavailableView` for empty states. Never a blank `VStack`.
- Never hardcode `preferredFramesPerSecond`. Read
  `UIScreen.main.maximumFramesPerSecond` (iOS) or
  `NSScreen.main?.maximumFramesPerSecond` (macOS) at runtime.

## AppDelegate vs SwiftUI App

- Pure SwiftUI `@main App` struct for standard apps.
- `AppDelegate` + `NSWindow` + `MTKView` root when the app needs Metal as the
  foundation. SwiftUI is then a layer on top, not the entry point.
- Login items and status bar apps: `NSApplicationDelegate` with
  `activationPolicy(.accessory)`.

## Testing

- `import Testing` with `@Test` and `#expect`. Never `XCTestCase`.
- Test at the boundary: integration tests hit real Keychain and FileManager.
  No mocking internals.
- Naming: descriptive test function names, no snake_case, no single-letter vars.

## FoundationModels Integration

- Dual-branch `@Generable` declarations for any type used in FM generation.
  `#if canImport(FoundationModels)` / `#else` plain fallback / `typealias`.
- `KomaFoundationModelDocumented` conformance + `foundationSession(...)` for
  Koma FM bridge. Satisfies koma-audit `wellBuilt (100)` while keeping CLI
  `swift build` working.
- `SystemDesignTemplate` pattern (Scope / Architecture / Deep Dive / Tradeoffs /
  Close) for structured interview or coaching generation. Session context shifts
  time toward weak phases.

## Naming

- Types: `UpperCamelCase`. Properties/methods: `lowerCamelCase`.
- No snake_case anywhere including test names.
- No single-letter or cryptic names. Prefer `outputPath` over `p`, `identifier`
  over `id` unless `id` is the established domain term.
- File names match the primary type they define, exactly.
- SPM package slugs and filesystem paths: `kebab-case`.
```

### ✓ `private/universal/substrate/agents/clia-carrie/memory/.docc/swift-naming-guidelines.md`
1,241 bytes · ~310 tok

```markdown
# Swift Naming Guidelines (Wrkstrm)

This note captures the Swift naming rules we follow across libraries and CLIs.

- Descriptive identifiers: favor clarity over brevity. Name things for what
  they are and what they do.
- Variables, properties, functions: lowerCamelCase.
- Types (struct/class/enum/protocol/extensions): UpperCamelCase.
- Never use single‑letter or cryptic names (e.g., `a`, `v`, `p`). Use complete
  words (e.g., `outputPath`, `assetRoot`, `violation`).
- Avoid unnecessary abbreviations. Prefer `configuration` over `config`,
  `identifier` over `id` unless the domain term is a well‑established initialism.
- No snake_case in Swift code — including test names. Prefer readable, long‑form
  names like `encodesIso8601Dates`.
- Scope drives brevity: shorter names are acceptable in very tight scopes when
  still descriptive (e.g., `index`, `count`, `line`), but never single‑letter.
- Tests: use Swift Testing with descriptive test names; keep identifiers explicit
  to aid parallel runs and diagnosis.

Rationale

- Human readability first: descriptive names reduce cognitive load in reviews,
  enable safer refactors, and make generated docs clearer. The small cost in
  keystrokes pays dividends over time.
```

### ✓ `private/universal/substrate/agents/clia-carrie/memory/.docc/streaming-contracts.md`
535 bytes · ~133 tok

```markdown
# Streaming Contracts

Guidance for choosing between buffered and streaming execution.

- Buffered run
  - Returns `ProcessOutput` once the process exits
  - Simpler flow for small outputs or batch pipelines
- Streaming run
  - `AsyncThrowingStream` of events, supports cancellation and live updates
  - Requires a streaming-capable runner (Subprocess preferred)

See `/documentation/commonprocess/tuist-command-architecture` for a Tuist Command diagram and
`/documentation/commonprocess/commonprocess-architecture` for CommonProcess.
```

**Phase total**: ~2,315 tok