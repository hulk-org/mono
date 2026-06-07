@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# query-engine

The query engine is the **session loop driver** — the thing that
turns "user typed something" into a stream of model messages, tool
calls, permission checks, and compaction events. It is split across
two files at `src/` root plus a small `query/` support directory.

## Files

- **`QueryEngine.ts`** (root) — Owns the SDK message stream and the
  tool/permission cycle. Imports session id and persistence flags
  from `bootstrap/state.ts`. Imports SDK message types
  (`SDKMessage`, `SDKPermissionDenial`, `SDKStatus`,
  `SDKUserMessageReplay`, `SDKCompactBoundaryMessage`,
  `PermissionMode`) from the Anthropic SDK. Uses `feature()` for
  reactive-compact branching.

- **`query.ts`** (root) — Lower-level model query path. Handles
  tools wiring, autocompact, and retry/fallback. Imports
  `FallbackTriggeredError` from `services/api/withRetry.js`,
  `calculateTokenWarningState` and `isAutoCompactEnabled` from
  `services/compact/autoCompact.js`, and `buildPostCompactMessages`
  from `services/compact/compact.js`.

- **`query/config.ts`** — Query-level config knobs.
- **`query/deps.ts`** — Dependency injection seam for testing.
- **`query/stopHooks.ts`** — Stop-condition hooks (when to halt
  the loop).
- **`query/tokenBudget.ts`** — Token budget accounting.

## Loop shape (read from imports, not behavior)

1. `QueryEngine` reads session state from `bootstrap/state.ts`
   (immutable session id, persistence flag).
2. It owns an SDK message stream typed against
   `@anthropic-ai/sdk/resources/messages.mjs`.
3. Each turn calls into `query.ts`, which:
   - assembles the tools list (from `tools.ts`),
   - checks the autocompact threshold via
     `services/compact/autoCompact.ts`,
   - runs the model call with `services/api/withRetry.ts` (which
     can throw `FallbackTriggeredError`),
   - on a tool use, hands off to `Tool.execute` after a permission
     check via `hooks/useCanUseTool`,
   - on a compact boundary, builds post-compact messages via
     `services/compact/compact.ts`.
4. Stop conditions are gated by `query/stopHooks.ts`.
5. Token accounting flows through `query/tokenBudget.ts`.

## Cross-cutting

- **Reactive compact is feature-flagged.** `feature('REACTIVE_COMPACT')`
  switches between two compact modes inside `query.ts`. The reactive
  variant is the newer one.
- **The fallback path is an exception type, not a return code.**
  `FallbackTriggeredError` short-circuits the retry layer and lets
  the engine pivot models without unwinding the loop.
- **Permission denials are first-class messages.** `SDKPermissionDenial`
  is a peer of `SDKMessage` in the stream type, not an out-of-band
  channel.

## Open questions

- The full set of SDK message variants and their order constraints.
- How `query/stopHooks.ts` interacts with `services/compact/`.
- Where the per-tool permission decision is cached, if at all.
- Whether reactive compact and autocompact threshold can be on
  simultaneously, or whether they're mutually exclusive modes.
