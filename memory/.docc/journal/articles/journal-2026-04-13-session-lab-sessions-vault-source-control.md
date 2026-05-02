# 2026-04-13 — Session-lab image toolkit, sessions vault unblocked, Source Control submodules + digikoma-plant port

## Context

The S1 incident (OSS adoption blocked by startup and organism drift) had a
concrete blocker: the codex sessions vault couldn't push to GitHub because
multiple rollout files exceeded the 100 MiB per-file limit. session-lab could
detect oversized files but couldn't act on them surgically. Source Control had
no submodule push management.

## Actions

### session-lab inline image management

- **Per-image strip** via regex on raw JSONL lines. First attempt used
  `JSONSerialization` round-trip which inflated files by 4.6 MB (key ordering
  and formatting changes). Fixed by using the same regex pattern as
  `CodexSessionStoreSanitizer.replaceInlineImages`:
  `data:(image/[^;]+);base64,([A-Za-z0-9+/=]+)`.
- **Per-file downscale** via `CodexSessionStoreCompactionSavingsReporter
  .downscaleInlineImages` (JPEG 0.85, 1280px max edge, 256 KB minimum).
  Atomically replaces the original.
- **zstd compression estimate** piped through `zstd --stdout` and byte-counted
  in a streaming loop. Shown in the row metrics and on the Compress button
  label ("Compress (tar.zst) → ~27 MiB").
- **Add to .gitignore** button for rollouts that can't compress under 100 MiB.
- **Open dominant image** moved next to Preview Cleanup with loading/disabled
  state during content analysis.
- **Content analysis preload** from disk cache on startup — eliminates per-row
  loading spinners when the largest-lines preview was already cached.

### Sessions vault unblocked

- `git filter-repo --strip-blobs-bigger-than 100M` removed 12 blobs (largest
  6.4 GB) from history.
- Per-session commits, each under 100 MiB, then force-pushed to GitHub.
- Mono burn-down: digikoma-git applied 11 commits for mono-level files, then
  manual commits inside 19 submodules + pointer bump.

### digikoma-git quoting fix

- `parseGitChangedFile` in `SwiftUniversalGitCore/GitStatusSupport.swift`
  didn't strip double quotes from git's porcelain output for paths containing
  spaces. Added unquoting + backslash unescape. Unblocked burn-down on
  "Touch Up" paths.

### Source Control — Submodules pane

- Discovery via `git config --file .gitmodules --get-regexp` (avoids stale
  worktree failures that broke `git submodule status`).
- Per-submodule ahead/behind via `git rev-list --left-right --count`.
- Push and Reset to Remote actions per row and in inspector.
- Grouped by substrate folder (agents, collectives, harnesses, vaults).
- gitignore filter for repo discovery (`git check-ignore --stdin`).

### Source Control — digikoma-plant visual architecture port

- Replaced `List` + `NavigationLink` sidebar with digikoma-plant's `ZStack {
  LinearGradient; ScrollView { identityCard + routesCard } }`.
- Replaced 3-pane `ModernSharedAppShell` (with inspector) with 2-pane
  `sidebar:` + `detail:`.
- `.windowStyle(.hiddenTitleBar)` eliminated the title bar seam — the gradient
  header IS the window chrome now.
- Amber/brown palette transposed from digikoma-plant's green at matching
  luminance: sign(0.44,0.26,0.13) → signDeep(0.17,0.11,0.08).

## Errors and lessons

- JSON re-serialization inflates files. Regex on the raw string preserves
  exact formatting and only touches the matched payload.
- When told to match an existing app, read the FULL reference root view before
  any edits. Six rounds of color-tweaking failed because the problem was
  structural (List vs ZStack sidebar, 3-pane vs 2-pane, NavigationStack title
  bar), not chromatic.
- `.windowStyle(.hiddenTitleBar)` — one line, solved the title bar seam that
  no amount of gradient tuning could fix.

## Session part 2: digikoma-memory + sandboxed eval runner

### digikoma-memory

New komo at `digikoma-org/private/universal/domain/meta/digikoma-memory/`. Four
commands: audit, cluster, split, reindex. Clustering uses a hardcoded
`(domain, keywords)` lookup table — no model involvement. Applied split
to hulk expertise: 4 domain articles created under
`memory/.docc/expertise/domains/` (git-operations, app-store-shipping,
spm-packaging, ios-macos-frameworks). 50/51 bullets preserved; 1 delta
from multi-line bullet parsing. Root expertise.md rewritten as
lightweight index with `@Links`.

Tracked the FoundationModels judgment upgrade as 0.8.0 universal pattern
in `koma.issues.docc/digikoma-memory-fm-judgment.md` — applies to
digikoma-memory, digikoma-classify, digikoma-need, digikoma-audit.

### Sandboxed eval runner in digikoma-plant

Built `DigikomaSandboxRunner` — generates macOS Seatbelt `.sb` profiles per
run, launches via `sandbox-exec -f`, enforces timeout via
`DispatchSource` timer. Profile: deny-default, restricted write paths,
read-only substrate, network deny. `ResumeOnce` wrapper for Swift 6
`CheckedContinuation` Sendable compliance. Wired into digikoma-plant
Factory > Eval Run lane via `DigikomaEvalRunView`.

## Artifacts

- `wrkstrm-app/.../session-lab/Sources/mac-app/` — 8 files changed
- `wrkstrm-app/.../source-control-by-wrkstrm/Sources/mac-app/` — 3 files
  changed + 1 new (SourceControlSubmodules.swift)
- `swift-universal/.../SwiftUniversalGitCore/GitStatusSupport.swift` — quoting fix
- `codex-sessions` vault — 21 per-session commits, filter-repo, force-pushed
- `digikoma-org/.../domain/meta/digikoma-memory/` — new komo (Package.swift, tool, CLI, tests, spec, katakana files)
- `digikoma-org/.../koma.issues.docc/digikoma-memory-fm-judgment.md` — 0.8.0 upgrade pattern
- `digikoma-org/.../apps/digikoma-plant/Sources/mac-app/DigikomaSandboxRunner.swift` — Seatbelt runner
- `digikoma-org/.../apps/digikoma-plant/Sources/mac-app/DigikomaEvalRunView.swift` — eval UI
- `hulk/memory/.docc/expertise/domains/` — 4 new domain articles from digikoma-memory split
