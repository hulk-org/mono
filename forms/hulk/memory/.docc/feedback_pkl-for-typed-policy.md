---
name: pkl-for-typed-policy
description: "PKL (Apple's configuration language) is the substrate's typed-policy schema language, joining JSON for records. Substrate's first canonical PKL primitive lives at `clia-org/.../wrkstrm-identifier/Pkl/OrgPrefix.pkl` (schema); per-org records live as `<org>/private/universal/identity/<org>.org-prefix.pkl` (amends the schema). Operator-decided 2026-05-26."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

The substrate uses **PKL** (Apple's configuration language, https://pkl-lang.org) as its typed-policy schema language. PKL joins JSON as a substrate primitive, but the two have **different roles**:

| Format | Role | Examples |
|---|---|---|
| **JSON** | Operator-edited *records* — identity files, agendas, chronicles, beads, organism manifests | `<slug>@<operator>.substrate.identity.json`, `<slug>.collective.json` |
| **PKL** | Tooling-consumed *typed policy* — config that drives substrate behavior | `<org>.org-prefix.pkl`, future `OrgConfig.pkl`, naming-policy declarations |

**Why PKL for policy specifically:**
- Apple-native, Swift-friendly (pkl-swift exists; pkl CLI is `brew install pkl`).
- `amends` keyword enforces typed inheritance from a schema module — records can't drift from the type.
- Compact declaration syntax compared to JSON Schema; far less boilerplate than `.proto`.
- Evaluates to JSON/YAML/binary Pcf for consumption by any tool that doesn't speak PKL.
- Already substrate-blessed: `digikoma-org` has `digikoma-pkl` (LLM-callable PKL evaluator tool) since prior session.

**Canonical PKL primitive — OrgPrefix (substrate's first):**

Schema: `collectives/clia-org/private/universal/domain/tooling/spm/wrkstrm-identifier/Pkl/OrgPrefix.pkl`
```pkl
module substrate.OrgPrefix
slug: String
modulePrefix: String
```

Per-org records:
- `collectives/clia-org/private/universal/identity/clia-org.org-prefix.pkl`:
  ```pkl
  amends "../domain/tooling/spm/wrkstrm-identifier/Pkl/OrgPrefix.pkl"
  slug = "clia-org"
  modulePrefix = "CLIAOrg"
  ```
- `collectives/wrkstrm-core/private/universal/identity/wrkstrm-core.org-prefix.pkl`:
  ```pkl
  amends "../../../../clia-org/private/universal/domain/tooling/spm/wrkstrm-identifier/Pkl/OrgPrefix.pkl"
  slug = "wrkstrm-core"
  modulePrefix = "WrkstrmCore"
  ```

**Verification:** `pkl eval --format json <record>.pkl` produces clean JSON the substrate's tools can consume.

**Conventions established:**
- Schema files live in the **canonical-consumer tool's package** (here: `wrkstrm-identifier/Pkl/`) — not in schema-universal. PKL is currently a tooling concern, not a record schema.
- Records live in the **per-owner identity directory** (`<owner>/private/universal/identity/<name>.pkl`).
- Records use `amends` to bind to the schema and enforce the type.
- File extension `.pkl` for both schema and records.

**Companion entries:** [[feedback_definitions-are-json-not-markdown]] (PKL fulfills the "or maybe PKL" half) · [[feedback_org-prefix-on-module-names]] (the first PKL-declared policy is the org module prefix) · [[feedback_executable-naming-slug-at-org-dot-form]] (future companion field — org executable segment).
