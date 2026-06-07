@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# tools

The `tools/` cluster contains every concrete `Tool` implementation
exposed to the model. The shared interface lives in `Tool.ts` at
`src/` root and the registry that composes them is `tools.ts`, also
at root.

## Registry shape

`tools.ts` is a **static composition file**, not a dynamic loader:

- Imports each tool by name from its directory.
- Wraps a few in `feature('FLAG')` / `require()` branches so dead
  code is eliminated for non-ant builds.
- Exports a single ordered `Tools` array consumed by `QueryEngine`.

Adding a tool means: create `tools/<Name>Tool/` with the standard
files, register it in `tools.ts`, and (if it's flagged) wire the
feature gate. There is no auto-discovery.

## Concrete tools (37)

Filesystem + editing:
- `FileReadTool/`, `FileWriteTool/`, `FileEditTool/`,
  `NotebookEditTool/`, `GlobTool/`, `GrepTool/`, `LSPTool/`.

Shell + execution:
- `BashTool/`, `PowerShellTool/`, `REPLTool/`, `SleepTool/`.

Web + remote:
- `WebFetchTool/`, `WebSearchTool/`, `RemoteTriggerTool/`,
  `ScheduleCronTool/`, `SendMessageTool/`.

Agents + tasks:
- `AgentTool/`, `TaskCreateTool/`, `TaskGetTool/`, `TaskListTool/`,
  `TaskOutputTool/`, `TaskStopTool/`, `TaskUpdateTool/`,
  `TeamCreateTool/`, `TeamDeleteTool/`.

Skills + planning:
- `SkillTool/`, `BriefTool/`, `EnterPlanModeTool/`,
  `ExitPlanModeTool/`, `EnterWorktreeTool/`, `ExitWorktreeTool/`,
  `TodoWriteTool/`, `ToolSearchTool/`.

MCP integration:
- `MCPTool/`, `McpAuthTool/`, `ListMcpResourcesTool/`,
  `ReadMcpResourceTool/`.

User interaction + meta:
- `AskUserQuestionTool/`, `ConfigTool/`, `SyntheticOutputTool/`.

Plus `shared/` (cross-tool helpers), `testing/` (test fixtures),
and `utils.ts` (registry-wide utility).

## Tool interface (`src/Tool.ts`)

Imports `ToolResultBlockParam`, `ToolUseBlockParam` from the
`@anthropic-ai/sdk`, plus `ElicitRequestURLParams` / `ElicitResult`
from MCP, and exports `ToolInputJSONSchema`. Each tool defines
input schema, render component, permission check, and execute
function. Permission flows through `hooks/useCanUseTool`.

## Cross-cutting

- **MCP tools are first-class.** Four tools (`MCPTool`, `McpAuthTool`,
  `ListMcpResourcesTool`, `ReadMcpResourceTool`) are dedicated to
  MCP server interaction. The MCP service layer lives in
  `services/mcp/`.
- **Task tools split into create/get/list/output/stop/update.** This
  is a complete CRUD seam; the actual task implementations live in
  `tasks/` (see <doc:tasks>).
- **`SyntheticOutputTool`** — exists for tests / replay; not a
  user-visible tool.

## Open questions

- Which tools are ant-only? The `feature()` gates in `tools.ts`
  haven't been enumerated yet.
- Permission model for `RemoteTriggerTool` and `ScheduleCronTool` —
  they cross device boundaries.
- Where the OpenAI-side adapter lives (if any) — `openclaw`?
