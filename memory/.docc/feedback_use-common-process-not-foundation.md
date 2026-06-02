---
name: use-common-process-not-foundation
description: "Substrate Swift code should use `common-process` (the substrate's typed Process wrapper) instead of raw `Foundation.Process`. Foundation Process leaks pipe FDs and exhausts limits on long sweeps."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

When spawning subprocesses from Swift in the substrate, use **`common-process`** (the substrate's canonical Process wrapper) — NOT raw `Foundation.Process`.

## Why

Raw `Foundation.Process` has two pain points the substrate's wrapper addresses:

1. **FD leaks.** Foundation Process doesn't reliably close pipe file descriptors when the Process deinits. On long sweeps (~2000+ subprocess invocations), this exhausts the per-process FD limit and produces "Bad file descriptor" errors on subsequent spawns. Surfaced 2026-05-26 during the digikoma sidecar rename sweep — after 2537 successful git-mv invocations, the next 67 failed with `NSPOSIXErrorDomain Code=9 "Bad file descriptor"`.
2. **Untyped API surface.** Raw Process requires manual pipe wiring, manual stdout/stderr decoding, manual exit-status checking. The substrate's wrapper provides a typed input → typed output contract.

The substrate's `common-process` exists for exactly these reasons. Use it.

## Where to find it

`collectives/wrkstrm-core/private/cross/spm/common-process/` — substrate-canonical home. Many substrate tools depend on it already (swift-harness-cli, the broader common-* primitives layer).

## When the FD-leak workaround is acceptable

If a scratchpad or one-shot tool genuinely can't depend on common-process (e.g., it lives somewhere that can't reach the path-dep), the FD-leak workaround is:

```swift
let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
process.waitUntilExit()
try? stdoutPipe.fileHandleForReading.close()
try? stderrPipe.fileHandleForReading.close()
try? stdoutPipe.fileHandleForWriting.close()
try? stderrPipe.fileHandleForWriting.close()
```

But this is a workaround. The substrate-correct answer is depending on `common-process`.

## How to apply

When writing new Swift code that spawns subprocesses:

1. Check if you can add `common-process` as a path-dep
2. If yes — use it
3. If no — apply the explicit-pipe-close workaround and add a comment explaining why common-process wasn't reachable

When refactoring existing Swift code that uses raw `Foundation.Process`:

- If it's a long-running sweep or high-frequency invoker → refactor to common-process (FD leaks will eventually bite)
- If it's a low-frequency invoker (single shot, occasional) → workaround is fine; refactor opportunistically

## History

Operator-reminded 2026-05-26 during the digikoma sidecar rename sweep, after I hit FD exhaustion using raw Foundation.Process for 2604 git mv invocations: "remember you can use common-process here." The substrate had a typed Process wrapper I should have reached for from the start.

## Related

- [[feedback_substrate-toolmaking-checklist]] — toolmaking discipline; this is a sub-discipline about which primitives to compose with
- [[feedback_grep-common-star-before-adding-primitives]] — grep all `common-*` sources first; this exact rule would have caught my raw-Process mistake
- [[feedback_agent-scratchpad-pattern-repl-proofs]] — scratchpads should still use substrate primitives; the scratchpad path doesn't exempt you from common-* discipline
