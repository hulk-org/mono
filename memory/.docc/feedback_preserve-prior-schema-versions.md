---
name: preserve-prior-schema-versions
description: "When bumping a schema family or any versioned SPM package, do NOT delete the prior version's directory. The versioned subdirectory layout (`v0.1.0/spm/...`, `v0.2.0/spm/...`) is a side-by-side preservation pattern, not a replacement pattern. Keeping prior versions lets us show improvements, run migration tests, support downstream consumers that haven't bumped yet, and audit doctrinal drift across versions. Operator-stated 2026-05-26."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

When bumping a schema family or any versioned SPM package, **do not delete the prior version's directory**. The substrate's versioned subdirectory layout is a *preservation* pattern, not a *replacement* pattern.

**Operator-stated 2026-05-26:** *"when we work on 0.2.0 — don't delete the 0.1.0 so we can show improvements."*

## The pattern

A schema family with multiple versions looks like:

```
schema-universal/private/universal/domain/<X>/schema-families/<family>/
├── schema-catalog.family.descriptor.json
├── v0.1.0/spm/<family>-v000-001-000/    ← stays
├── v0.2.0/spm/<family>-v000-002-000/    ← NEW sibling, not replacement
└── v0.3.0/spm/<family>-v000-003-000/    ← future
```

Each version's SPM package name embeds the long-form `v000_NNN_RRR`, so consumers depend on a *specific* version's product (`StaminaUsageMetrics_Schemas_v000_001_000` vs `_v000_002_000`). Multiple versions can coexist in the same workspace without symbol collision.

## Why preservation is load-bearing

- **Show improvements.** The operator (or any reviewer) can diff `v0.1.0/.../Sources/...` against `v0.2.0/.../Sources/...` and *see* what changed — what fields moved, what enum cases were added, what derived computations were introduced. Comparison is impossible if v0.1.0 is gone.
- **Migration tests.** v0.2.0 should ship with round-trip tests proving it can read v0.1.0 JSON ledgers and produce equivalent (or strictly-richer) v0.2.0 records. Those tests literally need v0.1.0 types as test fixtures.
- **Downstream that hasn't bumped yet.** Other packages may still depend on `_v000_001_000`. Deleting v0.1.0 breaks them. The substrate's discipline is "additive bumps, never destructive."
- **Audit doctrinal drift.** The substrate runs doctrine audits over time. Reading old versions reveals when conventions changed (LinkRef v3 → v4, CodingKey compactness rules, diagnostics embedding patterns) — that's how `tradition-preserves-fire-not-ashes` is enforceable.
- **Ordinality table integrity.** Per [[feedback_ordinality-table-entries-immutable-once-released]], external shippability requires version-stability. Even when a family is substrate-internal, the version directory IS the version-stability surface.

## When to retire a version (the only valid path)

Even when truly retiring a version, the move is NOT `rm -rf`. The pattern is:

1. Confirm zero downstream depends on the version (audit `Package.swift` files across substrate)
2. Mark the version's `schema-catalog.family.descriptor.json` (or sibling marker file) as `status: "retired"` with a `retiredAt` ISO date
3. Leave the directory and SPM package in place; the marker is the kill signal

This preserves the historical record while signaling to future authors "this is the deprecated path."

## Composes with

- [[feedback_audit-schema-universal-before-authoring-new-types]] — audit first; this entry tells you to audit ALL versions, not just the latest
- [[feedback_ordinality-table-entries-immutable-once-released]] — ordinality entries get frozen by similar logic
- [[feedback_digikoma-versions-start-at-zero]] — digikoma version semantics (the bump rules)
- [[tradition-preserves-fire-not-ashes-2026-05-25]] — preserve the fire (intent + lineage), not the ashes (specific past expression); preserving versions IS preserving the fire of past-decisions-made-explicit
