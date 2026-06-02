---
name: digikoma-lineage-long-form-versions
description: "digikoma-org lineage.json uses long-form `MMM_NNN_RRR` SEMVER strings (major_minor_revision), NOT integers. Other digikoma surfaces use different version formats — don't conflate them."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

`lineage.json` for any digikoma in `digikoma-org/private/universal/domain/<domain>/digikoma-*/` uses **long-form underscore-separated SEMVER strings** for both `version` and `parentVersion`:

```json
{
  "version": "000_001_000",
  "timestamp": "2026-05-26T00:00:00Z",
  "summary": "First minor re-forge from v0.0.0 baseline.",
  "parentVersion": "000_000_000"
}
```

**Not** integers like `1` or `0`. The format encodes semantic versioning as `MMM_NNN_RRR` = `MAJOR_MINOR_REVISION` per [[feedback_digikoma-versions-start-at-zero]]. The third triplet is the **revision** (deliberate small iteration), not a CI-style automated build. The first lineage entry's `version` is `"000_000_000"` (v0.0.0) with `"parentVersion": null`.

## The substrate uses multiple version formats — don't conflate

| Surface | Format | Initial value | After first minor re-forge (v0.1.0) |
|---|---|---|---|
| Schema-family discriminator (`"IdentityModel"`, `"LinkRefModel"`, ...) | semver string | `"0.1.0"` | `"0.2.0"` |
| Schema-set manifest path / `set` field | semver with v-prefix | `"core-entity-set-v1.0.0"` | (sets don't re-forge; they re-publish) |
| Lineage `version` / `parentVersion` | **long-form semver `MMM_NNN_RRR`** | `"000_000_000"` / `null` | `"000_001_000"` / `"000_000_000"` |
| Swift product names (schema families) | long-form with `v` prefix | `Foo_Schemas_v000_001_000` (schemas historically started at v0.1.0, not v0.0.0) | `Foo_Schemas_v000_002_000` |
| `ToolInvocationReceipt.digikomaVersion` | **integer (re-forge ordinality)** | `0` | `1` |
| `スペック.json.version` (digikoma spec version) | **integer (re-forge ordinality)** | `0` | `1` |
| `digikoma-prove`-style Swift `digikomaVersion` static let | long-form semver | `"000_000_000"` | `"000_001_000"` |
| Forge protocol identifier in アイディ.md | long-form with `v` prefix | `v000_000_001` (the FORGE protocol, distinct from the forged digikoma's version) | unchanged unless the forge protocol itself revs |

Key disambiguation:

- The **long-form `MMM_NNN_RRR`** is semantic (major.minor.revision) — bumps reflect contract impact and follow the reset cascade ([[feedback_digikoma-versions-start-at-zero]]).
- The **integer form** is ordinal (Nth entry in lineage) — bumps by exactly 1 per re-forge regardless of semver step size, and never resets.
- A single re-forge can produce `(lineage[5] = "002_003_001", integer = 5)` — five re-forges total, current contract at v2.3.1 (one revision bump past v2.3.0).

The right format per surface is enforced by where it appears, not by surface name. When writing a new lineage record, *match the existing format in that file* — don't pick from another version-bearing surface.

**Why:** different format conventions exist because each surface composes with different consumers — JSON Schema validators (semver string), SPM module discovery (long-form with v-prefix), `ToolInvocationReceipt` Codable (Int), lineage history (long-form semver string for human-readable sortability AND contract-impact reasoning). Conflating them produces silent decode failures or sort-order regressions.

**How to apply:** when adding a record to any version-bearing file, READ the existing entries first and match the format exactly. When in doubt, check this table.

## History

Operator-corrected 2026-05-26 during digikoma-prove v0.0.0 → v0.1.0 re-forge across four rounds:
1. I regressed an existing long-form string to integer `1` when appending a new entry (this rule)
2. I started re-forging at `v1` instead of `v0` ([[feedback_digikoma-versions-start-at-zero]] rule 1)
3. I treated the long-form as a flat counter instead of `MMM_NNN_RRR` semver ([[feedback_digikoma-versions-start-at-zero]] rule 2)
4. I called the third triplet "build" instead of "revision" ([[feedback_digikoma-versions-start-at-zero]] terminology)

## Related

- [[feedback_digikoma-versions-start-at-zero]] — companion rule; semver structure + zero-indexed start + reset cascade + revision terminology
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — the broader digikoma vocabulary doctrine
- [[feedback_substrate-toolmaking-checklist]] — toolmaking discipline; this is a sub-discipline about staying within file conventions
- [[feedback_definitions-are-json-not-markdown]] — typed JSON is the source of truth; matching format conventions is part of that discipline
