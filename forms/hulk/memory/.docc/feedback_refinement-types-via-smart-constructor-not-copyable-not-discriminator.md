---
name: refinement-types-via-smart-constructor-not-copyable-not-discriminator
description: "Substrate's typed-state-management pattern is REFINEMENT TYPES VIA SMART CONSTRUCTOR (aka 'parse, don't validate' / 'make illegal states unrepresentable'). Distinct from ~Copyable (linear types for single-use resources) and discriminated unions (enums for mutually-exclusive states). The wrapper carries proof of an invariant; the inner unrefined type stays PRIVATE so the proof can't be tossed. (2026-06-04)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-04, after I shipped `ContrastValidatedPalette` with `public let palette: SemanticPalette`):**
> if ~Copyable is not what you want are discriminators? what is it?

**The substrate-typed answer — three sibling patterns, each solving a different correctness axis:**

| Pattern | Solves | When you reach for it |
|---|---|---|
| `~Copyable` (linear/affine types) | "this value can be used AT MOST ONCE" | File handles, locks, DB transactions — resources where double-use is a bug. Swift's move-only types. |
| Discriminated union (`enum` with associated values) | "this value is in EXACTLY ONE of N mutually-exclusive states" | `Result<S, F>`, parse trees, finite state machines where consumers must handle each case via `switch` |
| **Refinement type via smart constructor** | "if this value EXISTS, an invariant has been proven about it" | Validated emails, sorted arrays, non-empty collections, palettes that passed contrast checks |

**Substrate's canonical name for this is `refinement type via smart constructor`** — aka "parse, don't validate" (Alexis King, Haskell) or "make illegal states unrepresentable" (Yaron Minsky, OCaml). The wrapper's existence IS the proof; constructors are the only path in; downstream code that holds a `ContrastValidatedPalette` doesn't need to re-check anything.

**Why discriminators (enums) are NOT what we want for palette validation:**

An enum like
```swift
enum PaletteState<E> {
  case valid(ContrastValidatedPalette<E>)
  case rejected(SemanticPalette<E>, [PaletteContrastIssue])
}
```
forces every downstream caller (renderer, shuffle resolver, UI indicator) to switch on each case at every use site. That pollutes the hot path with case-handling that only the validation BOUNDARY cares about. Refinement types push case-handling to the boundary (where validation happens) and downstream code sees only the proven-good shape.

**Why ~Copyable isn't right either:**

Palettes are pure values consumed many times per frame. Nothing about "rendered with this palette once, now it's consumed" makes sense. ~Copyable's job is single-use resources where double-use is incorrect (TCP sockets, mutex locks, MTLCommandBuffer.commit).

**The bug I had in the first ContrastValidatedPalette I shipped — and the fix:**

Original:
```swift
public struct ContrastValidatedPalette<E> {
  public let palette: SemanticPalette<E>  // ← validation invariant escapable
  // ...
}
```

Any caller could extract `.palette` and pass it to an unvalidated API. The wrapper LOOKED like a refinement type but didn't enforce one — the proof could be tossed.

Substrate-grade fix:
```swift
public struct ContrastValidatedPalette<E> {
  private let _palette: SemanticPalette<E>  // ← PRIVATE; proof inescapable
  public let thresholds: PaletteContrastThresholds
  public let reports: [AxisReport]

  public var slug: String { _palette.slug }
  public var displayName: String { _palette.displayName }
  public func resolve(mode:, target:, increasedContrast:) -> QuadColorState<...> {
    _palette.resolve(...)
  }

  public init(...) throws { ... }  // smart constructor — only path in
}
```

The substrate-doctrine moment when adding a new method to the wrapper: does it preserve the invariant, or does it leak validation state? If it leaks, the wrapper has stopped being a refinement type. Each public method is a load-bearing design decision.

**When BOTH patterns apply in the same codebase:**

- Discriminator at the **validation BOUNDARY** — `filterValid` could return `[Result<ContrastValidatedPalette, ValidationError>]` if callers care about which failed
- Refinement at the **downstream USE site** — the shuffle catalog is `[ContrastValidatedPalette]`, never `[Result<…>]`

They compose; they don't compete.

**When `~Copyable` WOULD become relevant in this codebase:**

If `AutoColorPolicy` transitions become async (background catalog reloads, animated swaps), the act of swapping policy could benefit from `~Copyable` — the old policy state would be CONSUMED on swap, structurally unreadable from any other reference. That's a transition-layer invariant orthogonal to the validation invariant the refinement type enforces.

**Composes with:**

- [[constraints-belong-in-types-not-tests]] — substrate's umbrella doctrine that this is a concrete instance of
- [[perceptual-quality-has-typed-failure-modes]] — the contrast report whose passing IS the refinement type's invariant
- [[Open-extensible catalogs require three-valued logic — UNKNOWN is first-class]] — Kleene logic at the validation boundary; refinement type after the boundary
- [[Every property fights for its life]] — adding a public method to the wrapper is the load-bearing moment

**How to apply going forward:**

1. When the substrate needs "value proven to satisfy X," reach for refinement type via smart constructor, not enum, not flag.
2. The smart constructor is the SINGLE path in. Inner state stays private. Public surface preserves the invariant.
3. If you find yourself accessing `wrapper.inner` from outside, the wrapper has stopped being a refinement — either expose a new method that preserves the invariant, or rethink whether the invariant was actually needed.
4. Provide BOTH a strict `throws` constructor (for tests/authoring/failable-by-design boundaries) AND a lenient `filterValid` static (for batch processing where you want the survivors).
