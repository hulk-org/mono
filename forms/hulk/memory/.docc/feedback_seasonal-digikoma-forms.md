---
name: seasonal-digikoma-forms
description: "Substrate doctrine — digikomas can have FORMS (mirroring form-of-agent pattern), and a form can be HOLIDAY/SEASONALLY THEMED. The first themed form is `digikoma-build-clean/forms/purge/` (Halloween 2026), an irreversible-cleansing variant of the measured `digikoma-build-clean`."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 80d30d4d-f88b-458d-977f-2015247c8a52
---

**Two substrate claims established 2026-05-26:**

1. **Form-of-digikoma is a real pattern** — mirroring [[feedback_codex-is-a-form-of-chatgpt]] (form-of-agent). A digikoma can host forms under `<digikoma>/forms/<form-slug>/` with the form's own `persona.md`, `spec.json`, and typed identity bundle. Shared walker/logic from the parent's `sources/`; form-specific defaults baked into the form's `spec.json`.
2. **Themed/seasonal forms are doctrinal**, not just aesthetic decoration. The substrate VALUES personality (composes with the playful naming pattern: hulk carrier, `.sd` sleeping daemons, ghost-shells, the-entity, savepointd). A seasonal form is a substrate-first-class thing — it lives in the codebase year-round but its theme codes when it's most relevant.

**Why:** Operator-stated 2026-05-26 — "1. yeah. so we can do special holiday digikomas! this is like our first holloween one." The framing flips PURGE from "we should make this a digikoma" → "this is the form-of-digikoma pattern's first instance + the substrate's first seasonal-themed form."

**The first themed form (Halloween 2026):**

| Field | Value |
|---|---|
| Parent digikoma | `digikoma-build-clean` |
| Form slug | `purge` |
| Form home | `digikoma-build-clean/forms/purge/` |
| Theme | Halloween (irreversible cleansing — Imperium-of-Man/Warhammer-40K coded, fits substrate's existing dark-playful aesthetic) |
| Parent semantics | Trash matched dirs to `~/.Trash/digikoma-build-clean-<ISO-date>/` (recoverable for ~30 days) |
| Form semantics | Hard-delete matched dirs (irreversible, bytes freed immediately) — safety floor: `dryRun: true` DEFAULT + `confirmIrreversible: true` REQUIRED for live mode |
| Form receipt type | `DigikomaPurgeResult` (sibling to parent's `DigikomaBuildCleanResult`); includes `auditTrailPath` (JSONL of what was eaten) |

## How to apply

- **When a substrate task involves a measured-vs-eradicate semantic split**, reach for the form pattern: parent owns the measured action, form owns the eradicate action.
- **When proposing a "branded" or "funny" variant of an existing digikoma**, default to the form-of-digikoma pattern — it's the doctrinal answer, not a sticker. The form gets its own typed identity bundle, not just a persona.md rewrite.
- **Holiday/seasonal forms are not a special-case** — they're regular forms with a thematic persona. They DON'T need an "activation window" or "season field" (overengineering); they exist year-round; the theme just tells you WHEN they're most relevant.
- **Future themed form candidates (Halloween)**: `digikoma-grave-digger` (excavate ancient archived sessions/logs), `digikoma-haunting` (find references to deleted/retired surfaces), `digikoma-banishment` (purge a slug from all roster/index files), `digikoma-shroud` (compress-and-encrypt before delete), `digikoma-crypt-keeper` (rotate-and-archive). Don't build these now — establish the pattern with PURGE first.
- **Other themes that fit the substrate aesthetic**: Christmas (`digikoma-gift` for moving artifacts to share-with-team; `digikoma-stocking-stuffer` for batched small commits); Valentine's (`digikoma-courtship` for pairing/handshake setup between agents); New Year (`digikoma-resolution` for goal-cycle reset). Speculative — the operator may want to keep this Halloween-only for now.

## Composes with

- [[feedback_codex-is-a-form-of-chatgpt]] — the parent form-of pattern (agents). Digikoma forms work the same way.
- [[feedback_digikoma-build-clean-exists]] — the parent digikoma being formed.
- [[feedback_substrate-cost-circle]] — themed receipts feed the same ledger as their parent's; PURGE's audit trail is a cost-circle artifact.
- [[feedback_substrate-dotted-form-factor-vocabulary]] — `purge` is a FORM (persona variant), not a form-factor (runtime shape like `.cli`/`.sd`). Don't confuse the two.
