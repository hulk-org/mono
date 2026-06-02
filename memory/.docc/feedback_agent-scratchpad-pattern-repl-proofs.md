---
name: agent-scratchpad-pattern-repl-proofs
description: "Substrate Swift scratchpads live at `<agent-home>/memory/.docc/repl-proofs/<YYYY-MM-DD>-<slug>.swift` with a sibling `Package.swift` for build context. Use these for one-shot Swift execution before committing to a full CLI."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate's Swift scratchpad pattern (per the toolmaking-checklist's "Swift scratchpad or CLI tool" pair) lives at a known path in each agent's home:

```
<agent-home>/memory/.docc/repl-proofs/
├── Package.swift                       — build context (shared across scratchpads)
├── 2026-MM-DD-<slug-A>.swift           — one scratchpad per dated topic
├── 2026-MM-DD-<slug-B>.swift
└── ...
```

## When to use a scratchpad vs a CLI tool

| Scratchpad | CLI tool |
|---|---|
| One-shot operational work that won't recur | Recurring need across sessions / consumers |
| Proving a substrate claim with runnable code | Typed-contract surface for other tools to compose against |
| Local agent-scope (lives in agent's memory) | Substrate-wide scope (lives in tooling/spm or domain/system/spm) |
| Header docs explaining CLAIM / NEGATIVE / COUNTERFACTUAL or simple "what this does + why" | Package.swift + library + exec target + tests + typed contract |
| Saved as historical record / proof | Saved as reusable primitive |

A 90-file one-shot rename sweep is a scratchpad. A reusable test-runner is a CLI tool.

## File naming convention

- `<YYYY-MM-DD>-<descriptive-slug>.swift` — example: `2026-05-26-digikoma-sidecar-rename.swift`
- Header doc-comment explaining what the scratchpad does and why
- For proofs, follow castor's pattern: `CLAIM:` / `NEGATIVE:` / `COUNTERFACTUAL:` sections
- For operations, use a simpler `// WHAT / WHY / HOW` header

## Why this exists

Three reasons this beats both "throwaway shell script" and "premature CLI":

1. **Saved in-repo** — satisfies the "no throwaway scripts" doctrine; the work is durable and reviewable
2. **Swift-typed** — uses real types from substrate packages; not stringly-typed bash
3. **Agent-scoped** — lives in the agent's memory home; doesn't pollute the substrate's tool registry with one-shot work

The `repl-proofs/` name comes from the original use case (Swift REPL-runnable proofs of substrate claims, à la castor's four-tier-cost-gradient proof). Operational scratchpads also live there; the directory is the substrate-canonical "saved Swift you might run once" home.

## How to apply

1. Create `<agent-home>/memory/.docc/repl-proofs/` if it doesn't exist
2. Add a `Package.swift` with the dependencies the scratchpad needs (path-deps to substrate packages)
3. Write `<YYYY-MM-DD>-<slug>.swift` with header doc + code
4. Run via `swift run` (if the Package.swift defines an executable target wrapping the scratchpad) OR `swift -e <inline>` for trivial cases OR `swift <path-to-file>` for standalone Swift scripts

For multi-file scratchpads, multiple `*.swift` files in `repl-proofs/` share the Package.swift.

## History

Operator-reminded 2026-05-26 after I proposed building a full SPM CLI package for a 90-file rename sweep: "you can do a scratchpad in your agent home. we had that pattern explicitly." The pattern was already established (castor, chatgpt, common, catch all have `repl-proofs/` dirs). I had not surfaced it before this reminder.

## Related

- [[feedback_substrate-toolmaking-checklist]] — the "Swift scratchpad OR cli tool" pair; this doctrine fills in the scratchpad side
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — neither supplements nor digikomas; scratchpads are agent-private throwaway-but-saved Swift
- castor's `private/universal/substrate/agents/castor/memory/.docc/repl-proofs/` — canonical proof examples
