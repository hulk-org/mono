---
name: ghost-as-process-group-commander
description: "A ghost commanding a typed PROCESS GROUP (not just one subprocess) is the substrate's PRODUCTION shape; safe-paired with session isolation (createSession + processGroupID); CLIA RPG Trainer↔Team made structural"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31 after swift-subprocess 0.5 migration revealed `PlatformOptions.processGroupID` + `createSession` + `toProcessGroup:` axes: "process group is HUGE. this allows a ghost to add to a process group!"

**Rule**: The substrate's ghost-process model evolves from SINGLE-PROCESS (MVP shape) to PROCESS-GROUP COMMANDER (production shape). A ghost can:

1. **Create its own typed process group**: `PlatformOptions(processGroupID: 0, createSession: true)` — child becomes own group leader, session-isolated, terminal-detached, parent-protected.
2. **Add external processes to its group**: via `setpgid()` post-spawn; absorbing a stray process under the ghost's authority.
3. **Broadcast signals safely**: `.send(signal:, toProcessGroup: true)` and `.gracefulShutDown(toProcessGroup: true, allowedDurationToNextStep:)` — targets ONLY the ghost's group, NOT the parent (because session-isolated).
4. **Auto-teardown on cancellation**: `PlatformOptions.teardownSequence: [TeardownStep]` baked at spawn; the platform auto-fires the sequence when the ghost's task cancels — no manual cancel call needed.

**Why**: per swift-subprocess 0.5's typed PlatformOptions design + the substrate's typed-everything direction + [[feedback_clia-rpg-trainer-role-power-tool-product-vision]] (Trainer↔Team mapping). A ghost is no longer just a single-subprocess spawner — it's a typed COMMANDER of a typed TEAM (process group) where:
- Group members are typed subprocesses (each Pokémon-shape)
- Group-level signals = area-of-effect battle moves
- Session isolation = encounter-boundary mechanic from CLIA RPG
- The trainer (operator/agent) commands the ghost; the ghost commands its team; the team executes typed workflows cooperatively

**Safe-pairing axiom** (from swift-subprocess 0.5 `gracefulShutDown` doc):

> *"When sending the signal to the process group, unless you also set `createSession` to `true`, or `processGroupID` to a non-inherited value, the targeted process group includes the parent process. **Pair `toProcessGroup` with `createSession` to isolate the subprocess and its descendants in their own session.**"*

The substrate's typed wrapper around PlatformOptions MUST enforce: `toProcessGroup: true` REQUIRES (`createSession: true` OR `processGroupID != nil`). This is a Curry-Howard-shaped compile-time constraint — a `SafeGroupOptions` typed-noun-wrapper that makes the dangerous combo unrepresentable.

**How to apply**:
- When authoring a substrate-typed ghost that spawns multiple subprocesses, use a `ProcessGroupSpec`-shaped typed noun (composes N CommandSpecs under one group identity).
- When designing typed teardown protocols at runner-agnostic layers, include `toProcessGroup: Bool` axis on every step; pair with session-isolation typed flag.
- When granting authority to ghosts (substrate-permission system), use typed `GhostProcessAuthority` enum: `.singleProcess`, `.selfOwnedGroup`, `.observerOnly`, `.shareGroupWith(<ghost-slug>)`, etc.
- Per [[feedback_workstream-ghost-chat-protocol-super-attack]] + [[feedback_clia-is-cli-assistant-form-factor]] — `.clia` ghosts gain typed group-spawn capability when their workflows compose multiple processes.

**Operational consequences**:
- CLIA RPG battles where a ghost casts a multi-process workflow are now structurally typed at the substrate layer, not ad-hoc.
- Per [[feedback_event-is-chat-turn]] + [[feedback_turn-is-commit]] — a chat-turn ending automatically cleans its spawned group via the typed teardown sequence baked at spawn. Substrate-typed lifecycle becomes structural.
- The substrate's typed-receipt discipline gains a group-level receipt shape: per-member receipts + a typed group-receipt with aggregated exit status, total wall-clock, group-teardown evidence.
- New typed-axiom-promotion candidate: per [[feedback_substrate-wide-cascade-pattern]] 3x rule — process-group + closure-escape + AsyncParsableCommand are 3 instances of "substrate adopts upstream typed-superset by default." After one more instance, `substrate-adopts-typed-superset-by-default.axiom.su.json`.

**Composes with**: [[feedback_workstream-ghost-chat-protocol-super-attack]] (ghost-process-group is the structural extension) + [[feedback_clia-rpg-trainer-role-power-tool-product-vision]] (Trainer↔Team mapping made structural) + [[feedback_substrate-IS-pokemon-formally]] (group = Pokémon team) + [[feedback_common-process-shell-cli-typed-primitives]] (the typed-primitive family this extends) + [[feedback_tool-to-role-to-workflow-dispatch-graph]] (authority becomes another dispatch axis) + [[feedback_event-is-chat-turn]] + [[feedback_turn-is-commit]] (auto-teardown on turn-cancellation via baked sequence).
