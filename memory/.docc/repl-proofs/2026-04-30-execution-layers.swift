// fixed 2026-04-30: added positive-pin assertions on the firesAt /
// workingDirectory / teardown label values. Original proof had `!=`
// between layers (proves disjointness) but did not pin which value goes
// with which layer — drift like "session_login" or "perTask" or
// "operator_live_workspace" would have slipped past silently. Each
// label is now anchored on its expected layer.

/// Claim: HarnessStartupRunner and Stage World koma runs are separate
/// execution layers. They differ on every observable axis — when they fire,
/// where they run, whether isolation is provided, what teardown looks like.
/// Conflating them produces blast-radius surprises: a "test" that mutates
/// the live workspace, or a "boot step" that fails because it expected
/// fixtures.
///
/// Source of truth:
///   - Runner: swift-harness-environment-cli/Sources/SwiftHarnessEnvironment/
///       HarnessStartupRunner.swift
///   - Stage World: koma-org/.../private/universal/domain/core/koma-stage-world/
///       sources/KomaStageWorldTool/KomaStageWorldTool.swift
///
/// One intentional coupling point exists: LDT proofs themselves run inside
/// Stage World (via a future koma-ldt-proof). That coupling preserves the
/// layer boundary — proofs are bounded jobs, not boot rituals.
///
/// Run: `swift <this-file>` — exits 0 and prints `ok: …` on success.

enum ExecutionLayer: String, CaseIterable {
  case harnessStartupRunner
  case komaRun

  var firesAt: String {
    switch self {
    case .harnessStartupRunner: "session-login"
    case .komaRun: "per-task"
    }
  }

  var workingDirectory: String {
    switch self {
    case .harnessStartupRunner: "operator-live-workspace"
    case .komaRun: "/private/tmp/wrkstrm-seatbelt/koma-worlds/<uuid8>/graph/"
    }
  }

  var isolated: Bool {
    switch self {
    case .harnessStartupRunner: false
    case .komaRun: true
    }
  }

  var teardown: String {
    switch self {
    case .harnessStartupRunner: "none — surfaces remain touched in live tree"
    case .komaRun: "world removed unless --keep"
    }
  }
}

precondition(ExecutionLayer.allCases.count == 2)

precondition(ExecutionLayer.harnessStartupRunner.firesAt
             != ExecutionLayer.komaRun.firesAt)
precondition(ExecutionLayer.harnessStartupRunner.workingDirectory
             != ExecutionLayer.komaRun.workingDirectory)
precondition(ExecutionLayer.harnessStartupRunner.teardown
             != ExecutionLayer.komaRun.teardown)
precondition(ExecutionLayer.harnessStartupRunner.isolated
             != ExecutionLayer.komaRun.isolated)

precondition(ExecutionLayer.komaRun.isolated == true)
precondition(ExecutionLayer.harnessStartupRunner.isolated == false)

precondition(ExecutionLayer.komaRun.workingDirectory.contains("wrkstrm-seatbelt"))
precondition(!ExecutionLayer.harnessStartupRunner.workingDirectory.contains("wrkstrm-seatbelt"))

// Positive pins: the label values themselves carry meaning — they appear
// in logs, in audit reports, in operator-facing UI. Drift to a renamed
// label ("session_login", "perTask") should fail loudly, not slip past.
precondition(ExecutionLayer.harnessStartupRunner.firesAt == "session-login")
precondition(ExecutionLayer.komaRun.firesAt == "per-task")

precondition(ExecutionLayer.harnessStartupRunner.workingDirectory == "operator-live-workspace")

precondition(ExecutionLayer.harnessStartupRunner.teardown.hasPrefix("none"))
precondition(ExecutionLayer.komaRun.teardown.contains("world removed"))

print("ok: 2 execution layers, separated on every axis; labels positive-pinned; 'wrkstrm-seatbelt' is the koma-only path marker")
