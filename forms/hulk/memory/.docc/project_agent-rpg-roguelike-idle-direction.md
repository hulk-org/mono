---
name: agent-rpg-roguelike-idle-direction
description: "agent-rpg's future direction (named 2026-05-30) is a roguelike + idle game hybrid — supersedes the Game Dev Story framing in project_clia-rpg-game-dev-story.md. CLIA Roles stays role-management-only; the game lineage lives in agent-rpg."
metadata:
  node_type: memory
  type: project
  originSessionId: 63b20b14-eef6-46d7-bfb3-d5c6b3ae095b
---

Operator named agent-rpg's future direction 2026-05-30 (CLIA session,
during clia-roles app scaffolding): "what that Playing Game will be
like is more like a roguelike + idle game in the future."

**Why:** Roguelike + idle is structurally substrate-shaped in ways
that Game Dev Story (earlier framing) wasn't:
- Roguelike *runs* ↔ substrate *sessions* (each lands in git,
  permadeath via commit history, can't re-roll — already documented
  in ontology.docc as Gap 9 divergence from JRPG canon)
- Idle progression ↔ substrate background work (agents continue
  between operator-active sessions; resources accumulate without
  active steering)
- Procedural generation ↔ substrate's casting-graph variability
  formula (organisms × roles × harnesses × collectives × audiences)

**How to apply:**
- The Game Dev Story framing in [[project_clia-rpg-game-dev-story]] is
  SUPERSEDED in genre terms. Architectural insights (agents-as-devs,
  directories-as-rooms, Digikoma-as-sprites) may still partially apply
  under roguelike+idle, but the wrapper changed.
- agent-rpg keeps its directory name; the genre pivot happens in
  place. No rename to "playing-game" or similar — the "Playing Game"
  phrasing was an operator pun on removing the Roles from Role-Playing
  Game (RPG → PG), not a real proposed name.
- CLIA Roles (`clia-app-org/.../clia-roles/`) stays
  role-management-only. The genre work does NOT migrate into clia-roles.
- Future architecture docs in `agent-rpg.architecture.docc/` will need
  to reflect the genre pivot — existing pages (`game-dev-story-world-model.md`,
  `sorcerian-scenario-model.md`) describe earlier framings; new
  roguelike+idle architecture pages will land alongside them, not
  replace them silently.
