---
name: credit-our-creators-even-in-closed-source
description: "When the substrate ports external creative work (CodePen pens, demo sites, shaders, sketches), the original creator is \"our creator\" and must be credited prominently — attribution survives the closed-source constraint"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

When the substrate ports external creative work, the original author is
explicitly framed as **"our creator"** and must be credited.

**Operator's exact words (2026-06-04, after seeing the captured
sabosugi/OPbXXoN snapshot land with its MIT copyright notice intact):**
> ooo and yes we should credit Sabo Sugi! our creators YES!

**What this means in practice:**

- **Attribution is not the same as public-sharing.** Per
  [[substrate-is-closed-source-no-sharing]] the substrate stays closed.
  But the closed-source surfaces STILL credit creators — internal
  showcase routes, internal scene-detail panes, internal app credits
  screens, in-app "about this scene" UI, internal documentation. The
  creator's name + verbatim copyright/license notice + canonical URL
  must be visible wherever a substrate operator can see the
  substrate-native rendering of their work.
- **The internal showcase IS a credits surface.** What I authored as a
  "public showcase route" should pivot conceptually into an internal
  "our creators" credit wall. Same substrate-typed data, different
  framing — operator-facing tribute to the creators whose work the
  substrate has ported.
- **The static-contract attribution test stays load-bearing.** The
  existing pattern of `StaticContractTests.swift` asserting
  `codepen.io/<author>/<id>` in the rendered hero applies internally too
  — every substrate surface showing a ported scene must include the
  attribution, enforced at the build's test gate.
- **Verbatim license notice when present.** Sabo Sugi's HTML contained
  a full MIT copyright notice. That notice itself, not just a paraphrase,
  must be surfaced (so the substrate honors the actual legal grant text,
  not a summary).

**What this rules out:**

- Stripping attribution because the surface is closed-source.
- Replacing the creator's name with substrate-internal slugs.
- Treating attribution as optional metadata; it's a required field on
  every typed scene record.

**How to apply going forward:**

1. The `CodePenSourcePacketModel.author` + `permalink` fields are
   load-bearing — they drive every internal credits surface.
2. The `the-entity.audience.su.json` `mustSee` list explicitly requires
   "Original pen attribution (codepen.io/<author>/<id>) verbatim" — keep
   this even on closed-source surfaces.
3. When a creator publishes an explicit license (MIT-style for Sabo
   Sugi, CC0 / BY-SA / etc. for others), preserve the literal license
   text alongside the attribution in the typed packet AND in the
   rendered credit surface.
4. Track creators across multiple ported scenes — when the substrate
   ports a second pen from the same author, the internal credits
   surface should aggregate by author.

**Cross-references:**

- [[substrate-is-closed-source-no-sharing]] — closed-source posture this
  attribution doctrine operates alongside.
- [[adversarial-audience-the-entity]] — defender's `mustSee` list
  includes creator attribution; this is consistent.
- [[brand-docs-must-reflect-rendered-site]] — internal brand docs must
  also reflect creator attribution.
- [[content-lives-in-its-owners-home]] — the substrate is the home for
  the rendering; the creator is the home for the source — both lineages
  matter.
