---
name: Ghost-shell and koma-plant session followups
description: Post-session work items from the 2026-04-20/21 ghost-shell rebuild and clia-app-org condensation
type: project
originSessionId: 2a54098a-bc60-4237-aace-febc407917a3
---
Followup items from the ghost-shell observer rebuild and app surface condensation session.

**Why:** These were identified during the session but deferred to avoid scope creep. Each is load-bearing for the next phase of work.

**How to apply:** Pick these up in priority order; the concurrent stress test is the most time-sensitive (validates the experiment framework before more runs).

## Ghost-shell

1. **Concurrent stress test** — long-hold ▶ for 4 simultaneous ghosts. Predicted: all hit contextExceeded at N≈5-7, thermal rises to fair/serious, fp latency increases from ANE contention. This is the next experiment.
2. **Host environment capture (#2 from gap analysis)** — GhostImprint captures host at start/end, but GhostRun itself doesn't store HostSnapshot per-run. Multi-run sessions on different machines need per-run host state.
3. **Subprocess shell wiring** — the subprocess sidebar entry is a placeholder. Wire `Process` + `NSXPCListener` to launch `bin/ghost-shell` and receive `GhostTelemetry` callbacks over XPC.
4. **Long-hold progressive ramp** — currently fires once at a single tier. Should escalate 2→4→8→16→32→64 the longer you hold, not just cycle on repeated long-presses.
5. **Per-run detail view** — clicking a run should show its full timing data, piece latencies, host snapshot, and terminus detail.
6. **Session record saving path** — the hypothesis expects evidence at `~/Library/Application Support/ghost-shell/sessions/v000_000_000/`. Current code saves to `.../imprints/v000_000_001/`. Reconcile or document the divergence.
7. **Shared KomaMode/GhostMode package** — identical enums in two repos. Extract to a shared domain package to make the vocabulary a type-level contract.
8. **Clean DerivedData relics** — stale ghost-shell builds at `ghost-shell-fsyzfhvcmknzutdfjarkfkevsgib` and others in DerivedData can be removed.

## Koma-plant

9. **Deeper Liquid Glass pass** — fleet graph background, Koma detail sections (Identity, Primitive role, Definition surfaces), and sub-views still use opaque green palette. Second pass needed.
10. **Wire KomaMode into fleet/deployment views** — KomaMode.swift exists but isn't yet used in the UI. Per-Komo mode badges and deployment metric strips should appear in fleet detail.
11. **KomaDeploymentMetricsStrip with real data** — currently defined but not wired to live signals. Needs telemetry from actual Komo runs to populate success rate, chaos, and contribution delta.

## clia-app-org

12. **Continue condensation** — clia-sop (2 files), clia-cli (2 files), clia-kit (4 files, no xcodeproj) are candidates for absorption or retirement. Read their sources before deciding.
13. **clia-box and clia-vms assessment** — clia-box (4 files) and clia-vms (21 files, largest dormant) need evaluation for what to keep.

## wrkstrm-performance

14. **Glyph-glitch exploration** — Japanese/English text that glitches between scripts in a label. Discussed but not started. Rendering layer TBD (SwiftUI Text + Timer vs Core Text vs Metal).
