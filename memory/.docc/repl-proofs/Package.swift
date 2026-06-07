// swift-tools-version: 6.0
import PackageDescription

// Claude's repl-proofs corpus. Each .swift file at this level is one
// scratchpad — substrate-claim proof OR one-shot operational tool — per
// feedback_agent-scratchpad-pattern-repl-proofs doctrine.
//
// Each scratchpad declares its own executable product / target below as
// they're added. Use:
//   swift run --package-path private/universal/substrate/agents/claude/memory/.docc/repl-proofs <product-name> [args]

let scratchpadSources = [
  "2026-05-26-digikoma-sidecar-rename.swift",
  "2026-05-26-axis-to-kura-extract.swift",
  "2026-05-26-path-rewrite.swift",
  "2026-05-26-about-me-readme-projection.swift",
  "2026-05-28-spawn-gate-set-materializer.swift",
  "2026-05-30-identity-v0_7_0-decode.swift",
  "2026-05-30-ontology-properties.swift",
]

func exclusions(for source: String) -> [String] {
  ["Package.swift"] + scratchpadSources.filter { $0 != source }
}

let identitySchemasV7Path =
  "../../../../../collectives/schema-universal/private/universal/domain/identity/schema-families/identity-schemas/v0.7.0/spm/identity-schemas-v000-007-000"

let swiftCheckPath =
  "../../../../../collectives/swift-universal/private/universal/domain/build/spm/swift-check"

let package = Package(
  name: "ClaudeReplProofs",
  platforms: [.macOS(.v14)],
  products: [
    .executable(
      name: "digikoma-sidecar-rename-2026-05-26",
      targets: ["digikoma-sidecar-rename-2026-05-26"]),
    .executable(
      name: "axis-to-kura-extract-2026-05-26",
      targets: ["axis-to-kura-extract-2026-05-26"]),
    .executable(
      name: "path-rewrite-2026-05-26",
      targets: ["path-rewrite-2026-05-26"]),
    .executable(
      name: "about-me-readme-projection-2026-05-26",
      targets: ["about-me-readme-projection-2026-05-26"]),
    .executable(
      name: "spawn-gate-set-materializer-2026-05-28",
      targets: ["spawn-gate-set-materializer-2026-05-28"]),
    .executable(
      name: "identity-v0_7_0-decode-2026-05-30",
      targets: ["identity-v0_7_0-decode-2026-05-30"]),
  ],
  dependencies: [
    .package(name: "Identity_Schemas_v000_007_000", path: identitySchemasV7Path),
    .package(name: "SwiftCheck", path: swiftCheckPath),
  ],
  targets: [
    .executableTarget(
      name: "digikoma-sidecar-rename-2026-05-26",
      path: ".",
      exclude: exclusions(for: "2026-05-26-digikoma-sidecar-rename.swift"),
      sources: ["2026-05-26-digikoma-sidecar-rename.swift"]
    ),
    .executableTarget(
      name: "axis-to-kura-extract-2026-05-26",
      path: ".",
      exclude: exclusions(for: "2026-05-26-axis-to-kura-extract.swift"),
      sources: ["2026-05-26-axis-to-kura-extract.swift"]
    ),
    .executableTarget(
      name: "path-rewrite-2026-05-26",
      path: ".",
      exclude: exclusions(for: "2026-05-26-path-rewrite.swift"),
      sources: ["2026-05-26-path-rewrite.swift"]
    ),
    .executableTarget(
      name: "about-me-readme-projection-2026-05-26",
      path: ".",
      exclude: exclusions(for: "2026-05-26-about-me-readme-projection.swift"),
      sources: ["2026-05-26-about-me-readme-projection.swift"]
    ),
    .executableTarget(
      name: "spawn-gate-set-materializer-2026-05-28",
      path: ".",
      exclude: exclusions(for: "2026-05-28-spawn-gate-set-materializer.swift"),
      sources: ["2026-05-28-spawn-gate-set-materializer.swift"]
    ),
    .executableTarget(
      name: "identity-v0_7_0-decode-2026-05-30",
      dependencies: [
        .product(
          name: "Identity_Schemas_v000_007_000",
          package: "Identity_Schemas_v000_007_000"),
      ],
      path: ".",
      exclude: exclusions(for: "2026-05-30-identity-v0_7_0-decode.swift"),
      sources: ["2026-05-30-identity-v0_7_0-decode.swift"]
    ),
    .testTarget(
      name: "OntologyPropertyTests",
      dependencies: [
        .product(name: "SwiftCheck", package: "SwiftCheck"),
      ],
      path: ".",
      exclude: exclusions(for: "2026-05-30-ontology-properties.swift"),
      sources: ["2026-05-30-ontology-properties.swift"]
    ),
  ]
)
