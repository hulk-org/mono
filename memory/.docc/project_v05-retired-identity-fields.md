---
name: v0.5+ retirement map for legacy identity fields
description: When uplifting an agent identity from v0.3.0 to v0.5+, the dropped `notes`, `checklists`, and `sections` fields each have a defined v0.5+ home. Do not silently delete their content; route it.
type: project
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
When uplifting an agent identity.json from v0.3.0 → v0.5+ shape, three top-level fields disappear from the schema but their content has named v0.5+ destinations:

- **`notes`** → **Hobonichi Techo** records. The substrate's journal surface; the `wd` (winddown) skill appends JSONL entries there. Historical biographical/voice notes from v0.3.0 belong as techo entries, not in the live identity.
- **`checklists`** → **per-turn templates**. These were always meant to be instantiated AT TURN START, not stored as static identity. v0.5+ moves them into the turn-template surface (separate from identity.json) so they can vary by harness/operator/task without identity churn.
- **`sections`** → **personality / identity surfaces**. Bullet lists like "Context switch protocol" and "Maintainer" were already semi-structured personality content. They fold into the persona.agent.triad.md or directly into existing identity fields (`guardrails`, `responsibilities`) — the v0.5+ shape pushes structured-bullets-in-JSON toward typed-prose-in-markdown or canonical identity slots.

**Why:** Operator articulated 2026-05-22 while migrating the pollux→castor-google-assignment home from schemaVersion 0.3.0 to 0.5.0. The v0.5+ schema dropped these fields because their semantics belong in distinct substrate surfaces (techo, turn-templates, persona/identity), not in one polymorphic identity.json.

**How to apply:**
- When migrating any v0.3.0 identity to v0.5+, *route* content from these fields to their proper homes BEFORE dropping the fields. Don't delete content silently.
- For `notes`: write to techo via the `wd` skill, or hand-write a techo JSONL entry preserving author + date + content.
- For `checklists`: if the content is genuinely a per-turn template, capture it in the turn-template surface; if it's stale (just describes generic agent boot behavior that v0.5+ handles structurally), accept the drop.
- For `sections`: distribute by intent — guardrails-like content → `guardrails` field, role-description content → `responsibilities` or `roles` field, persona/style content → `persona.agent.triad.md`.
- This pattern applies to the 31 other roster-unbound homes (`--→1.0 ?` cohort) in the same v0.3.0 cohort.
