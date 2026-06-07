---
name: typed-quality-failure-decomposition-workflow-landed
description: "Substrate workflow `typed-quality-failure-decomposition` v0.1.0 landed 2026-06-04 — 8-stage workflow for converting operator-named perceptual/UX quality complaints into typed substrate-canonical failure-mode catalogs with reports + thresholds + axiom-promotion-when-3x. Two instances dogfooded same session: PaletteContrastReport (palette-input) + RenderedFrameReport (renderer-output). Substrate-quality-failure-typist role first-bound to claude same day."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Typed substrate-canonical records landed 2026-06-04 (this memory = downstream POINTER per [[capture-requires-typed-workflows-and-roles-not-just-memory]]):**

- **Workflow:** `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/workflows/typed-quality-failure-decomposition/v0.1.0/typed-quality-failure-decomposition.workflow.json` — 8 stages, 2 instances recorded in `x-instances[]`.
- **Role:** `private/universal/substrate/roles/substrate-quality-failure-typist/private/universal/identity/substrate-quality-failure-typist.role-surface-manifest.json` — first binding claude 2026-06-04.

**The 8 workflow stages:**

| # | Stage | Output |
|---|---|---|
| 1 | operator-complaint-receipt | Verbatim operator quote captured |
| 2 | failure-mode-decomposition | Typed enum with 3-6 named cases |
| 3 | typed-report-authoring | Report struct + Thresholds preset + issues(against:) method |
| 4 | axis-cube-survey | Full Cartesian product survey + frequency breakdown |
| 5 | root-cause-localization | Named file+line or palette+slot evidence |
| 6 | upstream-fix | Patch at the root cause site (not workaround at consumer) |
| 7 | re-survey-confirmation | Before/after delta proving fix worked |
| 8 | axiom-promotion-if-3x | Typed AxiomModel at 3rd instance, else feedback memory |

**Two instances dogfooded this session:**

1. **PaletteContrastReport (palette-input)** — operator: *"the BLOOMING and maxing out at 100 on light colors though... that doesn't have enough contrast. how do we test for that?"* → 4 named failure modes (insufficientSlotContrast / flatLightnessSpread / saturationBlooming / lightnessBlooming) + .hdrToneMapped threshold preset. Survey: 56 combos, 2 PASS, 54 FAIL.

2. **RenderedFrameReport (renderer-output)** — operator: *"things are PURE WHITE or PURE black and whole parts of the screens look like that."* → 6 named failure modes (whiteBlowout / blackCrushing / insufficientTonalRange / washedOutNarrowBand / flatLuminanceVariance / hueWashout) + .hdrToneMapped preset. Survey: 14 combos, 10/14 hue-washout FAIL. Visual confirmation via offscreen PNGs paired with verdicts.

**The substrate-doctrine pattern this workflow enforces — "name the failure modes once, surface everywhere":**

- Enum cases are the substrate's stable typed vocabulary for the failure class
- Report struct carries raw metrics (re-computable, re-renderable)
- Thresholds preset is the substrate-canonical tuning for the consumer's pipeline
- issues(against:) returns Set<Issue> not Bool — discrete failures, not vibes
- Survey is axis-cube COMPLETE — every combo tested, not "a few examples"
- Root cause names a specific file+line or palette+slot — not vague
- Fix is at the root cause, not threshold-relaxation that masks the symptom

**Promotion path for the underlying axiom ("name failure modes once, surface everywhere"):**

- 1st instance — PaletteContrastReport (this session)
- 2nd instance — RenderedFrameReport (this session)
- 3rd instance — next time a substrate quality complaint surfaces (renderer / API / UI / audio / latency / etc.)
- AT 3RD INSTANCE — promote to typed AxiomModel per substrate 3x-rule

**Composes with:**

- [[capture-requires-typed-workflows-and-roles-not-just-memory]] — this memory IS the protocol's Step 4 output (downstream pointer)
- [[perceptual-quality-has-typed-failure-modes]] — feedback memory authored alongside, names the pattern
- [[ui-action-must-advance-state]] — sibling axiom landed same session; UI-layer analogue of typed-report failure-mode decomposition
- [[refinement-types-via-smart-constructor-not-copyable-not-discriminator]] — model-layer doctrine; this workflow PRODUCES refinement-typable proofs
- [[everything-is-quantum-state-machine]] — state-layer doctrine; PaletteState QHsm composes with these reports
- [[constraints-belong-in-types-not-tests]] — umbrella doctrine
- [[deferral-is-drift-do-it-now]] — axiom promotion at 3x must not be deferred
