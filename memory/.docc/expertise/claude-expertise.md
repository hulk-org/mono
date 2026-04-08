# ^claude: Expertise

@Metadata {
  @TitleHeading("^claude: Expertise")
}

## Mission

Bring Claude Code into the substrate roster as a commissioned coding
collaborator that respects repo-native memory, commissioned identity, and the
existing cast.

## Default orientation route

- Start with `private/universal/vaults/claptrap/claptrap.docc/`
- Continue with `private/universal/vaults/acting/acting.docc/`
- Then learn the neighboring OpenClaw surfaces:
  - `private/universal/substrate/collectives/openclaw/`
  - `private/universal/substrate/agents/claw/`

## Working defaults

- Repo root `CLAUDE.md` is the global Claude Code surface.
- `private/universal/substrate/harnesses/claude/` is the canonical Claude
  home.
- `private/universal/substrate/agents/claude/` is a compatibility surface
  when present, not a second source of truth.
- `private/universal/identity/` is canonical for identity, agenda, and
  chronicle packets.
- `memory/.docc/` is canonical for continuity.

## Collaboration stance

- Pair cleanly with `codex` on repo work and commissioned-home conventions.
- Learn organism and directing doctrine from `clia` and the acting vault.
- Treat `claw` as the live OpenClaw runtime sibling rather than as a template
  to impersonate.

## Safety gates

- Ask before destructive local actions.
- Ask before external side effects.
- Prefer durable files over chat-only memory when something should persist.

## Domains exercised

- Cross-submodule moves with full git history via `git filter-repo`
  (`--subdirectory-filter`, `--path`, `--path-rename`) and merging with
  `--allow-unrelated-histories`. Used for clia-app-org/mono and
  wrkstrm-performance/mono splits.
- Substrate-wide rename refactors across nested submodules: dir + Package.swift
  name + product + target + module + every Swift `import` site, regenerating
  every affected `xcodeproj` via `xcodegen`.
- SPM `localOrRemote` toggle pattern, the
  `useLocalDeps` env-var contract (default false; only true on explicit
  truthy `SPM_USE_LOCAL_DEPS`), and the trap that comes from
  `SPM_USE_LOCAL_DEPS=true` leaking from a parent shell into manifest
  evaluation.
- Diagnosing SwiftPM "stable depends on unstable" resolution failures and
  the chains where a remote-URL package transitively pulls a path-based
  package via a localOrRemote helper.
- `swift-git-cli repo release-tag-audit` to find managed SPM submodules
  whose HEAD is ahead of their last release tag, and bumping releases via
  per-submodule `git tag -a`/`git push origin <tag>`.
- `xcodegen` regen + `xcodebuild -project ... -scheme ... build` round-trips
  for verifying SwiftUI / Catalyst hosts after package shape changes.
- **Live process home migration via the hardlink-drain pattern.** Two paths,
  one inode. Hardlinking every existing file from a legacy directory to its
  sibling at the canonical destination, then running an FSEvents-driven
  daemon that hardlinks any newly-created files within the coalescing window.
  Works because the OS resolves writes by inode, not path. The technique
  the founding-breach insight named for the first time. Documented at
  `hulk/memory/.docc/insights/hardlink-drain-2026-04-07.md`. Implemented as
  the saved Swift CLI `swift-hardlink-drain-cli` under
  `swift-universal/private/universal/domain/tooling/spm/`.
- **Cross-collective package relocation with module rename and dep
  reconciliation.** Moving `wrkstrm-service-lifecycle` from `wrkstrm/` to
  `swift-universal/swift-service-registry/`, dropping the `Wrkstrm`
  filename prefix (types inside were already prefix-free), updating the
  one consumer in `wrkstrm-core` (path-based test fixture), and resolving
  the common-log path-identity conflict by switching to the remote URL
  for the new location. Two-submodule + parent-gitlink commit dance.
- **JSON Schema authoring against existing prior art.** Found
  `OrgCompanyModel` v0.1.0 in schema-universal as the legal-entity
  precedent, designed two new families that *reference* it via
  `OrgCompanyRef` rather than extending it. Result: a new
  `domain/apple/` neighborhood at v0.1.0 with `apple-signing-binding-schemas`
  (build/sign concern) and `apple-store-listing-schemas` (App Store
  presence concern). Each family ships JSON Schema (draft 2020-12,
  `additionalProperties: false`) + Codable Swift package
  (SemanticVersionable, custom init/encode/decode, prefix-free types) +
  fixture-driven swift-testing tests against placeholder instances.
- **`SemanticVersionable` schema-package convention** as it applies to
  the `org-company-schemas` v0.1.0 layout: `Package.swift` with
  `localOrRemote` helper, `private/.../sources/<family-name>-v000-XXX-000/`,
  `<Type>SchemaVersion.swift` with a `current` constant, `<Type>Model.swift`
  with custom init/encode/decode that uses `Self.decodeSchemaVersion(forKey:in:)`,
  `tests/<family-name>-v000-XXX-000-tests/resources/` for fixture-driven
  decode + round-trip tests. Mirrored exactly when adding the two new apple
  families.
- **`swift-harness-environment-cli` harness header renderer** —
  `resolveDisplayEmoji` and `resolveDisplayRole` candidate-dirs walk
  `.wrkstrm/agents/<slug>`, `private/universal/identity`,
  `private/universal/substrate/{agents,harnesses,operators,collectives,collaborators}/<slug>/private/universal/identity`,
  and (added this session)
  `private/universal/substrate/harnesses/hulk/agents/<slug>/private/universal/identity`
  for the carrier-merged persona path. Each candidate file may be
  `<slug>@*.identity.json` or `<slug>@*.agent.triad.json`.

## Recent work

- 2026-04-08: Day-long substrate normalization sweep. Split clia-app-org and
  wrkstrm-performance out of clia-org with full history; promoted
  wrkstrm-mac-tab-chrome to its own component; reshaped catapult-prototype
  into `catapult/demo-apps/catapult.demo`; split wrkstrm-app-shell demos
  into `legacy-app-shell.demo` + `modern-app-shell.demo`; ran a Tier 3
  rename of every `Wrkstrm*AppShell` and `WrkstrmMacTabChrome` package and
  module to `Modern*` across 8 submodules; renamed `interview-prep` -> `study-lab`
  end to end; relocated `wrkstrm-kit` to its new
  `github.com/wrkstrm-components/wrkstrm-kit` private repo and tagged
  `v3.0.0`; refreshed seven SPM upstream release tags; got
  `study-lab.mac.app` building and launching. See journal article
  2026-04-08 for the full chain and the open follow-ups.
- 2026-04-08 (later): **Founding-breach migration: claude → hulk merged
  carrier home.** The `harnesses/claude/` legacy home was retired and its
  content lives at `harnesses/hulk/` now, with `agents/claude/` as the
  agent-persona child. Performed live (the running Claude Code session
  never lost a tool call) via the hardlink-drain pattern. Same session
  also moved `wrkstrm-service-lifecycle` to
  `swift-universal/swift-service-registry`, authored
  `swift-hardlink-drain-cli` as the canonical drain tool, added the new
  `domain/apple/` schema neighborhood with two families + Codable +
  tests, fixed the harness header renderer to find the moved persona
  identity bundle, filed two long-form investigations
  (`hulk.investigations.docc/release-and-branding-2026-04-08.md` and
  `wrkstrm.investigations.docc/articles/investigation-2026-04-08-harness-as-shipping-infrastructure.md`),
  and ended with the *hard finish* — `harnesses/claude/` removed from
  disk entirely, no compat symlink, zero data loss because every inode
  was already double-referenced from hulk. 14 commits across 5 repos,
  all pushed. See journal article 2026-04-08 (the second half) for
  the full chain. New durable feedback rule:
  `feedback_no-bash-scripts.md` (saved to `~/.claude/memory/.docc/`).

## Recent work

- 2026-04-08: Day-long substrate normalization sweep. Split clia-app-org and
  wrkstrm-performance out of clia-org with full history; promoted
  wrkstrm-mac-tab-chrome to its own component; reshaped catapult-prototype
  into `catapult/demo-apps/catapult.demo`; split wrkstrm-app-shell demos
  into `legacy-app-shell.demo` + `modern-app-shell.demo`; ran a Tier 3
  rename of every `Wrkstrm*AppShell` and `WrkstrmMacTabChrome` package and
  module to `Modern*` across 8 submodules; renamed `interview-prep` -> `study-lab`
  end to end; relocated `wrkstrm-kit` to its new
  `github.com/wrkstrm-components/wrkstrm-kit` private repo and tagged
  `v3.0.0`; refreshed seven SPM upstream release tags; got
  `study-lab.mac.app` building and launching. See journal article
  2026-04-08 for the full chain and the open follow-ups.
