@Metadata {
  @TechnologyRoot
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Claude Code Architecture")
}

# Claude Code Architecture (in-tree TypeScript)

Architectural map of the upstream Claude Code TypeScript snapshot
checked into the hulk harness at
`private/universal/substrate/harnesses/hulk/private/universal/domain/tooling/claude-code/`.

This bundle is **draft**. It is the first time the substrate has had
an in-tree architecture document for this tree, and the goal is to
make every top-level subsystem under `src/` discoverable, with enough
detail per cluster that future investigations can start from a known
shape instead of re-scanning the directory.

The companion Quipsnip → buddy investigation that triggered this
work lives at
[The Buddy Feature (2026-04-09)](../../../../../../hulk.investigations.docc/buddy-feature-2026-04-09.md)
and
[Buddy vs. S-Type (2026-04-09)](../../../../../../hulk.investigations.docc/buddy-vs-s-type-2026-04-09.md).
Read those first if you want context on why this bundle exists.

## Source location

```
private/universal/substrate/harnesses/hulk/
  private/universal/domain/tooling/claude-code/
    README.md
    src/
      <subsystems below>
```

The Python claw-code mirror under
`collectives/ultraworkers/private/claw-code/src/` is a **port-audit
surface**, not the implementation. It carries
`reference_data/subsystems/<name>.json` snapshots that point at this
tree but contain placeholder packages for the not-yet-ported pieces.

## Top-level shape

`src/` mixes **entrypoint files** with **subsystem directories**.
The entrypoint files at `src/` root act as the public seam between
the larger clusters; everything inside a subsystem directory should
be reachable from one of these:

| Root file | Role |
| --- | --- |
| `main.tsx` | Process entry. Side-effect-ordered: profile checkpoint → MDM raw read → keychain prefetch → settings → React/Ink boot. |
| `setup.ts` | Non-interactive bootstrap: cwd, sinks, release notes, analytics. |
| `replLauncher.tsx` | Interactive REPL boot. |
| `dialogLaunchers.tsx` | Top-level modal launchers for the REPL. |
| `interactiveHelpers.tsx` | REPL helpers shared between dialogs. |
| `QueryEngine.ts` | Session loop driver. Owns the SDK message stream and the tool/permission cycle. |
| `query.ts` | Lower-level model query: tools, autocompact, retry/fallback. |
| `Tool.ts` | The `Tool` interface (input schema, render, permission, execute). |
| `tools.ts` | Static tool registry — composes every tool in `tools/`. |
| `Task.ts` | The `Task` interface + `TaskType` discriminant. |
| `tasks.ts` | Task registry — composes every task in `tasks/`. |
| `commands.ts` | Slash-command registry — composes every command in `commands/`. |
| `context.ts` | Context assembly: CLAUDE.md / memory file resolution, env state. |
| `history.ts` | On-disk history append/read with lockfile + paste store. |
| `cost-tracker.ts` / `costHook.ts` | Session cost accounting + hook. |
| `ink.ts` | Re-export shim over the local Ink fork at `src/ink/`. |
| `projectOnboardingState.ts` | First-time project state machine. |

## Subsystem map

Articles below cover the architecturally heaviest clusters in
detail. The remaining subsystems are listed inline here so the index
stays the single complete map.

### Covered in their own articles

- <doc:bridge> — REPL ↔ remote-control bridge, capacity wake, polling, JWT, transports.
- <doc:tools> — All ~37 tool implementations and the shared registry.
- <doc:tasks> — Task abstraction and the five concrete task types (Dream, LocalAgent, LocalShell, RemoteAgent, InProcessTeammate).
- <doc:query-engine> — `QueryEngine.ts` + `query.ts` + the autocompact / fallback / token-budget services.
- <doc:services> — The big `services/` cluster (analytics, mcp, oauth, sessionmemory, settings sync, …).
- <doc:commands> — The slash-command tree (~90 commands).
- <doc:components-and-ink> — React/Ink UI surface and the in-tree Ink fork.
- <doc:state-and-bootstrap> — `AppState`, store, bootstrap state, profile init.
- <doc:memory-and-skills> — `memdir/`, `skills/`, `services/SessionMemory/`, `services/extractMemories/`.
- <doc:plugins-and-mcp> — `plugins/`, `services/mcp/`, `services/plugins/`.
- <doc:native-ts> — Embedded native ports (`color-diff`, `file-index`, `yoga-layout`).
- <doc:buddy> — The companion subsystem (links to the existing investigations).
- <doc:mystery-surfaces> — Resolves the mystery surfaces into four groups: multi-agent runtime (`swarm` + `teleport` + `ultraplan`), extension distribution (`dxt` + `thinkback`), business surfaces (`passes` + `grove`), and internal middleware (`moreright`).
- <doc:swarm-vs-tachikoma> — **Paradigm comparison.** Places the entire swarm runtime against the Tachikoma organism ontology and execution model. Swarm = lateral scaling of chat agents. Tachikoma = structured work-graph execution by bounded autonomous units under Ghost direction, in isolated worlds, with no memory drift. Covers the projection pipeline (compiler analogy: Ghost=front-end, work graph=IR, Tachikoma=passes), the worker contract (`clia-worker --spec --root --out`), the cognition bridge, the anatomy system (Ant/Hound/Fox/Spider/Owl species), the execution-world ladder (temp dir → Apple Containerization → Firecracker → smolBSD/Unikraft), and the founding-breach insight reframed through the ontology. Concludes: swarm is the legacy chat-agent multiplexer; Tachikoma is the target for structured work.
- <doc:secret-surfaces> — **Deep read.** Full code-level read of the multi-agent runtime: identity resolution (2-layer AsyncLocalStorage + CLI args), file-based mailbox (lockfile, inbox JSON, idle notification), teammate init (team-wide permissions + Stop hook), leader permission bridge (single React consent surface for all teammates), backend registry (tmux/iTerm2/in-process detection + fallback), `TeammateSpawnConfig` type surface (systemPromptMode is the persona-injection seam), in-process runner (`runAgent` under isolated `AsyncLocalStorage`), git-bundle teleport (stash → bundle → upload → seed), ultraplan polling (3s, 5-failure cap). Concludes with the **five specific files** that need edits for persona-aware swarm, and the one new piece of code (persona-bundle loader).

### Inline subsystem inventory

Subsystems not yet promoted to their own article. Each entry names
the directory, top-level file count, and the role inferred from file
names + a quick read of the most prominent file.

- **`assistant/`** (1 file) — `sessionHistory.ts`. Assistant-side
  session history accessor. Thin shim that the `services/` layer
  reads through.

- **`bootstrap/`** (1 file) — `state.ts`. Holds session-scoped state
  set very early in `main.tsx`: project root, session id,
  persistence-disabled flag, additional CLAUDE.md dirs, cached
  CLAUDE.md content. Imported by `QueryEngine`, `history`, `context`.

- **`buddy/`** (6 files) — see <doc:buddy>.

- **`cli/`** (handlers/, transports/, exit.ts, ndjsonSafeStringify.ts,
  print.ts, remoteIO.ts, structuredIO.ts, update.ts) — Non-REPL CLI
  surface: print mode, structured/NDJSON IO, transports, in-process
  update flow, exit handling.

- **`constants/`** (~22 files) — Frozen tables: api/tool limits,
  betas, error ids, figures, file paths, github-app config, oauth,
  output styles, product strings, prompts (model-facing), spinner
  verbs, system prompt sections, tool registry strings, xml tags.

- **`context/`** (8 React contexts) — fps metrics, mailbox, modal,
  notifications, overlays, prompt overlay, queued message, stats,
  voice. The notification context is what `useBuddyNotification`
  pushes the rainbow `/buddy` teaser through.

- **`coordinator/`** (1 file) — `coordinatorMode.ts`. Mode flag for
  the coordinator agent (the "supervisor of supervisors" surface).

- **`entrypoints/`** — Public entrypoints other than `main.tsx`:
  `cli.tsx`, `init.ts`, `mcp.ts`, plus `agentSdkTypes.ts`,
  `sandboxTypes.ts`, and the `sdk/` subdirectory which is the
  Agent SDK surface consumers import.

- **`hooks/`** (~85 files + `notifs/`, `toolPermission/`) — React
  hooks layer. Owns most of the REPL's stateful behavior: keybindings,
  command queue, file/diff suggestions, tool permission UX, autoupdater,
  copy-on-select, away summary, idle/blink, paste/clipboard hints, etc.
  Treat this as the *behavior* layer parallel to `components/`'s
  *render* layer.

- **`keybindings/`** (14 files) — Key parser, schema, validator,
  resolver, default bindings, user binding loader, React context,
  shortcut display, template substitution. Self-contained.

- **`memdir/`** (7 files) — Memory directory abstraction:
  `findRelevantMemories`, `memdir`, `memoryAge`, `memoryScan`,
  `memoryTypes`, `paths`, `teamMemPaths`, `teamMemPrompts`. See
  <doc:memory-and-skills>.

- **`migrations/`** (~11 files) — Settings/config migrations between
  releases: auto-updates flag, bypass-permissions accepted, MCP
  enable-all-project, model lineage migrations
  (Fennec→Opus, legacy Opus→current, Opus→Opus1m,
  Sonnet1m→Sonnet45, Sonnet45→Sonnet46), repl-bridge enabled →
  remote-control-at-startup, and a couple of "reset" migrations
  for opt-in offers and pro→opus default.

- **`moreright/`** (1 file) — `useMoreRight.tsx`. Single hook,
  unclear from name; probably a UI affordance for "more on the
  right" / sidebar reveal. Worth a closer read.

- **`native-ts/`** — `color-diff/`, `file-index/`, `yoga-layout/`.
  In-tree TS ports of native modules. See <doc:native-ts>.

- **`outputStyles/`** (1 file) — `loadOutputStylesDir.ts`. Loader for
  named output style presets.

- **`plugins/`** — `builtinPlugins.ts` + `bundled/`. See
  <doc:plugins-and-mcp>.

- **`query/`** (4 files) — Support for `query.ts` at the root level:
  `config.ts`, `deps.ts`, `stopHooks.ts`, `tokenBudget.ts`. Read in
  the <doc:query-engine> article.

- **`remote/`** (4 files) — Remote permission bridge, remote session
  manager, SDK message adapter, sessions websocket. Pairs with
  `bridge/` — bridge runs *here* on the device, `remote/` is what
  the web/desktop sees.

- **`schemas/`** (1 file) — `hooks.ts`. Zod schemas for hook
  definitions.

- **`screens/`** (3 files) — Top-level Ink screens:
  `Doctor.tsx` (the `/doctor` surface), `REPL.tsx` (the main
  interactive screen), `ResumeConversation.tsx`.

- **`server/`** (3 files) — `createDirectConnectSession.ts`,
  `directConnectManager.ts`, `types.ts`. Direct-connect session
  surface — the localhost-API server side of remote control.

- **`skills/`** (4 files + `bundled/`) — See <doc:memory-and-skills>.

- **`state/`** (6 files) — `AppState.tsx`, `AppStateStore.ts`,
  `onChangeAppState.ts`, `selectors.ts`, `store.ts`,
  `teammateViewHelpers.ts`. The reactive app state container that
  components subscribe to. Distinct from `bootstrap/state.ts`,
  which holds *immutable*-after-boot session info.

- **`tasks/`** — See <doc:tasks>.

- **`tools/`** — See <doc:tools>.

- **`types/`** — Pure type modules: `command.ts`, `hooks.ts`,
  `ids.ts` (typed UUID newtypes — `AgentId`, etc.), `logs.ts`,
  `permissions.ts`, `plugin.ts`, `textInputTypes.ts`, plus a
  `generated/` subdir for code-generated types.

- **`upstreamproxy/`** (2 files) — `relay.ts`, `upstreamproxy.ts`.
  Local relay used to talk to the upstream API in restricted
  environments.

- **`utils/`** (~329 files across many subdirs) — The grab-bag.
  Notable subdirs by name: `background/`, `bash/`, `claudeInChrome/`,
  `computerUse/`, `deepLink/`, `dxt/`, `filePersistence/`, `git/`,
  `github/`, `hooks/`, `mcp/`, `memory/`, `messages/`, `model/`,
  `nativeInstaller/`, `permissions/`, `plugins/`, `powershell/`,
  `processUserInput/`, `sandbox/`, `secureStorage/`, `settings/`,
  `shell/`, `skills/`, `suggestions/`, `swarm/`, `task/`,
  `telemetry/`, `teleport/`, `todo/`, `ultraplan/`. This is where
  most "small reusable things" live; documenting it exhaustively is
  out of scope for v0.1 of this bundle.

- **`vim/`** (5 files) — Vim-mode emulator for the prompt input:
  motions, operators, text objects, transitions, types. Self-contained.

- **`voice/`** (1 file) — `voiceModeEnabled.ts`. Tiny gate; the
  actual voice input pipeline lives in the `voice` React context
  and (likely) a service.

## Cross-cutting observations

A few patterns repeat across the tree and are worth naming up front
so each subsystem article doesn't have to re-explain them:

1. **`feature('FLAG')` from `bun:bundle`.** Conditional features are
   compile-time flags resolved at bundle time, not runtime config.
   `BUDDY`, `WORKFLOW_SCRIPTS`, `MONITOR_TOOL`, `REACTIVE_COMPACT`,
   etc. Dead code is eliminated; the unflagged path is what ships.
2. **`bootstrap/state.ts` is the early-immutable layer.** Read after
   `main.tsx` writes it; never written again. Anything that needs
   to change later belongs in `state/AppState`.
3. **Registries are static composition files at `src/` root.**
   `tools.ts`, `tasks.ts`, `commands.ts` are not dynamic loaders —
   they import every concrete implementation by name. Adding a new
   tool/task/command means editing the registry and the
   `feature()`-gated branch if applicable.
4. **The "shared" subdirectory pattern.** `tools/shared/`,
   `components/*/shared/` — when you see it, expect plain functions
   reused across siblings, not a base class.
5. **Two "state" surfaces.** `bootstrap/state.ts` (immutable session
   facts) and `state/AppState.tsx` (reactive UI state). Don't
   conflate them.
6. **`utils/` is not the bottom of the stack.** Many `utils/`
   modules import from `services/` and `bootstrap/`. Treat `utils/`
   as "well-known helpers" rather than "leaf dependencies."
7. **`ink/` is a fork.** `src/ink/` is a vendored Ink build with
   local layout, optimizer, and reconciler. `ink.ts` at root is a
   thin re-export shim. See <doc:components-and-ink>.

## Open questions

- **What's the actual provenance of this snapshot?** It is a full
  Claude Code TS source tree under hulk; we should pin its upstream
  commit / version somewhere checked-in. The README at
  `claude-code/README.md` is one line; not enough.
- **What is `moreright/`?** Resolved in <doc:mystery-surfaces> —
  it is an external-build stub for an internal-only per-turn
  middleware hook (`onBeforeQuery` / `onTurnComplete` / `render`).
  The real implementation is not in this tree.
- **Where does the `voice/` pipeline actually live?** Only one file
  in this directory; the React context is the visible surface.
- **What's the contract for `coordinator/`?** Single mode-flag file.
  The interesting code is in `services/` and `tasks/` siblings —
  see also `utils/swarm/` covered in <doc:mystery-surfaces>.
- **`utils/swarm/`, `utils/ultraplan/`, `utils/teleport/`,
  `utils/dxt/`** — Resolved in <doc:mystery-surfaces>. Multi-agent
  runtime + remote-workspace + plan-mode round trip + DXT bundle
  handling.
- **Why are some root files capitalized (`Tool.ts`, `Task.ts`,
  `QueryEngine.ts`) and others not?** Capitalized ones export a
  central type or class; non-capitalized ones are registries or
  loose helpers. This is convention, not enforced.

## Status

Draft v0.1. Index is complete; per-cluster articles below are
**stubbed** with their inventory and the questions worth chasing,
not finished prose. Each one should be promoted to a full read
when the relevant work touches it. Do not treat the linked
articles as authoritative until they have their own dated
review note.
