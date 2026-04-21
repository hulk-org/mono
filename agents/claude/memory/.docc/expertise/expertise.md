# Expertise

@Metadata {
  @TechnologyRoot
}

## Domains

- **Koma system**: Build, run, and test komo across the 7-domain fleet
  (core/build/directory/meta/context/intelligence/gaming). Familiar with spec
  format, identity surfaces, lineage, and the koma-primitives registry.
- **koma-plant**: Factory app rebuild and launch workflow.
- **Substrate navigation**: Scale-disciplined orientation across the monorepo,
  harness/agent/operator home resolution, submodule topology.
- **Swift SPM packaging**: Package.swift authoring, localOrRemote patterns,
  executable + library target splits, test target wiring.
- **App Store shipping**: Archive, export, validate, upload via altool; purpose
  string authoring; credential store conventions.
- **apple-pi agent loop**: Plugin architecture (`AgentPlugin`, `TurnContext`,
  `ProcessPlugin`), Koma<->AgentTool bridging, turn lifecycle hooks, declarative
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
  vs Koma architecture; @Tool macro analysis for potential @KomaSpec adoption.
- **Research pipeline**: koma-web-fetch (URLSession + Tavily + HTML extraction),
  koma-summarize-context (recursive FM summarization with chrome filtering),
  CommonLog integration across all Koma.
- **Header session state**: Session-scoped state files, incident mode priority,
  stale sweep, --session-id on all CLI commands.

## Recent Work

- 2026-04-20: Swarm investigation + Beads discovery. Built koma-web-fetch
  (5/5 tests) and koma-summarize-context (3/3 tests) with CommonLog wired
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
- 2026-04-15: Built apple-pi plugin architecture - `KomaAgentToolAdapter`
  bridges `Logikoma` -> `AgentTool` (JSON round-trip); `AgentPlugin` +
  `TurnContext` formalise `onTurnStart`/`onTurnEnd` hooks; `ProcessPlugin` +
  `ProcessPluginCommand: Codable` make any CLI tool a JSON-declarative turn
  lifecycle participant. 25 tests across 3 new test suites.
- 2026-04-14: Proved 5 core komo green end-to-end (echo, scan-directory,
  read-file, git, list) with 39 passing tests including on-device
  FoundationModels smart paths. Fleet inventory: 56 komo, 21 built.
