# Spm Packaging

@Metadata {
  @TitleHeading("Expertise: Spm Packaging")
}

## Entries

- Diagnosing SwiftPM "stable depends on unstable" resolution failures and the chains where a remote-URL package transitively pulls a path-based package via a localOrRemote helper.
- **Live process home migration via the hardlink-drain pattern.** Two paths, one inode. Hardlinking every existing file from a legacy directory to its sibling at the canonical destination, then running an FSEvents-driven daemon that hardlinks any newly-created files within the coalescing window. Works because the OS resolves writes by inode, not path. The technique the founding-breach insight named for the first time. Documented at `hulk/memory/.docc/insights/hardlink-drain-2026-04-07.md`. Implemented as the saved Swift CLI `swift-hardlink-drain-cli` under `swift-universal/private/universal/domain/tooling/spm/`.
- **JSON Schema authoring against existing prior art.** Found `OrgCompanyModel` v0.1.0 in schema-universal as the legal-entity precedent, designed two new families that *reference* it via `OrgCompanyRef` rather than extending it. Result: a new `domain/apple/` neighborhood at v0.1.0 with `apple-signing-binding-schemas` (build/sign concern) and `apple-store-listing-schemas` (App Store presence concern). Each family ships JSON Schema (draft 2020-12, `additionalProperties: false`) + Codable Swift package (SemanticVersionable, custom init/encode/decode, prefix-free types) + fixture-driven swift-testing tests against placeholder instances.
- **`SemanticVersionable` schema-package convention** as it applies to the `org-company-schemas` v0.1.0 layout: `Package.swift` with `localOrRemote` helper, `private/.../sources/<family-name>-v000-XXX-000/`, `<Type>SchemaVersion.swift` with a `current` constant, `<Type>Model.swift` with custom init/encode/decode that uses `Self.decodeSchemaVersion(forKey:in:)`, `tests/<family-name>-v000-XXX-000-tests/resources/` for fixture-driven decode + round-trip tests. Mirrored exactly when adding the two new apple families.
