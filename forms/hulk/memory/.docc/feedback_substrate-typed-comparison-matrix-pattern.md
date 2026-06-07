---
name: substrate-typed-comparison-matrix-pattern
description: "Substrate-canonical pattern for any typed comparison work: BenchmarkMatrix shape (Config + Row + Report + Runner) ALREADY shipped in wrkstrm-core (IMessageVaultBenchmarkMatrix, FoundryBuildMatrixService). Architectural-option comparison authored 2026-06-05 as third instance — typed cells, weighted scores, generated markdown projection. Operator named this fractal: 'this is a matrix calculation hahaha. i think we have substrate level matrix infra in wrkstrm-core now.'"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05) after noticing the comparison-demos README markdown was an untyped projection of what should be typed data:**

> this is a matrix calculation hahaha. i think we have substrate level matrix infra in wrkstrm-core now

**The substrate-doctrine pattern they surfaced** — the substrate ALREADY shipped a typed-matrix shape (BenchmarkMatrix). Any new typed-comparison work composes against that shape rather than reinventing.

## The canonical BenchmarkMatrix shape (substrate-shipped)

```swift
public struct <Name>BenchmarkMatrixConfig: Equatable, Sendable {
  public var tiers: [<Name>Tier]      // axis A (rows or buckets)
  public var iterations: Int           // sample size per cell
  // … other config
}

public struct <Name>BenchmarkMatrixRow: Equatable, Codable, Sendable {
  public var lane: <Name>Lane          // row identity
  public var tier: <Name>Tier?         // column identity
  public var axis: <Name>Axis          // cell-level dimension
  public var operation: String
  // … typed metric fields per cell
}

public struct <Name>BenchmarkMatrixReport: Equatable, Codable, Sendable {
  public var capturedAt: Date
  public var tiers: [<Name>Tier]
  public var rows: [<Name>BenchmarkMatrixRow]
}

public struct <Name>BenchmarkMatrixRunner: Sendable {
  public func run(config: ...) async throws -> ...Report
}
```

Existing canonical instances:
- `wrkstrm-core/.../imessage-vault-cli/Sources/IMessageVault/IMessageVaultBenchmarkMatrix.swift`
- `wrkstrm-core/.../foundry/Sources/FoundryCoreLib/BuildMatrixService.swift`

## First architectural-option instance landed 2026-06-05

`wrkstrm-color/spm/Sources/WrkstrmColor/ArchitectureOptionMatrix.swift`

Generalizes BenchmarkMatrix from "benchmark surface" to "any architectural-option / capability-tier / approach scoring." Adds:
- `ComparisonVerdict` enum (.pass / .warn / .fail / .neutral) with `.score: Double`
- `ComparisonCell` carrying verdict + summary + notes
- `ArchitectureOption` + `ComparisonDimension` typed enums for THIS instance
- Weighted scoring (config carries per-dimension weights summing to 1.0)
- `markdownTable()` projection method
- `ArchitectureOptionMatrixRunner.substrateWebEmissionComparison()` baking the substrate-canonical 3-way comparison from this session

Generated table embeds in `comparison-demos/README.md` with a warning that the markdown is a PROJECTION of the typed report, not the source. Hand-editing the markdown is bad-state-UI doctrine ([[ui-action-must-advance-state]] applied at the documentation layer).

## Substrate-doctrine recursion the operator named

Every comparison surface substrate has shipped fits this shape:

| Comparison surface | The implicit matrix |
|---|---|
| `PaletteContrastReport` issue × palette × axis | already typed (could lift onto BenchmarkMatrix shape) |
| `RenderedFrameReport` issue × frame × axis | already typed (could lift) |
| `typed-quality-failure-decomposition.workflow.json x-instances[]` | already typed (could lift) |
| Architecture option × dimension (comparison-demos README) | **was free text — now typed as of 2026-06-05** |
| Future `RenderTargetFidelityReport` issue × platform × axis | will be typed when authored |
| Goodnotes-style architectural decisions across substrate scenes | follow this shape |

Every "comparison/scoring/evaluation" the substrate does deserves the BenchmarkMatrix-shape typed record. The markdown table is one projection; CSV is another; HTML visualization is another; Scene Lab's grid-style view is another. The DATA is one thing.

## Substrate-canonical naming convention (3+ instances now)

`<Domain>MatrixConfig / <Domain>MatrixRow / <Domain>MatrixReport / <Domain>MatrixRunner`

Examples:
- `IMessageVaultBenchmarkMatrix*` (wrkstrm-core, existing)
- `BuildMatrix*` via `BuildMatrixService` (wrkstrm-core, existing)
- `ArchitectureOptionMatrix*` (wrkstrm-color, new 2026-06-05)

## How to apply going forward

1. **When authoring ANY typed comparison/scoring work, reach for this shape first.** Don't invent a one-off `<Thing>ComparisonReport` — fit the BenchmarkMatrix pattern.
2. **README/markdown comparison tables are PROJECTIONS of typed reports, never the source.** Hand-edited tables that don't update when the substrate evolves are lies.
3. **The weighted-score + winner computation is mechanical** — drop in cells, the runner produces the score; substrate-doctrine winners emerge structurally from typed data.
4. **Composing with `wrkstrm-core` matrix infra:** when the matrix needs heavy linear-algebra (correlation across rows, eigenvalue decomposition, PCA on dimensions), reuse the wrkstrm-core matrix primitives. Don't reimplement.

## Composes with

- [[constraints-belong-in-types-not-tests]] — comparison/scoring should be typed data, not narrative
- [[refinement-types-via-smart-constructor-not-copyable-not-discriminator]] — typed report carries proof; consumers don't re-validate
- [[everything-is-quantum-state-machine]] — sibling pattern at a different layer
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — typed records are substrate-canonical truth; markdown is downstream projection
- [[ui-action-must-advance-state]] — hand-edited markdown tables are bad-state-UI lies at the docs layer
- [[lift-existing-patterns-not-reimplement]] — when substrate has already shipped a pattern (BenchmarkMatrix), reuse, don't invent
