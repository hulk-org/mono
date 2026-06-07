# CUJ Articles Without Tests Are Vibes

Date: 2026-05-17

Substrate ship-readiness discipline crystallized via operator pushback.

## What happened

I wrote 8 Critical User Journey (CUJ) articles as DocC markdown for the
Ghost app — actor, trigger, steps, success criteria, failure modes,
status. Front-and-center per the ship-readiness contract.

Then I started doing manual verification.

Operator's pushback: *"but did you create automated tests for the CUJs
first?"*

## The doctrinal claim

**CUJ articles without tests are vibes; CUJ tests without articles are
noise. The substrate's pattern is articles + tests, each citing the
other.**

- The article says "this is what the journey claims" (operator-facing
  narrative).
- The test says "this is what the code provably does" (mechanical
  assertion).
- The article references the test file in its "Related → Implementation
  references" section.
- The test names quote the article's CUJ ID and title (`@Test("CUJ 01
  — First-Time Summon …")`).

Either alone is incomplete:
- Articles alone become aspirational checklists nobody can audit.
- Tests alone become opaque assertions nobody can read for intent.

## What separable test scope looks like

Not every CUJ step is mechanically testable agent-tier. The discipline
is to be honest about what is and isn't:

```
CUJ assertion                              Test layer
────────────────────────────────────       ──────────────────────
Scanner returns N artifacts                Swift Testing (Foundation)
Manifest has correct shape                 Swift Testing (Foundation)
SUMMON button enable logic                 Swift Testing (pure)
Cross-count consistency invariants         Swift Testing (Foundation)
Pipeline command shape                     Swift Testing (string ops)
─────────────────────────────────────────────────────────────────────
SwiftUI hero renders correctly             XCUITest (UI snapshot)
Adapter voice is first-person              Operator-gate (judgment)
Theorem-hour escalation triggers           Operator-gate (judgment)
End-to-end pipeline produces real artifact Integration test (heavy)
```

Mechanical tests are agent-tier; operator-gate items are explicit. Both
get listed.

## How this rescued the night

After the pushback I added a `GhostCUJTests` target to the ghost app
(via xcodegen `bundle.unit-test` type) and wrote 19 Swift Testing
assertions across 6 suites covering CUJ 01 readiness, CUJ 04
cross-count consistency, CUJ 05 library totality, CUJ 07 command
shape, plus identity-contract invariants. All 19 passed.

The CUJ articles now reference those tests in their "Implementation
references" sections; the tests are named after the article they
verify. Doctrine + proof, side by side.

## How to apply

When the next ship-shape product question arises:

1. Write the CUJ article (operator-facing narrative).
2. **Immediately** add at least one Swift Testing assertion per CUJ
   that's mechanically verifiable.
3. Be explicit in the article's Status block about which CUJs need
   operator-tier verification vs which are agent-tier proven.
4. Cross-link both ways.

Don't write a single page with all CUJs — split per article (each CUJ
gets its own DocC page). Lets each one have its own `@PageColor`,
status, code refs, and reads cleanly in DocC.

## Substrate-side test target gotcha (worth saving)

For a SwiftUI app whose `PRODUCT_NAME` is a wrkstrm-identifier hash
(e.g., `28d558fc`):

```yaml
# project.yml — Ghost target
settings:
  PRODUCT_NAME: 28d558fc           # canonical hash, becomes .app filename
  PRODUCT_MODULE_NAME: Ghost       # Swift module name — must be valid identifier

# project.yml — GhostCUJTests target
settings:
  TEST_HOST: $(BUILT_PRODUCTS_DIR)/28d558fc.app/Contents/MacOS/28d558fc
  BUNDLE_LOADER: $(TEST_HOST)
```

Without these two overrides:
- `@testable import Ghost` fails (Swift can't find a module named
  after the hash because hashes can start with digits).
- `xcodebuild test` fails with `Could not find test host for
  GhostCUJTests: TEST_HOST evaluates to "/path/to/Ghost.app/..."`
  because Xcode's default template assumes PRODUCT_NAME == target name.

Set both. Then `@testable import Ghost` works and the test bundle hosts
inside the hash-named .app correctly.

## Source

Live correction during the 2026-05-16/17 Ghost-app ship-readiness pass.
After 8 CUJ articles landed I jumped to manual verification; operator
pushed back; the test scaffolding followed. The final state was
`Tests/GhostCUJTests/GhostCUJTests.swift` with 19 passing Swift Testing
assertions, and the articles + tests cross-linking each other.
