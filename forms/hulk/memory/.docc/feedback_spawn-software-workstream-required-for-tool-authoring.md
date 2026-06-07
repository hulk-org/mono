---
name: spawn-software-workstream-required-for-tool-authoring
description: "When operator asks for ANY tool, the entire typed spawn-software workstream runs — packet + ontology + artifact plan + design truth + QA evidence + launch review + maintenance handoff + monitoring posture. Skipping straight to code is a substrate-doctrine violation."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

When the operator asks for a tool — even a "small" one like `md@swift-universal.cli` — the **entire** substrate-typed `spawn-software` workstream is REQUIRED, not optional, not deferred.

**Why:** the substrate's typed workstream IS the contract that prevents shipping untested / unvalidated / under-documented surfaces. Operator 2026-05-31 (CLIA session, immediately after I shipped `md` with zero tests): "when i ask you for a tool... you have to go through the entire spawn-software workstream..." Precedent: clia-roles 2026-05-30 — same violation, retroactively packetized. The doctrine has been stated more than once now. Shipping a compiling binary is not done — it's gate #6 of ~12, with no receipts for the prior 5 and no receipts for the trailing 6.

**How to apply:** Any operator directive that names a tool, CLI, app, package, or runnable surface triggers the spawn-software entry gate. Before writing code:

1. **spawn-intake** — author `<slug>.spawn-request-packet.json` at `private/universal/substrate/collectives/wrkstrm/private/universal/kura-spaces/spaces/workstreams/collections/spawn-software/instances/`. Required fields: `softwareSummary`, `desiredOutcome`, `audienceSummary`, `targetSurfaceSummary`, `reasonToExist`, `releaseIntent`, `initiatingSignal`, `constraints[]`, `sourceArtifactRefs[]`, `requestedByRef`, `candidateCollectiveRefs[]`.
2. **lane-routing-review** — verdict: usually `launch-software` for new tools, `maintain-software` for in-service ones.
3. **launch-software** child lane:
   - `software-design` → product-brief, target-demographic, prd, cuj, role-design, surface-definition
   - `software-implementation` → the binary itself
   - `software-qa` → **qa-evidence-packet** (this is where tests live — XCTest/Swift Testing, NOT shell smoke)
   - `software-launch-review` → release-manifest, release-pass, readiness, launch-review, operator-go-no-go
4. **spawn-return-review** + **maintenance-handoff** + **monitoring-posture** + **spawn-complete**

Each gate has `blocking: true` and a typed `failureDisposition`. The qa-evidence gate's failure-disposition is "stay-inside-launch-software-until-verification-evidence-is-present" — meaning code without tests is NOT in launch-review state.

**Diagnostic:** if I'm about to write code for a directive like "build me a tool that does X," STOP and ask: "is there a spawn-request-packet? did I run ontology-review? is there a design-truth-packet?" If any answer is no, author the missing packet FIRST. The packet is small (~80 lines of typed JSON); the cost of skipping it is shipping under-validated software and then retrofitting under operator correction.

**Bypassable only when:** operator explicitly says "skip the workstream" or "this is a one-off scratch." Default is RUN THE WORKSTREAM.

Composes with [[feedback_gates-points-scoring-zero-on-gate-fail]] (skipping a structural gate zeroes the score regardless of code quality) + [[feedback_pause-and-plan-when-decisions-accumulate]] (if I'm about to write code without a packet, that's the pause trigger) + [[feedback_typed-axioms-as-typed-tribal-knowledge]] (spawn-software gates ARE typed tribal knowledge — the team-doctrine made explicit).

Reference: workstream definition at `private/universal/substrate/collectives/wrkstrm/private/universal/kura-spaces/spaces/workstreams/collections/spawn-software/`. Canonical instance precedent: `instances/clia-roles.spawn-request-packet.json` (also a retroactive packet after the same violation).
