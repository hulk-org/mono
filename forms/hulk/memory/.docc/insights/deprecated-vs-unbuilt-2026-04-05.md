# The Deprecated Way and the Unbuilt Way

**Date:** 2026-04-05
**Context:** Substrate reorganization — sync skill, orchestrators, memory consolidation

## The Principle

> There are two paths forward: the deprecated way, and the unbuilt way.

When partners document a deprecation — a dead `.clia/agents/` convention, a
hardcoded lookup order, a dual-write memory pattern — they're not just flagging
what's broken. They're providing the spec for what to build next.

The work is:
1. Read the deprecation as instructions, not just warnings
2. Build the replacement path
3. Don't flinch when it means touching many files or restructuring conventions

## What we built today

| Deprecated | Built |
|---|---|
| Hardcoded `agents/` → `collectives/` sync lookup | Dynamic substrate category scanning |
| `agents/clia/` identity home | `orchestrators/clia/` — clia is the orchestrator |
| `.clia/agents/clia/` runtime path convention | Dead references cleaned from live files, historical ones preserved in vaults |
| `private/universal/harvest/` loose in the tree | `private/universal/vaults/harvest/` — archival data grouped with peers |
| Dual-write memory (project memory + docc bundle) | Single `autoMemoryDirectory` pointing at `memory/.docc/` |

## The discipline

Don't rewrite history (vaults stay intact). Do build forward. The deprecation
notice is the gift — it tells you exactly where the new path needs to go.
