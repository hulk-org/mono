---
name: Schema-universal wrapper localOrRemote sweep
description: State of the schema-universal SPM wrapper migration to the localOrRemote helper, and what's still hard-coded
type: project
---

Schema-universal has ~138 SPM wrappers under `private/universal/substrate/collectives/schema-universal/private/universal/`. They split into two patterns for resolving `swift-universal-main`:

- **Modern (76 wrappers as of 2026-04-08):** use a `localOrRemote(name:path:remote:)` helper with a 41-line preamble (`envBool`, `packageDir`, `resolvedPath`, `useLocalDeps`, `localOrRemote`). Default is remote (matches `localOrRemote defaults false` rule). Canonical reference: `schema-families/chronicle-schemas/v0.1.0/spm/chronicle-schemas-v000-001-000/Package.swift`.
- **Legacy (~62 wrappers):** hard-code `.package(url: "https://github.com/swift-universal/swift-universal-main.git", from: "3.0.7")`. SPM warns `Conflicting identity for swift-universal-main` whenever any chain in the same build also reaches the local-path identity, and the warning will escalate to an error in future SPM versions.

**Why:** The two identities (github URL vs local path under `collectives/swift-universal/`) collide in any dep graph that touches both, polluting downstream builds with warnings and blocking future SPM upgrades. The fix is mechanical: every legacy wrapper gets the same preamble + the `.package(url:...)` block replaced with a `localOrRemote(name:path:remote:)` call. The relative path in the call depends on directory depth — 8 ups from `schema-families/<family>/<version>/spm/<wrapper>/`, 10 ups from `domain/foundation/schema-primitives/<family>/<version>/spm/<wrapper>/`.

**How to apply:**
- For any new aggregator or set, run `swift build --package-path <aggregator>` and grep for `Conflicting identity`. Each warning identifies a wrapper that needs the fix. Apply the helper preamble + URL replacement; rebuild; repeat until silent.
- A few legacy wrappers already have the helper preamble but still hard-code the URL block (e.g. `contribution-schemas v0.1.0`, `focus-domain-schemas v0.1.0` as of pre-fix state). Check before adding the preamble — only the URL line needs replacing.
- Full sweep across all ~62 legacy wrappers should be done as a Swift CLI rewrite, not by hand. Patch-safety doctrine for sustained refactors applies.
- The wrappers live inside the `schema-universal` git submodule. Edits land on the submodule's working tree; commit inside the submodule and bump the pointer in mono separately. Cross-repo, not a single mono commit.

**Fixed in 2026-04-08 schema-set binding session (12 wrappers, tight scope of `core-triad-set v0.6.0` transitive graph):**
1. `schemas-sets/core-triads/v0.6.0/spm/core-triad-set-v000-006-000`
2. `schema-families/triad-primitives-schemas/v0.6.0/spm/triad-primitives-v000-006-000`
3. `schema-families/expected-contributions-schemas/v0.1.0/spm/expected-contributions-schemas-v000-001-000`
4. `schema-families/entity-primitives-schemas/v0.1.0/spm/entity-primitives-schemas-v000-001-000`
5. `schema-families/agenda-support-schemas/v0.1.0/spm/agenda-support-schemas-v000-001-000`
6. `schema-families/agenda-support-schemas/v0.5.0/spm/agenda-support-schemas-v000-005-000`
7. `schema-families/chronicle-support-schemas/v0.1.0/spm/chronicle-support-schemas-v000-001-000`
8. `schema-families/thread-link-schemas/v0.1.0/spm/thread-link-schemas-v000-001-000`
9. `schema-families/horizon-schemas/v0.3.0/spm/horizon-schemas-v000-003-000`
10. `domain/foundation/schema-primitives/section-schemas/v0.1.0/spm/section-schemas-v000-001-000`
11. `domain/foundation/schema-primitives/contribution-schemas/v0.1.0/spm/contribution-schemas-v000-001-000` (preamble already present)
12. `domain/foundation/schema-primitives/focus-domain-schemas/v0.1.0/spm/focus-domain-schemas-v000-001-000` (preamble already present)

After these 12, **clean** `rm -rf .build && swift build --package-path private/universal/schemas/sets` is silent. Edits are uncommitted on the schema-universal submodule working tree as of session end.

**Cache trap to know about:** `swift build` re-uses cached dependency resolution aggressively. The first incremental build after fixing only 8 wrappers reported "Build complete!" with `grep -c Conflicting identity` returning 0 — but that was because SPM hadn't re-resolved. A clean `rm -rf .build` rebuild surfaced 4 more legacy wrappers in the same graph. **Always do a clean rebuild for the final verification when sweeping conflict warnings**, otherwise the cache will lie.

**Still pending (~50 wrappers):** the broader sweep across legacy wrappers not currently in any active dep graph. Best done as a Swift CLI that detects the legacy pattern and applies the rewrite uniformly. Each fix needs a clean build verification of the aggregator after.
