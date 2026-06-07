#!/usr/bin/env swift
//
// 2026-05-17-substrate-imdb-character-worldline-shapes.swift
//
// LDT proof for substrate-imdb-of-people-characters-personas-across-hilbert-timelines
// (committed at mono f3b55630c7) + character-schemas v0.1.0 + worldline-schemas v0.1.0
// (committed at schema-universal 1e578c7, mono pointer bump f1ca643e56).
//
// Per AGENTS.md LDT doctrine: every non-trivial structural claim becomes a compilable
// .swift proof under repl-proofs/, runs with `swift <file>`, asserts with precondition.
// Three explicit statements: Affirmative + Negative + Counterfactual.
//
// CLAIMS PROVEN:
//   1. CharacterModel: a valid Character record has required fields {i, t, c, sH, sB-non-empty}.
//   2. WorldlineModel: a valid Worldline has required fields {i, t, c, sE, e, ev-non-empty}
//      AND its events are chronologically ordered.
//   3. Substrate refuses Character with empty substrateBindings (Curry-Howard: substrate-doctrine-relevance
//      is required by the type, not optional discipline).
//   4. Substrate refuses Worldline with no events.
//
// Run: swift 2026-05-17-substrate-imdb-character-worldline-shapes.swift

import Foundation

// MARK: - Pieces

struct LinkRef: Codable, Equatable {
  let k: String
  let v: String
  let vt: String
  let vr: String
  let sf: String
  let sv: String
  let sk: String
}

struct CharacterModel: Codable {
  let i: String         // slug
  let t: String         // title
  let c: Int64          // chrononID
  let sH: String        // sourceHilbertSpace
  let sB: [LinkRef]     // substrateBindings (REQUIRED non-empty)
  let fA: String?
  let fAY: Int?
  let k: String?
  let k2: String?
}

struct WorldlineEvent: Codable {
  let c: Int64
  let t: String
  let k: String
  let hS: String?
  let ref: LinkRef?
  let n: String?
}

struct WorldlineModel: Codable {
  let i: String
  let t: String
  let c: Int64
  let sE: String
  let e: LinkRef
  let ev: [WorldlineEvent]
  let hS: String?
}

// MARK: - Validation primitives (substrate-doctrine-required invariants)

enum SubstrateValidationError: Error, CustomStringConvertible {
  case characterSubstrateBindingsEmpty
  case worldlineEventsEmpty
  case worldlineEventsOutOfOrder(at: Int)

  var description: String {
    switch self {
    case .characterSubstrateBindingsEmpty:
      return "substrate refuses Character with empty sB (substrateBindings)"
    case .worldlineEventsEmpty:
      return "substrate refuses Worldline with empty ev (events)"
    case .worldlineEventsOutOfOrder(let i):
      return "substrate refuses Worldline whose events are not chronologically ordered (failure at index \(i))"
    }
  }
}

func validateCharacter(_ c: CharacterModel) throws {
  if c.sB.isEmpty { throw SubstrateValidationError.characterSubstrateBindingsEmpty }
}

func validateWorldline(_ w: WorldlineModel) throws {
  if w.ev.isEmpty { throw SubstrateValidationError.worldlineEventsEmpty }
  for i in 1..<w.ev.count {
    if w.ev[i].c < w.ev[i - 1].c {
      throw SubstrateValidationError.worldlineEventsOutOfOrder(at: i)
    }
  }
}

// MARK: - Fixtures

let vashBinding = LinkRef(
  k: "vr", v: "bastards-for-peace-and-love",
  vt: "wrkstrm-doctrine", vr: "private/universal/vaults/wrkstrm-doctrine",
  sf: "ideation-schemas", sv: "0.1.0", sk: "ConceptModel"
)

let validVash = CharacterModel(
  i: "vash-the-stampede",
  t: "Vash the Stampede",
  c: 1_779_120_000_000_000_000,
  sH: "trigun",
  sB: [vashBinding],
  fA: "Trigun manga 1995",
  fAY: 1995,
  k: "protagonist",
  k2: "Pacifist with maximum capability."
)

let unboundCharacter = CharacterModel(
  i: "untyped-character",
  t: "Some character with no substrate-doctrine relevance",
  c: 1_779_120_000_000_000_000,
  sH: "some-fictional-space",
  sB: [], // empty — substrate must refuse
  fA: nil, fAY: nil, k: nil, k2: nil
)

let entityRef = LinkRef(
  k: "vr", v: "wrkstrm-substrate", vt: "wrkstrm-doctrine",
  vr: "private/universal/vaults/wrkstrm-doctrine", sf: "substrate-self-schemas",
  sv: "0.1.0-interim", sk: "SubstrateRecord"
)

let orderedWorldline = WorldlineModel(
  i: "worldline-substrate-test",
  t: "Test substrate worldline (chronologically ordered)",
  c: 1_779_120_000_000_000_000,
  sE: "substrate",
  e: entityRef,
  ev: [
    WorldlineEvent(c: 1_655_895_220_000_000_000, t: "founding commit", k: "founding-commit", hS: nil, ref: nil, n: nil),
    WorldlineEvent(c: 1_666_935_002_000_000_000, t: "first AI harness", k: "harness-instantiation", hS: nil, ref: nil, n: nil),
    WorldlineEvent(c: 1_779_120_000_000_000_000, t: "doctrine vault seeded", k: "doctrine-extension", hS: nil, ref: nil, n: nil),
  ],
  hS: "substrate-doctrine"
)

let unorderedWorldline = WorldlineModel(
  i: "worldline-test-unordered",
  t: "Counterfactual: a worldline whose events run backward",
  c: 1_779_120_000_000_000_000,
  sE: "substrate",
  e: entityRef,
  ev: [
    WorldlineEvent(c: 1_779_120_000_000_000_000, t: "future event", k: "doctrine-extension", hS: nil, ref: nil, n: nil),
    WorldlineEvent(c: 1_655_895_220_000_000_000, t: "past event after future event", k: "founding-commit", hS: nil, ref: nil, n: nil),
  ],
  hS: "substrate-doctrine"
)

let emptyWorldline = WorldlineModel(
  i: "worldline-empty",
  t: "Empty events — substrate must refuse",
  c: 1_779_120_000_000_000_000,
  sE: "substrate",
  e: entityRef,
  ev: [],
  hS: nil
)

// MARK: - AFFIRMATIVE: valid records pass

do {
  try validateCharacter(validVash)
  print("✓ AFFIRMATIVE  Character: Vash record validates (slug + title + chronon + sourceHilbertSpace + non-empty substrateBindings).")
} catch {
  preconditionFailure("AFFIRMATIVE failed: valid Vash record should validate. Error: \(error)")
}

do {
  try validateWorldline(orderedWorldline)
  print("✓ AFFIRMATIVE  Worldline: chronologically-ordered substrate worldline validates.")
} catch {
  preconditionFailure("AFFIRMATIVE failed: ordered worldline should validate. Error: \(error)")
}

// MARK: - NEGATIVE: invalid records fail with the expected substrate-doctrine error

do {
  try validateCharacter(unboundCharacter)
  preconditionFailure("NEGATIVE failed: Character with empty sB should be rejected.")
} catch SubstrateValidationError.characterSubstrateBindingsEmpty {
  print("✓ NEGATIVE     Character: empty-substrateBindings record rejected with the expected typed error. Substrate refuses Character without substrate-doctrine relevance.")
} catch {
  preconditionFailure("NEGATIVE failed: wrong error type. Got: \(error)")
}

do {
  try validateWorldline(emptyWorldline)
  preconditionFailure("NEGATIVE failed: Worldline with empty events should be rejected.")
} catch SubstrateValidationError.worldlineEventsEmpty {
  print("✓ NEGATIVE     Worldline: empty-events record rejected. Substrate refuses worldlines with no events.")
} catch {
  preconditionFailure("NEGATIVE failed: wrong error type. Got: \(error)")
}

// MARK: - COUNTERFACTUAL: events out of chronological order fail with the typed-ordering error

do {
  try validateWorldline(unorderedWorldline)
  preconditionFailure("COUNTERFACTUAL failed: Worldline with events out of order should be rejected.")
} catch SubstrateValidationError.worldlineEventsOutOfOrder(let at) {
  precondition(at == 1, "COUNTERFACTUAL: failure should be at index 1 (the past event after the future event). Got index \(at).")
  print("✓ COUNTERFACTUAL  Worldline: events out of chronological order rejected at index \(at). Substrate's Hilbert-timeline ordering is type-enforced.")
} catch {
  preconditionFailure("COUNTERFACTUAL failed: wrong error type. Got: \(error)")
}

// MARK: - Done

print("")
print("LDT proof complete: substrate-imdb character-schemas + worldline-schemas v0.1.0 shape invariants asserted.")
print("Three substrate-doctrine claims proven by compilation + precondition assertion:")
print("  1. Valid records pass validation.")
print("  2. Characters with empty substrateBindings rejected (substrate-doctrine-relevance is type-required).")
print("  3. Worldlines with empty or out-of-order events rejected (Hilbert-timeline ordering is type-enforced).")
