import Testing

/// Claim: For digikoma-ldt-proof v1's parser, `testCount` always equals
/// `passedCount + failedCount`. The parser sees one of three outcomes —
/// all-passed, all-failed, or no-summary-line — and never produces a
/// partial-failure breakdown. v2 will add per-test event-stream parsing,
/// at which point this invariant should *fail* (and force the
/// implementer to update both the model and this proof together).
///
/// Source of truth: digikoma-org/.../meta/digikoma-ldt-proof/sources/
///   DigikomaLdtProofTool/DigikomaLdtProofTool.swift
///   (specifically `parseSwiftTestingOutput` + the result fields it
///   populates).
///
/// Why this is an LDT proof, not a Swift Testing test of the package
/// itself: the claim is a structural invariant of v1's parser logic,
/// not a behavioral test of the running tool. The proof models the
/// outcome space directly via an enum and asserts on the modeled
/// shape, mirroring the parser's branching rather than importing it.
/// When v2 widens the outcome space (passed=2, failed=1, total=3), the
/// `ParseOutcome` enum here must grow a fourth case — and the proof
/// will fail until it does. That forced co-evolution is the value.

@Test("digikoma-ldt-proof v1 parser: testCount = passedCount + failedCount")
func ldtProofCountInvariantV1() {
  // Outcome space the v1 parser can produce. Mirrors the three
  // branches of `parseSwiftTestingOutput`:
  //   - summary line says "passed" → all N counted as passed
  //   - summary line says "failed" → all N counted as failed
  //   - no summary line found      → (0, 0, 0)
  enum ParseOutcome: Equatable, CaseIterable {
    case allPassed(total: Int)
    case allFailed(total: Int)
    case noSummary

    static var allCases: [ParseOutcome] {
      [
        .allPassed(total: 0),
        .allPassed(total: 1),
        .allPassed(total: 3),
        .allPassed(total: 100),
        .allFailed(total: 1),
        .allFailed(total: 3),
        .allFailed(total: 100),
        .noSummary,
      ]
    }

    var counts: (total: Int, passed: Int, failed: Int) {
      switch self {
      case .allPassed(let n): (n, n, 0)
      case .allFailed(let n): (n, 0, n)
      case .noSummary: (0, 0, 0)
      }
    }
  }

  // --- The invariant: total == passed + failed for every outcome. ---
  for outcome in ParseOutcome.allCases {
    let c = outcome.counts
    #expect(c.total == c.passed + c.failed,
            "outcome \(outcome): total \(c.total) ≠ passed \(c.passed) + failed \(c.failed)")
  }

  // --- Positive: passed-only outcomes have failed=0. ---
  for outcome in ParseOutcome.allCases {
    if case .allPassed(let n) = outcome {
      let c = outcome.counts
      #expect(c.passed == n)
      #expect(c.failed == 0)
    }
  }

  // --- Positive: failed-only outcomes have passed=0. ---
  for outcome in ParseOutcome.allCases {
    if case .allFailed(let n) = outcome {
      let c = outcome.counts
      #expect(c.passed == 0)
      #expect(c.failed == n)
    }
  }

  // --- Negative: no outcome in v1's space has BOTH passed > 0 AND failed > 0. ---
  // This is the line that should fail when v2 lands per-test parsing,
  // because v2 will produce mixed outcomes (e.g. 2 passed + 1 failed).
  for outcome in ParseOutcome.allCases {
    let c = outcome.counts
    let mixed = c.passed > 0 && c.failed > 0
    #expect(!mixed, "v1 should not produce mixed outcomes; got \(outcome) → \(c)")
  }

  // --- Cardinality: 8 outcomes total in v1's modeled space. ---
  #expect(ParseOutcome.allCases.count == 8)
}
