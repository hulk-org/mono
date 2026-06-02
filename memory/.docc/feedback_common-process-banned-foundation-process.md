---
name: common-process-banned-foundation-process
description: "Substrate Swift code uses `CommonProcess` (from swift-universal/.../common-process) for subprocess invocation, never `Foundation.Process`. The substrate's typed Command/CommandSpec/RunnerControllerFactory primitives provide consistent instrumentation, error handling, and async semantics; Foundation.Process is banned outright. Operator-stated 2026-05-26."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

When substrate Swift code needs to invoke a subprocess (shell out to `git`, `pkl`, `xcodebuild`, any external CLI), it uses the substrate's `CommonProcess` primitive from:

`collectives/swift-universal/private/universal/spm/domain/system/common-process`

Foundation's `Process` is **banned outright** for substrate code.

**Why:** `CommonProcess` provides:
- Typed `CommandSpec` (executable + args + env + working dir, all Codable + Sendable)
- Async `RunnerControllerFactory.run(command:) async throws -> ProcessOutput` API
- Buffered `ProcessOutput` with `stdoutText`, `stderrText`, `isSuccess` accessors
- Consistent instrumentation hooks via `ProcessInstrumentation` protocol
- Multiple runner backends (TSCBasic, Subprocess, Seatbelt, Foundation) selectable per call
- Composable with cost/inference accounting per [[insights/substrate-sync-cost-pattern-2026-05-26]]

Hand-rolling `Foundation.Process` skips ALL of these — every subsequent improvement to the substrate's process layer (sandboxing, metrics, schema-typed invoices) bypasses ad-hoc code.

**How to apply:**
- Any Swift file in a substrate package that needs to invoke an external CLI: `import CommonProcess` (+ `import CommonProcessExecutionKit` if you need the execution kit).
- Add `.product(name: "CommonProcess", package: "CommonProcess")` to the SPM target's deps.
- Build a `CommandSpec(executable:, args:, env:, workingDirectory:)` and run via `RunnerControllerFactory.run(command:)`. Result is a `ProcessOutput`.

**Canonical example (from HarnessStartupRunner in CLIAOrgHarnessCore):**
```swift
import CommonProcess
import CommonProcessExecutionKit

let command = CommandSpec(
  executable: .name("pkl"),
  args: ["eval", "--format", "json", recordPath],
  env: .inherit(updating: nil),
  workingDirectory: nil
)
let output = try await RunnerControllerFactory.run(command: command)
guard output.isSuccess else {
  throw OrgPrefixLoaderError.pklEvalFailed(
    slug: slug, exitCode: output.exitStatus.code, stderr: output.stderrText)
}
let prefix = try JSONDecoder().decode(OrgPrefix.self, from: output.stdout)
```

**Boundary:**
- The ban applies to substrate Swift code. Third-party code or vendored deps may still use Process internally — we don't fork them.
- `CommonProcess` itself is allowed to use `Foundation.Process` under the hood (it's THE substrate's primitive over Foundation).
- When writing a quick test fixture or debug script that LIVES in `.build` or scratch dirs, Process is acceptable. Banned only in committed substrate Swift code.

**Companion entries:** [[feedback_async-parsable-command-only]] (CommandSpec.run is async; AsyncParsableCommand is the natural caller) · [[feedback_grep-common-star-before-adding-primitives]] (common-process is THE process primitive — don't roll your own).
