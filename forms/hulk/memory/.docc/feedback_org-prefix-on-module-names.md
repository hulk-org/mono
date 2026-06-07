---
name: org-prefix-on-module-names
description: "Substrate Swift modules owned by a collective carry that collective's `<OrgPascalCase>` prefix in the MODULE/TARGET name so `import` lines are self-locating. Canonical example: `import CLIAOrgHarnessCore` tells you the module lives in `clia-org`. Operator-stated 2026-05-26 as the Swift-identifier-layer companion to the slug@org.form executable-naming doctrine."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

Swift modules/targets/libraries owned by a collective are named `<OrgPascalCase><RestOfName>` so that any `import <ModuleName>` statement immediately tells the reader which collective hosts the source code. The prefix is the same axis as the `<slug>@<org>.<form>` executable-naming convention from [[feedback_executable-naming-slug-at-org-dot-form]], just expressed at the Swift-identifier layer instead of the operator-facing-binary layer.

**Canonical example (operator-decided 2026-05-26):**

```
Package directory:   collectives/clia-org/private/universal/domain/tooling/spm/harness-core@clia-org.cli/
Package name:        harness-core@clia-org-cli
Product/binary:      harness-core@clia-org.cli
Swift module:        CLIAOrgHarnessCore        ← org prefix here
Import line:         import CLIAOrgHarnessCore ← tells you "this came from clia-org"
```

**Org module prefix is DECLARED, not derived:**

The org's module prefix is authoritative state that should live in the org's **profile/identity record** (e.g., `collectives/<org>/private/universal/identity/<org>@<operator>.substrate.identity.json` or a peer file). The PascalCase mapping from directory name is the *default guess* when no explicit declaration exists, but the declared value wins.

Why declared, not derived:
- Some orgs have acronyms with conventional all-caps rendering (`clia-org` → `CLIAOrg`) — a pure dir→PascalCase routine has no way to know that.
- Some orgs have a separate sub-org subordinate to a parent (`wrkstrm` vs `wrkstrm-core`) — operator may want both to share a prefix or have distinct ones.
- Some orgs may want an opaque/abbreviated prefix for log brevity (`digikoma` → `DK`? `Dgk`?).

**Canonical declared prefixes (operator-stated 2026-05-26):**
- `clia-org` → `CLIAOrg` (acronym preserved as all-caps)
- `wrkstrm-core` → `WrkstrmCore` (PascalCase, no acronym)

Future orgs declare their prefix the same way. Tools building module-name renames consume the declared prefix rather than deriving from the directory.

**Default mapping when no declaration exists:**
- Direct PascalCase of the full collective directory name, with acronyms recognized as all-caps when conventional in prose.
- Example defaults: `kura-org` → `KuraOrg`, `digikoma` → `Digikoma`, `ghost-shell-org` → `GhostShellOrg`.
- This is only a default; the operator can override per-org via the profile declaration.

**Apply rule (touch-and-migrate, per operator 2026-05-26):**
- When you migrate a file under the swift-prefix ban + naming-convention sweep, also apply the org prefix to every module declared in that file's package.
- Don't sweep orgs that aren't otherwise being touched in the same session — adjacent unchanged code keeps its old names until the touch-and-migrate rule reaches it.
- Same migration discipline as [[feedback_async-parsable-command-only]]: "touching a file with legacy modules → migrate all modules in that file."

**SwiftPM mechanics:**
- The Package.swift `.library(name:)` and `.target(name:)` use the new `<OrgPascalCase><Rest>` form.
- The package's `name:` field stays in the hyphen + `@<org>` form (e.g., `harness-core@clia-org-cli`) — that's the SwiftPM dependency-resolution identifier, separate from the Swift module identifier.
- Source-directory paths (the `path:` field) are arbitrary; the existing kebab-case rule from commit `0e3d896` continues. The org prefix is only at the Swift-identifier layer.

**Why:**
- Reading `import HarnessCore` doesn't tell you where the source lives. Reading `import CLIAOrgHarnessCore` does — one glance, ownership resolved. Same payoff as the slug@org.form binary-name convention: encoded provenance in operator-facing surfaces.
- Hard pre-commit grep: `grep -r CLIAOrg` finds every consumer of clia-org modules across the substrate in one sweep. Pairs with the existing `grep -r clia-org` for directories + binaries.
- The convention scales: future orgs' modules read `WrkstrmCommitFilter`, `KuraOrgVaultIndex`, etc.

**Companion entries:** [[feedback_executable-naming-slug-at-org-dot-form]] · [[feedback_async-parsable-command-only]] · [[feedback_substrate-dotted-form-factor-vocabulary]]
