---
name: openclaw is compat surface, not our identity
description: harnesses/openclaw/ is the OpenAI-side upstream we stay compatible with; our carrier identity belongs in a different home
type: project
---

`harnesses/openclaw/` is the OpenAI-side upstream organism. We are *openclaw
compatible* — we host and mirror its layout — but our own carrier identity
should not be authored inside `harnesses/openclaw/{IDENTITY,SOUL,USER}.md`.

**Why:** treating openclaw as both the upstream we track AND the home of our
carrier doctrine collapses two things rismay wants kept separate. The
upstream evolves on its own schedule; our carrier identity needs a stable
home that isn't rewritten every time we sync openclaw. Contrast hulk, where
`harnesses/hulk/` *is* the canonical carrier home because hulk is ours.

**How to apply:**
- Persona content (Claw etc.) staying under `harnesses/openclaw/agents/<slug>/`
  is fine — that's compat layout.
- Uppercased harness files such as `IDENTITY.md`, `SOUL.md`, and `USER.md` are
  OpenClaw-facing compatibility/orientation surfaces. Do not treat them as the
  canonical substrate identity source.
- Our operational identity source is the active 0.8.0 identity spec surface:
  `*.identity.json` and its paired agenda/chronicle documents in the
  commissioned home.
- Do NOT write our carrier doctrine into top-level `harnesses/openclaw/`
  files. Ask where the openclaw-side carrier identity should live before
  reshaping (likely a sibling under `harnesses/` or nested under `hulk/`).
- The 2026-04-09 rewrite of `harnesses/openclaw/{IDENTITY,SOUL,USER}.md` is
  the cautionary example — it framed openclaw itself as our carrier, which
  is the conflation to undo.
