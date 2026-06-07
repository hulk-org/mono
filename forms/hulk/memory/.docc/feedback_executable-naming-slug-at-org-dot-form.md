---
name: executable-naming-slug-at-org-dot-form
description: "Substrate executable products are named `<slug>@<org>.<form>` going forward (e.g., `harness@clia-org.cli`). Generalizes the existing dotted-form vocabulary with an `@<org>` segment — the **full collective directory name** — that namespaces across collectives. Obfuscators can remap the public name later — pick names that express INTENT today and let downstream transforms alias them. Operator-stated 2026-05-26."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

Substrate executable products use the three-segment form:

```
<slug>@<org>.<form>[.<sub-form>]
```

Examples:
- `harness@clia-org.cli` — the canonical example, the substrate's harness control surface; owned by the `clia-org` collective (AI-coordination domain). The product binary carries the **full collective directory name** (`clia-org`), not a short form (`clia`).
- Future: `savepoint@wrkstrm.cli`, `<slug>@kura-org.cli`, `<slug>@digikoma.cli`, etc.

**Why:**
- **Hides implementation language.** No `swift-` prefix in operator-facing names, logs, `ps`, or status lines.
- **Org segment is domain-driven, not just ownership.** The `@<org>` segment names whichever collective owns the *concept*, not whoever happens to host the source. Canonical: `harness@clia-org.cli` because **`clia-org` is the AI-coordination collective** and harness control is AI coordination (operator-corrected 2026-05-26, after I initially proposed `@universal`). Future CLIs land where their concept lives: a savepoint CLI → `savepoint@wrkstrm.cli` (commit/version infrastructure is wrkstrm's domain), a kura tool → `<slug>@kura-org.cli`, a digikoma orchestrator → `<slug>@digikoma.cli`. `@universal` is reserved for the rare CLI that genuinely spans all collectives (a generic substrate primitive used by every org).
- **`.<form>` aligns with [[feedback_substrate-dotted-form-factor-vocabulary]].** Substrate already uses `savepoint.cli`, `savepoint.sd`, `claude.app`. The new shape extends that doctrine with the `@<org>` namespace, not replacing it.
- **Obfuscator-friendly.** A future obfuscator pass can map `harness@clia-org.cli` → arbitrary bytes the substrate wants at runtime. Picking a name that *expresses intent today* and letting downstream transforms alias it is the [[feedback_projection-system-terminology-before-localization]] doctrine — additive projection layers, not retroactive renames.

**Three-layer naming (the path/product split):**
The substrate uses *different* names at three layers; each layer drops what's already conveyed elsewhere.

| Layer | Carries | Example |
|---|---|---|
| Operator-facing product (binary) | full provenance `@<org>` | `harness@clia-org.cli` |
| Source directory path | dotted form only (org dropped — already in filesystem home) | `sources/harness.cli/` |
| Swift module/target identifier | clean PascalCase (no `@`, no `.`, no org noise) | `HarnessCLI` |

Operator decision 2026-05-26: "the path can be `sources/harness.cli/` but the product name has to be `harness@clia-org.cli`." Filesystem home (`collectives/clia-org/...`) already conveys org; the source path doesn't need to repeat it. The product/binary name DOES repeat it because logs, `ps`, and installed-binary paths don't carry the filesystem context.

**SwiftPM mechanics:**
- Product names accept `@` and `.` (arbitrary string, used as binary filename).
- Target/module names cannot contain `@` or `.` (Swift identifier rules) — use the PascalCase mirror.
- Source-dir path is set via `path:` field in target spec; can differ from target name.
- Org segment uses the **full collective directory name** (`clia-org`), not a short form (`clia`), so `grep -r clia-org` catches both directories AND binary names in one sweep.

**Migration path for existing CLIs:**
- New CLIs use the three-segment form from day one.
- Existing two-segment products (`savepoint.cli`, `claude.app`) are grandfathered. Rename only when the touched-file rule applies (see [[feedback_async-parsable-command-only]]'s migration pattern).
- The legacy `swift-` prefix is banned everywhere going forward — every rename strips it.

**Companion entries:** [[feedback_substrate-dotted-form-factor-vocabulary]] · [[feedback_projection-system-terminology-before-localization]] · [[feedback_async-parsable-command-only]] · [[project_swift-harness-cli-size-aware-commit-tooling]]
