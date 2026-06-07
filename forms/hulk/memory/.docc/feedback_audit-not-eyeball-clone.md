---
name: Audit, don't eyeball-clone organism files
description: When authoring CLIA identity/organism JSON, run swift-agent-cli doctor iteratively — do not copy fields from a sibling home like pi or mono
type: feedback
originSessionId: ea96a7fa-1582-42b0-9b52-c49cef9d4871
---
When authoring or normalizing a `*.organism.json` (or any CLIA core-entity artifact),
the canonical loop is:

1. Write the file (or stub it).
2. `swift-agent-cli doctor --slug <slug> --kind organism --path <home> --format text`
3. Fix one reported error at a time.
4. Repeat until `error-count: 0 / problems: none`.

Do NOT model the file by visual diff against a sibling organism (e.g. pi, mono).

**Why:** Sibling homes can be on a different schema-set generation than the one
the shipping doctor binds. Pi's organism has `composition: harness`, top-level
`schemaVersion: 0.2.0`, and `aspects.agent.doc.schemaVersion: 0.7.0` — three of
those are wrong under v0.9 doctor (valid composition is `{singular, collective}`,
v0.9 binds organism-schemas v0.4.0 + agent-schemas v0.2.0). Eyeball-cloning pi
propagates aspirational/post-v0.9 shapes into a file that the actual shipping
audit tool rejects. The 2026-05-11 digikoma harness commission caught this only
because we ran the doctor after the hand-roll.

**How to apply:** Every commission, migration, or hand-edit of organism / identity
/ agenda / chronicle JSON ends with a passing doctor run. If the doctor is
broken (build error), fix the doctor first — do not bypass it by claiming
"it matches pi." The doctor is the substrate's only durable schema enforcer.
