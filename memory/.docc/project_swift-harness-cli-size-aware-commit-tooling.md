---
name: swift-harness-cli-size-aware-commit-tooling
description: "Substrate factory candidate — size-aware commit staging (≥100MB filter, leaves-first submodule traversal, ledger emission) should be a first-class swift-harness-cli primitive, not an ad-hoc bash recipe. Operator-named 2026-05-26 after I hand-rolled the bash and they flagged \"should be a part of swift-harness-cli so that we can track this.\""
metadata: 
  node_type: memory
  type: project
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

**Fact:** the bash recipe to filter staged files by size, exclude ≥100MB blobs, walk submodules leaves-first, and produce a clean commit set should be lifted into `swift-harness-cli` as a typed CLI primitive that emits a ledger record per invocation.

**Why:** the user named this on 2026-05-26 when I hit the GitHub 100MB file rejection during the kura/vaults submodule rename cleanup. They explicitly said: "these session searches should be a part of swift-harness-cli so that we can track this!" The intent is exactly the digikoma factory pattern from [[insights/substrate-is-digikoma-factory-2026-05-23]]:
- Reusable bounded executor with typed contract (input: paths + threshold; output: safe set + excluded set + per-file size manifest)
- Absorbs a repeating agent-side burden (every multi-MB submodule commit in this workspace will hit this)
- Clean intent→apply→ledger handoff (declared intent, applied to index, ledger record of what was filtered)
- Runs independent of agent session (CI-callable, savepointd-callable)

**How to apply:**
- Don't author ad-hoc bash size-filters when this kind of pattern recurs — flag it as a swift-harness-cli sub-command candidate.
- The existing skill `git-drain-files` already describes the leaves-first traversal pattern; it should call this new CLI primitive rather than reimplement the logic.
- Cost surface: compose with `inference-account-schemas v0.2.0` per [[insights/substrate-sync-cost-pattern-2026-05-26]] and [[feedback_cost-model-non-divergence-discipline]] — every invocation emits a typed CommitFilterInvoice into the ledger.
- Composes with `swift-git-cli` (already in the substrate) for the underlying git operations and submodule status checks.
- Reference incident: the codex-sessions submodule rename, 2026-05-26 — `git add -A` swept in 21+ files over 100MB up to 438MB. Hand-rolled `git ls-tree -r -l HEAD | awk '$4 > 100*1024*1024'` is what the CLI should provide as a primitive.

**Companion entries:** [[insights/substrate-is-digikoma-factory-2026-05-23]] · [[feedback_diff-cached-before-every-commit]] · [[feedback_savepoint-daemon-races-commits]]
