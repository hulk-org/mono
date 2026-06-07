---
name: clia-rpg-trainer-role-power-tool-product-vision
description: "The substrate's first concrete CLIA RPG product spec. Agents↔trainers, roles↔Pokémon, workflows↔moves/powers, tools↔move-cost/PP. 22 UI screen mappings derived from existing typed records. 3 invariants make the system playable AND substrate-coherent."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's CLIA RPG product vision lands 2026-05-31 with the complete functional mapping.

Operator 2026-05-31 (after substrate-workstream-loop discovery): "we now know the goal! pokemon style workflow encounters with all the necessary UI to display, agents, roles, workflows, tools, contribution types, etc. we know that agents can get ASSIGNED roles. and ROLES come with POWERS/ATTACKS which are workflows! and those workflows come with required tools."

**The core mapping** (Pokémon ↔ substrate):

```
Trainer → Pokémon → Moves (4 slots) → Move cost (PP/items)
   ↕          ↕            ↕                    ↕
Agent → Role → Workflow (as power/attack) → Required Tools
```

**Three invariants** that make the system playable AND substrate-coherent:

1. **Agents don't have direct powers** — agents wield powers via ASSIGNED roles only. An agent with no role assignments has no moves. Forces typed role-binding before any substrate-typed work.
2. **Roles carry their typed workflows + required tools** — role-surface-manifest enumerates moves (stateRefs[]) + tools (digikomaToolRefs[]). Switching roles switches move set.
3. **Workflows are tool-gated** — invoking workflow without required tools is forbidden per tool-exclusivity registry. UI shows tool-availability before move selection.

**22 UI screens mapped** (each renders mechanically from existing typed records):

| UI Screen | Substrate Data Source |
|---|---|
| Trainer Panel | agents/<slug>/.../identity + chronicle |
| Pokémon Roster | role assignments + role-surface-manifests |
| Role Detail Screen | role-surface-manifest + role-workflow |
| Move List | role-workflow stages + tool-exclusivity registry |
| Type Chart | typed interaction matrix (forward-pointing) |
| Tool Bag | kura-spaces/tools/v0.1.0/ |
| Encounter Screen | substrate-session-state-machine event + classification |
| Battle Screen | state-machine transitions trace + role contribution-mix |
| Status Panel | orthogonal-region error-inventory-tracker |
| Pokédex Screen | substrate-typed-record catalog |
| Map Screen | tool→role→workflow dispatch graph |
| Level Screen | minimization metrics + axiom citations |
| Evolution Sequence | axiom-promotion via 3x rule |
| PC Box | agents/<slug>/ persona surface archive |
| Gym Screen | workstream gate-set |
| Badge Case | gate-clearance receipts |
| Trade Screen | share-by-default skill |
| Save Screen | cascade-execution commit |
| ... | ... |

**Implementation strategy** (4 phases):

- Phase 1: Read-only views — Trainer Panel, Pokémon Roster, Role Detail, Move List, Tool Bag, Pokédex. Read typed JSON via Codable; render mechanically. Operator sees substrate as a Pokémon-style game.
- Phase 2: Live state views — Encounter, Battle, Status Panel. Renders live substrate-session-state-machine.
- Phase 3: Action surfaces — Pokéball capture invokes capture-state; move selection invokes workflow; role switching re-assigns; tool acquisition resolves gap signals.
- Phase 4: Long-term progression — Evolution sequences, Type Chart authoring, PC Box, Trade Screen.

**The substrate's distinguishing feature**: most idle RPGs have game state as the only state; CLIA RPG's game state IS the substrate's typed records. Every Trainer Panel shows a REAL agent; every Pokémon is a REAL role; every move is a REAL workflow; every battle is REAL typed work producing real loot. The substrate's growth IS the game's progression. Same thing, two surfaces.

**Why this is the closing recognition**:

The substrate's typed-everything trajectory + project_typed-models-quantum-state-machines-generative-ui = CLIA RPG. This vision lands the concrete implementation target. The substrate ALREADY has the typed records for Phase 1 read-only views. Implementation = SwiftUI views consuming typed JSON via Codable.

Composes with [[feedback_clia-rpg-product-identification]] (the product name) + [[feedback_substrate-IS-idle-rpg-encounter-battle]] (the mechanics) + [[feedback_substrate-workstream-loop-discovered]] (the META-CYCLE the UI surfaces) + [[feedback_substrate-IS-pokemon-formally]] (the formal correspondence) + [[feedback_tool-to-role-to-workflow-dispatch-graph]] (the dispatch graph the UI navigates) + [[user_operator-niantic-pokemon-go-lineage]] (production-validated UI design lineage).
