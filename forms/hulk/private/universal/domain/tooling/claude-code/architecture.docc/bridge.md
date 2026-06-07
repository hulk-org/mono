@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# bridge

The `bridge/` cluster is the **REPL ↔ remote control** seam. It is
how a local Claude Code REPL exposes itself to a remote operator
(web/desktop) over a transport, and how inbound messages and
attachments come back into the local session.

Pairs with `remote/` (the *server* side of the same channel) and
with `services/oauth/` + `utils/auth*` for authentication.

## Files

| File | Role |
| --- | --- |
| `bridgeApi.ts` | Outbound API surface — how local code calls the bridge. |
| `bridgeConfig.ts` | Bridge configuration loader. |
| `bridgeDebug.ts` | Debug instrumentation. |
| `bridgeEnabled.ts` | Feature gate / opt-in check. |
| `bridgeMain.ts` | Bridge process entrypoint. |
| `bridgeMessaging.ts` | Message envelope encoding/decoding. |
| `bridgePermissionCallbacks.ts` | Tool permission round-trips over the bridge. |
| `bridgePointer.ts` | Cursor / "where the user is" pointer state. |
| `bridgeStatusUtil.ts` | Status string helpers. |
| `bridgeUI.ts` | UI affordances driven by bridge state. |
| `capacityWake.ts` | Wake-from-sleep on capacity event. |
| `codeSessionApi.ts` | Code session API client. |
| `createSession.ts` | Session creation handshake. |
| `debugUtils.ts` | Bridge-only debug helpers. |
| `envLessBridgeConfig.ts` | Config path that doesn't read env vars (sandbox-safe). |
| `flushGate.ts` | Backpressure / flush gating. |
| `inboundAttachments.ts` | Inbound file attachment handling. |
| `inboundMessages.ts` | Inbound message handling. |
| `initReplBridge.ts` | REPL-side bridge init. |
| `jwtUtils.ts` | JWT validation/parse for trusted sessions. |
| `pollConfig.ts` / `pollConfigDefaults.ts` | Polling cadence config. |
| `remoteBridgeCore.ts` | Core remote bridge state machine. |
| `replBridge.ts` | REPL bridge facade. |
| `replBridgeHandle.ts` | Handle returned to REPL callers. |
| `replBridgeTransport.ts` | Transport abstraction. |
| `sessionIdCompat.ts` | Backward-compat session id translation. |
| `sessionRunner.ts` | Drives a bridged session through the QueryEngine loop. |
| `trustedDevice.ts` | Trusted-device check. |
| `types.ts` | Bridge types. |
| `workSecret.ts` | Per-session secret material. |

## Key concepts

- **REPL bridge vs. remote bridge.** `replBridge.ts` is the local
  REPL's view; `remoteBridgeCore.ts` runs the wire protocol.
- **Capacity wake.** `capacityWake.ts` is what brings a sleeping
  bridged session back when the upstream side has work.
- **JWT + trusted device.** Auth runs through `jwtUtils.ts`
  `trustedDevice.ts`; the work secret in `workSecret.ts` is
  per-session.
- **Sandbox-safe config.** `envLessBridgeConfig.ts` exists because
  some environments strip env vars before this code runs (the
  same shape as the `xcodebuild SPM_USE_LOCAL_DEPS` issue noted
  in operator memory).

## Open questions

- Wire-format spec (NDJSON? framed JSON? protobuf?) — not yet read.
- Where the session id compatibility layer breaks: which old format
  does `sessionIdCompat.ts` translate from?
- How `flushGate.ts` interacts with autocompact under reactive mode.
