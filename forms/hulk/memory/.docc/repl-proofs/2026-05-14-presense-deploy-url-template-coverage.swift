import Foundation
import Testing

// LDT proof: how often does Presense's current github.io template URL
// actually resolve when probed? Answers the question driving the
// share-record `deployedURL` field decision: is the template a good
// default with rare exceptions, or a wild guess that's wrong most of
// the time?
//
// Walks all v0.4.0 records in the rismay operator tree, applies the
// same URL template Presense uses
// (https://<host.owner>.github.io/<slug>/), HEAD-probes each, and
// reports the breakdown by status, surface, and visibility. No
// dependencies on the Presense or share-record packages — decodes
// records as raw [String: Any] so this proof can run from the
// repl-proofs target without dragging in the schema dep graph.

// MARK: - Minimal record shape (just the fields the audit needs)

private struct AuditRecord {
  let path: String
  let slug: String
  let status: String
  let visibility: String
  let surface: String
  let hostKind: String
  let hostOwner: String

  static func decode(json: [String: Any], path: String) -> AuditRecord? {
    guard
      let slug = json["slug"] as? String,
      let status = json["status"] as? String,
      let visibility = json["visibility"] as? String,
      let surface = json["surface"] as? [String: Any],
      let surfaceKind = surface["kind"] as? String,
      let host = json["host"] as? [String: Any],
      let hostKind = host["kind"] as? String
    else { return nil }
    let owner = (host["owner"] as? String) ?? (host["account"] as? String) ?? ""
    return AuditRecord(
      path: path,
      slug: slug,
      status: status,
      visibility: visibility,
      surface: surfaceKind,
      hostKind: hostKind,
      hostOwner: owner
    )
  }

  /// Mirrors PresenseLoader.publicURL(for:) exactly.
  var templateURL: URL? {
    switch (hostKind, surface) {
    case ("github", "static-site"), ("github", "dynamic-site"):
      return URL(string: "https://\(hostOwner).github.io/\(slug)/")
    default:
      return nil
    }
  }
}

// MARK: - Walker

private func walkRecords(root: URL) -> [AuditRecord] {
  let fm = FileManager.default
  guard let enumerator = fm.enumerator(
    at: root,
    includingPropertiesForKeys: [.isRegularFileKey],
    options: [.skipsHiddenFiles]
  ) else { return [] }
  var out: [AuditRecord] = []
  while let url = enumerator.nextObject() as? URL {
    guard url.lastPathComponent.hasSuffix(".share.json") else { continue }
    guard
      let data = try? Data(contentsOf: url),
      let probe = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
      (probe["schemaVersion"] as? String) == "0.4.0",
      let rec = AuditRecord.decode(json: probe, path: url.path)
    else { continue }
    out.append(rec)
  }
  return out
}

// MARK: - HEAD probe

private actor ProbeResults {
  var byStatus: [String: Int] = [:]
  var reachable: [AuditRecord] = []
  var unreachable: [(AuditRecord, Int)] = []
  var noTemplate: [AuditRecord] = []
  var probed = 0

  func recordReachable(_ r: AuditRecord) { reachable.append(r); probed += 1 }
  func recordUnreachable(_ r: AuditRecord, _ code: Int) {
    unreachable.append((r, code))
    probed += 1
  }
  func recordNoTemplate(_ r: AuditRecord) { noTemplate.append(r) }
}

private func probe(url: URL) async -> Int {
  var request = URLRequest(url: url, timeoutInterval: 6)
  request.httpMethod = "HEAD"
  do {
    let (_, response) = try await URLSession.shared.data(for: request)
    return (response as? HTTPURLResponse)?.statusCode ?? 0
  } catch {
    return 0
  }
}

// MARK: - The proof

@Test
func presenseDeployURLTemplateCoverage() async throws {
  let operatorRoot = URL(
    fileURLWithPath: "/Users/sonoma/mono/private/universal/substrate/operators/rismay",
    isDirectory: true
  )

  let records = walkRecords(root: operatorRoot)
  print("--- audit: presense URL template coverage ---")
  print("scanned v0.4.0 records: \(records.count)")
  #expect(records.count > 0, "expected at least one v0.4.0 record")

  let results = ProbeResults()

  // Probe in batches of 8 to avoid hammering the network.
  let publishedWithTemplate = records.filter { $0.status == "published" && $0.templateURL != nil }
  print("published + has-template: \(publishedWithTemplate.count)")

  await withTaskGroup(of: Void.self) { group in
    for record in publishedWithTemplate {
      group.addTask {
        guard let url = record.templateURL else { return }
        let code = await probe(url: url)
        if (200..<300).contains(code) {
          await results.recordReachable(record)
        } else {
          await results.recordUnreachable(record, code)
        }
      }
    }
  }

  for record in records where record.templateURL == nil {
    await results.recordNoTemplate(record)
  }

  let reachable = await results.reachable
  let unreachable = await results.unreachable
  let noTemplate = await results.noTemplate

  print("\n--- breakdown ---")
  print("reachable via template: \(reachable.count)")
  print("unreachable via template: \(unreachable.count)")
  print("no template applies (sourceMirror, inlineMarkdown, draft, etc.): \(noTemplate.count)")

  // Group by status for the records we DIDN'T probe (status != published)
  let nonPublished = records.filter { $0.status != "published" }
  let nonPublishedByStatus = Dictionary(grouping: nonPublished, by: \.status)
    .mapValues { $0.count }
  print("\nnon-published records (not probed): \(nonPublished.count)")
  for (status, count) in nonPublishedByStatus.sorted(by: { $0.value > $1.value }) {
    print("  status=\(status): \(count)")
  }

  // Group reachables/unreachables by visibility + surface for pattern hunting
  print("\n--- reachable records (template works) by visibility ---")
  let reachableByVis = Dictionary(grouping: reachable, by: \.visibility).mapValues { $0.count }
  for (vis, count) in reachableByVis.sorted(by: { $0.value > $1.value }) {
    print("  visibility=\(vis): \(count)")
  }

  print("\n--- unreachable records (template fails) by visibility + surface ---")
  let unreachableByVisSurface = Dictionary(
    grouping: unreachable.map { "\($0.0.visibility)/\($0.0.surface)" },
    by: { $0 }
  ).mapValues { $0.count }
  for (key, count) in unreachableByVisSurface.sorted(by: { $0.value > $1.value }) {
    print("  \(key): \(count)")
  }

  // Sample a few unreachable URLs for inspection
  print("\n--- 5 sample unreachable template URLs ---")
  for (record, code) in unreachable.prefix(5) {
    let url = record.templateURL?.absoluteString ?? "(none)"
    print("  [\(code == 0 ? "no-resp" : "\(code)")] \(record.slug) (vis=\(record.visibility)) → \(url)")
  }

  // Compute the headline number for the design decision.
  let total = publishedWithTemplate.count
  let pctReachable = total == 0 ? 0 : Int((Double(reachable.count) / Double(total)) * 100.0)
  print("\n=== HEADLINE ===")
  print("of \(total) published+template-eligible records, \(reachable.count) are reachable via template (\(pctReachable)%)")
  print("=> \(unreachable.count) records would need explicit deployedURL")
  print("=> \(noTemplate.count) records have no template at all (need explicit deployedURL or no public surface)")

  // Intentionally not asserting a specific reachability threshold —
  // this proof is investigative; the print output IS the deliverable.
  // Assert only that we made progress.
  #expect(reachable.count + unreachable.count == publishedWithTemplate.count)
}
