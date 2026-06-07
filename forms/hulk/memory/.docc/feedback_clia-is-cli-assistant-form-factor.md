---
name: clia-is-cli-assistant-form-factor
description: "`.clia` is the substrate's typed CLI ASSISTANT form-factor — conversational CLI bound to chat ghost protocol; distinct from `.cli` (deterministic command-line tool)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31: "and remember that cli tools that you can talk to are .clia - get it a cli ASSISTANT."

**Rule**: Substrate's typed form-factor convention now includes:
- `<slug>@<org>.cli` — DETERMINISTIC command-line tool (typed input → typed output; bounded calls; no conversation)
- `<slug>@<org>.clia` — CLI **ASSISTANT** (CONVERSATIONAL; ghost-protocol-equipped; multi-turn; uses `DigikomaConversationCommand.chat()` + `DigikomaConversationPacketFactory`)
- `<slug>@<org>.workstream` — typed workstream Swift Package (per [[feedback_workstreams-as-swift-packages-next-layer]])
- `<slug>@<org>.workstream-instance` — typed workstream instance Swift Package
- `<slug>@<org>.app` — Mac/iOS/web app
- `<slug>@<org>.ghost` — typed ghost persona

**Why**: per [[feedback_form-is-universal-binding-pattern]] — "form" is the substrate's universal binding pattern; each form variant declares its binding semantics. The `.clia` form names a CLI binding that is CONVERSATIONAL (can be talked to) rather than just executable (returns and exits). CLIA = CLI Assistant; the substrate's clia-org and clia-app-org collectives are NAMED after this assistant-shape, and clia-conversation-kit (`CLIAInteractiveChatSession`, `CLIAConversationInputRouter`) is the typed implementation library. The convention was already in active use: `kura-org/private/universal/digikoma/savepoint-commit.digikoma.clia` + `savepoint-git-push.digikoma.clia` (compound `.digikoma.clia` = a Digikoma + CLIA assistant), `operators/rismay/.../appointment-reminders.workstream.clia.{json,jsonl}` (workstream emits `.workstream.clia.*` typed records), `agents/clia/.../*.clia.agent.triad.*` (typed CLIA agent triads), `operators/rismay/.../environment.harness.clia.json` (harness env). The operator just named the convention so future authoring stops bypassing it.

**How to apply**:
- When authoring a CLI tool that should support natural-language interaction (multi-turn, has memory, uses an LLM backend), use `.clia` form-factor.
- When authoring a CLI tool that is bounded (one call → one typed result, no conversation), use `.cli` form-factor.
- A Swift Package that ships BOTH a deterministic CLI AND a conversational assistant declares TWO executables (per [[feedback_workstream-package-ships-library-cli-and-clia]]):
  ```swift
  products: [
    .library(name: "Workstream", targets: ["Workstream"]),
    .executable(name: "workstream", targets: ["WorkstreamCLI"]),      // .cli
    .executable(name: "workstream-chat", targets: ["WorkstreamCLIA"]), // .clia
  ]
  ```
- `.clia` executables import: `DigikomaCore` + `ConversationProtocol_Schemas_v000_000_000` + the domain library (workstream typed records) + a `DigikomaIntelligenceProvider` conformer (Apple FoundationModels for on-device, Anthropic/OpenAI/Ollama for cloud).
- `.clia` artifacts persist as `.clia.json` / `.clia.jsonl` fixture-replayable typed records.

**Composes with**: [[feedback_workstream-ghost-chat-protocol-super-attack]] (the chat protocol the .clia runs) + [[feedback_form-is-universal-binding-pattern]] (the parent doctrine) + [[feedback_codex-is-a-form-of-chatgpt]] (sibling typed-form precedent) + [[feedback_workstreams-as-swift-packages-next-layer]] (workstream Package now ships .cli + .clia + library).
