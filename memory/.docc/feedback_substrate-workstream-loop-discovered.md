---
name: substrate-workstream-loop-discovered
description: "The substrate's typed META-CYCLE — every workflow we authored connects into a single recurring loop. 3 sequential phases (creative-selection → spawn-software → maintain-software) + 6 orthogonal infrastructure workflows (unknown-workflow / cascade-task-creation+execution / retroactive-packetization / capture-state / workflow-creation / library-extraction-for-testability). Typed handoffs at every connection."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's typed workstream loop closes 2026-05-31. Operator named it: "we just discovered the workflows necessary in the workstream loop. and how they connect!"

**The substrate has typed:**

3 sequential phases (the main loop):
1. **creative-selection** — 5 sub-workflows (signal-framing → claim-research → option-inventory → fit-review → spawn-request-assembly) — produces `spawn-request-packet`
2. **spawn-software** — 11 typed gates — produces shipped software + `maintenance-handoff-packet` + `monitoring-posture-packet`
3. **maintain-software** — in-service stewardship — produces operational signals (feeds back to creative-selection)

6 orthogonal infrastructure workflows (run alongside):
- **unknown-workflow** — entry classification for every chat-turn-event
- **cascade-task-creation + cascade-execution** — typed commit infrastructure
- **retroactive-packetization** — recovery when phases are skipped
- **capture-state** (formerly wd) — end-of-phase capture into typed records
- **workflow-creation** — self-extension when no workflow matches
- **library-extraction-for-testability** — Swift refactor sub-pattern

**4 typed handoffs between main phases:**

| Source | Artifact | Target | Schema home |
|---|---|---|---|
| creative-selection | spawn-request-packet | spawn-software | spawn-software-packet-schemas/v0.1.0/ |
| spawn-software | maintenance-handoff-packet | maintain-software | spawn-software-packet-schemas/v0.1.0/ |
| spawn-software | monitoring-posture-packet | maintain-software | spawn-software-packet-schemas/v0.1.0/ |
| maintain-software | operational-signals (via chronicle-techo + beads) | creative-selection.creative-signal-framing | schema-family forward-pointing |

**6 orthogonal connection points:**

- unknown-workflow → ALL phases (first entry)
- cascade workflows → ALL phases (when ≥3 records or ≥3 submodules touched)
- retroactive-packetization → ALL phases (when typed evidence missing)
- capture-state → ALL phases (end-of-phase loot capture)
- workflow-creation → unknown-workflow gap (self-extension)
- library-extraction-for-testability → spawn-software.qa-evidence + maintain-software (Swift refactor)

**Why this matters:**

- Before 2026-05-31, individual workflows were typed but the loop connecting them was implicit
- The substrate had `creative-selection.workflow-series.json` (2026-05-29) and `spawn-software.workstream-template.json` (referenced as downstream) — but the LOOP shape connecting creative-selection → spawn-software → maintain-software → creative-selection wasn't explicitly typed
- This session ran the loop (mainly creative-selection) without naming it; operator surfaced the recognition; loop typed at substrate-game/v0.1.0/substrate-workstream-loop.md
- Substrate growth direction is now: **complete iterations of the loop**. Each cycle ships typed product. Each cycle's maintain-software signals feed next creative-selection. Orthogonal infrastructure ensures every cycle is typed-committed, captured, recovered if skipped.

**CLIA RPG composition**: the substrate's workstream loop IS CLIA RPG's gameplay loop. Random encounter = chat-turn-event into unknown-workflow → classifies into loop phase. Battle = phase workflow runs. Loot = typed handoff artifact. Boss encounter = end-of-phase handoff. Save point = cascade-execution. XP = minimization metrics descending. Level-up = axiom promotion (3x rule). New region unlocked = workflow-creation extending the loop. Same loop, two angles (substrate doctrine vs playable game mechanics).

**Apple creative-selection lineage**: Apple's design culture is demo → critique → refine → demo. The substrate's workstream loop is the formal typed version with typed handoffs replacing demo-meeting handshakes. Ken Kocienda's iterative refinement process informs the substrate's META-CYCLE.

**How to apply:**

- When designing new workflows, identify their position in the loop (sequential phase vs orthogonal infrastructure)
- When typed handoff artifacts are missing between phases, type them — the loop's typed-handoff discipline is non-negotiable
- When a session walks the loop without naming it (as this session did with creative-selection), retroactive packetization is the recovery (we ran this TWICE today — md@swift-universal.cli's spawn-software walk + this session's creative-selection walk)
- The substrate's growth is loop iterations. Count them.

**Future work:**

- Type maintain-software → creative-selection handoff explicitly as an `operational-signal-packet` schema family (currently typed through chronicle-techo + bead surfacing)
- Type orthogonal-infrastructure-to-main-phase connections as typed events on substrate-session-state-machine
- Visualize the loop as mermaid/graphviz from typed records (generative-UI derives mechanically)

Composes with [[feedback_session-WAS-creative-selection-retroactively-recognized]] (creative-selection stage recognition) + [[feedback_clia-rpg-product-identification]] (CLIA RPG's gameplay loop = this workstream loop) + [[feedback_everything-is-quantum-state-machine]] (loop is a typed QHsm at the meta-cycle layer) + [[feedback_retroactive-packetization-is-the-recovery-protocol]] (recovery for unnamed loop walks).
