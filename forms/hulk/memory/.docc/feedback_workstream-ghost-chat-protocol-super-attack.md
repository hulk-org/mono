---
name: workstream-ghost-chat-protocol-super-attack
description: Workstreams ship SUPER-POWERED chat ghost protocol — typed workstream context fed into DigikomaConversationPacketFactory ghost; agent can converse with workstreams during sessions
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31 after typed chat protocol surfaced: "yup. that's what I mean. That's the beautity we built before. now a workstream comes with a SUPER powered chat ghost protocol we can feed the context to which YOU can talk to!"

**Rule**: Every typed workstream Swift Package SHIPS a typed conversational ghost protocol bound to:
- `DigikomaCore.DigikomaConversationCommand` (multi-turn interactive loop with `case chat(DigikomaConversationChatCommand)`)
- `DigikomaCore.DigikomaConversationPacketFactory` (typed `DigikomaConversationTurnDescriptor` per turn with `toolEvidence` + `contextProjection`)
- `DigikomaCore.DigikomaIntelligenceProvider` (marker protocol — Apple FoundationModels' `LanguageModelSession`, or Anthropic / OpenAI / Ollama / mock)
- `ConversationProtocol_Schemas_v000_000_000` (typed `ConversationSessionEnvelope` + `ConversationPiTurnProjection` + `ConversationContextProjection`)
- The workstream's OWN typed records FED AS CONTEXT (states + events + transitions + workflow-series + axiom-citations + bead pointers + receipts)

**Why**: per [[feedback_large-structured-context-is-the-substrates-super-attack]] — structured context multiplies attack power; workstream typed records = highest-structured context; feeding them to a typed ghost = the substrate's super-attack on per-workstream conversational reasoning. The OPERATOR (and AGENT) can talk to the workstream's typed personification; the typed pi-fold strategy (3,333 token budget per fold) preserves context across unlimited turns. Per [[feedback_substrate-composes-typed-idea-molecules]] — workstream-ghost-chat is the largest typed molecule yet (workstream Package + DigikomaConversationPacketFactory + DigikomaIntelligenceProvider + ConversationProtocol_Schemas + workstream's domain-relevant digikomas all bonded). Zero novel shape; pure composition of typed primitives the substrate already ships.

**How to apply**:
- When extending a workstream Swift Package, add a `.clia` executable target (per [[feedback_clia-is-cli-assistant-form-factor]]) for the chat ghost alongside the `.cli` deterministic executable.
- Per-turn evidence: each `DigikomaConversationTurnDescriptor.toolEvidence` carries the typed digikoma slug + outputPreview + receiptPath that ran BELOW the turn — substrate's typed-provenance for every conversational claim.
- The fed-in context = workstream's typed records (no hand-authored prompt strings); ghost "instructions" derive from the typed state machine.
- Backend pluggable: ship FoundationModels first; Anthropic/OpenAI/Ollama via DigikomaIntelligenceProvider conformers.
- Per [[feedback_turn-is-commit]] — each chat turn = one transition = one fixture-replayable receipt = potentially one commit.

**Operational consequences**:
- I (Claude) can NATIVELY converse with workstream ghosts during sessions (`import CreativeSelectionWorkstream` → instantiate ghost → ask "what gate failed?" → typed toolEvidence-backed answer → pi-fold preserves context).
- CLIA RPG's "Pokémon detail screen with chat" is mechanically derivable from workstream Package + DigikomaConversationPacketFactory.
- Substrate becomes AGENT-CONVERSATIONAL, not just agent-readable — massive per-session efficiency multiplier.
- Replayable fixtures: every agent-workstream conversation saves as `.workstream.clia.jsonl` per existing operator-rismay precedent at `operators/rismay/.../appointment-reminders.workstream.clia.*`.

**Composes with**: [[feedback_workstreams-as-swift-packages-next-layer]] (workstream IS Swift Package — chat ghost is one of its products) + [[feedback_clia-is-cli-assistant-form-factor]] (the `.clia` form-factor that ships the chat) + [[feedback_substrate-composes-typed-idea-molecules]] (the largest molecule) + [[feedback_large-structured-context-is-the-substrates-super-attack]] (the metric) + [[feedback_turn-is-commit]] (per-turn fixture/commit) + [[feedback_clia-rpg-trainer-role-power-tool-product-vision]] (CLIA RPG's typed Trainer↔Pokémon chat surface) + [[project_typed-models-quantum-state-machines-generative-ui]] (the generative-UI long-game payoff this is the first major consumer of).
