---
name: xcodebuild test env-forwarding to iOS sim test runner — simctl launchctl is the only working mechanism
description: In Xcode 26, neither TEST_RUNNER_<KEY> nor SIMCTL_CHILD_<KEY> prefixes forward env vars from xcodebuild to the iOS sim test runner; only `simctl spawn <udid> launchctl setenv KEY VALUE` works
type: reference
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
When an orchestrator needs to deliver a value (locale, scene name, output
dir, etc.) from itself to a test runner running inside an iOS simulator,
**Apple's two documented env-forwarding mechanisms do NOT work in Xcode 26**:

1. **`TEST_RUNNER_<KEY>=<VALUE>` xcodebuild positional arg** — documented as
   forwarding `<KEY>=<VALUE>` to the test runner's process env after
   stripping the prefix. Empirically: test runner's
   `ProcessInfo.processInfo.environment["<KEY>"]` is empty.
2. **`SIMCTL_CHILD_<KEY>=<VALUE>` xcodebuild process env** — documented as
   stripping the prefix and forwarding to simctl-spawned children when
   xcodebuild calls simctl internally to launch the test runner.
   Empirically: same result, env var doesn't reach test runner.

**The working mechanism is `xcrun simctl spawn <udid> launchctl setenv KEY VALUE`**.
This modifies the simulator's launchctl env, and all subsequently spawned
processes (including xcodebuild's test runner) inherit it.

**Why:** rismay's substrate has an app-store-snapshot pipeline where the
orchestrator (`digikoma-capture-app-store-screenshots`) needs to tell each
per-tuple test runner which locale/device/scene it represents. After six
debug cycles confirming the prefix-based mechanisms don't work, threading
through launchctl is the only path that actually delivers.

**How to apply:**
- Orchestrator side: `xcrun simctl spawn <udid> launchctl setenv <key> <value>`
  for each env var, BEFORE invoking `xcodebuild test`. The sim UDID is
  derivable from `xcrun simctl list devices --json` filtering by name +
  OS version. Boot the sim first via `simctl boot <udid>` (idempotent).
- Clean up after: `xcrun simctl spawn <udid> launchctl unsetenv <key>`.
- Test runner side: read via `ProcessInfo.processInfo.environment["<key>"]`
  exactly as you'd hope. The value will be there.
- Caveat: this only works for **iOS simulator destinations**. Mac Catalyst
  test runners don't spawn through simctl, so their env-forwarding takes
  a different path (Catalyst snapshot capture is a separate digikoma
  anyway — see `digikoma-capture-mac-screenshots`).

**Pipe-buffer landmine when parsing `simctl list devices --json`:** the
JSON output exceeds the macOS pipe buffer (~64KB) when many sims are
installed. Reading via `Process` + `Pipe` will deadlock if you call
`waitUntilExit()` BEFORE `readDataToEndOfFile()`. Always drain the pipe
first; the read blocks on EOF which arrives when the child exits, so the
ordering still completes correctly.
