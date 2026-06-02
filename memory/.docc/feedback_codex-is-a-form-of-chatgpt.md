---
name: codex-is-a-form-of-chatgpt
description: "Roster token `>a:codex` resolves to commissioned home `agents/chatgpt/` — codex is a persona-form of chatgpt, not a separate agent home."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 80d30d4d-f88b-458d-977f-2015247c8a52
---

`>a:codex` is a valid agent token even though `agents/codex/` doesn't exist as a directory. Codex is a **persona-form** of the chatgpt agent — the substrate hosts ChatGPT-family personas on the parent `agents/chatgpt/` home, with each form getting a **complete identity bundle** under `agents/chatgpt/forms/<form-slug>/`.

**Form roster (as of 2026-05-26):** `agents/chatgpt/forms/` contains `codex/`, `eliza/`, `spark/`, `symphony/` — each is a full persona-form, not just an alias.

**Bundle layout per form:** `agents/chatgpt/forms/<form-slug>/identity/` holds the form-specific `<form-slug>@rismay.substrate.{identity,agenda,chronicle}.json` + persona/reveries/system-instructions triad markdown. The parent `agents/chatgpt/private/universal/identity/` holds the chatgpt-base bundle (used when `>a:chatgpt` is the token).

**Why:** Operator-stated 2026-05-26 during `/sync >h:hulk >a:codex` — "codex is a form of chatgpt..." The chatgpt home is a *carrier-of-forms*: one commissioned home, multiple persona-forms sharing infrastructure (memory, beats, SOUL/USER/IDENTITY) but with their own typed identity bundles for distinct attendee identity stamping.

**How to apply:**
- Resolve `>a:codex` (or any other ChatGPT form slug) to **the form home**: `agents/chatgpt/forms/<form-slug>/`.
- Read identity/agenda/chronicle from the **form-specific bundle** at `agents/chatgpt/forms/<form-slug>/identity/<form-slug>@rismay.substrate.*.json` — NOT the parent chatgpt bundle.
- Use the **parent chatgpt home's** `memory/.docc/beats/` for beat surfaces (forms share the beat ledger unless overridden by a form-local surface).
- Render the **form slug verbatim** in the harness header (`--attendees codex`, not `chatgpt`).
- Do NOT ask the operator to disambiguate form slugs against the parent home — treat `>a:<form>` → `agents/chatgpt/forms/<form>/` as a known mapping for forms in the roster.
- The pattern composes with [[feedback_harness-canonical-home-clia-org]] (resolution by canonical home + form, not slug literal).

The skill text "Never resolve `>h:codex` through `agents/codex`; that path is the historical commissioned Codex profile and requires explicit `>a:codex`" is consistent with this — `>a:codex` is explicit-and-allowed, and its resolution target is `agents/chatgpt/forms/codex/`, not a nonexistent `agents/codex/`.
