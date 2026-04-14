---
name: xcodebuild needs launchctl setenv for SPM_USE_LOCAL_DEPS
description: Plain `SPM_USE_LOCAL_DEPS=true xcodebuild ...` does not propagate the env var to xcodebuild's package manifest evaluator on macOS; use `launchctl setenv` for the duration of the build, then unset.
type: feedback
---

When an xcodebuild project consumes substrate packages whose `Package.swift`
uses the `localOrRemote(...)` toggle (common-ai, google-ai-swift, and
many wrkstrm/swift-universal packages), the manifest evaluator inside
xcodebuild does **not** see `SPM_USE_LOCAL_DEPS` even when you do:

```bash
SPM_USE_LOCAL_DEPS=true xcodebuild ...
export SPM_USE_LOCAL_DEPS=true && xcodebuild ...
env SPM_USE_LOCAL_DEPS=true xcodebuild ...
```

xcodebuild's manifest evaluator runs in a sandboxed subprocess that strips
non-allowlisted env vars. `SPM_USE_LOCAL_DEPS` is not in the allowlist, so
`useLocalDeps` evaluates to `false` and `localOrRemote()` returns the
**remote URL** form. Then SPM rejects the resolution because the remote
google-ai-swift's published tag has an unstable transitive dep on
common-log.

**The reliable workaround is `launchctl setenv`**, which puts the var
into the user's launchd session. xcodebuild and its sandboxed
subprocesses inherit launchd-session env vars.

```bash
launchctl setenv SPM_USE_LOCAL_DEPS true
xcodebuild -project ... -scheme ... -derivedDataPath ... build
launchctl unsetenv SPM_USE_LOCAL_DEPS    # always clean up
```

`swift package` (the CLI) does NOT need this — plain
`SPM_USE_LOCAL_DEPS=true swift package ...` works fine. This issue is
specific to xcodebuild.

**Why:** Verified empirically on 2026-04-08 building Prep Lab
(`study-lab.mac` in `codeswiftly/.../apps/study-lab/`). All four other
incantations failed with the same `google-ai-swift … unstable-version
package 'common-log'` error. `launchctl setenv` resolved on the first
attempt.

**How to apply:**
- For any xcodebuild build of a substrate Apple app that depends on
  common-ai, google-ai-swift, or other `localOrRemote`-using packages,
  set the launchd env var first.
- Always pair the `setenv` with an `unsetenv` so the var doesn't leak
  into other processes for the rest of the login session. The release
  doctrine in `laussat-studio-shipping.md` requires the var to be
  **unset** for release builds (`env -u SPM_USE_LOCAL_DEPS xcodebuild`),
  so leaving it set in launchd would silently break a later release
  build.
- This does **not** override the
  `feedback_localOrRemote-default-false.md` rule. The default in
  Package.swift remains false (remote); we are only opting in
  per-build via the operator-controlled launchd env.
