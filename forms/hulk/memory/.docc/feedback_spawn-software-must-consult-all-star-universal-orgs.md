---
name: spawn-software-must-consult-all-star-universal-orgs
description: "Substrate-doctrine STAGE of spawn-software: every spawn-software workstream MUST walk every *-universal collective (schema-universal, swift-universal, spaces-universal, service-universal, swift-ui-universal, swift-gen-ui-universal, …) and harvest CANONICAL best-practice primitives before authoring app-local equivalents. New typed workflow at spaces-universal/.../workflows/spawn-software-universal-best-practices-audit/v0.1.0/ enforces this as a gate BEFORE design-truth-packet authoring. Operator-articulated 2026-06-05."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05) after the cull-by-wrkstrm spawn-request packet landed:**

> remember that spawn-software must go through all *-universal orgs in order to get the BEST practices for the software generation process! update workstreams and workflows if necessary.

## Substrate-doctrine STAGE this names

Every spawn-software workstream MUST walk every `*-universal` collective in `private/universal/substrate/collectives/` and harvest CANONICAL best-practice primitives BEFORE authoring app-local equivalents. The walk produces a typed audit receipt; design-truth-packet authoring CANNOT start until the receipt is committed.

## *-universal orgs as of 2026-06-05

| Org | Owner domain | Canonical surfaces to consume |
|---|---|---|
| `schema-universal` | typed-data shapes | `schemas-sets/`, `domain/` schema-families, `kura-spaces/` schema-lifecycle workflows + axioms |
| `swift-universal` | Swift canonical primitives | `spm/domain/system/` (common-process, common-shell, common-log, common-archive, common-cli), `spm/domain/build/`, `spm/domain/tooling/` (substrate-canonical Swift CLIs), `spm/domain/localization/` |
| `spaces-universal` | kura-spaces typed coordination | `kura-spaces/workflows/`, `kura-spaces/axioms/`, `kura-spaces/role/` formulae, `kura-spaces/tools/` tool↔role↔workflow dispatch graph |
| `service-universal` | runtime services | `domain/config/`, `domain/flags/` feature flags, `domain/network/`, `domain/runtime/`, `domain/design/` (WrkstrmDesignTokenService home), `domain/color/`, `domain/video/` |
| `swift-ui-universal` | SwiftUI primitives | substrate-canonical SwiftUI View primitives + modifiers (currently empty — pattern-spotting surface per [[empty-placeholder-dirs-are-pattern-surfaces]]; populating is part of spawn-software contributions) |
| `swift-gen-ui-universal` | Generative-UI primitives | Apple @Generable typed record contracts, generative-UI typed surfaces (currently empty) |

## The new typed workflow

`spaces-universal/.../workflows/spawn-software-universal-best-practices-audit/v0.1.0/spawn-software-universal-best-practices-audit.workflow.json`

Six stages:
1. **enumerate-universal-orgs** — walk `collectives/` and list every `-universal` dir at audit time. New `*-universal` orgs added to substrate AUTOMATICALLY enter the audit; no per-workflow edit needed
2. **walk-each-universal-org** — per-org LIFT / GAP / PASS-THROUGH lines
3. **name-substrate-modern-composition-checklist-failures** — every hand-rolled component with a canonical equivalent is named (composes with [[feedback_substrate-modern-composition-checklist-is-required-spawn-software-proof-gate]])
4. **author-universal-best-practices-audit-receipt** — emit typed receipt at the spawn-software's owning collective
5. **bead-track-gaps** — for every GAP, author a typed bead/epic at the *-universal org needing to contribute
6. **gate-spawn-software-progression** — design-truth + implementation stages CANNOT START until receipt is committed

## First instance landed 2026-06-05

`scene-lab/agenda/spawn-software/cull-by-wrkstrm.universal-best-practices-audit-receipt.json` — 6 orgs walked, 11 GAP beads tracked, 7-line modern-composition-checklist captures every hand-rolled component with a canonical equivalent.

Key findings from the cull-by-wrkstrm first instance:
- `swift-ui-universal` empty — Cull's hand-rolled SwiftUI primitives (PaletteCard, PaletteStateRow, ReadingListRow, BookmarkRow) SEED its first canonical primitives. This is the substrate-doctrine inflection where `swift-ui-universal` becomes populated.
- `safari-bookmarks-schemas` must be authored at `schema-universal/domain/platforms/schema-families/` (currently local to scene-lab — violates [[All schemas live in schema-universal, not in the consuming collective]])
- `creative-selection-runner.role-surface-manifest.json` must declare Cull as the role's operator-facing app surface
- `service-universal/domain/design/WrkstrmDesignTokenService` consumption is MANDATORY for design tokens
- `swift-universal/spm/domain/system/common-log` MUST replace raw `NSLog` and `print()`

## Composes with

- [[spawn-software-workstream-required-for-tool-authoring]] — parent doctrine; this workflow is the new mandatory STAGE
- [[issue-found-means-entire-spawn-software-rerun]] — when an audit finding surfaces post-launch, the workstream re-runs
- [[lift-existing-patterns-not-reimplement]] — the foundational substrate axiom this workflow enforces at the *-universal scale
- [[grep-substrate-common-star-before-authoring-tool-code]] — sibling discipline at the per-primitive scale
- [[Audit schema-universal for existing typed contracts before authoring new ones]] — schema-universal-specific instance
- [[All schemas live in schema-universal, not in the consuming collective]] — schema-universal placement rule
- [[empty-placeholder-dirs-are-pattern-surfaces]] — explains why empty `*-universal` dirs are still load-bearing (they MARK the substrate's intent to populate)
- [[common-and-mono-are-the-platform-engineers]] — the *-universal orgs ARE the substrate's platform-engineering teams; consulting them = consulting platform-engineering
- [[feedback_substrate-modern-composition-checklist-is-required-spawn-software-proof-gate]] — the composition checklist that this workflow's stage 3 produces

## How to apply going forward

1. **When authoring a spawn-request packet, list `<slug>.universal-best-practices-audit-receipt.json` as the FIRST downstream artifact** — it precedes design-truth-packet, ontology-review-receipt, implementation-surface-receipt, everything.
2. **Run the audit as a literal stage** — walk every `*-universal` org under `collectives/`, name what your spawn-software composes against and what gaps exist.
3. **Bead-track every gap** — never ship a hand-rolled-local-equivalent without the bead at the *-universal org that should contribute.
4. **Gate downstream stages on the receipt** — design-truth-packet authoring is BLOCKED until the receipt is committed. The substrate's typed-everything discipline depends on this gate.
