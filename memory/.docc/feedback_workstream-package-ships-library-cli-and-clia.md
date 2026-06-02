---
name: workstream-package-ships-library-cli-and-clia
description: Workstream Swift Package ships THREE products — typed library + deterministic .cli executable + conversational .clia assistant; canonical product family per workstream
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31: "so there are multiple executables in the workstream package."

**Rule**: Every typed workstream Swift Package ships THREE products:

```swift
let package = Package(
  name: "<workstream-slug>@<org>.workstream",
  products: [
    .library(name: "<Workstream>Workstream", targets: ["<Workstream>Workstream"]),
    .executable(name: "<workstream-slug>",     targets: ["<Workstream>CLI"]),    // .cli
    .executable(name: "<workstream-slug>-chat", targets: ["<Workstream>CLIA"]),  // .clia
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    .package(path: "<path-to>/digikoma-org/private/universal/domain/core/digikoma-core"),
    .package(path: "<path-to>/schema-universal/.../conversation-protocol-schemas/v0.1.0/spm/conversation-protocol-schemas-v000-000-000"),
  ],
  targets: [
    .target(name: "<Workstream>Workstream", path: "Sources/<Workstream>Workstream"),
    .executableTarget(
      name: "<Workstream>CLI",
      dependencies: ["<Workstream>Workstream", .product(name: "ArgumentParser", package: "swift-argument-parser")],
      path: "Sources/<Workstream>CLI"
    ),
    .executableTarget(
      name: "<Workstream>CLIA",
      dependencies: [
        "<Workstream>Workstream",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "DigikomaCore", package: "digikoma-core"),
        .product(name: "ConversationProtocol_Schemas_v000_000_000", package: "conversation-protocol-schemas-v000-000-000"),
      ],
      path: "Sources/<Workstream>CLIA"
    ),
    .testTarget(name: "<Workstream>WorkstreamTests", ...),
  ]
)
```

**Why**: per [[feedback_workstreams-as-swift-packages-next-layer]] workstreams ARE Swift Packages; per [[feedback_clia-is-cli-assistant-form-factor]] `.clia` is the typed CLI-assistant form-factor; per [[feedback_workstream-ghost-chat-protocol-super-attack]] the workstream ships a SUPER-POWERED chat ghost protocol. Three products = three consumer surfaces:
- LIBRARY for compile-checked typed integration in other Swift Packages
- `.cli` executable for deterministic shell automation (`instantiate`, `walk`, `status`, run from shell scripts, CI)
- `.clia` executable for CONVERSATIONAL inspection ("what stage am I in?", "why did gate 3 fail?", "show me the receipts for the last walk", multi-turn, pi-fold typed context preservation, agent-talkable)

The operator framed it precisely: "so there are multiple executables in the workstream package" — the answer to "what do you get from this Package.swift?" is now THREE: typed lib + deterministic CLI + conversational assistant.

**How to apply**:
- Refactor existing single-executable workstream Packages (creative-selection, spawn-software, maintain-software, creative-selection-loop, clia-rpg-spawn-run) to add `.clia` targets alongside their existing `.cli`.
- DELETE any hardcoded `Chat` subcommand in `.cli` executables — that bypasses the typed conversation protocol; chat lives in `.clia` only.
- Author `Sources/<Workstream>CLIA/` mirroring `Sources/<Workstream>CLI/` shape but consuming `DigikomaConversationCommand.chat()` + `DigikomaConversationPacketFactory` + a `DigikomaIntelligenceProvider` conformer.
- The `.clia` executable's CLI usage block declares it conversational; per `DigikomaConversationCommandParser.usage()`:
  ```
  workstream-chat ask --question <text> [--path <file>] [--output <json>] [--packet-output <json>]
  workstream-chat chat [--question <text>] [--path <file>] [--output <json>] [--packet-output <json>]
  ```
  with `/exit`, `/quit` interactive commands.

**Composes with**: [[feedback_workstream-ghost-chat-protocol-super-attack]] (what the .clia runs) + [[feedback_clia-is-cli-assistant-form-factor]] (the form-factor convention) + [[feedback_workstreams-as-swift-packages-next-layer]] (the parent doctrine) + [[feedback_substrate-composes-typed-idea-molecules]] (3-product family as composed typed molecule).
