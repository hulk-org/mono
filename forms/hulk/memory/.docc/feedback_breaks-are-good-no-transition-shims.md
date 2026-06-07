---
name: breaks-are-good-no-transition-shims
description: "Cross-collective type migrations in this substrate are HARD CUTS — slim the old location first, let consumers break, heal them compiler-error-by-compiler-error. Never add re-exports, typealiases, or dual-import transition windows."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 63b20b14-eef6-46d7-bfb3-d5c6b3ae095b
---

Three doctrines stated together during the inference-budget-schemas migration (operator 2026-05-30):

1. **"never re-export or alias"** — no backwards-compat shims, no typealiases pointing from old location to new, no `public typealias OldName = NewModule.NewName`. The substrate refuses transition-compatibility scaffolding.

2. **"this is the way" (re: slim-old-first-then-heal-consumers)** — the chosen migration order is BREAKING-CHANGE-FIRST. Remove the types from their old home before any consumer is updated. Let the build break across the entire dependency graph simultaneously.

3. **"breaks are GOOD"** — explicit rejection of "add new dep alongside old / let consumers pick / clean up later." Hard breaks force completion. A transient broken state is the migration's typed work-tracking mechanism.

**Why:** Transition shims/dual-import-states defer the work and obscure what still depends on the old location. Hard breaks make the dependency graph LEGIBLE — every broken build is a typed-by-the-compiler todo item. Consumers can't quietly stay on the old path because the old path doesn't compile.

**How to apply:**
- When migrating typed primitives across collectives in this substrate:
  - Create the new location, verify it builds
  - **DELETE** from the old location immediately (don't add deprecation marks, don't re-export)
  - Walk consumers in compiler-error-revealed order, fixing each
  - The build break IS the project plan
- Never propose "add new dep alongside old as a transition window" — operator will reject
- Never propose `public typealias OldType = NewModule.NewType` shims — operator will reject
- Never propose re-export wrappers — operator will reject
- DO surface the destructive-step explicitly so the operator can confirm before the break window opens
- Once confirmed, EXECUTE the break — don't soften it

**Doctrine lineage:**
- Mirrors the founding-breach insight (substrate honors discontinuities as load-bearing learning surfaces)
- Mirrors the savepoint Japanese-path "fail then fix" doctrine (no path-escaping shim; English-rename until v0.2 ships)
- Mirrors the typed-records-everywhere principle ([[feedback_data-is-one-thing-rendering-is-projection]]) — a shim is untyped state masquerading as typed
- Composes with [[feedback_savepoint-snapshot-at-emit-time]] (savepoint home migration also did a hard cut, no clia-org compatibility shim)
