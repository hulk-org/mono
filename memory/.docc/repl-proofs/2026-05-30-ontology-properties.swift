// 2026-05-30 - SwiftCheck property tests for the substrate's typing ontology.
//
// WHAT: Property-based tests over the substrate's typing axes (OrganismKind,
//       OrganismAspect, OrgRoleClass, OwnerTier, OrgRolePerformerKind, Form,
//       S-Type). Each property is a conjectured invariant; SwiftCheck tries
//       to falsify it with random inputs. Wins (properties that pass) and
//       breaks (falsifying counterexamples) feed the forms-vs-classes
//       doctrine memo.
//
// WHY: Operator-stated 2026-05-30 — we want to test the ontology with
//      swift-check before reshaping schemas. The forms-vs-classes question
//      (operators/ghosts/orchestrators might be classes) only resolves once
//      we see which axis-slug collisions actually exist and which
//      hypothesized invariants survive contact with the seed catalog.
//
// Usage:
//   swift test \
//     --package-path private/universal/substrate/agents/claude/memory/.docc/repl-proofs \
//     --filter OntologyPropertyTests
//
// SwiftCheck integrates with XCTest, so this scratchpad is structured as a
// test target rather than an executable. Other repl-proofs in this corpus
// stay executable; this one is the exception because of SwiftCheck's
// XCTest binding.

import Foundation
import SwiftCheck
import XCTest

// MARK: - Axis slug registries
//
// Seeded from the substrate surfaces named in each comment. The Explore
// inventory pass will confirm/correct these.

/// `OrganismKind` cases from organism-schemas v0.7.0 OrganismModel.swift.
let organismKindSlugs: Set<String> = [
  "audience", "human", "organization", "software",
]

/// Slot names on the OrganismAspects struct (same file).
let organismAspectSlugs: Set<String> = [
  "agenda", "agent", "audience", "collective", "ghost",
  "harness", "koma", "legalEntity", "orchestrator", "sprite",
]

/// Role-class slugs from roles/classes/role-class-catalog.json (status: seed).
let orgRoleClassSlugs: Set<String> = [
  "steward", "director", "maker", "reviewer-approver", "operator",
  "coach", "taxonomist", "adapter", "compiler", "maintainer",
]

/// Doctrinal owner-tier slugs (top-level homes under substrate/).
/// Inventory confirmed 2026-05-30 by Explore agent — eight canonical
/// commissioned-home tiers plus `roles/` as a secondary (non-commissioned)
/// tier. `ghosts/` and `orchestrators/` were missing from prior seed.
let ownerTierSlugs: Set<String> = [
  "agents", "audiences", "collectives", "ghosts",
  "harnesses", "maintainers", "operators", "orchestrators",
  "roles",
]

/// OrgRolePerformerKind static instances.
let orgRolePerformerKindSlugs: Set<String> = [
  "human", "agent", "digikoma",
]

/// S-Type atoms from the authoritative catalog at
/// s-type-standards-schemas/v0.3.0/.../s-type-standards.json (36 entries).
/// Prior seed had only the 15 referenced by role-class-catalog; this is the
/// full registry. ExpectedContributions keeps them as freeform [String] —
/// the catalog typing is JSON, no Swift enum.
let sTypeSlugs: Set<String> = [
  "a11y", "app", "audio", "blog", "bug", "business",
  "code", "community", "content", "data", "design", "doc",
  "eventOrganizing", "example", "financial", "fundingFinding",
  "governance", "ideas", "infra", "maintenance", "mentoring",
  "ops", "platform", "plugin", "product", "projectManagement",
  "promotion", "question", "research", "review", "security",
  "talk", "test", "tool", "translation", "tutorial",
  "userTesting", "video",
]

// MARK: - Axis identity

enum Axis: String, CaseIterable, Hashable {
  case organismKind
  case organismAspect
  case orgRoleClass
  case ownerTier
  case orgRolePerformerKind
  case sType
}

func slugs(on axis: Axis) -> Set<String> {
  switch axis {
  case .organismKind: return organismKindSlugs
  case .organismAspect: return organismAspectSlugs
  case .orgRoleClass: return orgRoleClassSlugs
  case .ownerTier: return ownerTierSlugs
  case .orgRolePerformerKind: return orgRolePerformerKindSlugs
  case .sType: return sTypeSlugs
  }
}

// MARK: - Singularization bridge

/// owner-tier slugs are plural (operators/), all other axes use singular
/// (operator). Normalize tier slugs to singular for collision detection so
/// "operators" and "operator" register as the same conceptual name.
func singularize(_ slug: String) -> String {
  if slug.hasSuffix("ies") { return String(slug.dropLast(3)) + "y" }
  if slug.hasSuffix("s") { return String(slug.dropLast()) }
  return slug
}

func canonicalize(_ slug: String, on axis: Axis) -> String {
  axis == .ownerTier ? singularize(slug) : slug
}

/// Slugs the operator has explicitly accepted as cross-axis aliases.
/// Empty for now — properties should reveal what would need to land here.
let collisionAllowlist: Set<String> = []

/// Hypothesis under investigation: operator/ghost/orchestrator might be
/// classes (not just aspects/tiers). Models the consequence of adding
/// them to the orgRoleClass axis. The collision count under this
/// hypothesis tells us how much renaming the cleanup would require.
let hypothesizedOrgRoleClassSlugs: Set<String> =
  orgRoleClassSlugs.union(["ghost", "orchestrator"])
// Note: `operator` is already in orgRoleClassSlugs; only the two new
// promotions need to be added to the hypothesis set.

// MARK: - Arbitrary instance

/// A slug drawn from a single axis. SwiftCheck generates the (axis, slug)
/// pair; properties parameterize over axis membership.
struct AxisSlug: Arbitrary, CustomStringConvertible {
  let axis: Axis
  let slug: String

  var description: String { "\(axis.rawValue):\(slug)" }

  static var arbitrary: Gen<AxisSlug> {
    Gen.fromElements(of: Axis.allCases)
      .flatMap { axis -> Gen<AxisSlug> in
        let pool = Array(slugs(on: axis))
        return Gen.fromElements(of: pool)
          .map { AxisSlug(axis: axis, slug: $0) }
      }
  }
}

// MARK: - Collision scan (deterministic, prints alongside properties)

func deterministicCollisionMap() -> [String: [Axis]] {
  var collisionMap: [String: [Axis]] = [:]
  for axis in Axis.allCases {
    for slug in slugs(on: axis) {
      let key = canonicalize(slug, on: axis)
      collisionMap[key, default: []].append(axis)
    }
  }
  return collisionMap.filter { $0.value.count > 1 }
}

// MARK: - S-Type catalog loader (relation-integrity properties)

/// Per-atom S-Type contribution model loaded from
/// private/universal/kura/collections/s-types/<slug>.s-type.json.
///
/// The three relation fields are DIRECTED edges: `synergized_by: [B]`
/// means "this atom is enhanced when paired with B" (a gains-from
/// relation). Reverse direction is NOT implied; B's own file authors
/// its own outgoing edges independently.
struct LoadedAtom: Decodable {
  let slug: String
  let synergized_by: [String]?
  let stabilized_by: [String]?
  let strained_by: [String]?

  func relations(_ kind: RelationKind) -> [String] {
    switch kind {
    case .synergizedBy: return synergized_by ?? []
    case .stabilizedBy: return stabilized_by ?? []
    case .strainedBy: return strained_by ?? []
    }
  }
}

enum RelationKind: String, CaseIterable {
  case synergizedBy = "synergized_by"
  case stabilizedBy = "stabilized_by"
  case strainedBy = "strained_by"
}

/// Resolves the kura/collections/s-types directory by walking up from cwd
/// until "private/universal/kura/collections/s-types" exists, or returns nil.
/// Walks deeply because xctest may launch from a deep .build/ path.
func resolveSTypeDir() -> URL? {
  let fm = FileManager.default
  let suffix = "private/universal/kura/collections/s-types"
  // First try cwd-rooted walk.
  var url = URL(fileURLWithPath: fm.currentDirectoryPath).standardizedFileURL
  for _ in 0..<24 {
    let candidate = url.appendingPathComponent(suffix)
    if fm.fileExists(atPath: candidate.path) { return candidate }
    if url.pathComponents.count <= 1 { break }
    url.deleteLastPathComponent()
  }
  // Fallback: walk up from this source file's location.
  let sourceURL = URL(fileURLWithPath: #filePath).standardizedFileURL
  var fromSource = sourceURL
  for _ in 0..<24 {
    let candidate = fromSource.appendingPathComponent(suffix)
    if fm.fileExists(atPath: candidate.path) { return candidate }
    if fromSource.pathComponents.count <= 1 { break }
    fromSource.deleteLastPathComponent()
  }
  return nil
}

/// Loads every <slug>.s-type.json into a slug→record map. Empty on failure.
func loadAllSTypeAtoms() -> [String: LoadedAtom] {
  guard let dir = resolveSTypeDir() else { return [:] }
  let fm = FileManager.default
  guard
    let entries = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
  else { return [:] }
  let decoder = JSONDecoder()
  var loaded: [String: LoadedAtom] = [:]
  for entry in entries where entry.lastPathComponent.hasSuffix(".s-type.json") {
    guard let data = try? Data(contentsOf: entry),
      let atom = try? decoder.decode(LoadedAtom.self, from: data)
    else { continue }
    loaded[atom.slug] = atom
  }
  return loaded
}

struct EdgeViolation: CustomStringConvertible {
  let kind: ViolationKind
  let from: String
  let to: String
  let relation: RelationKind

  enum ViolationKind { case dangling, selfReference }

  var description: String {
    let r = relation.rawValue
    switch kind {
    case .dangling: return "\(from) →\(r)→ \(to), but \(to) is not a defined atom"
    case .selfReference: return "\(from) →\(r)→ \(from) (self-reference)"
    }
  }
}

/// Scans for closure (every relation target resolves to a defined atom)
/// and no-self-reference. Symmetry is NOT checked — relations are
/// directed edges by design, so asymmetry is expected.
func scanRelationViolations(_ atoms: [String: LoadedAtom]) -> [EdgeViolation] {
  var violations: [EdgeViolation] = []
  let defined = Set(atoms.keys)
  for (slug, atom) in atoms {
    for relation in RelationKind.allCases {
      let pool = atom.relations(relation)
      for target in pool {
        if target == slug {
          violations.append(.init(kind: .selfReference, from: slug, to: target, relation: relation))
          continue
        }
        if !defined.contains(target) {
          violations.append(.init(kind: .dangling, from: slug, to: target, relation: relation))
        }
      }
    }
  }
  return violations
}

/// Counts the directed-edge asymmetries (informational, not a violation):
/// edges where A relation→ B holds but B relation→ A does not. Surfacing
/// the count lets us see how directional the graph is in practice.
func countDirectedAsymmetries(_ atoms: [String: LoadedAtom]) -> [RelationKind: Int] {
  var counts: [RelationKind: Int] = [:]
  let defined = Set(atoms.keys)
  for (slug, atom) in atoms {
    for relation in RelationKind.allCases {
      for target in atom.relations(relation) where defined.contains(target) {
        if let other = atoms[target], !other.relations(relation).contains(slug) {
          counts[relation, default: 0] += 1
        }
      }
    }
  }
  return counts
}

// MARK: - Tests

final class OntologyPropertyTests: XCTestCase {

  override class func setUp() {
    super.setUp()
    print("\nsubstrate ontology — deterministic collision scan:")
    let collisions = deterministicCollisionMap()
      .sorted { $0.key < $1.key }
    if collisions.isEmpty {
      print("  (none)")
    } else {
      for (slug, axes) in collisions {
        let axesText = axes.map(\.rawValue).sorted().joined(separator: ", ")
        print("  \(slug)  →  [\(axesText)]")
      }
    }
    print("")
  }

  /// Sanity: every drawn axis-slug is non-empty.
  func testSlugsAreNonEmpty() {
    property("axis slugs are non-empty") <- forAll { (drawn: AxisSlug) in
      !drawn.slug.isEmpty
    }
  }

  /// Sanity: a drawn axis-slug is registered under its own axis.
  func testAxisSelfMembership() {
    property("axis self-membership") <- forAll { (drawn: AxisSlug) in
      slugs(on: drawn.axis).contains(drawn.slug)
    }
  }

  /// The load-bearing property: no canonicalized slug appears on more than
  /// one axis without an explicit collisionAllowlist entry. EXPECTED to
  /// falsify today — that falsification is the evidence.
  func testNoCrossAxisCollisions() {
    property("no cross-axis collisions outside allowlist") <- forAll { (drawn: AxisSlug) in
      let canonical = canonicalize(drawn.slug, on: drawn.axis)
      if collisionAllowlist.contains(canonical) { return true }
      let axes = Axis.allCases.filter { axis in
        slugs(on: axis).contains(where: { canonicalize($0, on: axis) == canonical })
      }
      return axes.count <= 1
    }
  }

  /// Deterministic scan over the 38 S-Type contribution atoms on disk:
  /// every relation edge must satisfy (1) closure — target is a defined
  /// atom, (2) no self-reference. Directional asymmetry is by design
  /// (the relations are directed edges) and is reported informationally,
  /// not as a violation.
  func testSTypeRelationIntegrity() {
    let atoms = loadAllSTypeAtoms()
    guard atoms.count >= 30 else {
      print("\nS-Type relation integrity: skipped — only \(atoms.count) atoms loaded.")
      return
    }
    print("\nS-Type relation integrity scan — \(atoms.count) atoms loaded:")
    let violations = scanRelationViolations(atoms)
    let dangling = violations.filter { $0.kind == .dangling }
    let selfRef = violations.filter { $0.kind == .selfReference }
    let asym = countDirectedAsymmetries(atoms)

    print("  dangling targets:  \(dangling.count)")
    print("  self-references:   \(selfRef.count)")
    print("  directed-edge asymmetries (informational, not violations):")
    for kind in RelationKind.allCases {
      print("    \(kind.rawValue): \(asym[kind] ?? 0)")
    }

    if !dangling.isEmpty {
      print("  --- dangling (first 5) ---")
      for v in dangling.prefix(5) { print("    \(v)") }
    }
    if !selfRef.isEmpty {
      print("  --- self-reference ---")
      for v in selfRef { print("    \(v)") }
    }

    XCTAssertEqual(
      dangling.count, 0,
      "Dangling relation targets must resolve to defined atoms.")
    XCTAssertEqual(
      selfRef.count, 0,
      "Atoms must not self-reference in their relation lists.")
  }

  /// Hypothesis simulation: if we promote ghost+orchestrator to classes
  /// (operator is already a class), how does the collision picture change?
  /// Prints the deterministic before/after diff and asserts the new
  /// collision count is bounded.
  func testHypothesisClassPromotionDelta() {
    print("\nhypothesis: promote ghost + orchestrator to orgRoleClass:")

    // Baseline collision count.
    let baseline = deterministicCollisionMap()
    print("  baseline collisions: \(baseline.count)")

    // Hypothetical: temporarily swap in the augmented orgRoleClass pool.
    var hypothetical: [String: [Axis]] = [:]
    for axis in Axis.allCases {
      let pool = axis == .orgRoleClass ? hypothesizedOrgRoleClassSlugs : slugs(on: axis)
      for slug in pool {
        let key = canonicalize(slug, on: axis)
        hypothetical[key, default: []].append(axis)
      }
    }
    let hypotheticalCollisions = hypothetical.filter { $0.value.count > 1 }
    print("  hypothetical collisions: \(hypotheticalCollisions.count)")

    let newCollisions = Set(hypotheticalCollisions.keys)
      .subtracting(Set(baseline.keys))
    if !newCollisions.isEmpty {
      print("  new collisions under hypothesis:")
      for slug in newCollisions.sorted() {
        let axes = hypothetical[slug]!.map(\.rawValue).sorted().joined(separator: ", ")
        print("    \(slug)  →  [\(axes)]")
      }
    }

    // Pre-hypothesis 3-axis collisions.
    let triple = baseline.filter { $0.value.count >= 3 }.keys.sorted()
    let hypotheticalTriple = hypotheticalCollisions.filter { $0.value.count >= 3 }.keys.sorted()
    print("  3-axis collisions (baseline): \(triple)")
    print("  3-axis collisions (hypothesis): \(hypotheticalTriple)")

    XCTAssertGreaterThanOrEqual(
      hypotheticalCollisions.count, baseline.count,
      "Hypothesis cannot reduce collisions without renaming — it only adds.")
  }
}
