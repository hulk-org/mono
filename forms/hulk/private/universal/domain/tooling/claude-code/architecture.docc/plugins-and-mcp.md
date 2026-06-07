@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# plugins-and-mcp

Plugins and MCP servers are two **extension surfaces**. They're
similar enough to be confused but architecturally distinct.

## `src/plugins/`

- **`builtinPlugins.ts`** — Static list of plugins shipped in the
  bundle.
- **`bundled/`** — Bundled plugin sources.

Plus `services/plugins/` (lifecycle service) and `utils/plugins/`
(helpers). The `commands/plugin/` and `commands/reload-plugins/`
slash commands are how users interact with the surface.

`commands/createMovedToPluginCommand.ts` exists because **slash
commands migrate out of `commands/` into the plugin system over
time**. A "moved to plugin" stub is left behind so user muscle
memory still finds the command.

## `src/services/mcp/`

The MCP (Model Context Protocol) client + server registry. Backs
four tools in `tools/`:

- `MCPTool/` — General MCP tool invocation.
- `McpAuthTool/` — MCP authentication.
- `ListMcpResourcesTool/` — Enumerate MCP resources.
- `ReadMcpResourceTool/` — Read a specific MCP resource.

Plus:

- `services/mcpServerApproval.tsx` — UI for approving an MCP server
  on first use.
- `components/mcp/` — UI components for MCP state.
- `commands/mcp/` — Slash command for MCP management.
- `entrypoints/mcp.ts` — MCP entrypoint from outside the REPL.
- `utils/mcp/` — Helpers.
- `skills/mcpSkillBuilders.ts` — Promote an MCP server into a skill.

## Plugins vs. MCP servers

The two are **not the same**:

| Axis | Plugins | MCP servers |
| --- | --- | --- |
| **What they ship** | Slash commands, sub-tools, UI components | Tools, resources, prompts |
| **Distribution** | Bundled into the binary or loaded by name | External processes / servers |
| **Lifecycle** | Loaded at startup | Connected on demand |
| **Approval** | Trust at install time | Per-server approval dialog |
| **Migration** | Commands move *into* plugins from `commands/` | MCP servers can be *promoted* into skills |

## Cross-cutting

- **Both have an "approval" model.** Plugins implicitly via install,
  MCP via the per-server dialog. Buddy's `feature('BUDDY')` gate is
  a third style — compile-time, no UI consent.
- **Both have a slash command surface.** `/plugin` for plugins,
  `/mcp` for MCP. Both are how the operator inspects state.
- **Skills bridge the two.** `mcpSkillBuilders.ts` converts an MCP
  server into something callable as a skill, which is the path that
  lets MCP-only capabilities show up in the same surface as bundled
  skills.

## Open questions

- The complete plugin contract — what does a plugin export? Almost
  certainly defined in `types/plugin.ts`, not yet read.
- Whether plugins can ship UI (`.tsx`) or are command/tool-only.
- The relationship between `services/plugins/` and
  `services/remoteManagedSettings/` — do MDM-managed environments
  pin plugin lists?
- Where the MCP wire protocol implementation lives — likely in the
  `@modelcontextprotocol/sdk` import seen in `Tool.ts`, not in this
  tree.
