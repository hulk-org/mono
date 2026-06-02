---
name: feedback-check-substrate-before-claiming-out-of-scope
description: "Don't claim a capability is missing from the substrate based on one skill's scoping note — the substrate is wide enough that an \"out of scope\" line in one place usually means \"not in THIS surface\" not \"not anywhere\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a49b7129-8123-47ec-8e5e-da15541654ec
---

When I claim "the substrate doesn't have X" or "X is out of scope" I
must do a real cross-substrate scan first, not just read one skill's
scoping language and stop there.

**Specific failure 2026-05-26:** I claimed Amanda's voice donation
would need "a separate TTS provider workstream" and "a new
voice-donation-schemas family" because the OpenAI Audio `speech` skill
description says *"Custom voice creation is out of scope."* The
operator corrected: *"we have ghost audio creation already - so all we
need to do is let her donate voice samples in a collection."*

The substrate actually had:

- `ghost-shell-org/private/universal/plans/v1-voice-cloning/` — full
  Materialization Plan with five workstreams covering vendor delegation
  (Apple Personal Voice / ElevenLabs / smoke-voice), cast-packet vault,
  checkpoint receipts, variant slugs, multi-operator parity
- `schema-universal/.../schema-families/voice-schemas/v0.1.0/`
- `clia-org/private/universal/skills/audio/{speech, transcribe}/`
- `wrkstrm-components/private/common-voice-input/` +
  `common-voice-output/` (Swift packages)
- `maintainers/resemble-ai/.../chatterbox/` (open-source voice cloning)
- `maintainers/openclaw/.../skills/sherpa-onnx-tts/` +
  `voice-call/` + `extensions/talk-voice/`
- `collectives/wrkstrm/public/universal/spm/domain/voice/`

A 30-second `find -type d -iname "*voice*"` would have surfaced all of
these BEFORE I made the wrong claim.

**Why:** The substrate is large enough that scoping notes in one place
say what THAT surface excludes, not what the substrate excludes. Operator
trust degrades when I make confident statements about substrate-wide
absence based on local reads.

**How to apply:**

- Before saying "X is out of scope" or "the substrate doesn't have X" or
  "this would need a new Y," run a broad cross-substrate search first.
  At minimum: `grep -ril` + `find -type d -iname` across `private/universal/substrate/`.
- If a skill says "X is out of scope," read it as "out of scope for
  this skill," not "out of scope for the substrate."
- When I notice the substrate has more than I expected, update memory
  on the spot — that's the signal the substrate is wider than my model
  of it, and the next "out of scope" claim is even more dangerous.
- Composes with [[feedback_substrate-toolmaking-checklist]] — the right
  default in this kind of moment is "build the cross-substrate-search
  tool I keep needing," not "guess again."

Related substrate-mapping memories:
- [[user-clia-voice-imagined-as-amanda]] — the user-fact that surfaced
  this error
