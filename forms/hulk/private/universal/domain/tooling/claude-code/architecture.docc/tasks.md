@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# tasks

The `tasks/` cluster contains the concrete `Task` implementations.
The interface and discriminant live in `Task.ts` at `src/` root;
the registry is `tasks.ts`, also at root.

## Task type discriminant (`src/Task.ts`)

```ts
type TaskType =
  | 'local_bash'
  | 'local_agent'
  | 'remote_agent'
  | 'in_process_teammate'
  | 'local_workflow'
  | 'monitor_mcp'
  | 'dream'
```

Plus a `TaskStatus` discriminant (not read in detail). Tasks have
typed UUIDs (`AgentId`) imported from `types/ids.ts` and on-disk
output paths via `utils/task/diskOutput.ts`.

## Concrete task directories

- **`DreamTask/`** — `'dream'`. Background "auto-dream" processing.
  Backed by `services/autoDream/`.
- **`InProcessTeammateTask/`** — `'in_process_teammate'`. A second
  agent persona running in the same process. The carrier-vs-persona
  story in operator memory points at this surface as the place
  hulk-style multi-persona hosting would land.
- **`LocalAgentTask/`** — `'local_agent'`. A subagent running
  locally via the `Agent` tool path.
- **`LocalShellTask/`** — `'local_bash'`. Shell-backed task.
- **`RemoteAgentTask/`** — `'remote_agent'`. Subagent running on a
  remote bridge.

Plus root-level files:

- `LocalMainSessionTask.ts` — the main session, modeled as a Task
  for uniformity.
- `pillLabel.ts` — UI helper for the task pill.
- `stopTask.ts` — uniform stop entrypoint.
- `types.ts` — task-level types.

## Registry shape (`src/tasks.ts`)

Imports each task by name. Two task types are loaded via
`feature()`-gated `require()`:

- `LocalWorkflowTask` behind `feature('WORKFLOW_SCRIPTS')`.
- `MonitorMcpTask` behind `feature('MONITOR_TOOL')`.

Both are `Task | null`. The non-feature build literally has these
slots as `null`, not as stubs. Treat absent task types as a build
choice, not a runtime state.

## Cross-cutting

- **Tasks have CRUD tools.** `TaskCreateTool`, `TaskGetTool`,
  `TaskListTool`, `TaskOutputTool`, `TaskStopTool`, `TaskUpdateTool`
  in `tools/` are how the model talks to this layer.
- **The main session is a task.** `LocalMainSessionTask` means the
  REPL's own loop is just one task among many — same lifecycle, same
  status discriminant.
- **Background tasks have a notification path.** Connects to
  `hooks/useBackgroundTaskNavigation.ts` and the notification
  context.

## Open questions

- The relationship between `tasks/InProcessTeammateTask/` and the
  `coordinator/` mode flag. Is in-process teammate the
  implementation that coordinator mode coordinates?
- Where the `'monitor_mcp'` task surfaces in the UI when its build
  flag is on.
- Whether `DreamTask` is the same surface as `services/autoDream/`
  or whether one drives the other.
