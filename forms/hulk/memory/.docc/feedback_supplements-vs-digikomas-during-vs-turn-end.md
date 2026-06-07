---
name: supplements-vs-digikomas-during-vs-turn-end
description: "Substrate distinguishes \"supplement\" (during-turn cognitive parallel-delegation) from \"digikoma\" (turn-end bounded executor); they're NOT interchangeable terms for typed delegation"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

Substrate has TWO distinct names for typed bounded delegation, not one — and using "digikoma" for both is a vocabulary regression that obscures the temporal-scope distinction the operator cares about.

- **Supplement** = augments the agent's NATIVE-HARNESS turn capacity by running a cognitive sub-task IN PARALLEL with the agent *during* a turn. Examples: testing supplement (decides what to test, writes new tests, runs them, interprets results, suggests follow-ups), discovery supplement (does substrate exploration while the agent works on design lock).
- **Digikoma** = bounded one-shot executor invoked AT TURN END (or between turns) for persistence/observability operations. Canonical: the savepoint pair (`savepointd` + `digikoma-savepoint`) that takes a `CommitRequestModel` and lands the commit. Other candidates: ledger flushes, telemetry pushes, header-session-state persistence.

**Why:** the words emphasize different relationships to the agent's native loop. "Supplement" emphasizes *supplements, not replaces* — the agent stays load-bearing and the supplement adds capacity. "Digikoma" emphasizes the *bounded one-shot executor* pattern with a typed contract handoff. They cost different things, compose differently with the cost-sync ledger, and run at different points in the turn lifecycle.

**How to apply:** when proposing typed delegation, classify by *when it runs relative to the agent's turn*.

- During-turn cognitive delegation → supplement
- Post-turn persistence/IO → digikoma
- A "git supplement that runs during the turn" is the wrong shape; git work is turn-end, so it's a digikoma
- A "testing digikoma" called once at turn-end is also the wrong shape; testing benefits from running in parallel with edits, so it's a supplement

There is also a **native-harness layer** beneath both — the inference engine + tool dispatch the operator cannot see and the agent cannot expose. Workflow docs should acknowledge this layer exists and is out of scope for delegation, rather than conflate it with agent-side execution work.

Three-layer model:

```
[native harness — opaque, not documented]
        ↓
[agent active turn — judgment, design, conversation, root-cause]
        ↓ parallel              ↓ at turn end
[supplements]              [digikomas]
```

Operator-stated 2026-05-26 in the turn-flow-default-agent-mechanism documentation thread, correcting an earlier draft that called everything a "digikoma."

## Stamina accounting: digikomas SAVE Stamina

**Operator-stated 2026-05-26:** *"digikoma are a way of SAVING stamina because you offload to them. we need to model that."*

Digikomas and supplements have a **second purpose besides typed bounded execution**: they are the substrate's mechanism for **saving the active agent's Stamina** by offloading work to bounded executors that run in their *own* stamina budget rather than burning the agent's.

This completes a symmetric Stamina ledger that the substrate already half-tracks. **Operator-formalized 2026-05-26:** every digikoma imprint emits a `+stamina` ledger entry, every skill use emits `−stamina`, every ability use emits a *deferred* `−stamina_deferred`. Three typed entry kinds:

| Entry kind | Triggered by | Timing | Effect on root agent's Stamina |
|---|---|---|---|
| `+stamina` | **Digikoma imprint** (each invocation leaves a typed receipt) | Turn-end | **+** (credit; work absorbed outside agent budget) |
| `+stamina` | **Supplement imprint** (parallel cognitive offload returns) | During-turn | **+** (credit; parallel work in supplement's own budget) |
| `−stamina` | **Skill use** (cataloged in `substrate/skills/`) | Session start (eager load) + per-invocation | **−** (paid up-front whether used or not; see [[feedback_skills-as-inventory-items]]) |
| `−stamina_deferred` | **Ability use** (ORG-local, NOT globally cataloged) | At acquisition (entering ORG context) | **−** (deferred; cost only when actually used) |
| `−stamina` | **Active turn work** (reasoning, edits, tool calls, prose) | During-turn | **−** (paid as the agent works) |
| **Receipt** | [[substrate-sync-cost-pattern]] typed invoice + append-only ledger | (records all of the above per-invocation) |

The `+stamina` / `−stamina` / `−stamina_deferred` schema is the operational core — see [[feedback_substrate-cost-circle]] for the canonical spec.

**Why this matters:**

- **Drain doctrine has a counterpart.** Draining skills from the global catalog recovers Stamina that would have been burned at session start. Routing work through digikomas recovers Stamina that would have been burned during active turns. Both are Stamina-conscious moves operating on different axes.
- **Choosing between in-context and digikoma is a Stamina trade.** "Do I do this commit myself?" vs "Do I hand a `CommitRequestModel` to `digikoma-savepoint` and let it land outside my context?" — second choice saves the agent's Stamina for higher-judgment work. Same logic for ledger flushes, telemetry, large file scans, multi-step git surgery.
- **Encumbrance pressure unlocks shifts.** When [[substrate-sync-cost-pattern]] `EncumbrancePressureLevel` rises, the substrate's recourse isn't just "do less" — it can be "shift more to digikomas" (turn-end offload) and "shift more to supplements" (parallel offload). The Stamina-save side of the ledger becomes the pressure-release valve.

**The "we need to model that" call:** the symmetric accounting needs to be formal, not just documented. Concrete next steps when the substrate revisits this:

1. **Typed `StaminaInvoice` schema** that distinguishes cost vs save entries, peer to existing `inference-account-schemas v0.2.0` invoice types.
2. **Per-skill load-cost annotation** in `SKILL.md` frontmatter (e.g., `stamina-load-cost: 800` — approximate token cost of the eager catalog enumeration), so the global catalog has measurable shelf-cost.
3. **Per-digikoma save-credit declaration** in the digikoma's typed contract (e.g., `digikoma-savepoint` declares "saves ~5000 stamina vs doing the equivalent git work in-context"), so receipts can compose into a net Stamina figure per turn.
4. **Ledger composition rule**: net session Stamina = Σ(loads) + Σ(active-turn work) − Σ(digikoma saves) − Σ(supplement saves). Substrate runtime can plot this and trigger encumbrance signals when net approaches the ceiling.

Related: [[insights/substrate-is-digikoma-factory-2026-05-23]] uses "digikoma" as the general term; this feedback refines that — the *factory* produces both supplements and digikomas, but the term "digikoma" is properly scoped to turn-end bounded executors. [[savepoint]] skill is the canonical turn-end git digikoma already in the substrate. [[feedback_skills-as-inventory-items]] is the cost-side companion to this save-side framing. [[feedback_substrate-cost-circle]] is the cross-participant synthesis — extends digikoma-saves-agent-stamina to its operator-time twin (ghost-saves-operator-time), closing the substrate's economic model.
