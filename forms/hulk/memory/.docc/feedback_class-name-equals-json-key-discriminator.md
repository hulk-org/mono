---
name: class-name-equals-json-key-discriminator
description: "Every substrate typed shape (top-level records AND embedded refs) carries its Swift-class-name as a JSON key paired with its semver-string value as the discriminator. This makes consumers symmetrically grep-discoverable across Swift and JSON, replacing formal type registries."
metadata:
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

The substrate's discoverability discipline: **the Swift class name = the JSON discriminator key, and the version string is the value.**

Examples confirmed in-tree:
- Top-level record: `"IdentityModel": "0.5.0"` in `<agent>.identity.json` ↔ `IdentityModel` Swift type
- Embedded ref: `"IdentityRefModel": "0.1.0"` inside roles[] entries ↔ `IdentityRefModel` Swift type
- LinkRef wire format: `"LinkRefModel": "0.3.0"` ↔ `LinkRefModel` Swift type (already captured in [[linkref-v3-canonical-v4-research-only]])

**Why:** the operator explicitly named the doctrine after seeing that `Identity_Schemas v0.5.0` decodes `roles[]` as `[IdentityRefModel]` and noting "we should be able to search for these no? ... the name of the class = '0.1.0' key in json really works". Substrate doesn't have a formal type registry — it has this naming convention. The convention IS the registry.

**How to apply:**
1. When proposing a new typed shape (whether top-level record or embedded ref), the JSON discriminator key MUST be the exact Swift class name. The value MUST be the semver string of the family version that owns that class.
2. To find all consumers of a model line, use TWO symmetric greps:
   - `grep -rn 'ClassName' --include='*.swift' <scope>` → Swift symbol consumers
   - `grep -rn '"ClassName"' --include='*.json' <scope>` → JSON instance consumers
   These two greps together are the substrate's "find references" tool.
3. When proposing schema deletion / set membership changes, run both greps FIRST to count the blast radius. The discriminator field makes "how many consumers does this break?" a one-line answer.
4. If you ever see a typed shape without a class-name discriminator, that's the gap to fix — the pattern is the substrate's deprecation-tracking + migration-counting surface.

Related: [[linkref-v3-canonical-v4-research-only]] (LinkRefModel discriminator), [[schema-set-vs-family-vs-record-versioning-2026-05-23]] (the three independent versioning axes — this memory adds the discoverability axiom on top).
