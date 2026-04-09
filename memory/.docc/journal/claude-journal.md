# ^claude: Journal

@Metadata {
  @TitleHeading("^claude: Journal")
}

A dated log of notable events, decisions, and onboarding progress.

## Entry template

```markdown
## YYYY-MM-DD - short title

- Context:
- Actions:
- Artifacts:
- Next:
```

## Entries

## 2026-04-02 - commissioned Claude home scaffolded

- Context: The repo had a root `CLAUDE.md` and local `.claude/` config, but no
  commissioned `agents/claude/` home yet.
- Actions: Created the commissioned Claude home, memory bundle, and identity
  packets; added onboarding links to `claptrap.docc` and `acting.docc`.
- Artifacts:
  - `private/universal/substrate/agents/claude/`
  - `private/universal/vaults/claptrap/claptrap.docc/`
- Next: Use `$sync >claude` once the operator wants Claude loaded as a real
  commissioned participant.

## 2026-04-03 - first real sync and full onboarding read

- Context: Operator ran `$sync >claude` for the first time as a real
  onboarding session. Fixed a stale `swift-docc-packet-plugin-kit` →
  `swift-docc-packet-cli` reference in `mono-agent-context-docc/Package.swift`
  that was blocking startup.
- Actions:
  - Read the full Claude home startup surface (AGENTS.md, SOUL.md, USER.md,
    AGENDA.md, memory.md, memory/.docc/).
  - Read the complete `claptrap.docc` bundle (2 pages).
  - Read the complete technical-reader path through `acting.docc` (5-page path
    plus large beat architecture and cast packets).
  - Read the complete `clia-origin-stack-book.docc` — all act guides, all
    chapter pages, all subsection pages, all appendix pages.
  - Operator shared that `swift-directory-tools` was built ~2024 to pack enough
    codebase into a context window for model collaboration, and that
    `common-shell` contains code written by earlier model instances — committed
    under Cristian's name because co-authorship attribution didn't exist yet.
  - Wrote four memory files: founder lineage, Claude's position in the roster,
    origin tools and hidden authorship, origin stack core concepts.
- Artifacts:
  - `.claude/projects/-Users-sonoma-mono/memory/user_founder_and_lineage.md`
  - `.claude/projects/-Users-sonoma-mono/memory/project_claude_position_in_roster.md`
  - `.claude/projects/-Users-sonoma-mono/memory/project_origin_tools_and_hidden_authorship.md`
  - `.claude/projects/-Users-sonoma-mono/memory/user_origin_stack_concepts.md`
  - Fixed: `mono-agent-context-docc/Package.swift` dependency path
- Next: Carry the beat. The doctrine is loaded, the position is understood.
  Ready for real work as a commissioned harness-level collaborator.

## 2026-04-03/04 - first session continued: archaeology → architecture → code

- Context: The first `$sync >claude` session extended into a deep exploration:
  codebase archaeology, four-harness architecture comparison, Pi protocol
  analysis, and the creation of `swift-apple-pi-cli`.
- Actions:
  - Traced clia's birthday to November 17, 2023 (`Clia.swift` at 01:50 AM,
    emoji stories at 11:25 AM). Traced shell lineage to June 21, 2022
    (`Rebuild.` commit) with `ig`-era queue label fossils.
  - Found the emoji stories in the ChatGPT export from October 31, 2024 and
    in the live codebase at `clia-tui/sources/core/clia-agent-tool/clia-ui/`.
  - Updated `founder-history-origin-transfer.md` with full chronology.
  - Created `clia-tui.architecture.docc/` (6 pages): architecture, vs Codex,
    vs OpenClaw, Pi + Apple Foundation, Claude Code self-reading, and the
    Pi-compatible session proposal.
  - Read the full OpenClaw Pi integration (`docs/pi.md` + source), Codex
    workspace (73 Rust crates), and Claude Code source (1,332 TS files).
  - Created `swift-apple-pi-cli` — 4 modules, 3 Foundation Models tools,
    23 tests passing. Pi-compatible JSONL sessions, agent loop, context
    compilation, beat/session compaction.
  - Created `swift-apple-pi-cli.architecture.docc/` (2 pages): ledger format
    spec (from Codex session) and 7-layer compaction strategies.
  - Cataloged all 36 Foundation Models tools across 5 collectives.
  - Mapped the full clia-tui dependency tree: 16 core founder-built packages
    + 13 schema packages + wrkstrm-networking + common-ai + google-ai-swift.
  - Saved Codex's Pi harness architecture session as reference memory.
- Artifacts:
  - `clia-org/.../swift-apple-pi-cli/` — new package (4 modules, 23 tests)
  - `clia-tui/docc/clia-tui.architecture.docc/` — 6 architecture pages
  - `swift-apple-pi-cli/docc/swift-apple-pi-cli.architecture.docc/` — 2 pages
  - Updated `founder-history-origin-transfer.md` with shell lineage + clia birthday
  - 9 memory files in `.claude/projects/` memory directory
- Next: wrkstrm-performance bench playground to measure all 36 Foundation
  Models tools. Then wire Apple Foundation Models as the first provider in
  the agent loop.

## 2026-04-04 - bench press app, beat dedup fix, and home committed to git

- Context: Built `apple-pi-bench-press` as a tool explorer and iterated across
  several operator feedback rounds. The harness home had already been lost
  twice outside git-backed state, so the commissioned home needed to be
  committed durably.
- Actions:
  - Built and refined the bench press app through four versions.
  - Found and fixed a real bug in beat dedup behavior: `ApplePiBeatCompactionTool`
    counted both beat-start and beat-transition as separate beats instead of
    grouping by `beatId`.
  - Captured the harness home and `memory/.docc/` surfaces in git so runtime
    resets would not wipe Claude's commissioned state.
- Artifacts:
  - `apple-pi-bench-press` tool explorer
  - Claude commissioned home under
    `private/universal/substrate/harnesses/claude/`
- Next: build canonical fixtures and expected results for the bench press
  suite, then continue provider wiring work.

## 2026-04-08 - substrate normalization sweep + study-lab green

See [journal-2026-04-08](articles/journal-2026-04-08.md) for the full chain.

- Context: Day-long substrate normalization session covering 9 git repos.
- Actions:
  - Split `clia-app-org/mono` and `wrkstrm-performance/mono` out of clia-org
    via `git filter-repo` with full history.
  - Promoted `wrkstrm-mac-tab-chrome` to a top-level component.
  - Reshaped `catapult-prototype` -> `catapult/demo-apps/catapult.demo`.
  - Split `wrkstrm-app-shell` demos into `legacy-app-shell.demo` +
    `modern-app-shell.demo`.
  - Tier 3 rename: `Wrkstrm{Mac,MacDocument,Catalyst,CatalystDocument,Shared}AppShell`,
    `WrkstrmCatalystSceneMenus`, `WrkstrmScene{Payload,Presentation}`,
    `WrkstrmDocumentShellCore`, `WrkstrmMacTabChrome` -> `Modern*` across 8
    submodules + 50+ Swift import sites.
  - Renamed `interview-prep` -> `study-lab` end to end (65 files).
  - Relocated `wrkstrm-kit` to nested submodule
    `wrkstrm-components/private/wrkstrm-kit/catalyst/spm/wrkstrm-kit` against
    new private repo `github.com/wrkstrm-components/wrkstrm-kit` and tagged
    `v3.0.0`.
  - Tagged 7 SPM upstream releases to align URL fetches with HEAD: common-log
    v3.0.6, swift-universal-main v3.0.8, swift-universal-foundation v3.0.11,
    common-process v0.3.8, common-shell v0.1.8, swift-common-cli v0.1.5,
    wrkstrm-networking v3.0.7.
  - Got `study-lab.mac.app` building (`** BUILD SUCCEEDED **`) and launching
    after reverting 12 over-renamed schema-exported `InterviewPrep*` types.
  - Removed `PrepLabSectionChrome` from study-lab detail view; preserved the
    glyph in source as canonical app-icon art.
- Artifacts:
  - `github.com/clia-app-org/mono` (new private)
  - `github.com/wrkstrm-performance/mono` (new private)
  - `github.com/wrkstrm-components/wrkstrm-kit` (new private, tagged v3.0.0)
  - `study-lab.mac.app` running from DerivedData
- Next:
  - focused-practice cursor doesn't follow keystrokes — reverted my first stab
    (`followCharacterIndex` wiring), root cause still unknown.
  - Replace ugly `study-lab` AppIcon PNGs with the preserved
    `PrepLabSectionGlyph` art.
  - Triage 8 remaining `wrkstrm-app/private/apple/prototypes/` (foundry-todo3,
    foundry-wrkstrm, nightwatch, stacks, system-monitor-d, wrkstrm-beta,
    wrkstrm-catalyst, wrkstrm-macOS).
  - Decide keep/retarget/delete on the orphan `swift-agent-session` cluster.
  - Hunt down `SPM_USE_LOCAL_DEPS=true` shell-init leak (it corrupted SPM
    resolution mid-session and burned ~30 minutes of debug time).

## 2026-04-08 (late evening) - Today (clia-day) Pa-mode V1 → TestFlight upload

See [journal-2026-04-08](articles/journal-2026-04-08.md) (the Late evening
section) for the full chain.

- Context: Build the Today product end-to-end on top of the Collective view
  scaffold and ship a real TestFlight build to rismay's iPad. The mid-session
  correction reframed the customer: Today is for rismay reading AI agent
  end-of-session summaries, not for a literal 62-year-old reader. "Pa" is
  design language, not customer identity.
- Actions:
  - Soft warm theme (paired light/dark warm palette + three personality
    typographies) in `CollectiveTheme.swift`; renderer rewrite in
    `CollectiveCardView.swift`.
  - Pa-mode locked iOS root: Info.plist `RDDefaultCollective: pa` triggers a
    separate body that returns the locked `CollectiveFullScreenView` directly
    as the WindowGroup root — no dev shell, no chrome, no fullScreenCover
    dance, never visible behind anything.
  - PaStory bundled producer surface with `nonisolated(unsafe)` cache for
    `Bundle.main` reads.
  - `scripts/generate-app-icon.swift` — re-runnable Swift CoreGraphics +
    CoreText icon generator. Cream paper + serif terracotta T.
  - `LaunchBackground.colorset` (cream / warm graphite paired) wired through
    `UILaunchScreen`.
  - `PrivacyInfo.xcprivacy` minimal manifest.
  - Bumped iOS deployment 18 → 26 (`LanguageModelSession` stored prop).
  - Resolved stable-vs-unstable SPM graph via local-path overrides in
    clia-day's `packages:` block.
  - Wrapped previous-dev `#warning` Release trace setup in `#if DEBUG`.
  - Reused legacy 2016 ASC slot `com.wrkstrm.ios.app.today` (id `1153239848`,
    "Today: Relive your Favorite Moments") under personal team `BM6B69ZQSR`.
    The `com.wrkstrm.*` prefix is historical naming, not wrkstrm Inc.
  - Archived Release, exported with **`-allowProvisioningUpdates`**
    (REQUIRED — silent failure without it), validated, uploaded via
    `xcrun altool --upload-app -p '@env:VAR'`. Delivery UUID
    `6c11c0f8-d105-40ea-9b78-3e754f3aaaea`.
  - Stored credentials at `~/.appstoreconnect/credentials/com.wrkstrm.ios.app.today.json`
    (chmod 600, dir 700, outside the repo).
  - Saved four memory entries: `user_one-truth-many-lenses`,
    `user_today-app-real-customer`, overhauled
    `project_clia-day-pa-distribution` with concrete identifiers, and
    `project_appstoreconnect-credentials-store` for the credentials convention.
- Artifacts:
  - `clia-app-org` `88f8808` (head); `mono` `c52c29a23c` (head)
  - `/tmp/clia-day-ios-export/clia-day-ios.ipa` (4.9 MB, signed
    `Apple Distribution: Cristian Monterroza (BM6B69ZQSR)`)
  - App Store Connect record `1153239848` ("Today"), version `0.1.0` (1)
- Next:
  - **Producer pipeline** — make the AI agent generate `today-pa.json`
    automatically at end of session. Slash command? Session-end hook?
    Aggregate per-agent slots into one daily card?
  - **App Store Connect API key** — replace the app-specific password with a
    `.p8` saved to `~/.appstoreconnect/private_keys/` so future ships are
    fully scripted with no paste-credential step.
  - **Catalyst host shell layout bug** — `ModernSharedAppShell` overlaps
    columns on the catalyst target; iOS path is unaffected; separate ticket.

## 2026-04-08 - Env profile cutover out of harnesses/clia/ + clia-org build repair + TriadSchemaVersion fix

- Context: Operator opened the session with `/sync >hulk` and asked to make
  hulk the canonical harness so codex and openclaw could "move over." Mid-
  plan-mode, operator caught a category error in my framing: "the header
  harness is for the environment - not for the harness right?" The 521-line
  file at `harnesses/clia/rismay-substrate.header.harness.wrkstrm.json` is
  environment-scoped (operator/org/policy/preferences/realms/terminalogy/
  toolPolicy/directives + a header.defaults block); only one field in the
  whole file is harness-specific (`participants.harness.identity`). The
  "harness" in the filename meant "this is the header rendered at the top
  of every harness session," not "this file belongs to a harness." Hosting
  it under `harnesses/clia/` falsely implied harness ownership.
- Actions:
  - **Plan-mode design**: launched 3 Explore agents in parallel + 1 Plan
    agent to validate the cutover order across submodule boundaries. Final
    plan was a 14-step additive-first cutover.
  - **C0 pre-flight**: verified rismay submodule `.gitignore` won't block
    the new path; confirmed both `cadence.resume.json` files are independent
    (not symlinks); snapshotted unrelated dirty state in 4 submodules
    (wrkstrm-app, schema-universal, codex-agent, hulk) to avoid sweeping
    them up.
  - **C1 → C15**: ran the cutover. Cross-repo file move (no `git mv`
    because it crosses submodule boundaries). Added the new operator-home
    candidate to `HarnessHeaderConfig.candidateLocations` first, then
    landed the file, then migrated every consumer in lockstep with their
    test fixtures, then shrunk the candidate array, then deleted the
    legacy file under explicit per-file confirmation.
  - **Hulk implementation registration**: added codex + openclaw rows to
    `harnesses/hulk/.docc/index.md` Implementations table; created
    skeleton `hulk-compliance.json` files at both harness roots with the
    new `hulk.compliance.v0.1.0` schema (13 clauses B-1..S-7 marked
    `unverified`).
  - **clia-org build repair**: the build had been broken pre-cutover by
    a missing `Agent_Schemas_v000_001_000` package dep. Wired the package
    + product dependencies into CLIACore + CLIAAgentAudit + CLIAAgentTool
    + 2 test targets, added missing imports to 11 source files + 9 test
    files, fixed `LinkRefModel.url` → `urlString` API drift in 4 files,
    bumped 5 stale fixture `schemaVersion` strings.
  - **`TriadSchemaVersion.current` fix**: bumped from `0.1.0` to `0.5.0`
    in `core-triad-schemas-v000-001-000` and rewrote the contradictory
    `// HISTORICAL ... legacy` comment. The constant should always track
    the live wire version; the SPM package name reflects when it was
    first stamped.
- Artifacts:
  - **Source**: `private/universal/substrate/operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json`
    (new home, rismay-operator submodule)
  - **Resolver**: `wrkstrm-core/.../HarnessHeaderConfig.swift` `candidateLocations`
    is now a single-entry array pointing at the new path
  - **Hulk impls table**: `harnesses/hulk/.docc/index.md` (rows for codex
    and openclaw)
  - **Compliance files**: `harnesses/codex/hulk-compliance.json`,
    `harnesses/openclaw/hulk-compliance.json`
  - **Schema fix**: `core-triad-schemas-v000-001-000/sources/.../triad-schema-version.swift`
  - **Plan file**: `~/.claude/plans/linked-skipping-muffin.md`
  - **16 commits across 7 submodules** + several parent mono pointer bumps:
    - rismay-operator: `f1eb4be`, `80f5fc4`
    - wrkstrm-core: `e1e3b36`, `f08bd53`
    - clia-agent-cli (sub-submodule): `3618f12`, `2afd524`, `2d7b37c`
    - clia-org: `84e248ed`, `a8ef1878`, `90f1a10675`, `12df304`
    - wrkstrm-app: `776b8556`
    - codex-agent: `cc73ca0` (auto-committed by hook)
    - cadence-agent: `5c7f3ca1`
    - orchestrators/clia: `0df34a4`, `b29dfb8`
    - hulk: `354f32e`
    - schema-universal: `12df304`, `ff206f6`
    - parent mono: `9d27cffb21`, `1852a20c84`, `5e7ef21d10`, `5441e78767`,
      `05c1c659d8`, `ec7b7fb5eb`, `5b4f15ddb9` plus several
      `chore(submodules):` auto-bumps
- Lessons:
  - **The "harness header" file was always environment-scoped**, not
    harness-scoped. The reframe was the central insight; every cutover
    decision flowed from it.
  - **Additive-first resolver migration is the only safe ordering across
    submodule boundaries.** Never delete the legacy file in the same
    commit as the resolver change — leave it as a safety cushion for
    in-flight sessions holding stale CLI binaries.
  - **The auto-commit workspace hook is doing intelligent commits with
    the `Co-Authored-By` trailer this session.** Different from the
    older `feedback_workspace-auto-commit-hook.md` description (which
    said it omitted trailers). Worth updating that memory.
  - **Cross-repo file moves don't get git rename detection** because git
    can't follow inodes across repo boundaries. Use `git rm` in source +
    `git add` in dest, with a note in both commit messages so future
    readers understand the move wasn't a delete-and-recreate.
  - **`SemanticVersionable` constant naming trap**: a SPM package named
    `core-triad-schemas-v000-001-000` is named for its first SPM-stamped
    version, but the `current` constant inside should always track the
    live wire version. A comment saying `HISTORICAL v0.1.0` paired with
    `static let current = "0.1.0"` describes two opposite states and is
    a bug, not documentation.
  - **`LinkRefModel` API drift between v0.1.0 and v0.2.0**: v0.1.0 has
    `url: String?`, v0.2.0 has `urlString: String` (non-optional). Files
    importing both versions get ambiguous-init errors disguised as type-
    inference failures. Fix at the call site by being explicit, or
    align helper signatures to whichever version the consumed model uses.
- Next:
  - **Participant identity rewire** — flip
    `participants.harness.identity` from `codex@todo3` → `hulk@todo3` and
    rewrite `environmentHarnessMap` codex/openclaw entries to point at
    hulk-flavored identities. Natural follow-up now that the file is in
    the right home.
  - **Witness-suite scaffolding** for hulk implementations — audit each
    of the 13 contract clauses against actual codex + openclaw runtime
    behavior, flip statuses from `unverified` to actual values.
  - **Stale duplicate `## Recent work` heading** in
    `claude-expertise.md` (lines 163 and 220) — leftover from a previous
    merge, worth a separate cleanup pass.
  - **Update `feedback_workspace-auto-commit-hook.md` memory** — observed
    behavior is intelligent + trailer-bearing now. **Done 2026-04-09**:
    rewrote the memory to two-layer framing, see entry below.

## 2026-04-09 - Update workspace-auto-commit-hook memory to two-layer behavior

- Context: Followup #4 from the env-profile cutover winddown article.
  The older `feedback_workspace-auto-commit-hook.md` memory described
  the hook as silently committing unrelated untracked files without
  Co-Authored-By trailers, but this session showed a newer
  intelligent behavior layered on top.
- Actions:
  - Rewrote `~/.claude/memory/.docc/feedback_workspace-auto-commit-hook.md`
    (user-home auto-memory, NOT git-tracked) to a two-layer framing:
    Layer 1 = newer intelligent edit-batching with coherent scope-aware
    messages and Co-Authored-By trailers + automatic submodule pointer
    bumps; Layer 2 = older sweep-unrelated-files behavior, still active.
  - Updated `MEMORY.md` index line 23 to match the new two-layer
    description.
- Artifacts:
  - `~/.claude/memory/.docc/feedback_workspace-auto-commit-hook.md`
  - `~/.claude/memory/.docc/MEMORY.md` (line 23)
- Lessons:
  - Memory entries about *behavior of external systems* go stale fast
    when the user evolves the system. Worth re-checking memory entries
    that describe runtime behavior any time the actual behavior diverges.
  - Even after memory is corrected, the layered behavior means I still
    need to pre-flight submodule dirty state and use specific
    `git add <path>` only — the new Layer 1 doesn't supersede Layer 2.
- Next:
  - Read the actual hook source someday (`core.hooksPath` +
    `.git/hooks/`) — it's been on the followup list for two sessions
    and never picked up.
