---
name: Swift Testing not XCTest
description: Substrate convention is Swift Testing (`import Testing`, `@Test`, `#expect`) for all new tests, never XCTest
type: feedback
---

All new Swift tests in the substrate must use the Swift Testing framework
(`import Testing`, `@Test`, `#expect`, `#require`, `@Suite`), not XCTest.

**Why:** rismay flagged this directly after I authored five XCTest files in
universal-schema-hygiene. The substrate prefers Swift Testing's value-type
suites + macro-based assertions over XCTest's class-based + function-name
conventions.

**How to apply:** when adding any new test file in any substrate Swift
package, use Swift Testing from the start. The existing XCTest test files
in some packages (e.g. universal-schema-hygiene/Tests/...) are legacy and
should be migrated when touched, but never freshly authored. Conversion
recipe:

- `import XCTest` → `import Testing` (+ `import Foundation` only if needed)
- `final class FooTests: XCTestCase` → `struct FooTests` (or
  `@Suite struct FooTests`)
- `func testFoo() throws` → `@Test func foo() throws`
- `XCTAssertEqual(a, b)` → `#expect(a == b)`
- `XCTAssertTrue(x)` → `#expect(x)`
- `try XCTUnwrap(x)` → `try #require(x)`
- `setUpWithError()` / `tearDownWithError()` → `init()` / `deinit`
  (deinit cannot throw — wrap cleanup in `try?`)
- For per-test temp directories the cleanest pattern is a struct property
  initialized in `init()` plus a `deinit` that does `try?
  FileManager.default.removeItem(at: tmp)`.
