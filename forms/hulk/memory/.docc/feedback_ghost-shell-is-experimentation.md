---
name: Ghost shell is experimentation not chat
description: ghost-shell.mac is an experimentation/observation layer for spawning and comparing ghosts — not a chat app; don't add prompt fields or chat UI
type: feedback
originSessionId: d053c5da-2b9f-4400-a3f6-4794d7099259
---
Ghost shell is an experimentation layer. It spawns ghosts, observes behavior, measures output, compares configurations. The three-column layout (shells / configs / runs) is correct for that purpose.

**Why:** I rewrote the working app into a chat-box (prompt field + answer) which is clia-ask, a completely different product. The existing architecture was right — it just needed v001 entries and the spawn bug fixed.

**How to apply:** When working on ghost-shell, evolve the existing experimentation UI. Add shell/config entries, fix spawn issues, add tool telemetry to run cards. Do NOT add prompt input fields, chat-style UX, or single-question-and-answer flows. That's clia-ask territory. Ghost shell observes and compares — it doesn't converse.
