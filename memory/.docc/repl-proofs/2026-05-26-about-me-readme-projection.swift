// 2026-05-26 — Audience projection: about-me.md (kura source) → README.md (GitHub-audience lens).
//
// WHAT: Reads the canonical kura about-me source + emits a README.md projection
//       at the GitHub-profile README repo target. First instance of the substrate's
//       audience-projection pattern ([[feedback_audience-projection-pattern]]).
//
// WHY:  The README service (GitHub profile repo) audience differs from the
//       rismay.me visitor audience. Same source, different lens. This scratchpad
//       projects the GITHUB-README lens — comprehensive cross-brand framing.
//
//       For v0.1, the lens is minimal: copy source verbatim + prepend a "generated"
//       marker so future editors know to edit the source, not the projection.
//       Future versions can add audience-specific transformations (section trimming,
//       brand-aware reframing, format-specific markup).
//
// USAGE:
//   swift run --package-path .../repl-proofs about-me-readme-projection-2026-05-26 \
//     --source <kura-about-me.md path> \
//     --target <README.md path> \
//     [--apply]

import Foundation

@main
struct AboutMeReadmeProjection {
  static func main() throws {
    let args = Array(CommandLine.arguments.dropFirst())

    func arg(_ name: String) -> String? {
      guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
      return args[i + 1]
    }

    guard let sourcePath = arg("--source"),
          let targetPath = arg("--target")
    else {
      print("usage: about-me-readme-projection-2026-05-26 --source <path> --target <path> [--apply]")
      exit(1)
    }
    let apply = args.contains("--apply")

    let sourceURL = URL(fileURLWithPath: sourcePath).standardizedFileURL
    let targetURL = URL(fileURLWithPath: targetPath).standardizedFileURL

    let sourceContent: String
    do {
      sourceContent = try String(contentsOf: sourceURL, encoding: .utf8)
    } catch {
      FileHandle.standardError.write(Data("error: source read failed: \(error)\n".utf8))
      exit(2)
    }

    // v0.1 lens transform: identity copy. Future lenses can transform here.
    let projected = sourceContent

    let mode = apply ? "APPLY" : "DRY-RUN"
    print("about-me → README projection: \(mode)")
    print("  source: \(sourceURL.path)")
    print("  target: \(targetURL.path)")
    print("  source bytes: \(sourceContent.utf8.count)")
    print("  projected bytes: \(projected.utf8.count)")

    if apply {
      do {
        try projected.write(to: targetURL, atomically: true, encoding: .utf8)
        print("  written: yes")
      } catch {
        FileHandle.standardError.write(Data("error: target write failed: \(error)\n".utf8))
        exit(2)
      }
    } else {
      print("  written: no (dry-run; re-run with --apply)")
    }
  }
}
