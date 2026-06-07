---
name: tradition-preserves-fire-not-ashes
description: "Mahler aphorism that compresses the substrate's evolution discipline — schemas, identities, and primitives evolve by preserving what each shape was FOR, not by preserving its specific past expression as a relic."
metadata:
  node_type: memory
  type: insight
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

> Tradition is not the worship of ashes, but the preservation of fire.
> — Gustav Mahler

Operator quoted this at the end of the 2026-05-25 session that landed the
Hobonichi → 神事手帳 (Shinji Techo) brand pivot, NoteModel v0.3.0 → v0.4.0
typed-temporal-anchor refactor, and the substrate-wide GitHub push
restoration after weeks of remote-pause. The line compresses several
substrate doctrines into one sentence.

**The principle:** the substrate is not in the business of preserving
its own past shapes as relics — it's in the business of keeping what
each shape was FOR alive across evolution. The shape changes; the
purpose persists.

**Where it lands across existing substrate doctrine:**

- Hobonichi Techo → Shinji Techo (神事手帳): the cultural practice
  (every entry carries a quote line) was the fire. The Hobonichi brand
  was the ashes — the substrate dropped the brand collision but kept
  the practice as a typed `ShinjiQuoteModel` field.
- NoteModel v0.3.0 → v0.4.0: `timestamp: String?` was ashes — a
  string-stamp from before the substrate had typed temporal anchors.
  The job of the field (when did this note happen?) was the fire.
  v0.4.0 keeps the job and replaces the expression with
  `MomentAnchorRef` (LinkRefModel + MomentIndexRow).
- NoteBlockModel extraction: v0.2.0's local copy stays where it fell
  (preserved per `feedback_no-rewrite-history` posture — see
  [[feedback_use-bsl-clock-expired-versions]] for the broader
  no-rewrite pattern), while the SHAPE gets a proper home in
  `note-block-schemas v0.1.0` that v0.3.0+ can warm themselves at.
  The ashes stay; the fire moves.
- Harvest correction cohort (codex, clip, pollux, dott, mono): named
  persona bundles got reclassified from `agents/` to `roles/` or
  `harnesses/` not because the personas were wrong, but because their
  expression-as-agent was the ashes — what they were FOR (behavior
  contract vs. durable character) was the fire that needed a
  different home. See [[feedback_named-coherent-doesnt-mean-agent]].

**How to apply:**

- Before authoring a new version, ask: what does THIS shape do that
  the prior version did, and what does the prior version's expression
  fail to do? Evolve the expression; carry the job.
- Before deleting a primitive or moving content, ask: what would
  burn out if I removed this? If the answer is "the practice/job/
  purpose," preserve it elsewhere first. If the answer is "the
  specific expression and nothing else," the expression is ashes.
- Resist the urge to update past versions to look like the new shape.
  The past version's job was already done; the new version's job is
  to carry the fire forward into shapes the substrate can actually
  use today.
- Resist the urge to abandon the entire concept when a specific
  expression breaks. The brand collision (Hobonichi) didn't kill the
  practice (daily-quote-per-entry) — it just routed it through a
  rename.

**Companion principles already in memory:**

- [[feedback_class-name-equals-json-key-discriminator]] — every
  typed shape carries its own `ClassName: x.y.z` discriminator so
  consumers can route between past and present expressions without
  needing the producer to migrate them.
- [[feedback_named-coherent-doesnt-mean-agent]] — the
  promotion/demotion machinery for personas; "wrong home" is
  reversible, the persona content itself isn't ashes.
- [[feedback_no-rewrite-history]] — historical records keep their
  schema validity forever; the past is preserved-as-was, the future
  routes around it.
