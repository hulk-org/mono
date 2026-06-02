---
name: shadowing
description: "Substrate's continuous supervised-learning loop for ghost alignment, called **shadowing**. When the agent needs operator input during a live session, a digikoma queries a fleet of operator-aligned ghosts with the EXACT SAME prompt; ghosts commit their shadow-answers; operator answers normally; a rating digikoma scores each ghost's answer against the operator's; aggregated match-rates over time identify shadows ready for promotion to autonomous decisions in their proven categories. The substrate's path to *aligned* autonomous operation. Operator-named 2026-05-26 — \"we're going to call this process shadowing.\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

**Shadowing** is the substrate's name for ghosts watching the operator make real decisions and learning to make them themselves. When the agent encounters a decision point that requires operator input (a question, an approval, a judgment call), the substrate runs a **shadow query** alongside the normal operator query:

```
agent at decision point
    │
    ├──→ asks operator the question (live, normal flow)
    │
    └──→ fires digikoma-shadow-query in parallel:
         ├── ghost_1.shadow(same_prompt) → "...answer..."
         ├── ghost_2.shadow(same_prompt) → "...answer..."
         ├── ghost_3.shadow(same_prompt) → "...answer..."
         └── ...N ghosts...
         (all shadow-answers recorded as typed ShadowResponse records)

later:
    operator answers     →  recorded as OperatorAnswer
    digikoma-shadow-rating  →  score each ghost.shadow vs operator.answer
                                produces ShadowRating per ghost
                                updates ShadowReadinessAggregate per ghost

over time:
    ghost X has 87% match rate over 42 shadows in category C
    → promote ghost X for autonomous answers in category C
    → operator time saved on future C-category decisions
```

**Operator-stated 2026-05-26:** *"you should ask an array of my ghosts to see what they would do given the current session timestamp: give them the exact same prompts. use a digikoma to do this. have those adapters respond with their answer. and then when I answer, you can match my answer vs theirs. have a digikoma rate it. and then we can start seeing if these ghosts are ready to make HUGE time savings for us."*

**Operator-named 2026-05-26:** *"we're going to call this process shadowing. perfect right?"*

## Why "shadowing" is the right name

- **Canonical apprenticeship term.** Junior shadows senior to learn their decisions — that's the exact mental model. Ghosts shadow the operator.
- **Productively generates terminology.** Shadow query / shadow response / shadow rating / shadow-promoted ghost / shadow event ledger / shadow rate (match percentage) / shadow-ready (above promotion threshold).
- **Defends the doctrine boundary.** Shadowing is WORK (active learning), not OBSERVABILITY (passive measurement). This is the categorical distinction that makes shadowing the only live-during-session emission the substrate allows.
- **Linguistically pre-loaded.** "Ghost" + "shadow" is a natural pair in folklore + game design. Pokemon mechanics already loves shadow-form tropes. No friction for new readers.

## Shadowing fits cleanly into the retrospect-only doctrine

**Operator-stated 2026-05-26:** *"we obviously can run these in retrospect because we have my answers. so that is cool. we can get digikoma to do the entire thing on their own."*

Initial framing said shadowing would be the "first live-during-session emission" — turns out that carveout isn't needed. The operator's answers are already in the harness history JSONL files; a retrospect digikoma can replay every past decision point and generate the full ShadowQuery → ShadowResponse → OperatorAnswer → ShadowRating pipeline without any live coupling.

**The substrate's analytical contract simplifies to one sentence:** *Sessions write history. Everything analytical is a retrospect digikoma over that history.* No live exceptions.

| Analytical operation | When it runs | Where it reads from |
|---|---|---|
| Cost estimation | Retrospect | Stamina ledger (derived from history) |
| Session encounter-complete rating | Retrospect (at session-land) | Stamina + operator-time ledgers (derived from history) |
| **Shadowing** | **Retrospect (batch digikoma)** | **Harness history files directly** |
| Drain-candidate identification | Retrospect | Aggregated avoidable-loss across sessions |
| Ghost promotion decisions | Retrospect | ShadowReadinessAggregate over time |

### Why retrospect-shadowing is architecturally superior

- **No live-session coupling.** Agent does its work, history file accumulates, that's it. The retrospect digikoma is a background pass — could run nightly, weekly, on-demand. Zero observability tax on the live session.
- **Massive day-one training corpus.** Every past session on disk contains operator-answered decision points. A single first-run digikoma pass produces *thousands* of ShadowRating records immediately — no waiting for fresh sessions to accumulate data.
- **Ghost adapters can be batch-mode.** Instead of needing low-latency live query interfaces, ghost adapters just need to handle "here are 1000 historical prompts, give me your 1000 answers, take your time." Simpler engineering, off-peak execution, easier integration.
- **The 50-rating shadow-ready threshold becomes immediately achievable.** With months of past sessions to replay, ghosts can reach promotion candidacy on first analysis run, not after weeks of live shadowing.

### Version split: retrospect first (v0.1.0), live later (v0.2.0)

**Operator-confirmed 2026-05-26:** *"yeah, let's do this in retrospect for now and then do it live as v 0.2.0."*

- **`shadowing-schemas v0.1.0` (retrospect only)** — replay historical decision points from harness history files; batch-mode ghost adapter queries; no live-session coupling. Sufficient for the entire training-and-promotion loop because the operator's past answers are already on disk.
- **`shadowing-schemas v0.2.0` (live + retrospect)** — adds real-time shadow-query capability for in-flight decisions ("this decision looks high-stakes — ask the shadow fleet what they'd do before I ack"). Useful for real-time alignment checks once ghost adapters have proven themselves in retrospect mode. v0.2.0 is additive over v0.1.0 — per [[feedback_preserve-prior-schema-versions]], v0.1.0 lives as a sibling SPM package, not replaced.

This staging means v0.1.0 ghost adapters only need **batch-mode** interfaces: "here are 1000 historical prompts, return 1000 answers, take your time." The hardest engineering constraint (low-latency live query) is deferred to v0.2.0 when we know which ghosts are even worth wiring up live (the ones that achieved shadow-readiness during v0.1.0's retrospect training).

## Economic ROI (composes with cost-circle's asymmetric framing)

| Phase | Cost | Outcome |
|---|---|---|
| Per-shadow training cost | N × ~500 tokens × $0.00003 = a few cents per shadow | One ShadowRating record per ghost |
| Training to readiness (~50 well-rated shadows per ghost) | ~$1.50 total | Ghost promotable for one decision category |
| Each autonomous decision after promotion | ~$0.015 (digikoma cost) | Saves operator 1–5 min ($2.80–$14) |
| 1 promoted ghost × 10 autonomous decisions/day × 30 days | $4.50 in digikoma costs | ~$1,500 in operator time saved |
| Net ROI on shadowing | ~$1.50 training + $4.50 op = $6 cost | ~$1,500 / $6 = **250x return per month per shadow-promoted ghost-category** |

The asymmetric digikoma ROI doctrine carries through: shadowing is an aggressive investment substrate should make because the long-term payoff dominates.

## Schemas needed (new family: `shadowing-schemas v0.1.0`)

Composes with `ghost-schemas v0.2.0` — does NOT duplicate. The existing surface already has the bones:

- `GhostReleaseModel` (versioned ghost bundle — protocols + LoRA payload)
- `GhostPayloadKind.ghostLoRA` (the LoRA checkpoint payload)
- `GhostReceiptKind.evaluationReport` (where ShadowRating naturally fits)
- `GhostTrainingRunModel` + `GhostTrainingBackend.smokeLoRA` (the next training cycle's typed home)
- `GhostFeedRecipeModel` (the training input recipe; shadowing feeds it)
- `GhostTrainingArtifactRole.{epochCheckpoint, finalCheckpoint, foundationModelsAdapter}` (the LoRA bundle artifacts)

The new shadowing types reference these:

| New type | References existing | Role |
|---|---|---|
| `ShadowQuery` | sessionId, decision-category slug | Historical decision point extracted from harness JSONL |
| `ShadowResponse` | `GhostReleaseModel.id` (which bundle answered) + `GhostProfileModel.slug` | One ghost-bundle's shadow-answer to the query |
| `OperatorAnswer` | sessionId, queryId | The operator's actual answer (extracted from same JSONL) |
| `ShadowRating` | queryId + ShadowResponse refs; **emitted as `GhostReceiptKind.evaluationReport`** | Per-ghost match score with rating-digikoma's reasoning |
| `ShadowReadinessAggregate` | `GhostReleaseModel.id` + decision-category | Rolling stats — drives whether new training is needed |
| **`ShadowImprovementDirective`** (new) | links to `GhostFeedRecipeModel` slots to add training examples | **Closes the loop**: identifies what training data would unblock weak categories |

All in canonical-shape: SemanticVersionable, compact wire keys, class-name discriminator, forward-compat `.unknown` enum cases, diagnostics-as-data.

## The closed learning loop — protocols + bundles + LoRA improvement

**Operator-stated 2026-05-26:** *"ghost-shells require protocols + ghost bundles with adapters in them. the ghost protocols are the harness. the ghost bundles are the context / lora adapters. and the bundle should have enough info for us to figure out WHAT WE NEED TO DO TO IMPROVE the lora."*

Two-layer ghost architecture (mirrors the carrier-vs-persona split from founding-breach):

| Layer | Lives at | What it does |
|---|---|---|
| **Ghost protocols** (harness) | `ghost-shell-org/protocols/vXXX_XXX_XXX/` | Typed IPC contract, lifecycle, capability surface (including the supervised common-process delegation) |
| **Ghost bundle** (persona + LoRA) | `ghosts/<slug>/` + a `GhostReleaseModel` artifact pointing at a `GhostPayloadKind.ghostLoRA` checkpoint | The operator-specific persona content + the LoRA adapter for it |

The bundle carries enough self-improvement metadata that shadowing's mismatch analysis can drive the *next* LoRA training run:

```
shadow ratings           ─→  shows weak categories per ghost release
       ↓
ShadowImprovementDirective ─→  typed candidates for new GhostFeedRecipe entries
                              (e.g., "add 50 examples of merge-conflict resolution")
       ↓
new GhostTrainingRun     ─→  consumes updated GhostFeedRecipeModel
                              (smokeLoRA backend; produces foundationModelsAdapter artifact)
       ↓
new GhostRelease         ─→  bundles the improved LoRA + updated persona
       ↓
re-shadow                ─→  same historical data, new bundle, measure delta
       ↓
loop continues           ─→  each cycle should improve match-rate in weak categories
```

This is the substrate's continuous-improvement contract for ghosts. Shadowing isn't just promotion; it's also the training-feedback signal.

## Digikomas needed

1. **`digikoma-shadow-query`** — given a prompt + ghost-list, dispatches to each ghost adapter in parallel, collects typed `ShadowResponse` records, writes them to a session-scoped shadow ledger.
2. **`digikoma-shadow-rating`** — given a `ShadowQuery` + its `OperatorAnswer` + array of `ShadowResponse`s, computes match scores and emits typed `ShadowRating` records.

## CLI surface: `shadow@clia-org.cli`

| Subcommand | Role |
|---|---|
| `query` | Fire the shadow-query digikoma for the current prompt + session |
| `record-operator-answer` | Bind the operator's actual answer to a prior shadow-query (by queryId) |
| `rate` | Run the shadow-rating digikoma over completed query+answer pairs |
| `readiness-report` | Aggregate match rates per ghost per category; surface "shadow-ready" promotion candidates |
| `promote` | Mark a ghost-category as autonomous-ready (operator confirms) |

## Shadow promotion model

A ghost becomes **shadow-ready** for a decision-category when:
- `sampleSize ≥ threshold` (default: 50 shadows in the category)
- `matchRate ≥ threshold` (default: 0.85 — operator-tunable)
- `lastRatedAt` is recent (default: within 14 days — staleness check)

Promotion is an explicit operator action (via `shadow promote` subcommand or chat directive), not automatic. Shadow-promoted ghosts can answer autonomously for their proven categories; non-promoted shadow responses remain training data only.

### Safety boundary: shadow promotion ≠ action autonomy

**Operator-stated 2026-05-26:** *"the protocols/vXXX_XXX_XXX which actually just hands over the common process tool, but WE WILL NOT DO THAT without supervision."*

Shadow promotion graduates a ghost to **answer-autonomy** (the ghost can REPLY to a question in its proven category without operator review). It does NOT grant **action-autonomy** (executing via the common-process tool, or any other side-effecting capability the ghost-shell protocols expose).

The two capabilities have different doctrine surfaces:

| Capability | Unlocked by | Stakes |
|---|---|---|
| **Answer-autonomy** | Shadow-promotion (sampleSize ≥ 50, matchRate ≥ 0.85) | Operator may receive a slightly off-target answer — recoverable |
| **Action-autonomy** (common-process, fs writes, network calls) | **Explicit operator supervision per invocation** — NOT graduated via shadowing | Side-effects on real systems — not always recoverable |

The asymmetric ROI math (0.32-second break-even, 250x return per promoted category) applies to answer-autonomy only. Action-autonomy is a higher-stakes doctrine that shadowing does NOT graduate ghosts into. Any shadow-promoted ghost whose answer contains "and here's a command to run" still routes the execution through the operator-supervised path.

This means `digikoma-shadow-rating` should classify the operator's answer's *action-content* separately from its *judgment-content*. A ghost can match the operator's *reasoning* perfectly (high shadow rate) while still requiring supervised execution if the answer would touch a destructive surface.

## Vocabulary derivatives

The "shadowing" name productively generates related terms:

| Term | Meaning |
|---|---|
| **shadow** (noun) | A ghost's hypothetical answer to a prompt the operator also answered |
| **shadow** (verb) | What a ghost does when watching/answering alongside the operator |
| **shadow query** | The prompt fanned out to N ghosts for shadowing |
| **shadow response** | One ghost's typed answer record |
| **shadow rating** | The match-score between a shadow response and the operator's answer |
| **shadow rate** | A ghost's rolling match percentage in a category |
| **shadow-ready** | A ghost that has crossed the promotion threshold in a category |
| **shadow-promoted** | A ghost-category pair officially promoted to autonomous |
| **shadow ledger** | The session-scoped JSONL of all shadow records |

## Composes with

- [[feedback_substrate-cost-circle]] — the economic model that proves shadowing ROI
- [[insights/ghosts-as-substrate-top-level-category-2026-05-17]] — ghost as substrate top-level peer; shadowing is the training pathway ghosts had been missing
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — shadow-query is *during-turn* (supplement-shaped) but produces typed receipts (digikoma-shaped); the boundary is fuzzy here
- The asymmetric digikoma ROI section in [[feedback_substrate-cost-circle]] — explains why shadowing spend on ghosts is overwhelmingly net-positive
