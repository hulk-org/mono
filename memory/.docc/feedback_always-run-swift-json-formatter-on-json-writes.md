---
name: Always run SwiftJSONFormatterCLI on JSON writes
description: every JSON write in the substrate must be formatted with the substrate's SwiftJSONFormatterCLI before commit; skipping it accumulates drift the substrate has to clean up later
type: feedback
originSessionId: 40fbc6fc-eb17-423d-89ce-0ac679ccd6b9
---
After writing or editing any `.json` / `.issue.json` / `.schema.json` /
`.protocol.json` / chronicle / fixture file in the substrate, run the
canonical formatter:

```bash
FMT_PKG=/Users/sonoma/mono/private/universal/substrate/collectives/swift-universal/private/universal/domain/tooling/spm/swift-json-formatter
swift run --package-path "$FMT_PKG" 36865b9b-cli fix --file <path>
```

The executable product is `36865b9b-cli` (uuid-prefixed name in
Package.swift's `.executable(name: "36865b9b-cli", targets:
["SwiftJSONFormatterCLI"])`). The wd skill doc had the wrong name
(`swift-json-formatter`); use the product name from Package.swift, not
the package directory name.

**Why:** The substrate has a canonical JSON wire format —
alphabetically-sorted keys + space-before-colon (`"key" : value`) +
2-space indent. Authoring JSON without running the formatter ships
inconsistent shape and accumulates drift the substrate has to clean
up later. The operator explicitly flagged "we're not using our
swift-json-formatter and i hate it" — strong feedback. Honor the
substrate's tooling.

**How to apply:** Run after every Write / Edit of a JSON file, BEFORE
committing. For session-end winddowns where many JSON files were
written, run a batch-format pass per touched directory. Include the
formatter invocation as a step in any typed SOP that writes JSON. For
session-history JSON that was committed pre-formatted, file a
retroactive-format-sweep bead rather than going back and reformatting
mid-flight.
