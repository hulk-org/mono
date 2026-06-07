---
name: common-cli-and-common-shell-both-exist
description: "Substrate has BOTH a standalone `common-cli` package (submodule at swift-universal/.../domain/build/spm/common-cli) AND a `common-shell` package as siblings — their CLI-arg territory overlaps in a fuzzy way the operator considers a past design mistake. Don't claim 'no standalone common-cli' from prior memory — verify via .gitmodules."
metadata:
  node_type: memory
  type: reference
  originSessionId: 2f6e8d5d-6c57-48a2-9fee-ab4870aa2a2f
---

**There is a standalone `common-cli` package — submodule, sibling to `common-shell`.** Earlier feedback memory [[common-process-shell-cli-typed-primitives]] (2026-05-31) claimed "NO standalone swift-common-cli Package exists — substitute CommonShellArguments." That claim was wrong by 2026-06-04; possibly the package was added after the memory was written, or possibly the memory was wrong from the start. Either way: **verify, don't recite.**

## Where they live

- `common-cli` at `private/universal/substrate/collectives/swift-universal/private/universal/domain/build/spm/common-cli/` — git submodule from `https://github.com/swift-universal/swift-common-cli.git` (`.gitmodules` entry confirmed). Ships:
  - `CommonCLI` library (depends on CommonShell + CommonProcess)
  - `TinyArgv` library (substrate's own arg parser, sibling to swift-argument-parser)
  - `CommonCLIFoundationModelsTool` library (FoundationModels tool integration)
  - `common-cli@swift-universal.cli` executable (target `CommonCLIPerf`)
  - Test targets: `CommonCLIMacOSTests`, `TinyArgvTests`, `CommonCLIPerfExecutableTests`
- `common-shell` at the sibling path. Ships:
  - `CommonShell`, `CommonShellArguments`, `CommonShellBenchSupport`, `CommonShellPerf` libraries
  - `common-shell-bench@swift-universal.cli`, `common-shell-cli@swift-universal.cli` executables

## The territory overlap the operator considers a design mistake

Operator 2026-06-04: *"there is a common-shell and a common-cli package... maybe it was made to be random? that was such a bad idea."*

Both packages occupy adjacent territory:

- `CommonShell` (in common-shell) vs `CommonCLI` (in common-cli) — both wrap subprocess execution patterns; `CommonCLI` depends on `CommonShell` so it's meant as the higher composition, but the names don't make that legible.
- `CommonShellArguments` (in common-shell) — substrate's `ParsableArguments` struct with `workingDirectory`, `outputs`, `verbose`.
- `CommonCLI` + `TinyArgv` (in common-cli) — alternative CLI arg parsing surfaces. `TinyArgv` is the substrate-owned lightweight parser sibling to swift-argument-parser.
- Both ship a `*@swift-universal.cli` perf executable.
- A consumer writing a new substrate `.cli` has to grep both packages to decide which primitive to use; the names alone don't disambiguate.

## How to apply

- Before claiming "substrate has/doesn't have X package," verify via the `.gitmodules` file in the collective. Memory entries about package existence are decay-prone.
- When recommending a substrate-canonical CLI primitive for a new tool, surface the overlap explicitly so the operator can decide. Don't silently pick one over the other.
- If asked to compose new CLI surfaces, default to investigating both `CommonCLI` and `CommonShellArguments` before picking — the directional dep (CommonCLI → CommonShell) suggests CommonCLI is the higher-layer composition, but this is fuzzy.
- This memory composes with [[common-process-banned-foundation-process]] + [[async-parsable-command-is-axiom]] — substrate CLIs should use substrate-owned arg parsers (TinyArgv or CommonShellArguments) AND AsyncParsableCommand, NEVER bare Foundation.Process or sync ParsableCommand.
