---
name: Use rismay-substrate.xcworkspace for shared build cache
description: Every new SPM package or app must be added to private/universal/substrate/rismay-substrate.xcworkspace so Xcode shares build caches across the 922+ packages in the substrate
type: feedback
---

Every new SPM package or Xcode project created in the substrate MUST be
added to the canonical workspace at
`private/universal/substrate/rismay-substrate.xcworkspace`. This workspace
has 922+ FileRef entries and enables Xcode's shared DerivedData across
all targets — without it each package recompiles MetalGameEngine, CommonLog,
WrkstrmFont, etc. from scratch independently.

**Why:** Build cache sharing. A full substrate build can take 30+ minutes;
shared caches reduce incremental builds to seconds. SPM's `swift build`
from the command line does NOT share caches across packages.

**How to apply:**
- After creating a new package at `collectives/<name>/.../<package>/`,
  add a `<FileRef location="group:/Users/sonoma/mono/.../<package>">` entry
  to `rismay-substrate.xcworkspace/contents.xcworkspacedata` in the
  appropriate group.
- For wrkstrm-performance packages: add under the wrkstrm-performance group.
- For wrkstrm-app apps: add under the wrkstrm-app group.
- For build + launch cycles: open the workspace in Xcode and build from
  there, not via `swift build` on individual packages.
- The workspace path is: `private/universal/substrate/rismay-substrate.xcworkspace`
