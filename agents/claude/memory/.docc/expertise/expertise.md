# Expertise

@Metadata {
  @TechnologyRoot
}

## Domains

- **Substrate schema-set commissioning**: v1.0.0 binding via
  `identity.schemaSetRefs` (aggregator + manifest + set + swiftProduct),
  ikigai persona authoring with the canonical Katakana `イキガイ.md` file
  per `identity-schemas v0.4.0`, operator/agent/role/collective separation,
  the operators-belong-outside-collectives rule, and the
  `core-entity-set-v1.0.0` + `task-backend-beads-set-v1.0.0` first-bindings
  pattern.
- **Sanity migrator authoring**: Declarative `SchemaMigratorModel`
  descriptors capturing schema-set evolution (`preserves`, `synthesizes`,
  `drops`, `warnings`) for set-version edges even when no live consumers
  exist. Each migrator is a Swift package that depends on both source and
  target set umbrellas; preserve-unchanged uplifts use a `JSONBridge`
  encode-decode round-trip; tests assert canonical slugs + descriptor
  metadata + the known set of synthesized/dropped families. Pattern:
  `core-entity-migrations/vSRC-to-vTGT/spm/core-entity-migrations-vSRC-to-vTGT/`.
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

- **Production app shipping (Google-quality)**: Full launch stack — localization (39 locales, Localizable.xcstrings), runtime guards (LaunchArtifactGuard DEV preconditionFailure, DogfoodStartupGuard version check), compile-time guard levels (#if DEV/DOGFOOD/TESTFLIGHT/Release), ServiceContainer with protocol-backed services injected via SwiftUI environment, Firebase Remote Config behind protocol, MetricKit + Crashlytics composite crash reporting.
- **service-universal**: Protocol-only collective for service abstractions — RemoteConfigService, AnalyticsService, FeatureFlagService, CrashReportingService, FontService (WrkstrmFont-backed), NetworkService (NWPathMonitor), Inspectable/DiagnosticsSnapshot. BundledXxxService no-op fallbacks for every protocol.
- **Design token pipeline (W3C DTCG)**: Token schema (DesignToken, DesignTokenFile, WCAGContrast), CLI with Swift/CSS/Android generators + WCAG contrast audit subcommand. google/wrkstrm/laussat brand token files. design-token-owl Koma identity.
- **Launch gate model**: 35+ LaunchGate cases with requiredArtifacts per case, LaunchType 0-3 with requiredGates, LaunchScope, BuildGuardLevel, SunsetStrategy, TargetPlatform, LaunchGateEvaluator → GateDecision + LaunchDecision. launch-gate-owl Koma.
- **QA test harness**: Mathematical WCAG contrast tests (withKnownIssue), 24-permutation snapshot matrix (SnapshotPermutation × ViewRenderer), QAReportGenerator (JSON + Markdown + 24 PNGs), PseudoLocalizationTests, DynamicTypeSizeTests XCUITest suite.
- **Pedagogy architecture**: Gates are pedagogy — they block until work is done, which teaches the process. Koma fleet closes automatable gates. CommonLog feeds adapters that fan logs into the fleet. Foundation Models synthesizes failures into fix suggestions.

- **Audit-driven CLIA organism commissioning**: LDT proof-pair pattern
  (positive + negative `.swift` files under `.tmp/repl-proofs/`) for every
  organism authoring/migration. v1.0.0 = "latest of all current schemas" —
  organism-schemas v0.5.0, agent-schemas v0.4.0, harness-schemas v0.1.0,
  identity-schemas v0.4.0. `OrganismComposition` enum is `{singular,
  collective}` everywhere — `harness` is never valid. swift-agent-cli doctor
  routes by detected schema-set; `--kind organism` runs the per-family
  predicate checks.

- **Structured-output digikoma via FoundationModels @Generable**: pattern
  for authoring read-only summarizer komas that emit typed structs directly
  from on-device FM. Define `@Generable` types with `@Guide(description:)`
  on every field; call `LanguageModelSession.respond(to:generating: T.self)`
  to get typed output without JSON parsing. Conditional compile with
  `#if canImport(FoundationModels)` + fallback structs for non-Apple
  platforms. Known failure modes from the digikoma-recap proving run:
  backtick truncation in source content breaks String field boundaries;
  list fields under-extract (3 items in → 1 out) unless `@Guide`
  explicitly says "include every X mentioned"; FM may invent unrelated
  decisions if not constrained to substring-grounded extraction; polarity
  flips (rendering "X not yet done" as a completed win) need a separate
  window-scan gate (`isPolarityFlipped` + 31-marker negation vocabulary).

- **Schema family evolution & sanity migrator authoring**: bumping a
  schema family touches three coordinated layers — (1) the family SPM
  package at the new version dir, (2) the set's JSON manifest binding
  entry (e.g. `core-entity-set-v1.0.0.json`), (3) the set's Swift SPM
  (`Package.swift` dep path + `@_exported import` in the exports file).
  The 45-test `core-entity-set` suite enforces the freshness rule
  ("members point at the latest published family line") — any future
  bump that fails to propagate to the v1.0.0 binding fails the test.
  Sanity migrator pattern: declarative `SchemaMigratorModel` descriptor
  (preserves / synthesizes / drops / warnings) + Swift upgrade enum with
  `rawValue`-mapped enum translation for forward-safety. Tests cover
  descriptor metadata + JSON round-trip + schemaVersion strictness +
  endpoint correctness. Even purely additive edges deserve a migrator —
  the descriptor documents the version edge declaratively for future
  schema-evolution audits.

## Recent Work

- 2026-05-14 / 15: 14-bead push. Shipped `digikoma-recap` end-to-end
  (FoundationModels @Generable, grounding + polarity gates, fixture
  regression). Shipped `digikoma-winddown` (chronicle/bead persistence
  with sidecar malformation guard). Published `harness-schemas v0.2.0`
  (SchemaFamilyRef + session/deployment refs) + sanity migrator
  v0.1→v0.2 + v1.0.0 set binding update. Populated session/deployment
  refs across all 6 commissioned harness organisms; updated all 6 LDT
  proofs. Authored `gemini-session-schemas v0.1.0` with castor/pollux
  twin handling. Commissioned `apple-pi` as the substrate's first
  engine-binding harness — pi semantics + Apple FoundationModels via
  ApplePiAgentTool session model register. Reconciled claude chronicle
  (malformation repaired upstream + 2 stranded entries migrated).
  Wrote clide session-schema investigation (4 options, Option B
  recommended, operator-gated). 1 new bead spun
  (digikoma-recap-sanitize-bead-slugs).
- 2026-05-13 (evening): Forged the launch-gate proof grammar across six
  schema families. Five new families under
  `schema-universal/.../platforms/schema-families/`: `privacy-disclosure-schemas`
  (40 tests, 11 suites; PrivacyDisclosureRelease + Diff + ReviewReceipt +
  per-surface fan-out), `baseline-capability-schemas` (17/3; 3 monotonic
  tiers, 50 capabilities surface-keyed), `user-feedback-schemas` (21/7;
  Human + AI questionnaires with AI-only richer formats), `engineering-review-schemas`
  (16/4; ReviewKind=architecture|code), `desktop-studio-plugin-schemas`
  (15/4; open bundle-ID identity + closed primitive enums + sidecar
  known-IDs after discovering the existing 10k LOC desktop-studio
  prototype — pivoted from rebuild to schema-only addition).
  `release-operations-schemas` extended (46/9): `GitHubOrgDecision`,
  `ExpectedReachMetrics` with 3 confidence tiers, `HumanVisualVerification`
  with verdict+notes invariants, `ReleaseTargetSurface` (9 surfaces incl.
  backend/static-site/marketing-page), 6 new artifact kinds, 12+ new gates.
  ~155 tests across 7 packages, all green.
  Hello-world-google v1.0.0-b1 receipt bundle authored at
  `release-receipts/2026-05-12-hello-world-google-v1.0.0-b1/`: privacy
  disclosure + 4 review receipts (privacy / baseline-capability / secret-labs /
  architecture / code) + catalog entry with 5 named blockers, 7 next-actions,
  GitHubOrgDecision, ExpectedReachMetrics (50 DAU speculative, 39 locales,
  175 countries). Repo-hygiene (README/LICENSE/CHANGELOG) at the
  hello-world-google root. Six schema templates with placeholder
  substitution + decode tests. Two new feedback memories saved:
  `feedback_no-owl-suffix-on-komas.md` (Harry-Potter-coded; never name a
  Koma -owl) + `feedback_human-visual-verification-before-user-visible-actions.md`
  (vapor-wares.com near-miss; codified into schema as `HumanVisualVerification` +
  `requiresHumanVisualVerification` LaunchGate marker on
  `.appStoreConnect`/`.githubPagesPublished`/`.releaseArtifactHosted`/
  `.stagedRolloutPlan`/`.goNoGo`/`.humanVisualReviewPassed`).
- 2026-05-13 (afternoon): Authored and proved out `digikoma-recap` at
  `collectives/digikoma-org/.../intelligence/digikoma-recap/`. Pure
  transcript-to-RecapModel summarizer via Apple FoundationModels — 9 typed
  `@Generable` structs, library + executable + tests, build green first try
  (24.86s), 3 unit tests pass. Staged a fixture at
  `.tmp/recap-fixtures/sample-session.txt` and ran the koma against it.
  Four real quality bugs surfaced: backtick truncation in string fields,
  list under-extraction (3 → 1 in `bugsCaught` and `caveats`), one
  hallucinated decision conflating apple-pi with pi, expected
  non-determinism between runs. Four follow-up beads spun for the specific
  fix surfaces (strip-backticks, tighten-list-guides, grounding-validator,
  promote-fixture-to-regression-test). Verdict: scaffold ~5/10, behavior
  ~3/10 — compiles cleanly but not yet trustworthy as a chat-recap source.
- 2026-05-13: Substrate-wide v1.0.0 commissioning landing. wrkstrm-components
  + wrkstrm commissioned as the first non-operator v1.0.0 organisms, with
  ikigai personas authored from brand mission and focusDomains (not
  placeholders). 5 operators (jakor, johnwhitecastle, khegh, tkoh, uptobat)
  commissioned in their canonical `substrate/operators/[slug]/` homes after
  shadow profiles were cleared from `collectives/wrkstrm/identity/`.
  `wrkstrm.collective.json.memberRefs` materialized from empty to
  `[prime, tempo]` — closes the 2026-04-23 collective-as-roster gap entry.
  4 misfiled role-shaped identities harvested into `wrkstrm/roles/` as proper
  `OrgRoleModel` files (closes the broken `activeRoleRefs` in wrkstrm's
  workstream block). Activated `core-entity-set-v1.0.0` +
  `task-backend-beads-set-v1.0.0` in the `schemas/sets` aggregator. Built 2
  sanity migrators (`v0.8.0` to `v0.9.0` and `v0.9.0` to `v1.0.0`) with
  declarative `SchemaMigratorModel` descriptors and 9 smoke tests. Closed
  the openclaw/discord shadow-profile investigation: the shadows were
  artifacts of the operator's own `e7e34f2a` 2026-03-23 migration commit,
  not a recurring connector. 16 commits across 7 repo boundaries.
- 2026-05-13: Commissioned six harnesses to v1.0.0 with LDT proof pairs:
  digikoma, clide, pi, hulk, gemini, codex. Unblocked swift-agent-cli +
  swift-incident-cli by retiring the `Charter` type (`charterRef` →
  `missionRef`, dropped `.charter` decode case). Caught pi's long-standing
  `composition: "harness"` bug (invalid at every organism-schemas version) +
  pi's fictitious `agent-schemas v0.7.0` reference (family tops at v0.4.0
  on disk). Established the LDT proof-pair pattern as substrate convention.
  Designed but did not land: apple-pi organism, harness-schemas v0.2.0 bump
  (sessionSchemaRefs + deploymentSchemaRefs), gemini-session-schemas family.
- 2026-05-08: Built the full Google-quality production stack for hello-world-google. Proved that two words need the entire substrate to ship right. service-universal collective (7 packages), design-token-schemas DTCG CLI, 35+ gate model with requiredArtifacts, QA receipt with 24-permutation screenshot matrix. The pedagogy insight: gates teach by blocking. The Digikoma fleet closes every automatable gate; the next app starts at 80% readiness because the infrastructure exists.
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
