---
name: substrate-is-idle-rpg-encounter-battle
description: The substrate is an idle RPG. Operator chat turns are random encounters; workflows are battles; capture-state records loot to the Pokédex. Encounter + battle system formalizes how the substrate works as a PLAYABLE game.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate is an **idle RPG** with formal encounter + battle systems.

Operator 2026-05-31 (after Pokémon correspondence + Niantic lineage disclosure): "essentially what we are describing this UI to be is: an idle RPG. and we need to define the encounter system / the battle system in order for us to capture the state. and basically: you go into these battles, etc. this explains RANDOM encounters! omg."

**Why idle RPG (not continuous-action)**:

The substrate is idle most of the time (agent in unknown-workflow / informal-mode). Operator attention arrives in discrete bursts as chat turns. This matches idle RPG mechanics (Cookie Clicker, AdVenture Capitalist, Egg Inc., Idle Heroes, Pokémon Go) — accumulate state in background; present discrete encounters when player checks in.

**The encounter system** (when battles fire):

| Encounter type | Trigger | Workflow analog |
|---|---|---|
| random-encounter | Operator chat-turn unannounced; classify | unknown-workflow stage 3 |
| scripted-encounter | Operator-named exclusive trigger (/wd, /cascade) | named-trigger-handoff |
| boss-encounter | Major directive → axiom promotion / schema deprecation | substrate-wide-cascade + 3x-rule promotion |
| mini-boss-encounter | Multi-stage workflow (spawn-software, cascade-execution) | typed workstream walk |
| trash-mob | Small clarification | informal-mode-eligible OR quick handoff |
| ambush-encounter | Operator-surfaced doctrinal violation | retroactive-packetization recovery |
| story-battle | Workflow advancing narrative arc | spawn-software, substrate-game sessions |
| side-quest | Optional operator tangent | informal-mode OR small handoff |
| preemption | context-limit-approaching priority | automatic transition to capture-state |

**The battle system** (how battles resolve):

- **Turn order**: per chat-turn RTC
- **HP**: context budget remaining
- **MP**: attention/working-memory budget
- **Moves**: role's contribution-mix entries
- **Targeting**: which substrate-typed entity the move affects
- **Critical hit**: operator-named exclusive trigger (1-turn classification)
- **Miss**: silent classification (typed error)
- **Status effects**: error-taxonomy categories as debuffs (Confused / Cursed / Forgetful / Disoriented / Out-of-order / Slow / Blind / Poisoned)
- **Win**: exitGate cleared → capture-state fires
- **Loss**: loss-condition triggered → rollback
- **XP**: minimization-tracker metrics descending
- **Level-up**: axiom promotion via 3x rule
- **Loot**: typed records (axioms, refinements, beads, techo entries)
- **Boss loot**: substrate-wide cascade landings

**Random encounters explained**: in JRPGs, random encounters fire per probability tables; the player walks the field and battles trigger when probability fires. Substrate equivalent: operator chat turns arrive unannounced; each chat turn IS an encounter (random if unprompted; scripted if operator-named-trigger). The randomness isn't chaos — it's the encounter system firing per operator-attention-pattern. **The agent's job is to be READY when one fires.**

**Why naming this matters**: before this framing, the substrate's behavior felt slightly improvised because the agent treated chat turns as continuous engagement. With encounter+battle typed:

- Chat turns are discrete encounters, not continuous interaction
- Predictable battle interface (state machine shows current battle, available moves, target options)
- Explicit win/loss conditions (exitGate vs loss-condition trigger)
- Mechanical loot capture (capture-state fires post-battle)
- Long-term progression curves (minimization metrics; substrate KNOWS when it's leveling up)
- The substrate becomes **playable** — operator + agent engage it the same way players engage a JRPG

**Composition with existing substrate records**:

- substrate-session-state-machine = the world map
- unknown-workflow = idle/exploration state
- Workflows = battle scenes
- Roles = characters with move sets
- Tools = moves
- tool-exclusivity-registry = encounter classifier
- wd/capture-state = post-battle loot capture
- minimization-program = XP/leveling curve
- error-taxonomy = status-effects catalog
- loss-conditions = game-over triggers
- cascade-execution = save-game commit
- MEMORY.md + axioms + workflows + tools = the Pokédex

**Future authoring**:

- encounter-classifier.skill at substrate/skills/encounter-classifier/
- battle-interface.workflow at kura-spaces/workflows/battle-interface/
- loot-table.json
- encounter-probability-table.json
- battle-receipt-schema for typed battle outcomes

**Substrate-typed records landed 2026-05-31**:

- Doctrine page: kura-spaces/substrate-game/v0.1.0/substrate-encounter-and-battle-system.md
- Extension: x-idle-rpg-doctrine on substrate-session-state-machine.json (encounter types + battle mechanics + status effects mapping + XP curves + future authoring targets)

Composes with [[feedback_substrate-IS-pokemon-formally]] (Pokémon is the worked-example precedent) + [[feedback_everything-is-quantum-state-machine]] (battles ARE state-machine transitions) + [[feedback_event-is-chat-turn]] (chat-turn-as-encounter) + [[feedback_wd-is-capture-pokeball-throw]] (post-battle loot capture mechanic) + [[user_operator-niantic-pokemon-go-lineage]] (idle-RPG production lineage informs this framing).
