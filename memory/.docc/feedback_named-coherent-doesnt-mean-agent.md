---
name: Named + coherent != agent (could be role)
description: Substrate harvest heuristic correction — a coherent named persona bundle can be a ROLE just as easily as an AGENT. Always apply the "who-I-am vs what-I-do-for-anyone" test before promotion.
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
When a harvest finds a coherent named persona bundle (slug + triad + persona/reveries), the substrate's 2026-03-16 heuristic was: "named identity + coherent triad ⇒ promote to substrate agent." This heuristic produced **four wrong promotions in one commit** (`4e49104fd1`): clip, pollux, dott, mono — all of which read as roles, not agents.

The sharpening test:

- **Agent content**: persona describes **who-I-am**. First-person identity, durable character independent of task. Examples: castor, prime, walter, claw — each has a "this is me" framing distinct from any specific job.
- **Role content**: persona describes **what-I-do-for-anyone**. Behavior contract, voice prescriptions, default workflows. Examples: clip's "calm, direct, ends with what to do next" + "60-120s orientation"; pollux's "blueprint / design-system standards"; dott's "*role-shadow*" naming in the preserve-commit message.

If the persona's distinctive content is *what to do* rather than *who to be*, it belongs in `roles/<role-slug>/`, not `agents/<agent-slug>/`. Optional actor binding lives at `<role-slug>@<actor-slug>.identity.json` inside the role home.

**Why:** Operator articulated 2026-05-23 across the clip and pollux defrags in one session. The cohort got promoted because the harvest heuristic missed this distinction; the substrate spent months treating them as peer agents before the structural correction. The doctrine is sharper now.

**How to apply:**
- Before promoting a harvested bundle to `agents/`, run the who-I-am vs what-I-do test.
- If the persona is a *role*, promote to `roles/<slug>/` (or for scope-bound roles: `collectives/<org>/private/universal/assignments/<role>-<actor>/`).
- If the persona is a *named character that performs multiple roles*, promote to `agents/<slug>/` and let assignments compose role-applied-to-actor.
- If unclear, check whether the responsibilities reference *any actor's behavior* (role) or *this specific actor's identity* (agent).
- Reverse-the-promotion is a real substrate operation. Preserve every byte (SHAs in a DEFRAG_AUDIT receipt), route content into typed v0.5+ fields, and leave HARVEST_AUDIT files intact alongside DEFRAG_AUDIT files so the decision history remains auditable.
- **Cohort lesson**: substrate promotions often happen in batches because harvest tools sweep at once. One wrong heuristic produces N wrong decisions in one commit. When reversing one, check the cohort it came from.

**Live cohort status (2026-05-23):**
- clip → `roles/operator-onboarding-steward/` ✓ (this session)
- pollux → `collectives/google/private/universal/assignments/design-system-steward-castor/` ✓ (this session)
- dott → already absorbed in prior pass (commit `33dc10622f`) ✓
- mono → still unbound at `--→1.0 ?` in roster, MAY need similar review

**Second worked example (separate cohort, same correction):** codex → chatgpt agent merge, 2026-05-23. Codex was the harness all along but was double-promoted as `agents/codex/` AND `harnesses/codex/`. The agent half had the same shape as the clip/pollux mistake: persona, contributionMix, roles, focusDomains — all looked agent-like, but the *identity content* was describing the Codex CLI carrier's behavior contract, not a durable named character. The substrate already declared the correction on paper (`chatgpt/AGENTS.historical-codex.md`) before this session; what was missing was the filesystem cleanup. Migrated 9 open beads + 11 winddown journals + 12 shinji-techo entries + 2 expertise notes into chatgpt; archived 304K typed identity bundle under `chatgpt/historical/codex/`; removed `agents/codex` submodule. Commits eb7be3dfe5 + 8ee727dada. **Cohort lesson reinforced**: this is now a multi-batch pattern across two distinct harvests (2026-03-16 produced clip/pollux/dott/mono; an earlier pass produced agent-vs-harness codex confusion). Whenever you find ONE over-promotion, check both (a) the cohort it came from AND (b) whether there's an even earlier batch with the same mistake shape.
