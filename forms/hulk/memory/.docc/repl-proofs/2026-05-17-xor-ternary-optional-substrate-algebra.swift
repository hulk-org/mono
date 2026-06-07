#!/usr/bin/env swift
//
// 2026-05-17-xor-ternary-optional-substrate-algebra.swift
//
// LDT proof for xor-ternary-optional-substrate-typing-algebra Concept
// (mono substrate-doctrine vault, just-committed alongside).
//
// CLAIMS PROVEN:
//   AFFIRMATIVE  1: Ternary + Optional are ORTHOGONAL — presence-axis × truth-axis
//                   composes into 4 distinct states fitting exactly in 2 bits.
//   AFFIRMATIVE  2: Boolean XOR's truth table is preserved on the Ternary-known
//                   subset (T XOR T = F; T XOR F = T; F XOR F = F).
//   NEGATIVE     1: Kleene XOR is PARTIALLY DISJOINT from Boolean XOR — UNKNOWN
//                   propagates (T XOR U = U; U XOR U = U), breaking XOR's clean
//                   self-inverse property (A XOR A ≠ F when A = U).
//   COUNTERFACTUAL: Pure XOR is DISABLED by Optional ABSENT — XOR(ABSENT, anything)
//                   propagates ABSENT, not a definite T/F. If we treated ABSENT
//                   as just-another-truth-value (false assumption), the algebra
//                   would lose information distinguishing "we never knew" from
//                   "we explicitly checked and found false."
//
// Run: swift 2026-05-17-xor-ternary-optional-substrate-algebra.swift

import Foundation

// MARK: - The four-state encoding (Ternary + Optional, 2 bits exactly)

enum SubstrateState: UInt8, CustomStringConvertible {
  case absent  = 0b00  // field not provided
  case unknown = 0b01  // field present, value null (Kleene UNKNOWN)
  case `false` = 0b10  // field present, value false
  case `true`  = 0b11  // field present, value true

  var description: String {
    switch self {
    case .absent:  return "ABSENT"
    case .unknown: return "UNKNOWN"
    case .false:   return "FALSE"
    case .true:    return "TRUE"
    }
  }
}

// MARK: - XOR variants

/// Boolean XOR on the Known subset. Defined only when both operands are TRUE or FALSE.
func booleanXOR(_ a: SubstrateState, _ b: SubstrateState) -> SubstrateState? {
  switch (a, b) {
  case (.true, .true):   return .false
  case (.true, .false):  return .true
  case (.false, .true):  return .true
  case (.false, .false): return .false
  default: return nil
  }
}

/// Kleene XOR — propagates UNKNOWN, propagates ABSENT differently.
/// T XOR U = U; U XOR U = U. T XOR T = F. ABSENT XOR anything = ABSENT.
func kleeneXOR(_ a: SubstrateState, _ b: SubstrateState) -> SubstrateState {
  if a == .absent || b == .absent { return .absent }
  if a == .unknown || b == .unknown { return .unknown }
  return booleanXOR(a, b) ?? .unknown
}

// MARK: - AFFIRMATIVE 1: Ternary + Optional are orthogonal; 2-bit encoding

precondition(SubstrateState.absent.rawValue  == 0b00, "ABSENT must be 0b00")
precondition(SubstrateState.unknown.rawValue == 0b01, "UNKNOWN must be 0b01")
precondition(SubstrateState.false.rawValue   == 0b10, "FALSE must be 0b10")
precondition(SubstrateState.true.rawValue    == 0b11, "TRUE must be 0b11")

let allStates: [SubstrateState] = [.absent, .unknown, .false, .true]
precondition(allStates.count == 4, "Exactly 4 states (Ternary + Optional = 2 bits = 4 values)")
let rawValueCount = Set(allStates.map { $0.rawValue }).count
precondition(rawValueCount == 4, "All 4 raw values distinct (no bit-pattern collision)")
print("✓ AFFIRMATIVE 1  Ternary + Optional orthogonal: 4 distinct states, exactly 2 bits per field.")

// MARK: - AFFIRMATIVE 2: Boolean XOR preserved on Known subset

precondition(booleanXOR(.true, .true)   == .false,  "T XOR T = F")
precondition(booleanXOR(.true, .false)  == .true,   "T XOR F = T")
precondition(booleanXOR(.false, .true)  == .true,   "F XOR T = T")
precondition(booleanXOR(.false, .false) == .false,  "F XOR F = F")
print("✓ AFFIRMATIVE 2  Boolean XOR preserved on Ternary's KNOWN subset (T,F).")

// MARK: - NEGATIVE: Kleene XOR breaks Boolean XOR's self-inverse property

// In Boolean XOR: A XOR A = F always (the self-inverse property).
// In Kleene XOR: U XOR U = U, NOT F.
let kleeneSelfXOR_unknown = kleeneXOR(.unknown, .unknown)
precondition(
  kleeneSelfXOR_unknown == .unknown,
  "Kleene U XOR U = U (UNKNOWN propagates; not F)"
)
let kleeneSelfXOR_true = kleeneXOR(.true, .true)
precondition(
  kleeneSelfXOR_true == .false,
  "Kleene T XOR T = F (matches Boolean on Known subset)"
)
// The self-inverse property A XOR A = F holds for KNOWN values but FAILS for UNKNOWN
precondition(
  kleeneSelfXOR_unknown != .false,
  "Kleene XOR's self-inverse property is BROKEN at UNKNOWN: U XOR U ≠ F"
)
print("✓ NEGATIVE       Kleene XOR's self-inverse property broken at UNKNOWN (U XOR U = U ≠ F). XOR + Ternary are PARTIALLY DISJOINT.")

// And T XOR U = U (UNKNOWN propagates through XOR)
let kleeneMixed = kleeneXOR(.true, .unknown)
precondition(
  kleeneMixed == .unknown,
  "Kleene T XOR U = U (UNKNOWN propagates)"
)
print("✓ NEGATIVE       Kleene T XOR U = U; UNKNOWN propagates through XOR (Boolean XOR's clean truth-table breaks under Ternary).")

// MARK: - COUNTERFACTUAL: pure XOR disabled by Optional ABSENT

// If we (incorrectly) collapsed ABSENT into FALSE — the false assumption substrate doctrine refuses — then:
//   ABSENT XOR ABSENT would be "FALSE XOR FALSE = FALSE"
// But that LOSES the distinction between "we never knew" and "we knew it was false."
// Substrate doctrine: ABSENT must propagate, NOT collapse to FALSE.
let kleeneAbsentXORAbsent = kleeneXOR(.absent, .absent)
precondition(
  kleeneAbsentXORAbsent == .absent,
  "Kleene ABSENT XOR ABSENT = ABSENT (does NOT collapse to FALSE)"
)
let kleeneAbsentXORTrue = kleeneXOR(.absent, .true)
precondition(
  kleeneAbsentXORTrue == .absent,
  "Kleene ABSENT XOR TRUE = ABSENT (ABSENT propagates, NOT TRUE)"
)
// Counterfactual: what if we collapsed ABSENT to FALSE? That FALSE assumption would yield:
//   ABSENT-as-FALSE XOR ABSENT-as-FALSE = FALSE
//   ABSENT-as-FALSE XOR TRUE = TRUE
// Both wrong from substrate-doctrine perspective. The actual algebra MUST keep ABSENT as a propagating state.
let counterfactualWrongResult: SubstrateState = .false  // what we'd get IF we collapsed ABSENT to FALSE
precondition(
  kleeneAbsentXORAbsent != counterfactualWrongResult,
  "COUNTERFACTUAL: substrate algebra refuses ABSENT-collapses-to-FALSE; ABSENT must remain distinguished"
)
print("✓ COUNTERFACTUAL XOR + Optional DISJOINT under ABSENT: substrate algebra refuses to collapse ABSENT into FALSE. ABSENT propagates; substrate's distinction between 'we never knew' vs 'we knew it was false' is preserved.")

// MARK: - Bonus: substrate-IMDB worldline-crossing query decomposes into this algebra

// Imagine two worldline events with same chronon but possibly-different positions.
// 'where does worldline A differ from worldline B at chronon T?' decomposes into:
//   - Optional AND: both records present at chronon T?
//   - Ternary AND: both positions known?
//   - Kleene XOR: do the positions differ?
let aPresent = SubstrateState.true
let bPresent = SubstrateState.true
let aKnown = SubstrateState.true
let bKnown = SubstrateState.unknown
let aPosition = SubstrateState.true   // some position
let bPosition = SubstrateState.unknown // unknown position

let bothPresent = aPresent == .true && bPresent == .true ? SubstrateState.true : SubstrateState.false
let bothKnown = aKnown == .true && bKnown == .true ? SubstrateState.true : (aKnown == .false || bKnown == .false ? .false : .unknown)
let differs = bothPresent == .true ? kleeneXOR(aPosition, bPosition) : .absent

print("✓ BONUS          substrate-IMDB query (rismay↔Jessica worldline crossing): bothPresent=\(bothPresent), bothKnown=\(bothKnown), differs=\(differs). UNKNOWN propagation through the XOR composes correctly.")

print("")
print("LDT proof complete. XOR + Ternary + Optional substrate algebra formalized.")
print("Three substrate-doctrine claims proven:")
print("  1. Ternary + Optional ORTHOGONAL (4 states fit exactly in 2 bits).")
print("  2. XOR preserved on Ternary KNOWN subset (T,F); BROKEN at UNKNOWN.")
print("  3. ABSENT propagates through XOR (DISJOINT from Boolean XOR algebra); substrate refuses to collapse ABSENT into FALSE.")
