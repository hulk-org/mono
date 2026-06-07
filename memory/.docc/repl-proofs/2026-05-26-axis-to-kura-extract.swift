// 2026-05-26 — Extract one axis from rismay.me's axis catalog into a kura tier.
//
// WHAT: Reads `data/rismay-axis-catalog.json`, finds the axis by id, writes
//       each room as a separate JSON file in the kura output directory, and
//       writes an index.md describing the axis.
//
// WHY:  Per the substrate doctrine "data is one thing, rendering is a
//       projection" ([[feedback_data-is-one-thing-rendering-is-projection]]):
//       the catalog SHOULD live in kura as the canonical storage, with the
//       site reading from a projection of kura. This scratchpad does step 1
//       (migrate the data to kura). The projection step (kura → projection
//       JSON the site consumes) is separate.
//
// TIER: The caller passes the kura tier directory, e.g.
//         operators/rismay/public/universal/kura/timelines/institutional-axis/
//       Tier choice is the caller's decision per
//       [[feedback_kura-tier-axis-definitions]] — Institutions is a timeline
//       (chronological journey), other axes get tier-checked individually.
//
// Usage:
//   swift run --package-path private/universal/substrate/agents/claude/memory/.docc/repl-proofs \
//     axis-to-kura-extract-2026-05-26 \
//     --catalog private/universal/substrate/operators/rismay/public/gh-pages/rismay-github-io/data/rismay-axis-catalog.json \
//     --axis-id institutional-axis \
//     --out private/universal/substrate/operators/rismay/public/universal/kura/timelines/institutional-axis \
//     --tier-label timeline

import Foundation

@main
struct AxisToKuraExtract {
  static func main() throws {
    let args = Array(CommandLine.arguments.dropFirst())

    func arg(_ name: String) -> String? {
      guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
      return args[i + 1]
    }

    guard let catalogPath = arg("--catalog"),
          let axisId = arg("--axis-id"),
          let outDir = arg("--out")
    else {
      print("""
        usage: axis-to-kura-extract-2026-05-26 \
        --catalog <path> --axis-id <id> --out <kura-tier-dir> [--tier-label <name>]
        """)
      exit(1)
    }
    let tierLabel = arg("--tier-label") ?? "collection"

    let data = try Data(contentsOf: URL(fileURLWithPath: catalogPath))
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let axes = json["axes"] as? [[String: Any]]
    else {
      print("error: catalog is not a top-level object with axes[]")
      exit(2)
    }
    guard let axis = axes.first(where: { ($0["id"] as? String) == axisId }) else {
      print("error: axis not found: \(axisId)")
      exit(2)
    }

    let outURL = URL(fileURLWithPath: outDir).standardizedFileURL
    try FileManager.default.createDirectory(
      at: outURL, withIntermediateDirectories: true, attributes: nil)

    let rooms = (axis["rooms"] as? [[String: Any]]) ?? []
    print("extract: axis=\(axisId) tier=\(tierLabel) rooms=\(rooms.count) out=\(outURL.path)")

    var writtenFiles: [String] = []
    for room in rooms {
      let seq = room["sequenceNumber"] as? Int ?? 0
      let shortTitle = (room["shortTitle"] as? String ?? "room")
        .lowercased()
        .replacingOccurrences(of: " ", with: "-")
        .replacingOccurrences(of: ".", with: "-")
        .replacingOccurrences(of: "/", with: "-")
      let filename = String(format: "%03d-%@.json", seq, shortTitle)
      let roomURL = outURL.appendingPathComponent(filename)
      let roomData = try JSONSerialization.data(
        withJSONObject: room, options: [.prettyPrinted, .sortedKeys])
      let roomDataWithNewline = roomData + Data([0x0A])
      try roomDataWithNewline.write(to: roomURL, options: [.atomic])
      writtenFiles.append(filename)
      print("  wrote: \(filename)")
    }

    let axisLabel = axis["label"] as? String ?? axisId
    let axisAcc = axis["accession"] as? String ?? ""
    let activeRoomID = axis["activeRoomID"] as? String ?? ""

    let roomTitles = rooms.compactMap { $0["title"] as? String }
    let roomFiles = zip(writtenFiles, roomTitles).map { "- [\($0.1)](\($0.0))" }
      .joined(separator: "\n")

    let indexContent = """
      # \(axisLabel)

      | | |
      |---|---|
      | Axis accession | \(axisAcc) |
      | Axis id | \(axisId) |
      | Kura tier | \(tierLabel) |
      | Active room id | \(activeRoomID) |
      | Rooms | \(rooms.count) |

      Storage tier is **\(tierLabel)** per [[feedback_kura-tier-axis-definitions]].
      The site (rismay.me) reads this via a projection step that walks the tier
      and emits `data/axis-site-projection.json`, per
      [[feedback_data-is-one-thing-rendering-is-projection]].

      ## Rooms (in sequence)

      \(roomFiles)

      ## Source

      Extracted from `\(catalogPath)` via the
      `axis-to-kura-extract-2026-05-26` scratchpad on \(currentDateISO()).
      """

    let indexURL = outURL.appendingPathComponent("index.md")
    try indexContent.write(to: indexURL, atomically: true, encoding: .utf8)
    print("  wrote: index.md")
    print("done: \(rooms.count) rooms + index.md → \(outURL.path)")
  }

  static func currentDateISO() -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    return formatter.string(from: Date())
  }
}
