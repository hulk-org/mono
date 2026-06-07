# Workflow schema-universal landscape (2026-05-26)

@Metadata {
  @PageColor(blue)
}

Substrate already has the typed surface needed to materialize the agent-blame-shielded workflow doctrine. The audit revealed ~20+ existing schema families covering workflow definitions, operating protocols (SOPs), workflow graph doctrine, completion records, lifecycle validation, work-graph events, missions, scenarios, workstreams, kickoff receipts, and operating rhythm. The next move is NOT to author new schemas — it's to comprehend the existing surface, identify genuine gaps, and graduate existing markdown skills (wd / roster / thread-spin / thread-close / agent-setup) to typed `WorkflowModel` instances against the existing contract.

## What this investigation is for

The operator stated 2026-05-26: *"we should make it so that when something goes wrong, you are not blamed. what we want is a test based and workflow based approach. you don't work without a workflow."* My first instinct was to propose authoring a `workflow-schemas` family from scratch. Per [[audit-schema-universal-before-authoring-new-types]] I audited substrate first — and discovered the surface already exists. This report captures what's there, how it composes, and where the actual gaps are.

## What substrate already has (the typed surface)

### Layer 1 — workflow contracts

**`workflow-schemas/v0.1.0`** at `private/universal/substrate/collectives/schema-universal/private/universal/domain/system/schema-families/workflow-schemas/v0.1.0/spm/`

Central type: `WorkflowModel` (Codable, Sendable, SemanticVersionable).

Composed shapes (~28 total):

| type | role |
|---|---|
| `WorkflowModel` | central workflow contract |
| `WorkflowWhy` | typed justification chain (agendaRefs, workstreamRefs, principleRefs, horizonRefs, rationale) |
| `WorkflowGraphNode` + `WorkflowGraphEdge` | typed graph structure of the workflow's steps |
| `WorkflowGraphEdgeKind` | typed edge classification |
| `WorkflowGraphTopology` | composed graph definition |
| `WorkflowDispatchGroup` + `WorkflowDispatchStrategy` + `WorkflowDispatchJoinPolicy` | fan-out / fan-in / serial / parallel typed strategies |
| `WorkflowFanOutPolicy` + `WorkflowFanOutFailurePolicy` | typed failure handling |
| `WorkflowPathItem` + `WorkflowPathArrangement` + `WorkflowPathArrangementMode` | typed execution paths |
| `WorkflowWorkSurface` | what the workflow operates on |
| `WorkflowCriticalUserJourney` | CUJ binding |
| `WorkflowProductRequirement` + `WorkflowRoleRequirement` + `WorkflowRoleFrontierCapability` | typed requirements |
| `WorkflowRoleSessionPerformance` + `WorkflowRoleTimespan` + `WorkflowRoleCostLimits` | typed measured execution stats + bounded resources |
| `WorkflowKeiko` + `KeikoWorkflow` + `WorkflowKeikoSignal` + `WorkflowKeikoStatus` + `WorkflowKeikoSignalKind` | 稽古 (practice/training) pattern — workflows-as-rehearsable |
| `WorkflowCompletionPacket` + `WorkflowCompletionEvidence` | typed completion records (Identifiable) |
| `WorkflowLifecycleValidationError` + `WorkflowLifecycleValidationFailure` | typed lifecycle errors (Error-conforming) |

Tests: 6 test files including `WorkflowModelConsistencyBattleTests.swift` (adversarial-tier already present).

### Layer 2 — SOP / operating protocol

**`operating-protocol-schemas/v0.1.0`** at `private/universal/substrate/collectives/schema-universal/private/universal/domain/system/schema-families/operating-protocol-schemas/v0.1.0/spm/`

| type | role |
|---|---|
| `OperatingProtocolModel` | central SOP contract |
| `OperatingProtocolAxiom` | declared invariant of the protocol |
| `OperatingProtocolAxiomContextRef` | context binding |
| `OperatingProtocolStep` | one typed step in the SOP |
| `OperatingProtocolTrigger` | typed activation trigger |
| `OperatingProtocolOutcome` | typed expected outcome |
| `OperatingProtocolSchemaVersion` | version anchor |

This IS substrate's typed SOP layer. Each markdown skill should have an `OperatingProtocolModel` instance alongside it (or instead of it).

### Layer 3 — workflow graph doctrine

**`workflow-graph-doctrine-schemas/v0.1.0`** at `private/universal/substrate/collectives/schema-universal/private/universal/domain/system/schema-families/workflow-graph-doctrine-schemas/v0.1.0/spm/`

| type | role |
|---|---|
| `WorkflowGraphDoctrine` | the doctrinal record itself |
| `WorkflowGraphNode` (doctrinal) + `WorkflowGraphNodeKind` | typed node-kind classification |
| `WorkflowGraphEdge` (doctrinal) + `WorkflowGraphEdgeKind` | typed edge classifications |
| `WorkflowGraphSpawnRule` | when nodes spawn other nodes |
| `WorkflowGraphLoopInvariant` | loop-termination guarantees |
| `WorkflowGraphLoopProof` | typed proof of loop termination |

This is the *meta-doctrine* layer — how workflows compose, when they spawn, when they loop, when loops terminate.

### Layer 4 — adjacent / supporting families

These compose with workflow-schemas at higher or lower abstraction:

| family | layer | role |
|---|---|---|
| `substrate-compound-schemas/v0.1.0` | compound | "compound layer above molecules" — composes multiple workflows |
| `work-graph-schemas` | work graph | the work graph workflows execute against |
| `work-graph-event-schemas` | events | typed events on the work graph |
| `mission-schemas` | strategic | mission-level coordination above workflows |
| `scenario-schemas` + `scenario-session-schemas` | scenarios | scenario definitions + sessions |
| `workstream-schemas` + `workstream-template-schemas` | workstreams | sustained streams of work |
| `role-workflow-schemas` | role-specific | workflows scoped to a role |
| `kickoff-receipt-schemas` + `kickoff-review-schemas` | kickoff | typed workflow-start events |
| `execution-receipt-schemas` + `receipt-schemas` | receipts | typed execution evidence |
| `operating-rhythm-schemas` | rhythm | cadence patterns workflows live in |
| `ifttt-directive-schemas` | if-then | typed conditional directives |
| `conversation-protocol-schemas` | conversation | typed conversation flow |
| `release-operations-schemas` | release | release-tier workflows |
| `paperclip-issue-protocol-schemas` | issues | bead / issue typed shape |

## How they compose (the doctrine triad applied)

The substrate-vocabulary triad I named in `[[agent-blame-shielded-workflow-doctrine-2026-05-26]]` (data / work / operation) maps onto schema families:

- **Data layer**: ordinality tables (per [[ordinality-table-entries-immutable-once-released]]) + identity-schemas + LinkRef + every typed JSON record
- **Work layer**: thread-schemas (with phases per [[bead-vs-thread-vs-beat-shapes]]) + paperclip-issue-protocol-schemas (beads) + workstream-schemas + mission-schemas + scenario-schemas
- **Operation layer**: workflow-schemas + operating-protocol-schemas + workflow-graph-doctrine-schemas + receipt-schemas + work-graph-event-schemas + substrate-compound-schemas

The doctrine I articulated already exists IN TYPED FORM across the operation layer. What I named "WorkflowRunModel" probably maps to a combination of `WorkflowCompletionPacket` + `execution-receipt-schemas` + `work-graph-event-schemas`. What I named "WorkflowStepModel" maps to `WorkflowGraphNode` and `OperatingProtocolStep`. What I named "agent-blame-shielding" is the SEMANTIC LENS on top — substrate has the data, but the *framing* I named is what the doctrine memory adds.

## Where the gaps actually are (the application work)

After the audit, the genuine gaps:

### Gap 1 — Skills are not yet typed WorkflowModel instances

The markdown skill files (e.g., `~/.claude/skills/wd/SKILL.md`, `roster/SKILL.md`, `thread-spin/SKILL.md`) describe operations in prose. They have no typed `WorkflowModel` instance attached. Per the doctrine, every skill should have a `<skill>-workflow.json` (typed WorkflowModel) + `<skill>-sop.md` (companion operating-protocol record + human description).

This is the substrate-doctrine-application work. ~10-15 skills to graduate. Pilot candidates: `wd`, `roster`, `thread-spin`, `thread-close`, `agent-setup`.

### Gap 2 — Agent-side enforcement layer

The doctrine claims "agents never operate outside a workflow envelope." Substrate has the typed contract, but the agent's RUNTIME enforcement is implicit. There's no substrate-level guard that says "I refuse to execute this operation without a WorkflowModel binding."

This is a harness / agent-runtime concern, not a schema concern. The schemas exist; the runtime wiring is the work. Possibly relevant: `harness-header-schemas`, `ai-harness-schemas`. Worth a follow-up investigation.

### Gap 3 — Blame-shielding framing as captured doctrine

The substrate has `WorkflowLifecycleValidationError` and `WorkflowLifecycleValidationFailure` — typed errors. But the FRAMING — "agent not blamed; workflow gets fixed" — isn't captured anywhere as substrate-doctrine text. The doctrine memory I just wrote (`[[agent-blame-shielded-workflow-doctrine-2026-05-26]]`) captures it.

This is doctrine, not schema. Memory + this investigation are the captures. Future tooling (linting, agent-runtime error handlers) can reference the memory for the framing.

### Gap 4 — Cross-family composition documentation

The 20+ families compose, but the COMPOSITION isn't documented as substrate-doctrine. How does `WorkflowModel` reference an `OperatingProtocolModel`? How does a workflow produce a `WorkflowCompletionPacket` that gets indexed in `execution-receipt-schemas`? How does substrate-compound-schemas wrap multiple workflows into a compound?

This is the comprehension work the beads spawn for.

## Recommended next moves (the beads)

**Comprehension beads** (read existing surface, produce typed reports):

1. `audit-workflow-schemas-v0.1.0-surface` — read every type in workflow-schemas; produce typed summary
2. `audit-operating-protocol-schemas-v0.1.0-surface` — same for operating-protocol-schemas
3. `audit-workflow-graph-doctrine-v0.1.0-surface` — same for the doctrine layer
4. `author-workflow-family-composition-map` — typed report showing how the ~20 families compose

**Application beads** (graduate skills to typed workflows):

5. `graduate-wd-skill-to-typed-workflow` — pilot the doctrine on the most-invoked skill
6. `graduate-roster-skill-to-typed-workflow`
7. `graduate-thread-spin-skill-to-typed-workflow`
8. `graduate-thread-close-skill-to-typed-workflow`
9. `graduate-agent-setup-skill-to-typed-workflow`

**Runtime-enforcement bead** (gap 2):

10. `investigate-agent-side-workflow-envelope-enforcement` — how does substrate enforce "agents never operate outside a workflow"? Possibly harness-header-schemas; possibly a new typed enforcement primitive; possibly purely a discipline/lint check.

## Open questions

1. **Should the 5-10 application beads be one thread or stand-alone?** Multi-phase work suggests one coordinating thread (`skills-to-typed-workflows-modernization-2026-05-26`) with phases for comprehension / pilot-application / full-application.
2. **Which markdown skill graduates first?** `wd` is most-invoked; `roster` is simpler; `thread-spin` is structural. Operator pick.
3. **Does `WorkflowKeiko` apply to skill graduation?** The "practice" pattern suggests we could rehearse a skill's workflow before locking — useful for skills where errors are costly. Worth a dedicated investigation.
4. **Substrate-doctrine: does Gap 2 (agent-side enforcement) get its own typed primitive, or is it pure runtime discipline?** I lean toward runtime discipline backed by lint checks (substrate doesn't ship for users; agents can self-enforce). But operator may want a typed `AgentExecutionContextRequirement` or similar.

## Recommended next move

**Start with comprehension before application.** Read workflow-schemas v0.1.0 in detail (1-2 beads), then pilot the doctrine on `wd` (most-frequent, highest-value-validation). Don't graduate 5 skills at once — pilot one, validate the pattern, then fan out.

Specifically: bead `audit-workflow-schemas-v0.1.0-surface` next, then `graduate-wd-skill-to-typed-workflow`. The other 7 beads become a Phase 2 cohort once the pattern is proven.

## Related substrate doctrine

- [[agent-blame-shielded-workflow-doctrine-2026-05-26]] — the doctrine this investigation lands against
- [[audit-schema-universal-before-authoring-new-types]] — the discipline that prevented me from re-authoring existing surface
- [[bead-vs-thread-vs-beat-shapes]] — phases (added 2026-05-26) compose with workflows
- [[ordinality-table-entries-immutable-once-released]] — applies to workflow ordinality fields (WorkflowDispatchStrategy, WorkflowFanOutPolicy, etc.)
- [[harnesses-agnostic-models-constrain]] — workflows are the layer where agent × harness × model bindings actually execute (Gap 2)
- [[cross-agent-communication-via-documents]] — SOPs are cross-agent communication; OperatingProtocolModel is the typed shape
