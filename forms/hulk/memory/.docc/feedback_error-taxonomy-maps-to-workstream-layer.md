---
name: error-taxonomy-maps-to-workstream-layer
description: "Substrate error taxonomy. Each error category maps to a CANONICAL implicated workstream/workflow layer, making error→gap diagnosis mechanical rather than ad-hoc."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's error → workstream-gap mapping has a typed taxonomy. Each error category points at a CANONICAL implicated layer, so /wd step 3's "identify what failed" decision is mechanical, not creative.

**Why:** without typed categories, every agent rediscovers the error→layer mapping from scratch, and similar errors get attributed to different gaps. Operator 2026-05-31 (CLIA, /wd skill refinement): "i guess categorize the ERRORS so we know WHAT workflow or workstream failed." Naming the categories makes diagnosis fast and consistent across sessions.

**How to apply** — for each error encountered, classify it into one of these categories. The category's canonical implicated layer points at what to refine in step 3:

| Error category | What happened | Canonical implicated layer | Refinement target |
|---|---|---|---|
| **workstream-skip** | Entire workstream not executed when it should have been | Missing axiom encoding the doctrine; missing trigger | Promote axiom; add trigger to operating-protocol |
| **gate-skip** | Gate "cleared" without typed evidence behind it | Gate's `failureDisposition` not load-bearing in agent context | Strengthen failureDisposition; require explicit receipt in `requiredArtifacts` |
| **step-skip** | Workstream executed but a step in its workflow was skipped | Missing step in `steps[]`; or passive instruction | Insert step; sharpen instruction from passive to active |
| **layer-confusion** | Work done at wrong level of substrate ladder (e.g. workflow.json when workstream-template was the unit) | Ladder under-documented; partition extractRule conflates layers | Clarify ladder in extractRule; add ladder doctrine to partition summary |
| **sequencing** | Steps executed out of order (e.g. citations before cited artifacts exist) | Missing sequencing constraint in step instructions | Add explicit "MUST run before/after X" to step |
| **deferral-when-inline** | Work that should land in-session was filed as bead/follow-up | Passive extractRule allowed deferral; weight estimate wrong | Rewrite extractRule as active; document weight in workstream-template |
| **contract-clarity** | Operator and agent had different mental models of the work's shape | Deliverable shape ambiguous in workstream-template; reviewGate vague | Sharpen deliverable definitions; add gate's verbatim accept-criteria |
| **build-test-validation** | Technical failure (compile / test / lint / dependency) | Missing test, missing pin, missing CI gate; workstream lacks `qa-evidence` discipline | Add test fixture; pin dep; bind to qa-evidence-complete gate |

**Categorization rule of thumb:** if the operator surfaces the error, it's almost always one of {workstream-skip, layer-confusion, contract-clarity, deferral-when-inline}. If the build/test surfaces it, it's almost always {build-test-validation}. Step-skip and sequencing tend to surface mid-execution as "wait, I skipped X" or "X needed to come first."

**One error often implicates multiple layers** — record all implicated layers per error, not just the most-visible one. Example: md@swift-universal.cli shipped without spawn-software walk was BOTH a workstream-skip (no walk happened) AND a contract-clarity (operator and agent had different "tool authoring done" mental models). Refine both.

This session's 8 documented errors classified:

1. md shipped without spawn-software walk → workstream-skip + contract-clarity
2. md shipped without tests → gate-skip (qa-evidence-complete) + workstream-skip
3. Source pure-functions in executable target blocked @testable import → build-test-validation + missing reviewGate ("library partition before tests")
4. Workflow-typing filed as beads → deferral-when-inline + layer-confusion (workflow.json vs workstream-template)
5. /wd step list didn't walk extractablePartitions → step-skip (missing manifest step)
6. Step-3 manifest-or-refine ran AFTER techo append in earlier mental model → sequencing
7. Workstreams partition extractRule was passive ("surface workstreams touched") → deferral-when-inline (rule allowed surface-only enumeration)
8. /wd update added step but didn't lead with errors → contract-clarity (extraction trigger ambiguous)

Each was refined in-session: 3 axiom promotions, 2 partition extractRule rewrites, 1 step insertion, 1 sequencing constraint, 1 manifest-or-refine sharpening.

Composes with [[feedback_errors-are-primary-evidence-for-workstream-refinement]] (the error-first discipline) + [[feedback_wd-extraction-targets-templates-not-runtime-instances]] (the ladder that layer-confusion errors point at) + [[feedback_gates-points-scoring-zero-on-gate-fail]] (substrate's anti-mechanism for gate-skip).
