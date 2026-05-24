---
name: Common-service substrate stack — first three-transport citizen + watcher kernel + common-imprint
description: Five-layer common-* stack landed; common-imprint added as substrate-canonical evidence-bundle contract; digikoma-hello-world ships CLI+Service+Tool transports + .imprint session bundles; watcher kernel routes fsevents to registered services; service-universal + macro deferred
type: project
originSessionId: 73646ca8-23c0-4889-afa0-407568d477f4
---
On 2026-05-22 the substrate landed its behavioral-citizenship stack with three new SPM packages:

- `private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/wrkstrm-notification/` — `WrkstrmNotificationCenter` actor wrapping `NSUserNotification` (deprecated; the deprecation diagnostic itself is the graduation marker: `graduate to directory-control bundle dispatch`).
- `private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/common-service/` — `CommonService` primitives: `SubstrateEvent`, `SubstrateService` + `SubstrateServiceContract`, `SubstrateCondition<E>` AST, `SchedulingPolicy`, `TriggerRecord`/`TriggerOutcome`/`SuppressionReason`, `ServiceID`/`ServiceDescription`/`SubstrateContractVersion`.
- `private/universal/substrate/collectives/digikoma-org/private/universal/domain/core/digikoma-hello-world/` — first conformer with five targets (DigikomaHelloWorldTool library + digikoma-hello-world-cli executable + DigikomaHelloWorldService + DigikomaHelloWorldFoundationModelsTool + digikoma-hello-world-demo executable) + the digikoma katakana docs (スペック.json, アイディ.md, インスト.md, レイ.md, lineage.json).

13 tests passing. State at `~/.local/share/digikoma/hello-world/state.json`; receipts at `receipts.jsonl` (compact JSONL, transport-tagged, jq-queryable). Three transports verified live (CLI customer #1–3, Service via demo customer #3, live NSUserNotification banner customer #4 with `notification: {"posted": {}}` receipt); FoundationModels Tool compiles under `@available(macOS 26)` — not yet invoked through an actual agent.

**Why:** Long architectural conversation established that substrate needs a typed event-bus + scheduler-policy + condition-AST + trigger-record vocabulary parallel to its existing data-schemas discipline. The five-layer common-* process stack — common-process → common-shell → swift-common-cli → common-service, with WrkstrmFSEvent below — is the substrate's process-stack naming convergence. Hello-world greeter proves the on-ramp works so every future digikoma can put on the same vest (typed conformance = visible-from-outside citizenship signal).

**How to apply:** When adding a new substrate citizen, copy `digikoma-hello-world`'s layout. Library target directories are PascalCase matching the Swift module name (`DigikomaXService/`); executable target directories and target names are kebab-case (`digikoma-x-cli/`); executable PRODUCT names use random 8-hex-char `-cli` suffix (e.g. `7f3a8c91-cli`). Dependency relative paths from `digikoma-org/private/universal/domain/<area>/<x>/` to `wrkstrm-core/private/cross/spm/<y>/` need **6 `../` segments**. Every digikoma includes the katakana docs. State files live at `~/.local/share/digikoma/<slug>/` (XDG-shaped, file-based, single-consumer); receipts JSONL uses a compact encoder (one JSON value per line) while state.json uses a pretty encoder.

Three-transport symmetry that every digikoma now inherits: same Tool library called by CLI executable (one-shot), Service library (event bus, watcher-dispatched), and FoundationModels Tool library (LLM-callable). All three write to the same state file and receipt log; each receipt carries `transport: "cli" | "service" | "tool"`.

Deferred (named, not yet built):
- `service-universal/` collective with versioned contract packages (e.g. `cli-rebuild-service-contracts-v000-001-000`), parallel to `schema-universal/`.
- `@SubstrateService` macro target — substrate's first behavioral macro, alongside Apple's `@Generable` on the data side.
- `CLIFanout<ID>` actor + `digikoma-watcher-kernel` — the watcher that statically links service-extensions and dispatches them with policy-aware scheduling. Watcher's binary symbol table becomes the substrate's wiring diagram.
- `ProcessResourceSampler` in a new optional sibling target of common-process (depends on `libproc` for `proc_pid_rusage`).
- `WrkstrmNotificationCenter` graduation: swap backend to dispatch through `wrkstrm-app/private/apple/apps/directory-control/` for proper bundle identity. Public API stays unchanged; consumers don't change. Pattern: one substrate-blessed host app carries the bundle identity for the whole substrate's UX surface; bundle-less consumers dispatch through it.
- Live FoundationModels Tool invocation through an agent (the substrate's `INTELLIGENCE` smoke test).

Submodule state when this landed: both `wrkstrm-core` and `digikoma-org` working trees have uncommitted new files; nothing yet committed in either submodule.

---

## Update 2026-05-22 (later same session): watcher kernel + common-imprint landed

Two more architectural pieces shipped after the initial commit above:

### Watcher kernel

`private/universal/substrate/collectives/digikoma-org/private/universal/domain/runtime/digikoma-watcher-kernel/` — new "runtime" area under digikoma-org for long-running substrate runtimes. Components:

- `WatcherKernel` actor — generic service registry + dispatch + bounded ring buffer of TriggerImprints
- `CLIRebuildService` — service-extension that fans `.fsPathChanged` events to `swift run <swift-installer> 2758bb78-cli cli --force` (subprocess via Foundation.Process). Will eventually migrate to a dedicated `digikoma-cli-rebuild` package when a second consumer arrives.
- `digikoma-watcher-kernel-cli` executable — wires `WrkstrmFSEventWatcher` → kernel → registered services, accepts `--watch <path>` + `--rebuild-target <product>`

Event vocabulary added to common-service: `SubstrateEvent.fsPathChanged(roots:paths:)` + `SubstrateEventKind` enum + `SubstrateServiceContract.subscribedKinds: [SubstrateEventKind]`. The kernel filters dispatch by `subscribedKinds` so services only see events they declared interest in.

Live smoke verified: 3 fsevents → 3 `transport: "service"` greetings; full cli-rebuild flow needs the watcher to run longer than the rebuild subprocess (the smoke killed parent before rebuild finished). Subprocess-survival-on-watcher-shutdown is a real gap — fix with `setsid` detachment OR by waiting on in-flight builds before exit.

### Common-imprint (canonical evidence-bundle contract)

`private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/common-imprint/` — substrate-wide typed contract that any organism can use. Generalizes the prior-art `.imprint` directory bundle pattern from GhostImprint, ProofImprint, HarnessSessionImprint, DigikomaPlaygroundImprint.

Typed surface:
- `protocol SubstrateImprintManifest: Codable, Sendable` — every consumer provides its own typed Manifest type with `static var schemaVersion: String`, `var capturedAt: Date`, `var bundleArtifacts: [BundleArtifact]`
- `struct BundleArtifact: Codable` — role, title, fileName, byteCount, contentType
- `SubstrateImprintWriter<Manifest>` — creates the `.imprint` directory, writes typed artifacts (Data / Encodable / file-copy), emits `manifest.json` on `finalize()`
- `SubstrateImprintReader<Manifest>` — reads back the manifest + any artifact by role
- `SubstrateImprintStorage` — canonical path helper: `~/.local/share/<consumer-slug>/imprints/<schemaVersion>/<bundleName>.imprint/`

Hello-world adopted via `HelloWorldSessionManifest` + `DigikomaHelloWorldTool.finalizeSession()`. CLI flag: `--finalize-session`. Live verified: bundle directory contains `manifest.json` (typed manifest) + `state.json` (state snapshot) + `imprints.jsonl` (call-log tail), all reproducibly readable.

**Two granularities now coexist:**
- per-call append-only `imprints.jsonl` (lightweight, streaming) — the substrate's first per-call log slot
- per-session `.imprint` directory bundle (substrate-canonical, structured evidence) — via `common-imprint`

### Test state

21 tests passing across 5 packages: wrkstrm-notification (3), common-service (7), common-imprint (4), digikoma-hello-world (5), digikoma-watcher-kernel (2). All packages build clean.

### Vocabulary rename: receipt → imprint (within this stack)

- `TriggerRecord` → `TriggerImprint` (common-service) — the kernel's dispatch record
- `GreetingReceipt` → `GreetingImprint` (digikoma-hello-world) — per-call greeting record
- `receipts.jsonl` → `imprints.jsonl` (file name on disk)
- `NotificationReceipt` stays (it's literally a receipt FROM the OS notification subsystem, not the digikoma's own imprint)

### Migration follow-ups (next commits)

- `digikoma-cli-rebuild` extracted as its own package once a second consumer arrives
- Subprocess-survival fix in CLIRebuildService (`setsid` detachment OR await-in-flight on watcher shutdown)
- Watcher CLI structured logging (current `print` writes are block-buffered when stdout redirects)
- `digikoma-swift-installer`'s broken hardcoded `/Users/sonoma/.swiftpm/bin/swift-installer` path needs fixing OR retirement in favor of the substrate-native CLIRebuildService approach

---

## Update 2026-05-22 (third commit chunk): imprint consolidation under common-imprint

The plan `~/.claude/plans/breezy-conjuring-shell.md` consolidated the substrate's scattered imprint types under `common-imprint`'s canonical contract.

### `common-imprint` extended

- New optional field `linkRef: LinkRefModel?` on `BundleArtifact` for consumers that want a substrate-vault-shaped pointer alongside the file name. Default `nil` so existing callers don't change.
- New SPM dep: `link-ref-schemas-v000-002-000` from `schema-universal/` — widens common-imprint's transitive dep graph (every consumer of common-imprint now depends on schema-universal).
- 2 new tests: linkRef round-trip when present, omitted by default.

### Migrated to `SubstrateImprintManifest` conformance + `SubstrateImprintWriter` refactor

| Type | Submodule | Status |
|---|---|---|
| `HarnessSessionImprint` | clia-org/.../swift-harness-stage-world-cli | ✅ migrated; 16 existing tests pass; nested snapshot types gained `Sendable` conformance for the protocol requirement |
| `ProofImprint` | swift-universal/.../swift-proof-cli | ✅ migrated; added `bundleArtifacts: [BundleArtifact] = []` (additive), added `static let schemaVersion`, refactored `ProofRunner.writeImprint()` to use `SubstrateImprintWriter`; 4 existing tests pass (including 2 real proof-run tests) |

### Deferred to follow-up commits (xcodegen-based projects)

| Type | Submodule | Reason |
|---|---|---|
| `GhostImprint` | ghost-shell-org/shells/v000_000_000/macos/ghost-shell.mac | Xcode-built target; SPM deps are in `.xcodeproj/project.pbxproj` (XCLocalSwiftPackageReference), not in project.yml. Adding common-imprint requires editing pbxproj OR adding a `packages:` section to project.yml + regenerating xcodeproj with `xcodegen generate`. Higher-risk operation; needs its own commit. |
| `DigikomaPlaygroundImprint` | digikoma-org/private/apple/apps/digikoma-plant | Same — xcodegen-based mac app, not an SPM package |

### Test state across all 7 packages

```
common-imprint:                  6 tests passing
wrkstrm-notification:            3 tests passing
common-service:                  7 tests passing
digikoma-hello-world:            5 tests passing
digikoma-watcher-kernel:         2 tests passing
swift-harness-stage-world-cli:  16 tests passing (existing tests verified migration didn't break)
swift-proof-cli:                 4 tests passing (existing tests verified migration didn't break)
TOTAL: 43 tests passing across 7 packages
```

### Submodule scope this commit chunk

- `wrkstrm-core` — common-imprint extended (BundleArtifact + LinkRef dep)
- `clia-org` (NEW dirty) — swift-harness-stage-world-cli package + HarnessSessionImprint
- `swift-universal` (NEW dirty) — swift-proof-cli package + ProofImprint + ProofRunner

Total: 3 submodules edited in this round (5 cumulative if you count the prior two commits).

### Pattern crystallized

The two canonical types (`HarnessSessionImprint`, `ProofImprint`) now demonstrate the substrate-canonical migration recipe for evidence-bundle types:

1. `import CommonImprint`
2. Add `SubstrateImprintManifest` to the struct's conformance list
3. Remove the inline `BundleArtifact` nested struct (common-imprint provides one with identical field shape + optional `linkRef`)
4. Ensure `capturedAt: Date` is `var` (not `let`) so Sendable mutating doesn't bite
5. Add `Sendable` conformance to nested types if any are `Codable`-only
6. Refactor save() / writeImprint() to use `SubstrateImprintWriter<TheManifest>` (init with bundleURL + manifest, call `writeArtifact` per file, call `finalize`)
7. Verify existing tests still pass

Every future imprint consumer can copy this recipe. Future migration of ghost-shell.mac + digikoma-plant uses the same recipe once their xcodegen integration is sorted.
