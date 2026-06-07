---
name: system-assistant-means-os-integrated-ai
description: "In the substrate, \"system assistant\" means OS-integrated AI (Gemini, Siri/Apple Foundation Models) — NOT shared internal infrastructure. ~2 in the substrate."
metadata:
  node_type: memory
  type: feedback
  originSessionId: cc7219dc-1f59-41e7-8a0b-8fde70593167
---

In the substrate's vocabulary, **"system assistant"** specifically means an OS-integrated AI persona — the kind of assistant the operating system itself ships and exposes to applications. Operator quote 2026-06-03 mid-rename cascade: "those are supposed to be harnesses please... system agents are like gemini or siri... only 2 in here."

The two system assistants in the substrate today:
- **gemini** — Google's system AI (Android, Pixel, Chrome integration)
- **apple-pi** — Apple's Foundation Models binding (Siri / Apple Intelligence; powering on-device system AI)

**NOT system assistants:**
- clide — CLIA's low-level daemon harness (substrate-internal runtime, NOT an OS-AI persona)
- digikoma — koma minting factory (substrate-internal infrastructure)
- loom, hulk, pi — runtime carriers, not OS-integrated personas

**Why:** I conflated "shared infrastructure with no single-assistant owner" (clide, digikoma) with "system assistant" during the 2026-06-03 agents→assistants rename cascade. Authored `assistant-form-binding.axiom.su.json` saying clide + digikoma should fold under `assistants/system/forms/<slug>/`. Wrong — those are harnesses, not system. The "system" category in the substrate is a *kind of assistant persona* (OS-integrated AI), not a *bucket for shared runtimes*.

**How to apply:**
- When categorizing a substrate persona, "system" means "this is an OS-integrated AI like Siri/Gemini" — reserve the word for that.
- Shared substrate-internal runtimes (daemons, factories, carriers) belong under `harnesses/` or another bucket — NEVER under `assistants/system/` unless they're literally OS-AI.
- The `harnesses/` folder is real and stays; not every harness becomes a form of some assistant. Some harnesses are just harnesses.
- The 2026-06-03 axiom needs correction: assistant-form-binding's "system meta-assistant" claim must be replaced with the OS-integrated-AI reading.

**Composes with:**
- [[assistant-form-binding axiom (needs correction)]] — substrate doctrine the rename authored; the "system" framing within it is wrong.
- [[do-not-break-domain-driven-design]] — each typed concept belongs to ONE bounded context; "system assistant" and "shared runtime" are different bounded contexts and shouldn't be conflated.
- Implies: not every harness needs a single-assistant owner; the rename's "every harness becomes a form" reading was too strict.
