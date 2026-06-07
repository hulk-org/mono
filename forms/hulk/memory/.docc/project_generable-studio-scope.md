---
name: Tachikoma scope decision
description: Tachikoma by wrkstrm (was Generable Studio) scopes to ALL agentic surfaces in the substrate; federated inventories per surface; agent self-reflective tool workbench feeding into Architect canvas
type: project
---

Tachikoma by wrkstrm (slug tachikoma-by-wrkstrm, bundle me.rismay.tachikoma, team BM6B69ZQSR) is the native macOS agent workbench for browsing, testing, evaluating, and promoting the substrate's full agentic surface. Named after Ghost in the Shell's think-tanks — AI units that introspect and refine their own capabilities. Tachikoma is the maintenance bay; Architect by wrkstrm is the mission (visual canvas where operator + agent draw running applications from the catalogued primitives).

**Why:** Scope decision on 2026-04-09 — "all agentic tools + cli + lib targets we might be able to turn agentic", not just FoundationModels Tools. The narrow scope (41 FM tools only) covered ~20% of the real agentic surface (~175-200 total endpoints).

**How to apply:** The manifest architecture is **federated** (Option C from the design session): one inventory JSON per runtime surface, each owned by its collective. Generable Studio loads and composes all of them into a unified sidebar. Surfaces identified so far:

1. `foundation-models-inventory.json` — FoundationModels.Tool conformers (~41). Owned by clia-cli resources. Schema already built + tested in `wrkstrm-performance/tool-eval-core/ToolEvalManifestKit`.
2. `claude-skills-inventory.json` — Claude Code skills (~32). Owned by the hulk/claude harness home.
3. `codex-commands-inventory.json` — Codex `$` commands (~10). Owned by the Codex harness home.
4. `mcp-servers-inventory.json` — MCP servers (~2+). Owned by MCP config surface.
5. `shell-cli-inventory.json` — swift-*-cli executables not wrapped as FM tools (~45). Owned by clia-cli or wrkstrm-core.
6. `sub-agents-inventory.json` — sub-agent types (general-purpose, Explore, Plan, etc.). Owned by the Claude Code harness.
7. `paperclip-adapters-inventory.json` — Paperclip agent adapters. Owned by paperclip.
8. `agent-personas-inventory.json` — substrate agent personas (~10). Owned by `substrate/agents/`.
9. `hooks-inventory.json` — configured hooks. Owned by settings.json / .claude/.

Each inventory re-uses the seven-state `InventoryStatus` enum (tool/candidate/deferred/rejected/data-only/cli-only/orchestrator) with surface-specific required fields (the FM inventory requires `@Generable` schemas; the skill inventory requires trigger conditions and host harness; the CLI inventory requires subcommand list, etc.).

**Key deliverables already built:**
- `wrkstrm-performance/tool-eval-core/` — `ToolEvalManifestKit` (14 tests green, Codable round-trip verified)
- `wrkstrm-app/.../generable-studio-by-wrkstrm/` — Phase 1 app with ModernSharedAppShell + WrkstrmMeshGradientHeader + WrkstrmTreeExplorerSwiftUI + 42-entry bundled FM fixture
- GenUICore adapter read-out: provider surface is extensible via `CommonAIService` protocol, tool-call gap exists (phased plan: app-local in v0.1, promoted to GenUICore in v0.2)

**Key component discoveries:**
- `WrkstrmTreeExplorerMacOS` is a 4-line placeholder stub; use `WrkstrmTreeExplorerSwiftUI` (catalyst/shared) instead
- `MarkdownPreviewKit` has heavy transitive deps and confusing excludes; use SwiftUI-native `AttributedString(markdown:)` for Phase 1
- `wrkstrm-generable-form` is the one component that needs writing new (dynamic SwiftUI form from GenerableSchema)
