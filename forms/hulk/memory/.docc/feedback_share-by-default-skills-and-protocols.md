---
name: share-by-default-skills-and-protocols
description: "Skills and operating-protocols that apply to >1 agent live at community homes (collectives/wrkstrm/.../operating-protocols/), NOT at personal agent homes. Share-by-default; hoard only when the protocol is genuinely agent-specific."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

Skills and operating-protocols that apply to MORE THAN ONE agent — including those that cite community-wide axioms, write to community-shared lanes, or encode substrate-doctrine — live at community homes. Default location for typed `OperatingProtocolModel` instances: `private/universal/substrate/collectives/wrkstrm/private/universal/operating-protocols/<slug>.operating-protocol.json` (matching the `wrkstrm-operating-beliefs.operating-protocol.json` precedent). Personal homes (`agents/<slug>/private/universal/skills/<slug>/`) are reserved for agent-specific protocols that genuinely differ per agent.

**Why:** operator 2026-05-31 (CLIA, gently teasing after I anchored wd at agents/claude/private/.../skills/wd/ for the whole session): "why are you so greedy? haha. you can share!" The same wd discipline applies to claude, carrie, clia, codex, catch, hermes, and every other substrate agent. Anchoring it at one agent's personal home implies the doctrine is that agent's property, not the substrate's. It also forces other agents either (a) to cross-reach into claude's personal tree (anti-pattern per personal-vs-community-lanes axiom), (b) to fork the skill into their own home (drift + duplication), or (c) to silently skip the discipline (substrate loses the contract).

**How to apply:**

- For a NEW skill/protocol: ask "does this apply to >1 agent?" before choosing the home. If yes → community home from day one. If no → personal home, but verify it's genuinely agent-specific (not just "I'm the first agent who thought of this").
- For an EXISTING skill at a personal home that should be shared: move to community home (see wd 2026-05-31 move precedent — protocol + SOP files moved from `agents/claude/private/universal/skills/wd/` to `collectives/wrkstrm/private/universal/operating-protocols/`).
- Update SKILL.md "Canonical homes" sections to point at the new community location. SKILL.md remains at `substrate/skills/<slug>/` (or `~/.claude/skills/<slug>/`) — the registration surface stays per-harness; only the protocol + SOP move.
- Grep for inbound LinkRef refs at axioms / techo entries / other operating-protocols pointing at the old path; sed-update them. The wd move touched 10 axiom files.
- The SKILL.md "Canonical homes" section should EXPLICITLY note community vs personal layering — without that, future agents inherit whichever location is documented as canonical and re-derive the wrong shape (the contract-clarity error compounds).

**Diagnostic for whether a personal-home skill should be shared:**

- Does it cite community axioms (kura-spaces/axioms/)? → community home
- Does it write to community-shared lanes (substrate-wide shinji-techo, kura collections)? → community home
- Does its operating-protocol describe a discipline rather than a personal preference? → community home
- Does it use harness-shared tools (agent-timeline-cli, digikoma-git, harness CLI)? → community home

If 2+ apply, the skill is community by nature.

Composes with [[feedback_error-taxonomy-maps-to-workstream-layer]] (this is a layer-confusion error in the taxonomy) + [[feedback_personal-vs-community-lanes-distinct]] (the parent doctrine: personal identity stays personal until promoted; community discipline lives in community from the start).
