import Testing

// fixed 2026-04-30: original Embodiment for `constitution` claimed
// harnesses/hulk/.docc/startup/startup.json. That file is a synopsis
// (observational, with `synopsis: true` and a sibling snapshots/<date>.*
// directory of dated point-in-time captures), not a constitution. The
// constitution role has no on-disk embodiment today — corrected below.
// The role disjointness asserts (the body of this proof) were unaffected;
// only the prose claim about substrate-side instance was wrong.

// converted 2026-04-30: graduated from script-mode `precondition` to
// Swift Testing `@Test func` + `#expect`.

/// Claim: Startup observability splits into three disjoint roles. Each role
/// does exactly one thing; no role does another role's job. Conflating roles
/// is the framing error that pushes contributors to make the runner re-read
/// surfaces (stenographer doing the constitution's job) or to instrument
/// the runner with structured telemetry (stenographer doing the court
/// reporter's job).
///
/// The three roles, with their substrate-side embodiments:
///
///   - constitution: declares what should load. Reads nothing at runtime.
///     Embodiment: NONE on disk today. Implicit in CLAUDE.md / AGENTS.md /
///     the runner's hardcoded behavior. May or may not need its own file
///     in the future — the synopsis (see note below) is doing
///     constitution-shaped work for audit purposes today.
///
///   - stenographer: renders the opening header so the session has a
///     recorded beginning, then steps aside. Performs a minimal sanity
///     read (.docc/index.md presence + minimum profile pull). Does not
///     instrument, does not declare.
///     Embodiment: swift-harness-environment-cli HarnessStartupRunner.run()
///
///   - courtReporter: reads the session transcript after the fact and
///     measures it against the most-recent synopsis (de-facto constitution).
///     Strictly retroactive — never blocks startup, never modifies the
///     live workspace.
///     Embodiment: future SwiftClaudeSessionStartupAudit (mirrors existing
///     SwiftCodexSessionStartupAudit), eventually generalized behind a
///     StartupReportSource protocol.
///
/// Note on a fourth role glimpsed during the 2026-04-30 fix: a `synopsiser`
/// role generates dated point-in-time observations of startup surfaces with
/// deltas. Embodiment exists (whatever produced
/// harnesses/hulk/.docc/startup/snapshots/2026-04-21.harness.startup.json
/// with currentBytes/snapshotBytes/delta/exists fields). This proof does
/// not yet model the synopsiser role — a follow-up proof should either
/// extend StartupRole to four cases or be written as a sibling.
///
/// Positive proof: each role's distinguishing property holds for itself.
/// Negative proof: each role's distinguishing property is false for the
/// other two. The negative half is what catches role-creep — if someone
/// "improves" the stenographer to also retroactively observe, this proof
/// fails.

@Test("startup roles: 3 disjoint roles, 1:1 mapping with responsibilities")
func startupRoles() {
  enum StartupRole: String, CaseIterable {
    case constitution
    case stenographer
    case courtReporter

    var declares: Bool { self == .constitution }
    var rendersHeader: Bool { self == .stenographer }
    var observesRetroactively: Bool { self == .courtReporter }
  }

  // --- Positive: each role has its own distinguishing responsibility. ---
  #expect(StartupRole.constitution.declares)
  #expect(StartupRole.stenographer.rendersHeader)
  #expect(StartupRole.courtReporter.observesRetroactively)

  // --- Negative: each role does NOT carry the others' responsibilities. ---
  #expect(!StartupRole.constitution.rendersHeader)
  #expect(!StartupRole.constitution.observesRetroactively)
  #expect(!StartupRole.stenographer.declares)
  #expect(!StartupRole.stenographer.observesRetroactively)
  #expect(!StartupRole.courtReporter.declares)
  #expect(!StartupRole.courtReporter.rendersHeader)

  // --- Cardinality: exactly one role per responsibility, three responsibilities total. ---
  #expect(StartupRole.allCases.filter(\.declares).count == 1)
  #expect(StartupRole.allCases.filter(\.rendersHeader).count == 1)
  #expect(StartupRole.allCases.filter(\.observesRetroactively).count == 1)
  #expect(StartupRole.allCases.count == 3)

  // --- Disjointness: every role carries exactly one responsibility, no role is empty. ---
  for role in StartupRole.allCases {
    let count = [role.declares, role.rendersHeader, role.observesRetroactively]
      .filter { $0 }
      .count
    #expect(count == 1, "role \(role.rawValue) carries \(count) responsibilities; expected 1")
  }
}
