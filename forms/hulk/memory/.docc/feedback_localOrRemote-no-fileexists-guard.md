---
name: localOrRemote helpers must not gate on FileManager.fileExists
description: SwiftPM Package.swift evaluation runs in an arbitrary cwd, so a relative-path fileExists check inside localOrRemote silently falls through to remote URL even with SPM_USE_LOCAL_DEPS=true
type: feedback
---

The `localOrRemote(name:path:url:from:)` helper used in `wrkstrm` SwiftPM
wrappers must NOT guard the local-path branch with
`FileManager.default.fileExists(atPath:)`. Trust the env var alone:

```swift
if useLocalDeps { return .package(name: name, path: path) }
return .package(url: url, from: version)
```

**Why:** SwiftPM evaluates Package.swift manifests in a sandboxed subprocess
with an arbitrary working directory — relative paths can't be resolved from
inside the manifest via `FileManager`. The `fileExists` check therefore
returns `false` in practice and silently routes the dependency to the remote
URL even when `SPM_USE_LOCAL_DEPS=true` is set. That broke localize → common-ai
→ google-ai-swift → common-log on 2026-04-09: localize correctly went local
for common-ai, but common-ai (with the fileExists guard) went REMOTE for
google-ai-swift, and the published google-ai-swift declares common-log as a
path dep, which trips SwiftPM's "stable-version package can't depend on
unstable-version" validator.

**How to apply:** when sweeping the ~62 schema-universal/wrkstrm wrappers
(see `project_schema-universal-wrapper-sweep.md`), strip any `fileExists`
guard from `localOrRemote`. Match the pattern in
`wrkstrm-core/private/cross/spm/localize/Package.swift` and (now)
`wrkstrm/public/universal/spm/domain/ai/common-ai/Package.swift`.

**Bonus gotcha:** on macOS, `SPM_USE_LOCAL_DEPS=true swift build` still won't
propagate the env var to the manifest evaluator subprocess in some configs.
Use `launchctl setenv SPM_USE_LOCAL_DEPS true` then `launchctl unsetenv` to
bracket — same pattern as `feedback_xcodebuild-spm-use-local-deps.md`.
