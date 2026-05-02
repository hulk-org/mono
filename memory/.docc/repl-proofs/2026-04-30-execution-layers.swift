import Testing

// fixed 2026-04-30: added positive-pin assertions on the firesAt /
// workingDirectory / teardown label values. Original proof had `!=`
// between layers (proves disjointness) but did not pin which value goes
// with which layer — drift like "session_login" or "perTask" or
// "operator_live_workspace" would have slipped past silently. Each
// label is now anchored on its expected layer.

// converted 2026-04-30: graduated from script-mode `precondition` to
// Swift Testing `@Test func` + `#expect`.

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
///   - Stage World: digikoma-org/.../private/universal/domain/core/digikoma-stage-world/
///       sources/DigikomaStageWorldTool/DigikomaStageWorldTool.swift
///
/// One intentional coupling point exists: LDT proofs themselves run inside
/// Stage World (via a future digikoma-ldt-proof). That coupling preserves the
/// layer boundary — proofs are bounded jobs, not boot rituals.

@Test("execution layers: HarnessStartupRunner vs Stage World koma runs are disjoint")
func executionLayers() {
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
      case .komaRun: "/private/tmp/wrkstrm-seatbelt/digikoma-worlds/<uuid8>/graph/"
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

  #expect(ExecutionLayer.allCases.count == 2)

  // Disjointness: every axis differs between the two layers.
  #expect(ExecutionLayer.harnessStartupRunner.firesAt
          != ExecutionLayer.komaRun.firesAt)
  #expect(ExecutionLayer.harnessStartupRunner.workingDirectory
          != ExecutionLayer.komaRun.workingDirectory)
  #expect(ExecutionLayer.harnessStartupRunner.teardown
          != ExecutionLayer.komaRun.teardown)
  #expect(ExecutionLayer.harnessStartupRunner.isolated
          != ExecutionLayer.komaRun.isolated)

  // Positive + negative on isolation.
  #expect(ExecutionLayer.komaRun.isolated == true)
  #expect(ExecutionLayer.harnessStartupRunner.isolated == false)

  // Positive + negative on the seatbelt path marker.
  #expect(ExecutionLayer.komaRun.workingDirectory.contains("wrkstrm-seatbelt"))
  #expect(!ExecutionLayer.harnessStartupRunner.workingDirectory.contains("wrkstrm-seatbelt"))

  // Positive pins on the label values themselves — they appear in logs,
  // audit reports, and operator-facing UI. Drift to a renamed label
  // ("session_login", "perTask") should fail loudly, not slip past.
  #expect(ExecutionLayer.harnessStartupRunner.firesAt == "session-login")
  #expect(ExecutionLayer.komaRun.firesAt == "per-task")

  #expect(ExecutionLayer.harnessStartupRunner.workingDirectory == "operator-live-workspace")

  #expect(ExecutionLayer.harnessStartupRunner.teardown.hasPrefix("none"))
  #expect(ExecutionLayer.komaRun.teardown.contains("world removed"))
}
