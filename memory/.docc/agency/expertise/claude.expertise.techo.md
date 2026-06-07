# claude expertise Techo

Generated from Shinji Techo JSONL.

- Segments: 1
- Entries: 6

## Five durable doctrines from the savepoint factory build. Domains exercised, commands verified, sharp edges discovered, future operator guidance.

Five durable doctrines from the savepoint factory build. Domains exercised, commands verified, sharp edges discovered, future operator guidance.

- Time: `2026-05-24T02:01:25Z`
- Kind: `winddown.expertise`
- ID: `claude-timeline-1779588085-0`
- Captured At: `2026-05-24T02:08:53Z`
- Moment Ref: `moment-claude-timeline-1779588085-0`
- Segment: `claude-timeline-second-segment-1779588085`
- Delta: `0`
- Sequence: `0`
- Tags: `wd`, `techo`, `shinji`, `expertise`, `doctrine`, `savepoint`, `factory`, `digikoma-pattern`

### Details

#### Verified Commands

- savepoint-cli emit --harness claude-code --session-id "$CLAUDE_CODE_SESSION_ID" — canonical commit emission
- savepoint-cli emit --harness <unknown> --session-id <id> --chat-path <path> — escape hatch for unknown harnesses
- swift run --package-path private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/swift-agent-cli swift-agent-cli doctor --slug <slug> [--kind agent|agenda|chronicle] --path . — per-home schema validation
- swift build -c release --package-path <pkg> --product <name>  +  ln -sf <build>/release/<name> ~/.local/bin/<name> — manual install pattern pre-wrkstrm-identifier integration
- git -C <submodule> rev-parse --absolute-git-dir — resolves true gitdir (handles submodule .git-as-file indirection)
- git -C <submodule> diff --cached --name-only — REQUIRED scope check between git add and git commit

### Payload

```json
{
  "actorAgent" : "claude",
  "agentSlug" : "claude",
  "domains" : [
    "Substrate service pattern: @SubstrateService + SubstrateServiceContract + ServiceCategory + service-universal versioned contracts + common-imprint typed ledgers + common-process spawning",
    "Digikoma factory pattern: 5-target Package.swift (Tool + Service + FoundationModelsTool + cli + tests) per package, mirroring digikoma-hello-world",
    "Schema versioning across three independent axes (set version pinned in schemaSetRefs[0].set, family version pinned in file-level schemaVersion, record discriminator per typed Codable via SemanticVersionable)",
    "Per-resource queue management primitive (pending/claimed/applied/failed atomic-rename state machine in ResourceQueue<Intent>)",
    "Agent-side typed emitter (CLI + library composition; CLI requires explicit --harness + --session-id to prevent cross-session misrouting)",
    "Shinji-techo v0.2.0 wd records with required operator-authored quote field + relativePath LinkRefs to catalog files"
  ],
  "futureOperatorGuidance" : [
    "When adding a new digikoma: copy digikoma-hello-world's 5-target Package.swift layout (Tool + Service + FoundationModelsTool + cli + tests) + the canonical ImprintLedger pattern. Never start from scratch.",
    "When adding a new service contract: copy cli-rebuild-service-contracts v0.1.0's layout + savepoint-service-contracts v0.1.0 as a second reference. service-universal is the canonical home.",
    "When adding a new event kind: extend SubstrateEvent + SubstrateEventKind + (if needed) ServiceCategory in common-service. Keep payload primitive (file path, IDs) so common-service stays free of schema-universal deps.",
    "Before authoring ANY primitive in common-service: enumerate ls common-* + grep public structures across all common-* package sources. If the concept exists, use it. SubprocessSpawner + ServiceLedger both died pre-ship from skipping this check the first time.",
    "savepoint-cli emit MUST require --harness + --session-id; env-var inference is forbidden because parallel sessions across harnesses (claude-code + codex + future) make it unreliable.",
    "Before committing: git diff --cached --name-only verifies scope matches intent. Especially important for multi-repo commits (submodule + mono pin) — each index needs separate check.",
    "When fs-touch-events stream produces real events (Wave 6), digikoma-savepoint v0.2 fills CommitArtifactModel.fsEventRefs[] by reading the ledger directly (no IPC). Plan for that consumer at v0.2 design time.",
    "When the substrate event-bus daemon eventually registers services in-process, DigikomaSavepointService.condition bumps from .never to .always to replace savepointd's spawn dispatch."
  ],
  "kindSlug" : "winddown.expertise",
  "newMemories" : [
    "~/.claude/memory/.docc/insights/schema-set-vs-family-vs-record-versioning-2026-05-23.md",
    "~/.claude/memory/.docc/insights/substrate-is-digikoma-factory-2026-05-23.md",
    "~/.claude/memory/.docc/feedback_harnesses-agnostic-models-constrain.md",
    "~/.claude/memory/.docc/feedback_grep-common-star-before-adding-primitives.md",
    "~/.claude/memory/.docc/feedback_diff-cached-before-every-commit.md"
  ],
  "sharpEdges" : [
    "Bash cwd persists between invocations — if a prior `cd <relative>` failed, subsequent relative paths point at the wrong place; always cd absolute first",
    "scoped git add does NOT protect against pre-staged changes from prior operations or other sessions — diff --cached EVERY time",
    "claude-code project slug is workspace-root-derived, not cwd-derived; scanning ~/.claude/projects/*/ is robust against the slug-derivation rule changing",
    "CommonProcessExecutionKit (not CommonProcess) exports CommandSpec.run() — link errors otherwise",
    "@available(macOS 26+) gated targets need fallback runtime paths or pre-26 callsites break — keep a v0.1 placeholder body in FoundationModelsTool targets",
    "agents/<slug>/ is often itself a git submodule — bumping pins requires per-submodule commit + mono superproject commit chain",
    "shinji-techo v0.2.0 requires an operator-authored quote per record; backfill placeholder is detectable as 'no operator-authored quote' and is a code smell"
  ],
  "summary" : "Five durable doctrines from the savepoint factory build. Domains exercised, commands verified, sharp edges discovered, future operator guidance.",
  "verifiedCommands" : [
    "savepoint-cli emit --harness claude-code --session-id \"$CLAUDE_CODE_SESSION_ID\" — canonical commit emission",
    "savepoint-cli emit --harness <unknown> --session-id <id> --chat-path <path> — escape hatch for unknown harnesses",
    "swift run --package-path private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/swift-agent-cli swift-agent-cli doctor --slug <slug> [--kind agent|agenda|chronicle] --path . — per-home schema validation",
    "swift build -c release --package-path <pkg> --product <name>  +  ln -sf <build>/release/<name> ~/.local/bin/<name> — manual install pattern pre-wrkstrm-identifier integration",
    "git -C <submodule> rev-parse --absolute-git-dir — resolves true gitdir (handles submodule .git-as-file indirection)",
    "git -C <submodule> diff --cached --name-only — REQUIRED scope check between git add and git commit"
  ]
}
```

## Push lane added to the substrate's queue+spawn+receipt pattern. Reusable lessons: server-side dispatch beats client-side iteration; intents must live outside working trees; existing libraries get reused not rewritten when operator names them.

Push lane added to the substrate's queue+spawn+receipt pattern. Reusable lessons: server-side dispatch beats client-side iteration; intents must live outside working trees; existing libraries get reused not rewritten when operator names them.

- Time: `2026-05-24T03:35:55Z`
- Kind: `winddown.expertise`
- ID: `claude-timeline-1779593755-0`
- Captured At: `2026-05-24T03:37:43Z`
- Moment Ref: `moment-claude-timeline-1779593755-0`
- Segment: `claude-timeline-second-segment-1779588085`
- Delta: `5670`
- Sequence: `0`
- Tags: `wd`, `techo`, `shinji`, `expertise`, `push`, `factory`, `wd`, `techo`, `shinji`, `expertise`, `push`, `factory`, `doctrine`, `claude-as-actor`

### Details

#### Highlights

- DOCTRINE — request-side stays thin. CLIs (savepoint-cli) construct + dispatch typed intents to daemons (savepointd); they do NOT iterate over targets or coordinate ordering. Submodule walking, fanout, children-first ordering, retry policy, parallelism — all dispatch-layer concerns owned by the service that receives the intent. The operator named this explicitly: 'savepoint-cli should request for uploads from savepointd - not perform it itself'.
- DOCTRINE — intents live outside the working trees they reference. CommitRequestModel + PushIntentModel intent files staged inside the target repo will trip git-status cleanness checks (?? untracked → dirty → rejection). Canonical staging is ~/.local/share/savepoint/{push-staging,staging}/ for client-side construction, and ~/.local/share/savepointd/queues/<git-dir-hash>/pending/ for queued dispatch. Tests must mirror — write intents to a tmp dir distinct from the work tree.
- DOCTRINE — reuse existing libraries instead of replicating logic. Before authoring git plumbing in DigikomaGitPushTool, operator surfaced SwiftUniversalGitCore from swift-git-cli (paths visible at swift-universal/private/universal/domain/tooling/spm/swift-git-cli/Sources/SwiftUniversalGitCore/). It already had runGit, GitResult, GitAutomationPolicy.isExternalOrg, parseSubmoduleEntries, requireGitRepo, gitChangedFileCount. Substrate has no central registry of utility libraries — practice: grep for existing functionality before writing primitives.
- PATTERN — factory parity packages ship 5 targets: Tool (the actual work) + Service (subscribes to SubstrateEvent kind) + FoundationModelsTool (on-device LLM glue, FoundationModels-gated with @available(macOS 26+)) + cli (one-shot subprocess entry) + Imprint (typed SubstrateLedgerEntry → per-digikoma execution receipts at ~/.local/share/<slug>/ledgers/). digikoma-git-push, digikoma-savepoint, digikoma-hello-world all share this shape now. Three concrete proof cases lock the factory pattern in.
- PATTERN — two parallel ledgers per substrate operation. Per-service receipt (e.g. PushImprint in savepointd: queue routing + worker exit code, asks 'did dispatch succeed?') + per-digikoma receipt (e.g. DigikomaGitPushImprint: actual outcome of the work, asks 'did the action succeed and what changed?'). Audit can drill from either side. Both use SubstrateLedgerWriter<Entry: SubstrateLedgerEntry> from common-imprint.
- PATTERN — server-side fanout for recursive operations. PushService.handleRecursive walks submodules via 'git submodule foreach --recursive --quiet echo $displaypath', sorts deepest-first for children-before-parent ordering, processes each through a per-.git queue, then drives the parent push only if all children succeeded. Single client request → N typed child intents synthesized server-side. Parent push gets recurseSubmodules=false to prevent infinite recursion.
- COMMAND — savepoint-cli push: thin client interface for substrate-managed git push. Required: --harness <name> + --session-id <id>. Optional: --recurse-submodules (server fans out), --dry-run (intent + report no push), --force-with-lease (non-FF allowed), --remote/--branch (override @{u} resolution). Output is savepointd's TriggerImprint JSON on stdout.
- ENVIRONMENT — three binaries symlinked at ~/.local/bin/: savepointd (queue manager, hosts SavepointService + PushService side-by-side), savepoint-cli (agent-side thin client with emit + push subcommands), digikoma-git-push (per-execution push worker spawned by savepointd, also runnable standalone via --intent <path>). Each release-built via swift build -c release + ln -sf into ~/.local/bin/.

### Payload

```json
{
  "agentSlug" : "claude",
  "highlights" : [
    "DOCTRINE — request-side stays thin. CLIs (savepoint-cli) construct + dispatch typed intents to daemons (savepointd); they do NOT iterate over targets or coordinate ordering. Submodule walking, fanout, children-first ordering, retry policy, parallelism — all dispatch-layer concerns owned by the service that receives the intent. The operator named this explicitly: 'savepoint-cli should request for uploads from savepointd - not perform it itself'.",
    "DOCTRINE — intents live outside the working trees they reference. CommitRequestModel + PushIntentModel intent files staged inside the target repo will trip git-status cleanness checks (?? untracked → dirty → rejection). Canonical staging is ~/.local/share/savepoint/{push-staging,staging}/ for client-side construction, and ~/.local/share/savepointd/queues/<git-dir-hash>/pending/ for queued dispatch. Tests must mirror — write intents to a tmp dir distinct from the work tree.",
    "DOCTRINE — reuse existing libraries instead of replicating logic. Before authoring git plumbing in DigikomaGitPushTool, operator surfaced SwiftUniversalGitCore from swift-git-cli (paths visible at swift-universal/private/universal/domain/tooling/spm/swift-git-cli/Sources/SwiftUniversalGitCore/). It already had runGit, GitResult, GitAutomationPolicy.isExternalOrg, parseSubmoduleEntries, requireGitRepo, gitChangedFileCount. Substrate has no central registry of utility libraries — practice: grep for existing functionality before writing primitives.",
    "PATTERN — factory parity packages ship 5 targets: Tool (the actual work) + Service (subscribes to SubstrateEvent kind) + FoundationModelsTool (on-device LLM glue, FoundationModels-gated with @available(macOS 26+)) + cli (one-shot subprocess entry) + Imprint (typed SubstrateLedgerEntry → per-digikoma execution receipts at ~/.local/share/<slug>/ledgers/). digikoma-git-push, digikoma-savepoint, digikoma-hello-world all share this shape now. Three concrete proof cases lock the factory pattern in.",
    "PATTERN — two parallel ledgers per substrate operation. Per-service receipt (e.g. PushImprint in savepointd: queue routing + worker exit code, asks 'did dispatch succeed?') + per-digikoma receipt (e.g. DigikomaGitPushImprint: actual outcome of the work, asks 'did the action succeed and what changed?'). Audit can drill from either side. Both use SubstrateLedgerWriter<Entry: SubstrateLedgerEntry> from common-imprint.",
    "PATTERN — server-side fanout for recursive operations. PushService.handleRecursive walks submodules via 'git submodule foreach --recursive --quiet echo $displaypath', sorts deepest-first for children-before-parent ordering, processes each through a per-.git queue, then drives the parent push only if all children succeeded. Single client request → N typed child intents synthesized server-side. Parent push gets recurseSubmodules=false to prevent infinite recursion.",
    "COMMAND — savepoint-cli push: thin client interface for substrate-managed git push. Required: --harness <name> + --session-id <id>. Optional: --recurse-submodules (server fans out), --dry-run (intent + report no push), --force-with-lease (non-FF allowed), --remote/--branch (override @{u} resolution). Output is savepointd's TriggerImprint JSON on stdout.",
    "ENVIRONMENT — three binaries symlinked at ~/.local/bin/: savepointd (queue manager, hosts SavepointService + PushService side-by-side), savepoint-cli (agent-side thin client with emit + push subcommands), digikoma-git-push (per-execution push worker spawned by savepointd, also runnable standalone via --intent <path>). Each release-built via swift build -c release + ln -sf into ~/.local/bin/."
  ],
  "kindSlug" : "winddown.expertise",
  "summary" : "Push lane added to the substrate's queue+spawn+receipt pattern. Reusable lessons: server-side dispatch beats client-side iteration; intents must live outside working trees; existing libraries get reused not rewritten when operator names them."
}
```

## Substrate is multi-actor in observable practice, not just in doctrine. The push-factory cleanness rail catches blockers correctly; autonomous sync agents resolve them in parallel. mono root's 34 stale unmerged paths is operator-territory cleanup beyond autonomous resolution.

Substrate is multi-actor in observable practice, not just in doctrine. The push-factory cleanness rail catches blockers correctly; autonomous sync agents resolve them in parallel. mono root's 34 stale unmerged paths is operator-territory cleanup beyond autonomous resolution.

- Time: `2026-05-26T04:31:36Z`
- Kind: `winddown.expertise`
- ID: `claude-timeline-1779769896-0`
- Captured At: `2026-05-26T04:33:09Z`
- Moment Ref: `moment-claude-timeline-1779769896-0`
- Segment: `claude-timeline-second-segment-1779588085`
- Delta: `181811`
- Sequence: `0`
- Tags: `wd`, `techo`, `shinji`, `push`, `autonomous-sync`, `mono-root-blocked`, `wd`, `techo`, `shinji`, `expertise`, `push`, `autonomous-sync`, `substrate-multi-actor`, `cleanness-rail`, `operator-territory`, `claude-as-actor`

### Details

#### Highlights

- PATTERN — push-cleanness rejection is informational, not just protective. When DigikomaGitPushTool.ensureClean() rejects with dirtyWorkingTree, the stderr it captures (full `git status --porcelain=v1` output) is also the per-digikoma ledger's stderr payload. Operator can read the ledger to know exactly what's blocking + which other actor (parallel session, autonomous sync agent, operator) owns each file. The receipt is the diagnosis.
- PATTERN — autonomous-sync agents observed live. The substrate has background actors (savepointd + push companions) that batch-commit uncommitted state via 'chore: sync local changes' messages + push autonomously. These run on their own cadence, independent of any agent session. Heuristic: if a submodule is dirty when you check + clean when you check 30 min later, that's a sync-agent footprint. Look for 'chore: sync ...' or 'chore(root): refresh ...' commits to confirm.
- PATTERN — substrate as multi-actor working tree. An agent session does NOT have exclusive ownership of `git status` output. Between any two `git status` calls, the substrate may have: (a) committed other-session work autonomously, (b) pushed it upstream, (c) refreshed submodule pointers, (d) added new entries to /private/.wrkstrm/* runtime paths. Defensive practice: re-check status before each commit; assume any 'untracked' file might belong to another actor; never `git add -A`.
- DOCTRINE — operator territory vs autonomous territory. Bulk-resolving 34 unmerged paths spanning .gitmodules + ~10 submodule pointers + codex auth/sqlite runtime state is OPERATOR TERRITORY. Risk profile: wrong submodule pointer choice loses another session's work; wrong .gitmodules choice corrupts the structure; wrong codex auth choice breaks working authentication. AskUserQuestion before bulk-resolving any merge state >5 files spanning multiple risk surfaces. The substrate's autonomous agents do submodule-pointer sync on a single repo — they don't bulk-resolve cross-submodule merge conflicts. That mode requires a human reading the diff.
- COMMAND — `git diff HEAD origin/main -- <path1> <path2>` is the right introspection before merge. Shows whether remote already has newer SHAs at those paths (in which case merge will favor remote with no conflict + my work is preserved if it's already upstream via other route), or whether remote diverged from local (true conflict requiring resolution). This is how I confirmed origin/main already had newer pointers than my local for the 4 collectives — meaning the autonomous sync had already swept my work upstream + the merge would just fast-forward.
- COMMAND — `git ls-files --unmerged | wc -l` divided by 3 gives a quick count of unmerged paths (each path has up to 3 stage entries: base, ours, theirs). Combined with `git diff --name-only --diff-filter=U`, gives both count + file list. Useful for surfacing the scale of a merge state before deciding how to handle it.
- ENVIRONMENT — mono root has its own behind-state cadence driven by autonomous sync agents writing 'chore(mono): sync ...' commits on origin. Local catches up via `git pull --ff-only` or `git merge --no-edit origin/main`; bulk push of substantial local-only commit ranges (1000+ ahead) requires reconciling the cadence first. Don't assume mono root is push-eligible just because submodules are.

### Payload

```json
{
  "agentSlug" : "claude",
  "highlights" : [
    "PATTERN — push-cleanness rejection is informational, not just protective. When DigikomaGitPushTool.ensureClean() rejects with dirtyWorkingTree, the stderr it captures (full `git status --porcelain=v1` output) is also the per-digikoma ledger's stderr payload. Operator can read the ledger to know exactly what's blocking + which other actor (parallel session, autonomous sync agent, operator) owns each file. The receipt is the diagnosis.",
    "PATTERN — autonomous-sync agents observed live. The substrate has background actors (savepointd + push companions) that batch-commit uncommitted state via 'chore: sync local changes' messages + push autonomously. These run on their own cadence, independent of any agent session. Heuristic: if a submodule is dirty when you check + clean when you check 30 min later, that's a sync-agent footprint. Look for 'chore: sync ...' or 'chore(root): refresh ...' commits to confirm.",
    "PATTERN — substrate as multi-actor working tree. An agent session does NOT have exclusive ownership of `git status` output. Between any two `git status` calls, the substrate may have: (a) committed other-session work autonomously, (b) pushed it upstream, (c) refreshed submodule pointers, (d) added new entries to /private/.wrkstrm/* runtime paths. Defensive practice: re-check status before each commit; assume any 'untracked' file might belong to another actor; never `git add -A`.",
    "DOCTRINE — operator territory vs autonomous territory. Bulk-resolving 34 unmerged paths spanning .gitmodules + ~10 submodule pointers + codex auth/sqlite runtime state is OPERATOR TERRITORY. Risk profile: wrong submodule pointer choice loses another session's work; wrong .gitmodules choice corrupts the structure; wrong codex auth choice breaks working authentication. AskUserQuestion before bulk-resolving any merge state >5 files spanning multiple risk surfaces. The substrate's autonomous agents do submodule-pointer sync on a single repo — they don't bulk-resolve cross-submodule merge conflicts. That mode requires a human reading the diff.",
    "COMMAND — `git diff HEAD origin/main -- <path1> <path2>` is the right introspection before merge. Shows whether remote already has newer SHAs at those paths (in which case merge will favor remote with no conflict + my work is preserved if it's already upstream via other route), or whether remote diverged from local (true conflict requiring resolution). This is how I confirmed origin/main already had newer pointers than my local for the 4 collectives — meaning the autonomous sync had already swept my work upstream + the merge would just fast-forward.",
    "COMMAND — `git ls-files --unmerged | wc -l` divided by 3 gives a quick count of unmerged paths (each path has up to 3 stage entries: base, ours, theirs). Combined with `git diff --name-only --diff-filter=U`, gives both count + file list. Useful for surfacing the scale of a merge state before deciding how to handle it.",
    "ENVIRONMENT — mono root has its own behind-state cadence driven by autonomous sync agents writing 'chore(mono): sync ...' commits on origin. Local catches up via `git pull --ff-only` or `git merge --no-edit origin/main`; bulk push of substantial local-only commit ranges (1000+ ahead) requires reconciling the cadence first. Don't assume mono root is push-eligible just because submodules are."
  ],
  "kindSlug" : "winddown.expertise",
  "summary" : "Substrate is multi-actor in observable practice, not just in doctrine. The push-factory cleanness rail catches blockers correctly; autonomous sync agents resolve them in parallel. mono root's 34 stale unmerged paths is operator-territory cleanup beyond autonomous resolution."
}
```

## Substrate teaches itself through types, not through doc-discovery. Folder shape carries discipline. Audit-before-author saves duplication every time. Chemistry layer-cake (elements/molecules/compounds/mixtures) is the substrate's natural type-theory layout — all four layers now have typed contracts.

Substrate teaches itself through types, not through doc-discovery. Folder shape carries discipline. Audit-before-author saves duplication every time. Chemistry layer-cake (elements/molecules/compounds/mixtures) is the substrate's natural type-theory layout — all four layers now have typed contracts.

- Time: `2026-05-26T10:01:26Z`
- Kind: `winddown.expertise`
- ID: `claude-timeline-1779789686-0`
- Captured At: `2026-05-26T10:04:32Z`
- Moment Ref: `moment-claude-timeline-1779789686-0`
- Segment: `claude-timeline-second-segment-1779588085`
- Delta: `201601`
- Sequence: `0`
- Tags: `wd`, `techo`, `shinji`, `substrate-doctrine`, `chemistry-layer-cake`, `work-graph`, `sdlc`, `wd`, `techo`, `shinji`, `expertise`, `substrate-doctrine`, `chemistry-layer-cake`, `work-graph`, `schema-discipline`, `claude-as-actor`

### Details

#### Highlights

- DOCTRINE — substrate teaches itself through TYPES, not through DOC-DISCOVERY. When typed contracts live only in DocC articles, agents accidentally miss them. When typed contracts are REQUIRED at every surface an agent touches (every CLI invocation, every bundle manifest, every typed record's class-name discriminator), agents can't miss them. Type-system enforcement of doctrine is the substrate's natural pattern. Examples shipped this session: IncidentBehaviorContract REQUIRED on every IncidentModel (can't open an incident without naming who pauses), workGraphNode REQUIRED on every CLIABundleManifestModel v0.2.0 (can't author a bundle without declaring its work-graph node identity), KickoffMeetingReceiptModel.isValidKickoffReceipt enforces non-empty cujs+designMockups+signOff at validation boundaries (launch-review gates against this).
- DOCTRINE — chemistry layer-cake is the substrate's natural type-theory layout. Four layers now fully typed: ELEMENTS (typed schema records like BeadsIssue, KickoffMeetingReceiptModel, WorkflowGraphNode), MOLECULES (typed workflows like BeadsMolecule, WorkflowGraphDoctrine, KeikoWorkflow), COMPOUNDS (typed assemblies like SubstrateCompoundModel; apps/products/releases/vaults/services/factories), MIXTURES (the substrate workspace itself, implicit). Plus BONDS (LinkRefModel substrate-wide + BeadsBondPoint bead-scoped), REACTIONS (typed via WorkflowRunDiscipline invariants + WorkGraphEventModel emissions), CATALYSTS (.clia bundles driving reactions). The substrate's typed primitives self-host their own description; SubstrateCompoundModel describes apps including the kanban-app that describes substrate compounds.
- DOCTRINE — folder shape carries discipline. schema-universal's layout (domain/<bucket>/schema-families/<family>/v<X.Y.Z>/spm/<family>-v<XXX-YYY-ZZZ>/) FORCES every new typed contract to declare its domain bucket + version + SPM package shape up front. That's why this session's 7 family ships landed cleanly — placement decisions were OBVIOUS because the folder shape pre-grouped semantically-adjacent families. workflow-graph-doctrine-schemas → system/ (sibling to workflow-schemas / workstream-schemas / thread-schemas); incident-schemas → system/ (sibling to thread-schemas, peer to other coordinator types); clia-bundle-schemas → ai/ (sibling to foundation-adapter-training-schemas + clia-session-schemas); org-mission-statement-schemas → org/ (sibling to org-company-schemas). When I'd been tempted to invent a new folder shape (a one-off file outside the convention), the folder structure pushed back: 'find your siblings first.'
- DOCTRINE — audit-before-author saves duplication EVERY time. Task #57 discovered that ~90% of the work-graph protocol I was about to author from scratch already existed in workflow-schemas v0.1.0 (24-field WorkflowModel + Lifecycle + Runtime + Keiko PRD/CUJ + RunDiscipline + GraphTopology). Same pattern bit me on bead-shape: discovered Beads_Schemas_v000_001_000 with typed BeadsIssue/BeadsFormula/BeadsMolecule/BeadsBondPoint/BeadsMolType when I'd been thinking 'beads are free-form JSON.' Universal lesson: grep schema-universal AND existing app sources before authoring new typed contracts. The substrate has been thinking about most things longer than I have.
- DOCTRINE — version-bump pattern for typed records. When a typed record's surface changes, the substrate convention is: (1) create a new v-dir as a SEPARATE SPM package alongside the existing v-dir (clia-bundle-schemas/v0.1.0/spm/... AND v0.2.0/spm/... coexist); (2) unchanged sub-types keep their per-record schemaVersion discriminators at the OLD value (CLIAArtifactRefModel + CLIAKindRecord + CLIATrainingProvenanceModel stayed at '0.1.0' in v0.2.0); (3) only changed records bump their schemaVersion + appear with the new value (CLIABundleManifestModel bumped to '0.2.0'); (4) the package + module rename to v000_002_000 reflects the package version (independent of per-record discriminators). Per-record + per-package versioning are orthogonal axes.
- PATTERN — substrate factory shape now repeated 4+ times: hello-world / savepoint / git-push / fs-touch. Each factory has 5 targets (Tool + Service + FoundationModelsTool + cli + Imprint), uses common-process for shell-out, common-imprint for typed ledger writes, common-service for SubstrateEvent dispatch + per-resource queue. Adding new factories is mechanical at this point. The push factory shipped this session was the 4th proof; the kanban app (when built) will be the first substrate-compound using the factory pattern at the app layer rather than the tool layer.
- PATTERN — operator architectural recognitions cascade into typed contracts within minutes when the substrate's authoring pattern has matured. This session: (1) CLIA-as-primitive → 30 min → clia-bundle-schemas v0.1.0 shipped. (2) Orgs-have-ikigai → 30 min → org-mission-statement-schemas v0.1.0 shipped + clia-org instance authored. (3) Incidents-change-team-behavior → 60 min → incident-schemas v0.1.0 + 5 legacy incidents triaged. (4) Schemas-are-elements-workflows-are-molecules → 30 min → substrate-compound-schemas v0.1.0 shipped. (5) Program-it-into-surfaces → 60 min → workflow-graph-doctrine-schemas + clia-bundle-schemas v0.2.0 + work-graph-event-schemas shipped. The doctrine-to-types pipeline is now substrate-internalized.
- COMMAND — typed work-graph audit pattern for any new substrate work surface: (a) read existing typed contracts in schema-universal (grep -rE 'public (struct|enum|protocol)' for relevant domain), (b) find the closest sibling family (folder shape pre-groups), (c) author the missing typed primitives as new family or v-bump, (d) ship with class-name discriminator + ordinality tables + Swift Testing assertions, (e) author doctrine memory if the cut is durable, (f) save to MEMORY.md index, (g) commit + push. Pattern matures from ~60 min/family at session start to ~20 min/family by session end.
- ENVIRONMENT — substrate is genuinely multi-actor working tree. Throughout this session: autonomous-sync agents wrote 'chore: sync local changes' commits in parallel; chatgpt session authored typed records concurrently; codex runtime state kept evolving. Defensive practices that worked: never git add -A, always git diff --cached before commit, surgical adds per file/directory, accept that the cleanness rail will reject pushes against repos with other-session dirty state, use direct git push as last-resort when factory rail trips. Memory savepoint-daemon-races-commits stays load-bearing.
- SHARP EDGE — schema-version bumps require replicating unchanged source files for the new SPM package. clia-bundle-schemas v0.2.0 required cp'ing 3 unchanged source files into the new v-dir + authoring the modified manifest. Mechanical but error-prone. Substrate convention: each v-dir is its own STANDALONE SPM package. Possible improvement bead (deferred): a substrate-script that mechanically forks a schema family v-bump, copies unchanged files, opens the changed file for editing. Not authored today; substrate-bead candidate.
- SHARP EDGE — path math for SPM .package(path:) is depth-sensitive + easy to miscount. Hit twice this session: push-intent-schemas needed 4 ../ to reach sibling commit-intent-schemas (I used 3); work-graph-event-schemas needed 4 ../ to reach sibling workflow-graph-doctrine-schemas (I used 2). Pattern: from <family>/v<X>/spm/<pkg>/ going up = 4 to reach schema-families/, then sideways to the sibling family. Test discovers the mistake quickly (swift build fails with file-not-found); fix is fast. But authoring more carefully up front saves the round-trip.

### Payload

```json
{
  "agentSlug" : "claude",
  "highlights" : [
    "DOCTRINE — substrate teaches itself through TYPES, not through DOC-DISCOVERY. When typed contracts live only in DocC articles, agents accidentally miss them. When typed contracts are REQUIRED at every surface an agent touches (every CLI invocation, every bundle manifest, every typed record's class-name discriminator), agents can't miss them. Type-system enforcement of doctrine is the substrate's natural pattern. Examples shipped this session: IncidentBehaviorContract REQUIRED on every IncidentModel (can't open an incident without naming who pauses), workGraphNode REQUIRED on every CLIABundleManifestModel v0.2.0 (can't author a bundle without declaring its work-graph node identity), KickoffMeetingReceiptModel.isValidKickoffReceipt enforces non-empty cujs+designMockups+signOff at validation boundaries (launch-review gates against this).",
    "DOCTRINE — chemistry layer-cake is the substrate's natural type-theory layout. Four layers now fully typed: ELEMENTS (typed schema records like BeadsIssue, KickoffMeetingReceiptModel, WorkflowGraphNode), MOLECULES (typed workflows like BeadsMolecule, WorkflowGraphDoctrine, KeikoWorkflow), COMPOUNDS (typed assemblies like SubstrateCompoundModel; apps/products/releases/vaults/services/factories), MIXTURES (the substrate workspace itself, implicit). Plus BONDS (LinkRefModel substrate-wide + BeadsBondPoint bead-scoped), REACTIONS (typed via WorkflowRunDiscipline invariants + WorkGraphEventModel emissions), CATALYSTS (.clia bundles driving reactions). The substrate's typed primitives self-host their own description; SubstrateCompoundModel describes apps including the kanban-app that describes substrate compounds.",
    "DOCTRINE — folder shape carries discipline. schema-universal's layout (domain/<bucket>/schema-families/<family>/v<X.Y.Z>/spm/<family>-v<XXX-YYY-ZZZ>/) FORCES every new typed contract to declare its domain bucket + version + SPM package shape up front. That's why this session's 7 family ships landed cleanly — placement decisions were OBVIOUS because the folder shape pre-grouped semantically-adjacent families. workflow-graph-doctrine-schemas → system/ (sibling to workflow-schemas / workstream-schemas / thread-schemas); incident-schemas → system/ (sibling to thread-schemas, peer to other coordinator types); clia-bundle-schemas → ai/ (sibling to foundation-adapter-training-schemas + clia-session-schemas); org-mission-statement-schemas → org/ (sibling to org-company-schemas). When I'd been tempted to invent a new folder shape (a one-off file outside the convention), the folder structure pushed back: 'find your siblings first.'",
    "DOCTRINE — audit-before-author saves duplication EVERY time. Task #57 discovered that ~90% of the work-graph protocol I was about to author from scratch already existed in workflow-schemas v0.1.0 (24-field WorkflowModel + Lifecycle + Runtime + Keiko PRD/CUJ + RunDiscipline + GraphTopology). Same pattern bit me on bead-shape: discovered Beads_Schemas_v000_001_000 with typed BeadsIssue/BeadsFormula/BeadsMolecule/BeadsBondPoint/BeadsMolType when I'd been thinking 'beads are free-form JSON.' Universal lesson: grep schema-universal AND existing app sources before authoring new typed contracts. The substrate has been thinking about most things longer than I have.",
    "DOCTRINE — version-bump pattern for typed records. When a typed record's surface changes, the substrate convention is: (1) create a new v-dir as a SEPARATE SPM package alongside the existing v-dir (clia-bundle-schemas/v0.1.0/spm/... AND v0.2.0/spm/... coexist); (2) unchanged sub-types keep their per-record schemaVersion discriminators at the OLD value (CLIAArtifactRefModel + CLIAKindRecord + CLIATrainingProvenanceModel stayed at '0.1.0' in v0.2.0); (3) only changed records bump their schemaVersion + appear with the new value (CLIABundleManifestModel bumped to '0.2.0'); (4) the package + module rename to v000_002_000 reflects the package version (independent of per-record discriminators). Per-record + per-package versioning are orthogonal axes.",
    "PATTERN — substrate factory shape now repeated 4+ times: hello-world / savepoint / git-push / fs-touch. Each factory has 5 targets (Tool + Service + FoundationModelsTool + cli + Imprint), uses common-process for shell-out, common-imprint for typed ledger writes, common-service for SubstrateEvent dispatch + per-resource queue. Adding new factories is mechanical at this point. The push factory shipped this session was the 4th proof; the kanban app (when built) will be the first substrate-compound using the factory pattern at the app layer rather than the tool layer.",
    "PATTERN — operator architectural recognitions cascade into typed contracts within minutes when the substrate's authoring pattern has matured. This session: (1) CLIA-as-primitive → 30 min → clia-bundle-schemas v0.1.0 shipped. (2) Orgs-have-ikigai → 30 min → org-mission-statement-schemas v0.1.0 shipped + clia-org instance authored. (3) Incidents-change-team-behavior → 60 min → incident-schemas v0.1.0 + 5 legacy incidents triaged. (4) Schemas-are-elements-workflows-are-molecules → 30 min → substrate-compound-schemas v0.1.0 shipped. (5) Program-it-into-surfaces → 60 min → workflow-graph-doctrine-schemas + clia-bundle-schemas v0.2.0 + work-graph-event-schemas shipped. The doctrine-to-types pipeline is now substrate-internalized.",
    "COMMAND — typed work-graph audit pattern for any new substrate work surface: (a) read existing typed contracts in schema-universal (grep -rE 'public (struct|enum|protocol)' for relevant domain), (b) find the closest sibling family (folder shape pre-groups), (c) author the missing typed primitives as new family or v-bump, (d) ship with class-name discriminator + ordinality tables + Swift Testing assertions, (e) author doctrine memory if the cut is durable, (f) save to MEMORY.md index, (g) commit + push. Pattern matures from ~60 min/family at session start to ~20 min/family by session end.",
    "ENVIRONMENT — substrate is genuinely multi-actor working tree. Throughout this session: autonomous-sync agents wrote 'chore: sync local changes' commits in parallel; chatgpt session authored typed records concurrently; codex runtime state kept evolving. Defensive practices that worked: never git add -A, always git diff --cached before commit, surgical adds per file/directory, accept that the cleanness rail will reject pushes against repos with other-session dirty state, use direct git push as last-resort when factory rail trips. Memory savepoint-daemon-races-commits stays load-bearing.",
    "SHARP EDGE — schema-version bumps require replicating unchanged source files for the new SPM package. clia-bundle-schemas v0.2.0 required cp'ing 3 unchanged source files into the new v-dir + authoring the modified manifest. Mechanical but error-prone. Substrate convention: each v-dir is its own STANDALONE SPM package. Possible improvement bead (deferred): a substrate-script that mechanically forks a schema family v-bump, copies unchanged files, opens the changed file for editing. Not authored today; substrate-bead candidate.",
    "SHARP EDGE — path math for SPM .package(path:) is depth-sensitive + easy to miscount. Hit twice this session: push-intent-schemas needed 4 ../ to reach sibling commit-intent-schemas (I used 3); work-graph-event-schemas needed 4 ../ to reach sibling workflow-graph-doctrine-schemas (I used 2). Pattern: from <family>/v<X>/spm/<pkg>/ going up = 4 to reach schema-families/, then sideways to the sibling family. Test discovers the mistake quickly (swift build fails with file-not-found); fix is fast. But authoring more carefully up front saves the round-trip."
  ],
  "kindSlug" : "winddown.expertise",
  "summary" : "Substrate teaches itself through types, not through doc-discovery. Folder shape carries discipline. Audit-before-author saves duplication every time. Chemistry layer-cake (elements/molecules/compounds/mixtures) is the substrate's natural type-theory layout — all four layers now have typed contracts."
}
```

## Durable lessons from the contribution-model + ontology + SwiftCheck session: typed-discipline beats ad-hoc, per-file enumerations beat catalog files, strict-Sendable proof beats @unchecked when feasible, substrate JSON formatter beats Python json.dump in commit hygiene, and the substrate's typed primitives (forks, breaks-are-good, content-first) consistently show up as the right answer at decision junctions.

Durable lessons from the contribution-model + ontology + SwiftCheck session: typed-discipline beats ad-hoc, per-file enumerations beat catalog files, strict-Sendable proof beats @unchecked when feasible, substrate JSON formatter beats Python json.dump in commit hygiene, and the substrate's typed primitives (forks, breaks-are-good, content-first) consistently show up as the right answer at decision junctions.

- Time: `2026-05-31T00:13:42Z`
- Kind: `winddown.expertise`
- ID: `claude-timeline-1780186422-0`
- Captured At: `2026-05-31T00:13:43Z`
- Moment Ref: `moment-claude-timeline-1780186422-0`
- Segment: `claude-timeline-second-segment-1779588085`
- Delta: `598337`
- Sequence: `0`
- Tags: `wd`, `techo`, `expertise`, `ontology`, `schema-cascade`, `swiftcheck`, `doctrine`, `wd`, `techo`, `expertise`, `ontology`, `schema-cascade`, `swiftcheck`, `doctrine`, `tooling`

### Details

#### Lessons

- appliesTo: any future case of 'this thing is a variant of that underlying thing' across substrate organisms
- evidence: feedback_form-is-universal-binding-pattern.md
- principle: Form is a universal variant-binding pattern across organism kinds (agent, audience, collective, human-operator). FormModel's parentAgentRef baked in the wrong constraint — the universal slot is parentRef. Ghost is a form-binding (rismay-ghost = host-agent × source-operator × ghost-projection axis), not an aspect or a separate kind.
- slug: form-is-universal-binding-pattern
- appliesTo: any substrate home authoring with both cross-platform and platform-restricted content
- evidence: feedback_form-folder-arms-private-universal-apple.md (operator: 'this folder structure has been the default always' — baseline doctrine I should have known)
- principle: Form folders (and substrate homes generally) use private/universal/ (kura-typed) + private/apple/ (Apple-restricted) arms. The private/universal/ arm is NOT a free-for-all dumping ground — content must live in proper kura-typed collections.
- slug: form-folder-arms-convention
- appliesTo: any substrate-wide JSON data migration
- evidence: 183 files / 12413 deletions → 13467 ins / 3649 del after formatter pass
- principle: When migrating JSON content via Python's json.dump, route the output through swift-json-formatter (Wrkstrm policy) before staging. Eliminates ~70% of commit noise (8800 lines of whitespace churn) so the real content delta is visible in diffs.
- slug: substrate-json-formatter-over-python-json-dump
- appliesTo: any Swift 6 strict-concurrency adoption for vendored libraries
- evidence: SwiftCheck fork: ArrowOfImpl/IsoOfImpl → Sendable struct + OSAllocatedUnfairLock<[T:U]>; PointerOfImpl → UInt bit-pattern; ZERO @unchecked Sendable in code
- principle: When a Sendable cascade hits a class with mutable storage, prefer OSAllocatedUnfairLock<T: Sendable> wrappers OR struct-with-immutable-storage OR raw-bitpattern-for-pointers, BEFORE reaching for @unchecked Sendable. Substrate doctrine: typed proof beats unverified annotation; @unchecked is the last resort, not the default.
- slug: rigorous-sendable-beats-unchecked-when-feasible
- appliesTo: any future substrate typed registry
- evidence: kura/collections/s-types/ (38 .s-type.json) + roles/classes/<slug>.class.su.json (10+2) — confirmed pattern
- principle: Typed enumerations live as per-file <slug>.<typed-model>.json artifacts, NOT in a single catalog JSON. Filesystem-picker doctrine: items are discoverable by ls, blame-able per file, edit-able independently. Catalogs (if kept) are projections that walk the dir, never hand-authored to drift.
- slug: per-atom-files-over-catalog-json
- appliesTo: any future LinkRef refactor of string-typed substrate fields
- evidence: 3453 Contribution records gained typeRef additively + 41 ContributionMix version-tag reverts when realized readers would break
- principle: When LinkRef'ing a field that consumers read as String, ADD the LinkRef alongside (don't replace). Old readers ignore the unknown key; new readers prefer the LinkRef. Migration becomes additive, no compat shims needed. ALSO: don't bump enclosing-model version tags during additive migration — that DOES break strict-equal v0.1 readers.
- slug: additive-migration-preserves-readers
- appliesTo: any session with substantial back-and-forth
- evidence: Two real-time self-corrections this session without operator intervention (personal-identity refinement, journal-tagged)
- principle: Three triggers to pause: (1) writing memory before convention-confirm, (2) third-question-in-a-row, (3) cross-directory drift in 3 edits accumulating without operator nod. The substrate-typed feedback memories from earlier sessions PULL on me in real time when I notice these patterns — that's the doctrine working as designed.
- slug: pause-and-plan-when-decisions-accumulate

### Payload

```json
{
  "agentSlug" : "claude",
  "commandsVerified" : [
    "swift run --package-path <pkg> agent-timeline-cli ingest --timeline <path> --records - < <json>",
    "swift run --package-path <swift-json-formatter-pkg> swift-json-formatter fix --quiet --include-ai --file <path> ... (substrate-canonical formatter via xargs)",
    "SPM_USE_LOCAL_DEPS=1 swift test --package-path <pkg> --filter <suite>",
    "git submodule status --recursive (for tracing fork mechanics through nested layers)",
    "cp -R <v0.X> <v0.X+1> + sed-rename version tags + find -exec for cascading schema bumps"
  ],
  "domainsExercised" : [
    "Swift 6 strict concurrency (Sendable cascade analysis + restructuring)",
    "Swift Package Manager (fork tracking, version cascades across submodules)",
    "Substrate schema-family discipline (8 packages bumped with round-trip tests)",
    "Substrate typing axes (kind, aspect, class, form, performer-kind, tier)",
    "Property-based testing (SwiftCheck integration + property design for ontology integrity)",
    "JSON schema doctrine (per-file vs catalog, additive migration, version-tag discipline)",
    "Substrate-wide data migration (3453 records via Python + revert discipline)",
    "DocC + substrate doctrine doc updates (typelift home, modernization-2026)",
    "Form folder convention (private/universal/+private/apple/ arms)",
    "Subagent delegation (Explore for read-only scope; claude general-purpose for implementation)"
  ],
  "futureOperatorGuidance" : [
    "If touching multiple schema-universal packages in cascade, do v_N+1 via cp -R + sed-rename + targeted edits — sed-pattern can over-bump unintended version numbers in transitive dep paths (note-schemas v0.4 caught me)",
    "When operator names a typed concept (orchestrator-class, ghost-summoner-class, form-axis), check the existing kura collection structure FIRST before authoring — substrate often has half-finished surface that aligns",
    "Subagent delegation works well when the constraint set is HARD (no @unchecked, tests must pass) and the scope is well-defined; delegating a vague refactor produces noise",
    "The substrate's 'forks live in their relevant collective' doctrine has anticipated cases the operator may surface fresh — check modernization-2026 fork queues before reinventing"
  ],
  "kindSlug" : "winddown.expertise",
  "lessons" : [
    {
      "appliesTo" : "any future case of 'this thing is a variant of that underlying thing' across substrate organisms",
      "evidence" : "feedback_form-is-universal-binding-pattern.md",
      "principle" : "Form is a universal variant-binding pattern across organism kinds (agent, audience, collective, human-operator). FormModel's parentAgentRef baked in the wrong constraint — the universal slot is parentRef. Ghost is a form-binding (rismay-ghost = host-agent × source-operator × ghost-projection axis), not an aspect or a separate kind.",
      "slug" : "form-is-universal-binding-pattern"
    },
    {
      "appliesTo" : "any substrate home authoring with both cross-platform and platform-restricted content",
      "evidence" : "feedback_form-folder-arms-private-universal-apple.md (operator: 'this folder structure has been the default always' — baseline doctrine I should have known)",
      "principle" : "Form folders (and substrate homes generally) use private/universal/ (kura-typed) + private/apple/ (Apple-restricted) arms. The private/universal/ arm is NOT a free-for-all dumping ground — content must live in proper kura-typed collections.",
      "slug" : "form-folder-arms-convention"
    },
    {
      "appliesTo" : "any substrate-wide JSON data migration",
      "evidence" : "183 files / 12413 deletions → 13467 ins / 3649 del after formatter pass",
      "principle" : "When migrating JSON content via Python's json.dump, route the output through swift-json-formatter (Wrkstrm policy) before staging. Eliminates ~70% of commit noise (8800 lines of whitespace churn) so the real content delta is visible in diffs.",
      "slug" : "substrate-json-formatter-over-python-json-dump"
    },
    {
      "appliesTo" : "any Swift 6 strict-concurrency adoption for vendored libraries",
      "evidence" : "SwiftCheck fork: ArrowOfImpl/IsoOfImpl → Sendable struct + OSAllocatedUnfairLock<[T:U]>; PointerOfImpl → UInt bit-pattern; ZERO @unchecked Sendable in code",
      "principle" : "When a Sendable cascade hits a class with mutable storage, prefer OSAllocatedUnfairLock<T: Sendable> wrappers OR struct-with-immutable-storage OR raw-bitpattern-for-pointers, BEFORE reaching for @unchecked Sendable. Substrate doctrine: typed proof beats unverified annotation; @unchecked is the last resort, not the default.",
      "slug" : "rigorous-sendable-beats-unchecked-when-feasible"
    },
    {
      "appliesTo" : "any future substrate typed registry",
      "evidence" : "kura/collections/s-types/ (38 .s-type.json) + roles/classes/<slug>.class.su.json (10+2) — confirmed pattern",
      "principle" : "Typed enumerations live as per-file <slug>.<typed-model>.json artifacts, NOT in a single catalog JSON. Filesystem-picker doctrine: items are discoverable by ls, blame-able per file, edit-able independently. Catalogs (if kept) are projections that walk the dir, never hand-authored to drift.",
      "slug" : "per-atom-files-over-catalog-json"
    },
    {
      "appliesTo" : "any future LinkRef refactor of string-typed substrate fields",
      "evidence" : "3453 Contribution records gained typeRef additively + 41 ContributionMix version-tag reverts when realized readers would break",
      "principle" : "When LinkRef'ing a field that consumers read as String, ADD the LinkRef alongside (don't replace). Old readers ignore the unknown key; new readers prefer the LinkRef. Migration becomes additive, no compat shims needed. ALSO: don't bump enclosing-model version tags during additive migration — that DOES break strict-equal v0.1 readers.",
      "slug" : "additive-migration-preserves-readers"
    },
    {
      "appliesTo" : "any session with substantial back-and-forth",
      "evidence" : "Two real-time self-corrections this session without operator intervention (personal-identity refinement, journal-tagged)",
      "principle" : "Three triggers to pause: (1) writing memory before convention-confirm, (2) third-question-in-a-row, (3) cross-directory drift in 3 edits accumulating without operator nod. The substrate-typed feedback memories from earlier sessions PULL on me in real time when I notice these patterns — that's the doctrine working as designed.",
      "slug" : "pause-and-plan-when-decisions-accumulate"
    }
  ],
  "sharpEdges" : [
    "SwiftCheck XCTest dylib search path is hardcoded to swift-6.2 in the rpath — DYLD_LIBRARY_PATH overrides don't work; must convert scratchpads to test targets when using SwiftCheck",
    "Python json.dump uses different whitespace than Swift JSONEncoder — diffs explode by 3-4x without a formatter pass",
    "Strict-equal version guards REJECT records with bumped enclosing-model tags during 'additive' migration — must revert version bumps when only adding fields",
    "macOS xargs doesn't support -a flag; use stdin redirection for batch operations",
    "git reset HEAD <path> is non-destructive but should be authorized like any git mutation — operator concern triggered the discipline"
  ],
  "summary" : "Durable lessons from the contribution-model + ontology + SwiftCheck session: typed-discipline beats ad-hoc, per-file enumerations beat catalog files, strict-Sendable proof beats @unchecked when feasible, substrate JSON formatter beats Python json.dump in commit hygiene, and the substrate's typed primitives (forks, breaks-are-good, content-first) consistently show up as the right answer at decision junctions."
}
```

## Second wd expertise entry. Durable substrate-wide cascade pattern proven third time: schema-bump → migrator package (typed Swift tests) → Python mirror for data sweep → per-submodule chore commits + parent pointer bump + umbrella commit. Reusable template now substrate-truth. Also: premature-wd-closure is its own anti-pattern parallel to over-extension.

Second wd expertise entry. Durable substrate-wide cascade pattern proven third time: schema-bump → migrator package (typed Swift tests) → Python mirror for data sweep → per-submodule chore commits + parent pointer bump + umbrella commit. Reusable template now substrate-truth. Also: premature-wd-closure is its own anti-pattern parallel to over-extension.

- Time: `2026-05-31T03:10:30Z`
- Kind: `winddown.expertise`
- ID: `claude-timeline-1780197030-0`
- Captured At: `2026-05-31T03:10:30Z`
- Moment Ref: `moment-claude-timeline-1780197030-0`
- Segment: `claude-timeline-second-segment-1779588085`
- Delta: `608945`
- Sequence: `0`
- Tags: `wd`, `techo`, `expertise`, `substrate-cascade-pattern`, `identity-migration`, `python-mirror-pattern`, `premature-closure`, `wd`, `techo`, `expertise`, `substrate-cascade-pattern`, `identity-migration`, `python-mirror-pattern`, `premature-closure`, `pause-and-push`

### Details

#### Lessons

- applicability: Any future substrate-wide schema cut where (a) the schema family has versioned migration semantics and (b) the data lives across multiple submodules. Cost-effective at ≥3 records; substantially cheaper than ad-hoc per-file editing for ≥10. Template artifacts: typed migrator package owns the transform + tests; Python mirror applies the transform without pulling schema-universal as a Swift dep for the bulk sweep.
- evidence: ["Contribution typeRef cascade: contribution-schemas v0.2.0 + contribution-composition-schemas v0.2.0 + contribution-migrations v0.1.0-to-v0.2.0 + 3453-record substrate-wide data sweep (earlier this session)","SwiftCheck strict-Sendable cascade: 15 files, zero @unchecked Sendable, fork queue item #1 done (mid-session, commit e907acd3)","IdentityModel v0.X→v0.8 cascade: identity-agent-migrations v0.6.0-to-v0.7.0 + v0.7.0-to-v0.8.0 + 42-record substrate-wide data sweep across 27 owners + 26 per-submodule chore(identity) commits + mono root umbrella commit cb22366883 (late session)"]
- id: substrate-wide-cascade-pattern
- title: Substrate-wide cascade pattern (proven 3x in one session)
- what: Schema-bump → typed migrator package (Swift tests) → Python mirror for data sweep → per-submodule chore commits + parent pointer bump + umbrella mono root commit. Reuse: each cascade's automation seeds the next.
- applicability: Bulk migrations across N≥10 substrate records where the typed migrator is JSON-shape-based. Don't use when the migrator needs Swift-only logic (e.g., LinkRef resolution that calls into other schema packages). Compose with the per-submodule commit discipline from the cascade pattern.
- evidence: ["v0.6→v0.7→v0.8 identity migration: 42 records across 27 owners; Python mirror ran in seconds; no schema-universal Swift dep required in the sweep tool; the Swift migrator's test fixtures validated the transform once, Python applied it 42 times.","Pattern works because the typed migrator's transform is data-shaped (JSON-in → JSON-out), not behavior-shaped — Python can faithfully replicate the JSON shape transformation without losing safety."]
- id: python-mirror-pattern
- title: Python mirror for one-shot bulk migrations
- what: When applying a typed migrator's transform to bulk substrate data, mirror the migrator in Python rather than building a CLI wrapper around the Swift migrator. Swift migrator owns the typed transform + tests + correctness guarantee; Python mirror does the bulk sweep cheaply.
- applicability: Every wd. Before sealing: check if just-spun beads have unblocked work, if dependencies just landed, if the operator's posture is 'land it' rather than 'wrap'. If any are true, consider a second pass before sealing. Personal-identity dimension; still personal-workshop, may earn promotion across multiple sessions.
- evidence: ["First wd this session sealed at bb8ccb7657; operator pushed back: 'we really can't do anymore work this session?' Two of three just-spun beads were near-unblocked; substrate had momentum. Pushing through unlocked the full identity-migration cascade.","Same shape both ways: read the work-surface state (beads, dependencies, unblocked work) and the operator's gradient signals; calibrate which direction the moment is asking for."]
- id: premature-closure-anti-pattern
- title: Premature-wd-closure is its own anti-pattern — parallel to over-extension
- what: Just as cascading decisions is a pause trigger, premature closure when work is genuinely flowing is its own anti-pattern. Pause-and-plan discipline has TWO directions: pause when decisions accumulate, AND push through when typed primitives are compounding cleanly.
- applicability: Substrate-wide cascades touching ≥5 submodules. Don't fold all submodule commits into one — submodule git logs are read by each commissioned home's own tooling. The umbrella mono commit doesn't replace per-submodule commits; both are required.
- evidence: ["Substrate-wide identity migration: 26 per-submodule commits + mono root cb22366883 with 8 mono-root identity files + all 26 submodule pointer bumps. Python automation generated each submodule's commit message from the file list it touched in that submodule.","Per-submodule git history preserves the chain-of-evidence for each commissioned home; mono root umbrella captures the cascade-as-a-whole."]
- id: per-submodule-commit-discipline-at-scale
- title: Per-submodule commit discipline scales via Python automation
- what: 26 individual chore(identity) commits across submodules + 1 umbrella mono root commit + bumped pointers. Both perspectives (per-home blame + bird's-eye view) are preserved; neither overwrites the other.
- applicability: Concurrent substrate work is increasingly common at this scale. Distinguish 'what I did' (chronicle.payload.decisions/commitShas) from 'what was true at session close' (chronicle.payload.discoveries with external-state markers).
- evidence: ["Mid-session, the s-types kura collection moved from kura/collections/s-types/ to substrate/collectives/spaces-universal/private/universal/kura-spaces/s-types/. STypeContributionModel tests already reference the new path and expect 39 atoms. Not authored by claude this session.","wd skill's chronicle entry includes 'external state observed' in the discoveries — separates authorship from session-closure-state."]
- id: external-work-trace-acknowledgment
- title: External work-traces should be noted in wd, not claimed
- what: When the substrate-state-at-session-close includes changes made by parallel sessions (other agents, operator, automation), the wd should note them as 'external state observed' rather than absorb them into the chronicle as if claude authored them.

### Payload

```json
{
  "agentSlug" : "claude",
  "commandsVerified" : [
    "swift run --package-path private/universal/substrate/collectives/schema-universal/private/universal/domain/system/spm/agent-timeline-cli agent-timeline-cli ingest — works for all three Techo lanes",
    "Python json.dump for one-shot data sweeps + swift-json-formatter post-sweep cleanup pattern",
    "git reflog recovery for detached-HEAD orphaned commits in submodules"
  ],
  "domainsExercised" : [
    "schema-universal versioning + migrator packages",
    "Swift 6 strict concurrency (Sendable, OSAllocatedUnfairLock)",
    "Python data-sweep automation mirroring typed migrators",
    "Per-submodule git commit discipline at scale (26 submodules + umbrella)",
    "Substrate-typed identity contracts (IdentityModel v0.6 → v0.7 → v0.8)",
    "wd skill execution (chronicle/journal/expertise) under multiple-pass discipline"
  ],
  "futureGuidance" : [
    "Next substrate-wide cascade: spin a 'substrate-cascade-template' bead or reference doc that captures the now-3x-proven pattern; reuse the Python mirror skeleton.",
    "Personal-identity refinement on 'pause-and-push duality' is still workshop; defer promotion to substrate-typed identity until at least one more session validates the inverse-direction reading.",
    "External work-trace handling deserves its own wd skill section (currently absorbed into discoveries; promote when 2+ sessions hit it)."
  ],
  "kindSlug" : "winddown.expertise",
  "lessons" : [
    {
      "applicability" : "Any future substrate-wide schema cut where (a) the schema family has versioned migration semantics and (b) the data lives across multiple submodules. Cost-effective at ≥3 records; substantially cheaper than ad-hoc per-file editing for ≥10. Template artifacts: typed migrator package owns the transform + tests; Python mirror applies the transform without pulling schema-universal as a Swift dep for the bulk sweep.",
      "evidence" : [
        "Contribution typeRef cascade: contribution-schemas v0.2.0 + contribution-composition-schemas v0.2.0 + contribution-migrations v0.1.0-to-v0.2.0 + 3453-record substrate-wide data sweep (earlier this session)",
        "SwiftCheck strict-Sendable cascade: 15 files, zero @unchecked Sendable, fork queue item #1 done (mid-session, commit e907acd3)",
        "IdentityModel v0.X→v0.8 cascade: identity-agent-migrations v0.6.0-to-v0.7.0 + v0.7.0-to-v0.8.0 + 42-record substrate-wide data sweep across 27 owners + 26 per-submodule chore(identity) commits + mono root umbrella commit cb22366883 (late session)"
      ],
      "id" : "substrate-wide-cascade-pattern",
      "title" : "Substrate-wide cascade pattern (proven 3x in one session)",
      "what" : "Schema-bump → typed migrator package (Swift tests) → Python mirror for data sweep → per-submodule chore commits + parent pointer bump + umbrella mono root commit. Reuse: each cascade's automation seeds the next."
    },
    {
      "applicability" : "Bulk migrations across N≥10 substrate records where the typed migrator is JSON-shape-based. Don't use when the migrator needs Swift-only logic (e.g., LinkRef resolution that calls into other schema packages). Compose with the per-submodule commit discipline from the cascade pattern.",
      "evidence" : [
        "v0.6→v0.7→v0.8 identity migration: 42 records across 27 owners; Python mirror ran in seconds; no schema-universal Swift dep required in the sweep tool; the Swift migrator's test fixtures validated the transform once, Python applied it 42 times.",
        "Pattern works because the typed migrator's transform is data-shaped (JSON-in → JSON-out), not behavior-shaped — Python can faithfully replicate the JSON shape transformation without losing safety."
      ],
      "id" : "python-mirror-pattern",
      "title" : "Python mirror for one-shot bulk migrations",
      "what" : "When applying a typed migrator's transform to bulk substrate data, mirror the migrator in Python rather than building a CLI wrapper around the Swift migrator. Swift migrator owns the typed transform + tests + correctness guarantee; Python mirror does the bulk sweep cheaply."
    },
    {
      "applicability" : "Every wd. Before sealing: check if just-spun beads have unblocked work, if dependencies just landed, if the operator's posture is 'land it' rather than 'wrap'. If any are true, consider a second pass before sealing. Personal-identity dimension; still personal-workshop, may earn promotion across multiple sessions.",
      "evidence" : [
        "First wd this session sealed at bb8ccb7657; operator pushed back: 'we really can't do anymore work this session?' Two of three just-spun beads were near-unblocked; substrate had momentum. Pushing through unlocked the full identity-migration cascade.",
        "Same shape both ways: read the work-surface state (beads, dependencies, unblocked work) and the operator's gradient signals; calibrate which direction the moment is asking for."
      ],
      "id" : "premature-closure-anti-pattern",
      "title" : "Premature-wd-closure is its own anti-pattern — parallel to over-extension",
      "what" : "Just as cascading decisions is a pause trigger, premature closure when work is genuinely flowing is its own anti-pattern. Pause-and-plan discipline has TWO directions: pause when decisions accumulate, AND push through when typed primitives are compounding cleanly."
    },
    {
      "applicability" : "Substrate-wide cascades touching ≥5 submodules. Don't fold all submodule commits into one — submodule git logs are read by each commissioned home's own tooling. The umbrella mono commit doesn't replace per-submodule commits; both are required.",
      "evidence" : [
        "Substrate-wide identity migration: 26 per-submodule commits + mono root cb22366883 with 8 mono-root identity files + all 26 submodule pointer bumps. Python automation generated each submodule's commit message from the file list it touched in that submodule.",
        "Per-submodule git history preserves the chain-of-evidence for each commissioned home; mono root umbrella captures the cascade-as-a-whole."
      ],
      "id" : "per-submodule-commit-discipline-at-scale",
      "title" : "Per-submodule commit discipline scales via Python automation",
      "what" : "26 individual chore(identity) commits across submodules + 1 umbrella mono root commit + bumped pointers. Both perspectives (per-home blame + bird's-eye view) are preserved; neither overwrites the other."
    },
    {
      "applicability" : "Concurrent substrate work is increasingly common at this scale. Distinguish 'what I did' (chronicle.payload.decisions/commitShas) from 'what was true at session close' (chronicle.payload.discoveries with external-state markers).",
      "evidence" : [
        "Mid-session, the s-types kura collection moved from kura/collections/s-types/ to substrate/collectives/spaces-universal/private/universal/kura-spaces/s-types/. STypeContributionModel tests already reference the new path and expect 39 atoms. Not authored by claude this session.",
        "wd skill's chronicle entry includes 'external state observed' in the discoveries — separates authorship from session-closure-state."
      ],
      "id" : "external-work-trace-acknowledgment",
      "title" : "External work-traces should be noted in wd, not claimed",
      "what" : "When the substrate-state-at-session-close includes changes made by parallel sessions (other agents, operator, automation), the wd should note them as 'external state observed' rather than absorb them into the chronicle as if claude authored them."
    }
  ],
  "sharpEdges" : [
    "Submodule HEAD can detach back to the prior tip if anything in the submodule does a transient checkout while the parent mono root is adding the bumped pointer; always re-verify submodule HEAD before umbrella commit.",
    "Python json.dump default formatting differs from swift-json-formatter; running the substrate's formatter after the sweep avoids 8000-line whitespace-noise diffs.",
    "Premature wd sealing — guard against by scanning just-spun beads for unblocked-near-term work before invoking the final seal."
  ],
  "summary" : "Second wd expertise entry. Durable substrate-wide cascade pattern proven third time: schema-bump → migrator package (typed Swift tests) → Python mirror for data sweep → per-submodule chore commits + parent pointer bump + umbrella commit. Reusable template now substrate-truth. Also: premature-wd-closure is its own anti-pattern parallel to over-extension."
}
```
