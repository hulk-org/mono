// fixed 2026-04-30: added explicit per-index negative assertions. Original
// proof relied on cardinality (filter(\.isPersonaScoped).count == 1) to
// imply that the other 10 indices were not persona-scoped — true
// mathematically, but fragile: if cardinality ever weakened or reordered,
// the negative claim would silently evaporate. Each non-persona index is
// now checked directly with a named-failure message.

/// Claim: hulk's startup is an ordered 11-phase carrier pipeline with exactly
/// one persona-scoped slot, at index 4 (the `agent-persona` phase). Phases
/// 0..3 and 5..10 are carrier-invariant — swapping persona only invalidates
/// the persona-scoped slot.
///
/// Source of truth: harnesses/hulk/.docc/startup/startup.json (schema 0.2.0).
///
/// Caught: a prose off-by-one — "swap re-runs phase 5" was actually index 4
/// (5th of 11). The REPL surfaced it before the runner change shipped.
///
/// Run: `swift <this-file>` — exits 0 and prints `ok: …` on success;
/// `precondition` aborts on any failed assertion.

enum Phase: String, CaseIterable {
  case runtimeConfig
  case root
  case environment
  case harnessBootstrap
  case agentPersona
  case identity
  case autoMemory
  case incident
  case backgroundMemory
  case skills
  case cliStartup

  var isPersonaScoped: Bool { self == .agentPersona }
}

precondition(Phase.allCases.count == 11)
precondition(Phase.allCases.filter(\.isPersonaScoped).count == 1)
precondition(Phase.allCases.firstIndex(where: \.isPersonaScoped) == 4)

let carrierInvariant = Phase.allCases.enumerated()
  .filter { !$0.element.isPersonaScoped }
  .map(\.offset)
precondition(carrierInvariant == [0, 1, 2, 3, 5, 6, 7, 8, 9, 10])

// Negative: each non-persona index is explicitly NOT persona-scoped.
// (Symmetric to the positive `firstIndex == 4` above. Catches drift if
// someone adds a second persona-scoped phase elsewhere.)
for index in [0, 1, 2, 3, 5, 6, 7, 8, 9, 10] {
  let phase = Phase.allCases[index]
  precondition(!phase.isPersonaScoped,
               "phase at index \(index) (\(phase.rawValue)) should not be persona-scoped")
}

print("ok: 11 phases, agentPersona alone at index 4, 10 carrier-invariant phases (each explicitly checked)")
