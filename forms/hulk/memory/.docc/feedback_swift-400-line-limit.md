---
name: Swift 400-line file limit
description: Swift source files should be under 400 lines; split by responsibility via extensions
type: feedback
---

All Swift source files in the substrate should stay **under 400 lines**.

**Why:** Keeps incremental compile scope local, keeps type-checker work
per file bounded, and forces real responsibility seams instead of
letting files balloon. Rismay flagged this after I split
`CliaMemCodexSessions.swift` into 8 files and still left 3 of them
over 400 (Loader 790, SessionsModel 585, PreviewSheet 460) — which
defeated the point of doing the split at all.

**How to apply:** When creating or growing a Swift file, plan to stay
under 400 from the start. Prefer splitting by responsibility via Swift
extensions (e.g. `Foo.swift` + `Foo+Queue.swift` + `Foo+Preview.swift`
for a class with distinct method clusters, or `Loader.swift`
`Loader+Scan.swift` + `Loader+Cache.swift` for a static-method enum).
Keep test-facing entry points (types + methods referenced by
`@testable import`) on the main declaration, not in an extension file,
so the test surface stays stable. Same for anything that needs to be
`nonisolated` or otherwise carries a non-default actor isolation — keep
it on the base declaration.
