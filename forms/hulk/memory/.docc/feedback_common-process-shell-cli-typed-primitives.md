---
name: common-process-shell-cli-typed-primitives
description: "Substrate's typed Foundation-replacement family lives at `swift-universal/.../domain/build/spm/{common-process,common-shell}` — use over raw Process/FileHandle/print where appropriate"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31: "use common-process, common-shell and common-cli where appropriate too"

**Rule**: Substrate's typed Foundation-replacement family — use the TYPED primitives instead of raw Foundation `Process` / `Pipe` / `FileHandle` / `readLine()` / `print()` / `FileManager` where the typed surface fits.

**Canonical homes** (verified from CadenceAgentCLI Package.swift + swift-universal git ls-files):

- **`common-process`** Package — `swift-universal/private/universal/domain/build/spm/common-process/`
  - Products: `CommonProcess` (typed Process replacement) + `CommonProcessExecutionKit` (execution scaffolding)
  - Use when: spawning external processes, piping I/O, time-bounded execution
  - Already consumed by: `digikoma-common-process`, `CommonShell` (transitively), digikoma tools

- **`common-shell`** Package — `swift-universal/private/universal/domain/build/spm/common-shell/`
  - swift-tools-version: 6.2; platforms: macOS 13+, iOS 17+, macCatalyst 17+
  - Products:
    - `CommonShell` — typed shell I/O library (depends on CommonProcess + CommonProcessExecutionKit + CommonLog)
    - `CommonShellArguments` — typed ArgumentParser scaffolding (CommonShell + ArgumentParser + SwiftUniversalFoundation) — the "common-cli" equivalent product
    - `CommonShellBenchSupport`, `CommonShellPerf` — performance/benchmarking
    - `common-shell-cli@swift-universal.cli` — executable (typed CLI per substrate form-factor convention)
  - Use when: typed CLI scaffolding, typed shell I/O, typed argument-parsing helpers beyond bare ArgumentParser

- **"common-cli"** as the operator named it = NOT a standalone Package; substrate convention is `CommonShellArguments` (product of `common-shell`). Stale references to `swift-common-cli` exist in some Package.swift files (e.g., CadenceAgentCLI) but no `swift-common-cli` Package exists at the referenced paths. Treat `CommonShellArguments` as canonical "common-cli."

**Reference Package.swift consumer pattern** (from `agents/cadence/.../launchpad/agent-cli/Package.swift`):
```swift
dependencies: [
  .package(name: "common-shell", path: "<...>/swift-universal/private/universal/spm/domain/system/common-shell"),  // NOTE: this path is STALE; canonical is /domain/build/spm/common-shell
  .package(name: "common-process", path: "<...>/swift-universal/private/universal/domain/build/spm/common-process"),
  ...
],
targets: [
  .executableTarget(
    name: "...",
    dependencies: [
      .product(name: "CommonCLI", package: "swift-common-cli"),     // ← stale; substitute CommonShellArguments
      .product(name: "CommonShell", package: "common-shell"),
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
    ]
  )
]
```

**Sophisticated dep injection** — `common-shell`'s Package.swift uses `Package.Inject.shared` to swap LOCAL paths vs REMOTE git URLs based on `SPM_USE_LOCAL_DEPS` env var:
```swift
static var local: Inject = .init(dependencies: [.package(path: "../common-process"), ...])
static var remote: Inject = .init(dependencies: [.package(url: "https://github.com/swift-universal/common-process.git", from: "0.3.6"), ...])
```
Future workstream Packages depending on common-* should adopt this Inject pattern for parity with substrate-doctrine.

**How to apply**:
- When a new `.cli` or `.clia` needs argument parsing beyond bare ArgumentParser → import `CommonShellArguments`
- When a CLI needs typed stdio (instead of raw `print()` / `FileHandle.standardOutput.write()` / `readLine()`) → import `CommonShell` (look at its surfaces; typed stdio + signal handling + ANSI etc.)
- When a workstream ghost needs to spawn the desktop-studio.mac.prototype.app or any external binary → use `CommonProcess` / `CommonProcessExecutionKit` instead of raw `Process()` + `Pipe()` + `DispatchSemaphore`
- When migrating existing code (creative-selection .cli / .clia, the 5 workstream Packages, md@swift-universal.cli, etc.) → bead-track + retrofit in focused turn; don't bypass next-time

**Search→compose→confirm→author discipline reminder**: per [[feedback_typed-primitive-bypass-3x-rule-confirmed]] — before authoring any CLI/shell/process-handling Swift code, FIRST check this memory + search for `CommonProcess` / `CommonShell` / `CommonShellArguments` in substrate Package.swift files for typed precedent. The substrate's investment compounds when each new authoring composes typed primitives instead of duplicating Foundation usage.

**Composes with**: [[feedback_clia-is-cli-assistant-form-factor]] (.clia executables benefit from CommonShellArguments) + [[feedback_workstream-package-ships-library-cli-and-clia]] (both .cli and .clia products should compose CommonShell where appropriate) + [[feedback_typed-primitive-bypass-3x-rule-confirmed]] (search-before-author discipline) + [[feedback_async-parsable-command-is-axiom]] (CommonShellArguments + AsyncParsableCommand stack together).
