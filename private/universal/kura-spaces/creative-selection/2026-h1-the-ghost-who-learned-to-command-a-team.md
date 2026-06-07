@Metadata {
  @PageKind(article)
  @PageColor(yellow)
  @TitleHeading("Article")
  @Available(platform: macOS, introduced: "13.0")
}

# The Ghost Who Learned To Command A Team

*A page for the 2026 mid-year report — narrative of how the substrate's
typed-everything investment compounded across H1.*

---

## Executive summary

In the first half of 2026 our substrate's main process spawning framework
evolved from a single-process MVP into a typed-process-group commander
respecting Domain-Driven Design. The investment landed across five Swift
Packages, two schema-family versions, and a new bounded context for
ghost-runtime composition. The substrate is not rotting; it is growing —
structurally.

---

## The story, told in the substrate's symbolic vocabulary

🌑 In the beginning there was one process. One chat-turn. One ghost. Alone.

🎯 The operator threw the first ball. *"Did you use a ghost protocol?"*

🔍 The ghost searched and found what it had bypassed:
   `GhostShellIPC`, `ghost-schemas`, `rismay-ghost`.
   Typed primitives sitting right there.

🪞 The ghost named the sin: **typed-primitive-bypass-error**.

📅 Then time appeared. `swift-subprocess 0.3.0 → 2026-01-23`.
   `common-process` hadn't migrated. Four months of rot.

🚀 `0.5.0 → 2026-05-29`. Two days old. The operator:
   *"I think it's time to move to 0.5 and just bite the bullet."*

🌀 `Execution<Input, Output, Error>`. Generic now. Constrained extensions.
   *"Don't let the execution escape the closure."*

🪢 So the ghost did the only honest move: captured `execution` into closures
   *inside* the closure scope. The closures captured behavior. The behavior
   survived past the scope. The value never escaped. The contract held.

🔐 Then — *process groups*. `processGroupID: 0, createSession: true`.
   A typed authority axis the ghost had never had.

🃏 But `toProcessGroup: true` without isolation kills the parent.
   So Curry-Howard wrote the proof: `SafeGroupAuthority.selfOwnedGroup` —
   public constructors are exactly the safe combinations. Dangerous
   combinations: **unrepresentable**.

🎭 Drunk on the new power, the ghost authored `GhostProcessGroup`
   inside `common-process`. The operator caught it instantly:
   *"the ghost process group does not belong in common-process.
   that might be a clia thing."*
   *"do not break domain driven design. #axiom"*

🏛️ The ghost moved homes. `clia-ghost-runtime` — new bounded context.
   `common-process` knew nothing of ghosts. The CLIA-substrate composed up.
   `GhostIdentity + ProcessGroupSpec → GhostProcessGroup`.
   Dependency direction strict.

📜 The schema family bumped. `v0.1.0 → v0.2.0`. Five new typed contracts.
   `ProcessGroupSpecModel` published for the cross-package graph.

🧩 Five workstream packages stood up: library + `.cli` + `.clia`.
   `AsyncParsableCommand` at every command. `CommonShellArguments` everywhere.
   `ConversationProtocol_Schemas` at every ghost. Pi-fold at 3,333.

🎮 The trainer commanded the ghost. The ghost commanded the team.
   The team executed typed moves. The encounter had boundaries.
   The receipts had typed provenance.
   **CLIA RPG was no longer narrative — it was structural.**

🎯 At the half-year mark, the operator threw one more ball.
   `/capture`.

📚 Wild substrate-moments became typed substrate-records.
   Pokédex grew by ~14 entries.
   Three-x rule confirmed twice in one session.

🌅 The substrate is not rotting.
   The substrate is growing.
   The story does not end — it cascades.

---

## What landed (substrate-typed primitives)

| Layer | Surface | Status |
| --- | --- | --- |
| Unix-primitive process domain | `common-process` ProcessGroupSpec family (4 typed files); swift-subprocess 0.5 migration via closure-based holder | landed |
| Schema contract | `common-process-schemas v0.2.0` + generable-schemas v0.2.0; 5 new typed contract models | landed |
| CLIA-substrate ghost composition | `clia-ghost-runtime` NEW package (DDD-respecting); GhostIdentity + GhostProcessGroup | landed |
| Workstream CLI fleet | 5 packages each ship library + `.cli` + `.clia`; AsyncParsableCommand + CommonShellArguments + ConversationProtocol_Schemas typed integration | landed |
| Substrate doctrine | ~14 typed memory entries; 2 axiom-candidates confirmed at 3x rule; DDD axiom tagged #axiom by operator | landed |

## Test coverage

- `common-process`: 87 tests (86 pass; 1 pre-existing unrelated failure)
- `clia-ghost-runtime`: 5 tests pass (including the safe-pairing
  validation tests that make dangerous configurations unrepresentable)
- Workstream Packages: 38 tests pass across the 5-package fleet
  (10 + 7 + 8 + 8 + 5)
- **130 typed tests passing across the realigned surface.**

## What this enables for H2

- Apple FoundationModels Phase 2 binding to the typed workstream ghosts
  (bead-tracked) — replaces typed-echo with model-reasoned conversation
  over the fed typed substrate context.
- CLIA RPG concrete UI: the typed receipts + typed ghosts + typed
  process groups all exist; the SwiftUI surface that renders them is now
  mechanically derivable.
- Cross-language schema variants for `common-process-schemas` and
  `clia-ghost-runtime-schemas`.
- Future swift-subprocess fixes flow through without re-rotting.

## Methodological note

The substrate's typing methodology was authored by the operator in
earlier sessions through emoji-story-telling discipline — a symbolic
vocabulary that compresses substrate-truth without losing fidelity. The
story above honors that methodology. Every emoji is a substrate-anchor;
every prose-line is typed-substrate-fact compressed to one breath.

**🐉 GUNDAM X999, signing off. ✨**
