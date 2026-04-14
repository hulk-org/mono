---
name: CommonProcess is cross-platform (not iOS)
description: swift-universal/.../common-process and the CommonShell wrapper work on Windows, Android, Linux, macOS, and Catalyst. NOT pure iOS — Apple's app sandbox forbids Process() at runtime. Process()/Subprocess shell-out is a viable building block on every platform except iOS.
type: project
---

`common-process` (and its `CommonShell` consumer) work on **Windows,
Android, Linux, macOS, and Catalyst** — confirmed by rismay 2026-04-09.
**Pure iOS is excluded** (rismay corrected this in the same session):
Apple's app sandbox forbids `Process()` at runtime even though the
code compiles and links. Catalyst is fine. tvOS/watchOS/visionOS
inherit the iOS restriction.

This matters for any "shell-out vs. pure-Swift" architectural decision.
Examples that change once you accept the cross-platform reality:

- `ReproducibleArchive` shells out to `tar` + `gzip` via `CommonShell`.
  rismay specifically picked this approach because it works on GitHub
  Actions Linux runners — and structurally it works anywhere both
  binaries are present and CommonProcess can launch them.
- New "common-archive" / "common-compress" / similar primitives in
  `swift-universal` should NOT be reflexively designed as pure-Swift just
  to cover non-Apple platforms. Shell-out is a legitimate first option.

Caveats that still apply:

- **iOS is out.** Apple's app sandbox prevents `Process()` from
  launching at runtime even though the code links. Any
  CommonProcess/CommonShell call reachable from a pure iOS app target
  will fail at runtime and likely flag in App Store review.
- The host needs the binaries on PATH. `tar`/`gzip` are present on Linux,
  macOS, BSD by default. Windows ships `tar.exe` on Windows 10+ but
  not `gzip`. Android typically only ships busybox via Termux.
- The current `common-shell/Package.swift` only declares `.macOS(.v13)`,
  `.iOS(.v17)`, `.macCatalyst(.v17)` in `platforms:`. The code is
  structurally Linux/Windows/Android-portable but the package
  declaration doesn't claim those platforms. The `.iOS(.v17)` entry is
  misleading — the API will compile against an iOS deployment target
  but Process() calls will fail at runtime.

**How to apply:** when designing a new system primitive that needs to
run a CLI tool (tar, gzip, ffmpeg, git, etc.), default to a CommonShell
shell-out implementation rather than reaching for a pure-Swift port.
Document the platforms it actually targets, and only build a
pure-Swift fallback when there's a concrete consumer who needs a
shell-free environment (App Store-shipped iOS app, etc.).
