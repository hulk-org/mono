@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Architecture — Deep Read")
}

# Secret Surfaces — Deep Read (2026-04-09)

This article supersedes the shallow inventory in <doc:mystery-surfaces>
with a full read of every load-bearing file. The goal: understand the
**multi-agent runtime, the mailbox, the teleport + git-bundle
pipeline, and the leader-permission bridge** well enough that hulk
can make informed carrier-vs-persona decisions without having to
re-read these surfaces.

7,548 LOC in `utils/swarm/`, 955 LOC in `utils/teleport/`, 476 LOC
in `utils/ultraplan/`, plus supporting files in
`utils/teammate.ts` (293 lines), `utils/teammateMailbox.ts` (120+
lines read), and `utils/teammateContext.ts` (re-exported).

## 1. Identity resolution — `utils/teammate.ts`

Every teammate resolves identity through a **two-layer priority
chain**:

```
1. AsyncLocalStorage  (in-process teammates — utils/teammateContext.ts)
2. dynamicTeamContext  (tmux teammates via CLI args)
```

Fields resolved: `agentId`, `agentName`, `teamName`, `color`,
`parentSessionId`, `planModeRequired`.

The split is clean:
- **In-process teammates** share a Node.js process with the leader.
  `AsyncLocalStorage` gives them isolated state per concurrent
  teammate without overwriting each other.
- **Pane-based teammates** (tmux/iTerm2) run in their own process.
  Identity arrives as CLI args (`--agent-id`, `--team-name`, etc.)
  and lands in `dynamicTeamContext`.

Key helper: `isTeamLead(teamContext)`. A session is the lead if its
`agentId` matches `teamContext.leadAgentId`, or (backward compat) if
it has no agent id but does have a team context — meaning it's the
session that *created* the team before agent IDs were standardized.

Lifecycle helpers: `hasActiveInProcessTeammates(appState)`,
`hasWorkingInProcessTeammates(appState)`,
`waitForTeammatesToBecomeIdle(setAppState, appState)`. The last one
registers `onIdleCallbacks` on each running teammate's task record
in `AppState`, resolving a promise when all of them fire. Race-safe:
if a teammate goes idle between the snapshot and the callback
registration, `onIdle` fires immediately.

## 2. Mailbox — `utils/teammateMailbox.ts`

**File-based messaging.** Each teammate gets an inbox:

```
~/.claude/teams/{team_name}/inboxes/{agent_name}.json
```

Messages are `TeammateMessage[]`:
```ts
{
  from: string
  text: string
  timestamp: string
  read: boolean
  color?: string      // sender's assigned color
  summary?: string    // 5-10 word preview shown in UI
}
```

Concurrency: uses a **lockfile with retry/backoff** (10 retries,
5–100 ms timeout per retry). The async lockfile API is used because
the sync version blocked the event loop in swarm scenarios where
multiple Claudes write to the same inbox.

Key operations:
- `readMailbox(agentName, teamName)` — reads all messages.
- `readUnreadMessages(agentName, teamName)` — filtered view.
- `writeToMailbox(agentName, message)` — write + lock.
- `createIdleNotification(agentName, { idleReason, summary })` —
  structured idle message that teammates send to the leader on
  `Stop`.
- `getLastPeerDmSummary(messages)` — extracts the most recent
  peer DM summary from the message array (used by the idle
  notification to give the leader a "what was the teammate last
  doing?" one-liner).
- `createShutdownRequestMessage(...)` — asks a teammate to stop.

Messages are delivered as **attachments** in the model's message
stream (not as tool calls), using the `TEAMMATE_MESSAGE_TAG` XML
tag from `constants/xml.ts`. `SendMessageTool` is what the model
calls to write to another teammate's inbox.

## 3. Teammate init — `utils/swarm/teammateInit.ts`

130 LOC. Called early in a teammate's session startup. Does two things:

1. **Applies team-wide permissions.** Reads the team file, and for
   each `teamAllowedPaths` entry, injects an `addRules` permission
   update into `AppState.toolPermissionContext`. Path format:
   `/absolute/path/**` for absolute, `relative/path/**` for
   relative. This is how the leader grants filesystem access to
   all teammates at once without per-teammate config.

2. **Registers the idle notification hook.** A `Stop` hook that
   fires when this teammate's session ends:
   - Marks the teammate as inactive in the team config via
     `setMemberActive(teamName, agentName, false)`.
   - Writes an idle notification to the **leader's** inbox (not a
     broadcast — directly to `leadAgentName`).
   - The notification includes `idleReason: 'available'` and a
     summary from `getLastPeerDmSummary(messages)`.
   - The hook has a 10-second timeout and runs `await writeToMailbox`
     to ensure the write completes before process shutdown.
   - Returns `true` (don't block the `Stop`).

The leader is identified by `teamFile.leadAgentId`, looked up from
`teamFile.members`.

## 4. Leader permission bridge — `utils/swarm/leaderPermissionBridge.ts`

55 LOC. The smallest but most architecturally significant file.

When an in-process teammate needs tool-use permission, it needs to
show the standard `ToolUseConfirm` dialog. But the dialog lives in
the **leader REPL's React tree**, not the teammate's context. This
bridge makes the leader's React state setters available to non-React
code:

```ts
registerLeaderToolUseConfirmQueue(setter)
getLeaderToolUseConfirmQueue() → setter | null
unregisterLeaderToolUseConfirmQueue()

registerLeaderSetToolPermissionContext(setter)
getLeaderSetToolPermissionContext() → setter | null
unregisterLeaderSetToolPermissionContext()
```

The REPL registers these at mount. In-process teammates call
`getLeaderToolUseConfirmQueue()` to push their permission request
into the leader's queue. The leader's `ToolUseConfirm` dialog
handles it like any other permission prompt — the operator sees one
unified consent surface regardless of which teammate is asking.

**This is the single point where the carrier-vs-persona split
matters most.** Today, all teammates share one leader. If hulk wants
different personas to have *different* permission profiles, the
bridge needs to carry persona identity alongside the permission
request.

## 5. Backend registry — `utils/swarm/backends/registry.ts`

465 LOC. Detection + caching + fallback + mode resolution.

**Detection priority flow:**

```
1. Inside tmux?                         → tmux backend (native)
2. Inside iTerm2 + it2 CLI available?   → iterm2 backend (native)
3. Inside iTerm2 + user prefers tmux?   → tmux backend (non-native)
4. Inside iTerm2 + tmux available?      → tmux backend + needsIt2Setup flag
5. tmux available anywhere?             → tmux backend (external session)
6. None available?                      → error + install instructions
```

**Fallback to in-process** is tracked by `inProcessFallbackActive`.
Once a pane spawn fails because no backend is available, all
subsequent spawns go in-process for the rest of the session.
Non-interactive sessions (`-p` mode) always use in-process.

Backends register lazily via `registerTmuxBackend` /
`registerITermBackend` (called by the backend module itself on
import). This avoids circular dependencies since the registry is
imported first.

Three resolved modes: `'in-process'`, `'tmux'`, `'iterm2'`.
The mode is captured at startup via `getTeammateModeFromSnapshot()`
and is **immutable for the session** — runtime config changes to
`teammateMode` are ignored after the first detection.

## 6. Backend interface — `utils/swarm/backends/types.ts`

Two parallel interface shapes:

**`PaneBackend`** — low-level pane operations:
- `createTeammatePaneInSwarmView(name, color)` → `CreatePaneResult`
- `sendCommandToPane(paneId, command)`
- `setPaneBorderColor(paneId, color)`
- `setPaneTitle(paneId, name, color)`
- `enablePaneBorderStatus(windowTarget)`
- `rebalancePanes(windowTarget, hasLeader)`
- `killPane(paneId)` → boolean
- `hidePane(paneId)` / `showPane(paneId, target)` → boolean
- `supportsHideShow` (readonly; iTerm2 does, tmux does)

**`TeammateExecutor`** — high-level teammate lifecycle:
- `spawn(config: TeammateSpawnConfig)` → `TeammateSpawnResult`
- `sendMessage(agentId, message)` (via mailbox)
- `terminate(agentId, reason)` — graceful shutdown request
- `kill(agentId)` — immediate termination
- `isActive(agentId)` → boolean

`PaneBackendExecutor` wraps a `PaneBackend` to provide the
`TeammateExecutor` interface. `InProcessBackend` implements
`TeammateExecutor` directly (no panes).

**`TeammateSpawnConfig`** is the richest type and worth quoting
in full:

```ts
type TeammateSpawnConfig = TeammateIdentity & {
  prompt: string               // initial prompt
  cwd: string                  // working directory
  model?: string               // model override
  systemPrompt?: string        // from workflow config
  systemPromptMode?: 'default' | 'replace' | 'append'
  worktreePath?: string        // git worktree
  parentSessionId: string      // leader session id
  permissions?: string[]       // granted tool permissions
  allowPermissionPrompts?: boolean  // false → auto-deny unlisted
}
```

The `systemPromptMode` field is the **persona-injection seam**.
Today it's `'default' | 'replace' | 'append'` — a teammate can
fully replace the system prompt or append to it. A persona bundle
would use `'replace'` with the persona's own SOUL document.

## 7. In-process runner — `utils/swarm/inProcessRunner.ts`

The longest file. Wraps `runAgent()` for in-process teammates with:

- **AsyncLocalStorage isolation** via `runWithTeammateContext()`.
- **AppState progress tracking** — imports the same
  `createProgressTracker` / `updateProgressFromMessage` path that
  `LocalAgentTask` uses.
- **Idle notification** to the leader on completion.
- **Plan mode approval flow** — if `planModeRequired`, the teammate
  enters plan mode and waits for leader approval before writing code.
- **Cleanup on abort** — independent `AbortController` (not linked
  to parent) so aborting one teammate doesn't cascade.
- **Tool visibility** — imports constants for `BASH_TOOL_NAME`,
  `SEND_MESSAGE_TOOL_NAME`, `TASK_*_TOOL_NAME`, `TEAM_*_TOOL_NAME`.
  Teammates see the full tool set.
- **Compaction** — runs the autocompact + microcompact cycle.
- **Permission routing** via `useSwarmPermissionPoller`
  `processMailboxPermissionResponse`.

In short: a teammate is a full `runAgent` call with a different
`AsyncLocalStorage` context. The same tools, the same compaction
engine, the same permission system — just running under a
different identity.

## 8. Teammate prompt addendum — `utils/swarm/teammatePromptAddendum.ts`

19 LOC. The system prompt addendum appended to teammates:

> You are running as an agent in a team. To communicate with anyone
> on your team:
> - Use the SendMessage tool with `to: "<name>"` to send messages
>   to specific teammates
> - Use the SendMessage tool with `to: "*"` sparingly for
>   team-wide broadcasts
>
> Just writing a response in text is not visible to others on your
> team — you MUST use the SendMessage tool.
>
> The user interacts primarily with the team lead. Your work is
> coordinated through the task system and teammate messaging.

This is the **only persona-differentiation point today**. Every
teammate gets the same addendum. If hulk wants different personas,
this is the first file to fork per persona — replacing it with
persona-specific instructions about *who* the teammate is.

## 9. Constants — `utils/swarm/constants.ts`

```ts
TEAM_LEAD_NAME   = 'team-lead'
SWARM_SESSION_NAME = 'claude-swarm'
SWARM_VIEW_WINDOW_NAME = 'swarm-view'
TMUX_COMMAND     = 'tmux'
HIDDEN_SESSION_NAME = 'claude-hidden'
getSwarmSocketName() → `claude-swarm-${process.pid}`

TEAMMATE_COMMAND_ENV_VAR   = 'CLAUDE_CODE_TEAMMATE_COMMAND'
TEAMMATE_COLOR_ENV_VAR     = 'CLAUDE_CODE_AGENT_COLOR'
PLAN_MODE_REQUIRED_ENV_VAR = 'CLAUDE_CODE_PLAN_MODE_REQUIRED'
```

The `TEAMMATE_COMMAND_ENV_VAR` override is how you'd point at a
**different binary** for spawning teammates — e.g., a claw-code
Rust teammate instead of a Node.js one, or a hulk-wrapped persona
bundle.

## 10. Teleport — `utils/teleport/gitBundle.ts`

The teleport pipeline ships a workspace to a remote Claude Code via
**git's bundle format** — not tar, not zip — so the remote gets a
real repo with full history. The flow:

1. `git stash create` → `update-ref refs/seed/stash` (makes
   uncommitted work reachable by the bundle).
2. `git bundle create --all` (includes `refs/seed/stash`).
3. Upload to `/v1/files` (Anthropic file API).
4. Cleanup `refs/seed/stash`.
5. Caller sets `seed_bundle_file_id` on the `SessionContext`.

Three bundle scopes, tried in order:
- `--all` (full repo including stash ref, all branches/tags).
- `HEAD` (current branch only, drops side branches + tags).
- squashed-root (single parentless commit of HEAD's tree — no
  history, just the snapshot; receiver needs `refs/seed/root`
  handling).

Fallback trigger: if the bundle exceeds `tengu_ccr_bundle_max_bytes`
(default 100 MB), it drops to the next tier.

`BundleUploadResult` includes `{ scope, hasWip, bundleSizeBytes }`
so the receiver knows what it got.

## 11. Ultraplan — `utils/ultraplan/ccrSession.ts`

Polls a remote teleported session:
- **Poll interval:** 3 seconds.
- **Failure tolerance:** 5 consecutive failures before giving up
  (at ~600 calls/30 min, any nonzero 5xx rate would kill it).
- **Transient-error retry:** uses `isTransientNetworkError` from
  `utils/teleport/api.ts`.
- **Completion signal:** scans for an approved `ExitPlanMode`
  tool result (`EXIT_PLAN_MODE_V2_TOOL_NAME`).
- **Pagination:** uses `pollRemoteSessionEvents` (shared with
  `RemoteAgentTask`) for typed `SDKMessage[]`.

The plan text is extracted from the tool result's content.

## Implications for the carrier-vs-persona story

Reading all of this in depth, the picture is sharper than
<doc:mystery-surfaces> sketched. Here are the **five specific
files** that matter for making the swarm persona-aware:

### 1. `TeammateSpawnConfig.systemPromptMode`
**Already a three-way enum.** `'default' | 'replace' | 'append'`.
A persona bundle would set `'replace'` and provide its SOUL as the
system prompt. No type change needed — just a new source for the
prompt value.

### 2. `teammatePromptAddendum.ts`
**Currently identical for all teammates.** Fork this per persona to
give each teammate persona-specific instructions (e.g., "you are
^claude" vs. "you are ^codex" vs. "you are ^carrie"). The addendum
is appended after the system prompt, so a `'replace'` system prompt
followed by a persona-specific addendum gives full control.

### 3. `leaderPermissionBridge.ts`
**Currently persona-blind.** The bridge carries
`SetToolUseConfirmQueueFn` but no identity metadata. If different
personas should have different permission profiles (e.g., claw can
write anywhere, carrie can only read), the bridge needs to carry
the persona identity alongside the request, and the leader's
`ToolUseConfirm` dialog needs to show *which persona* is asking.

### 4. `teammate.ts` — `dynamicTeamContext`
**Already has `agentName`.** A persona bundle would map `agentName`
to the persona slug. No type change needed — just ensure the slug
is the one from the persona's identity bundle
(`claude`, `codex`, `carrie`, `claw`), not a free-text label.

### 5. `teammateMailbox.ts` — inbox paths
**Currently keyed by `agentName`.** If personas have durable inboxes
across sessions, the path scheme needs a session-stable component.
Today it's
`~/.claude/teams/{teamName}/inboxes/{agentName}.json` — which gets
wiped when the team is deleted. Durable persona mailboxes would need
to live at the hulk carrier level, not the Claude Code team level.

### What's NOT missing

- **Tool visibility:** teammates already see the full tool set.
  A persona that should see a restricted set can filter at the
  `permissions` field in `TeammateSpawnConfig`.
- **Model selection:** `teammateModel.ts` already resolves
  per-provider fallbacks. A persona that prefers a different model
  just sets `config.model`.
- **Compaction + memory:** the in-process runner already runs full
  autocompact + microcompact. Persona-specific memory is a memdir
  question, not a swarm question.
- **Abort lifecycle:** independent `AbortController` per teammate is
  already the pattern. Killing one persona doesn't cascade.

### What IS missing (summary)

1. Persona-identity-aware permission bridge (file 3 above).
2. Per-persona prompt addendum (file 2 above — trivial).
3. Durable cross-session mailboxes for personas (file 5 above).
4. A persona-bundle loader that resolves
   `SOUL + system prompt + permitted tools + model preference`
   from an identity bundle and packs it into a
   `TeammateSpawnConfig`.

Item 4 is the only new code. Items 1–3 are edits to existing files.

## Full read: `inProcessRunner.ts` (1,552 LOC)

This is the heart of the swarm — a **continuous prompt loop** that
runs `runAgent()` inside an `AsyncLocalStorage` context with full
conversation accumulation, compaction, permission routing, mailbox
polling, task claiming, and graceful shutdown. Deserves its own
section because every future persona question lives or dies here.

### Entry point

`startInProcessTeammate(config)` fires `runInProcessTeammate(config)`
in a fire-and-forget `void` call. The config type
(`InProcessRunnerConfig`) captures everything:

```ts
{
  identity: TeammateIdentity
  taskId: string
  prompt: string
  agentDefinition?: CustomAgentDefinition
  teammateContext: TeammateContext
  toolUseContext: ToolUseContext
  abortController: AbortController
  model?: string
  systemPrompt?: string
  systemPromptMode?: 'default' | 'replace' | 'append'
  allowedTools?: string[]
  allowPermissionPrompts?: boolean
  description?: string
  invokingRequestId?: string
}
```

### System prompt assembly

Three modes for `systemPromptMode`:

1. **`'replace'`** — uses `config.systemPrompt` verbatim. Full
   persona replacement. Does NOT append
   `TEAMMATE_SYSTEM_PROMPT_ADDENDUM`. So a `'replace'` persona
   must include its own teammate communication instructions.

2. **`'default'`** — calls `getSystemPrompt()` (the standard main
   agent system prompt), then appends
   `TEAMMATE_SYSTEM_PROMPT_ADDENDUM`. If an `agentDefinition`
   is provided, also appends `agentDefinition.getSystemPrompt()`
   under `# Custom Agent Instructions`.

3. **`'append'`** — same as default, plus appends
   `config.systemPrompt` at the end.

### Agent definition resolution

Every teammate gets a `resolvedAgentDefinition: CustomAgentDefinition`
with:
- `agentType: identity.agentName` — the teammate name *is* the type.
- `tools`: if the agent definition specifies a tool list, **team-
  essential tools are force-injected**: `SendMessage`, `TeamCreate`,
  `TeamDelete`, `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate`.
  If no tool list, uses `['*']` (all tools).
- `permissionMode: 'default'` — teammates always get full tool access
  regardless of the leader's permission mode. The leader's mode
  governs the leader's own tools, not the teammates'.
- The per-iteration loop checks `task.permissionMode` from
  `AppState` (which the leader can cycle via `Shift+Tab`), and
  overrides `resolvedAgentDefinition.permissionMode` per iteration.

### The main loop

```
while (!aborted && !shouldExit) {
  1. Create per-turn AbortController (Escape stops current turn only)
  2. Check if autocompact threshold exceeded → compact
  3. Run runAgent() with:
     - createInProcessCanUseTool (leader bridge + mailbox fallback)
     - forkContextMessages (accumulated conversation)
     - model override
     - allowedTools
     - contentReplacementState (persistent across iterations)
  4. Accumulate messages into allMessages + AppState
  5. Update progress tracker
  6. On turn completion: mark idle, call onIdleCallbacks, send
     idle notification to leader via mailbox
  7. Wait for next prompt or shutdown:
     - Poll mailbox every 500ms
     - Priority: shutdown requests > team-lead messages > peer messages
     - Also check team task list for unclaimed tasks
     - Also check AppState.pendingUserMessages (from transcript UI)
  8. On new message: loop continues
  9. On shutdown request: pass to model for decision (NOT auto-approved)
  10. On abort: exit
}
```

### Two abort layers

- **Lifecycle `AbortController`** — kills the whole teammate.
  Independent of the leader's controller. Set on spawn.
- **Per-turn `currentWorkAbortController`** — stops the current
  `runAgent()` call. Created fresh each iteration. Stored in
  `AppState` so the UI can `Escape` it. If work is aborted, the
  teammate goes idle and sends an `idleReason: 'interrupted'`
  notification.

### Permission routing

`createInProcessCanUseTool()` has two paths:

1. **Leader bridge (preferred):** calls
   `getLeaderToolUseConfirmQueue()` and pushes a
   `ToolUseConfirm` entry into the leader's React queue. The entry
   includes a `workerBadge: { name, color }` so the dialog shows
   which teammate is asking. Decision flows back via `onAllow` /
   `onReject` / `recheckPermission`. Permission updates are
   persisted AND written back to the leader's shared context with
   `preserveMode: true` (prevents the teammate's `acceptEdits`
   context from leaking back to the coordinator's mode).

2. **Mailbox fallback:** if the leader bridge is unavailable
   (e.g., detached process), creates a `SwarmPermissionRequest`,
   sends it to the leader's inbox via
   `sendPermissionRequestViaMailbox()`, registers a callback, and
   polls the teammate's own mailbox every 500ms for the response.

For bash commands specifically: if `feature('BASH_CLASSIFIER')` is
on, the teammate **awaits** the classifier result (unlike the main
agent which races it against user interaction). This means bash
auto-approval is blocking for teammates.

### Compaction

When `tokenCountWithEstimation(allMessages)` exceeds
`getAutoCompactThreshold()`, the runner:
- Creates an **isolated** `ToolUseContext` clone (separate
  `readFileState` cache, no UI callbacks) to prevent compaction from
  interfering with the main session.
- Calls `compactConversation()` then `buildPostCompactMessages()`.
- Replaces `allMessages` in place.
- Resets `microcompact` state and `contentReplacementState`.
- Mirrors the compaction into `task.messages` in `AppState`.

### Task claiming

On startup and in every idle loop iteration, the teammate calls
`tryClaimNextTask(parentSessionId, agentName)`. This:
- Lists tasks from the team task list.
- Finds the first pending, unowned, unblocked task.
- Claims it atomically via `claimTask()`.
- Sets status to `in_progress`.
- Formats the task as a prompt.

This means **teammates are self-scheduling** — they don't wait for
the leader to assign tasks. The leader creates tasks; teammates
claim and work them autonomously.

### Message priority in the idle loop

```
1. AppState.pendingUserMessages (from transcript viewing / direct injection)
2. Mailbox: shutdown requests (highest priority, scanned first)
3. Mailbox: team-lead messages (prioritized over peers)
4. Mailbox: peer messages (FIFO)
5. Team task list: unclaimed tasks
```

Shutdown requests are never auto-approved — they're passed to the
model as a teammate-message XML block. The model decides whether to
shut down or keep working. This is a deliberate design choice: the
shutdown request is a *conversation turn*, not a kill signal.

### XML message format

All inter-teammate messages are wrapped in
`<teammate-message teammate_id="name" color="..." summary="...">`:

```xml
<teammate-message teammate_id="researcher" color="blue" summary="found 3 bugs">
  I found three bugs in the auth module...
</teammate-message>
```

This ensures the model sees teammate messages in a structured
format regardless of whether the teammate is in-process or
pane-based. User messages (from the transcript UI) are NOT wrapped.

## Full read: `permissionSync.ts` (928 LOC)

File-based permission synchronization with structured request/response
lifecycle:

### On-disk layout

```
~/.claude/teams/{teamName}/permissions/
  pending/
    perm-{timestamp}-{random}.json
  resolved/
    perm-{timestamp}-{random}.json
```

### Request schema (`SwarmPermissionRequest`)

```ts
{
  id: string                    // "perm-{timestamp}-{random}"
  workerId: string              // agent id
  workerName: string            // agent name
  workerColor?: string          // display color
  teamName: string
  toolName: string              // "Bash", "Edit", etc.
  toolUseId: string
  description: string           // human-readable
  input: Record<string, unknown>
  permissionSuggestions: unknown[]
  status: 'pending' | 'approved' | 'rejected'
  resolvedBy?: 'worker' | 'leader'
  resolvedAt?: number
  feedback?: string             // rejection reason
  updatedInput?: Record<string, unknown>
  permissionUpdates?: unknown[]  // "always allow" rules
  createdAt: number
}
```

Validated with Zod v4 via `lazySchema()`. Directory-level lockfile
for atomic writes.

### Flow

1. Worker calls `writePermissionRequest()` → writes to `pending/`.
2. Worker also sends a notification to the leader's mailbox via
   `sendPermissionRequestViaMailbox()`.
3. Leader reads pending via `readPendingPermissions()` (sorted by
   `createdAt`, oldest first).
4. Leader resolves via `resolvePermissionRequest()` → moves from
   `pending/` to `resolved/`, sends response to worker's mailbox.
5. Worker reads resolved via `readResolvedPermission()` or catches
   the mailbox response.

The dual path (file + mailbox) ensures both the bridge path (direct
React queue) and the fallback path (file-based) have consistent state.

## Full read: `teamHelpers.ts` (683 LOC)

The team file is the **durable state of a swarm** on disk:

### `TeamFile` type

```ts
{
  name: string
  description?: string
  createdAt: number
  leadAgentId: string
  leadSessionId?: string           // leader's session UUID
  hiddenPaneIds?: string[]         // panes hidden from UI
  teamAllowedPaths?: TeamAllowedPath[]  // team-wide fs permissions
  members: Array<{
    agentId: string
    name: string
    agentType?: string
    model?: string
    prompt?: string
    color?: string
    planModeRequired?: boolean
    joinedAt: number
    tmuxPaneId: string
    cwd: string
    worktreePath?: string
    sessionId?: string
    subscriptions: string[]
    backendType?: BackendType
    isActive?: boolean            // false when idle
    mode?: PermissionMode
  }>
}
```

Stored at `~/.claude/teams/{team_name}/config.json`.

Operations: `readTeamFile`, `writeTeamFile` (sync + async variants),
`removeTeammateFromTeamFile`, `addHiddenPaneId`,
`removeHiddenPaneId`, `setMemberActive`. The `TeamCreateTool` uses
`inputSchema` (Zod: `{ operation, agent_type, team_name,
description }`) for `spawnTeam` / `cleanup` operations.

Notable field: **`teamAllowedPaths`** — array of
`{ path, toolName, addedBy, addedAt }`. The leader can grant
team-wide filesystem access (applied at teammate init via
`applyPermissionUpdate`). This is how one operator approval
cascades to all teammates at once.

## Full read: other files

### `spawnInProcess.ts` (328 LOC)

Creates `TeammateContext`, generates deterministic `agentId`
(`name@team`), creates independent `AbortController`, registers the
task in `AppState`, registers cleanup + Perfetto tracing, and returns
`InProcessSpawnOutput`. Also contains `killInProcessTeammate()`:
aborts the controller, calls `onIdleCallbacks`, removes from
`teamContext.teammates`, removes from team file, emits SDK terminated
event, schedules eviction.

### `reconnection.ts` (119 LOC)

Handles session resume for teammates. `computeInitialTeamContext()`
reads `dynamicTeamContext` (set from CLI args in `main.tsx`) and the
team file to produce `AppState.teamContext` synchronously BEFORE
first React render. `initializeTeammateContextFromSession()` does the
same for transcript-resumed sessions. Both produce the same shape:
`{ teamName, teamFilePath, leadAgentId, selfAgentId, selfAgentName,
isLeader, teammates: {} }`.

### `teammateLayoutManager.ts` (107 LOC)

Round-robin color assignment from `AGENT_COLORS` palette. Thin
delegation to the detected `PaneBackend` for pane creation, border
status, and command sending.

## What this means for persona-aware swarm (revised)

After reading every line, the gap is even smaller than
<doc:mystery-surfaces> estimated. The critical finding:

**`systemPromptMode: 'replace'` already skips the standard prompt
AND the teammate addendum.** A persona bundle using `'replace'`
has complete control of the system prompt. The persona just needs to
include its own teammate communication instructions (the
`SendMessage` / `to: "*"` pattern) since the addendum won't be
appended for it.

**Teammates are self-scheduling via the task list.** A persona
doesn't need the leader to hand it work — it claims tasks
autonomously. This means a multi-persona hulk could have a shared
task list where different personas claim tasks suited to their
specialization.

**The permission bridge already carries `workerBadge: { name, color }`**
on every request. The leader's `ToolUseConfirm` dialog already shows
which teammate is asking. Adding persona identity is a one-field
edit (add `personaSlug` to the badge), not an architecture change.

The remaining gap:
1. A persona-bundle loader (~200 LOC estimated, reads identity
   bundle → `InProcessRunnerConfig`).
2. Durable cross-session mailboxes (path scheme change in
   `teammateMailbox.ts`).
3. Per-persona teammate addendum (fork `teammatePromptAddendum.ts`
   or inline into the `'replace'` system prompt).
4. One-field persona slug on the worker badge
   (`leaderPermissionBridge.ts`).
