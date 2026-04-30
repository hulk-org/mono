---
name: Suikoden II patterns for agents framework
description: Design mechanics from Suikoden II (108 Stars, three combat scales, runes, Unite Attacks, cross-save) that rismay flagged as load-bearing for the substrate agents framework
type: project
originSessionId: 518cd36a-01ff-4af3-b27d-e0bdf07ab2ab
---
Design source for the substrate agents framework. Rismay flagged Suikoden II's mechanics as important for shaping how Komo/Tachikoma/agents/collectives compose.

**Why:** the game solves three problems the framework still has open — bounded capability per worker, declarative multi-agent combos, and recruitment-as-progression-state. These aren't ornamental; the mappings are direct.

**How to apply:** when designing new substrate primitives (factory output, roster gates, Stage World rehearsals, koma-plant/koma-lab evals), check against these analogues before inventing fresh terminology.

**Mechanic map:**

- **108 Stars of Destiny → roster completion gate.** Castle visibly grows as Stars join (shops, mini-games, NPCs). Substrate analogue: each commissioned home unlocks a visible capability slot. Partial roster = degraded outcomes; full roster = "true ending." `roster` skill already enumerates; what's missing is the visible deficit + capability-unlock loop.

- **Three combat scales, one world-state:**
  - Duel (1v1, RPS on dialogue tells) = operator ↔ single Komo, scan selection on observed signal.
  - 6-party battle = bounded multi-agent collab; Unite Attacks fire only when specific named members are co-present.
  - Army battle (hex map) = fleet-scale Komo deployment; characters can permadeath, gating the true ending.

- **Unite Attack registry (missing primitive).** Declarative typed surface where co-present agents declare a named combo with prerequisites + effect. Distinct from ad-hoc multi-agent assembly. Stage World should rehearse these before live substrate.

- **Runes + per-battle charges (not shared MP).** Equipped to head/hand/body slots; tier-N charges per battle, replenished between. Matches Tachikoma's "no mid-term memory, bounded context, per-engagement" model far better than a shared pool. Use as the scan-budget shape (formerly "trick-budget"; vocabulary retired per `feedback_no-pet-no-trick`).

- **Permadeath in army battles.** Individual Komo failure in long-running fleet tasks should count as recruit-loss against the 108, pressuring careful staffing. Luca Blight's three-stage fight is the rotating-party endurance pattern.

- **Cross-save (Suikoden I → II).** Surviving heroes carry levels/equipment forward. Substrate has chronicle continuity; Unite Attack mastery + rune affinity could persist alongside it.

- **Castle mini-games = lab/gym surfaces.** koma-lab, schema-lab, session-lab map onto cooking-duel/theater/card-game: optional sub-systems whose state matters for the broader run, not detached side content.

**Related memories:** project_tachikoma-factory, project_komo-execution-units, project_stage-world-gym, project_koma-gym-insight, project_koma-domain-architecture, project_koma-plant.
