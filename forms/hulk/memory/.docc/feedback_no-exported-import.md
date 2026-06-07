---
name: No @_exported import
description: never use `@_exported import Foo` to leak a dependency's symbols to consumers — same anti-pattern as `public typealias X = OtherPackage.X`
type: feedback
originSessionId: a0cdddaa-f001-4f3b-a3f8-28aa502f7ad6
---
Never use `@_exported import Foo` in a Swift module. It's the same anti-pattern as `public typealias X = OtherPackage.X` — it lets downstream consumers reference `Foo`'s symbols without declaring `Foo` as a direct dependency, hiding the actual dep graph.

**Why:** breaks the "Direct deps not transitive" rule. Consumers that look like they only depend on `Bar` are silently picking up `Foo`'s symbols through `Bar`'s re-export, so the dep graph in their `Package.swift` lies. When `Bar` later drops or renames `Foo`, those consumers break in non-obvious ways. The plus-rule from `feedback_no-reexport-typealias.md` applies here too.

**How to apply:** if you see `@_exported import Foo` in a package, delete the line. Then sweep every consumer of that package and add an explicit `import Foo` wherever they use `Foo`'s symbols. Consumers' `Package.swift` (or `project.yml`) must also declare the direct dep on `Foo`. The pattern `@_exported import` is never the right answer — there is no "ergonomic re-export" exception.
