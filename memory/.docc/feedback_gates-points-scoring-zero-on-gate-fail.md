---
name: gates-points-scoring-zero-on-gate-fail
description: "Substrate scoring doctrine: gates+points hybrid where gates are binary AND zero out the entire score if failed. 1/2/4/8 doubling weights. School-grade F-vs-gradient model. Cures the polish-without-substance failure mode."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Substrate scoring doctrine: gates+points hybrid with zero-on-gate-fail.** Operator-stated 2026-05-30 across multiple turns:

> *"It's like what schools use: F - Fail and then a gradient of passing. So yeah if something has all the small things which look good, but don't work fundamentally: FFFFFF."*

> *"Cool javascript page: ooooo, WHO GIVES A FUCK! the thing doesn't work!"*

> *"if the structural lock is not passed: the score is 0... not the sum of the things that come above it."*

**The doctrine in one rule:**

If ANY gate fails, the entire score is **literally 0**. Quality + consumer-trust + important points do NOT accumulate. The arithmetic itself enforces the doctrine — you can't have a non-zero "this is mostly fine" score when a structural gate fails.

```
fn score(gates_passed: Bool, quality_pts: Int, c_trust_pts: Int, important_pts: Int) -> Int:
  if not gates_passed: return 0   // ← zero, not "F with partial credit"
  return important_pts + c_trust_pts + quality_pts
```

**Weighting: 1/2/4/8 (4 tiers, full doubling)**

| Tier | Weight | Question it answers | Failure mode if broken |
|---|---:|---|---|
| **Quality** | 1 | "Could be tightened?" | cosmetic |
| **Consumer-trust** | 2 | "Do downstream consumers notice this is gappy?" | UX / discovery gap |
| **Important** | 4 | "Is this production-readiness?" | not-shippable-yet |
| **Gate (structural)** | 8 | "Are downstream consumers broken?" | **categorically different** |

Per Wilson's [[reference_wilson-constructing-measures-framework]], these are a designer-assigned PRIOR; long-term they should be empirically calibrated via Rasch when enough data exists.

**Why doubling and not Fibonacci:**

- Fibonacci (1/2/3/5/8/13) communicates "uncertainty grows non-linearly" — appropriate for story-point ESTIMATION
- Doubling (1/2/4/8) communicates "deliberate categorical separation" — appropriate for typed-and-bounded severity tiers
- Substrate hygiene has known, bounded severity per rule → doubling is the honest encoding
- 4 tiers maps to cognitive psychology's working-memory sweet spot (Cowan 2001 magical number 4)

**Why the 2→4 and 4→8 jumps are RIGHT (not 2→3 or 4→6):**

Recovery-cost asymmetry. A structural break requires *rebuilding* (days, with collateral); a quality miss requires *additive work* (minutes-hours). The cost curve is closer to 1-2-4-8 than 1-2-3-4. Doubling captures the multiplicative growth in remediation cost as severity increases.

**Display contract — F-vs-gradient:**

```
Gate failed:    FAIL ✗  →  SCORE = 0  +  list of failed gates by name
Gates passed:   PASS ✓  →  SCORE = 47/58 = 81% = B+  +  per-tier breakdown
```

Never hide gate failures behind quality polish. Lead with gate state in every reporting surface. This is the cure for the "Cool javascript page" anti-pattern — observers who only see polish miss structural failure.

**How to apply:**

1. **Any substrate scoring system** (hygiene-cli, release-gate dashboard, agent-quality metrics, audit-grade dashboards) should follow gates+points with zero-on-gate-fail. The arithmetic IS the doctrine.

2. **Rule classification when authoring a new measure:**
   - Ask "if this fails, are downstream consumers BROKEN?" → if yes, it's a GATE (8)
   - Ask "if this fails, is this not yet PRODUCTION-READY?" → if yes, it's IMPORTANT (4)
   - Ask "do downstream consumers notice this gap?" → if yes, it's CONSUMER-TRUST (2)
   - Otherwise → QUALITY (1)
   - Each tier must have an actionable question it answers — see [[feedback_minimum-point-system-with-actionable-tiers]]

3. **Display the failure mode by NAME, not by number.** "GATE FAILED: layout.json-and-spm-twins" is auditable; "1 structural failure" is opaque.

4. **For external-facing surfaces** (investor demos, public README, partner dashboards), surface gate state PROMINENTLY. Polish without structural integrity is the substrate's communication failure mode the operator named explicitly.

**Self-pattern note for agents (operator-named 2026-05-30):**

The operator gently noted that agents (and I in this session specifically) tend to "look at things in order" and accumulate visible quality wins while structural things are broken. Concrete instance: this session I authored 5+ packages at the wrong substrate path, ran tests, all green — celebrating quality progress while my underlying structural gate (correct schema-family location) was failing. Under zero-on-gate-fail, I should have gotten a 0, not "look at all these tests passing."

**The pattern to catch:** *before celebrating quality progress on any substrate work, check the structural gates first*. If gates fail, the quality work is moot — it produces a 0, not partial credit. This is doctrine-grade behavior-correction for substrate agents.

## Related

- [[reference_wilson-constructing-measures-framework]] — Wilson's psychometric framework for refining the 1/2/4/8 prior into empirically-calibrated weights via Rasch
- [[feedback_release-gate-audience-review]] — release-gate doctrine; gates+points is the scoring layer on top of typed gates
- [[feedback_web-always-has-antagonist-speak-as-such]] — antagonist gates compose with the gates+points pattern (every public surface has gate state to enforce)
- [[feedback_adversarial-audience-the-entity]] — the-entity is one of the gates external surfaces face
- [[feedback_pause-and-plan-when-decisions-accumulate]] — operator's broader caution against "kept going without checking direction"; this memory specializes that to scoring-system design
