---
name: json-crispr-corpus-migrator-pattern
description: "Substrate's \"JSON CRISPR\" migrator architecture — generic Codable round-trip walker finds embedded model sub-trees in any host JSON file, typed Swift bridge translates source→target, pure-functional substitution lifts in place. Host-agnostic; one corpus pass migrates every occurrence across the repo regardless of which schema family wraps it."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

The substrate's migrator architecture is **NOT** the per-family-version Codable-roundtrip pattern (like the v0.4→v0.5 identity migrator). The right pattern is host-agnostic JSON-CRISPR with three separable pieces.

**Why:** the operator explicitly named the pattern after reviewing my v0.4→v0.5 template proposal: "the migrators are now supposed to be things that find the type in json files and then we do JSON CRISPR to modify them to the right shape ... LinkRef v3 has a migrator like that." Canonical implementation lives at `schema-universal/private/universal/domain/system/spm/swift-link-ref-corpus-migrator-cli/`. Confirmed "cool new pattern" by the operator.

**How to apply** — author migrators in this shape:

### 1. Generic Codable round-trip walker (substrate-wide library)

```swift
public func findPositions<T: Codable>(of type: T.Type, in data: Data) throws -> [(path: JSONPath, value: T)]
```

Visits every JSON node, tries to decode as `T`, treats the node as authentic **iff** `encode(decode(node)) == node` after canonical re-serialization (`JSONEncoder.outputFormatting = [.sortedKeys]`). The round-trip equality IS the formal correctness witness — false positives can't slip through.

### 2. Typed Swift bridge (one file)

```swift
public extension SourceModel {
  var asTargetVersion: TargetModel { /* pure translation */ }
}

public enum SourceModelBridge_X_to_Y: SchemaVersionBridge { ... }
```

Lives in `<source-family>/migrators/<sourceVer>-to-<targetVer>/spm/`. No JSON parsing — just one typed model translated to another. Conforms to `SchemaMigrationModel` protocol via `@retroactive` extension on both ends.

### 3. CRISPR substitution + per-file driver

```swift
public func substituting(in node: Any, at path: JSONPath, with newValue: Any) throws -> Any  // pure functional
public func migrateXInFile(_ url: URL, dryRun: Bool) throws -> FileMigrationReport         // find + lift + write
public func migrateXInDirectory(_ root: URL, dryRun: Bool) throws -> [FileMigrationReport] // recursive
```

CLI entry point at `domain/system/spm/swift-<source>-corpus-migrator-cli/sources/swift-<source>-corpus-migrator/main.swift`.

### Properties this gives you

- **Host-agnostic**: one corpus pass migrates every occurrence regardless of which schema family wraps it (roles[] in identity.json, assignmentRefs[] in agenda.json, anywhere else)
- **No false positives**: round-trip equality is the witness
- **No lost fields**: walks JSON tree directly, doesn't round-trip through host Codable
- **Idempotent**: re-running on already-migrated JSON is a no-op (target type doesn't decode as source)
- **Resumable**: per-file reports let you bisect on failure
- **Dry-run native**: `dryRun: true` returns the report without writing

### When NOT to use

Single-family version bump where the migration is purely additive (new optional fields, no shape change). For those, the host Codable-roundtrip pattern is still fine (e.g., the v0.4→v0.5 identity migrator was an "add new fields" bump). The corpus pattern is for *cross-host* migrations where the same embedded type appears in many wrappers.

### Slug-only translation case (Kleene-UNKNOWN-friendly default)

When the source type carries only enough info to identify the slug/kind but not the address (no path, no url), emit the target with `slugs: [kind, slug]` and an unresolved/empty target. Consumers handle UNKNOWN per [[three-valued-logic-open-catalogs]] — they decide whether to resolve, defer, or flag.

Related: [[class-name-equals-json-key-discriminator]] (the discriminator pattern that makes step 1 grepable), [[linkref-v3-canonical-v4-research-only]] (LinkRef is the substrate's universal target wire format), [[three-valued-logic-open-catalogs]] (UNKNOWN handling on slug-only refs).
