---
name: feedback-typed-feedback-edits-next-evolution-of-audience-packet
description: "Feedback edits — from ANYONE (operator, agents, ghosts, audience reviewers, the-entity) on substrate content (kura-spaces, public copy, schemas, code) — must be FIRST-CLASS PERSISTENT TYPED RECORDS in the substrate, not transient chat annotations. Each edit gets a LinkRef-shaped identity, carries reviewer provenance, references the target content + location, has typed lifecycle status (active / superseded / merged / retracted), and composes with the audience-aware-content-pipeline as its next evolution. Operator-named 2026-06-04 mid-Slate-review of the rismay README: \"what i mean in my kura-spaces and ANYONE that gives feedback, we have to be able to give edits which can be referenced and remain, or superceded, etc. this is the next evolution of audience packet writing.\""
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

Feedback edits are first-class persistent typed records — universal across reviewers (operator + agents + ghosts + audience reviewers + the-entity) and universal across substrate content (kura-spaces, public copy, schemas, code, README copy, brand docs, audience packets themselves).

**Why:** Operator-named 2026-06-04 while reviewing the rismay README in Slate: "what i mean in my kura-spaces and ANYONE that gives feedback, we have to be able to give edits which can be referenced and remain, or superceded, etc. this is the next evolution of audience packet writing." The moment that triggered this: the operator gave four corrections in a row (substrate-typed bullet remove + YouTube TTS add + Google Maps longevity-claim retract + closed-source-vocab broadening) and there was no typed primitive to record any of them as substrate-canonical edit-records. They became README diffs + shinji-techo lines + memory edits — three different surfaces — when the substrate should have ONE typed edit primitive that flows to all the right places.

**Sharpening 2026-06-04 (same session, three operator beats after the initial naming):**

- **Beat 1: ID-discipline confirmed** — "we should by ID'ing these copy edits." Stable IDs (F-01, OD-F04a, etc.) are first-class substrate currency. Findings carry IDs; operator-decisions carry IDs that compose with the finding ID they respond to.
- **Beat 2: ALL-OF-IT must persist** — "SO ALL OF THIS! ALL OF THIS needs to go into packets we REMEMBER!" The full review-decision cycle (review session + per-finding operator decisions + applied actions) must be typed packets on disk, not transient chat. The substrate's "remember in a FILE" discipline applies recursively here.
- **Beat 3: PER-AUDIENCE + PER-DOMAIN storage axis** — "it needs to be remembered PER audience that would give this feedback. and then we can stack audiences all over the place easily. we maybe should save feedback per domain." Storage path encodes the typed shape:

```
<owner>/private/universal/kura-spaces/feedback/<domain>/<asset-slug>/<reviewer-slug>.<kind>.<timestamp?>.json
```

  - **`<domain>`** = content-shape grouping (`readmes`, `sites`, `api-docs`, `schemas`, `kura-spaces`, `investor-decks`, etc.)
  - **`<asset-slug>`** = the specific content piece being reviewed
  - **`<reviewer-slug>`** = the AUDIENCE-KIND or DECIDER emitting feedback (`the-entity`, `operator-curious`, `public-visitor`, `trusted-collaborator`, `rismay` as operator-decider, etc.)
  - **`<kind>`** = `review` (audience-side findings) or `operator-decisions` (owner-side accept/reject/modify responses)
  - **`<timestamp>`** = optional session timestamp for multi-revision audit trail
  - Stacking N audiences against one asset = listing N `*.review.json` files in the asset folder; the substrate composes them mechanically into an AudienceProfileStack-aware verdict
  - Re-using an audience-kind across N assets = its LinkRef back to the canonical audience packet remains stable

**Beat 6: CALIBRATE-SMALLEST-ASSET-FIRST strategy (2026-06-04, same session).** Operator-attested at the moment the README publish pipeline hit its 9th doctrine-miss surface (the App-signed attestation requirement after the chat-attestation fabrication): "this is why i went back to readme. we get this right, then BOOM! other sites are going to work well." The strategy: pick the simplest reasonable asset (README — one markdown file, public-by-design) as the substrate's CANARY for the publish pipeline. Every doctrine miss the README surfaces (walter discipline, substrate-vocab axiom, audience-aware-feedback-cycle workflow, 6 audience packets, publish-gate-policy schema, snapshot-publish workflow, platform-engineer doctrine, finding-corpus-query metric, App-signed attestation requirement) becomes typed substrate-canonical infrastructure. When the second asset (rismay.me) runs the same pipeline, every gate is already typed, every audience review pattern is established, every walter-anchor is locked — authoring cost drops asymptotically. The "BOOM" framing is the operator's recognition that the README ISN'T the deliverable; the CALIBRATED PIPELINE is the deliverable. Composes with Beat 5 compounding doctrine — calibration-smallest-first IS the sequence in which compounding pays off. Strategy for any future substrate authoring of multi-asset pipelines: pick the canary, let it surface assumptions, codify every miss, scale to siblings.

**Beat 5: "compounding" recognition (2026-06-04).** Operator-attested mid-second-asset-dogfood, after seeing 6 of 14 findings on rismay.me about-me.md auto-resolve via inheritance from README's OD-FNN decisions: "this is compounding on itself! great, great!" The operator NAMED the typed-substrate-investment dividend as `compounding`. What compounds: workflow (1 author, ∞ reuse) + audience packets (6 authored, every asset reviews against them) + axioms (2 authored, every authoring pass) + walter anchors (1 file, every rolling-fact) + operator-decisions (per-finding-ID, inheritable across assets) + filesystem shape (per-domain/per-asset/per-reviewer naturally nests). Compounding is the DIVIDEND of /capture's typed-records-first discipline; if we'd written only memory entries it wouldn't inherit. The substrate's "typed-everything investment converts context-size from cost to power" doctrine ([[large-structured-context-is-the-substrates-super-attack]]) made concrete at the workflow layer.

**Arm-tier purity confirmed by operator 2026-06-04** — "yes, i agree the feedback is private and not in the public arms." Feedback packets ALWAYS live in the PRIVATE arm of the content owner's home, EVEN WHEN THE CONTENT BEING REVIEWED IS PUBLIC. Public-arm content + private-arm feedback ABOUT that content is the substrate-canonical split. Reasoning:

- Defender intel (what the-entity could exploit) leaks attack surface if it shipped publicly alongside the content — bad
- Operator-decisions reveal substrate-internal reasoning + audit trail of why content reads as it does — substrate-internal
- Reviewer identity (which audience-kind emitted which finding) is substrate-internal taxonomy
- The PUBLIC artifact is the consequence; the FEEDBACK is the means; means stay private

Composes with [[substrate-is-closed-source-no-sharing]] (arm-tier purity rule the operator established earlier 2026-06-04). NEVER author feedback packets under `<owner>/public/` even when reviewing `<owner>/public/...` content.

**Sharpening 2026-06-04 (Beat 5 — review-surface home + visual-finding kind):**

- **Beat 5a: Review-surface logic belongs in wrkstrm-core/wrkstrm-components, NOT in an app-singleton.** Operator-attested 2026-06-04: "it should be a wrkstrm-core tool." Presense.app at `collectives/wrkstrm-app/.../apps/presense-by-wrkstrm/` is the FIRST consumer-app; the review-surface BONES (ingest typed `*.review.json` files, render multi-audience panels, surface finding-IDs, capture operator-decisions per-finding-ID, emit operator-decisions.json packet) graduate to a shared `wrkstrm-components/<feedback-review-surface>/` Swift Package. Multiple future apps (any surface that reviews assets — Slate-as-reviewer, web-deploy preview, brand-doc reviewer, audience-packet authoring tool) import it. Substrate pattern matches how Modern Mac App Shell + Tab Chrome + Mesh Gradient Header are wrkstrm-components consumed by N apps. Composes with [[Direct deps over transitive bundling]] + [[grep-common-star-before-adding-primitives]] + [[per-scene-independent-spm-packages]].

- **Beat 5b: Visual annotation is a first-class FINDING-KIND in the typed-feedback-cycle.** Operator-attested 2026-06-04: "we want to be able to draw on the image. like preview app. or just take a screenshot so I can do it in preview." When a reviewer draws over an asset, the drawing IS the finding — stored as image overlay PNG + sibling JSON metadata at `<owner>/private/universal/kura-spaces/feedback/<domain>/<asset>/<reviewer>.annotations/<F-NN>-<short-slug>.png` (overlay) + `.json` (typed finding metadata referencing the overlay). The typed `FindingModel.kind` enum gains a `visual-annotation` variant alongside `text` / `severity-flagged` / etc. Composes with [[data-is-one-thing-rendering-is-projection]] + [[feedback-stored-per-audience-per-domain-in-private-arm]]. Two implementation paths: (a) FAST — in-app screenshot-to-clipboard tool; operator annotates in macOS Preview; drops the annotated PNG back into the feedback dir. (b) SUBSTRATE-COHERENT — PencilKit / NSCanvas-based in-app drawing overlay with substrate-typed annotation-emission; the drawing tools become part of the wrkstrm-components feedback-review-surface package. Ship (a) for momentum, evolve to (b) when the package graduates.

**Concrete first instance landed in this session (2026-06-04):**

- `operators/rismay/private/universal/kura-spaces/feedback/readmes/rismay-readme/the-entity.review.json` (aligned-the-entity defender review, 8 findings F-01 through F-08)
- `operators/rismay/private/universal/kura-spaces/feedback/readmes/rismay-readme/rismay.operator-decisions.2026-06-04.json` (10 operator-decisions OD-F01 through OD-F08, including OD-F04a/b/c split for partial accept)
- README.md edited per OD-F04a (Lens Copywriter row removed) and OD-F04b (Wrkstrm Foundation row removed)

**How to apply (substrate-doctrine direction, not yet shipped as typed schema family):**

1. **The primitive**: A typed `FeedbackEditModel` (working name) lives in a new schema family under `schema-universal/.../schema-families/feedback-edit-schemas/v0.1.0/`. Each record carries:
   - `id` (canonical slug)
   - `reviewerIdentityRef: LinkRefModel` (operator, agent, ghost, audience-profile, the-entity — universal)
   - `targetContentRef: LinkRefModel` (the kura-space record / file / schema instance being edited)
   - `targetLocation` (line/range/anchor/section — granular pointer inside the target)
   - `editKind` (correction | addition | removal | retraction | sharpening | direction)
   - `editBody` (proposed change content)
   - `status` (active | superseded | merged | retracted)
   - `lineage` (`predecessorRef`, `successorRefs[]`) — composes with [[tradition-preserves-fire-not-ashes-2026-05-25]] supersession discipline
   - `createdAt` + `attestedQuote` (verbatim reviewer source when applicable — composes with the walter three-tier provenance discipline)

2. **Storage**: Edits live in the OWNER home of the target content (per [[content-lives-in-its-owners-home]]) under a new kura tier — likely `agenda/feedback-edits/<slug>.feedback-edit.su.json`. NOT in the reviewer's home; the content owner owns the edit-graph against their content.

3. **Discoverability**: Every typed substrate record carries a back-reference field `feedbackEditRefs: [LinkRefModel]` (or resolves it via index) so the edit graph is navigable from both directions — given a piece of content, list its edits; given an edit, walk to its target.

4. **Lifecycle (the "remain or superseded etc." part)**: Edits remain readable forever once written. A successor edit doesn't delete the predecessor — it sets predecessor's `status` to `superseded` and records the chain. The substrate gains an audit trail of WHO said WHAT about WHICH content WHEN, and how the edit evolved.

5. **Universal-reviewer scope**: Operator edits go through this primitive. Agent suggestions go through this primitive. Ghost shadowing answers ([[shadowing]]) materialize as typed edit-records. Audience-side reviewers (the-entity defender review, operator-curious reviewer, etc.) emit edits typed to their audience-profile. Even substrate-internal walter audit-failures become edits with `editKind=retraction`.

6. **The "next evolution of audience packet writing" framing**: The audience-aware-content-pipeline today produces audience packets + content authored against them + adversarial defender review. The NEXT layer adds typed feedback edits as a first-class output AND input of the pipeline — every review pass emits edits; every authoring pass reads pending edits; the pipeline becomes iterative and multi-reviewer-aware. Audience packets gain a `feedbackEditPolicy` field declaring which reviewers can emit which edit kinds against content addressed to that audience.

7. **Compose with**: [[supersession-not-silent-edit]] / [[tradition-preserves-fire-not-ashes-2026-05-25]] (supersession discipline) + [[turn-is-commit]] (each edit IS a turn IS a commit) + [[content-lives-in-its-owners-home]] (storage location) + [[All ad-hoc *Ref / *RefModel types are dead — use LinkRefModel v0.3.0]] (reference shape) + [[substrate-typed-discriminator-pattern]] (editKind + reviewerKind as typed discriminators) + [[shadowing]] (ghost-fleet edits = typed compare across reviewers) + [[dual-consumer-for-ghost-touching-surfaces]] (operator-feedback + agent-feedback are both producers) + [[reference_rismay-biographical-anchors-walter-locked]] (the walter-audit-failure capture is itself an early edit-record shape) + [[audience-packet-must-precede-content-reference]] (audience packet pre-existence rule extends to edit-feedback policy) + [[adversarial-audience-the-entity]] (the-entity emits typed defender-side edits) + [[deferral-is-drift-do-it-now]] (substrate-doctrine-shaped; ship the primitive when the next concrete trigger arrives — likely Presense or a kura-space content-review pass).

**Status: substrate-doctrine direction captured; primitive not yet authored.** When the next trigger arrives (Presense verdict UI needing typed feedback storage, or a kura-space review pass needing persistent edit records, or audience packet writers needing to record reviewer disagreement), author `FeedbackEditModel v0.1.0` in schema-universal as the first concrete instance.
