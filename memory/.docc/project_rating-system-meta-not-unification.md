---
name: Rating systems described by meta-schema, NOT collapsed into one
description: Each rating system (Presense, EGM Review, Engineering Review, Privacy Disclosure, Baseline Capability, …) stays its own schema; they are described uniformly via a rating-system meta-schema
type: project
originSessionId: e45c8d90-ebba-4176-9460-670eb736f881
---
The substrate has at least four verdict-shaped JSON schemas plus the
share-record (the subject side). Operator's directive 2026-05-14:
**do NOT collapse them into one shared schema.** Instead, build a
**rating-system meta-schema** that describes the SHAPE of any rating
system; each existing system stays its own thing as a declared
instance of the meta.

Three-tier ontology:

1. **Meta** — `rating-system.schema.json` (one schema describing what
   it means to BE a rating system)
2. **System** — declared instances of the Meta: `presense.system.json`,
   `egm-review.system.json`, `engineering-review.system.json`,
   `privacy-disclosure.system.json`, `baseline-capability.system.json`,
   future systems
3. **Instance** — concrete ratings under one system (a single Presense
   sidecar, a single EngineeringReviewReceipt, etc.)

The Meta declares twelve fields per system: id, displayName,
subjectKind, lifecycleStage (`pre-ship-gate`/`post-ship-overlay`/
`retroactive-review`), authority (`stop-authority`/`voice`),
rubricModel, scoreModel, verdictStateVocabulary,
attributionModel, historyPolicy, proseBodyShape, emitTrigger.

**Gates and ratings are different families.** Gates ask "can this
ship?" — pre-ship, stop authority, categorical. Ratings ask "how
good is what shipped?" — post-ship, voice, graded. Both expressible
under the same Meta but NEVER merged into one entity.

**Why:** Operator quote: "we have a whole bunch and we DO NOT want
to standardize them." Standardizing the rating data would erase
legitimate differences (Presense's 5 anchored axes, EGM's
score-only minimalism, eng-review's 22 categorical criteria).
Standardizing the *shape of describing them* preserves all of that
while letting one app render any of them. This is "one truth, many
lenses" applied at the rating-system layer.

**How to apply:** When proposing a new "thing-plus-verdict" surface,
do NOT propose a new sidecar schema in isolation. First describe it
as a rating system instance in the Meta. If the Meta can't express
it, the Meta has the wrong shape — fix the Meta, not the system.
Existing schemas (PresenseSidecar v0.1.0,
EngineeringReviewReceipt v0.1.0, etc.) stay as-is; the `*.system.json`
declarations describe them in the Meta language without forcing
migration. Full proposal:
`agents/carrie/memory/.docc/investigation.docc/rating-systems-meta-schema-2026-05-14.md`.
