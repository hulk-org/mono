---
name: constraints-belong-in-types-not-tests
description: Compile-time type constraints (protocols, generic where clauses, newtype wrappers, macros) prevent entire classes of bugs that runtime tests/preconditions only catch after the fact — Bjarne's C++ Concepts thesis applied to Swift.
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
When an invariant can be expressed at the type level, express it there.
Runtime tests and preconditions are the fallback for invariants the type
system can't yet capture, not the default place to enforce correctness.

**Why:** Bjarne Stroustrup's C++20 Concepts effort (40 years to ship) was
built on the principle that constraints in the type system catch mistakes at
compile time, with ergonomic errors at the call site, instead of producing
cryptic instantiation errors or runtime crashes. Swift has the analogous
machinery already: protocols with `where` clauses, opaque types (`some`),
existentials (`any`), property wrappers, generic constraints, and Macros
(5.9+). Curry-Howard says a type IS a proposition — once you've constructed
a value of that type, you've proven the proposition; no further runtime
check is needed. The user's articulation: "we need to be doing [this] for
constraining properties and types at compile time so that you don't program
mistakes."

**How to apply:**
- Before writing a `precondition(...)`, ask: "is there a wrapper type whose
  existence would prove this invariant?" If yes, mint the wrapper. Examples:
  `NonEmpty<T>`, `NonZero<Int>`, `Trimmed<String>`, `AbsolutePath<String>`
  vs `RelativePath<String>`, `Validated<T, Rule>`.
- Before writing a runtime "this enum value can't appear here" test, ask:
  "can the kind enums sit in two different protocols so the compiler refuses
  the wrong slot?" Two role-named protocols + protocol-constrained slot
  types makes the wrong kind a type error.
- Before writing a schema-battle test for a structural property (no
  duplicates, no shape collisions, exhaustive coverage), ask: "is this
  expressible as a Swift Macro (5.9+) that fails compilation?" Macros are
  the substrate's compile-time AST inspection lever.
- Runtime tests stay valuable for: behavioral properties, integration
  contracts, fixture round-trips, and invariants the type system genuinely
  can't express (yet). They are NOT the default home for type-shaped rules.
- When mining the substrate's existing runtime tests for refactoring
  candidates: every test whose name reads "X must be Y" or "X cannot be Z"
  is a compile-time-constraint candidate.
