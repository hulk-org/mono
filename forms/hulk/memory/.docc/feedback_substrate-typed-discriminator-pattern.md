---
name: substrate-typed-discriminator-pattern
description: "Substrate typed schemas use kind-tagged discriminator patterns (LinkRefModel v0.3.0 shape), not JSON Schema x-extensions. Future schema upgrades must follow the typed-discriminator wire convention."
metadata:
  node_type: memory
  type: feedback
  originSessionId: d6827382-74c6-4bcf-9c0f-eeaa9e6b51c2
---

When upgrading or extending a substrate typed schema (any `*-schemas` family under `schema-universal`), do NOT reach for JSON Schema `x-*` vendor extensions to add fields, and do NOT invent ad-hoc dictionary shapes. Use the LinkRefModel v0.3.0 typed-discriminator pattern instead.

**Why:** Operator pushback 2026-06-02 mid-brand-identity-schemas upgrade: "i think we should add discriminator patterns like in link ref 0.3 so we TYPE those things. and not x-extension like we have right now." The substrate's typed-everything investment expects every variant axis to be a first-class typed wire concept with a discriminator key, not an opaque escape hatch.

**How to apply:** The canonical reference is `link-ref-schemas/v0.3.0/json/link-ref-model.schema.json` + `sources/link-ref-model.swift` in schema-universal. Adopt these wire conventions for new typed shapes:

1. **Schema-version field on the wrapper:** `"<ModelName>": "<version>"` (e.g. `"LinkRefModel": "0.3.0"`). The version *is* the discriminator that selects the Swift Codable family.
2. **Short wire keys:** `t` (title), `d` (caption), `s` (slugs array), `tg` (targets array). Swift Codable expands to long names; JSON stays compact.
3. **Variant discriminator field `k`:** known values are short slugs (`u`, `rp`, `ap`, `vr`, `src`, `go`, `ss`, `cs`, etc.). Different `k` values activate different sibling field sets (e.g. `k=u` uses `v`; `k=vr` uses `v + vt + vr + sf + sv + sk + sp + st + jp + sh + fi`).
4. **Open variant set:** unknown `k` values must be allowed by the schema and preserved by the Swift consumer as "unknown target state". This is the substrate's forward-compatibility contract. Do not enumerate `k` values as a closed `enum:` in the schema.
5. **`additionalProperties: false` recursively:** every `$def` is closed. Only the `k` discriminator field is open at the value level.
6. **No `x-*` extensions:** anything that wants to be data must be a typed field with its own discriminator. If a field can carry multiple shapes, that's a discriminator-tagged sum type, not an `x-*` escape.

Composes with [[do-not-break-domain-driven-design]] (typed primitives stay in their bounded context), [[typed-primitive-bypass-3x-rule-confirmed]] (search→compose→confirm→author before inventing schema), and [[substrate-composes-typed-idea-molecules]] (typed records compose; `x-*` does not).
