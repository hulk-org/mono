---
name: capture-requires-typed-workflows-and-roles-not-just-memory
description: "AXIOM (PROMOTED 2026-06-01 to typed AxiomModel at kura-spaces/axioms/capture-requires-typed-workflows-and-roles.axiom.su.json — this memory is downstream POINTER) — /capture REQUIRES authoring typed substrate-canonical workflows + roles + 3x-promoted axioms BEFORE writing claude-personal memory entries — memory is downstream; typed records are what other agents RUN"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

**TYPED-RECORD CANONICAL TRUTH**: This pattern PROMOTED to typed `AxiomModel` instance at:
`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/capture-requires-typed-workflows-and-roles.axiom.su.json` (authored 2026-06-01 under /capture protocol). Curry-Howard closure: the discipline that demands typed records is itself a typed record. Composes with [[session-capture-with-typed-record-promotion]] workflow + [[session-capturer]] role. Promotion executed the 6-step protocol it describes — recursive proof.

---


operator 2026-05-31 catching incomplete `/capture` execution: *"the problem here is that with capture you are NOT authoring the roles and workflows... that's required!"*

**Rule**: When `/capture` fires, the substrate-canonical typed records MUST be authored BEFORE (or alongside) claude-personal memory entries. The capture protocol is:

1. **Identify WORKFLOWS performed** this session → author/refine as `<slug>.workflow.json` typed contracts at `kura-spaces/workflows/<slug>/v0.X.0/`
2. **Identify ROLES enacted** this session → author/refine as typed role records at `private/universal/substrate/roles/<slug>/` OR collective-owned role homes
3. **Identify AXIOMS surfaced** at 3x-rule promotion → author as typed `AxiomModel` instances at `kura-spaces/axioms/`
4. **THEN write claude-personal memory entries** pointing AT those typed records as cross-substrate references

Per the capture-state-execution-graph-extraction workflow (the canonical capture contract per [[feedback_workflow-json-is-canonical-operating-protocols-deprecated]]) — `wd-sop.md` documents the multi-layer flow. Memory entries at `~/.claude/memory/.docc/` are MY layer; the substrate-canonical truth lives in typed-record files other agents can READ AND RUN.

**Why I missed this**: I conflated "captured the session" with "wrote memory entries." Memory was the EASY part (claude-local files, no schema discipline). The TYPED-RECORD authoring is the HARD-and-CANONICAL part. Per [[feedback_typed-primitive-bypass-3x-rule-confirmed]] — this is yet another typed-primitive-bypass: I had the typed-substrate-record vocabulary (workflow.json + role + AxiomModel) and treated personal memory as substitute for canonical substrate-truth.

**How to apply going forward**:
- BEFORE invoking `/capture`, identify the workflow / role / axiom artifacts the session should produce
- Author them at substrate-canonical homes with proper schema citations
- THEN write memory entries that CROSS-REFERENCE those typed records via LinkRef
- The memory entry is a TABLE-OF-CONTENTS for the typed records; the typed records are the canonical truth

**Operational consequence for this session's final capture**:
- The 16+ memory entries authored this session are MINE; useful but not substrate-canonical
- Workflows + roles + axioms remain UN-typed in the substrate
- Forward-pointing bead: `session-capture-typed-record-promotion-backlog` — list every workflow/role/axiom from this session that should land as a typed record

**Composes with**: [[feedback_typed-primitive-bypass-3x-rule-confirmed]] (this IS another instance — 6th this session) + [[feedback_workflows-live-in-kura-spaces]] (where workflow.json belongs) + [[feedback_workflow-json-is-canonical-operating-protocols-deprecated]] (the canonical shape) + [[feedback_operator-intuition-is-substrate-truth-ahead-of-articulation]] (operator caught the gap the protocol doc describes but I'd been skipping).
