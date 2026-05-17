---
name: Substrate vaults shipped (registry + workspace)
description: First two typed-vault libraries landed May 2026; same architectural pattern (file-backed JSON/XML via Foundation, atomic save + .bak rotation, typed find/upsert/remove); future vaults follow same shape
type: project
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
Substrate's "vaults around the models" thread shipped its first two production vaults this session:

**SubstrateRegistryVault** at `clia-org/private/universal/domain/tooling/spm/substrate-registry-vault/`
- Wraps substrate-cli-registry.json (105 CLIs) + substrate-apps-input.json (127 apps)
- Typed Swift API: `find(slug:)`, `find(execName:)`, `find(execHash:)`, `find(alias:)`, `entries(forCollective:)`, `aliased`, `installable`, `collectives`, `upsert(_:)`, `remove(slug:)`, `save()`
- Storage: file-based JSON with atomic save + `.bak.json` rotation
- 9/9 tests passing

**SubstrateWorkspaceVault** at `clia-org/private/universal/domain/tooling/spm/substrate-workspace-vault/`
- Wraps substrate xcworkspace's `contents.xcworkspacedata` XML
- Typed Swift API: `entries`, `find(path:)`, `entries(inGroup:)`, `topLevelGroups`, `upsert(_:)`, `remove(path:)`, `save()`
- Tracks group hierarchy (FileRefs nested inside `<Group>` elements; `WorkspaceFileRef.groupPath` captures nesting)
- Storage: file-based XML via XMLDocument, atomic save + `.bak.xml` rotation
- 7/7 tests passing

**Integration into wrkstrm-identifier:** subcommands (emit-aliases, install-cli, apply-cli-renames, workspace-sync, workspace-validate) all use the vault APIs. Old local Registry/RegistryEntry duplicate types deleted; vault types are canonical.

**Integration into foundry:** foundry-app-lib has SubstrateRegistryVault + SubstrateWorkspaceVault as deps + `FoundryFleet` @MainActor ObservableObject facade exposing 11 typed query methods. SwiftUI binding ready; FleetView next.

**How to apply:** Build the next vault (InstallReceiptsVault, DisplayManifestsVault, OperatorAliasesVault) using the same Package.swift + Models.swift + Vault.swift + tests pattern. ~1 hour per new vault. Per substrate-as-factorio doctrine: these are "belt vaults" — file-based single-consumer; graduate to "bot vault" (vaultd + Fleece + Couchbase Lite) when 3+ consumers need live reactivity.
