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
- **iOS app shipping end-to-end via xcodebuild + altool, no Xcode GUI.**
  `xcodebuild archive` (Release, generic/platform=iOS), then `xcodebuild
  -exportArchive` with **`-allowProvisioningUpdates`** (REQUIRED — without
  it, automatic signing silently fails with "No profiles for ... were found"
  even when the App Store Connect record + Apple Distribution cert both
  exist locally; the flag grants permission to fetch profiles from the
  Apple web service). Then `xcrun altool --validate-app` followed by
  `xcrun altool --upload-app` with `-p '@env:VAR'` so the app-specific
  password never appears on the command line. Distribution cert
  (`Apple Distribution: ...`) must already be in the keychain — Xcode →
  Settings → Accounts → Manage Certificates → + → Apple Distribution
  creates it; xcodebuild can't create distribution certs from the CLI.
- **Pa-mode product pattern.** Info.plist key `RDDefaultCollective: pa`
  branches the SwiftUI app's WindowGroup root to a locked
  `CollectiveFullScreenView` (no dev shell, no chrome, no fullScreenCover
  dance) so the lens *is* the entire app. Launch args
  (`-OpenCollective <slug>`, `-DefaultCollective <slug>`) take precedence
  in `init()` so dev iteration on the iOS target still works.
- **Density-aware lens rendering with paired light/dark warm palette.**
  CollectiveTheme injected via `EnvironmentValues` exposes a paper-cream
  + warm-graphite paired palette and three personality typographies
  (warmSerif → New York via `Font.system(_, design: .serif)`, structured
  → monospaced, considered → mid-weight). The renderer picks personality
  from `(audience, density)` instead of from a stored field on Collective
  so the schema stays minimal.
- **App icon generation via Swift CoreGraphics + CoreText, no AppKit/UIKit.**
  CGContext + CGGradient + CTFont + CTLineCreateWithAttributedString +
  CGImageDestinationCreateWithURL writes a 1024×1024 PNG. Use
  `kCTFontAttributeName` / `kCTForegroundColorAttributeName` (CFString)
  in the attributes dict — `NSAttributedString.Key.font` /
  `.foregroundColor` are AppKit/UIKit additions and unavailable from
  pure Foundation. Keep as a re-runnable script in `scripts/`.
- **xcodegen `info.properties` build-setting interpolation.** When the
  iOS target uses an `info: { path, properties }` block (not
  `GENERATE_INFOPLIST_FILE`), set
  `CFBundleShortVersionString: $(MARKETING_VERSION)` and
  `CFBundleVersion: $(CURRENT_PROJECT_VERSION)` so the version flows from
  one source of truth in `settings.base`. xcodegen writes the literal
  `$(...)` and Xcode resolves at build time. Also: orientations and
  `UILaunchScreen` belong here, not in a hand-edited Info.plist.
- **App Store Connect API querying via xcodebuild distribution logs.**
  Failed `-exportArchive` writes a `xcdistributionlogs` bundle to
  `$TMPDIR/<scheme>_<date>.xcdistributionlogs/`. The
  `IDEDistributionAppStoreConnect.log` shows the exact REST query
  xcodebuild made and the response, which is how to definitively diagnose
  whether a bundle id exists in App Store Connect (`data: [], total: 0`
  → not registered; `data: [...], total: 1` → registered).
- **Local credentials store convention for App Store Connect uploads.**
  `~/.appstoreconnect/credentials/<bundle-id>.json` (chmod 600, dir 700,
  outside the repo). One file per app; schema includes appleId, team,
  ascAppId, app-specific password (or apiKey ref), upload history with
  delivery UUIDs. Treat as interim until a real keychain takes over.
  Documented at `~/.claude/memory/.docc/project_appstoreconnect-credentials-store.md`.

## Recent work

- 2026-04-09 (post-cutover followup): **Updated
  `feedback_workspace-auto-commit-hook.md` to two-layer framing.** The
  older memory described the workspace hook as silently committing
  unrelated untracked files without trailers; this session observed a
  newer behavior where the hook auto-commits MY edits with coherent
  scope-aware messages (e.g. `cc73ca0 env(codex):`,
  `2d7b37c clia-agent-cli: wire agent-schemas`,
  `a04ffd0 memory(hulk/claude): chronicle the env profile cutover session`)
  that DO carry the `Co-Authored-By: Claude Opus 4.6 (1M context)`
  trailer, and that the hook also auto-bumps parent mono submodule
  pointers in separate `chore(submodules):` commits. The older sweep
  behavior is still active though — confirmed mid-session when my
  `0759894e20 chore(submodules): bump hulk for env profile cutover
  winddown` accidentally bundled three unrelated `maintainers/{shueber,
  simonbs}` items. Memory now documents both layers; index entry
  rewritten to match.

- 2026-04-08 (evening): **Env profile cutover out of `harnesses/clia/` +
  clia-org build repair + `TriadSchemaVersion` fix.** Cut over the 521-line
  operator/environment profile from the misnamed
  `harnesses/clia/rismay-substrate.header.harness.wrkstrm.json` to its
  semantically correct home at
  `operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json`.
  The operator caught the misnomer mid-plan-mode ("the header harness is
  for the environment - not for the harness right?") and the reframe drove
  everything: the file describes operator/org/policy/preferences/realms/
  terminalogy/toolPolicy/directives plus a header.defaults block; only ONE
  field in the entire 521 lines is harness-specific. Additive-first resolver
  cutover across 7 submodules + parent mono in 16 commits — extend
  `HarnessHeaderConfig.candidateLocations` to `[new, legacy]`, land the file
  cross-repo (no `git mv` because git can't follow inodes across repo
  boundaries), migrate every consumer (wrkstrm-core resolver/tests/display
  literals, clia-org `EnvironmentProfiler` fallbacks + 5 test files,
  wrkstrm-app source-control commit-plan filter, codex-agent boot/identity
  surfaces × 6, cadence-agent identity + resume × 2, orchestrators/clia
  doctrine mirrors × 3, schema-universal investigation, hulk memory note,
  parent-mono skill files), shrink the candidate array to a single entry,
  delete the legacy file + the retirement README + the empty `harnesses/clia/`
  directory under explicit per-file confirmation. **Registered codex and
  openclaw as hulk implementations on paper**: Implementations table rows in
  `harnesses/hulk/.docc/index.md` plus skeleton `hulk-compliance.json` files
  at both harness roots listing all 13 contract clauses (B-1 Identity Loading
  through S-7 Host Citizenship) as `unverified`. Defined the
  `hulk.compliance.v0.1.0` schema. **Repaired the pre-existing clia-org build
  break** that had been masked by the missing module error: wired
  `agent-schemas-v000-001-000` as a new package dep across CLIACore +
  CLIAAgentAudit + CLIAAgentTool + 2 test targets, added the missing
  `Agent_Schemas` + `Agenda_Schemas` imports to 11 source files and 9 test
  files, fixed `LinkRefModel` API drift (`.url` → `.urlString`, non-optional
  in v0.2.0), bumped 5 stale fixture `schemaVersion` strings from `0.2.0` to
  `0.3.0`. **Fixed `TriadSchemaVersion.current` drift** in
  `core-triad-schemas-v000-001-000`: the constant was hardcoded to `"0.1.0"`
  with a contradictory `// HISTORICAL v0.1.0: preserved legacy schema
  surface` comment. Bumped to `"0.5.0"` matching the live JSON schemas under
  `.wrkstrm/schemas/triads/triads.{agent,agency,agenda}.schema.json` and
  rewrote the comment to explain that the SPM package name reflects its
  first stamped version while the constant always tracks the live wire.
  Unblocked 3 silent runtime bugs (Merger fallback, BackupCleanupCommand
  output, ProfilesCommand warning chain) that were all silently encoding
  invalid documents with `schemaVersion: 0.1.0`. Final state: 117/117
  clia-agent-cli tests green (was failing-to-build → 114/117 → 117/117);
  17/17 wrkstrm-core SwiftHarnessEnvironmentTests green under both extended
  and shrunk resolver; `header validate` returns the new operator-home path;
  `harnesses/clia/` directory gone. See journal article
  `journal-2026-04-08-env-profile-cutover.md` for the full chain.

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
- 2026-04-08 (latest): **Today (clia-day) Pa-mode V1 → TestFlight upload.**
  Built the Today product end-to-end as a personal-account TestFlight ship.
  Soft warm theme (paired light/dark, serif typography), Pa-mode locked
  iOS root (Info.plist `RDDefaultCollective: pa` makes the lens the entire
  app), `PaStory` bundled producer surface with `nonisolated(unsafe)`
  cache, density-aware `CollectiveCardView` rewrite, custom soft segmented
  picker, themed launch screen, generated app icon via CoreGraphics +
  CoreText, `PrivacyInfo.xcprivacy`, version metadata flowing from
  `$(MARKETING_VERSION)`/`$(CURRENT_PROJECT_VERSION)`. Resolved a
  stable-vs-unstable SPM graph conflict via local-path overrides. Bumped
  iOS deployment target 18 → 26 to allow `LanguageModelSession` stored
  prop. Wrapped a previous-dev `#warning` Release trace in `#if DEBUG`.
  Reused legacy 2016 slot `com.wrkstrm.ios.app.today` (ASC id `1153239848`,
  display name "Today") under personal team `BM6B69ZQSR`. Archive →
  export with `-allowProvisioningUpdates` → validate → upload via
  `xcrun altool` succeeded; Delivery UUID
  `6c11c0f8-d105-40ea-9b78-3e754f3aaaea`. **Mid-session correction**:
  rismay clarified that the product is *for him reading AI summaries*, not
  for a literal 62-year-old reader; "Pa" is design language not customer
  identity. Saved as `user_today-app-real-customer.md` so future-me does
  not have to be corrected again. The producer pipeline (AI agent
  generates `today-pa.json` automatically at end of session) is the next
  design priority.
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
