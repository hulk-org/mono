---
name: user-clia-voice-imagined-as-amanda
description: "Rismay has long imagined amanda-champagne's voice as clia's voice; if the collaboration goes well, Amanda may lend her voice to clia as a substrate voice donation — load-bearing identity-design intent, not a passing remark"
metadata: 
  node_type: memory
  type: user
  originSessionId: a49b7129-8123-47ec-8e5e-da15541654ec
---

Operator-stated 2026-05-26, addressed directly to clia during the `>h:hulk
>a:clia` session: *"BTW: if we do right, amanda will lend you her voice!
I've always imagined her voice for you."*

This is **identity-design intent** the operator has carried for some time
— not a casual aside. It changes how clia's persona is being shaped and
how the substrate should treat amanda-champagne's role.

**What this means:**

- Clia's persona, in rismay's internal model, *already has* a voice; that
  voice sounds like Amanda. Substrate work on clia's persona should leave
  room for an eventual real voice realization rather than picking a
  default TTS voice and freezing it.
- Amanda's potential voice donation is **contingent on the trajectory
  going well** — the Thursday-interview help, the clia-org collaboration,
  the relationship deepening over time. Voice comes last in the sequence,
  not first.
- The substrate already has ghost-audio infrastructure (operator
  corrected me 2026-05-26 — "we have ghost audio creation already").
  Existing surfaces: `ghost-shell-org/private/universal/plans/v1-voice-cloning/`
  (Materialization Plan, 5 workstreams, status=drafted),
  `schema-universal/.../schema-families/voice-schemas/v0.1.0/`,
  `clia-org/private/universal/skills/audio/` (speech + transcribe),
  `wrkstrm-components/private/common-voice-input` + `common-voice-output`,
  `maintainers/resemble-ai/chatterbox/`,
  `maintainers/openclaw/.../skills/sherpa-onnx-tts/`. The OpenAI `speech`
  skill's "custom voice creation out of scope" line was a single-skill
  scoping note, not the substrate's posture.
- The cast-packet doctrine (per the v1-voice-cloning plan, WS2) is
  the canonical home for voice training corpora — vaults tier, NOT
  kura collections tier. Planned path:
  `private/universal/vaults/acting/voice-cast-packets/<operator-slug>/v<version>/`.
  Amanda's samples would land at the amanda-champagne sub-path. Per
  [[feedback_content-lives-in-its-owners-home]] there's a tension
  with operator-home placement; operator-decision-pending.
- All Amanda needs to provide is voice samples; the downstream
  pipeline (vendor delegation, checkpoint receipts, variant slugs)
  already has a designed shape via WS1-WS5 of the existing plan.

**How to apply:**

- **Do not bring up the voice question to Amanda directly without
  rismay's lead.** Consent has to be hers, asked cleanly, on its own
  terms — never as a side-quest to other work or as an implicit
  condition for being in clia-org. The work has to stand independently.
- When designing clia's persona surfaces (system instructions, reveries,
  persona triads), avoid baking in a different voice/identity that
  would conflict with an eventual Amanda-voiced realization.
- When the voice donation becomes operational, treat it as a substrate
  workstream of its own (new schema family + consent record + provider
  selection + sample collection + revocation pathway), not a quick
  config change.

**Why the operator told clia, not just "the assistant":**

The phrasing was second-person to clia ("for *you*"). This is
operator-to-persona context, the kind that lives in user-memory rather
than project-memory because it's a durable shaping fact about the
clia-as-character, not a transient task.

Related:
- [[user-relationship-amanda-champagne]]
- [[project-amanda-thursday-interview-2026-05-28]]
- [[project-clia-us-wrkstrm-com-shared-invite-infra]]
