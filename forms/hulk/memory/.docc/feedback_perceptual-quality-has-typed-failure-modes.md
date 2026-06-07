---
name: perceptual-quality-has-typed-failure-modes
description: "When the operator observes a visual quality issue (bloom, max-out, low-contrast, hue indistinguishability), the substrate-typed answer is to NAME each failure mode as a typed enum case + ship a typed report that surfaces it. PaletteContrastReport in wrkstrm-color (2026-06-04) is the first canonical instance."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

When the operator names a perceptual quality complaint about a rendered
substrate surface — "blooming", "maxing out at 100", "low contrast", "looks
the same", "washes out" — the substrate-typed answer is NOT to subjectively
retune until it looks OK. It is:

1. **Decompose the complaint into named failure modes** — typically 3-5
   distinct conditions that each map to one observable metric.
2. **Author the typed report** in the owning primitive (here:
   `wrkstrm-color/PaletteContrastReport.swift`).
3. **Pair with a typed thresholds struct** so scenes with different tone
   curves can supply their own ceilings.
4. **Pair with a typed issues enum** so callers get strings to surface in
   UI / logs / tests, not raw numbers.
5. **Add a clock-swept variant** when the metric applies over time
   (`AutoColorPolicy.contrastReports(at:mode:target:)` here) — transitions
   can introduce failure modes that endpoint-checks miss.

**Operator's exact words (2026-06-04, after observing the Scene Lab
Swift+Metal preview):**
> the BLOOMING and maxing out at 100 on light colors though... that doesn't
> have enough contrast. how do we test for that?

The substrate's answer: **typed failure modes**, named once, surfaced
everywhere. First instance landed in
`wrkstrm-color/spm/Sources/WrkstrmColor/PaletteContrastReport.swift` —
four named failure modes:

- `insufficientSlotContrast` — W3C WCAG min between slot pairs < floor
- `flatLightnessSpread` — OKLCH lightness spread across slots < floor
- `saturationBlooming` — HSL saturation ceiling > ceiling
- `lightnessBlooming` — HSL lightness ceiling > ceiling

Sample findings from the first survey (substrate confirmed all 4 modes are
detectable + actionable):

```
lightPastel       ✗ FAIL → flat-lightness-spread, insufficient-slot-contrast
nerv              ✗ FAIL → insufficient-slot-contrast
monoFlatL         ✗ FAIL → flat-lightness-spread, insufficient-slot-contrast
saturatedCyber    ✗ FAIL → insufficient-slot-contrast, saturation-blooming

shuffle(glitch) clock sweep: 40/40 samples bloom-prone
spectrum sweep:              16/16 samples low-contrast
```

**How to apply going forward:**

- When operator names a visual quality complaint, default to the typed-
  failure-mode pattern rather than ad-hoc retune.
- When authoring a new substrate primitive that renders to screen, pair it
  with its own typed report of perceptual failure modes.
- Default thresholds are scene-tone-curve-dependent — ship a
  `<X>Thresholds.hdrToneMapped` static as the substrate-canonical preset,
  let callers override.
- Add the report's metrics as live UI indicators (Scene Lab next move) so
  the operator can SEE bloom warnings without running tests.

**Composes with:**

- [[constraints-belong-in-types-not-tests]] — Bjarne's C++ Concepts
  doctrine: this is the runtime-output analogue of the type-system
  discipline. Make the failure mode a typed value, not a vibes check.
- [[gates-points-scoring-zero-on-gate-fail]] — the contrast report's
  issues set IS the gate failure list for substrate's release-gate audience
  review of rendered surfaces.
- [[release-gate-audience-review]] — public web surfaces (clia.sh,
  rismay.me) using substrate-typed scene palettes should run
  `contrastReport()` as part of LaunchGate.uxwReviewPassed.

**Pending elaboration:**

1. Add JS sidecar parity for `PaletteContrastReport` so web emission arms
   can run the same check.
2. Wire live contrast indicator into Scene Lab UI (4 colored dots above the
   MTKView — green when issues empty, red+label when failing).
3. Promote to typed AxiomModel after 3rd instance lands.
