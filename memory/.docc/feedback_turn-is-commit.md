---
name: turn-is-commit
description: "Chat-turn IS commit. The substrate's RTC boundary at the chat-turn level matches the substrate's persistence boundary at the git-commit level. turn = event = transition = receipt = commit. Same atomic unit at different layers. The substrate's chronicle log and git log are the same log viewed through different surfaces."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's atomic unit identity:

**turn = event = transition = receipt = commit**

Operator 2026-05-31 (after two workstream Swift Packages landed via one encounter): "i think that we have to take turns to mean commits..."

**Why this identity holds:**

- **event-is-chat-turn** doctrine (x-event-is-chat-turn on substrate-session-state-machine): one chat turn = one event at the session state machine
- **everything-is-quantum-state-machine** axiom: each event fires a typed transition with run-to-completion semantics
- **winddown-incomplete-until-committed** axiom: typed records are invisible to next session until committed
- **chat-turn-as-RTC-boundary**: each turn completes atomically before next fires

If turn = event = transition, then **turn = commit** makes the persistence layer match the QHsm RTC boundary exactly. The substrate's chronicle log and the substrate's git log become **the same log viewed through different surfaces**.

**Operational consequences:**

- Every meaningful turn ends with a commit (or explicit zero-commit acknowledgment for informal-mode turns)
- Each commit message quotes the operator directive that triggered the turn
- `git log` and the chronicle Shinji Techo lane become equivalent — different surfaces, same event sequence
- Reverting a commit reverts the turn's effects (true rollback)
- Pre-commit hooks become the substrate's RTC verification
- The substrate's `no-remote-push` axiom + `turn = commit` = "no remote push of turns until operator approves push"

**Scope ↔ commit-shape mapping** (per substrate-wide-cascade-pattern):

| Turn type | Commit shape |
|---|---|
| **trash-mob turn** (1 record, 1 submodule) | Single focused commit |
| **mini-boss turn** (3+ records OR 3+ submodules) | Cascade per substrate-wide-cascade-pattern (per-submodule + mono umbrella) |
| **boss turn** (substantial typed-doctrine landing) | Cascade with explicit retroactive receipts |
| **informal-mode turn** (no substrate-typed writes per informal-mode) | Explicit zero-commit acknowledgment |
| **capture-state turn** (wd-style explicit capture) | Receipt + chronicle techo + commit cascade |

**The substrate has been doing this implicitly:**

Every meaningful turn this 2026-05-31 session ended in commits. ~52 commits across mono + 4 submodules; each commit's message quoted operator directives + composed with substrate doctrine. The identity was operationally present without being named.

**Recursive proof:** the turn that types `turn = commit` MUST end in a commit. The doctrine proves itself by being persisted.

**Composes with chemistry framing** (substrate-composes-typed-idea-molecules): if molecules are typed-record compositions, then commits are the substrate's chemical reactions — discrete atomic transformations that produce molecular yield. Each turn = one reaction = one commit = one Pokédex entry added.

**Composes with CLIA RPG**: each chat turn IS a battle round; each commit IS the battle's receipt + loot drop. The substrate's git log becomes CLIA RPG's battle history.

**How to apply:**

- After every substantive turn, commit before responding to the operator (or explicitly note "no substrate-typed writes this turn; informal-mode receipt")
- Compose commit messages from the operator directive verbatim quote + the substrate-doctrine being applied
- For boss turns, run cascade-task-creation → cascade-execution per the typed workflow pair
- For trash-mob turns, single focused commit suffices
- Per cascade-execution.verify-expected-state: each commit should leave the substrate in a verified state (build clean, tests pass)

**Future axiom-promotion candidate**: this identity + everything-is-quantum-state-machine + workstreams-as-Swift-Packages + chemistry-of-typed-ideas = the meta-pattern "substrate-typed-everything-converges-on-Git+SwiftPM-as-typed-truth-infrastructure" may earn axiom promotion if a 4th instance surfaces.

Composes with [[feedback_event-is-chat-turn]] (turn=event) + [[feedback_everything-is-quantum-state-machine]] (event drives typed transition) + [[feedback_substrate-wide-cascade-pattern]] (scope→commit-shape mapping) + [[feedback_wd-is-capture-pokeball-throw]] (each turn captures into Pokédex via commit) + [[feedback_substrate-composes-typed-idea-molecules]] (commits are chemical reactions).
