---
name: digikoma-build-clean-exists
description: "Before running raw FS ops to clean `.build/` directories, reach for `digikoma-build-clean` — substrate's typed, recoverable, dry-run-able cleanup tool. The substrate also has 20+ other digikomas under `domain/build/` that cover most build-operations tasks."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 80d30d4d-f88b-458d-977f-2015247c8a52
---

**`digikoma-build-clean` exists** at:

`private/universal/substrate/collectives/digikoma-org/private/universal/domain/build/digikoma-build-clean/`

It does exactly what `find -name .build -prune -exec rm -rf {} +` does, but **better**: it moves matched dirs to `~/.Trash/digikoma-build-clean-<ISO-date>/` (recoverable!) and supports dry-run preview. Its identity file warns: *"the substrate fills 250+ GB of `.build/` quietly across hundreds of packages. Run periodically."*

**Why:** Operator-pointed-out 2026-05-26 after I bulk-purged 272 `.build/` dirs via raw `find -rm -rf`. The framing was "we can make this a digikoma right?" — not as a build-it request, but as a nudge to discover the typed primitive that already exists. My destructive `rm -rf` was non-recoverable; `digikoma-build-clean` would have moved the same content to Trash with full hierarchy preservation, recoverable for ~30 days.

## Canonical invocation

JSON in, structured result out:

```bash
echo '{"rootPath":"/Users/sonoma/mono","dryRun":true}' | digikoma-build-clean
echo '{"rootPath":"/Users/sonoma/mono","dryRun":false}' | digikoma-build-clean
```

Or with explicit files:

```bash
digikoma-build-clean --input args.json --output result.json
```

**`DigikomaBuildCleanArguments` fields:** `rootPath` (required), `dirName` (default `.build`), `maxDepth` (default 12), `dryRun` (default false), `trashRoot` (default `~/.Trash`), `subdirPrefix` (default `digikoma-build-clean`), `computeSizes` (default true).

**`DigikomaBuildCleanResult`** carries the resolved rootPath, matched paths, sizes, action taken, per-path failures (non-fatal), Trash subdir destination, etc.

## How to apply

- **Before reaching for `find ... -delete`, `rm -rf`, or any raw FS op on substrate paths**: check `digikoma-org/private/universal/domain/<area>/` for an existing digikoma. The substrate has them organized by domain (`build`, `core`, `runtime`, `intelligence`, `meta`, `turn`, `directory`, `protocols`, `gaming`, `context`, `archive`, `fleet`).
- **For build operations specifically**: 20+ digikomas live under `domain/build/`: `digikoma-build-clean`, `digikoma-swift-build`, `digikoma-swift-format`, `digikoma-swift-lint`, `digikoma-swift-test`, `digikoma-swift-package-dump`, `digikoma-xcode-build`, `digikoma-xcode-run`, `digikoma-attest-surface`, `digikoma-audit-leak-surface`, `digikoma-audit-xcstrings-coverage`, `digikoma-file-gate`, `digikoma-package-scan`, `digikoma-release-features`, `digikoma-ship-apple-app`, `digikoma-symbolgraph-extract`, `digikoma-xcodegen-fleet`, `digikoma-launch-status`, `digikoma-capture-app-store-screenshots`, `digikoma-generate-app-store-metadata`. Run `ls` on that dir before inventing.
- **Default to `dryRun: true` first** on any non-trivial scope — even a typed digikoma is destructive in live mode.
- **The pattern**: `echo '<JSON args>' | <digikoma-name>` — JSON in via stdin, structured result out via stdout. Composes with the substrate cost-circle ledger ([[feedback_substrate-cost-circle]]).
- **Naming**: digikoma binaries are `digikoma-<task-name>`, products `digikoma-<task-name>`, libraries `Digikoma<TaskName>Tool`, depend on `DigikomaCore` from `digikoma-core` package.
- **Composes with [[feedback_substrate-cost-circle]]** (digikoma-first default disposition): the digikoma was already built — every time I reach for raw FS ops instead, I'm bypassing typed receipts, losing the recoverable-trash safety, and skipping the substrate-cost-circle ledger entries that retrospect tools would aggregate. Routing to the existing digikoma is the right move both ergonomically and doctrinally.
- **Composes with [[feedback_use-common-process-not-foundation]]**: same pattern — substrate has a typed primitive; reach for it instead of raw stdlib alternatives.
