# NERV Inference Control + Cross-App Budget Gate

Session spanning 2026-04-22 to 2026-04-23. Massive build session: Inference Control got the full EVA/NERV treatment, a cross-app budget gate was wired between three apps, and the harness header now shows budget fuse status on every startup.

## What Shipped

### Inference Control (NERV Command Center)
- Pacing engine: 5-tier urgency (nominal/caution/warning/critical/alert) with cockpit callout strings
- 170px hex badges with three concentric countdown rings (session cooldown, weekly time, weekly usage)
- Fuse model: ring color derived from weekly divergence (usage vs time remaining)
- Glass sweep + ring shimmer animations, edge-sweep skeleton loading for standby state
- NERV header: hazard stripes, amber leading rails, monospaced typography throughout
- Hidden title bar, directional warning banners (SPEND NOW / SLOW DOWN)
- Mini hex cluster in menubar popover
- Menubar icon + urgency text label
- Sparklines: fill gradient, 1.0x reference label, latest point dot
- Full rename from inference-metrics to inference-control

### InferenceBudgetGate SPM Package
- Shared Codable types: BudgetGateState, BudgetSignal, BudgetDirection, ProviderBudgetSnapshot
- Publisher (writes to shared UserDefaults every poll cycle)
- Reader with directional canSpawn() and shouldEncourageSpend()
- Darwin notification observer for instant cross-app propagation
- Platform lowered to macOS 13 for CLI compatibility

### Ghost Shell Integration
- Phase 1: advisory logging on spawn
- Phase 2: per-provider hex indicators + action labels in detail header
- Phase 3: auto-throttle banner (RED+AHEAD) with Override, auto-encourage banner (RED+BEHIND), 30s periodic refresh

### Workflow Integration
- Dashboard budget banner with per-provider signal/action/remaining%
- Ready queue SPEND/HOLD badges on issues
- Molecules encouraging overlay when unblocked + budget behind
- Harness picker signal dots + red border on exhausted providers
- Transport wheel budget warning

### Harness Header
- swift-harness-environment-cli renders `BUDGET: SPEND NOW . Claude 99% expiring` on every startup
- Leads with the action (SPEND NOW / SLOW DOWN / ON PACE), not just the signal color
- Provider labels show "expiring" (behind) vs "remaining" (ahead)

### Budget-Spend Bead Generation
- BudgetBeadGenerator auto-writes Bead issues when RED+BEHIND
- One per provider per 30-min window to ~/mono/.wrkstrm/beads/issues/
- Turns budget waste into claimable work in Workflow's ready queue

### Reset Time Drift Buffer
- Provider resets_at timestamps are ~2 hours late vs actual resets
- 2-hour safety buffer subtracted from all reset times in the pacing engine
- Warnings arrive before the window closes, not after

## Key Design Decision

RED is directional. RED+BEHIND = "SPEND NOW" (allocation expiring, you're wasting money). RED+AHEAD = "SLOW DOWN" (burning too fast, will hit cap). The entire system speaks this language consistently.

## Artifacts
- InferenceBudgetGate: `wrkstrm-app/private/cross/spm/inference-budget-gate/`
- Inference Control: `wrkstrm-app/private/apple/apps/inference-control/`
- Ghost Shell: `wrkstrm-app/private/apple/apps/ghost-shell/`
- Workflow: `wrkstrm-app/private/apple/apps/workflow/`
- Harness CLI: `wrkstrm-core/private/cross/spm/swift-harness-environment-cli/`
