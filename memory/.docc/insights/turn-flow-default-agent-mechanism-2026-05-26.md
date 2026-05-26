# Turn flow: default-agent mechanism

Observed shape of a Claude turn that diagnosed a bug, designed a structural
fix, executed a multi-file schema migration, and reported. Captured as a
case study for the substrate's supplement + digikoma factoring per the
"produce bounded executors that absorb work agents would otherwise spend
tokens/attention on" doctrine — refined to distinguish during-turn
supplements from turn-end digikomas.

Case: the operator asked "the default agent for hulk is claude, not chatgpt,
how did we get here?" That turn became (1) trace data flow → (2) propose
typed structural fix → (3) iterate on placement/scope → (4) execute a
schema-edit + identity-migration + resolver-wiring + verification sweep.

This document is doctrine on the *shape* of that turn — not a transcript
of its outcome. The shipped artifacts live in commits; the workflow lives
here.

## Preamble: the native-harness layer

Beneath the agent's observable turn behavior there is a **native-harness
layer** (in this carrier: claude-code) responsible for the inference loop,
tool dispatch, prompt-cache management, conversation context shaping, and
the actual model invocation. This layer is opaque from the agent's side and
intentionally out of scope for this document. The agent cannot expose
native-harness internals; the operator does not need them to design
supplements and digikomas around the agent's observable surface.

Naming the layer matters even when we can't document it: every contract
proposed below should be designed assuming the native harness *already
handles* the turn-orchestration plumbing. A supplement that tried to
re-implement tool dispatch or context management would be in the wrong
layer of the stack.

## Three-layer model

```
[NATIVE HARNESS — opaque, claude-code internals]
   tool dispatch · context management · prompt cache · the loop itself
        │
        ▼ (turn invocation)
[AGENT ACTIVE TURN]
   judgment · design lock · conversation · root-cause reasoning · report
        │
        ├──────────► [SUPPLEMENTS]  (run during the turn, in parallel)
        │                augment turn capacity — never replace the agent
        │
        ▼ (turn end)
[DIGIKOMAS]
   bounded one-shot executors for persistence / observability
```

- **Supplements** run *during* the turn, as parallel cognitive helpers.
  They take typed sub-task contracts and emit typed reports back to the
  agent's working set. Example: a testing supplement that decides what to
  test, writes companion tests, runs them, interprets failures, and
  suggests follow-ups while the agent works on the next edit.
- **Digikomas** run *at turn end* (or between turns), as one-shot bounded
  executors with a single typed input → typed output handoff. Canonical
  example: the savepoint pair (`savepointd` + `digikoma-savepoint`)
  taking a `CommitRequestModel` and landing the commit.

See [[feedback_supplements-vs-digikomas-during-vs-turn-end]] for the
terminology contract.

## Two interleaved modes inside the agent layer

A turn touching typed substrate state weaves two distinct agent-side
modes:

1. **Conversational refinement** — operator + agent iterate on what the
   problem is, what the fix should look like, and how big a scope it
   should take. Pure judgment. Cannot be delegated to anything.
2. **Solo execution** — agent does discovery, edits, builds, tests, and
   reports. Mix of judgment and mechanical work. The mechanical sub-steps
   are where supplements attach.

Conversational mode produces the contract solo execution honors. A
supplement cannot stand in for the operator's preferences, scope
decisions, or judgment calls about substrate doctrine — those are
upstream of any delegated work.

## Execution phase decomposition with supplement attachments

Seven phases observed in the default-agent turn, generalizable to any
typed-substrate-state turn. Each phase shows what's agent-only versus
what the parallel supplement stream can absorb.

### Phase A — pre-flight discovery

Goal: build the cognitive model needed to make safe edits.

What I did this turn: located `HarnessSessionResolver.swift` and the agent
resolution path; read IdentityModel v0.6.0 + JSON schemas + tests; located
LinkRefModel v0.3.0 wire shape; audited how many other identities are
already at v0.6.0 (zero — hulk would be first); located the v0.5→v0.6 host
migrator + corpus migrator + bridge; audited blast radius across hulk's
chronicle / organism schema versions.

- **Agent**: chooses which questions to ask, judges when the model is
  complete enough to design from
- **Discovery supplement (parallel)**: typed substrate exploration that
  returns a `DiscoverySurveyReport` while the agent is reading early
  context — emitting blast-radius audit, cohort-size count, canonical
  reference impl, migrator paths, all in a single typed bundle

### Phase B — design lock

Goal: convert the conversational contract into an executable edit plan.

What I did this turn: decided IdentityModel gets `defaultAgentRef:
LinkRefModel?` as a singleton mirroring `ghostRef`; decided to add in
place on v0.6.0 (no v0.7.0 bump) per [[feedback_ordinality-table-entries-immutable-once-released]]
since field-addition is forward-additive; decided to bundle hulk's full
v0.5→v0.6 migration with the field addition because v0.6.0 IdentityModel
decoder strict-validates schemaVersion.

- **Agent only**. No supplement attaches here.
- Anti-pattern: do not let a supplement "propose the design." It will
  not know which substrate-canonical pattern to mirror (`ghostRef`
  here), the version-bump policy, or the operator's scope preference.
  Design lock stays with the agent.

This is the one phase with no parallel stream. That is a meaningful
telemetry signal — see "what this unlocks" below.

### Phase C — schema edit + focused tests

Goal: make the typed source-of-truth change with test coverage.

What I did this turn: six Codable-boilerplate edits to
`identity-model.swift` (property, init param, CodingKey, decode, encode,
doc-comment); one new round-trip test in
`identity-model-v6-tests.swift`; build + test verification.

- **Agent**: writes the edits, judges where the field lives, writes the
  test assertion shape and doc-comment line
- **Testing supplement (parallel)**: as the agent writes each edit,
  decides whether a companion test exists / needs to be added, runs the
  focused test suite for the package, returns `TestRunReport { passed[],
  failed[], suggestions[] }` so the agent doesn't context-switch into
  test parsing

### Phase D — data migration

Goal: bring affected on-disk records into the new schema.

What I did this turn: dry-ran the corpus migrator and discovered hulk's
legacy `{kind, slug}` lacks the IdentityRefModel discriminator (migrator
skipped); read the IdentityRef→LinkRef bridge translation rules;
hand-crafted the Kleene-UNKNOWN LinkRef for `agendaRefs[0]` and the
populated LinkRef for `defaultAgentRef`; stripped redundant prose from
`purpose`.

- **Agent**: chooses migrator-vs-hand-craft, picks which bridge rule
  applies, decides what prose to strip
- **Testing supplement (parallel)**: decode-verifies the migrated file
  against the target schema, reports `status: ok` or surfaces decoder
  errors back to the agent

### Phase E — wiring + integration build

Goal: connect the new typed surface to its consumers.

What I did this turn: updated `HarnessSessionResolver.defaultAgentSlug`
to take harness slug + root; wrote a minimal local Decodable
`HarnessIdentityDefaults` instead of adding `identity-schemas-v000-006-000`
as a package dependency (avoided 7 transitive schema-package additions);
build + test verification.

- **Agent**: chooses where the lookup goes in the precedence chain,
  decides full-dep vs local-minimal-decoder
- **Testing supplement (parallel)**: runs the integration test suite for
  the touched package, reports pass/fail
- Anti-pattern: do not let a supplement pick the package-graph
  topology. Local-decoder vs full-dep is a substrate design call that
  affects compile times, transitive surface area, future refactors.

### Phase F — verification + regression diagnosis

Goal: prove the mechanism works; explain any new failures.

What I did this turn: decode-tested hulk's identity via
`swift-agent-cli profile`; resolver-tested via
`swift-harness-cli session resolve --harness hulk` (proved claude was
picked); ran the full SwiftHarness suite (32/32 pass); noticed hulk
roster row flipped from clean → `x`; doctor-traced across all five
identity kinds; root-caused to a missing `hulk@*.agenda.json` file
(pre-existing condition surfaced by v0.6.0 strict mode).

- **Testing supplement (parallel)**: runs the doctor sweep across all
  identity kinds, captures the roster row diff before+after, emits a
  `RegressionReport { newFailures[], preExistingFailures[] }`
- **Agent**: applies root-cause reasoning when the supplement reports
  failure — cross-referencing doctor output, sibling working setups,
  schema strict-mode behavior. This is the supplement → agent escalation
  path.

### Phase G — typed report

Goal: produce the summary the operator reads.

What I did this turn: wrote a markdown summary (what landed, what's
verified, what's out of scope) with Insight blocks per the explanatory
style.

- **Agent only**. The summary is the agent's narrative.
- A supplement can emit typed facts feeding the summary, but the agent
  decides what's worth surfacing.

### Turn end — savepoint digikoma

After the agent's final reply, the savepoint pair takes over:
`savepointd` accepts a `CommitRequestModel` constructed from the agent's
session context, runs the actual git operations, and emits a typed
commit record. This is the canonical turn-end digikoma — the prototype
for any future persistence/observability digikomas.

See the `savepoint` skill for the existing canonical contract.

## What can't be delegated (anti-patterns)

These belong to the agent. A supplement or digikoma that tried to do them
would produce mis-shaped output:

1. **Design lock** (Phase B). The choice of where a new typed surface
   lives, which sibling pattern to mirror, whether to bump schema version
   or add in place. A supplement has no substrate doctrine in scope.
2. **Scope decisions during conversational refinement.** When the
   operator says "let's do option B but no bump," that's a contract
   update. The agent re-derives; no delegation.
3. **Root-cause analysis when verification fails.** Phase F regression
   diagnosis required pattern-matching across loose evidence (doctor
   output, gemini's working setup, organism schema versions, v0.6.0
   strict-mode behavior). Judgment.
4. **The final report's narrative.** Supplements emit typed facts; only
   the agent decides what's worth surfacing.
5. **Package-graph topology decisions** (Phase E). Local decoder vs full
   dependency is a substrate-doctrine call.
6. **Prose edits in typed files** (e.g. stripping "(default: claude)"
   from `purpose`). These require reading what the prose *means* now
   that the typed slot exists.

## Supplement and digikoma inventory

| | Phase(s) | Typed contract sketch | Status |
|---|---|---|---|
| **Discovery supplement** | A | `{ kind: "migration-survey", schemaFamilyRef, sourceVersion, targetVersion } → DiscoverySurveyReport { migratorPaths[], existingMigratedInstances[], cohortSize, blastRadiusFiles[], canonicalReferenceImpl? }` | proposed |
| **Testing supplement** | C, D, E, F | continuous stream: `{ recentEdits[], scope: "focused" \| "integration" \| "doctor-sweep" } → TestRunReport ∪ RegressionReport` emitted as the agent works | proposed |
| **Savepoint digikoma** | turn end | `CommitRequestModel → CommitLandedRecord` | exists ([[savepoint]] skill) |

The two dropped from the prior draft (`add-codable-field`,
`linkref-translator`) are tools/macros — pure mechanical translation
with no cognitive work, no parallel stream. They might still be useful
as editor macros but they don't fit the supplement contract.

## Cost-ledger consequences

Supplements and digikomas compose with the cost-sync pattern
([[insights/substrate-sync-cost-pattern-2026-05-26]]) but they emit
*different invoice shapes* because their temporal scopes differ:

- **Supplements emit `ContinuousInvocationInvoice`** — per-second (or
  per-cognitive-step) cost accrual during the turn. The supplement is
  "open" for the duration of its parallel stream.
- **Digikomas emit `OneShotInvocationInvoice`** — single typed cost at
  the handoff event.

This distinction needs to be baked into the cost-sync schema *before*
the first supplement ships, because invoice shapes are hard to migrate
once production runs accumulate. Reference: the substrate's existing
`inference-account-schemas v0.2.0` should be the composition point.

## What this unlocks

If the discovery + testing supplements and the savepoint digikoma
absorbed the parallel work from this turn, the agent's remaining surface
would have been:

- Conversational refinement with the operator (4 exchanges)
- Phase B design lock (~3 decisions)
- Phase E topology call (1 decision: local decoder vs full dep)
- Phase F root-cause reasoning (1 investigation: why hulk regressed)
- Phase G report narrative (1 markdown summary)
- (savepoint digikoma fires after, no agent work)

That's the higher-importance surface. Discovery grep loops, doctor
sweeps, build+test parsing, commit ceremony — all delegable.

**Telemetry signal worth tracking**: time spent in Phase B (design lock)
should *not* shrink as supplements are introduced. If it does, the
supplements have over-reached into doctrine-judgment territory. Phase B
time is the agent's load-bearing contribution; preserving it is the
test that the factoring is healthy.

## Cross-references

- Terminology contract: [[feedback_supplements-vs-digikomas-during-vs-turn-end]]
- Digikoma factory doctrine: [[insights/substrate-is-digikoma-factory-2026-05-23]]
- Cost-sync pattern supplements + digikomas compose with: [[insights/substrate-sync-cost-pattern-2026-05-26]]
- Schema-version doctrine (why "in place" was valid here): [[feedback_ordinality-table-entries-immutable-once-released]]
- Same-shape doctrine (why singleton + plural pairs work): [[feedback_same-shape-same-model]]
- Class-name = discriminator (the doctrine the singleton field reifies):
  [[feedback_class-name-equals-json-key-discriminator]]
- Canonical turn-end digikoma already in the substrate: `savepoint` skill
