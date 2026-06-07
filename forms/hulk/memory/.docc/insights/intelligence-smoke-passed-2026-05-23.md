---
name: INTELLIGENCE smoke PASSED 2026-05-23 — substrate's first AI-driven action
description: Apple Foundation Model on-device drove hello_world via LanguageModelSession; substrate's three-transport claim (CLI+Service+Tool) is now live, not just typed
type: project
originSessionId: 73646ca8-23c0-4889-afa0-407568d477f4
---
On 2026-05-23 at ~08:30Z the substrate's three-transport citizenship claim transitioned from typed-and-compile-tested to live-and-AI-verified for the first time. Customer #2 in `~/.local/share/digikoma/hello-world/imprints.jsonl` is the substrate's first AI-driven greeting — `transport: "tool"`.

## What happened

`digikoma-hello-world-intelligence-smoke` (hashed product `3e8d2c01-cli` in `digikoma-org/.../digikoma-hello-world/`) drove Apple's on-device `LanguageModelSession` with `HelloWorldFoundationModelsTool` registered. The smoke:

1. Recorded `countBefore` from `~/.local/share/digikoma/hello-world/state.json`
2. Created `LanguageModelSession(tools: [HelloWorldFoundationModelsTool()])`
3. Sent prompt: "Please greet a customer using your hello_world tool. The customer's message should be 'first AI-driven customer'. After calling the tool, briefly confirm what happened."
4. Apple Foundation Model on-device:
   - Inspected the registered `Tool` array via Apple's typed introspection (@Generable Arguments + name + description)
   - Decided to invoke `hello_world` with `message: "first AI-driven customer"`
   - Got back the typed result string ("Greeted customer #2. Welcome to the substrate!")
   - Responded in natural language: "I have successfully greeted the customer using the hello_world tool. The customer's message was 'first AI-driven customer', and they were greeted as customer #2."
5. `countAfter` was 2 (was 1), confirming the tool was invoked.
6. `imprints.jsonl` gained its first `transport: "tool"` entry — customer #2 with `notification: {"posted": {}}` (NSUserNotification banner fired live on screen).
7. `transport` breakdown across the imprints log now reads `1 service, 1 tool` (plus earlier CLI entries from prior sessions).

## Why this matters

The substrate has been making the *three-transport* claim since `digikoma-hello-world` shipped on 2026-05-22 — every action callable from CLI (one-shot human/script), Service (event-bus watcher dispatch), and Tool (LLM-callable). CLI was live from day one. Service was live since the watcher kernel landed. Tool was *compile-time verified* via `@available(macOS 26.0) struct: Tool` but never actually invoked through a real `LanguageModelSession` until today.

This is the substrate's "Hello world from the future" moment — the substrate didn't just *talk to* AI, the AI *talked to* the substrate. Every future digikoma that adds a `*FoundationModelsTool` target inherits this proven loop for free.

## Substrate-doctrinal implications

- The `@Generable Arguments` + `Tool` protocol surface in `DigikomaHelloWorldFoundationModelsTool` IS what Apple's on-device model needs to discover and invoke substrate digikomas. No additional bridging code. Apple's `@Generable` macro on the data side composes cleanly with the substrate's typed-citizenship discipline on the behavior side.
- The shared state file + imprint log across all three transports means cross-transport audit queries (`jq -r '.transport' ~/.local/share/digikoma/hello-world/imprints.jsonl | sort | uniq -c`) tell the operator how each digikoma is being driven. AI-driven invocations are first-class entries alongside human-driven ones.
- The `notification: {"posted": {}}` field of the AI-driven imprint records that the substrate's UX surface (NSUserNotification banner) fired in the operator's session — meaning the AI's action was both *logged* AND *visible* to the operator without any separate observability infrastructure.

## How to repro

```bash
swift run --package-path private/universal/substrate/collectives/digikoma-org/private/universal/domain/core/digikoma-hello-world 3e8d2c01-cli
```

Requires macOS 26+ with Apple on-device Foundation Model available.

## Commits

- digikoma-org: `Add digikoma-hello-world-intelligence-smoke: the three-transport live test`
- mono: `Bump digikoma-org: INTELLIGENCE smoke live-verified`
