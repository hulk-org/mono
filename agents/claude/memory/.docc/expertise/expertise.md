# Expertise

@Metadata {
  @TechnologyRoot
}

## Domains

- **Digikoma system**: Build, run, and test komo across the 7-domain fleet
  (core/build/directory/meta/context/intelligence/gaming). Familiar with spec
  format, identity surfaces, lineage, and the digikoma-primitives registry.
- **digikoma-plant**: Factory app rebuild and launch workflow.
- **Substrate navigation**: Scale-disciplined orientation across the monorepo,
  harness/agent/operator home resolution, submodule topology.
- **Swift SPM packaging**: Package.swift authoring, localOrRemote patterns,
  executable + library target splits, test target wiring.
- **App Store shipping**: Archive, export, validate, upload via altool; purpose
  string authoring; credential store conventions.
- **apple-pi agent loop**: Plugin architecture (`AgentPlugin`, `TurnContext`,
  `ProcessPlugin`), Digikoma<->AgentTool bridging, turn lifecycle hooks, declarative
  JSON subprocess plugins with template substitution.
- **Performance benchmarking (graph rendering)**: `GraphBenchBackend` protocol
  + async 60fps binary-search driver, live on-screen renderer conformers for
  Metal / SceneKit / RealityKit / UIKit Dynamics, AppKit vs Catalyst
  dual-target via `#if canImport` branches.
- **Mac Catalyst app shelling**: xcodegen `project.yml` drives Catalyst app
  targets sharing an SPM sources directory with an AppKit CLI; UIKit
  `AppDelegate` / `UISceneDelegate` boot into a view controller that hosts a
  bench container UIView and routes status updates via a closure sink.

- **Beads + Workflow integration**: beads-schemas v0.1.0 (18 Swift types +
  JSON schemas validated against Go source), Workflow app scaffold
  (me.rismay.workflow), WorkstreamTemplateModel ↔ Beads bridging,
  PaperclipIssueModel rename.
- **Swarm framework analysis**: Deep investigation of christopherkarani/Swarm
  vs Digikoma architecture; @Tool macro analysis for potential @DigikomaSpec adoption.
- **Research pipeline**: digikoma-web-fetch (URLSession + Tavily + HTML extraction),
  digikoma-summarize-context (recursive FM summarization with chrome filtering),
  CommonLog integration across all Digikoma.
- **Header session state**: Session-scoped state files, incident mode priority,
  stale sweep, --session-id on all CLI commands.
- **Metal particle visualization**: COLLIDE membrane scene built on
  MetalGameEngine (instanced SDF quads + line segments). CollideSimulation
  drives particle physics CPU-side, membrane wave amplitude tracks collision
  density. Desktop wallpaper mode via NSPanel at desktopIconWindow - 1.

- **RPN calculator**: swift-rpn-cli (RPNCore library, 38 ops + named
  definitions with macro expansion and recursion detection, 51 tests),
  digikoma-rpn (Logikoma wrapper), digikoma-ghost-calc (FM + tool proof).
- **Swift macros (compiler plugins)**: @Traced body macro via SwiftSyntax,
  CommonLog-injectable, generates entry/exit/error logging around any function.
- **Ghost Shell experimentation**: v001 binary with LogikomaFoundationTool,
  XPC telemetry protocol, observer app configuration.

## Recent Work

- 2026-04-24: Built swift-rpn-cli (38 ops + named definitions, 51 tests),
  digikoma-rpn (5 tests), digikoma-ghost-calc (FM+tool proof — circle area, leap year,
  percentages all correct). Built @Traced body macro (SwiftSyntax compiler
  plugin, 2 expansion tests). Built ghost-shell v001 binary with digikoma-rpn as
  FoundationModels Tool. Wrote 3 doctrine articles. Then fumbled the
  ghost-shell.mac app refactor — rewrote working experimentation UI into a chat
  box, broke the file split, lost code in git checkout. Restored original,
  re-added v001 entries. Lesson: ghost-shell is experimentation not chat.
- 2026-04-23: Local network discovery via Bonjour/mDNS (dns-sd). Found macMini
  and Mac Pro advertising SMB on local network. Light sync session.
- 2026-04-23: COLLIDE insight + Metal 4 visualization. Four representations
  of the membrane metaphor (MD, SVG, HTML/JS, Metal). Built metal-collide-bench
  target in metal-game-engine with CollideSimulation, NERV palette, and
  --desktop live wallpaper mode. Synced >clide as harness profile.
- 2026-04-20: Swarm investigation + Beads discovery. Built digikoma-web-fetch
  (5/5 tests) and digikoma-summarize-context (3/3 tests) with CommonLog wired
  in. Ran 3-stage research pipeline (v1/v2/v3). Created beads-schemas v0.1.0
  (~40 types from Go source). Scaffolded Workflow app. Moved paperclipIssue
  to per-task, added beadsIssueId. Renamed PaperclipIssueProtocolModel →
  PaperclipIssueModel. Session-scoped header state with incident priority.
  Mounted pointfreeco/sqlite-data, gastownhall/beads, christopherkarani/Swarm.
- 2026-04-16: graph-view-bench-press unification - `GraphBenchBackend`
  protocol drives one bench executable over seven live rendering strategies;
  dropped sim-only + offscreen variants per "must render on-screen" rule;
  ported three benches from MTLTexture offscreen to live `NSWindow`; stood up
  Mac Catalyst shell (`graph-view-bench-catalyst.app`) via xcodegen with
  shared sources directory, UIKit `AppDelegate`+`SceneDelegate`, and
  `BenchStatusDisplay` sink for per-probe status. Upstream fixes:
  `PerformanceLabKit.BenchmarkRunner` guarded with
  `#if !targetEnvironment(macCatalyst)`; `UIKitDynamicsGraphBackend` got
  `CGVector`->`CGPoint` type fix + `hostView:` parameter so the animator
  container can mount in a visible host view. Metal fragment shader grew SDF
  circle rendering (`length(uv) - 1.0` + `fwidth` for AA).
- 2026-04-15: Built apple-pi plugin architecture - `DigikomaAgentToolAdapter`
  bridges `Logikoma` -> `AgentTool` (JSON round-trip); `AgentPlugin` +
  `TurnContext` formalise `onTurnStart`/`onTurnEnd` hooks; `ProcessPlugin` +
  `ProcessPluginCommand: Codable` make any CLI tool a JSON-declarative turn
  lifecycle participant. 25 tests across 3 new test suites.
- 2026-04-14: Proved 5 core komo green end-to-end (echo, scan-directory,
  read-file, git, list) with 39 passing tests including on-device
  FoundationModels smart paths. Fleet inventory: 56 komo, 21 built.
