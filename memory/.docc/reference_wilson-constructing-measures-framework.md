---
name: wilson-constructing-measures-framework
description: "Mark Wilson's *Constructing Measures* (2nd Ed.) — psychometric framework for measurement-instrument design. Four building blocks: construct map, items design, outcome space, measurement model. Substrate should refine designer-prior scoring (1/2/4/8) via Rasch calibration once data exists."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Mark Wilson — *Constructing Measures: An Item Response Modeling Approach*, 2nd Edition.** Operator-introduced 2026-05-30 in the substrate scoring-design discussion. Substrate-relevant psychometric framework for designing measurement instruments.

**Why this matters to the substrate:** the substrate has multiple scoring/measurement systems (`universal-schema-hygiene-cli` scoreboard, release-gate metrics, agent-quality dashboards, audit grades). Wilson's framework provides explicit methodology for designing these as proper psychometric instruments rather than ad-hoc weighted scoring.

## The four building blocks

| # | Block | What it is | Substrate-state |
|---|---|---|---|
| **1** | **Construct map** | Visual/conceptual ordering of the latent construct from low to high, with observable signs at each level. Defines WHAT you're trying to measure before designing items. | Not authored. Substrate has rule categories but no explicit "what does schema-family maturity LOOK LIKE from v0.0 to v1.0?" map. |
| **2** | **Items design** | Each item (rule/check) should DISCRIMINATE between respondents at different construct levels. Items everyone passes (or no one passes) are noise. | Partially done. 12 hygiene rules exist; discrimination not validated against the 40-family corpus. |
| **3** | **Outcome space** | Set of response categories for each item, ordered to match construct direction. Binary {pass, fail} is simplest; partial-credit (e.g., {none, partial, full, comprehensive}) adds discrimination. | Mostly binary today. Could grow partial-credit for high-leverage rules like `proof.canonical-fixture`. |
| **4** | **Measurement model** | Statistical model (Rasch / IRT) that estimates each item's DIFFICULTY and each respondent's ABILITY from observed responses. Replaces designer-assigned weights with empirically-calibrated ones. | Not used. Substrate uses designer-prior weights (1/2/4/8 per [[feedback_gates-points-scoring-zero-on-gate-fail]]). With 40 families × 12 rules = 480 data points, Rasch fit is feasible. |

## How Wilson's framework maps to substrate scoring

**Current substrate stance:** 1/2/4/8 weights are a DESIGNER PRIOR per [[feedback_gates-points-scoring-zero-on-gate-fail]]. This is honest psychometric language — Wilson would call it the "construct-referenced prior" the designer assigns before empirical calibration.

**Refinement path Wilson would recommend:**

1. **Author the construct map first** — sketch "schema-family-maturity" from low to high with observable signs at each level. Concrete examples of what a v0.0 stub looks like vs v0.5 partial-canonical vs v1.0 fully-canonical. This is the missing building block.

2. **Validate item discrimination** — run hygiene-cli over the 40-family corpus, capture pass/fail per rule. Rules at 0% or 100% pass-rate are noise (no discrimination). Wilson's framework excludes non-discriminating items.

3. **Consider partial-credit outcome spaces** for high-leverage items. `proof.canonical-fixture` → {none, basic, multiple, comprehensive} gives more discrimination per item than pure binary.

4. **Fit Rasch model** to the empirical data once construct map + discriminating items are in place. Item difficulties emerge from data; compare to 1/2/4/8 prior. Discrepancies = places where intuition is wrong about severity.

5. **Wright map** as standard output — items (calibrated by difficulty) vs persons (families calibrated by ability) on a single scale. Shows at a glance which families are advanced vs novice and which rules gate maturity transitions.

## Other Wilson principles that apply

| Principle | Application |
|---|---|
| **Construct-referenced scoring** — every reported score must reference its position on the construct map | "Family X at 47/58" should mean "production-ready, v1.0 candidate" — not just arithmetic sum |
| **Items as latent-trait indicators** — each item reveals the underlying construct, not just itself | Each hygiene rule is a window into substrate-canonical-ness, not just its own check |
| **Outcome ordering matters** — categories must be monotonically related to the construct | Pass should always be "more of the construct" than fail; partial-credit options should be ordered |
| **Person fit + item fit** — outliers in either direction merit investigation | A family that passes hard items but fails easy ones is suspicious; same for items unexpectedly missed by mature families |

## When NOT to apply Wilson's full framework

Wilson's psychometric framework is academically rigorous and meant for instrument-quality measurement (educational tests, attitude scales, health outcome measures). The substrate doesn't need to fully implement it for every scoring system. Use the framework when:

- A scoring system will be **reported externally** (auditors, investors, partners)
- The substrate has **enough corpus** to fit a measurement model (>30 respondents, >10 items typical minimum)
- **Calibration accuracy** matters (the score will be acted on, not just informational)

For lightweight internal scoring (e.g., per-session agent quality), Wilson's framework is overkill — a designer prior with 1/2/4/8 is sufficient.

## Operator's stance (2026-05-30)

> *"ok, he is waaaay too deep. so let's lock ours for now as a starting point."*

The operator authorized 1/2/4/8 as the designer prior for substrate hygiene **with explicit acknowledgment that Wilson's framework is the deeper refinement path** if/when the substrate decides to invest. The prior is honest as long as it's labeled "subject to Rasch refinement" rather than presented as final calibration.

## Cross-substrate measurement-design candidates

Beyond hygiene, the substrate has multiple measurement systems that could benefit from Wilson's framework:

- Agent commissioning maturity
- Audience-readiness scoring
- Addressing-protocol completeness
- Identity-package authoring quality
- Release-gate composite scoring
- Bead resolution-quality metrics

Each would benefit from drafting its construct map BEFORE designing measurement weights. Substrate-doctrine candidate: *"for any new measurement instrument, sketch the construct map first."*

## Related

- [[feedback_gates-points-scoring-zero-on-gate-fail]] — the scoring scheme Wilson would call a "designer prior subject to refinement"
- [[feedback_minimum-point-system-with-actionable-tiers]] — Wilson's framework formalizes the "actionable tiers" intuition via empirical difficulty estimation
- ideation thread `clia/memory/.docc/ideation/2026-05-30-gates-points-scoring-doctrine.md` — captures session discussion for future exploration
