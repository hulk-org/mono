---
name: Digikoma is the canonical protocol, not Logikoma
description: New komas conform to DigikomaIdentifiable (DigikomaCore); Logikoma is the deprecated predecessor and only Tachikoma/Logikoma names get preserved during the substrate-wide Digikoma → Digikoma rename
type: feedback
originSessionId: d1242b94-1af3-4e43-85ab-68cb830f0f9b
---
When scaffolding a new bounded execution unit in digikoma-org, conform to
`DigikomaIdentifiable` from DigikomaCore — not the older `Logikoma` protocol.
The DigikomaIdentifiable.swift docstring is explicit: "Replaces the older
`Logikoma` protocol."

**Why:** rismay flagged this directly after I shipped two komas using
`: Logikoma`. The substrate has an in-flight `Digikoma → Digikoma` rename
orchestrated by `digikoma-rename-fleet` (in digikoma-org/.../directory/) whose
preserve/rename/restore stages explicitly preserve `Tachikoma` and `Logikoma`
strings while renaming everything else `Digikoma*` to `Digikoma*`. New code
should be born on the destination side, not the migration path.

**How to apply:**

- Class types: `DigikomaXTool`, `DigikomaXArguments`, `DigikomaXResult`,
  `DigikomaXMatch`, `DigikomaXToolError`. Filenames match.
- Package directory: `digikoma-x` (kebab-case).
- Library product / target: `DigikomaXTool`. Executable: `digikoma-x`.
  Test target: `DigikomaXToolTests`.
- Conformance: `public struct DigikomaXTool: DigikomaIdentifiable`.
  Default `Intelligence == AutoDigikomaIntelligence` is fine for
  pure-function digikomas (no FoundationModels session inside the loop).
- KEEP unchanged because they live in the still-named `DigikomaCore` package:
  `import DigikomaCore`, `DigikomaIdentity(...)`, `DigikomaAction.fetch/.clean/etc.`,
  `.product(name: "DigikomaCore", package: "digikoma-core")`, `komaSlug`, `komaVersion`.
- Domain parent dirs (`build/`, `directory/`, `core/`, etc.) keep their
  short kebab names — the rename only affects `Digikoma*` prefixes, not
  category dirs.
- Doc files (`アイディ.md`, `インスト.md`, `レイ.md`) say "Digikoma" in
  narrative; user-facing slugs (e.g. `"build-clean"`, `"symbolgraph-extract"`)
  stay short and don't carry the prefix.
