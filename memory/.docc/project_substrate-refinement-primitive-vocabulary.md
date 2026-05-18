---
name: substrate-refinement-primitive-vocabulary
description: Long-game vocabulary of ~8-12 refinement-type primitives the substrate is building toward (NonEmpty shipped, Bounded next, Trimmed/Slug/AbsolutePath/etc. follow); each pays one boundary check and carries the proof forever; composes with @Generable for LLM contracts and SwiftUI Form for generative UI.
type: project
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
The substrate is building toward a small, composable vocabulary of
**refinement-type primitives** that move invariants from runtime tests
into the type system. `NonEmpty<T>` (in `swift-universal/.../common-non-empty`,
shipped 2026-05-15) is the seed; the broader vocabulary the user has been
thinking about for a long time covers ~8-12 primitives that together cover
most invariants substrate apps actually need.

**Core vocabulary candidates (in priority order):**

1. `NonEmpty<T>` — at least one element. **Shipped.**
2. `Bounded<Value: BinaryInteger, let Min: Int, let Max: Int>` —
   value in `[Min, Max]`. Natively expressible in Swift 6.2+ via
   **SE-0452 Integer Generic Parameters** (shipped September 2025,
   the long-awaited value-generics beachhead). Pre-6.2 fallback was
   marker-type `Policy` carrying static min/max.
3. `NonZero<T: Numeric>` — value is never zero. Useful for division,
   array indices that must be positive, etc.
4. `NonEmptyString` — string is non-empty after trimming whitespace.
5. `Trimmed<String>` — whitespace-stripped at construction; idempotent.
6. `Slug<String>` — kebab-case-only string (no whitespace, no caps,
   only `[a-z0-9-]`). The substrate uses slugs everywhere.
7. `AbsolutePath<String>` vs `RelativePath<String>` — different *types*
   for the two intents, not just different fields. Compile-time
   prevention of "I passed a relative path where absolute was needed."
8. `Sorted<T>` — array known to be sorted. Carries the sort guarantee
   so binary-search and merge operations are statically safe.
9. `Unique<T>` — array known to be deduplicated.
10. `UniqueBy<T, key: KeyPath>` — deduplicated by a specific key.
11. `URL<Scheme>` — typed URL discriminated by scheme. Pairs with the
    LinkRefModel v0.3.0 `urlScheme` / `customScheme` / `substrateScheme`
    factories.
12. `Email<String>` — validated email shape.

**Architectural payoffs:**

- **Boundary-check factoring**: every refinement pays one check at
  the decoder/factory site; downstream consumers never re-check.
- **Composition**: `NonEmpty<Bounded<Int, 1, 100>>` carries two
  invariants in one type signature.
- **`@Generable` projection**: each refinement becomes a `@Guide`
  attribute on the LLM generation contract (per
  `reference_apple-generable-canonical-architecture.md`).
- **Generative UI projection**: SwiftUI `Form` widgets derive from
  the refinement type — `Bounded<Int, 1, 100>` becomes a slider
  with the right range without anyone telling the form generator.
- **Test surface reduction**: every "X must be Y" runtime test
  becomes unwriteable because the wrong value can't be constructed.

**Where this lives:**

- `swift-universal/.../common-non-empty/` — first primitive
- Future siblings: `common-bounded`, `common-non-zero`, `common-slug`,
  `common-paths`, `common-sorted`, `common-unique`. Or a single
  `common-refinements` aggregator package once 3-4 are in place.
- Each primitive uses CommonLog at `system="<PackageName>"`,
  `category="Lift"` / `"Codable"` for boundary-failure visibility.

**Why this order:**

`Bounded` is next because (a) SE-0452 just made it native-Swift
expressible for `Int`, and (b) it covers the "valid ranges" use
case the user has been thinking about since long before NonEmpty
shipped. After Bounded: NonEmptyString + Trimmed (string hygiene),
then AbsolutePath/RelativePath (immediate substrate use case —
LinkRefModel.Target.relativePath/absolutePath would consume them
in their `path:` parameter for compile-time prevention of swap bugs).
