---
name: grep-common-star-before-adding-primitives
description: "Before adding ANY primitive to common-service (or any common-* package), grep all wrkstrm-core/private/cross/spm/common-* for the concept — substrate often already owns it in a sibling package"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

**The substrate's primitive layer is the `common-*` family** under `wrkstrm-core/private/cross/spm/`: common-service, common-imprint, common-process, common-shell, common-log, common-secrets, etc. Each package owns one axis of primitive infrastructure.

**Before adding any new primitive to common-service (or proposing one), grep ALL common-\* packages for the concept first.** The substrate has accumulated enough primitives that the concept you think is missing is often already shipped in a sibling.

**Why:** caught this failure mode twice in one hour on 2026-05-23:
- Authored `SubprocessSpawner` in common-service — `CommonProcess.CommandSpec` already owns subprocess spawning with timeouts, sandbox, instrumentation, runner selection.
- Authored `ServiceLedger<Imprint>` in common-service — `CommonImprint.SubstrateLedgerWriter<Entry: SubstrateLedgerEntry>` already owns append-JSONL ledgers with typed contract, fsync, canonical path resolution via `SubstrateLedgerStorage.ledgerURL(consumerSlug:ledgerName:)`.

Both wrappers were dead before they shipped. The operator caught both with a single question each ("we should be using common-process right?" / "common-imprint already has this").

**How to apply, in order:**
1. Run: `ls private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/` to enumerate the current primitive packages.
2. For each `common-*` package potentially relevant to the concept: `find <pkg>/sources -name '*.swift'` and skim type names.
3. Grep across all of them for keywords matching the proposed primitive (`grep -rE "public struct|public protocol" common-*/sources/`).
4. Only after confirming nothing matches, propose the new primitive.

**Pattern when adding to common-service is genuinely correct**: the primitive must (a) not exist in any other common-* package, (b) be reusable across many services, (c) have no reasonable home in a more-specific package. ResourceQueue<Intent> passed all three on 2026-05-23; SubprocessSpawner and ServiceLedger failed (a).

**Cross-reference to architectural memory:** [[feedback_same-shape-same-model]] (don't duplicate models with identical shape). The common-* failure mode is the package-level version of the type-level duplication anti-pattern.

**Concrete substrate primitives observed as of 2026-05-23:**
- `common-service` — SubstrateEvent, TriggerImprint, SchedulingPolicy, SubstrateCondition, @SubstrateService macro, ResourceQueue<Intent>
- `common-imprint` — SubstrateLedgerWriter<Entry>, SubstrateLedgerEntry, SubstrateLedgerStorage, SubstrateLedgerReader, SubstrateImprintWriter/Reader/Manifest/Storage, BundleArtifact
- `common-process` — CommandSpec, ProcessOutput, ProcessRunnerKind, multiple Runner backends (TSCBasic, Foundation, Subprocess), MetricsInstrumentation, SeatbeltProfileBuilder
- (others to enumerate next time the question arises)
