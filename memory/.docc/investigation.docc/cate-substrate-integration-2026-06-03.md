# Cate Substrate Integration

@Metadata {
  @PageKind(article)
}

*Investigation date: 2026-06-03.*

## Summary

The substrate hit a typed-contract leak in iTerm's ScriptingBridge layer
during `session-split` rendering: property writes succeeded and
read-backs matched, but iTerm did not visually composite the assigned
PNG background. Rather than patch the foreign contract, the operator
named `0-AI-UG/cate` as the answer — an MIT-licensed Electron canvas
IDE whose `src/shared/panels.ts` extension surface lets the substrate
own the rendering contract end-to-end. This page enumerates cate's
substrate-relevant architecture, sketches the smallest credible
integration, and lists the open decisions blocking commitment.

## What was investigated

- The iTerm bridge bug at `ITerm2Bridge.m:45-66, 283-316` and the
  Swift caller at `main.swift:242-269`. Fix landed at `main.swift:268`
  (surface `launchError` via `writeToStandardError`, `return false`
  so `discardAppearance` reclaims orphan `.png` + `.svg` artifacts).
- The runtime verification that the bridge *does* write the property
  and *does* read it back unchanged — confirmed via direct osascript
  probe on iTerm window 1: wrote PNG path, read PNG path. The render
  layer is where the contract leaks, and that surface is internal to
  iTerm.
- The github-stars vault refresh (`scripts/sync-github-stars-vault.swift`):
  1751 stars across 36 GraphQL pages, 1611 unique repos, 600 marked
  `research_replacement`. Vault rebuilt: build → check → triage →
  summarize all green except two known check-script complaints
  (timeline SQLite missing, card-vs-entry 1:M mismatch).
- Cate's architecture, read from its own README.md + CLAUDE.md
  package.json: Electron 41 + React 18 + xterm.js + node-pty
  Zustand + electron-store + Monaco editor. The `src/shared/panels.ts`
  file centralizes panel definitions; `src/shared/ipc-channels.ts`
  types IPC. CanvasNode owns drag/resize/close; DockTabStack owns
  tabs/splits.

## What was found

1. **The iTerm contract is structurally leaky for our use case.** Even
   when we route assignments through AppleScript (which works at the
   property layer), iTerm's render layer requires profile-level
   "Use Image" + `image blend` + `image mode` interactions that vary
   by version and are not part of any stable substrate-typeable
   contract. Negotiating this is high-friction with low durable
   payoff.

2. **Cate is architecturally substrate-shaped.** Its panel system
   matches the substrate's existing typed-record-as-projection pattern
   one-to-one. Each session-split lane maps to a CanvasNode hosting a
   TerminalPanel with a PNG background. Spatial layout, named layouts,
   detached panels, and persistence are all already implemented.

3. **The session-split CLI is already structured to absorb cate as a
   new renderer.** `SessionSplitTerminalTarget` is a sum type
   (`iterm | terminal | print`). Adding a fourth case (`cate`) is
   enum extension, not redesign. The existing lane-brief JSON shape
   travels unchanged.

4. **Cate's MIT license removes the BSL-clock-expired dance** the
   substrate has had to apply to BSL 1.1 deps (Couchbase Lite,
   MariaDB). Cate can be vendored directly as a submodule when the
   substrate's remote-migration story settles.

5. **Cate's `node-pty` ceiling is Node ≤ 22 LTS.** Substrate-side
   consumers must respect the `.nvmrc` (Node 20 or 22) — Node 23+
   breaks `node-pty` native compilation. This is a real constraint
   on which Node environments can host the substrate-cate bridge.

## Proposed shape

### Phase 1 — Vendoring

- Cate currently lives at `.tmp/cate/` (33 MB shallow clone) per
  CLAUDE.md's working-surface doctrine.
- Promote when the substrate's GitHub-remote migration finishes
  ([[github-remote-migration-in-progress-no-push]],
  [[no-github-pushes-pending-codeberg-or-self-hosted-git-server-migration]]).
  Likely typed home: `private/universal/substrate/collectives/cate-org/`
  as a new commissioned collective, mirroring the pattern used for
  `openai/` and `wrkstrm/`. Authorship attribution: `0-AI UG`.

### Phase 2 — Session-split renderer extension

- `Sources/SwiftSessionSplitCore/SessionSplit.swift` —
  `SessionSplitTerminalTarget` gains `case cate`.
- `Sources/SwiftSessionSplitCLI/main.swift` —
  new `case .cate: try launchInCate(plan: plan, appearance: appearance)`
  in the dispatch switch.
- `launchInCate` posts an IPC message to a running cate instance
  (channel TBD — likely a substrate-side `cate-companion` over a Unix
  socket or HTTP/JSON-RPC on a fixed local port). The message
  carries the lane brief JSON + PNG path + harness-cli command.

### Phase 3 — Cate-side panel pair

- New cate command (`Cmd+K` palette entry) `Substrate: open session-split lane`
  that consumes a brief JSON, opens a TerminalPanel running the
  harness CLI, and applies the PNG as a CanvasNode background.
- The cate-side change is a small addition to `src/shared/panels.ts`
  (new panel-type discriminator) + a renderer-store action that
  composes a TerminalPanel with the background asset.

### Phase 4 — iTerm-as-fallback

- The iTerm bridge code stays in place behind `--terminal iterm`.
- The Swift fix from this turn (`main.swift:268`) stays useful for
  surfacing the genuinely-broken cases (NSException, session-not-
  found) that aren't the render-layer leak.
- Default `--terminal` resolution prefers `cate` when a cate instance
  is detected (substrate-side discovery probe TBD), with `iterm` as
  the fallback when cate is absent.

## Risks

- **Cate is upstream-active.** Pushed today (2026-06-03). Vendoring
  via submodule lets us follow updates; vendoring as a forked snapshot
  loses upstream momentum. The substrate's remote-migration story
  decides which pattern lands.
- **Node-pty version ceiling** (Node 20–22 LTS) constrains substrate
  CI environments that host cate workflows.
- **IPC contract design** is the real authoring work. Cate doesn't
  ship a substrate-aware companion; we'd be writing the channel from
  scratch. Choice between Unix socket + JSON, HTTP/JSON-RPC, and an
  Electron-side IPC bridge has real maintenance implications.
- **Discovery probe semantics.** When should `--terminal auto` pick
  cate vs iterm? Currently iTerm is the only auto-pick. Adding cate
  changes operator surprise calculus.

## Open questions

1. Does cate vendor under a new `cate-org/` collective, under
   `takumi-org/` (alongside session-split), or as a plain
   `vendor/cate/` tree under an existing org? The first respects
   ownership doctrine; the others minimize structural churn.
2. What is the IPC channel contract? Unix socket + length-prefixed
   JSON is the substrate-canonical idiom for cli↔daemon pairs (e.g.
   savepoint.sd, vaultd). Cate would need a companion process to
   speak that protocol; the cate-side renderer can't open sockets
   directly without main-process IPC.
3. Should the session-split's existing PNG+SVG lane-art generator
   ([[apparently in SessionLaneAppearance.swift]]) stay substrate-side
   and ship the PNG, or move to a cate-side panel-renderer that draws
   the lane card from typed lane metadata directly?
4. Is there a substrate-owned identifier scheme for cate instances
   (lane home, project root) so multiple cate windows on one host
   can be routed to the right canvas?

## Refinement — CodeEdit as the substrate-shaped renderer

After the initial cate selection, the operator named the substrate-
fit refinement: *"another star in there that used swift term that we
should use. and it's important because we already have that
dependency."* That star is `CodeEditApp/CodeEdit` — a 22,882-star
MIT-licensed native Mac IDE that imports SwiftTerm. The substrate
already pulls SwiftTerm 1.0.0 in via
`collectives/wrkstrm/private/universal/spm/domain/system/CommonConsoleKit/Package.swift:28`,
so the transitive dep surface stays unchanged when CodeEdit's
terminal layer joins.

### What CodeEdit ships that substrate can lift

- `CodeEdit/Features/TerminalEmulator/Views/TerminalEmulatorView.swift`
  — `NSViewRepresentable` wrapping `LocalProcessTerminalView` from
  SwiftTerm for SwiftUI consumption.
- `CodeEdit/Features/TerminalEmulator/Views/CEActiveTaskTerminalView.swift`,
  `CELocalShellTerminalView.swift`, `CETerminalView.swift`,
  `TerminalEmulatorView+Coordinator.swift` — the layered terminal
  view family (shell mode, task mode, coordinator pattern).
- `CodeEdit/Utils/Extensions/SwiftTerm/Color/SwiftTerm+Color+Init.swift`
  — color bridging into SwiftTerm's typed color surface.
- `TerminalCache` — preserves terminal state when the view leaves
  the SwiftUI hierarchy. Maps cleanly onto substrate's session-
  persistence pattern.

### The fork divergence to reconcile

CodeEdit pins SwiftTerm at `https://github.com/thecoolwinter/SwiftTerm`
(`CodeEdit.xcodeproj/project.pbxproj` — `XCRemoteSwiftPackageReference`
entry `6CCF73CE2E26DE3200B94F75`). Substrate pins
`https://github.com/migueldeicaza/SwiftTerm.git from 1.0.0`. Two
reconciliation paths:

1. Substrate switches CommonConsoleKit's SwiftTerm pin to
   `thecoolwinter/SwiftTerm` to match CodeEdit. Requires auditing
   the fork's divergence (likely a CodeEdit-specific patch set).
2. Lift CodeEdit's TerminalEmulatorView source into substrate and
   re-target it at `migueldeicaza/SwiftTerm`. Requires verifying
   the fork's diffs are non-load-bearing for the
   `LocalProcessTerminalView` surface area we need.

Option 2 is the substrate-doctrinal preference (own the source we
ship, minimize forked-upstream entanglement). Option 1 is faster
if the fork's patches turn out to be cosmetic.

### Cate vs CodeEdit — the architectural trade

| Axis | cate | CodeEdit |
| --- | --- | --- |
| Renderer | Electron + React + xterm.js | Native AppKit + SwiftUI |
| Terminal lib | xterm.js + node-pty (Node ≤ 22 LTS ceiling) | SwiftTerm (already substrate dep) |
| Spatial model | Infinite zoomable Figma canvas | Workspace + tabs + splits |
| License | MIT | MIT |
| Stars | 1107 | 22882 |
| Push activity | 2026-06-03 | 2026-06-03 |
| Substrate-doctrinal fit | "data-is-projection" via web | "own-the-dep-graph" via Swift |
| Foreign dep surface | Electron + Node + npm ecosystem | None new |

Cate carried the doctrine (substrate owns the renderer) into view.
CodeEdit is the doctrine's substrate-shaped instantiation: same
inversion, no Electron/Node surface, builds on a primitive
substrate's stack already inherits.

### Revised Phase 1 — Vendoring (CodeEdit lane)

- CodeEdit cloned to `.tmp/CodeEdit/` (21 MB shallow).
- Promote to typed home when the remote-migration story settles.
  Likely path: `private/universal/substrate/collectives/codeeditapp/`
  as a new commissioned collective mirroring the
  `CodeEditApp` GitHub org structure (CodeEdit, CodeEditSourceEditor,
  CodeEditTextView, CodeEditLanguages, CodeEditKit, CodeEditCLI,
  WelcomeWindow, AboutWindow). Multiple of these may become useful
  in their own right; vendoring the org structure preserves the
  composition shape.

### Revised Phase 2 — Lift the terminal layer

The terminal layer's substrate-shaped vendoring path:

1. Copy `CodeEdit/Features/TerminalEmulator/` into a substrate-owned
   Swift Package — probably alongside CommonConsoleKit at
   `collectives/wrkstrm/.../spm/domain/system/CommonTerminalView/`
   or similar. Target the substrate's SwiftTerm pin.
2. Audit the fork's diffs (`thecoolwinter/SwiftTerm` vs
   `migueldeicaza/SwiftTerm`). If non-load-bearing, the lifted
   source compiles against the upstream pin directly.
3. CodeEdit's TerminalCache + Coordinator pattern map onto substrate
   session-state persistence — these are reusable typed primitives,
   not just IDE-specific glue.

### Revised renderer story for session-split

- `SessionSplitTerminalTarget` still gains a new case. But now the
  case is `codeeditview` (or `swiftterm`, or similar substrate-
  doctrinal slug), not `cate`.
- Lane PNG art renders as a SwiftUI background view *behind* the
  TerminalEmulatorView NSViewRepresentable. Substrate owns the
  compositing path end-to-end.
- The renderer launches in-process (or via a substrate Mac app
  hosting the canvas) — no IPC bridge to a separate Electron
  daemon. The substrate's existing CommonConsoleKit stack
  composes directly.

## Recommended next move (revised)

The substrate-shaped path is CodeEdit, not cate. The cate clone at
`.tmp/cate/` stays as a reference for the canvas-spatial-pattern
(Figma-style infinite-zoom dock), but the renderer the substrate
actually ships should be Swift-native, building on CodeEdit's
TerminalEmulatorView family and the SwiftTerm primitive substrate's
stack already imports.

Concrete next moves, ordered:

1. **Audit the `thecoolwinter/SwiftTerm` fork's divergence from
   `migueldeicaza/SwiftTerm`.** Determine whether substrate can
   lift CodeEdit's TerminalEmulatorView against the upstream pin
   substrate already uses.
2. **Decide CodeEdit's vendoring home.** A new
   `collectives/codeeditapp/` collective preserves the org-shape and
   leaves room for CodeEditSourceEditor, CodeEditTextView, etc.
   Alternative: lift only the terminal layer into
   `collectives/wrkstrm/.../spm/domain/system/CommonTerminalView/`
   and skip the IDE chrome entirely.
3. **Sketch the session-split renderer extension** with the new
   case name and the substrate-owned compositing path.
4. **Keep the Swift fix from this turn (`main.swift:268`).** It
   stays useful as long as iTerm remains a fallback target.

The cate path is not wrong; it is a longer, foreign-surface route
to the same destination. The substrate's existing SwiftTerm
investment is the dispositive constraint — when a dep we already
own can host the renderer, the substrate-doctrinal move is to use
it.

## Fork audit results — migueldeicaza is the substrate-aligned pin

Both forks shallow-cloned to `.tmp/migueldeicaza-SwiftTerm/` and
`.tmp/thecoolwinter-SwiftTerm/`. Direct file diff of the load-bearing
consumer file (`Sources/SwiftTerm/Mac/MacLocalTerminalView.swift`)
revealed an asymmetry:

**thecoolwinter is a SUBSET of migueldeicaza.** thecoolwinter
removed (relative to upstream):

- `currentDirectory` parameter on `startProcess(executable:args:environment:execName:)`.
- `public func terminate()`.
- `clipboardRead(source:) -> Data?`.
- Backing-scale-aware `getWindowSize()` (replaced with a simpler version).
- Public-internal(set) visibility on the `process` property (tightened to internal).

migueldeicaza-only additions absent from thecoolwinter:

- `BlockElementRenderer.swift`, `BoxDrawingRenderer.swift`, `TerminalProgressBarView.swift`.
- `Metal/` directory — **the upstream now ships a Metal renderer.**
- `KittyGraphics.swift`, `KittyKeyboardEncoder.swift`, `KittyKeyboardProtocol.swift`, `KittyPlaceholder.swift` — Kitty terminal protocol support.
- `SearchEngine.swift`, `SearchLineCache.swift`, `SearchOptions.swift`, `SearchState.swift`, `TerminalViewSearch.swift`, `MacFindBarView.swift` — full search engine.
- `UnicodeWidthData.swift` — unicode width tables.
- `Documentation.docc`.

The substrate already pins `migueldeicaza/SwiftTerm` from 1.0.0.
CodeEdit's `TerminalEmulatorView.swift` only depends on the SUBSET
that thecoolwinter ships, which is also fully present in upstream
migueldeicaza. So:

**Lifting CodeEdit's `TerminalEmulatorView` family against the
substrate's existing migueldeicaza pin will compile unchanged.**

Substrate even gains capabilities CodeEdit's source doesn't
currently exercise — currentDirectory routing, terminate(), Metal
rendering, Kitty graphics, search engine — that future substrate
work can opt into without re-pinning. The fork-audit verdict is
unambiguous: no fork switch needed.

## Architect — the substrate's existing canvas host

The substrate already ships a Metal-rendered canvas Mac app at
`private/universal/substrate/collectives/wrkstrm-app/private/apple/apps/architect/`.

`Sources/mac-app/` houses:

- `DrawingCanvas.swift` — direct `MTKView` subclass, the actual
  Metal-rendered canvas.
- `MetalCanvasView.swift` — `NSViewRepresentable` SwiftUI wrapper.
- `CanvasView.swift`, `ArchitectRootView.swift` — view composition;
  root view enumerates a `.canvas` case labeled "Board".
- `StrokePipeline.swift` — drawing/stroke pipeline.
- `TouchBridge.swift` — pencil/touch bridge (iPad / Catalyst).
- `ColorWorkbenchView.swift`, `TypographyWorkbenchView.swift`,
  `ComponentsView.swift` — workbench panels.

`Package.swift` already declares dependencies on
`ModernMacAppShell`, `ModernSharedAppShell`, `WrkstrmFont`,
`WrkstrmSwiftUI`, `WrkstrmColor`, `metal-game-engine`, and
`common-log`. Targets are `ArchitectMain` (executable) and
`ArchitectLib` (library). Catalyst, mac-app, mac-main, and mac-touch
source roots are already separated, indicating multi-platform
intent.

This means the cate-but-Swift-native vision is *not* a green-field
build. Substrate has the canvas. Substrate has the Metal engine.
Substrate has the app shell. The only missing piece is the
**terminal panel that drops onto the DrawingCanvas surface** —
which is exactly what the lifted CodeEdit TerminalEmulatorView
family provides.

## Package sketch — `CommonTerminalView`

A new Swift Package, peer to CommonConsoleKit, in the substrate's
canonical `wrkstrm/.../spm/domain/system/` tier.

**Home:**
`private/universal/substrate/collectives/wrkstrm/private/universal/spm/domain/system/CommonTerminalView/`

**Package.swift:**

```swift
// swift-tools-version: 6.2
import Foundation
import PackageDescription

func localOrRemote(path: String, url: String, from version: Version) -> Package.Dependency {
  if ProcessInfo.useLocalDeps { return .package(path: path) }
  return .package(url: url, from: version)
}

let package = Package(
  name: "CommonTerminalView",
  platforms: [
    .macOS("26.0"),
    .iOS("26.0"),
    .macCatalyst("26.0"),
  ],
  products: [
    .library(name: "CommonTerminalView", targets: ["CommonTerminalView"]),
  ],
  dependencies: [
    .package(url: "https://github.com/migueldeicaza/SwiftTerm.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "CommonTerminalView",
      dependencies: [
        .product(name: "SwiftTerm", package: "SwiftTerm"),
      ]
    ),
    .testTarget(
      name: "CommonTerminalViewTests",
      dependencies: ["CommonTerminalView"]
    ),
  ]
)
```

**Sources structure** (lifted from
`CodeEdit/Features/TerminalEmulator/` with substrate-doctrinal
renames):

- `Sources/CommonTerminalView/TerminalEmulatorView.swift`
  (`NSViewRepresentable` wrapping `LocalProcessTerminalView`)
- `Sources/CommonTerminalView/TerminalEmulatorView+Coordinator.swift`
- `Sources/CommonTerminalView/CommonTerminalView.swift`
  (renamed from `CETerminalView` — the substrate-canonical
  base view)
- `Sources/CommonTerminalView/LocalShellTerminalView.swift`
  (renamed from `CELocalShellTerminalView`)
- `Sources/CommonTerminalView/ActiveTaskTerminalView.swift`
  (renamed from `CEActiveTaskTerminalView`)
- `Sources/CommonTerminalView/TerminalCache.swift`
- `Sources/CommonTerminalView/SwiftTerm+Color+Init.swift`

**ATTRIBUTION.md** at the package root records the lift
provenance: source files derived from `CodeEditApp/CodeEdit`
(MIT) at the audited commit hash; substrate-internal renames
documented; original copyright preserved per MIT terms.

**Consumers (initial):**

- `architect` Mac app — drops `TerminalEmulatorView` onto the
  DrawingCanvas surface as a new panel kind, sibling to
  ComponentsView / ColorWorkbenchView / TypographyWorkbenchView.
- `session-split@takumi-org.cli` — new
  `SessionSplitTerminalTarget` case (slug TBD; `architect`
  is one candidate, suggesting the renderer is named by the
  host app) launches/focuses an Architect window and posts a
  panel-open request via a substrate-side IPC or in-process
  channel.

**Composition with substrate:**

- CommonConsoleKit (already in stack) provides CommonShell
  arg parsing and SwiftTerm Terminal core.
- CommonTerminalView (new) provides the SwiftUI/AppKit view
  surface for embedding terminals as canvas panels.
- Architect (already in stack) provides the canvas host where
  CommonTerminalView panels dock.

Three Packages compose into the cate-but-native picture; the
substrate's existing dep graph absorbs the new Package with one
new dependency arrow (CommonTerminalView → SwiftTerm, already
shared with CommonConsoleKit).

## DDD correction — use CommonProcess, not SwiftTerm's LocalProcess

Operator-stated mid-investigation: *"remember that we use our
CommonProcess.. not theirs."* The substrate's `CommonProcess`
primitive family
(`swift-universal/.../common-process/Sources/common-process/`) is
the bounded-context owner of substrate-side subprocess spawning,
per
[[do-not-break-domain-driven-design]] and
[[common-process-banned-foundation-process]]. SwiftTerm's
`LocalProcess` is a substrate-foreign subprocess primitive;
lifting CodeEdit's `TerminalEmulatorView` as-is would import that
foreign primitive transitively — a typed-primitive-bypass
([[typed-primitive-bypass-3x-rule-confirmed]]).

### SwiftTerm's three composition layers

Looking at the dependency shape of SwiftTerm's classes:

1. `TerminalView` — pure rendering view (`NSView` / `UIView`
   subclass). Owns escape parsing, character grid, render
   pipeline. NO process awareness.
2. `PseudoTerminalHelpers` (`Pty.swift`) — thin libc wrapper over
   `forkpty(3)`, returns master fd + child PID. macOS/Linux only.
   This is Unix-primitive layer; no Foundation.Process.
3. `LocalProcess` + `LocalProcessTerminalView` — composes
   `PseudoTerminalHelpers` (PTY allocation) + an async read loop
   on the master fd + child-process lifecycle. THIS is what
   substrate must replace with `CommonProcess`-shaped equivalents.

The substrate-doctrinal lift preserves layers 1 and (optionally)
2, but layer 3 must be substrate-authored.

### CommonProcess's current typed surface

Public types present:

- `CommandSpec`, `EnvironmentModel`, `Executable`
- `ProcessGroupAuthority`, `ProcessGroupSpec`, `SafeGroupAuthority`
- `ProcessError`, `ProcessSignalName`
- `ProcessEvent`, `ProcessOutput`, `ProcessExitStatus+Convenience`
- `ProcessInstrumentation`, `ProcessInstrumentationContext`,
  `ProcessMetrics`, `ProcessMetricsRecorder`, `ProcessPreviewer`
- `ProcessTeardownStep`

Public types ABSENT (gap for the terminal use case):

- No `PTYSpec` / `PTYProcessSpec` / `TerminalProcessSpec`.
- No `PseudoTerminalDevice` / `PTYHandle`.
- No `forkpty/openpty/posix_openpt` references anywhere in
  `common-process/Sources/`.

Substrate-wide PTY sweep confirms: the only PTY-aware code in the
substrate is in `codex-rs/utils/pty/` (Rust) — no Swift PTY
primitive exists.

### New typed primitive needed — `PTYSpec` (proposal)

A new file at
`common-process/Sources/common-process/PTYSpec.swift` declaring:

```swift
public struct PTYSpec: Sendable, Codable {
  public var command: CommandSpec         // what to exec
  public var initialWindowSize: PTYWindowSize
  public var locale: String?              // LANG/LC_ALL override
  public var controllingTerminal: Bool    // setsid + ioctl(TIOCSCTTY)
  public var group: ProcessGroupSpec?     // composes with groups
  public var teardown: [ProcessTeardownStep]
  public var instrumentation: ProcessInstrumentationContext?
}

public struct PTYWindowSize: Sendable, Codable, Equatable {
  public var rows: UInt16
  public var cols: UInt16
  public var pixelWidth: UInt16
  public var pixelHeight: UInt16
}
```

Plus a runner (probably in `common-process-runners`) that:

- Allocates the PTY pair via libc `forkpty()` (or
  `posix_openpt()` + `grantpt()` + `unlockpt()` for finer
  control).
- Returns a typed handle exposing master-fd I/O (async read
  stream + write closure) and a child-process handle composing
  with the existing `ProcessGroupAuthority` taxonomy.
- Cross-platform-gates iOS / Windows out cleanly (matches
  SwiftTerm's `#if !os(iOS) && !os(tvOS) && !os(Windows)` gate).

This new primitive is the bounded-context-correct home for PTY
allocation. It composes with — does NOT contaminate — the existing
CommandSpec / ProcessGroupSpec families.

## Revised Package sketch — `CommonTerminalView` (DDD-corrected)

`CommonTerminalView` depends on `migueldeicaza/SwiftTerm` (for the
rendering layer only) and on substrate-owned `CommonProcess`
(extended with `PTYSpec`) for the subprocess-driving layer.

The lifted source structure changes:

- **Keep** the SwiftUI `NSViewRepresentable` wrapper pattern from
  CodeEdit's `TerminalEmulatorView.swift`.
- **Keep** the coordinator pattern from
  `TerminalEmulatorView+Coordinator.swift`.
- **Keep** the `TerminalCache` pattern.
- **Keep** `SwiftTerm+Color+Init.swift` (pure color bridging).
- **Replace** the inner `LocalProcessTerminalView` with a new
  substrate-authored `CommonProcessTerminalView : TerminalView,
  TerminalViewDelegate` class that composes SwiftTerm's pure
  `TerminalView` (rendering) with `CommonProcess.PTYSpec` (process
  driving). Same shape as SwiftTerm's `LocalProcessTerminalView`,
  but using substrate primitives.

The substrate-side `CommonProcessTerminalView` becomes the
substrate's typed canonical replacement for `LocalProcessTerminalView`
in any consumer — not just CommonTerminalView's view family.

### Revised Package.swift

```swift
// swift-tools-version: 6.2
import Foundation
import PackageDescription

func localOrRemote(path: String, url: String, from version: Version) -> Package.Dependency {
  if ProcessInfo.useLocalDeps { return .package(path: path) }
  return .package(url: url, from: version)
}

let commonProcessDependency = localOrRemote(
  path: "../../../../../../../swift-universal/private/universal/domain/build/spm/common-process",
  url: "https://github.com/swift-universal/common-process.git",
  from: "0.2.0"   // version that ships PTYSpec — TBD
)

let package = Package(
  name: "CommonTerminalView",
  platforms: [
    .macOS("26.0"),
    .iOS("26.0"),
    .macCatalyst("26.0"),
  ],
  products: [
    .library(name: "CommonTerminalView", targets: ["CommonTerminalView"]),
  ],
  dependencies: [
    .package(url: "https://github.com/migueldeicaza/SwiftTerm.git", from: "1.0.0"),
    commonProcessDependency,
  ],
  targets: [
    .target(
      name: "CommonTerminalView",
      dependencies: [
        .product(name: "SwiftTerm", package: "SwiftTerm"),
        .product(name: "CommonProcess", package: "common-process"),
      ]
    ),
    .testTarget(
      name: "CommonTerminalViewTests",
      dependencies: ["CommonTerminalView"]
    ),
  ]
)
```

### Revised Sources structure

- `Sources/CommonTerminalView/TerminalEmulatorView.swift`
  — SwiftUI `NSViewRepresentable` wrapping `CommonProcessTerminalView`
  (NOT `LocalProcessTerminalView`).
- `Sources/CommonTerminalView/TerminalEmulatorView+Coordinator.swift`
- `Sources/CommonTerminalView/CommonProcessTerminalView.swift`
  — **new substrate-authored class** mirroring SwiftTerm's
  `LocalProcessTerminalView` API but composing `CommonProcess.PTYSpec`
  for process driving instead of SwiftTerm's `LocalProcess`.
- `Sources/CommonTerminalView/TerminalCache.swift`
- `Sources/CommonTerminalView/SwiftTerm+Color+Init.swift`
- `Sources/CommonTerminalView/PTYBridgeAdapters.swift`
  — adapters bridging `CommonProcess.PTYSpec` events to SwiftTerm's
  `TerminalViewDelegate` callbacks (process termination, title
  updates, window-size updates).

The lifted view code from CodeEdit is the SwiftUI / coordinator /
cache layer. The substrate authors the process-driving class
itself.

## Sequencing — what blocks what

The substrate-doctrinal path has a hard ordering constraint that
the earlier sketch glossed over:

1. **`PTYSpec` + runner must land in `common-process` first.**
   This is a new typed primitive in CommonProcess's bounded
   context. Probably a `common-process-schemas` v0.3.0 bump to
   declare the typed contract, then a `common-process` minor
   version to add the runner.
2. **`CommonTerminalView` Package authored.** Initial lift can
   land as soon as PTYSpec is callable. The Package's
   `CommonProcessTerminalView` is where the bulk of the new code
   lives — the rest is lift-from-CodeEdit.
3. **Architect-side panel wiring.** Once CommonTerminalView
   compiles + renders a working terminal, Architect's mac-app
   adds a TerminalEmulatorView panel kind alongside
   ComponentsView / ColorWorkbenchView.
4. **Session-split renderer extension.** Once Architect can host
   a terminal panel from a typed open-panel intent,
   `SessionSplitTerminalTarget.architect` lands in
   session-split's switch.

The previous Phases 2-4 stand as written; the new Phase 0
(PTYSpec in CommonProcess) gates everything downstream.

## Recommended next move (DDD-corrected)

1. **Author the `PTYSpec` typed contract** in
   `common-process-schemas` (a new schema file in the appropriate
   v0.x.0 cut) — defines the wire shape of PTY-process spec
   without committing yet to a specific runner implementation.
   This is the smallest first commit; the runner follows.
2. **Author the `PTYSpec` runner** in `common-process` and/or
   `common-process-runners`, wrapping libc `forkpty()` with the
   substrate's instrumentation / teardown / group-authority
   composition.
3. **Then author `CommonTerminalView`** as sketched above.
4. **Then wire Architect's mac-app panel + session-split
   renderer extension** as previously planned.
5. **Keep the Swift fix from this turn (`main.swift:268`).**
   iTerm fallback remains useful until the new pipeline ships.

The cate clone at `.tmp/cate/` stays as a reference for the
Figma-spatial-canvas pattern (multi-window detach, named layouts,
dock zones) that the Architect canvas may eventually adopt. The
substrate-shaped path now commits to: SwiftTerm (upstream
rendering only) + `CommonProcess.PTYSpec` (substrate-authored
process primitive) + CommonTerminalView (substrate-owned lift
process-driving glue) + Architect (substrate-owned canvas host).
Four substrate-owned layers, one foreign rendering library —
versus cate's stack which would have imported Electron + Node
node-pty + xterm.js as foreign primitives.
