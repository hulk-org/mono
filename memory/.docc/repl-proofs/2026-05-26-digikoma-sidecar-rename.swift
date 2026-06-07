// 2026-05-26 — Sweep rename Japanese digikoma sidecars to English.
//
// WHAT: Walks <root>/digikoma-*/ subdirs (recursively); for each, git-mv's
//       any Japanese sidecars (アイディ.md, インスト.md, スペック.json,
//       レイ.md) to their English counterparts (identity.md, install.md,
//       spec.json, persona.md), then updates Package.swift's resources
//       block to reference the new names.
//
// WHY:  savepoint v0.1 fails on git's escaped Japanese path form
//       ("pathspec did not match" because git status quotes
//       \343\202\242... and savepoint passes that form to git add).
//       English filenames also improve toolchain compat (greppers, fzf,
//       IDE search). Per [[feedback_digikoma-english-filenames]] doctrine
//       2026-05-26.
//
// HOW:  scratchpad pattern per [[feedback_agent-scratchpad-pattern-repl-proofs]].
//       Run with --dry-run to preview, --apply to execute.
//
// Usage:
//   swift run --package-path private/universal/substrate/agents/claude/memory/.docc/repl-proofs \
//     digikoma-sidecar-rename-2026-05-26 \
//     --root private/universal/substrate/collectives/digikoma-org/private/universal/domain \
//     [--apply]

import Foundation

@main
struct DigikomaSidecarRename {
  static let renameMap: [(old: String, new: String)] = [
    ("アイディ.md", "identity.md"),
    ("インスト.md", "install.md"),
    ("スペック.json", "spec.json"),
    ("レイ.md", "persona.md"),
  ]

  struct DigikomaRenameReport {
    var packageDir: URL
    var renamed: [(old: String, new: String)] = []
    var packageSwiftUpdated: Bool = false
    var errors: [String] = []
  }

  static func main() throws {
    let args = Array(CommandLine.arguments.dropFirst())
    guard let rootIndex = args.firstIndex(of: "--root"),
          rootIndex + 1 < args.count
    else {
      print("usage: digikoma-sidecar-rename-2026-05-26 --root <path> [--apply]")
      exit(1)
    }
    let root = URL(fileURLWithPath: args[rootIndex + 1]).standardizedFileURL
    let apply = args.contains("--apply")

    let mode = apply ? "APPLY" : "DRY-RUN"
    print("digikoma-sidecar-rename: \(mode) — root: \(root.path)")
    print("")

    let digikomaDirs = try findDigikomaDirs(under: root)
    print("scanned \(digikomaDirs.count) digikoma-* subdirs under root")
    print("")

    var totalRenamed = 0
    var totalPackageUpdated = 0
    var reportsWithWork: [DigikomaRenameReport] = []

    for dir in digikomaDirs {
      let report = try process(packageDir: dir, apply: apply)
      if !report.renamed.isEmpty || report.packageSwiftUpdated {
        reportsWithWork.append(report)
        totalRenamed += report.renamed.count
        totalPackageUpdated += report.packageSwiftUpdated ? 1 : 0
      }
    }

    print("digikomas with Japanese sidecars: \(reportsWithWork.count)")
    print("total sidecars to rename: \(totalRenamed)")
    print("Package.swift files to update: \(totalPackageUpdated)")
    print("")

    if !apply {
      print("(dry-run; re-run with --apply to execute)")
    } else {
      print("renames + Package.swift updates applied.")
    }

    if reportsWithWork.contains(where: { !$0.errors.isEmpty }) {
      print("")
      print("errors:")
      for report in reportsWithWork where !report.errors.isEmpty {
        print("  \(report.packageDir.lastPathComponent):")
        for err in report.errors {
          print("    - \(err)")
        }
      }
      exit(2)
    }
  }

  static func findDigikomaDirs(under root: URL) throws -> [URL] {
    let fm = FileManager.default
    guard let enumerator = fm.enumerator(
      at: root,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: [.skipsHiddenFiles])
    else {
      return []
    }
    var dirs: [URL] = []
    for case let url as URL in enumerator {
      let isDir = (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
      guard isDir else { continue }
      if url.lastPathComponent.hasPrefix("digikoma-") {
        dirs.append(url)
        enumerator.skipDescendants()
      }
    }
    return dirs.sorted { $0.path < $1.path }
  }

  static func process(packageDir: URL, apply: Bool) throws -> DigikomaRenameReport {
    var report = DigikomaRenameReport(packageDir: packageDir)
    let fm = FileManager.default

    // Find which old sidecars exist
    let toRename: [(URL, URL)] = renameMap.compactMap { mapping in
      let oldURL = packageDir.appendingPathComponent(mapping.old)
      let newURL = packageDir.appendingPathComponent(mapping.new)
      guard fm.fileExists(atPath: oldURL.path) else { return nil }
      return (oldURL, newURL)
    }

    guard !toRename.isEmpty else { return report }

    // Apply renames via git mv (preserves history)
    for (oldURL, newURL) in toRename {
      report.renamed.append((oldURL.lastPathComponent, newURL.lastPathComponent))
      if apply {
        let result = runGit(
          ["mv", oldURL.lastPathComponent, newURL.lastPathComponent],
          cwd: packageDir)
        if result.exitCode != 0 {
          report.errors.append("git mv \(oldURL.lastPathComponent) failed: \(result.stderr)")
        }
      }
    }

    // Update Package.swift if it references the old names
    let packageSwift = packageDir.appendingPathComponent("Package.swift")
    if fm.fileExists(atPath: packageSwift.path) {
      let original = (try? String(contentsOf: packageSwift, encoding: .utf8)) ?? ""
      var updated = original
      for mapping in renameMap {
        updated = updated.replacingOccurrences(
          of: ".copy(\"../../\(mapping.old)\")",
          with: ".copy(\"../../\(mapping.new)\")")
      }
      if updated != original {
        report.packageSwiftUpdated = true
        if apply {
          do {
            try updated.write(to: packageSwift, atomically: true, encoding: .utf8)
          } catch {
            report.errors.append("Package.swift write failed: \(error)")
          }
        }
      }
    }

    return report
  }

  struct GitResult {
    var exitCode: Int32
    var stdout: String
    var stderr: String
  }

  static func runGit(_ args: [String], cwd: URL) -> GitResult {
    let process = Process()
    process.currentDirectoryURL = cwd
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["git"] + args
    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()
    process.standardOutput = stdoutPipe
    process.standardError = stderrPipe
    do {
      try process.run()
    } catch {
      return GitResult(exitCode: -1, stdout: "", stderr: "spawn failed: \(error)")
    }
    let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
    let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    // Explicitly close pipe FDs — Foundation Process leaks them otherwise,
    // which exhausts the per-process FD limit on long sweeps (~2000+ spawns).
    try? stdoutPipe.fileHandleForReading.close()
    try? stderrPipe.fileHandleForReading.close()
    try? stdoutPipe.fileHandleForWriting.close()
    try? stderrPipe.fileHandleForWriting.close()
    return GitResult(
      exitCode: process.terminationStatus,
      stdout: String(data: stdoutData, encoding: .utf8) ?? "",
      stderr: String(data: stderrData, encoding: .utf8) ?? "")
  }
}
