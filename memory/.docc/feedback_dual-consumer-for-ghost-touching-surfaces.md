---
name: dual-consumer-for-ghost-touching-surfaces
description: "Every ghost-touching role surfaces as TWO actor-kind-tailored projections: app tailored to HUMANS performing the role, CLI + digikomas tailored to AGENTS performing the same role. Both surface the same typed records; tailoring differs by actor-kind, not by data."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

**Rule**: Every substrate role that touches a ghost ships TWO actor-kind-tailored surfaces from day one. The role is the invariant; the actor performing it determines the tailoring:

| Actor performing the role | Tailored surface | Why this ergonomic fits |
|---------------------------|------------------|------------------------|
| **Human** | **App** (Ghost.app for ghost-touching; CLIA Session Metrics.app for session-touching) | GUI affordances, sortable tables, modal supervision approvals, hover/click depth. Optimized for one-thing-at-a-time human focus. |
| **Agent** (interactive — claude/codex/etc. performing the role in a working session) | **CLI** (`<slug>@<org>.cli`) | Scriptable, composable, parallelizable, deterministic exit codes, typed JSON output. Optimized for agent reasoning over tool output. |
| **Digikoma** (bounded one-shot agent) | **Specific digikoma binary** (`digikoma-<role-slice>`) | One bounded slice of the role per binary. Even more constrained than the CLI: takes typed input, emits typed receipt, exits. Optimized for turn-end safe delegation. |

Same role; three surfaces. Records are shared across all three.

**Why this framing matters**: it makes agents first-class actors, not "scripts that pretend to be humans." When claude performs the ghost-summoner role, claude isn't "automating what a human would do in Ghost.app" — claude is performing the role themselves, using the agent-tailored surface (CLI). The CLI is not a "fallback for when the GUI isn't available"; it IS the role-surface for the agent actor.

**Enforced by**: `ghost-schemas v0.2.0`'s `GhostRuntimeWorkflowModel.appAndCLIShareRuntimeContract` invariant — `consumers.contains(.ghostApp) && consumers.contains(.ghostCLI)` is a `precondition` that rejects single-consumer workflows. The schema validator literally crashes on a ghost-touching workflow that omits either surface. Shipping without both surfaces violates a contract the substrate already enforces.

**Composes with** [[feedback_data-is-one-thing-rendering-is-projection]]: typed records are the data; the three surfaces are projections. The records don't fork by actor-kind; the renderings do.

**Composes with** [[feedback_clia-session-metrics-app-session-scorecards]] for the role split that picks WHICH app/CLI/digikoma family each surface belongs to (ghost-summoner → Ghost.app + `shadow@clia-org.cli` + `digikoma-shadow-*`; session-optimizer → CLIA Session Metrics.app + future `session-rate@clia-org.cli` + future session-optimizer digikomas).

**Safety implication**: when a role carries a safety boundary (e.g., shadowing's `ProposedActionEnvelope.supervisionRequired`), the enforcement lives at the **record + tool-wrapper layer**, not at any of the three projection layers. The boundary CANNOT be weakened by a renderer (human-tailored GUI or agent-tailored CLI) because the typed envelope refuses to encode "supervision skipped" — there is no flag at the projection layer; there is only the typed envelope and `common-process`'s refusal of unapproved proposed-action calls. This is critical when the actor is an AGENT (who might otherwise self-approve their own promotions) — the boundary is enforced agnostically across actor-kinds.

**How to apply**: when planning any new ghost-touching feature:
1. Identify the role it serves (e.g., ghost-summoner, session-optimizer).
2. Ship all three tailored surfaces in v0.1.0: app (human) + CLI (agent) + digikomas-as-needed (one per bounded slice the role needs to delegate).
3. None of the three may bypass the safety boundary. The typed envelope + wrapper enforcement is the boundary; the surfaces are just renderers.
4. A sanity test like `everyCLISubcommandHasAppEquivalent` in the macOS test target enforces app/CLI parity over time. A complementary test should enforce that no digikoma performs work the CLI doesn't expose (digikomas are bounded slices of CLI capability, not divergent surface area).

**Canonical example**: Shadowing (2026-05-26):
- **Ghost.app's Shadow tab** = ghost-summoner role tailored for HUMAN actors (the operator).
- **`shadow@clia-org.cli`** = ghost-summoner role tailored for AGENT actors (claude/codex performing ghost-summoner work in a session).
- **`digikoma-shadow-rating`, `digikoma-shadow-query`, etc.** = ghost-summoner role tailored for DIGIKOMA actors (bounded one-shot slices the agent delegates to).
All three read/write the same typed records (`ShadowQuery`, `ShadowRating`, `ShadowReadinessAggregate`, etc.). The promote/approve flows go through the same typed `SupervisionApproval` records regardless of which actor's surface initiated them.

**Operator quotes 2026-05-26**:
- "a digikoma can run this on the cli, but a human needs to be able to run this in Ghost.app."
- "ok, so we need the App surfaces to tailor to those 2 human roles. and the CLIs and digikoma to tailor to the agents performing those 2 roles."
