# SPM Test Fixture Pattern (schema-universal)

The fixture-first test pattern for swift-universal-style schema packages,
based on what worked in `inference-engine-schemas v0.1.0`, the converted
`agent-schemas v0.3.0`, and the `core-entity-migrations v0.7.0-to-v0.8.0`
migrator test conversion (2026-04-05).

## Why fixtures, not Swift-built values

The contract for a schema family is **"can the decoder read what an external
producer wrote"**, not "can the encoder reproduce what I hand-built in
Swift". Swift-built test values only prove the symmetry of one encoder + one
decoder against itself. Real wire-format JSON proves the schema actually
matches what external producers emit.

For migrators, the contract is even sharper: **"the canonical source wire
format upgrades to the canonical target wire format"**. Hand-built legacy
values can drift from what real legacy data looks like.

## Directory layout

For schema family round-trip tests:

```
tests/<package>-tests/
├── <Test>.swift
└── resources/
    ├── <model>-minimal.json
    ├── <model>-full.json
    └── <model>-wrong-version-X.json
```

For migrator tests (where source/target distinction matters):

```
tests/<migrator-package>-tests/
├── <Test>.swift
└── resources/
    ├── source/
    │   ├── <example-A>.json
    │   └── <example-B>.json
    └── target/
        ├── <example-A>.json
        └── <example-B>.json
```

## Package.swift configuration

**For schema family round-trip tests** (flat resources), use `.process`:

```swift
.testTarget(
  name: "<Package>Tests",
  dependencies: [...],
  path: "tests/<package>-tests",
  resources: [
    .process("resources")
  ])
```

**For migrator tests** (with subdirectories that must be preserved), use
`.copy`:

```swift
.testTarget(
  name: "<Migrator>Tests",
  dependencies: [...],
  path: "tests/<migrator>-tests",
  resources: [
    .copy("resources")
  ])
```

**Critical:** `.process` flattens the directory structure when copying
resources into the test bundle. `.copy` preserves the literal directory
layout. Migrator tests need `.copy` because they rely on
`source/`/`target/` separation in the bundle.

## Loading fixtures

For flat resources (`.process` mode):

```swift
private func fixtureData(_ name: String) throws -> Data {
  guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
    Issue.record("Missing fixture: \(name).json")
    return Data()
  }
  return try Data(contentsOf: url)
}
```

For nested resources (`.copy` mode), use the `subdirectory:` parameter and
include the literal `resources/` prefix because `.copy` preserves the
top-level directory name:

```swift
private func loadSourceOrganism(_ name: String) throws -> SomeModel {
  guard
    let url = Bundle.module.url(
      forResource: name,
      withExtension: "json",
      subdirectory: "resources/source")  // NOT just "source"
  else {
    Issue.record("Missing fixture: resources/source/\(name).json")
    throw FixtureError.missing("resources/source/\(name)")
  }
  let data = try Data(contentsOf: url)
  return try JSONDecoder().decode(SomeModel.self, from: data)
}
```

## Test scenarios that should always exist

For a schema family round-trip test:

1. **Decodes minimal fixture** — only required fields, defaults the rest
2. **Decodes full fixture** — all fields populated
3. **Round-trip discipline** — full fixture decodes, re-encodes, re-decodes
4. **Rejects wrong schemaVersion** — at least one fixture with the wrong
   version should fail decoding

For a migrator test:

1. **Static configuration** — sourceSchemaSet, targetSchemaSet, slug strings
2. **Happy-path upgrade** — load source fixture, run upgrade, assert on result
3. **Warning emission** — load a fixture that triggers a known warning,
   assert the warning is emitted
4. **Surface upgrade** — bundle-level upgrade with multiple inputs
5. **Source round-trip** — proves the source fixture itself is valid wire
   format the legacy decoder accepts cleanly

## Anti-patterns to avoid

- **`Bundle.main`** — wrong bundle. SPM test resources go through `Bundle.module`.
- **Forward-slashes in `forResource:` without `subdirectory:`** — silently
  returns nil because `forResource:` matches a flat name, not a path.
- **`.process` for migrator tests** — flattens `source/target/` structure
  and breaks any test that depends on namespace separation.
- **Hand-encoding Swift values to compare against re-encoded results** —
  proves nothing about external producers.

## Reference implementations

| Pattern | File |
|---|---|
| Round-trip with `.process` | `inference-engine-schemas/v0.1.0/.../InferenceEngineModelTests.swift` |
| Round-trip with `.process` (converted) | `agent-schemas/v0.3.0/.../AgentSchemaTests.swift` |
| Migrator with `.copy` and source/ subdir | `core-entity-migrations/v0.7.0-to-v0.8.0/.../CoreEntityMigrationTests.swift` |
