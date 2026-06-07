---
name: Today app real customer is rismay, Pa is design language
description: The Today (clia-day) Pa lens is for rismay reading AI agent end-of-session summaries; Pa is the warmth voice, not a literal customer
type: user
---

The Today app (clia-day, bundle id `com.wrkstrm.ios.app.today`, ships locked
into the Pa lens via Info.plist `RDDefaultCollective: pa`) is **not** a
product for a literal 62-year-old reader. The real customer is **rismay
himself**, reading **end-of-session summaries written by AI agents** about
what they did for him that day.

**The "Pa" framing is design language, not customer identity:**
- Warm cream paper background, not a dashboard
- Serif typography, calm and considered, like a letter
- One hero card per day, no feeds
- Plain English, no commit logs or jargon
- "How's your day looking?" answered in the operator's own voice
- "Letter from your kid" tagline → really "letter from your AI agent"

**The producer is the AI itself.** Today's hardcoded `today-pa.json` is a
*placeholder* for what should eventually be an automated end-of-session
summary written by Claude / Codex / whichever agent ran the session.
Until automated, the agent should write a real summary into the JSON at
the end of each session before any TestFlight push. The manual-push V1
distribution model rismay chose is exactly right for this — every story
update is a deliberate "here is what I did, in your voice, for you to read
on your iPad" act.

**Why it was framed as Pa originally:** rismay introduced the project as
"an app for my dad so he can stay up on my work." That was a polite cover
for what is actually a more intimate request — a clean way for rismay to
see what his AI agents are doing, in language that feels human rather than
in dense build logs. The Pa framing made the design constraints concrete
(simple nav, big type, no jargon) without rismay having to say "I want my
AI agents to write me letters." The constraints are the same; the customer
is rismay.

**How to apply:**
- Do not rename `PaLens` / `PaStory` / `today-pa.json` / `seedPa` /
  `RDDefaultCollective: pa` without asking. The pa naming carries the
  warmth and rismay may want to keep it. Treat it as cosmetic warmth, not
  customer identity.
- When writing or generating story content for `today-pa.json`, write to
  rismay as the reader. Tell him what *we* (the agents) did today in his
  own voice — calm, plain, considered. Avoid the third-person "he is
  making the app gentler" framing unless rismay explicitly asks for it.
- A real, agent-written end-of-session summary in `today-pa.json` is the
  next product priority — more urgent than further shipping plumbing.
- Pa (the literal dad) may still become a real audience later, with a
  separate collective slug, but he is not the V1 customer. Do not assume
  any future feature work is Pa-driven without explicit confirmation.

**Why this memory exists:** rismay corrected this on 2026-04-08 after
multiple sessions of me building Pa-as-literal-customer. I had read every
warmth signal as a constraint on a real-person product when they were
actually constraints on the operator-AI reporting loop. This memory exists
so future-me does not have to be corrected again.
