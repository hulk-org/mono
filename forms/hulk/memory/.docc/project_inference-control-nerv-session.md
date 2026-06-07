---
name: Inference Control NERV session state
description: 2026-04-22 session progress — NERV HQ aesthetic, hex badges, pacing warnings, fuse model; pickup points for next session
type: project
originSessionId: b4c9d58c-0196-4bd0-9c5d-e4accca62e6b
---
## What shipped this session (2026-04-22)

**Pacing engine upgrades:**
- `PaceUrgency` 5-tier enum (nominal → caution → warning → critical → alert)
- `PaceWarning` with cockpit callout strings ("BURN RATE CRITICAL", "SYNC RATIO LOW", etc.)
- `classifyUrgency()` combining pace delta with projected exhaustion time
- Menubar icon now reflects pacing urgency (was always the same icon)
- `BackgroundScanStore.highestPacingUrgency` + `.cockpitWarning` computed props

**NERV visual system:**
- `InferenceStatsStyle` palette: near-black canvas, NERV amber accent, extended nervGreen/nervAmber/nervRed
- All typography switched to `.monospaced` with tracking
- `NervSectionHeader` component with amber leading rule
- `NervHazardStripes` diagonal stripe Shape
- Sharp 3-4px corner radii replacing soft 10-16px rounds
- Leading amber/red rails on cards and sections

**Hex badge system:**
- `NervHexagon`, `NervHexArc`, `NervHexEdge` shapes
- `NervHexBadge` with three concentric countdown ring fuses:
  - Inner: session cooldown remaining
  - Middle: weekly TIME remaining (white, the clock)
  - Outer: weekly USAGE remaining (the fuse)
- Fuse color from weekly divergence: |usage - time| ≤ 5% = green, escalates to red
- Glass sweep + ring shimmer animations
- Edge-by-edge skeleton loader for standby state (gray, not colored)
- Four lifecycle states: standby → loading → online / offline
- 60s timeout from standby → offline
- Tap hex → triggerRefresh()

**Hex cluster layout:**
- `NervHexCluster` with honeycomb tessellation (adjacent, not overlapping)
- 170px hexes inline in the header
- Text left, hexes right, vertically centered

**Header:**
- NERV command center bar with hazard stripes (10px top, 6px bottom)
- Red gradient flash on alert (pulses from edges)
- Hidden title bar (`.windowStyle(.hiddenTitleBar)`)
- Badge-first warning line: ▌CRITICAL▐ then callout text

**Rename:**
- inference-metrics → inference-control (full rename: directory, xcodeproj, bundle IDs, type names, schemes, workspace ref)

## Pickup points

1. **Cadence state review** — hex badge state machine needs formalization (see project_inference-metrics-nerv-state.md)
2. **Claude shows STANDBY/NO AUTH** — OAuth token refresh may need investigation; the usage poller has the token but it might be expired
3. **Shimmer + glass animations** — running but could be tuned (timing, intensity)
4. **Pacing view cards** — still use the old style in the dashboard body; could bring NERV treatment deeper into the pace cards
5. **Menubar popover** — still has the cockpit banner but hasn't gotten the full NERV visual pass

## Wave 2 — Cross-App Integration (2026-04-23)

**Darwin notifications:** `BudgetGateObserver` in the shared package fires a Darwin notification (`me.rismay.inference-control.budget-gate.changed`) when the worst signal changes. Ghost Shell and Workflow observe instantly + keep 30s poll as fallback.

**Auto-generated budget-spend Beads:** `BudgetBeadGenerator` writes `bd-budget-spend-{provider}-{YYYYMMDD-HHmm}.json` to `~/mono/.wrkstrm/beads/issues/` when RED+BEHIND. One per provider per 30-min window. Raw JSON via JSONSerialization (no Beads schema import).

**Ghost Shell Phase 3:**
- Auto-throttle banner (RED+AHEAD: "SLOW DOWN" + Override button)
- Auto-encourage banner (RED+BEHIND: "SPEND NOW")
- Per-provider hex indicators (16px) + action labels in detail header
- 30s periodic budget refresh

**Workflow budget-aware queue:**
- Dashboard budget banner with per-provider signal/action/remaining%
- Ready queue context header (SPEND NOW / BUDGET CRITICAL)
- Issue row SPEND/HOLD badges
- Molecules encouraging banner when unblocked + behind
- Harness picker signal dots + red border

**Inference Control NERV polish:**
- Menubar popover: NERV header, hazard stripe, mini hex cluster (56px badges), budget gate summary, monospaced scan status
- Menubar label: shows urgency text at `.warning`+
- Sparklines: fill gradient, 1.0× label, latest point dot
- Progress bars: sharp corners, 25/50/75% tick marks
- Pacing summary cards: FUSE STATUS / WEEKLY BUDGET / SESSION WINDOW
- Budget gate card in pacing dashboard section
- NervHexagon + NervHexArc promoted to internal access

**Shared package:** `InferenceBudgetGate` now includes `BudgetGateObserver` for Darwin notification observation.

**How to apply:** next session on Inference Control, start from the hex badge system — it's the visual centerpiece. The fuse model is the core design language.
