@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Architecture")
}

# Mystery Surfaces (Resolved)

Follow-up to the open questions in <doc:index>. The eight surfaces
called out as "mystery" turn out to cluster cleanly into four
groups, and one of those groups — the **multi-agent runtime** — is
load-bearing for the carrier-vs-persona conversation in operator
memory. This is the important part.

## TL;DR — what each surface actually is

| Surface | What it is |
| --- | --- |
| `utils/swarm/` | The **in-process / multi-pane teammate runtime**. Leader + teammates, iTerm/Tmux/in-process backends, mailbox comms, permission bridge. Backs `tasks/InProcessTeammateTask/` and `coordinator/`. |
| `utils/teleport/` + `commands/teleport/` | **Ship a workspace to a remote Claude Code**. Git-bundle the repo, pick an environment (Anthropic Cloud / BYOC / Bridge), open a remote session. |
| `utils/ultraplan/` | **Plan-mode round trip over teleport.** Sends a plan request to a remote Claude in plan mode and polls until it `ExitPlanMode`s with an approved plan. CCR BYOC beta. |
| `utils/dxt/` | **Desktop Extension / MCP bundle handling.** Validates `.dxt` / `.mcpb` manifests, safe-zip extraction. |
| `commands/thinkback/` + `/thinkback-play` | Marketplace-installable **animation skill**. Loaded from the official plugin marketplace (or `claude-code-marketplace` for ant builds). |
| `commands/passes/` + `components/Passes/` | **Guest passes / referral program** UI. Tracks "remaining passes," logs `tengu_guest_passes_visited`, gates the upsell. |
| `components/grove/` | **Terms-of-service consent flow.** Codename "Grove." Handles the October 8 2025 Consumer Terms / Privacy Policy update with grace-period acceptance. |
| `moreright/useMoreRight.tsx` | **Internal-only REPL middleware hook.** External builds get the no-op stub seen in this tree; the real implementation is internal. |

## Group 1 — Multi-agent runtime (the load-bearing one)

Three subsystems compose the multi-agent story. They are not
discoverable by name; the picture only emerges when you read them
together.

### `utils/swarm/` — the teammate runtime

A complete leader + teammates execution model with pluggable
backends. Files:

- **`teammateModel.ts`** — Per-teammate model selection. Provider-aware
  fallback to `CLAUDE_OPUS_4_6_CONFIG[getAPIProvider()]` so
  Bedrock/Vertex/Foundry customers get the right model id. Comment
  marker `@[MODEL LAUNCH]` flags this as a release-time touch point.
- **`teammateInit.ts`** — A teammate Claude Code instance registers
  a `Stop` hook on init that notifies the team leader when the
  teammate becomes idle. Uses `teammateMailbox` for cross-process
  comms.
- **`teammatePromptAddendum.ts`** — Additional system prompt
  injected when running as a teammate.
- **`teammateLayoutManager.ts`** — Manages where teammate panes
  appear.
- **`leaderPermissionBridge.ts`** — Module-level bridge so an
  in-process teammate can route its tool-use confirm requests
  through the **leader REPL's** standard `ToolUseConfirm` dialog
  rather than a separate permission badge. This is the key trick:
  one operator approves tool use for many running personas.
- **`permissionSync.ts`** — Permission state propagation across
  the swarm.
- **`reconnection.ts`** — Reconnect to a teammate that's gone away.
- **`spawnInProcess.ts`** + **`inProcessRunner.ts`** — Run a
  teammate inside the leader's process.
- **`spawnUtils.ts`** — Pane / process spawning helpers.
- **`teamHelpers.ts`** — Read/write the team file, set member
  active state.
- **`It2SetupPrompt.tsx`** — iTerm2 setup wizard.
- **`constants.ts`** — Swarm constants.
- **`backends/`** — Backend registry:
  - `registry.ts` — Backend selection.
  - `detection.ts` — Detect the host terminal.
  - `types.ts` — Backend interface.
  - `InProcessBackend.ts` — Same-process teammates.
  - `ITermBackend.ts` — iTerm2-pane teammates.
  - `TmuxBackend.ts` — Tmux-pane teammates.
  - `it2Setup.ts` — iTerm2 specifics.
  - `PaneBackendExecutor.ts` — Shared executor for pane backends.
  - `teammateModeSnapshot.ts` — Snapshot of swarm state.

The execution model is **leader + N teammates with three backend
shapes** (in-process, iTerm2 panes, Tmux panes). Comms run through
a mailbox abstraction (`utils/teammateMailbox.ts`, sibling). The
leader owns permission UX for the whole swarm via
`leaderPermissionBridge.ts`.

This is **the implementation that the carrier-vs-persona founding
breach insight needs**. Hulk wanting to host multiple agent
personas at once is functionally identical to "Claude Code leader
running multiple in-process teammates." The work is already done at
the runtime layer; what's missing is the persona-bundle layer that
would let two of those teammates be different *characters*, not
just two instances of the same agent.

### `utils/teleport/` — workspace shipping

How a local Claude Code session moves its workspace to a remote
Claude Code:

- **`api.ts`** — Teleport HTTP client. Uses Anthropic OAuth
  (`getOauthConfig`, `getOrganizationUUID`,
  `getClaudeAIOAuthTokens`). Beta tag: `CCR_BYOC_BETA =
  'ccr-byoc-2025-07-29'` ("Claude Code Remote, Bring Your Own
  Cloud"). Has explicit retry config:
  `[2000, 4000, 8000, 16000]` ms. Distinguishes transient network
  errors from real failures via `isTransientNetworkError`.
- **`environments.ts`** — Environment listing. Three kinds:
  ```ts
  type EnvironmentKind = 'anthropic_cloud' | 'byoc' | 'bridge'
  ```
  Anthropic-hosted, customer cloud, or bridge-back-to-your-machine.
- **`environmentSelection.ts`** — UI/logic for picking an
  environment.
- **`gitBundle.ts`** — Bundles the local git state for shipping.
  This is *git's* bundle format — not a tar — so the remote can
  apply it as a real repo with full history.
- **`index.js`** — Teleport command entrypoint.

Plus `commands/teleport/index.js` and a cluster of teleport-aware
components: `TeleportError`, `TeleportProgress`,
`TeleportRepoMismatchDialog`, `TeleportResumeWrapper`,
`TeleportStash`. The repo-mismatch dialog implies teleport will
refuse to overwrite a divergent remote, which is the right move.

### `utils/ultraplan/` — plan-mode over teleport

Two files, but they tie the previous two together:

- **`ccrSession.ts`** — Polls a remote teleported session for an
  approved `ExitPlanMode` tool result, then extracts the plan
  text. Comment header is unusually clear:
  > CCR session polling for /ultraplan. Waits for an approved
  > ExitPlanMode tool_result, then extracts the plan text. Uses
  > pollRemoteSessionEvents (shared with RemoteAgentTask) for
  > pagination + typed SDKMessage[]. Plan mode is set via
  > set_permission_mode control_request in teleportToRemote's
  > CreateSession events array.

  Poll interval: 3 s. Max consecutive failures: 5 (the comment
  notes a 30-min poll is ~600 calls, so any nonzero 5xx rate would
  kill an unguarded run). Imports
  `EXIT_PLAN_MODE_V2_TOOL_NAME` from `tools/ExitPlanModeTool/` —
  the plan-mode tool exists in this tree as a real tool, not just
  a flag.
- **`keyword.ts`** — Detects `/ultraplan` token positions in
  prompt input (parallel to buddy's `findBuddyTriggerPositions`).

So `/ultraplan` is: **teleport the workspace to a remote Claude,
spin it up in plan mode, wait until it produces an approved plan,
bring the plan back.** It's a *one-shot remote planner* using the
same infrastructure as remote teammates.

### How they fit together

```
                     ┌─ moreright (internal middleware)
                     │
   leader REPL  ─────┼─ swarm (in-process / iTerm / Tmux teammates)
                     │     │
                     │     └─ leaderPermissionBridge ──┐
                     │                                  │
                     ├─ teleport (git-bundle, env pick) │
                     │     │                            │
                     │     └─ ultraplan (plan-mode poll) │
                     │                                  │
                     └─ tasks/InProcessTeammateTask     │
                       tasks/RemoteAgentTask  ◄─────────┘
```

`tasks/RemoteAgentTask/` is the *task type*; `utils/teleport/`
is the *transport*; `utils/swarm/` is the *runtime*; `bridge/`
and `remote/` are the *wire*. Four named layers, all already
in-tree.

## Group 2 — Extension distribution

Two surfaces handle "things that come from outside the binary."

### `utils/dxt/` — Desktop Extension manifest handling

Anthropic ships an MCP bundle format called **DXT** (Desktop
Extension) / `.mcpb`. This subsystem validates and unpacks them:

- **`helpers.ts`** — `validateManifest(manifestJson)` lazy-imports
  `@anthropic-ai/mcpb` because that package uses Zod v3, which
  eagerly creates ~24 `.bind(this)` closures per schema instance
  across ~300 instances — about 700 KB of bound closures kept off
  the startup heap for sessions that never touch a `.dxt`/`.mcpb`.
  This is the same "lazy-load to protect startup" instinct that
  shows up all over `main.tsx`.
- **`zip.ts`** — Safe zip extraction with hard limits:
  - 512 MB per file
  - 1024 MB total uncompressed
  - 100,000 file count cap
  - Path traversal check via `containsPathTraversal` — refuses
    absolute paths and `..` escapes.

Both files are model defenses against malicious extension bundles,
not feature surfaces.

### `commands/thinkback/` + `commands/thinkback-play/`

`thinkback` is an **animation skill installed via the plugin
marketplace**. The command:

1. Resolves the right marketplace name (`claude-code-marketplace`
   for `USER_TYPE=ant`, `OFFICIAL_MARKETPLACE_NAME` otherwise).
2. Builds a plugin id: `thinkback@<marketplace>`.
3. Checks installed plugins via `loadInstalledPluginsV2` and
   either installs the skill from the marketplace or plays its
   animation directly via `playAnimation` (exported from
   `commands/thinkback/thinkback.tsx`).

Why interesting: `thinkback` is **a first-party command that
secretly delegates to the plugin system**. It's the cleanest live
example of the "moved-to-plugin" lifecycle that
`createMovedToPluginCommand.ts` exists to support. It tells us
plugins are real, marketplace-backed, and ant builds use a
separate marketplace name.

## Group 3 — Business / compliance surfaces

These two are not multi-agent or extension; they are product
surfaces that exist for legal / commercial reasons.

### `commands/passes/` + `components/Passes/`

The **guest passes / referral program**. Tracks per-account
"remaining passes" via `services/api/referral.ts`. State lives in
global config:

- `config.hasVisitedPasses` — gate for the upsell.
- `config.passesLastSeenRemaining` — last known remaining count.

Analytics event on first visit: `tengu_guest_passes_visited`.
Component: `components/Passes/Passes.tsx`.

### `components/grove/Grove.tsx` — terms-of-service consent

"Grove" is the codename for the **policy update / new-terms
acceptance flow**. Reads from `services/api/grove.ts`:
`getGroveSettings`, `getGroveNoticeConfig`, `markGroveNoticeViewed`,
`updateGroveSettings`, `calculateShouldShowGrove`, plus
`AccountSettings` and `GroveConfig` types.

Has hard-coded ASCII art ("NEW TERMS" envelope) and a grace-period
copy block referencing **October 8 2025** as the consumer terms
effective date. The decision type is:

```ts
type GroveDecision =
  | 'accept_opt_in'
  | 'accept_opt_out'
  | 'defer'
  | 'escape'
  | 'skip_rendering'
```

Three render locations: `'settings' | 'policy_update_modal' |
'onboarding'`. So Grove is a **single component reused in three
places** that owns the consent UX for the policy change.

Worth flagging for substrate work because: if hulk ever
distributes a Claude Code persona that talks to anthropic.com on
behalf of an operator, the Grove consent surface is what governs
that — it's not a static EULA.

## Group 4 — Internal middleware

### `moreright/useMoreRight.tsx`

The file in this tree is a **stub for external builds**. Its own
header comment:

> Stub for external builds — the real hook is internal only.
>
> Self-contained: no relative imports. Typecheck sees this file at
> scripts/external-stubs/src/moreright/ before overlay, where
> ../types/ would resolve to scripts/external-stubs/src/types/
> (doesn't exist).

The hook signature is the actual contract:

```ts
useMoreRight(_args: {
  enabled: boolean
  setMessages: (action) => void
  inputValue: string
  setInputValue: (s) => void
  setToolJSX: (args) => void
}): {
  onBeforeQuery: (input: string, all, n: number) => Promise<boolean>
  onTurnComplete: (all, aborted: boolean) => Promise<void>
  render: () => null
}
```

Three hooks per turn — **before query**, **after turn**, plus
a **render slot**. Plus the ability to mutate `inputValue` and
`setToolJSX`. So the real `moreright` is a **per-turn middleware
that can preempt queries, react to turn completion, and inject
arbitrary tool JSX into the render**. It is the most powerful
extension seam in the entire codebase, and externally it does
nothing.

Two implications:

1. **There is internal Claude Code functionality not in this tree.**
   The "external build" framing is explicit. We do not have the
   real `moreright`. It is plausibly where ant-only experiments
   (the "more on the right" sidebar?) live.
2. **The seam itself is informative even without the
   implementation.** The shape tells us how the REPL accepts
   middleware: pre/post/render, with full message-array access. If
   hulk wants its own middleware layer, this is the contract to
   copy.

## What this means for hulk

Three concrete takeaways:

### 1. The persona-hosting story is mostly built

The carrier-vs-persona insight at
`harnesses/hulk/memory/.docc/insights/founding-breach-2026-04-05.md`
treats hosting multiple agent personas as an architectural goal.
The runtime to do that **already exists** in this tree under
`utils/swarm/`. What's missing is not the runtime but the
persona-bundle layer:

- Each swarm teammate currently uses the same Claude Code agent.
- Making teammates *different personas* (claude, claw, codex,
  carrie) means making `teammateModel` + `teammatePromptAddendum`
  + the system prompt build path persona-aware.
- The leader-permission bridge already centralizes consent across
  teammates, which is exactly what a multi-persona carrier needs.
- Backends (`InProcessBackend` / `ITermBackend` / `TmuxBackend`)
  already abstract the "where does this persona render" question.

This is *much* less work than the founding-breach insight implies.
The hard parts (cross-process comms, leader permission UX, pane
layout, idle notification) are done.

### 2. The remote story has three named environments and a beta tag

`EnvironmentKind = 'anthropic_cloud' | 'byoc' | 'bridge'` plus
`CCR_BYOC_BETA = 'ccr-byoc-2025-07-29'`. If hulk ever wants to
distribute personas across machines, the choice is one of these
three — and "BYOC" means *the user's own cloud*, not Anthropic's.
That matters for substrate-level decisions about where memory and
identity bundles live when a session crosses a machine boundary.

### 3. Plan-mode round trips are a real pattern, not a one-off

`/ultraplan` proves the pattern is supported end-to-end:
**teleport → set permission mode → poll for tool result → return
artifact**. Anything hulk wants to do that looks like "send a
narrowly-scoped subtask to a remote Claude and wait for a
structured artifact" is a copy of this exact shape, with a
different tool than `ExitPlanMode`.

## Open questions (now narrower)

- **What's in the real `moreright`?** Worth asking the
  operator — this is internal-only, so the answer isn't in the tree.
- **How does `utils/teammateMailbox.ts` actually serialize
  messages?** Sibling file, not yet read.
- **Where does `services/api/grove.ts` fetch the policy config
  from?** That endpoint is probably in `services/api/`.
- **Is `passes` still active in the product?** Or is it a legacy
  surface kept for users who already had passes? The `tengu_`
  analytics prefix suggests this is old.
- **How does `utils/swarm/teammateMailbox` interact with
  `services/SessionMemory/` for handing memories *between*
  teammates?** Critical for the persona-bundle question.
