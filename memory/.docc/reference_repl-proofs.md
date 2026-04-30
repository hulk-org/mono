---
name: LDT proofs index
description: Index of compilable Swift proof files under repl-proofs/ — Login Driven Thinking (LDT) artifacts. Each entry is a real .swift file that runs with `swift <file>` and prints `ok: …` on success.
type: reference
originSessionId: c051197f-2163-48bf-a3a9-e51c4fe4b87d
---
Login Driven Thinking (LDT) proof index. Each proof is a **compilable Swift
file** under `~/.claude/memory/.docc/repl-proofs/<date>-<topic>.swift`. The
file is the artifact — this index is just a TOC. To re-run a proof:

```
swift ~/.claude/memory/.docc/repl-proofs/<date>-<topic>.swift
```

Each `.swift` file is self-describing: doc comments at the top state the
claim, source of truth, and what (if anything) the proof caught. The body
models the claim with types/functions and asserts with `precondition(...)`.

Doctrine: root `AGENTS.md` `## Login Driven Thinking (LDT)`.
Companion rule: `feedback_test-driven-repl-proofs.md`.

## Proofs

| Date | Topic | Path | One-liner |
|---|---|---|---|
| 2026-04-29 | hulk-startup-phases | `repl-proofs/2026-04-29-hulk-startup-phases.swift` | 11-phase carrier pipeline, exactly one persona-scoped slot at index 4; caught a prose off-by-one |

Append new rows in date order; never edit a landed proof file except to fix
a bug (with a `// fixed YYYY-MM-DD: <what was wrong>` doc-comment line at
the top of the file).
