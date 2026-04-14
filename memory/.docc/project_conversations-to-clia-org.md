---
name: Move conversations CLI to clia-org
description: rismay wants the todo3 conversations SPM package (currently in todo3/.../code/spm/tools/conversations/) relocated to clia-org/.../tooling/spm/ — it's conceptually a clia-* tool, not a todo3 tool, and zero external Swift consumers depend on it.
type: project
---

The `conversations` SPM tool currently lives at
`private/universal/substrate/collectives/todo3/private/code/spm/tools/conversations/`
but should move over to `clia-org/private/universal/domain/tooling/spm/`
(naming TBD — likely `swift-conversations-cli` to match siblings like
`swift-codex-session-store-cli` and `swift-session-mirror-cli`).

**Why:**

- Conceptually it's a clia-* tool: parses Codex/Claude/openclaw chat
  exports, generates canonical conversation files, runs encoding
  benchmarks, builds reproducible archives. It's the same family as
  `swift-codex-session-store-cli`, `swift-codex-session-startup-audit-cli`,
  `swift-session-mirror-cli`, and clia-mem.
- todo3 is a more generic knowledge-base / personal-todo collective.
- It's the home of the only existing in-substrate LZFSE compression
  call sites (~15 inline `(NSData).compressed/decompressed(using: .lzfse)`
  calls in `ConversationsCLI.swift` and `ConversationsBenchEncoding.swift`).
  Now that `swift-universal/.../common-lzfse` is the source-of-truth for
  LZFSE file ops (added 2026-04-09), those call sites should migrate to
  `import CommonLZFSE` and use `Data.lzfseCompressed/Decompressed` and
  `LZFSEFile.compressInPlace`. The move-to-clia-org and the
  CommonLZFSE migration are the natural pair.

**How to apply:**

- **Zero external Swift consumers.** A grep across the substrate for
  `import ConversationGeneratorCore` / `import ConversationsCLI` /
  `package: "Conversations"` returns only the package's own files plus
  one line in an openclaw session log. Moving it does NOT require
  updating any Package.swift outside todo3.
- **Documentation references.** Two playbook .md files in
  `todo3/private/operations/playbooks/how-to/use-swift-package-manager.md`
  and `todo3/private/engineering/playbooks/how-to/use-swift-package-manager.md`
  mention `tools/conversations` and need updating after the move.
- **Existing Package.swift uses an obsolete relative-path layout** —
  `../../../mono/orgs/wrkstrm/private/spm/...` and
  `../../../mono/orgs/swift-universal/private/spm/...`. That's a
  vestige of an older monorepo shape; the substrate uses
  `private/universal/substrate/collectives/...` paths. Every relative
  dep needs rewriting to traverse from clia-org's tooling spm dir
  rather than todo3's tools dir.
- **`ReproducibleArchive` sibling.** Lives at `todo3/private/code/spm/library/reproducible-archive/`
  and is depended on via relative path `../../library/reproducible-archive`.
  It's a tar+gzip directory archiver via subprocess — wrong shape for
  most modern uses but the conversations CLI uses it for canonical
  conversation archive bundles. Decision needed: bring it along, or
  leave it in todo3 and update the relative path. I'd lean toward
  bringing it along under `clia-org/.../tooling/spm/` since it's
  arguably a clia-org concern too, but that's a second move with its
  own dependency and consumer audit.
- **Dead source dirs in the conversations package.** `Sources/ConversationsBenchEncoding/`
  (where 10 of the 15 inline lzfse calls live!) and `Sources/ConversationsWrappers/`
  exist on disk but are NOT declared targets in the current Package.swift.
  The `.build` cache shows they used to be declared (and built into a
  `conversations-bench-encoding` executable), so they're orphaned from
  a previous package shape. Decision needed: revive them as declared
  targets in the new home, leave them as orphaned source dirs that
  come along, or delete them as part of the move.
- **External `~/todo3` clone.** The `.build` cache references
  `/Users/sonoma/todo3/...` paths, suggesting rismay maintains both a
  standalone `~/todo3` clone AND a substrate-mounted `mono/.../todo3`
  copy. The move only affects the substrate-mounted copy; the
  standalone clone is its own concern.

**Migration scope (when we do it):**

1. `git mv` the package directory across collectives (preserves history).
2. Decide on the new name (`swift-conversations-cli` recommended).
3. Rewrite every relative-path dependency in `Package.swift` to
   traverse from clia-org instead of todo3. Most deps point at
   swift-universal narrow packages — those resolve from
   `clia-org/.../tooling/spm/<new-name>/` via roughly
   `../../../../../../../swift-universal/private/universal/spm/domain/system/<dep>`.
4. Migrate the 15 inline lzfse calls to `CommonLZFSE` as part of the
   same change.
5. Update the 2 doc playbook .md files.
6. Decide ReproducibleArchive's fate (move with, or leave behind).
7. Decide ConversationsBenchEncoding/Wrappers fate.
8. Build + test the package in its new home.
9. Verify the standalone executable still runs.
10. Stage the deletion in todo3 separately so the operator can review.

**Don't push the codex sessions submodule and don't push todo3 either**
unless explicitly asked — the move touches both submodules, both should
be left unstaged for operator review.
