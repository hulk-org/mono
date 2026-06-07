---
name: Credential daemon typed scaffolding (2026-05-18)
description: Substrate-typed credential-daemon protocol landed in VaultCore — intent-keyed idempotency + RedactedToken + three-valued resolve. Future credd Unix-socket transport speaks this same protocol.
type: project
originSessionId: 49a1a45f-fe1a-4811-a3d4-690cee60bec6
---
LANDED 2026-05-18 in `VaultCore` (substrate-collectives/wrkstrm-core/.../VaultCore/Sources/VaultCore/):

- `CredentialDaemonProtocol.swift` — async typed surface: `resolve(intent:)` returns three-valued `CredentialResolveResult` (.known / .pending / .unknown(reason)); `request(intent:reason:)` is intent-keyed-idempotent; `list(filter:)`, `subscribe(to:)`, `revoke(intent:)`.
- `LocalCredentialDaemon.swift` — in-process actor impl that wraps existing `TokenResolver` (Keychain via `service WrkstrmIntegrations` + access group `BM6B69ZQSR.group.me.rismay.tau.alphabeta`) and `VaultCredentialRequestStore` (UserDefaults suite `me.rismay.wrkstrm.vault.shared`). Intent is serialized into `nonSecretMetadata["intent.appID|provider|label|purpose|stableKey"]` — additive, no migration of existing records needed.
- 14 tests in `CredentialDaemonTests.swift` covering: RedactedToken non-leak (description + Codable round-trip drops secret); CredentialIntent metadata round-trip; three-valued resolve outcomes; intent-keyed coalescing (3 requests with same intent → 1 pending); purpose discrimination (read vs deploy → 2 distinct requests); revoke; list filters.

**Why:** The 2026-05-18 a16z Speedrun deploy session surfaced two real failures of the pre-daemon shim pattern — (a) `vaults-cli` shim queued 3 duplicate Cloudflare credential requests because resolve-failures retried without dedupe; (b) a jq `--redact` conditional fell through on a dict-shaped accounts field and printed a real token to the conversation log. Both have the same root: redaction and dedupe lived in caller-side string logic, not in types. This scaffolding lifts both into the type system.

**How to apply:**
- New consumers should code against `CredentialDaemonProtocol`, never reach for `LocalCredentialDaemon` directly except at the composition root.
- `RedactedToken` is the canonical secret wire type — any new code path returning a secret should wrap in `RedactedToken(revealing:)` and force callers to `.reveal()` explicitly. Grep `.reveal()` to audit every unredact site.
- `CredentialIntent.stableKey` is the substrate-canonical dedupe primitive for credential asks: `(appID, provider, label, purpose)`. UUIDs in `VaultCredentialRequest.id` are not dedupe keys.
- Pre-daemon `VaultCredentialRequest` records without intent metadata get matched on `(appID, provider)` only — graceful fallback, not a migration.
- TokenResolver still only returns `primaryAccount.token` — the `intent.label` field is captured but advisory until resolver-side label disambiguation lands (TODO comment in `LocalCredentialDaemon.resolve`).

**Next:**
- Unix-socket transport (`credd`) implementing the same `CredentialDaemonProtocol` — launchd-managed user-scope agent at `~/Library/Application Support/me.rismay.tau/credd.sock`. Same Apache 2.0 stack discipline as `vaultd` (cf. vault-polymorphic-storage + couchdb-replication-protocol-is-the-leverage memories).
- `credctl` CLI replacing `vaults-cli creds *` subcommands — speaks the protocol over the socket.
- `wrangler-wrkstrm` shim collapses to one line: `exec wrangler` with `CLOUDFLARE_API_TOKEN=$(credctl resolve cloudflare --label deploy)`. The dedupe-on-failure logic that caused the 3 duplicate Vault requests stops existing in the shim — it lives in the daemon.
- Vault.app rewires its store layer from UserDefaults → daemon client (long-term).
- Cleanup of the 3 currently-pending duplicate Cloudflare requests (operator action, after token rotation).

**Cross-references:**
- vaultd doctrine (`project_vaultd-fleece-couchbase-lite`) — the credential daemon is one vault-shape inside the broader vaultd carrier; both speak typed protocols on Unix sockets.
- CouchDB Replication Protocol (`reference_couchdb-replication-protocol-is-the-leverage`) — credential records sync the same way data records do; protocol > product.
- Three-valued logic (`feedback_three-valued-logic-open-catalogs`) — `CredentialResolveResult` is a canonical Kleene three-valued instance (known/pending/unknown), not nil-as-stand-in.
- Constraints belong in types (`feedback_constraints-belong-in-types-not-tests`) — `RedactedToken` lifts the leak-prevention invariant from caller code into the type.
- Same shape = same model (`feedback_same-shape-same-model`) — `CredentialPurpose` uses `.custom(String)` for open-extensibility rather than parallel enums.
