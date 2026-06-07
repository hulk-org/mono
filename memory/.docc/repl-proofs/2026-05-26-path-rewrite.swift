// 2026-05-26 — Bulk path-string rewrite across an explicit file list.
//
// WHAT: Reads each file in --files, replaces every occurrence of --from with
//       --to, writes back. Atomic per-file. Reports counts.
//
// WHY:  Third occurrence of "rewrite a path string across N files" this
//       session (digikoma sidecar rename → kura axis extract → switcheroo
//       cleanup). Per [[feedback_substrate-toolmaking-checklist]] third-
//       occurrence rule, this MUST be a tool. Generic enough that future
//       path-rename sweeps reuse it.
//
// Usage:
//   swift run --package-path .../repl-proofs path-rewrite-2026-05-26 \
//     --from <old-string> --to <new-string> \
//     --files <path1> <path2> ...

import Foundation

@main
struct PathRewrite {
  static func main() throws {
    let args = Array(CommandLine.arguments.dropFirst())

    func arg(_ name: String) -> String? {
      guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
      return args[i + 1]
    }

    guard let fromString = arg("--from"),
          let toString = arg("--to"),
          let filesIdx = args.firstIndex(of: "--files")
    else {
      print("usage: --from <old> --to <new> --files <path1> <path2> ...")
      exit(1)
    }
    let filePaths = Array(args.dropFirst(filesIdx + 1))
    guard !filePaths.isEmpty else {
      print("error: --files must list at least one path")
      exit(1)
    }

    print("rewrite: '\(fromString)' → '\(toString)' across \(filePaths.count) file(s)")
    print("")

    var totalRewrites = 0
    var changedFiles = 0
    for path in filePaths {
      let url = URL(fileURLWithPath: path)
      guard let original = try? String(contentsOf: url, encoding: .utf8) else {
        print("  skip (read failed): \(path)")
        continue
      }
      let occurrences = original.components(separatedBy: fromString).count - 1
      guard occurrences > 0 else {
        print("  no-op: \(path)")
        continue
      }
      let updated = original.replacingOccurrences(of: fromString, with: toString)
      try updated.write(to: url, atomically: true, encoding: .utf8)
      totalRewrites += occurrences
      changedFiles += 1
      print("  rewrote \(occurrences)x in \(path)")
    }

    print("")
    print("done: \(totalRewrites) replacements across \(changedFiles) file(s)")
  }
}
