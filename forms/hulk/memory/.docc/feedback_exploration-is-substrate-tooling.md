---
name: exploration-is-substrate-tooling
description: "When the agent runs find/grep/awk across substrate sources to learn primitives (public API, usage patterns, package layout), that exploration ITSELF should become a substrate CLI tool — not a one-shot bash command. Throwaway exploration code is banned. Operator-stated 2026-05-26."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

The substrate has a **"no throwaway code"** discipline that applies even to *exploration*. If the agent finds itself running ad-hoc shell commands to learn how a substrate primitive works (e.g., `find common-process/sources -name '*.swift'`, `grep -rE 'public (struct|enum|func)' ...`, `grep -B1 -A10 'public struct ProcessOutput'`), that pattern is **already a CLI tool waiting to be authored**. It should land as a substrate CLI command, not a one-line bash that vanishes from history.

**Operator-stated 2026-05-26:** "this needs to be a CLI tool! this is so cool. this is why I say NO throwaway code"

**Why:**
- The exploration solves a recurring operator-side burden — every fresh agent or session re-runs the same find/grep dance to orient. A typed CLI absorbs that burden once.
- Bash output is line-noise; typed CLI output is a record. The substrate's [[insights/substrate-is-digikoma-factory-2026-05-23]] doctrine generalizes: "reusable bounded executor with typed contract, absorbs a repeating agent-side burden, clean intent→apply→ledger handoff, runs independent of agent session." Exploration tools meet all four criteria.
- A CLI carries instrumentation (cost ledger, audit trail) that bash doesn't — important for the substrate's [[insights/substrate-sync-cost-pattern-2026-05-26]] discipline.

**How to apply:**
- When tempted to run a find/grep combo across substrate sources: **stop and ask whether it should be a CLI verb in wrkstrm-identifier** (the canonical naming/discovery tool family) or a new dedicated package.
- Concrete pattern candidates that recurred this session and should become CLIs:
  - "Show me the public surface of package X" → `wrkstrm-identifier inspect-package --slug <X>`
  - "Where is type Y defined in substrate?" → `wrkstrm-identifier locate-symbol --name <Y>`
  - "What primitives exist under common-* prefix?" → `wrkstrm-identifier list-commons`
  - "Sample usage of API Z" → `wrkstrm-identifier sample-usage --symbol <Z>`
- Save these patterns as TODO items the next time you hit the exploration → CLI conversion.

**Boundary:**
- One-shot bash is fine for **environment checks** (`which pkl`, `ls -la some-file`, `git status`) — those are stateful inquiries about the operator's host machine, not substrate-primitive discovery.
- The ban applies specifically to **substrate-primitive exploration**: scanning Swift sources, mapping public APIs, learning architectural patterns. That's where the discovery CLI lives.

**Companion entries:** [[insights/substrate-is-digikoma-factory-2026-05-23]] (the broader factory doctrine) · [[project_swift-harness-cli-size-aware-commit-tooling]] (sibling example: bash size-filter → CLI primitive) · [[feedback_grep-common-star-before-adding-primitives]] (the inverse rule: grep before authoring; this rule says even THAT grep should be a CLI).
