---
name: clia-session-metrics-app-session-scorecards
description: "Substrate's two human-facing apps map to two named typed roles. Ghost.app is the role-surface for ghost-summoner (summons/trains/promotes/supervises specific ghost bundles); CLIA Session Metrics.app is the role-surface for session-optimizer (rates landed sessions, finds drains, drives continuous improvement). Same human can wear both hats; the apps ARE the role-surfaces, not just data-shape splits."
metadata:
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

**Rule**: The substrate has TWO named roles. Each role has THREE actor-kind-tailored surfaces per [[feedback_dual-consumer-for-ghost-touching-surfaces]]. The apps are the role-surfaces tailored for HUMAN actors performing the role; the CLIs and digikomas are tailored for AGENT actors performing the same role.

**Full role × actor-kind matrix:**

| Role | Human surface (app) | Agent surface (interactive) | Agent surface (one-shot digikoma) |
|------|--------------------|-----------------------------|-----------------------------------|
| **`ghost-summoner`** — summons (trains via LoRA), promotes, supervises, queries specific ghost bundles | **Ghost.app › Shadow tab** | `shadow@clia-org.cli` | `digikoma-shadow-rating`, `digikoma-shadow-query`, etc. (one per bounded slice) |
| **`session-optimizer`** — reviews landed sessions for cost/rank/drains, tunes thresholds, retires categories, surfaces retraining candidates | **CLIA Session Metrics.app** | future `session-rate@clia-org.cli` (TBD) | future session-optimizer digikomas (TBD) |

Each role's three surfaces serve **the same role**; the differences are purely ergonomic per actor-kind:
- Human surface = GUI affordances, sortable tables, modal approvals, hover/click depth.
- Agent CLI = scriptable, composable, typed JSON output, parallelizable.
- Digikoma = bounded one-shot slice, takes typed input, emits typed receipt.

A single human can wear both role hats at different moments. Agents performing either role use the agent-tailored surfaces (CLI + digikomas), not the human-tailored apps (apps have no headless surface).

**Role framing — why these names matter**:
- **"summoner"** = ritual invocation. Training a ghost from operator decisions is a ritual — the operator's recorded judgments become the corpus that summons a LoRA-aligned ghost.
- **"optimizer"** = Kaizen. This role doesn't just review; it acts on what it sees. Continuous improvement, not passive observation.

**Diagnostic — which app does my new view belong to?**

Ask: **which named role is this view for?** Not what data it walks, not what the keying axis is.

- "I'm summoning/training/promoting/supervising a specific ghost" → ghost-summoner → **Ghost.app**
- "I'm reviewing landed sessions and acting on what I see" → session-optimizer → **CLIA Session Metrics.app**

The keying axis is a *symptom* of the role split, not the cause:
- ghost-summoner views are usually keyed `(ghost)` or `(ghost, category)` because the summoner holds a ghost fixed and looks at it.
- session-optimizer views are usually keyed `(sessionId)` because the optimizer holds a session fixed and looks at it.
- **But**: shadowing's ratio-report walks session-level records to compute (ghost, category) rows — it's a ghost-summoner view (Ghost.app) even though session-level data is its input. The role wins, not the input data shape.

**Why**: this matches the substrate's existing app-shape doctrine. Apps exist to serve **a primary role's task**. A surface that tries to serve two roles at once becomes a category-mixed dashboard nobody can navigate. Two apps with clear role boundaries are easier to learn, easier to operate, and easier to staff (a human stepping into the ghost-summoner role doesn't need to learn the session-optimizer's vocabulary, and vice versa).

**Composition examples**:

- Shadowing's UX split (canonical, 2026-05-26):
  - **In Ghost.app**: readiness table, promote/approve actions, query panel, ratio-by-ghost dashboard. All ghost-summoner role.
  - **In CLIA Session Metrics.app**: per-session SessionRating scorecard with shadow-improvement contribution as one axis (future v0.2.0 work). Session-optimizer role; shadowing's contribution shows up *as a column* in the session scorecard, not as the primary content.
- Future `session-rating-schemas v0.1.0`: lives in CLIA Session Metrics.app exclusively (the per-session encounter-complete view IS the session-optimizer's primary role-surface).
- Future `GhostTrainingRunModel` GUI for triggering retrains: lives in Ghost.app (ghost-summoner role).
- Stamina + operator-time per-session charts: live in CLIA Session Metrics.app (session-optimizer role). Per-ghost rollups of the same data live in Ghost.app (ghost-summoner role — "how expensive is this ghost?").

**Role-typing status (2026-05-26)**: typed role homes `roles/ghost-summoner/` and `roles/session-optimizer/` are operator-named today, **not yet instantiated** as `identity.json` + `agenda.json` + `chronicle.json` triads under `private/universal/substrate/roles/`. When they land, they get the standard owner-tier home shape. The existing `roles/ghost-writer/` is a DIFFERENT role — it's video-content writing for GHOST video productions (per `ghost-writer.org-role.json` tags `comedy`/`ghost-video`/`video-production`), not ghost-bundle summoning. Do NOT conflate.

**How to apply**:
- When planning any new metric/dashboard/management surface, ask "which role is this for?" before "what data does it show?" The role answer picks the app.
- When updating PRDs or design docs, name the role explicitly: "this is the ghost-summoner's view" or "this is the session-optimizer's view." The clarity prevents the surface from drifting into the wrong app.
- Both apps follow [[feedback_dual-consumer-for-ghost-touching-surfaces]] for their CLI siblings: anything reachable from either app must also be reachable from a CLI for digikomas/scripts.
- Per [[feedback_data-is-one-thing-rendering-is-projection]]: the apps are projections, not data owners. Both walk the same typed records under `schema-universal/` (e.g., `stamina-usage-metrics-schemas`, `operator-time-metrics-schemas`, `shadowing-schemas`, future `session-rating-schemas`).

**Canonical example**: Shadowing (2026-05-26). Ghost.app's Shadow tab serves the **ghost-summoner** role (readiness, promote, query, supervise). CLIA Session Metrics.app serves the **session-optimizer** role (when future SessionRating ships, shadow-improvement contribution renders as one of its axes). Both apps surface the same underlying records — neither owns the data. See `private/universal/vaults/shadowing/shadowing.docc/architecture.md` (Surface boundary section).

**Operator quotes 2026-05-26**:
- "CLIA Session Metrics.app is where we will see these session scorecards."
- "this is for the roles: one is creating a ghost. one is reviewing sessions. 2 different tasks."
- "so these views in apps imply roles right? ghost-summoner and session-optimizer?"
