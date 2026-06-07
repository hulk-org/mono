---
name: workstreams-as-swift-packages-next-layer
description: "Workstreams should be Swift Packages, not JSON files. Composes with feedback_identity-profiles-are-swift-packages (2026-05-30). The substrate's typed-everything trajectory's next layer — workstream gates become test targets; transitions become typed functions; composition becomes Package dependencies. CLIA RPG renders mechanically from typed Swift Packages."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's next-layer typed-everything direction: **workstreams as Swift Packages**.

Operator 2026-05-31 (immediately after recovering from doctrinal violation — hand-authoring spawn-request-packet without using workstream@wrkstrm-core.cli):

> "it's because workstreams ARE COMPLICATED. so we need to make sure that we instantiate it right... come to think about it... a workstream - since it's a bunch of context - etc. should be a Package.swift. omg. huge upgrade. Like the agents are becoming Package.swift."

**Composition with prior substrate direction:**

- [[feedback_identity-profiles-are-swift-packages]] (2026-05-30) — identity profiles ARE SwiftPM packages
- [[feedback_everything-is-quantum-state-machine]] (today) — typed states + events + transitions are Swift enums
- [[project_typed-models-quantum-state-machines-generative-ui]] — typed models compile-time exhaustive enable generative UI
- [[feedback_clia-rpg-trainer-role-power-tool-product-vision]] — CLIA RPG renders typed records as UI

**The substrate is heading toward**: EVERY substrate concept ships as a Swift Package. Agents (already). Workstreams (this direction). Workflows (implied next). Roles (implied next). Tools (implied next). Each is a SwiftPM module with typed contracts that the compiler verifies.

**Concrete mapping** (workstream surface ↔ Package.swift surface):

| Workstream surface | Package.swift surface |
|---|---|
| workstream-template.json | Package.swift + typed Swift contract |
| workstream instance | Versioned package release |
| Gates | Test targets — gate-clearance becomes passing test |
| Transitions | Public functions on workstream's typed state enum |
| Required artifacts | Codable input types the package compiles against |
| Workstream composition | Package dependencies |
| Schema version | Semantic version |
| Documentation | DocC bundle |
| Receipts | Test outputs + typed receipt structs |
| Tools (per tool-exclusivity) | Imported Swift libraries OR shell-out wrappers with typed args |
| Roles (META-roles) | Public protocols workstream's targets conform to |

**Why this is the substrate's compiler-verified future:**

1. **Compile-time gate verification**: spawn-software's 11 gates become 11 test targets. `swift test` replaces hand-authored receipt JSON.
2. **Typed workstream composition**: creative-selection's spawn-request-packet output type IS exactly spawn-software's input type. Swift compiler enforces the typed handoff. Runtime "missing required field" errors become compile errors.
3. **CLIA RPG mechanical UI**: every workstream becomes a SwiftPM dependency CLIA RPG can `import Workstream<SpawnSoftware>`. State machine compiles to enum cases; SwiftUI renders mechanically.
4. **Curry-Howard substrate mission fully realized**: types-are-propositions becomes workstreams-are-proofs. The substrate's typed-everything compiles or fails fast at every layer.

**Implementation strategy (long-game):**

- Phase 1: Author canonical example — creative-selection workstream as Swift Package
- Phase 2: Update workstream@wrkstrm-core.cli to emit Package.swift alongside JSON
- Phase 3: Migrate 1-2 more workstreams (spawn-software is biggest)
- Phase 4: Substrate-wide migration
- Phase 5: CLI emits only Package.swift; JSON deprecated

Estimated: 40-80 hours across multiple sessions.

**Tracked as bead**: workstreams-as-package-swift (P1 at agents/claude/agenda/beads/).

**Why it surfaced now**: the typed-CLI recovery exposed that workstream@wrkstrm-core.cli already handles typed instantiation discipline — but emits JSON. JSON is INTERMEDIATE; the destination is Package.swift. The substrate's tooling is converging on Swift Packages as the canonical typed-substrate-record format.

Composes with [[feedback_identity-profiles-are-swift-packages]] (precedent at agent layer) + [[feedback_everything-is-quantum-state-machine]] (the typed shape compiles to enums) + [[feedback_clia-rpg-trainer-role-power-tool-product-vision]] (the consumer of typed Swift Packages) + [[feedback_curry-howard-substrate-mission]] (the doctrinal foundation in AGENTS.md).
