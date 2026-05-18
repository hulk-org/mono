---
name: vaultd-fleece-couchbase-lite
description: Vault-polymorphic storage — each vault declares its own storage type (text/json/sqlite/fleece+vaultd) as typed metadata; multi-consumer vaults (CLI + App + 3D world) graduate to Fleece+Couchbase Lite via vaultd for live-query reactive sync; single-consumer vaults stay file-based; typed Swift models + refinement primitives stay unchanged.
type: project
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
The substrate is **NOT** moving everything to a centralized server.
The actual design is **vault-polymorphic storage**: each vault
declares its own storage type as typed metadata (`VaultStorageType`),
and the substrate dispatches accordingly. Single-consumer vaults
stay file-based and cheap; multi-consumer vaults (CLI + App +
3D world) graduate to Fleece + Couchbase Lite via the `vaultd`
daemon to eliminate lock contention and gain live-query reactive
sync. Apps connect to vaultd as clients ONLY for the Fleece+Couchbase
storage type; other storage types use direct access.

**Why per-vault storage choice (not blanket vaultd):**

- **Lock contention only triggers with multi-consumer vaults**:
  N processes opening the same SQLite/JSON files produce "database
  is locked" errors. A single-consumer vault doesn't have that
  problem; centralizing it would be over-engineering.
- **Vaults already differ in nature**: text-file vaults (notes,
  prompts, doctrine MDs), JSON-file vaults (workflow definitions,
  identity bundles), SQLite vaults (harness runtime state), and
  the new Fleece+vaultd class (multi-consumer, live-query-driven).

**Why Fleece + Couchbase Lite + vaultd for multi-consumer vaults:**

- **Centralized server = one queue, N clients**: vaultd serializes
  all access; clients see consistent transactions.
- **Fleece is the right wire format**: binary, JSON-superset, O(1)
  random field access without parsing the whole document, smaller
  than JSON on disk.
- **Couchbase Lite ships SwiftUI live queries**: data changes
  propagate to UI without manual reactive plumbing. CLI writes →
  app form reflows + 3D world re-renders the changed organism →
  every consumer sees consistent state. This is the killer feature
  for the CLI + App + 3D-world substrate.
- **Sync Gateway** is optional: vault-to-cloud replication if/when
  the substrate goes multi-device.

**What stays unchanged from the typed-everything work:**

- Typed Swift models (LinkRefModel, WorkflowModel, etc.) — the
  model IS the spec; storage is downstream.
- Refinement primitives (NonEmpty, Bounded, NonZero, Trimmed, Slug,
  AbsolutePath/RelativePath, Sorted, Unique, …) — type-level
  enforcement is storage-agnostic.
- Schema versioning + migrators (`asV000_003_000` etc.) — bridge
  functions are pure; bind to whichever storage layer.
- Schema battle tests, identifier registry, role-named protocols.
- `@Generable` composition with Apple FoundationModels.

**What changes:**

- **Storage layer**: filesystem JSON files → Couchbase Lite documents
  in Fleece encoding.
- **Access API**: direct `Data(contentsOf:)` → vaultd IPC client.
- **Concurrency model**: file locks → server-side transactions.
- **Corpus migrator pattern** (`swift-link-ref-corpus-migrator-cli`):
  the same `findPositions(of:)` walker survives, but the substrate
  source becomes vault queries (fast, indexed) instead of filesystem
  recursion (slow, lock-prone).
- **Compact JSON wire keys** (`{t, d, s, tg}` in LinkRefModel v0.3.0):
  less load-bearing inside the vault (Fleece is binary), still useful
  when data crosses to network APIs / file exports.

**Sketched typed shape:**

```swift
public struct VaultStorageType: Sendable, Hashable, Codable {
  internal enum Storage: Sendable, Hashable, Codable {
    case textFiles(rootPath: String)
    case jsonFiles(rootPath: String)
    case sqliteDatabase(path: String)
    case fleeceCouchbase(server: VaultServerEndpoint)
  }
  internal let storage: Storage
  public static func textFiles(rootPath: String) -> Self
  public static func jsonFiles(rootPath: String) -> Self
  public static func sqliteDatabase(path: String) -> Self
  public static func fleeceCouchbase(server: VaultServerEndpoint) -> Self
}

public struct VaultManifest: Sendable, Hashable, Codable, SemanticVersionable {
  public static let semanticVersion = "0.1.0"
  public var slug: String
  public var displayName: String?
  public var storage: VaultStorageType
  /// Multiple consumers → multi-consumer vault → server-mediated storage required.
  public var consumers: NonEmpty<VaultConsumer>
}

public enum VaultConsumer: String, Codable, Sendable, Hashable, CaseIterable {
  case cli, app, threeDWorld, agent, koma, daemon
}
```

A future refinement primitive `MultiConsumer<T>` (≥2 elements) could
make "vault has multiple consumers" a type, letting the compiler reject
`VaultManifest { storage: .textFiles(_), consumers: <MultiConsumer> }`
at construction — pushing the validation rule into the type system.

**Open design questions to settle before building:**

1. **Per-vault storage classification**: which existing substrate
   vaults stay file-based vs which graduate to Fleece+vaultd?
   Vault-by-wrkstrm credentials (multi-consumer) → vaultd; agent
   private memory (single-consumer) → stays file-based; etc.
2. **vaultd ownership**: is vaultd hosted inside hulk (the carrier
   harness), as a peer daemon, or as a system-level launchd service?
3. **IPC mechanism**: XPC (macOS-native, fastest) or Unix socket
   (cross-platform, simpler)?
4. **Authentication**: how does an app prove it's allowed to access
   a given vault? Reuses the existing vault-by-wrkstrm credential
   pattern, or new mechanism?
5. **Migration plan**: how do existing JSON files (workflow JSONs,
   identity bundles, chronicles, agendas) lift into vault docs?
   The corpus migrator pattern adapts — same bridge functions,
   different source/sink — but needs a one-time mass migration step.
6. **Sync Gateway**: does the substrate adopt cloud sync now, or
   stay local-only with sync as a future option?
7. **Doc identity strategy**: substrate uses slug-as-identity
   everywhere; map slugs → Couchbase Lite doc IDs directly, or use
   UUIDs with slug as a property?

**Connection to existing substrate work:**

- `vault-by-wrkstrm` (Passwords + Wallet + Reminders hybrid; keychain
  daemon; sealed agent artifacts; me.rismay.vault) is the existing
  vault concept; vaultd is the daemon shape that hosts it.
- `swift-git-credential-vault` koma (planned) implements git
  credential helper protocol on top of VaultCore.TokenResolver —
  vaultd is the server side of that resolver.
- Generative UI + Couchbase Lite live queries pair naturally —
  type → vault doc → live query → SwiftUI form.
