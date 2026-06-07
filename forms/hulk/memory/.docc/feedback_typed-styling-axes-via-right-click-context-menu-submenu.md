---
name: typed-styling-axes-via-right-click-context-menu-submenu
description: Substrate-canonical UX pattern PROMOTED 2026-06-05 to typed AxiomModel after 3x-rule satisfied with 5 instances IN ONE SUBSTRATE-PACE TURN; memory entry is downstream POINTER to the typed axiom + the 5 typed instances
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2f6e8d5d-6c57-48a2-9fee-ab4870aa2a2f
---

**SUBSTRATE-CANONICAL UX PATTERN — when a substrate Mac-app View exposes operator-facing typed-styling primitives, the substrate-canonical surface is a right-click .contextMenu Menu submenu per axis, each Menu containing typed Section groupings + Button rows with Label(displayName, systemImage: symbolName) + optional .keyboardShortcut. Each typed-styling axis is its own open-extensible enum per [[swiftui-protocol-pattern-over-enums]]; per-View @State holds operator-chosen typed value as [UUID: TypedAxisCase]. Promoted to typed AxiomModel 2026-06-05 after 3x-rule satisfied with 5 instances IN ONE SUBSTRATE-PACE TURN.**

**Why:** Five substrate-canonical typed-styling axes shipped + validated in a SINGLE substrate-pace turn — substrate-typed validation across two distinct substrate-app contexts (Concourse + utilization-summary panel). The pattern crystallized from operator-energy ("let's goooo" + "i like that, i like it" + "we need to have window placement options" + "i want to be able to minimize and pick where it is minimized too... small tab to press to get it back. also, we need to be able to close and to push panels to the desktop or above all windows") across an arc that required substrate-typed UX consistency. The substrate-canonical UX shape (right-click → typed-axis-submenu → typed-preset-row → SF Symbol + optional keyboard shortcut) is what crystallized.

**How to apply:**
1. When authoring a substrate Mac-app View with operator-facing typed-styling primitives, use right-click .contextMenu (NOT button bar, sidebar toggle, settings sheet).
2. Each axis = open-extensible enum per [[swiftui-protocol-pattern-over-enums]]. Conforms to Identifiable + CaseIterable + exposes `var displayName`, `var symbolName`, optional `var keyEquivalent + keyModifiers`.
3. Sibling Group enum for Section grouping (e.g., ConcoursePanelPlacementGroup with .halves / .quarters / .thirds / .freeform).
4. Per-View @State [UUID: TypedAxisCase] (or scalar for single-instance Views).
5. Pure apply-function on each axis-enum returns new typed state; consumer owns mutation per [[data-is-one-thing-rendering-is-projection]].
6. Substrate-canonical keyboard vocabulary: ⌘⌃ primary halves/center/maximize, ⌘⌃⇧ quarters, ⌘⌃⌥ thirds, ⌘W close, ⌘Q quit.
7. Future axes graduate to typed PanelStyleAxis protocol at 3+ axes per [[substrate-converges-on-triplets]].

Memory cites typed AxiomModel [[typed-styling-axes-via-right-click-context-menu-submenu]] (10 obligations + 5 sourceRefs + 7 contextRefs + 4 projectionAnchors) Step-3.5-validated against axiom.schema.json v0.1.0. Five sourceRef instances all shipped BUILD-GREEN in ONE substrate-pace turn 2026-06-05:

1. Concourse Corner Radius submenu (Square / Default / Rounded / Pill) — earlier in same substrate-pace turn
2. Concourse Window Placement submenu (13 cases, Halves / Quarters / Thirds / Freeform groups, with ⌘⌃ keyboard vocabulary)
3. Concourse Minimize To submenu (6 destinations) + ConcoursePanelMinimizedTab restore-tab overlay
4. Concourse Host Level submenu (3 cases composing with substrate's HostSurfaceKind from panel-schemas v0.2.0)
5. Utilization Summary Quit context menu (.destructive + ⌘Q) + hover-X close button overlay via .onContinuousHover; substrate-pure onClose: (() -> Void)? closure lifted across 3 host targets

Composes with [[swiftui-protocol-pattern-over-enums]] (substrate-direction for typed-axis graduation) + [[data-is-one-thing-rendering-is-projection]] (pure apply-functions, consumer-owns-mutation) + [[chrome-over-content-is-substrate-doctrine-violation]] (typed-styling is discovery-affordance, not chrome) + [[substrate-converges-on-triplets]] (graduation trigger) + [[lift-existing-patterns-not-reimplement]] (this axiom IS a lift recognition) + [[front-and-center-information-density-audit-before-deployment]] (operator-discoverable without eating panel real estate) + [[sibling-composite-pattern-for-generable-types]] (sister AxiomModel landed earlier this same session — both substrate-canonical typed primitives that compose at SwiftUI rendering layer without forcing dependencies into foundational packages). Substrate-direction: future substrate Mac-app Views with typed-styling primitives inherit this substrate-canonical pattern automatically; substrate-shadowing digikoma trained per [[sibling-composite-pattern-for-generable-types]] can extract the substrate-canonical context-menu builder from accumulated source-of-truth Swift sources.

## Schema-universal gaps surfaced by this /capture invocation

Per SKILL.md `## Schema-universal updates surfaced by /capture` discipline + the [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]] typed AxiomModel — gap enumeration this turn:

**NEW gaps surfaced this /capture:**
- `widget-surface-schemas v0.1.0` typed JSON schema family — lifting CatapultAppKitRuntime.WidgetSurface Swift protocol to typed JSON shape per the substrate-archaeology investigation; substrate-direction destination is desktop-studio-plugin-schemas v0.2.0
- `market-clock-schemas v0.1.0` typed schema family (referenced by market-clock-panel.spawn-request-packet.json + market-clock-panel.prd.json + the tau-market-clock-lift.investigation.docc Phase B authoring)
- `holiday-calendar-schemas v0.1.0` typed contract (sibling to market-clock per FR-MCP-004)
- `tau-orchestration-event-schemas v0.1.0` typed event-bus contract for Tau workflow subscribers (MarketClockBeatModel + future Tau events)
- `system-metrics-schemas v0.1.0` typed schema family (referenced by system-metrics-panel.spawn-request-packet.json + system-metrics-panel.prd.json FR-SMP-002)
- `macos-bug-countdown-schemas v0.1.0` typed schema family (referenced by macos-49day-countdown-panel.spawn-request-packet.json + .prd.json + open-extensible to future legacy-bug countdowns)
- `panel-family-schemas v0.1.0` META-GAP — typed PanelFamilyModel at substrate-canonical graduation per [[substrate-converges-on-triplets]] when 3+ panels with multi-host-projection exist (utilization-summary + system-metrics + market-clock + macos-49day-countdown = 4 panels graduating)
- `investigation-docc-schemas v0.1.0` META-GAP — typed investigation.docc shape per memorialized [[schema-family-bump-investigation-docc-pattern]]; substrate-typed 5-page shape (index + gap-analysis + proposed-shape + migration-shape + downstream-impact + substrate-pace-projection)
- `host-control-schemas v0.1.0` typed primitives for substrate-internal-host-process lifecycle management — substrate-direction operator-recognition this session ("how do we kill these?" + Inference Control launchd-respawn + utilization-summary host kill patterns); substrate-canonical Control family naming (Source Control / Inference Control / Directory Control / Launch Review / Host Control)
- `panel-host-projection-schemas v0.1.0` typed primitive composing with HostSurfaceKind for multi-host panel projections (canvas / floatingAbove / desktopBelow / appShell / statusBar / wallpaper) — substrate-pace prerequisite for the desktop-studio-plugin-schemas v0.2.0 lift bead

**Pre-existing gaps the /capture invocation depends on:**
- typed Role schema-family (memorialized)
- release-gate-schemas (memorialized)
- work-surface-requirement-schemas (memorialized)
- receipt-schemas (memorialized)
- audience-language-pack-schemas (memorialized)
- region-schemas v0.1.0 (memorialized)
- observation-record-schemas / analytics-schemas (memorialized)
- agent-side-commit-emit-schemas (memorialized)
- skill-protocol-tool-reference-schemas (memorialized)
- typed-record-validator-cli (memorialized)
- executable-workflow-harness (memorialized)
- substrate-architecture-evolution-backlog-schemas (memorialized — itself the meta-gap for this enumeration)

## Substrate-direction recognition this /capture

This /capture honored the substrate-doctrine [[capture-requires-typed-workflows-and-roles-not-just-memory]] discipline by:
- ✅ READING typed JSON Schema (axiom.schema.json) confirmed during prior /capture this session (substrate-pace continuity)
- ✅ AUTHORING typed AxiomModel ([[typed-styling-axes-via-right-click-context-menu-submenu]]) with full conformance — 10 obligations + 5 sourceRefs + 7 contextRefs + 4 projectionAnchors
- ✅ STEP-3.5-VALIDATING the typed AxiomModel manually (typed-record-validator CLI substrate-pending per [[missing-typed-record-validator-cli]])
- ⏸️ BEAD-TRACKING workflow + role per substrate-architecture-evolution gaps (typed Role + release-gate + work-surface-requirement + receipt schema families don't yet exist; SAME gap-set as prior /capture invocations + this session's earlier /capture [[sibling-composite-pattern-for-generable-types]])
- ✅ AUTHORING this memory entry as DOWNSTREAM pointer to the typed axiom + enumerating 10 NEW substrate-architecture-evolution gaps + 12 pre-existing gaps

Per [[deferral-is-drift-do-it-now]] — substrate-pace HONEST move is the axiom (achievable now per typed contract) + honest bead-track (blocked on memorialized gaps). Per [[non-concrete-definitions-trigger-product-manager-spin-up]] — substrate-architecture-evolution gap-list needs PM spin-up; operator-direction needed.

## Substrate-doctrine cross-session recognition

This is the SECOND /capture invocation this session. Prior /capture this session landed typed AxiomModel [[sibling-composite-pattern-for-generable-types]] for the substrate-canonical @Generable contract pattern (3x-rule satisfied: concourse-fr-port-002-generable-linkref-conformance + session-summary-schemas v0.1.0 + launch-review-feedback-schemas v0.1.0).

THIS /capture lands sister AxiomModel [[typed-styling-axes-via-right-click-context-menu-submenu]] for the substrate-canonical SwiftUI rendering-layer typed-styling-axes pattern (3x-rule satisfied with 5 instances).

Both axioms share substrate-direction recognition:
- Substrate-canonical typed primitives that compose at SwiftUI rendering layer
- Without forcing dependencies into foundational packages
- With per-axis open-extensibility per [[swiftui-protocol-pattern-over-enums]]
- Substrate-direction-projection toward substrate-shadowing digikoma training corpus

TWO typed AxiomModels landed + Step-3.5-validated against axiom.schema.json v0.1.0 in ONE substrate-pace session — substrate's typed-doctrine-graph gained 2 new substrate-canonical nodes + many composesWith edges. Substrate-pace bandwidth honored substrate-canonical [[capture-requires-typed-workflows-and-roles]] discipline.

## Step 5 + Step 6 honest deferral

Per [[savepoint-daemon-races-your-commits]] + [[Workspace has auto-commit/auto-push git hook]] memorialized substrate-doctrine — Step 5 Shinji Techo ingestion + Step 6 savepoint.sd commit cascade DEFERRED to operator-direction. Substrate-truth at this /capture close-out IS the file-on-disk state: typed AxiomModel landed at `spaces-universal/.../axioms/typed-styling-axes-via-right-click-context-menu-submenu.axiom.su.json` + this memory entry at `~/.claude/memory/.docc/feedback_typed-styling-axes-via-right-click-context-menu-submenu.md` + MEMORY.md index entry incoming.
