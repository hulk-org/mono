@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# services

The `services/` cluster is where stateful, longer-lived subsystems
live. Roughly: anything that owns a connection, a cache, a sync
loop, or a third-party integration ends up here. ~36 top-level
entries.

## Inventory

### Subsystems with their own directory

- **`AgentSummary/`** — Per-agent summarization service.
- **`analytics/`** — Event logging (`logEvent`,
  `AnalyticsMetadata_I_VERIFIED_THIS_IS_NOT_CODE_OR_FILEPATHS` —
  the type name is a built-in safety reminder).
- **`api/`** — API client, retry, fallback (`withRetry.ts`).
- **`autoDream/`** — Background "dream" processing; pairs with
  `tasks/DreamTask/`.
- **`compact/`** — Conversation compaction. Two entrypoints:
  `autoCompact.ts` (threshold + warning state) and `compact.ts`
  (post-compact message builder).
- **`extractMemories/`** — Memory extraction from session content.
- **`lsp/`** — Language Server Protocol integration. Backs `LSPTool`.
- **`MagicDocs/`** — Documentation magic surface (likely the
  `/brief` / `BriefTool` backing).
- **`mcp/`** — MCP client + server registry. Backs four MCP tools.
- **`oauth/`** — OAuth flows (Anthropic console, GitHub, etc.).
- **`plugins/`** — Plugin loader / lifecycle.
- **`policyLimits/`** — Policy-based limit enforcement.
- **`PromptSuggestion/`** — Suggestion engine for the prompt input.
- **`remoteManagedSettings/`** — MDM-style remote settings.
- **`SessionMemory/`** — Per-session memory store.
- **`settingsSync/`** — Settings sync across devices.
- **`teamMemorySync/`** — Team-wide memory sync.
- **`tips/`** — In-product tip system.
- **`tools/`** — Service-side tool support (not the tool registry).
- **`toolUseSummary/`** — Aggregated tool-use stats.

### Single-file services

- `awaySummary.ts` — End-of-session summary.
- `claudeAiLimits.ts` + `claudeAiLimitsHook.ts` — claude.ai limit
  state + React hook.
- `diagnosticTracking.ts` — Diagnostic event tracking.
- `internalLogging.ts` — Internal-only logging path.
- `mcpServerApproval.tsx` — UI for approving an MCP server (one of
  the few `.tsx` files in `services/`).
- `mockRateLimits.ts` + `rateLimitMessages.ts` + `rateLimitMocking.ts`
  — Rate limit modeling and the messages users see.
- `notifier.ts` — Cross-process notifier (OS notifications).
- `preventSleep.ts` — Inhibit system sleep during long jobs.
- `tokenEstimation.ts` — Pre-send token count estimate.
- `vcr.ts` — Record/replay (the API layer's "video tape recorder").
- `voice.ts` + `voiceKeyterms.ts` + `voiceStreamSTT.ts` — Voice
  input pipeline (streaming STT). The `voice/` directory at `src/`
  root only holds the enable gate; the actual logic is here.

## Cross-cutting

- **Compact has two layers.** `services/compact/autoCompact.ts`
  decides *when*; `services/compact/compact.ts` decides *what
  messages survive*.
- **Memory has three services.** `extractMemories/` writes,
  `SessionMemory/` stores, `teamMemorySync/` syncs. Memdir
  (`src/memdir/`) is the on-disk layout shared by all three.
- **Voice is mostly here, not under `voice/`.** Three files
  (`voice.ts`, `voiceKeyterms.ts`, `voiceStreamSTT.ts`) carry the
  pipeline.
- **`vcr.ts` is interesting.** Implies recorded sessions can be
  replayed against the API layer for tests. Worth a follow-up.

## Open questions

- Whether `services/AgentSummary/` is the same surface as
  `services/toolUseSummary/` or a separate concept.
- Whether `MagicDocs/` is shipped or experimental.
- The contract between `policyLimits/` and `claudeAiLimits.ts`.
- Where the compaction *prompt* lives (the model-facing instruction
  to summarize) — `constants/prompts.ts` is the likely place but
  unconfirmed.
