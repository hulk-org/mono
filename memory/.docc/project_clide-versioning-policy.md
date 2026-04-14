---
name: CLIDE versioning policy
description: Keep CLIDE current package buildable while versioning protocol and inertly archiving old runtime source
type: project
---

CLIDE must not accumulate historical runtime packages as active SwiftPM roots.
Old CLIDE source will eventually stop compiling against the current Swift/C
toolchain, and any workspace-wide package sweep that sees a live `Package.swift`
would then break the substrate.

As of 2026-04-12, CLIDE v1 is active. The active
`clia-org/private/universal/domain/tooling/spm/clide` path is a symlink to the
full copied `clide-v1` package derived from the frozen `clia-tui` snapshot.
The original `domain/ai/spm/clia-tui` root is intentionally inert because its
manifest has been moved to `Package.swift.frozen`.

CLIDE v2 is the minimum C + Swift daemon package, at
`clia-org/private/universal/domain/tooling/spm/clide-v2`.

**Policy:**
- Do not combine CLIDE versions inside one `Package.swift`.
- Each maintained CLIDE line gets its own package root.
- CLIDE v1 is allowed to be a copied `clia-tui` package.
- Frozen source snapshots should use `Package.swift.frozen`, not a live
  `Package.swift`.
- CLIDE v2 is the daemon line and can become active later by switching the
  active `tooling/spm/clide` symlink.
- Version future daemon runtime and protocol inside the maintained current
  daemon package.
- Keep protocol adapters compiling with the current toolchain.
- Do not place frozen runtime source snapshots under active `spm/` discovery
  paths with live `Package.swift` manifests.
- If a frozen runtime is needed, archive it outside the default package
  discovery path or store the manifest inertly as `Package.swift.frozen`.
- Use versioned SwiftPM package identities only for maintained compatibility
  libraries, not for unmaintained historical executables.

This preserves `Package.swift` as the treaty without making old CLIDE versions
load-bearing in modern builds.
