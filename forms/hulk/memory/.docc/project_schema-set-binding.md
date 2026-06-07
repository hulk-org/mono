---
name: Schema set binding model
description: How agent identity files bind to schema sets via the universal aggregator, and why per-file schemaVersion is not stale drift
type: project
---

Per-file `schemaVersion` on identity/agenda/chronicle packets is the **family version**, not the set version, and is not stale drift on its own. Under `core-triad-set-v0.6.0`, identity-schemas is family version 0.3.0 — so an identity file carrying `schemaVersion: 0.3.0` is correct, it just lacked a set context to anchor it. Tau's investigation at `schema-universal/universal-schema.incident.docc/root-schema-set-manifest-investigation.md` overstates Gap 2 on this point: 0.3.0 was never bogus, the detector was conflating set version with family version.

The substrate-side binding model that landed 2026-04-08:

- **Universal aggregator**: `private/universal/schemas/sets/Package.swift` — thin SPM package whose only job is to path-dep the canonical schema-set wrappers inside `schema-universal/.../schemas-sets/<set>/<version>/spm/` and re-export them via `Sources/SchemaSets/SchemaSets.swift` as `@_exported import`s. Adding a new bindable set = one new path dep + one re-export. No copies, no symlinks, no doctrine ratification.
- **Per-agent binding**: identity bundles carry a `schemaSetRefs` array, peer of the existing `schemaVersion` field, with entries shaped `{ aggregator, manifest, set, swiftProduct }`. The `swiftProduct` names the library exposed by the canonical wrapper (e.g. `CoreTriad_Set_v000_006_000`).
- **Compile check**: `swift build --package-path private/universal/schemas/sets` is the literal "does the substrate compile against its declared sets" test. First green build was 2026-04-08, 188 steps, no SPM_USE_LOCAL_DEPS needed.
- **Cross-check**: a binding is consistent when the file's `schemaVersion` equals the manifest's `operational.bindings[fileSuffix].schemaVersion` row for the matching kind. Mismatch should fail at load — but no loader enforces this yet.

**Why:** Resolves the "agents can't figure out which sets they're bound to" gap rismay opened, while preserving the existing schema-universal SPM wrappers as the single source of truth. Avoids the symlink/copy/move debate by making the universal-namespace package an *index*, not a *registry*.

**How to apply:** When binding a new agent (tau, codex, clia-org, etc.), first add the relevant set as a path dep in `private/universal/schemas/sets/Package.swift` and re-export it from `SchemaSets.swift`, then add the `schemaSetRefs` entry to that agent's identity. Verify with `swift build --package-path private/universal/schemas/sets` and an eye-check that the file's `schemaVersion` matches the manifest's binding row. Do **not** rewrite per-file `schemaVersion` fields under the assumption they are stale — they are family versions under the declared set.

**Two layers, two rules — do not conflate:**

1. **Schema set wrappers** (e.g. `core-triad-set-v000-006-000` inside `schema-universal/.../schemas-sets/<set>/<version>/spm/`) are explicitly allowed to `@_exported import` their constituent family products. Composing families into a single bindable surface is the whole point of a set. The carve-out from `feedback_no-reexport-typealias.md` and `feedback_direct-deps-not-transitive.md` applies **here**. Each set wrapper has a `*-exports.swift` source file that re-exports its members; that file is correct, do not strip it.

2. **The universal aggregator** at `private/universal/schemas/sets/` is **not** a schema set. It is the index of *which sets* the substrate currently binds. It has no public API, no re-exports, and no consumers — `Sources/SchemaSets/SchemaSets.swift` is just `public enum SchemaSets {}` so the target has something to compile. Its only job is to make `swift build --package-path private/universal/schemas/sets` resolve every declared set's wrapper, proving they still build together. Agents bind directly to a set wrapper's product (e.g. `CoreTriad_Set_v000_006_000`) via `identity.schemaSetRefs.swiftProduct`, not by importing `SchemaSets`. The direct-deps and no-reexport rules apply **here**.

If a future task wants to "simplify" the aggregator by adding `@_exported import` to pull set types through it, that's wrong — it would turn the index into a kitchen-sink super-package and break the direct-deps rule. The aggregator stays sourceless-in-spirit.

**Deferred / not done yet:**
- `SchemaSetDetector.detect` still content-sniffs; no manifest read yet.
- No loader enforces `schemaVersion` ↔ manifest row equality at load time.
- Only `core-triad-set-v0.6.0` is in the aggregator. Tau, codex, clia-org still unbound.
- No deprecation policy decided for `schemaVersion` field itself; investigation's Gap 2 question is still open.
- Pilot bound: `claude@rismay.substrate.identity.json` only.
