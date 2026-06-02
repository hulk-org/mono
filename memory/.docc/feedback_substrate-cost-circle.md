---
name: substrate-cost-circle
description: "Substrate's cost model now has TWO symmetric saving mechanics — **digikomas save agent Stamina, ghosts save operator Time**. The circle = (agent cost ↔ digikoma save) + (operator cost ↔ ghost save). Both are typed cost-measuring mechanics; together they close resource accounting for every substrate participant. Operator-named 2026-05-26 — \"the circle is complete.\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

The substrate has two participants whose resources need accounting:

- **Agent** — burns **Stamina** (context tokens, compute) per turn.
- **Operator** — burns **Time** (human attention, hours) per session.

Each participant has a *cost side* (resource burn) and a *save side* (typed bounded executor that recovers resource by routing work elsewhere).

**Operator-stated 2026-05-26:** *"a digikoma is a way for agents to gain stamina. and a ghost is a way for the TIME of an operator to be saved. we modelled JUST how expensive operators are so. basically both of these are cost measuring mechanics and now the circle is complete."*

## The two-resource × two-side ledger

|  | Agent (Stamina) | Operator (Time) |
|---|---|---|
| **Cost side** | Skill loading + active turn work — see [[feedback_skills-as-inventory-items]] | Operator session attention, human review cycles, operator-driven coordination |
| **Save side** | **Digikomas** + supplements — see [[feedback_supplements-vs-digikomas-during-vs-turn-end]] | **Ghosts** — see [[insights/ghosts-as-substrate-top-level-category-2026-05-17]] |
| **Receipt mechanism** | [[insights/substrate-sync-cost-pattern-2026-05-26]] typed invoice + append-only ledger | Same ledger family, operator-tier records |

## Why digikoma + ghost pair structurally

- **Both are bounded executors with their own resource budgets.** Digikoma runs in a separate stamina budget so the agent doesn't burn its own; ghost runs in a separate time budget — an AI-tier proxy of the operator that acts during operator-off-hours or when the operator is doing other things. The pattern is identical at a different layer.
- **Both are typed contract handoffs**, not generic agents. Digikoma takes a typed input model (`CommitRequestModel` → savepoint pair); ghost runs on the `ghost-shell-org` runtime with operator-aligned identity at `ghosts/<slug>/` (same slug as the operator — "same person, different tier" per the ghosts memory).
- **Both produce receipts** that should compose with the substrate's append-only cost ledger so net-resource accounting can be computed at session close.

## "We modelled JUST how expensive operators are"

The substrate's recent cost-modeling work focused first on **agent Stamina** (`inference-account-schemas v0.2.0`, sync-cost-pattern, encumbrance pressure levels). That captured one half of the participant pair. The "JUST" in the operator's statement reads two ways and both are true: *we just (recently) modelled it*, AND *we modelled JUST (only) the agent-side so far*. Ghosts complete the picture by giving operator-time the same typed-cost treatment:

- **Operator-side cost units** — operator-hours, attention-minutes, coordination-overhead. Different unit than Stamina but same typed-receipt framework.
- **Ghost save-credits** — each ghost-handled task declares "saves N operator-minutes vs the operator doing it directly," analogous to how digikomas declare stamina-save-credits.
- **Net-session resource summary** — `net_stamina(session) + net_time(session)` becomes the substrate's per-session economic figure. Encumbrance pressure can fire on either axis independently, or composite.

## The circle: full coverage of substrate participants

Before this synthesis: cost model tracked agent Stamina only. Operators were treated as "free" attention. That's wrong — operator time is the **most expensive** substrate resource (the operator is the founding participant whose hours have the highest opportunity cost).

After: every substrate participant has a typed cost-side AND a typed save-side. Resource accounting is **symmetric** and **closed** — no participant's resource burn is invisible to the ledger.

The geometric metaphor "the circle is complete" is precise — not "two-sided" or "balanced" but **closed**, meaning the model covers every participant and every resource flow.

## The three ledger entry kinds (operational formalization)

**Operator-stated 2026-05-26:** *"so we need to model every digikoma imprint as a +stamina and every skill use as: −stamina. and every ability use as a deferred stamina use woooooo."*

This is the concrete schema spec — the substrate's stamina ledger emits exactly three entry kinds, each tied to a typed event:

| Entry kind | Triggered by | Timing | Sign | Meaning |
|---|---|---|---|---|
| `+stamina` | **Digikoma imprint** (every invocation that leaves a typed receipt) | At digikoma execution time (turn-end) | **+** (credit / save) | Work was offloaded outside the agent's stamina budget — credit the agent's ledger by the work-equivalent amount the digikoma absorbed |
| `−stamina` | **Skill use** (every cataloged skill in `substrate/skills/` enumerated at session start, plus per-invocation when used) | At session start (load) AND at use (invocation) | **−** (debit / cost) | Skill is eagerly loaded into the global catalog and burns context tokens immediately; using it burns more |
| `−stamina_deferred` | **Ability use** (JIT-acquired skill at an ORG home, NOT in the global catalog) | At ability-acquisition time (entering the owning ORG's context); NOT at session start | **−** (debit, deferred) | Cost is paid only when the agent actually walks to the ORG and picks up the ability, NOT bundled into session-start load |

### Why this distinction reshapes the drain doctrine

Moving a skill from the global catalog to an ORG-local home doesn't just *relocate* the file — it **converts the entry kind from eager `−stamina` to deferred `−stamina_deferred`**. That's the mechanical reason the drain reclaims session-start budget: the cost still exists, but it's deferred to actual-use time instead of paid at every session start whether used or not.

Same skill, same SKILL.md content. The difference is *when* the cost lands on the ledger. This sharpens [[feedback_skills-as-inventory-items]]: the drain is a **timing conversion** of stamina cost, not an elimination.

### Net Stamina formula (formalized)

```
net_stamina(session) = +∑(digikoma imprints)
                      −∑(skill uses, eager at session start)
                      −∑(ability uses, deferred at acquisition time)
                      −∑(active turn work)
```

The first three terms are the new typed ledger entry kinds. The fourth (active turn work) is the existing agent-side cost from [[insights/substrate-sync-cost-pattern-2026-05-26]]. Receipts compose; net is computable per turn or per session.

## Avoidable loss: loaded vs used, settled at compaction

**Operator-stated 2026-05-26:** *"if a skill is loaded and NOT used: it's a stamina loss which could have been avoided. but if a skill is used BEFORE a compaction... then it's zero stamina loss."*

The `−stamina` cost of an eager skill load is **provisional** — it represents stamina the runtime spent on the bet that the skill would prove useful this session. The bet resolves at the next compaction:

- **Loaded AND used before next compaction** → the load was justified; net contribution is **zero stamina loss** (the cost was paid, the value was delivered).
- **Loaded AND not used before next compaction** → the load was wasted; the full `−stamina` cost becomes **avoidable loss** (the substrate paid stamina for context that produced no value).

**Compaction is the settlement boundary.** Each compaction event closes the books on the prior window — loaded skills get their final per-window verdict (justified or wasted), and the post-compaction context opens a new window where the same skills may be re-evaluated. Avoidable loss is computable per window.

### Feedback loop with the drain doctrine

This is the *measurable* justification for [[feedback_skills-as-inventory-items]]. Avoidable-loss frequency per skill across sessions is the metric that tells the substrate what to drain next:

| Observation | Action |
|---|---|
| Skill X loaded-but-not-used in most sessions | Strong drain candidate — convert to ORG-local ability so the cost becomes `−stamina_deferred` (paid only when actually picked up) |
| Skill X used in most sessions | Keep cataloged — load cost is repeatedly amortized by value delivery |
| Skill X used heavily in some session types, never in others | Conditional-cataloging candidate for a future role-autoload doctrine — load only when the session type matches |

The drain isn't aesthetic; it's a *prediction* about which skills will produce avoidable loss in future sessions based on prior observed loss frequency. The cost-circle gives the substrate the data; the drain doctrine gives it the action.

### Schema extension needed for v0.2.0

The v0.1.0 `StaminaUsageMetric` records aggregate per-event entries (`record --kind <k> ...`). To compute avoidable loss, v0.2.0 needs three additional event-level kinds emitted by the runtime:

- `loaded` — skill added to the global enumeration (at session start AND after each compaction's re-enumeration). Provisional `−stamina`.
- `used` — skill actually invoked. Confirms a prior `loaded` in the same window; zero net loss.
- `compaction` — window-boundary marker. A `compaction-settle` digikoma can sweep the prior window and emit derived `avoidableLoss` aggregate entries.

v0.1.0's three kinds (`imprint` / `eagerUse` / `deferredUse`) remain as a strict subset — they record verdict-level outcomes. v0.2.0 adds the event-level detail so verdicts can be COMPUTED rather than asserted.

### v0.2.0 versioning + authoring discipline

When the v0.2.0 work happens, two operator-stated rules apply:

1. **Do not delete v0.1.0.** v0.2.0 lives as a *sibling* SPM package at `stamina-usage-metrics-schemas/v0.2.0/spm/stamina-usage-metrics-schemas-v000-002-000/`, not as a replacement. See [[feedback_preserve-prior-schema-versions]] — preservation is load-bearing for diffability, migration tests, downstream-not-yet-bumped consumers, and doctrinal-drift audits.
2. **All new typed models go to schema-universal first, then get brought in via SPM dependency.** v0.2.0's new event-level types (`StaminaUsageEvent`, `StaminaCompactionMarker`, `StaminaAvoidableLossAggregate`, etc.) live in the schema family under `schema-universal`, NOT inside the consuming CLI. The CLI (and any other consumer — codex's session-end hook, the harness header renderer, the compaction-settle digikoma) brings them in by adding the SPM dependency. See [[feedback_audit-schema-universal-before-authoring-new-types]] — "audit before authoring" applies to v0.2.0's new types too. Reuse the v0.1.0 types where they fit; only add new types when no existing one composes.

**Operator-stated 2026-05-26:** *"models should be moved to schema-universal and then brought in. makes it so we don't reinvent the wheel over and over again."*

## Instrumentation discipline: the meter must be honest about its own cost

**Operator-stated 2026-05-26:** *"we need to make sure that tokens are counted via VERY well instrumented digikoma. we should have verbose settings on by default as we start so we know that the verbose can subtract token GENERATION aspects."*

The substrate's stamina ledger has the observer-effect problem of any measurement system: **the meter consumes the resource it's measuring**. Verbose-mode digikomas emit instrumentation output, and that output is *itself made of tokens*. A naive counter that just sums "all tokens this turn" would attribute the meter's own overhead to the work being done, inflating every reading.

For the ledger to be true, three instrumentation rules apply:

1. **Every digikoma is the substrate's measurement instrument.** Each invocation must emit per-call: token counts (input/output split), wall-clock timing, digikoma identity, the typed input contract that triggered it, and (for `+stamina` credits) the work-equivalent saved. Without per-invocation precision, the ledger is uncountable.
2. **Verbose mode ON by default at session start.** Substrate doesn't run "quiet then opt in to verbose" — it runs verbose then opts down. The default is full instrumentation so operators and the substrate runtime can see what's being measured. Quiet mode becomes the optimization, not the default.
3. **Meter overhead must be subtractable.** Verbose output generates tokens. Every verbose stamp must include its own size so the consumer can compute `true_work_cost = observed_total − Σ(meter_overhead_stamps)`. The meter reports its own cost so the readings are honest about what's work and what's measurement.

**Why this matters:** without rule 3, optimizing verbose chatter would *look like* optimizing work. Operators (and the substrate's encumbrance system) need to distinguish "the agent is doing expensive work" from "the meter is loud about cheap work." Subtractable meter overhead is the only way to tell.

**Implementation surface:** verbose digikoma stamps should be a typed shape like:

```
VerboseStamp(
  generatingDigikoma: <id>,
  payloadTokens: <int>,        // the substantive content
  meterOverheadTokens: <int>,  // the verbose framing's own size
  timestamp: <ts>
)
```

Consumers of the ledger compute net cost by accumulating `payloadTokens` and subtracting `Σ(meterOverheadTokens)` from gross-observed-total. The runtime can also emit a per-turn diagnostic line: "verbose meter spent N tokens this turn; net work cost was M."

This composes with [[feedback_cost-model-non-divergence-discipline]] — meter-overhead types should NOT be a parallel hierarchy to existing `inference-account-schemas v0.2.0` types; they extend the existing invoice/receipt shapes with a `meterOverheadTokens` field on each entry, not a separate ledger.

## Session measurement is RETROSPECT-ONLY (observability tax avoidance)

**Operator-stated 2026-05-26:** *"we actually don't want to measure in progress sessions. only in retrospect. otherwise we incur observability costs."*

Session-level stamina measurement (which skills loaded, which were used, when compactions fired) happens **retrospectively** by reading the harness's already-existing session history JSONL files — NEVER by live emission during the session. Live instrumentation would burn stamina on the very act of measuring stamina, polluting the readings.

**Two-layer split:**

- **Digikomas emit during their work** because emission IS their work (the typed receipt is the deliverable, not observability sidecar). A `digikoma-savepoint` writing a `+stamina` imprint record IS what it does; the imprint is its product. Live emission for digikomas is fine because there's no observability tax — the work *is* the emit.
- **Sessions do NOT emit during their work** because emission would be pure observability tax. Sessions write history JSONL anyway (for replay/debugging/operator review), so the substrate reads *that residue* retrospectively. Free measurement, paid by the harness's existing history-keeping.

**Why this is structurally stronger than subtractable meter overhead:** the prior doctrine ("meter must subtract its own cost") still holds for digikoma emission. But for sessions, the move is one step better — there is no meter to subtract. The history file already exists, was written for non-stamina reasons, and is read after the fact by something that doesn't perturb the session.

**Concrete consequences:**

1. No per-harness session-start emission hooks. No live scanner. No bootstrap CLI. None of that.
2. A retrospect tool reads each harness's history JSONL after sessions land:
   - claude: `harnesses/hulk/projects/<proj>/<session-id>.jsonl` + `harnesses/hulk/sessions/<id>` state
   - codex: `harnesses/codex/sessions/<id>/...` + `history.jsonl`
   - gemini: equivalent
3. Past sessions become analyzable. The substrate can compute "how much did we waste on gstack between March and now" by walking 60 days of pre-existing history files.

## Encounter-complete: sessions get ratings when they land

**Operator-stated 2026-05-26:** *"once a session lands it gets ratings! haha. like an encounter complete!"*

When a session lands (the work is committed via the savepoint pair and the session's history file is final), the retrospect tool computes a typed **`SessionRating`** — a Pokemon/RPG-style "encounter complete" summary card.

The rating is a **lens packet** (per [[insights/lens-apps-substrate-pattern-2026-05-18]]) — typed JSON underneath, renderable per audience as terminal art, markdown, HTML, PDF, or SwiftUI view.

**Suggested rating components** (analogous to RPG encounter outcomes):

| RPG concept | Session-rating analog |
|---|---|
| Final score / rank | Overall rank (S / A / B / C / D / F) computed from avoidable-loss ratio + error count + compaction survival |
| XP gained | Net positive stamina (work absorbed by digikomas, useful skill uses) |
| MVP party member | Top imprint contributor — the digikoma that absorbed the most work this session |
| Items found | Useful skills that earned their load — paired loaded+used inside their window |
| Items wasted / over-encumbered | Top drain candidate — skill that loaded and was never used (gstack-style waste) |
| Boss encountered | Highest-cost single operation in the session |
| Hits taken | Error-tagged entries × cost |
| Levels survived | Compactions weathered |

**Rank computation (suggested ladder):**

| Rank | Condition |
|---|---|
| S | Net positive stamina, 0 avoidable loss, 0 errors |
| A | Net positive or neutral, avoidable-loss < 5% of gross |
| B | Avoidable-loss 5–15% of gross |
| C | Avoidable-loss 15–30% of gross |
| D | Avoidable-loss 30–50% of gross |
| F | Avoidable-loss > 50% of gross |

**Why this matters beyond aesthetics:** ratings make cost-awareness *glanceable*. Operators don't have to read JSON or run aggregation queries — every session ends with a postcard saying "A-rank, $0.045 wasted, top drain candidate: gstack-foo." That builds the drain-doctrine feedback loop into operator habit, not just into substrate scheduled jobs.

**Composition note:** the rating's data fields all come from `StaminaSessionSummary` + per-strategy `StaminaAvoidableLossEntry` records. No new schema layer needed — `SessionRating` is a *derived* lens packet, computed from the same canonical ledger the cost-estimator already reads.

## Operator-time-loss: rate-limit events are the canonical example

**Operator-stated 2026-05-26:** *"i think that TIME lost is important too. if we hit a rate limit then BOOM we lost that time. and that time is measured against the operators time cost... which is HUGE."*

The cost-circle's operator-Time-cost side was previously abstract ("session attention", "human review cycles"). Rate-limit events give it a concrete, measurable form: **every 429 response or rate-limit-induced pause is a typed `OperatorTimeLossEvent` with computable dollar cost.**

**Why rate limits hit the operator's budget, not the agent's:** while the agent waits to retry, the operator is parked — watching their terminal, attention captured but not productive. The stamina ledger doesn't change during the wait (no tokens flow), but **wall-clock minutes accumulate against the operator's hourly rate**. At a reasonable operator rate ($150–$300/hr opportunity cost for substrate operators), a single 12-minute rate-limit pause is $30–$60 of real economic damage.

**Typed event shape (v0.2.0+ schema candidate):**

```swift
public struct OperatorTimeLossEvent: Codable, Sendable, Hashable {
  public var kind: OperatorTimeLossKind  // .rateLimit, .approvalGate, .toolDelay, etc.
  public var waitSeconds: Int            // wall-clock duration of the loss
  public var triggerSource: String       // which inference provider, which gate, etc.
  public var sessionId: String
  public var timestamp: Date
}
```

**Dollar-cost computation:**

```
operator_time_loss_usd = (waitSeconds / 3600) × operator_hourly_rate_usd
```

**Retrospect extraction:** the history files already record everything needed. For claude:
- API error responses with status 429 (or matching error message text)
- Retry-after timestamps in the response
- Wall-clock gap between the error and the next assistant message

For codex / gemini: equivalent error tags + timestamp deltas.

**Symmetry with the stamina side, completed:**

| Side | Cost mechanism | Save mechanism | Canonical example |
|---|---|---|---|
| Agent Stamina | Skill loads (`−stamina`) | Digikoma imprints (`+stamina`) | gstack toolkit wasted load tokens |
| Operator Time | Rate-limit waits, approval gates, manual interventions | Ghosts (operator-time-save) | 429 from inference provider during peak hours |

**Why this matters for ratings:** the `SessionRating` previously computed rank from stamina-side metrics only. With operator-time-loss in the mix, a session can be S-rank on stamina but F-rank overall because it cost the operator 45 minutes of rate-limit waits. The rating *should not* hide operator time loss — it's the bigger economic figure. Suggested rank impact:

| Operator time lost in session | Rating impact |
|---|---|
| 0 minutes | No penalty |
| < 2 minutes total | -0 ranks (within noise) |
| 2–10 minutes | -1 rank (S→A, A→B, etc.) |
| 10–30 minutes | -2 ranks |
| > 30 minutes | Cap at C regardless of stamina performance |

**Forward-engineering implications:**

1. **New schema family or shared type:** `OperatorTimeLossEvent` lives alongside `StaminaUsageEvent`. Likely a new `operator-time-metrics-schemas` family (mirrors `stamina-usage-metrics-schemas` shape) rather than extending stamina's.
2. **Retrospect tool extracts both event streams:** stamina-from-skill-events AND operator-time-loss-from-rate-limits, written to two ledgers in the same `.wrkstrm/tmp/` slot.
3. **Cost estimator joins both:** `stamina-loss-cost-estimator@clia-org.cli` gains an `--operator-hourly-rate-usd` flag; output report includes operator-time-loss section with $ figures.
4. **Operator profile gains an hourly rate field:** `operators/<slug>/private/universal/identity/<slug>.identity.json` carries `hourlyRateUSD` so the rate isn't a CLI flag but a typed operator attribute.
5. **`SessionRating` derivation incorporates both axes** (stamina avoidable-loss ratio AND operator-time-loss).

## Asymmetric ROI: digikoma deployment is almost always net-positive

**Operator-stated 2026-05-26:** *"so you see, even if the digikoma only adds a bit of stamina, it can avoid a time loss event!"*

The cost-circle's two-axis model exposes a massive economic asymmetry between agent stamina (cheap, per-token) and operator time (expensive, per-minute). This asymmetry means **digikoma deployment decisions are almost never close calls — the math overwhelmingly favors offloading.**

### The break-even math

- Typical digikoma stamina cost: **~500 tokens** (typed receipt + bounded execution + ledger write)
- Per-token price (Claude Opus): **$0.00003/token**
- Digikoma cost: **$0.015 = 1.5 cents**
- Operator time cost (at $350k/yr, 2080 hr/yr): **$168.27/hr = $2.80/minute**

**Break-even threshold:**

```
break_even_seconds = digikoma_cost_usd / (operator_hourly_rate_usd / 3600)
                   = $0.015 / ($168.27 / 3600)
                   = $0.015 / $0.04674/sec
                   ≈ 0.32 seconds
```

**A digikoma that saves the operator more than a third of a second pays for itself.**

### Realistic ROI multiples

| Operator time saved | Operator $ saved | Digikoma $ cost | ROI multiple |
|---|---|---|---|
| 1 second | $0.047 | $0.015 | 3x |
| 30 seconds | $1.40 | $0.015 | 93x |
| 5 minutes (one rate-limit pause) | $14.02 | $0.015 | **933x** |
| 30 minutes (the rank-cap threshold) | $84.13 | $0.015 | **5,609x** |
| 60 minutes | $168.27 | $0.015 | **11,218x** |

### Doctrinal consequence: digikoma-first default

Before this framing: "should we route this to a digikoma?" was a judgment call balancing stamina vs. perceived complexity.

After this framing: **the substrate's default disposition is digikoma-first.** Route to a digikoma unless the digikoma is genuinely expensive (thousands of tokens) AND the operator-time-savings are genuinely uncertain. The asymmetry is so large that even poorly-estimated savings make most digikomas worthwhile.

The same applies to **ghosts** (operator-time-saving counterpart): ghost deployment also has an asymmetric ROI when measured against operator opportunity cost. A ghost that absorbs 1 hour of operator-coordination work at a stamina cost of ~$0.50 = 336x ROI.

### The substrate's job, restated

The cost-circle now makes the substrate's purpose mathematically precise: **convert cheap agent stamina into expensive operator time as aggressively as possible.** Digikomas and ghosts are the conversion mechanisms. Skill drains free up the stamina budget for those conversions. Every doctrinal piece (drain doctrine, encounter ratings, retrospect analysis) ultimately serves this conversion.

## Forward-engineering implications

1. **Typed `OperatorTimeInvoice` schema** parallel to the agent's proposed `StaminaInvoice` ([[feedback_supplements-vs-digikomas-during-vs-turn-end]] section 4). Both peer to existing `inference-account-schemas v0.2.0`.
2. **Ghost contract declarations** — each ghost handler declares its `time-save-credit` so receipts compose. Format mirrors digikoma's `stamina-save-credit`.
3. **Cross-resource encumbrance** — substrate runtime tracks both ledgers in parallel; pressure on either axis can trigger different recourses (drain agent skills → recover Stamina; defer task to ghost → recover Time; offload to digikoma → recover Stamina differently; etc.).
4. **Operator-cost rate annotation** — session-start records the operator's stated hourly opportunity cost; mid-session resource burns can be multiplied to compute economic-cost-equivalent figures across the two units.
5. **Composition discipline** — per [[feedback_cost-model-non-divergence-discipline]], any new operator-time-cost types must compose with `inference-account-schemas v0.2.0` rather than redefine parallel hierarchies.

## Companion entries

- [[insights/ghosts-as-substrate-top-level-category-2026-05-17]] — ghost as substrate top-level category, peer to agents/operators; "same person, different tier"
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — agent-side save mechanism, with Stamina accounting model that this entry now mirrors for operator-time
- [[feedback_skills-as-inventory-items]] — agent-side cost mechanism (loading skills costs Stamina)
- [[insights/substrate-sync-cost-pattern-2026-05-26]] — canonical receipt ledger that both halves of the circle write to
- [[feedback_cost-model-non-divergence-discipline]] — composition discipline preventing parallel-hierarchy drift
