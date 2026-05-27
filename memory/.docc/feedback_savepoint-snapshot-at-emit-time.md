---
name: savepoint-snapshot-at-emit-time
description: "savepoint-cli must capture the diff snapshot AT EMIT TIME (not at execute time). Becomes load-bearing when savepointd goes async (v0.2 daemon mode) — queue-execute latency × concurrent-agent activity = drift between agent intent and actual commit. Snapshot-at-emit pattern is the substrate's MVCC for typed commit primitives."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**savepoint-cli must capture the diff snapshot at the moment of emit, not defer to the worker's re-derivation at execute time.** Operator-stated 2026-05-26 during the UXW gate landing: *"savepoint cli might need to grab a diff exactly at that moment we emit... to get context of what you have worked on so that it can know what to commit when its queue is up."*

## The drift window

The savepoint pipeline has three latency phases:

1. Agent emits `CommitRequestModel` via `savepoint-cli emit` (T1)
2. savepointd queues the intent (T2, ~T1+ms)
3. digikoma-savepoint processes the queue + derives a commit from the *current* working tree (T3)

In **v0.1 (synchronous one-shot)**: T1 → T3 is milliseconds; drift window is negligible.

In **v0.2+ (daemon mode)** (planned): T1 → T3 can be seconds-to-minutes while the queue holds other intents. During that window:

- Other agents commit (changing what `since-last-commit` resolves to)
- Other agents edit overlapping files (changing the bytes the agent thought they were committing)
- The current chat-session's *intent* (T1) and the actual *working tree state* (T3) drift apart silently

Re-deriving at T3 is **architecturally dishonest** — the commit no longer matches the agent's intent.

## The fix: snapshot-at-emit-time

`savepoint-cli emit` captures the diff bytes at T1 and embeds them in the CommitRequestModel. The worker at T3 uses the snapshot as source-of-truth, not the current working tree.

Schema addition (proposed shape):

```swift
// commit-request-schemas
public struct CommitDiffSnapshot: Codable, Sendable, Equatable {
  public let snapshotTaken: Date
  public let workingTreeHEAD: String      // git rev-parse HEAD at emit time
  public let stagedDiff: String?          // git diff --cached output, scoped to requested files
  public let unstagedDiff: String?        // git diff output, scoped to requested files
  public let untrackedFiles: [UntrackedFileSnapshot]  // name + blob content for ?? files in scope
  public let scopedFileBlobs: [FileBlob]  // per-file blob SHA at snapshot time (for drift detection)
}

public struct CommitRequestModel {
  // ... existing fields ...
  public let scope: CommitScope
  public let snapshot: CommitDiffSnapshot?  // NEW: source-of-truth bytes at emit time
}
```

Capture-side (`savepoint-cli emit`): before writing the intent JSON, shell out to:

- `git rev-parse HEAD` (capture HEAD SHA)
- `git diff --cached -- <scoped files>` (capture staged diff)
- `git diff -- <scoped files>` (capture unstaged diff)
- For untracked files in scope: read bytes + compute blob SHA

Use `CommonProcess` ([[feedback_common-process-banned-foundation-process]]), not `Foundation.Process`.

Apply-side (`digikoma-savepoint`): when snapshot present, prefer one of:

| Policy | Behavior | When to default |
|---|---|---|
| **(1) apply-the-snapshot** | Replay captured patch onto current HEAD; if conflicts, fail | Agent's intent IS the bytes — drift means override |
| **(2) verify-and-derive** | Compare current working-tree state to snapshot; if drift detected, emit typed `DriftDetected` event and fail; if no drift, derive normally | Agent's intent is the *bytes-with-acknowledgment-that-they-match-current-state* — drift means human attention |
| **(3) snapshot-as-evidence-only** | Always derive from current working tree; include snapshot in artifact for audit/replay | Snapshot is provenance, not source-of-truth |

**Substrate default: policy (2) verify-and-derive.** Agents emit intent + evidence; the worker confirms reality matches evidence; failures emit typed `DriftDetected` events the agent (or operator) can inspect. Composes with the [[substrate-cost-circle]] ledger — `DriftDetected` is a `−stamina` charge (agent emitted intent that didn't land cleanly), and gives the operator a typed surface to inspect what drifted instead of a silent wrong commit.

## Why this is the substrate-honest pattern

The substrate consistently prefers **typed records carry the bytes** over **typed records reference derivable state**:

- `LaunchGateCheck` carries actual status + notes (not a pointer to "check the dashboard")
- `ToolInvocationReceipt` carries actual stdout/stderr (not a pointer to a log file that might rotate)
- `PrivacyDisclosureReviewReceipt` carries the actual sign-off + reviewer identity (not a pointer to a hand-shaken understanding)
- `EngineeringReviewReceipt` carries the actual review verdict + change-set hash
- ...

`CommitRequestModel` carrying `CommitDiffSnapshot` is the same pattern applied to commit-time: the record carries the evidence at the moment of declaration, not a description of where evidence can be re-derived.

This is the substrate's **MVCC pattern** — same architectural insight as database snapshot-isolation: a transaction sees the world as it was at start, not as it is at commit. savepoint becoming an async daemon makes this insight load-bearing.

## How to apply (when implementing)

1. Bump `commit-request-schemas` to add `CommitDiffSnapshot` + `snapshot: CommitDiffSnapshot?` on `CommitRequestModel`
2. Update `savepoint-cli emit` to capture diff/HEAD/blobs at emit time, embed in intent
3. Update `digikoma-savepoint` worker to consult snapshot at execute time (default policy: verify-and-derive)
4. Add typed `DriftDetected` event surface so failed-due-to-drift commits become inspectable
5. Update [[feedback_substrate-cost-circle]] to record drift-charge ledger entries
6. Update savepoint skill instructions to mention the new behavior

## Pitfalls

- **Skipping the snapshot in v0.1 thinking "it doesn't matter yet."** The schema slot should land NOW even if v0.1 leaves the field nil — wire-format additions are cheaper than wire-format breaks. Snapshot becomes mandatory at v0.2 daemon mode.
- **Picking policy (1) by default.** Apply-the-snapshot silently overrides operator/other-agent edits that landed in the drift window. Policy (2) fails loudly instead. Loud failures > silent wrong commits.
- **Capturing the full diff regardless of scope.** Snapshot should be SCOPED to the agent's declared files (`scope.files` or what `since-last-commit` resolved to at T1). Don't capture other concurrent changes the agent never intended.
- **Treating untracked files as "not in scope."** Untracked files are precisely the case where the worker can't re-derive — must capture bytes at emit time.

## History

Operator-stated 2026-05-26 right after two savepoint commits landed cleanly in synchronous v0.1 mode. The observation is forward-looking: v0.1's negligible drift window masks a design refinement that becomes load-bearing for v0.2 daemon mode. Saving the doctrine now so the v0.2 design isn't blocked on rediscovering it.

## New home + naming (operator-directed 2026-05-26)

**savepoint moves to kura-org and adopts the `<slug>@<org>.cli` naming convention** ([[feedback_executable-naming-slug-at-org-dot-form]] + [[feedback_substrate-dotted-form-factor-vocabulary]] + [[feedback_harness-canonical-home-clia-org]] as the precedent case). Operator-stated 2026-05-26: *"this cli will be part of the kura-org now and it will use the new cli naming conventions."*

Why kura-org: commits ARE kura-storage operations (typed records of what changed, when, by whom, with what intent + evidence). kura-org is the substrate's cross-actor neutral storehouse — every actor uses savepoint, so it belongs in the shared-primitives home, not in clia-org (which is cluster-specific). Same logic as why `command-line-adventures` lives in kura-org rather than any single actor's home.

Target paths (canonical as of 2026-05-26 migration commits):

| Component | Old path | New path |
|---|---|---|
| Agent-side emitter CLI | `clia-org/private/universal/domain/tooling/spm/savepoint-emit/` | `kura-org/private/universal/tools/savepoint.cli/` |
| Sleeping daemon | `clia-org/private/universal/domain/tooling/spm/savepointd/` | `kura-org/private/universal/tools/savepoint.sd/` |
| Commit-request schema | `schema-universal/.../schema-families/commit-request-schemas/` | unchanged (stays in schema-universal) |
| Digikoma worker | `digikoma-org/private/universal/domain/core/digikoma-savepoint/` | unchanged (stays in digikoma-org; only agent-side CLI + daemon moved) |

Note: kura-org's tooling layout is `private/universal/tools/<name>/`, NOT `private/universal/domain/tooling/spm/<name>/` (clia-org's layout). Each owner home picks its own internal tools convention. Same package gets a shorter relative-path dependency chain in kura-org (5 ups vs 7 ups) because of the shallower depth.

Both savepoint packages share the slug `savepoint`; the form-factor (`.cli` vs `.sd`) disambiguates. **No `d` suffix on the slug** — the `.sd` form-factor already carries the sleeping-daemon semantic per [[feedback_sd-sleeping-daemon-form-factor]] (operator-corrected 2026-05-26: "savepoint should be moved too... savepoint.sd"). The Unix-convention `<slug>d` binary name (`savepointd` executable target) can still ship inside the package for downstream-script familiarity, but the PACKAGE name is just `savepoint.sd`.

The `<slug>@<org>.<form-factor>` naming makes ownership + shape legible at glance (no need to follow imports): `savepoint.cli` reads as "savepoint, owned by kura-org, in CLI shape" and `savepoint.sd` as "savepoint, owned by kura-org, in sleeping-daemon shape." Same discipline as [[feedback_org-prefix-on-module-names]].

The OLD `clia-org/.../savepoint-cli/` + `clia-org/.../savepointd/` are RETIRED — edits there will get silently wiped by background substrate-restructure passes (same hazard as the `harness@clia-org.cli` migration). Author new code only at the kura-org paths.

The savepoint skill (`~/.claude/skills/savepoint/SKILL.md`) needs updates for: rebuild commands, install paths, source paths. Currently points at clia-org — must migrate.

## Related

- [[insights/substrate-is-digikoma-factory-2026-05-23]] — savepoint is the canonical proof-case of the digikoma factory; design refinements here ratify the pattern broadly
- [[feedback_substrate-cost-circle]] — drift detection emits typed stamina/time-loss events into the cost ledger
- [[feedback_common-process-banned-foundation-process]] — capture-side subprocess invocations use `CommonProcess`, not `Foundation.Process`
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — savepoint is a turn-end digikoma; snapshot-at-emit-time is the discipline that lets turn-end work survive queue latency
- [[feedback_harness-canonical-home-clia-org]] — precedent case for canonical-home-changed + old-path-gets-silently-wiped hazard
- [[feedback_executable-naming-slug-at-org-dot-form]] — `<slug>@<org>.cli` naming discipline
- [[feedback_substrate-dotted-form-factor-vocabulary]] — `.cli` / `.lib` / `.daemon` form-factor suffixes
- [[feedback_org-prefix-on-module-names]] — Swift module-name discipline that pairs with executable naming
