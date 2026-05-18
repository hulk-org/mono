---
name: Pi organism on aspirational schema set
description: pi (and likely other harness organisms) fail the v0.9 swift-agent-cli doctor; they were authored against an unreleased schema cut
type: project
originSessionId: ea96a7fa-1582-42b0-9b52-c49cef9d4871
---
`harnesses/pi/private/universal/identity/pi@rismay.substrate.organism.json` does
not pass `swift-agent-cli v0.9 doctor` as of 2026-05-11. Three fields are
post-v0.9 / aspirational-v1.0 shapes:

- `composition: harness` — OrganismComposition enum is `{singular, collective}` in v0.9; pi's value is invalid.
- `schemaVersion: 0.2.0` (top-level) — v0.9 binds organism-schemas v0.4.0.
- `aspects.agent.doc.schemaVersion: 0.7.0` — v0.9 binds agent-schemas v0.2.0.

**Why:** Pi was clearly authored against the schema cut described in
`core-entities/.docc/v1.0.0/v1.0.0.md` (which references organism-schemas v0.5.0
+ agent-schemas v0.4.0 + ...). That cut is not shipping in swift-agent-cli yet
— the latest dispatched set in the CLI is v0.9. Pi sits in the gap between
"what the doc roadmap says" and "what the audit tool enforces."

**How to apply:** When auditing or cleaning up harness/agent organism files
across the substrate, expect pi and likely several other modern homes (dott,
eliza, mono — sv=0.7.0 in the earlier agent-folder audit) to fail the v0.9
doctor for the same reasons. Do not "fix" them by downgrading to v0.9 unless
the broader migration is intentional. The right closure is either (a) ship the
v1.0 schema set in swift-agent-cli, or (b) author an explicit migrator
(schema-universal/.../schema-migrators/) that down-projects to v0.9 fields.
