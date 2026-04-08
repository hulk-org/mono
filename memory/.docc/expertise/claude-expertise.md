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
