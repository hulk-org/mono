---
name: minimum-point-system-with-actionable-tiers
description: "Substrate scoring doctrine: use the minimum N-point scale such that every tier has an actionable question. Avoid arbitrary 5/10 weights; each tier earns its place by answering a distinct decision question."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Substrate scoring scales: use the minimum N such that every tier has an actionable question.** Operator-stated 2026-05-30:

> *"these points... like like we only need a 1 or 2 point system... that's the factoring right? we should move to minimum point based on relative strength to concerns."*

**The principle in one line:**

The minimum scale is the smallest N where each tier answers a *different* actionable question. If you can't articulate the question a tier answers, the tier doesn't belong.

**Diagnostic per scale:**

| N | Domain it fits | Test |
|---:|---|---|
| **1** | All concerns equally critical | Pure presence/absence: "Does this exist?" |
| **2** | Structural vs quality binary | "Does this break consumers, or is it cosmetic?" |
| **3** | Structural / consumer-trust / quality | Middle tier must answer: "If this fails, can consumers function but with degraded trust?" |
| **4** | Quality / consumer-trust / important / structural | Adds: "If this fails, is this not yet PRODUCTION-READY?" — distinct from both consumer-trust and structural |
| **5+** | Almost always overkill | Rarely earns its place; usually two adjacent tiers can be collapsed without losing information |

**Symptoms of unearned tiers (failure mode of N too large):**

- 80%+ of items end up in the middle bucket → people default to "important" when unsure → middle becomes a dumping ground
- No actionable threshold for the middle tier → "consumer-trust failure" doesn't gate any decision
- Items in the middle tier differ from each other MORE than from the edges → the boundary isn't real

**Why the substrate's existing 5/10 weights are wrong:**

The `universal-schema-hygiene-cli` scoreboard uses 5/10 point weights. That's a 2x ratio (structural=10 is 2x quality=5). Two problems:

1. **The 2x ratio understates severity.** Recovery cost for structural breaks is closer to 4-8x quality misses (per [[feedback_gates-points-scoring-zero-on-gate-fail]]). 5/10 communicates "twice as important" when the substrate actually means "categorically different."
2. **Arbitrary weighting (5, 10) carries no semantic.** A 1/2/4/8 system FORCES the authoring choice to be meaningful — you can't hide a "feels 8-ish" intuition. Reading "this is a 4" tells the reader exactly which tier.

**Substrate scoring scheme post-correction:**

Per [[feedback_gates-points-scoring-zero-on-gate-fail]], the substrate's chosen scheme is:

- **4 tiers, doubling: 1 / 2 / 4 / 8**
- Each tier answers a distinct actionable question (cosmetic / UX-noticed / not-yet-production-ready / consumer-broken)
- Gate failure (8-tier) zeros the entire score, not partial credit

**General-applicability:**

This principle extends beyond hygiene scoring to any substrate scoring/severity system:

| Domain | Tier count | Tiers |
|---|---:|---|
| Hygiene scoring | 4 | quality / consumer-trust / important / gate |
| Incident severity | 3 | S0 critical / S1 serious / S2 minor (NOT S0/S1/S2/S3/S4 — rarely justified) |
| Confidence levels | 3 | high / medium / low (NOT 1-10 — over-discriminates) |
| Release-gate priority | 2 | blocking / advisory (most release gates collapse here) |
| Agent quality | 4 | excellent / acceptable / needs-rework / unshippable |
| Bug bounty severity | 4-5 | informational / low / medium / high / critical (industry standard; each has a distinct payout question) |

**How to author a new scoring system (substrate-doctrine):**

1. List the concerns/items
2. For each concern, articulate the question its failure answers ("if this fails, what changes?")
3. Group concerns by *same answer* — those are candidate tiers
4. If two tiers' questions are the same, COLLAPSE them
5. If a tier has no actionable question, REMOVE it
6. Pick the minimum N (count of distinct-question tiers)
7. Pick weights using doubling (1/2/4/8/...) — each tier ≈ 2x lower

**Self-pattern note for substrate authoring:**

When tempted to use 5/10 weights or arbitrary numeric spreads, the instinct usually reflects "I want this to feel important" rather than "this tier has a distinct actionable question." Discipline: every numeric weight should be defensible by pointing to the tier's question. If you can't, the weight is decoration, not measurement.

## Related

- [[feedback_gates-points-scoring-zero-on-gate-fail]] — the concrete 1/2/4/8 doubling scheme that implements this principle
- [[reference_wilson-constructing-measures-framework]] — Wilson's psychometric framework provides empirical calibration for tier weights; this memory provides the *prior design* methodology
- [[feedback_data-is-one-thing-rendering-is-projection]] — scoring is data; F-vs-gradient display is projection; design both layers separately
- [[feedback_pause-and-plan-when-decisions-accumulate]] — similar discipline applied to action: smallest viable scope; here, smallest viable tier count
