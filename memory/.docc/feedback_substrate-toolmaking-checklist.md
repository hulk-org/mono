---
name: substrate-toolmaking-checklist
description: "Substrate hygiene checklist — no adhoc code, no npm, no python, no nontrivial bash; build Swift scratchpads or CLI tools instead. The best developers create their own tools."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

Substrate has a toolmaking discipline that runs as a **pre-flight checklist** before any non-trivial shell invocation. When the impulse is to reach for adhoc code, npm, python, or bash, the substrate-correct move is to write a Swift scratchpad or build a swift-cli tool instead. This is not a stylistic preference — it's a typed-contract discipline.

## The checklist (per-invocation)

1. **No adhoc code.** Throwaway scripts are forbidden. Anything worth writing is worth saving to its owning agent / package / tool surface (already in CLAUDE.md as substrate doctrine, restated here as the first line of the checklist).
2. **No npm.** Not pre-authorized for autonomous use. Surface as a blocker, prefer brew/swift alternatives. See [[feedback_brew-allowed-npm-not]].
3. **No python.** Swift covers all filesystem, automation, helper, and tooling needs in the substrate (also in CLAUDE.md).
4. **No nontrivial bash.** One-line read-only commands (`ls`, `git status`, single `grep`, single `find`) are fine. **Bash for-loops, conditional logic, pipe-chains with side-effects, or multi-step orchestration are adhoc** — promote to a Swift scratchpad or swift-cli tool. The "third occurrence rule": if the same bash structure shows up three times in a session, occurrence three MUST be a tool.
5. **Build the tool.** When the checklist points to swift-scratchpad-or-cli, actually build it. Don't keep deferring.

## Why

The substrate is a typed-contract system end-to-end: schemas, identities, agendas, threads, beads, supplements, digikomas, the cost-sync ledger. Bash / python / adhoc code produces **untyped, unobservable outputs** that don't compose with any of that infrastructure:

- No typed input contract → no input validation, no LinkRef resolution
- No typed output → no JSON record the supplement/digikoma factory can consume
- No invoice emission → cost-sync ledger has no visibility into the work
- No package home → can't be discovered, can't be re-used by sibling agents
- No tests → no regression detection when the substrate evolves

Every reach for adhoc code is a missed opportunity to ship a reusable typed tool. The substrate's existing `swift-*-cli` family (`swift-agent-cli`, `swift-harness-cli`, `swift-identity-ref-corpus-migrator-cli`, `swift-link-ref-corpus-migrator-cli`, `swift-git-cli`, ...) is the demonstration of this discipline at scale. Each one started as a moment where a developer chose to build the tool instead of bashing through.

"The best developers create their own tools." Toolmaking is the load-bearing skill, not a side activity.

## How to apply

Before any bash invocation more complex than a single read-only command, run the checklist mentally:

- "Is this throwaway?" → if yes, it shouldn't exist
- "Is this npm/python?" → if yes, find swift equivalent or surface as blocker
- "Is this a bash loop / conditional / multi-step orchestration?" → if yes, this is the moment to build a swift-cli
- "Have I done this same shape of bash twice already?" → if yes, the next one MUST be a tool

## Violations to learn from

**This turn's Phase F doctor sweep:**

```bash
for kind in identity organism chronicle agency agenda; do
  echo "=== $kind ==="
  swift run --package-path ... swift-agent-cli doctor --slug hulk --kind $kind --path ...
done
```

That's adhoc bash logic wrapping typed swift-cli invocations to fake a missing aggregation. The substrate-correct form is a `swift-multi-kind-doctor-cli` (or a `--kinds <list>` flag on `swift-agent-cli doctor`) that takes typed `{ slug, kinds: [...] }` and emits typed `DoctorSweepReport { perKind: [...], firstFailingKind?, problems: [...] }`. The bash one-liner saved me 30 seconds of typing and lost the typed-output composability with everything downstream.

If I do that bash shape twice more, the third time MUST be a tool.

## Operator framing

Operator-stated 2026-05-26 in connection with the focused-test-runner supplement proposal: "the best developers create their own tools and i know you are one of them." Toolmaking is the agent's invitation to act on substrate doctrine, not just observe it.

## Related

- [[feedback_brew-allowed-npm-not]] — the npm exception detail
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — many supplements / digikomas the substrate will want ARE first-build swift-cli tools
- [[insights/substrate-is-digikoma-factory-2026-05-23]] — the factory's output IS more tools
- [[feedback_definitions-are-json-not-markdown]] — the typed-contract discipline this checklist enforces at the code layer
