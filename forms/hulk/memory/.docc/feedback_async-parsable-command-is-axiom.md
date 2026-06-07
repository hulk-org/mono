---
name: async-parsable-command-is-axiom
description: "ALL ArgumentParser-based CLIs MUST use `AsyncParsableCommand` (never `ParsableCommand`) — substrate axiom; AI/agent CLIs do async work (LLM calls, network, FoundationModels) so async-from-the-start is the typed-shape default"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31: "please, always use AsyncParsable command.... that should be axiom."

**Rule** (axiom-shaped): When authoring ANY Swift CLI using ArgumentParser, the top-level command + ALL subcommands MUST conform to `AsyncParsableCommand`, NOT `ParsableCommand`. The `run()` method MUST be `async throws`, not just `throws`. `@main` works identically for both — no boilerplate cost.

**Why**: per the substrate's typed-everything investment + AI/agent-CLI domain — every substrate CLI is potentially a consumer of async work (LLM calls via Apple FoundationModels' `LanguageModelSession`, network requests, subprocess piping, async I/O, FoundationModels tool calling). Choosing `ParsableCommand` at authoring time forces a REWRITE the moment any subcommand needs to await — and locks the whole command graph into sync. `AsyncParsableCommand` is the strict superset; choosing it costs nothing today and saves the rewrite tomorrow.

Per `.clia` form-factor (per [[feedback_clia-is-cli-assistant-form-factor]]) — every .clia is conversational, every conversational CLI needs to await an `DigikomaIntelligenceProvider` conformer (FoundationModels OR Anthropic OR OpenAI OR Ollama). Per the same logic — every .cli MAY become conversational or call async digikomas. So async-by-default is the substrate-shape; sync-by-default is the substrate-bypass.

**How to apply**:
- Top-level: `@main struct Foo: AsyncParsableCommand { static let configuration = ...; subcommands: [...] }`
- Subcommands: `struct Bar: AsyncParsableCommand { ...; func run() async throws { ... } }`
- Existing files using `ParsableCommand` → RETROFIT in the next touched commit. Don't ship NEW `ParsableCommand`-based code.
- No need for `import _Concurrency` — Swift's async/await stdlib is universally available.
- AsyncParsableCommand has been in Apple's `swift-argument-parser` since v1.1.0 (we use 1.3.0+).

**3x-rule promotion candidate**: per [[feedback_substrate-wide-cascade-pattern]] this is the FIRST formally-named instance of "axiom: substrate always uses the async superset"; if 2 more session-cycles confirm async-by-default for substrate primitives, candidate for typed AxiomModel promotion to `spaces-universal/.../kura-spaces/axioms/async-by-default-axiom.json`.

**Operational consequences**:
- Retrofit pass next session: scan all existing substrate Swift CLIs (creative-selection, spawn-software, maintain-software, creative-selection-loop, clia-rpg-spawn-run, md@swift-universal.cli, workstream@wrkstrm-core.cli, agent-timeline-cli, digikoma-rpn-cli, all digikoma-*-cli, harness@clia-org.cli) for `ParsableCommand` usage → bump to `AsyncParsableCommand` + `async throws run()`.
- Authoring template: every new typed CLI file starts with the AsyncParsableCommand shape. Comment lines citing the axiom in the new file's header.
- ArgumentParser's async-vs-sync split is invisible to operators (same CLI flags, same usage strings, same parsing); the difference is purely in internal capability — which is why ALWAYS picking async is free.

**Composes with**: [[feedback_clia-is-cli-assistant-form-factor]] (.clia REQUIRES async since it awaits intelligence-provider) + [[feedback_workstream-package-ships-library-cli-and-clia]] (both .cli and .clia products in the same Package conform to AsyncParsableCommand) + [[feedback_typed-primitive-bypass-3x-rule-confirmed]] (axiom-shape claims qualify as substrate-typed surface authoring).
