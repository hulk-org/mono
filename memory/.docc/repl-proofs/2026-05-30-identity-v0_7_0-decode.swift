// 2026-05-30 - Decode claude's identity record through Identity_Schemas v0.7.0.
//
// WHAT: Reads private/universal/substrate/agents/claude/private/universal/
//       identity/claude@rismay.substrate.identity.json and decodes it through
//       the v0.7.0 IdentityModel decoder, then re-encodes and reports which
//       v0.7.0-canonical fields are present/absent.
//
// WHY: Sync turn 2026-05-30 surfaced that claude's identity bundle was at
//      v0.6.0 while core-entity-set v1.0.0 pins identity-schemas to v0.7.0.
//      This proof witnesses the post-uplift JSON decodes cleanly against the
//      strict-equal v0.7.0 contract (IdentityModel, PersonaRefs,
//      SystemInstructionsRefs, NoteModel) before we trust the on-disk record.
//
// Usage:
//   SPM_USE_LOCAL_DEPS=1 swift run \
//     --package-path private/universal/substrate/agents/claude/memory/.docc/repl-proofs \
//     identity-v0_7_0-decode-2026-05-30

import Foundation
import Identity_Schemas_v000_007_000

@main
struct IdentityV7DecodeProof {
  static func main() throws {
    let repoRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let identityURL = repoRoot
      .appendingPathComponent("private/universal/substrate/agents/claude")
      .appendingPathComponent("private/universal/identity")
      .appendingPathComponent("claude@rismay.substrate.identity.json")

    let data = try Data(contentsOf: identityURL)
    let decoder = JSONDecoder()
    let identity: IdentityModel
    do {
      identity = try decoder.decode(IdentityModel.self, from: data)
    } catch {
      FileHandle.standardError.write(Data("FAIL decode: \(error)\n".utf8))
      exit(1)
    }

    print("PASS decode")
    print("  schemaVersion      = \(identity.schemaVersion)")
    print("  slug               = \(identity.slug)")
    print("  title              = \(identity.title)")
    print("  updated            = \(identity.updated)")
    print("  status             = \(identity.status ?? "nil")")
    print("  displayRole        = \(identity.displayRole ?? "nil")")
    print("  roles.count        = \(identity.roles.count)")
    print("  skillRefs.count    = \(identity.skillRefs.count)")
    print("  toolRefs.count     = \(identity.toolRefs.count)")
    print("  agendaRefs.count   = \(identity.agendaRefs?.count ?? 0)")
    print("  agentRefs.count    = \(identity.agentRefs.count)")
    print("  digikomaRefs.count = \(identity.digikomaRefs.count)")
    print("  deferredMoves.count= \(identity.deferredMoves.count)")
    print("  links.count        = \(identity.links.count)")
    print("  notes.count        = \(identity.notes.count)")
    print("  focusDomains.count = \(identity.focusDomains?.count ?? 0)")
    print(
      "  persona.profilePath= \(identity.persona?.profilePath ?? "nil")"
    )
    print(
      "  persona.ikigai.sourcePath = \(identity.persona?.ikigai?.sourcePath ?? "nil")"
    )
    print(
      "  systemInstructions.compactPath = \(identity.systemInstructions?.compactPath ?? "nil")"
    )
    print(
      "  contributionMultipliers present = \(identity.contributionMultipliers != nil)"
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let roundTrip = try encoder.encode(identity)
    let _ = try decoder.decode(IdentityModel.self, from: roundTrip)
    print("PASS round-trip decode")
  }
}
