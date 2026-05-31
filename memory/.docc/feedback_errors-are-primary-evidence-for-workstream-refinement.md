---
name: errors-are-primary-evidence-for-workstream-refinement
description: "Errors (technical + doctrinal) are the substrate's primary evidence for what workstreams/workflows are missing or under-documented. /wd extraction must lead with error inventory, not passive \"what was touched\" enumeration."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

Errors are the SUBSTRATE'S PRIMARY EVIDENCE for what workstreams and workflows are missing or under-documented. /wd extraction MUST lead with error inventory, not passive "what was touched" enumeration.

**Why:** technical errors (build failures, test failures, validation rejections) and doctrinal errors (operator-surfaced violations: "you didn't run the spawn-software workstream", "we want TEMPLATE extraction", "the wd step doesn't actually manifest workstreams") both REVEAL gaps in the typed contract. Passive enumeration ("here are the workstreams I touched") preserves the surface but doesn't refine the doctrine. The substrate gets better by closing the gaps errors surfaced, not by listing what was visible.

Operator 2026-05-31 (CLIA, during wd-skill refinement): "we need to make sure to focus on ERRORS and what was not documented in the workstreams and workflows". Two preceding catches that triggered this: (a) "did you role and workflow extract /wd" (wd-skill itself wasn't being /wd-extracted from); (b) "remember that we want to do workflow TEMPLATE extraction" (templates were being deferred to beads). Both were errors-as-evidence — the operator was treating my omissions as substrate-shape signal, not as personal-fault correction.

**How to apply:** when /wd step 3 (manifest-or-refine-typed-artifacts) runs:

1. **FIRST inventory errors encountered this session.** Include both technical (compile/test/lint/validation) and doctrinal (operator-surfaced contract violations, skill-protocol skips, deferral-when-inline-would-work).
2. **For each error, identify which workstream or workflow was being executed when it occurred.** If no workstream/workflow was named, that's its own gap — the session was operating without typed contract.
3. **For each implicated workstream/workflow, identify what was undocumented or under-documented in its typed contract that allowed the error.** Examples: a workstream-template missing a `reviewGates[]` entry that would have caught the issue; a partition's extractRule being passive when it should have been active; a step missing from `steps[]` that would have triggered the action; an axiom not yet promoted that would have encoded the doctrine.
4. **AUTHOR or REFINE the implicated workstream-template/workflow-series to close the documentation gap.** This is the refinement loop. Without it, the doctrine stagnates and the same error recurs in the next agent's session.
5. **Mark-empty-not-omit** if no errors surfaced — but be skeptical of empty-marks; most sessions have at least one doctrinal slip if examined honestly.

Substrate diagnostic: if /wd extraction produces a chronicle entry summarizing the session without naming any error and any implicated workstream/workflow refinement, the extraction was probably surface-only.

Composes with [[feedback_wd-extraction-targets-templates-not-runtime-instances]] (the 3-shape ladder) + [[feedback_spawn-software-workstream-required-for-tool-authoring]] (the canonical "doctrinal error reveals workstream gap" example) + [[feedback_gates-points-scoring-zero-on-gate-fail]] (the substrate's anti-mechanism that turns hidden gaps into hard zeros).
