---
name: agent-blame-shielded-workflow-doctrine-2026-05-26
description: "Substrate doctrine: agents never operate outside a typed workflow envelope. When operations go wrong, the FAULT TRACES TO THE WORKFLOW DEFINITION, not the agent. Workflows are typed JSON primitives with SOP companions, tested at substrate's tiered coverage standard. Removes the agent-as-blame-target framing; replaces with structural diagnosability. Operator-stated 2026-05-26 after the typelift thread + phases design: 'we should make it so that when something goes wrong, you are not blamed. what we want is a test based and workflow based approach. you don't work without a workflow.'"
metadata:
  node_type: memory
  type: insight
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-stated 2026-05-26 immediately after Phase being added as the 4th typed work-shape. The doctrine completes a structural triad of 2026-05-26 substrate-doctrine refinements:

1. **[[ordinality-table-entries-immutable-once-released]]** — typed shapes have freeze discipline (data)
2. **[[bead-vs-thread-vs-beat-shapes]]** — work artifacts have 4 typed shapes (work)
3. **THIS doctrine** — operations have typed workflow envelopes with shielded accountability (operation)

Together: substrate models data, work, AND operation structurally. The three doctrines compose: phases (work) invoke workflows (operation) over typed schemas (data). When anything breaks, the type-system tells you where.

## The principle

**Agents don't work outside workflows.** Workflows are typed JSON contracts, tested at substrate's tiered coverage standard, accompanied by markdown SOPs (human-readable operating procedures). When something goes wrong, the workflow definition gets fixed — not the agent.

The doctrine has STRUCTURAL implications, not just psychological framing:

- **Reproducibility** — workflow runs replay deterministically given inputs
- **Accountability** — bugs trace to typed workflow definitions
- **Testability** — workflows are testable independently of agent execution
- **Evolvability** — workflows improve in place; agents don't need rewiring
- **Multi-agent portability** — any agent executes the same workflow identically
- **Diagnosability** — failures get typed root-cause analysis, not vibes

## Why the framing matters

Agents that operate under "I might mess up and apologize" mode produce DEFENSIVE code: over-confirmation, excess hedging, request-for-permission loops. Agents that operate under "the workflow either works or gets fixed" mode produce STRUCTURAL code: typed contracts, tested invariants, durable artifacts.

The doctrine improves agent OUTPUT QUALITY by removing the blame-target framing. Workflow-blame is also LESS PERSONAL — operators don't feel they're criticizing the agent when they fix a workflow.

## Five structural implications — ALL ALREADY TYPED IN SCHEMA-UNIVERSAL

After authoring this memory I audited schema-universal per [[audit-schema-universal-before-authoring-new-types]] and discovered substrate has ~20+ workflow/operation-layer schema families already authored. The doctrine doesn't need new schemas — it needs WIRING and APPLICATION. See the investigation report at `private/universal/substrate/agents/claude/memory/.docc/investigation.docc/workflow-schema-universal-landscape-2026-05-26.md` for the full landscape.

1. **Workflow as typed primitive** — substrate has `workflow-schemas/v0.1.0` with `WorkflowModel` + `WorkflowGraphTopology` + `WorkflowGraphNode/Edge` + `WorkflowDispatchGroup` + ~25 supporting typed shapes. The contract exists.
2. **Workflow run / completion records** — substrate has `WorkflowCompletionPacket` + `WorkflowCompletionEvidence` + `WorkflowLifecycleValidationError/Failure` for typed completion + lifecycle errors.
3. **SOP as companion** — substrate has `operating-protocol-schemas/v0.1.0` with `OperatingProtocolModel` + `Axiom` + `Step` + `Trigger` + `Outcome`. This IS the typed SOP layer.
4. **Workflow tests** — every existing family already has tests (workflow-schemas has 6 test files including `WorkflowModelConsistencyBattleTests`); tiered coverage discipline applies as it did to ai-model-catalog-schemas.
5. **Agent operations always instantiate workflows** — the GAP. Substrate has the contract; existing markdown skills (wd / roster / thread-spin / thread-close / agent-setup) are NOT yet wired as typed `WorkflowModel` instances. This is the substrate-doctrine-application work, not new authoring.

## Substrate primitives this doctrine connects to

- **`operating-protocol-schemas`** — substrate already has SOPs typed per [[cross-agent-communication-via-documents]]. SOPs are the human-readable layer; workflows would be the executable layer underneath.
- **Skills** (wd, roster, thread-spin, thread-close, etc.) — currently markdown SKILL.md instructions. Under this doctrine, they graduate to typed workflows with markdown SOP companions.
- **Phases** (added today as 4th work-shape per [[bead-vs-thread-vs-beat-shapes]]) — phases are sequenced workflow chunks; a thread's phases invoke a sequence of workflows.
- **Identity contracts** per [[harnesses-agnostic-models-constrain]] — workflows are the layer where agent × harness × model bindings actually execute.
- **`work-graph-event-schemas`** + **`kickoff-receipt-schemas`** + **`substrate-compound-schemas`** — substrate has multiple workflow-adjacent schema families authored recently; the doctrine may extend EXISTING families rather than author entirely new ones (per [[audit-schema-universal-before-authoring-new-types]] discipline).

## The recursion

Workflows test workflows:
- A workflow defines steps for "audit a schema family for substrate-relevance"
- The workflow's test suite covers steps + pre/postconditions
- The workflow itself was AUTHORED via the "author-typed-workflow" workflow
- That workflow has its own tests
- The testing-discipline workflow is also a workflow

Substrate already lives this recursion at the schema layer (schemas test schemas via tests that are themselves schema instances). Extending to workflows is the same pattern one level up.

## Concrete example: how typelift work changes

Today: I authored a thread + 8 beads + 3 phases. Phase A execution (vendor) would be me running `git submodule add` interactively while pattern-matching operator intent.

Under the doctrine: Phase A invokes a typed `vendor-org-as-maintainer-submodules-workflow` (versioned, tested, SOP-documented) taking inputs `{ org: "typelift", licenseFilter: "Apache-2.0", target: "maintainers/typelift/.../spm/" }` and producing a typed `WorkflowRunModel` record. If the workflow has a bug (omits a license check, mishandles a missing tag), the workflow gets a v0.2.0 cut with a regression test. The agent isn't blamed; the workflow gets better.

## How to apply

1. **When authoring a NEW agent operation**, default to: "what's the typed workflow that defines this?" Not: "what should I do?"
2. **When a skill exists as markdown SKILL.md**, graduate it to typed workflow + SOP companion when next touched.
3. **When something goes wrong**, the diagnostic question is: "what's the workflow gap that allowed this?" Not: "what did the agent do wrong?"
4. **When designing substrate features**, ask: "does this require a new workflow? does it extend an existing one? is there an existing schema family in schema-universal we can extend (per [[audit-schema-universal-before-authoring-new-types]])?"
5. **Apply tiered coverage to workflows themselves** — Tier 3 exhaustive truth-table tests on workflow step transitions, decoder rejection of malformed workflow JSON, invariant tests for workflow lifecycle states.

## When NOT to apply

- **Truly trivial operations** (ls, cat, simple read) don't need workflow envelopes. The doctrine is for operations that have multiple steps, that have consequences, that could fail in interesting ways.
- **One-off exploratory commands** while debugging — these are research, not production execution. They convert to workflows when the pattern stabilizes.
- **Hardcoded substrate setup steps** that fire once at substrate genesis — these are bootstrap, not steady-state.

## Related memories

- [[bead-vs-thread-vs-beat-shapes]] — the 4 work-shape vocabulary (phases invoke workflows)
- [[ordinality-table-entries-immutable-once-released]] — freeze discipline applies to WorkflowModel case mappings + step ordinals
- [[cross-agent-communication-via-documents]] — SOPs are the cross-agent communication shape; workflows are the executable side
- [[harnesses-agnostic-models-constrain]] — workflows are the layer where agent × harness × model bindings execute
- [[every-property-fights-for-its-life]] — "agent operation" was an embedded implicit shape; this doctrine graduates it to a typed family
- [[definitions-are-json-not-markdown]] — workflows are JSON contracts; SOPs are markdown companions
- [[audit-schema-universal-before-authoring-new-types]] — before authoring workflow-schemas, audit what substrate already has
- [[tradition-preserves-fire-not-ashes-2026-05-25]] — agent-operation-as-typed-reproducible preserves the fire (substrate operation); workflow-blame-shielding preserves the operator's intent without burning agents as blame-targets
