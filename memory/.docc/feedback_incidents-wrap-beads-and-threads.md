---
name: incidents-wrap-beads-and-threads
description: "Substrate doctrine — incidents WRAP beads and threads (containment, not just reference). The three primitives don't merge; incidents are the encompassing context for the discrete work units that resolve them."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

Substrate doctrine, operator-confirmed 2026-05-30 (CLIA, incident-closure
session): "i think incidents can wrap beads and threads. so no merge for
now."

The three substrate work-tracking primitives do NOT merge:

- **Bead** = "someone fixes this when convenient" (= bug/ticket in
  industry terms). `<agent>/agenda/beads/<slug>.issue.json`. Lifecycle
  `open` → `closed`. Owner + priority. No freeze.
- **Thread** = "we coordinate on this." Multi-actor coordination scope.
- **Incident** = "everyone stops what they were doing and aligns to
  this until it's resolved." REQUIRES `IncidentBehaviorContract` (freeze
  scope + per-actor behaviorChanges + escalationOwners + resumptionCriteria).
  Lifecycle: declared → contained → resolved → post-mortem-complete →
  obsolete.

The relationship is **containment, not just reference**: incidents WRAP
their constituent beads and threads. The discrete work units (beads) and
the coordination scopes (threads) live INSIDE the incident's resolution
arc; they don't stand on their own once an incident pulls them in.

**Why:** the merge temptation is real — all three are "things that need
to happen, with status + owner + evidence." But the type discriminator
that prevents the merge is **the BehaviorContract requirement** — incidents
alter what *other people are allowed to do* during the window. Bugs/beads
don't. `IncidentFreezeScope.kind: "none"` is explicitly INVALID at the
type level per the doc-comment: "use bead or thread instead." Substrate
already enforces "if you have nothing to pause, you don't have an incident."

**How to apply:**

- When authoring a record that needs status tracking, ask first: **can I
  fill an `IncidentBehaviorContract`?** If yes → incident. If no →
  bead (single discrete unit) or thread (multi-actor coordination).
- Existing IncidentModel fields already encode the containment:
  - `relatedBeads: [LinkRefModel]` — beads the incident wraps
  - `relatedThread: LinkRefModel?` — coordinating thread the incident
    wraps
- When closing an incident, also close (or transition) its wrapped beads
  and threads — they don't outlive the incident's resolution arc unless
  they had standalone reasons before the incident wrapped them.
- The substrate doctrine here is **deliberately stricter than industry
  defaults** (Jira/Linear/GitHub Issues conflate via a `type` field on a
  single Issue model). Substrate eats the schema-authoring cost to prevent
  the silent-divergence class of error (incident misclassified as bug →
  freeze never activates → behavior diverges without alarm).

Concrete instance from this session: the 4-way sub-incident split each
wraps 1-3 catch beads via `relatedBeads[]`. The beads are the discrete
resolution work; the sub-incidents are the wrapping behavior-change
context. Operator quote: "great call" on keeping them distinct.

Composes with the substrate's incident-vs-bead-vs-thread type
discriminator (`IncidentModel.swift` doc-comment) and with
[[feedback_data-is-one-thing-rendering-is-projection]] (incidents and
beads render differently because their *kinds* differ — incident shows
in harness banner; beads stay in agent-local agenda).
