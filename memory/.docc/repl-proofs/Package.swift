// swift-tools-version: 6.0
import PackageDescription

// LDT proof corpus. Each .swift file at this level is one proof,
// realized as a single @Test func. Run with:
//   swift test --package-path ~/.claude/memory/.docc/repl-proofs/

let package = Package(
  name: "ReplProofs",
  platforms: [.macOS(.v14)],
  targets: [
    .testTarget(
      name: "ReplProofs",
      path: ".",
      exclude: [
        "Package.swift",
        // Pre-existing script-mode proof (not converted to Swift Testing
        // in this round). Top-level expressions are illegal in test
        // target compilation; convert in a separate, authorized pass.
        "2026-04-29-broker-constraint-matrix-and-copyable-session.swift",
      ]
    )
  ]
)
