---
name: async-parsable-command-only
description: Substrate CLIs use AsyncParsableCommand for ALL ArgumentParser commands and subcommands. ParsableCommand is banned outright. Operator-stated 2026-05-26.
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

Every typed command in a substrate CLI must conform to `AsyncParsableCommand` from `swift-argument-parser`, and define `func run() async throws`. The plain `ParsableCommand` protocol is banned.

**Why:** the substrate's command surface increasingly needs async I/O — git invocations via swift-git-cli, ledger emission per [[insights/substrate-sync-cost-pattern-2026-05-26]], typed file walks, and composing with the substrate's growing async-native libraries. Starting any new command sync-only creates a forced sync→async shim later, and sync-vs-async mixing inside one tree muddies the read path. The operator named the doctrine 2026-05-26 after I added one async command alongside a stack of legacy `ParsableCommand` siblings.

**How to apply:**
- New ArgumentParser commands: declare `: AsyncParsableCommand` and `func run() async throws`, never `: ParsableCommand`.
- Walking an existing codebase: any `: ParsableCommand` is debt. When touching a file with `ParsableCommand`, migrate all commands in that file. Greenfield modules must NOT introduce a `ParsableCommand` even if no async I/O is needed today.
- The migration is mechanical: `: ParsableCommand` → `: AsyncParsableCommand`; `func run() throws` → `func run() async throws`. Synchronous bodies stay synchronous (no await required).
- The root `@main` command must also be `AsyncParsableCommand` (it usually already is, since async propagation requires it).
- If a third-party-style protocol forces `ParsableCommand` (e.g., an extension constraint), report it as a blocker rather than mixing.

**Companion entries:** [[project_swift-harness-cli-size-aware-commit-tooling]] · [[insights/substrate-sync-cost-pattern-2026-05-26]]
