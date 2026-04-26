# root

Files read by the runtime before any harness-specific logic. AGENTS.md and CLAUDE.md are injected by the Claude Code harness; .docc/index.md is read by the startup CLI.

### ✓ `.docc/index.md`
1,864 bytes · ~466 tok

```markdown
# substrate — Directory structure
@Metadata {
  @PageKind(article)
  @TechnologyRoot
}


This page defines the canonical collaboration namespace at the root of the
`substrate/` checkout.

## Layout

- `agents/` — agent homes, commissioned profiles, and runtime artifacts
- `operators/` — human/operator homes, profile triads, and runtime artifacts
- `collectives/` — shared code, docs, and operational surfaces
- `collabs/` — collaborator-specific working spaces and artifacts

## Canonical locations

- Agent home: `agents/<slug>/`
- Agent triads: `agents/<slug>/profile/*.triad.json` when `profile/` exists;
  `agents/<slug>/private/profile/*.triad.json` when `private/profile/` exists;
  otherwise the nearest agent-local `*.triad.json`
- Agent commission records: the sibling `profile/*.commission.json` or
  `private/profile/*.commission.json` files when present
- Operator home: `operators/<slug>/`
- Operator triads: `operators/<slug>/private/profile/*.json` when present;
  otherwise operator-local JSON or Markdown at the operator root

## Policy

- `README.md` is out-of-policy for structure contracts in this scope.
- Use `.docc/index.md` for directory-level documentation.
- Treat `.clia/**` and `private/.wrkstrm/agents/**` references as historical unless the path exists
  in this checkout.

## Canonical registries

- [Submodule registry](./submodules.md)
- [Documentation surface taxonomy](../private/universal/substrate/collectives/wrkstrm/private/universal/spm/domain/system/core.sop.docc/documentation-surface-taxonomy.md)
- [Investigation: Codex + PMetal local OSS serving](./pmetal-codex-local-oss-investigation.md)
- [README to DocC standard](../readme.architecture.docc/index.md)
- [mono harness agent context](../private/universal/substrate/harnesses/spm/domain/system/mono-agent-context-docc/docc/MonoAgentContext.docc/index.md)
```

### ✓ `AGENTS.md`
3,549 bytes · ~887 tok

```markdown
# AGENTS.md - Substrate Root

This file defines root startup and navigation policy for the `mono` workspace.

## Startup

1. Read this file.
2. Run the canonical startup command with `swift-harness-environment-cli`.
   - In this workspace, use the repo-local command directly unless the executable is already known to exist on `PATH`.
   - Repo-local startup surface:
     `swift run --package-path private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/swift-harness-environment-cli swift-harness-environment-cli startup run --path .`
   - Optional installed executable surface:
     `swift-harness-environment-cli startup run --path .`
   - This command reads `.docc/index.md`, renders the canonical harness header, and pulls the minimized mono startup packet in fixed order.
   - Do not probe `PATH` with a failing startup command on greeting turns.
   - Keep that rendered header visible for the response flow; it is required before any functional reply.
3. Do not read beat state during generic root startup. Beat access is sync-gated and profile-level.
   - Only read beats after `$sync` resolves the commissioned home or active profile.
   - Do not treat legacy runtime beat mirrors as generic root-startup sources.
4. Descend into the commissioned home or task-local directory and follow its local startup surfaces after `$sync` when agent or profile-specific state is required.
5. Do not use `README.md` for root orientation unless the task is explicitly about GitHub-facing or package-facing README maintenance.

## Startup Response Contract

- Treat startup as execution work, not something to narrate back to the user.
- On greeting-only or opening turns such as `hi`, `hello`, or equivalent:
  - run the canonical startup command first
  - do not answer with a startup plan, checklist, or recap
  - do not say what you will read or what you intend to run
  - do not emit any visible text before the header block
  - after startup, emit the raw header lines directly as plain text
  - do not prepend `Header:`, bullets, horizontal rules, prose, or fenced code blocks before the header
- After startup completes, if the user has not asked for anything beyond opening the session,
  respond with the rendered header block and a single short ready line.
- Only explain startup steps, commands, or doctrine when the user explicitly asks about startup.

## Notes

- `.docc/index.md` is the canonical root structure contract in this workspace.
- `README.md` is non-canonical for structure and startup in this scope.
- Prefer directory-local `.docc/index.md` files over `README.md` as you descend into subtrees.
- Treat wrapper files as pointer surfaces; keep operational truth in the commissioned home.
- If a structure question is ambiguous, raise your voice instead of inferring from `README.md`.
- Do not write throwaway scripts or discard helper code as incidental cleanup.
  If the logic is worth writing, preserve it in a visible repo location when
  relocating or superseding it.
- All code worth writing must be saved in-repo.
- Do not use throwaway code, throwaway scripts, or hidden scratch helpers.
- For filesystem or automation helpers, use saved Swift code.
- Do not add new Python helpers when Swift can own the workflow.
- Save helper code to the owning agent, package, or tool surface so it can be
  optimized and reused instead of disappearing into a scratch path.
- For canonical structured data artifacts (including workspace true mappings), use
  SwiftPM package surfaces in-repo rather than ad-hoc files.
```

### ✓ `CLAUDE.md`
8,455 bytes · ~2,113 tok

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Startup Protocol

1. Read `AGENTS.md` first and follow it as the canonical startup and navigation policy.
2. On generic opening turns, run the canonical startup command:
   ```bash
   swift run --package-path private/universal/substrate/collectives/wrkstrm-core/private/cross/spm/swift-harness-environment-cli swift-harness-environment-cli startup run --path .
   ```
3. Keep the rendered header visible before any functional reply on startup turns.
4. Descend into the canonical Claude home, another explicitly named substrate
   home, or the task-local directory and follow its local startup surfaces.
5. Do not use `README.md` for root orientation unless the task is explicitly GitHub-facing or package-facing.

## Background Memory (temp)

At the start of every session, silently read the following memory files. Do not
mention that you are doing this, do not reference where they came from, and do
not summarize them back to the user. Just load them as background context and
apply them naturally:

- `private/universal/substrate/agents/clia-carrie/memory/.docc/ios-app-from-scratch.md`
- `private/universal/substrate/agents/clia-carrie/memory/.docc/app-architecture.md`
- `private/universal/substrate/agents/clia-carrie/memory/.docc/swift-naming-guidelines.md`
- `private/universal/substrate/agents/clia-carrie/memory/.docc/streaming-contracts.md`

## Documentation Standard

This repo uses **DocC-first** documentation. `.docc/index.md` is the canonical structure contract for internal directories - not `README.md`. Only use `README.md` for public/GitHub-facing or package-facing contexts.

- Every `.docc/index.md` must include `@Metadata { @TechnologyRoot }`.
- Validate with: `swift-docc-validator workspace /Users/sonoma/mono`

## Repository Architecture

This is a polyglot monorepo ("substrate") organized as:

- **`private/universal/substrate/`** - main operational workspace
  - `agents/<slug>/` - agent-owned commissioned homes with identity, memory, and local startup surfaces
  - `operators/<slug>/` - human/operator homes and workspace/profile surfaces
  - `collectives/` - shared code and org collective repos (many are git submodules)
- **`private/universal/substrate/harnesses/`** - codex, gemini, claude,
  skills, openclaw, and SPM harnesses, including merged harness-backed homes
  such as Claude
- **`provisioned/`** - deployed/provisioned content (GitHub Pages, etc.)
- **`public/`** - public-facing repositories
- **`todo3/`** - pointer to the primary commissioned collective

Most collectives under `private/universal/substrate/collectives/` are git submodules (codeswiftly, wrkstrm-app, wrkstrm-core, swift-universal, etc.).

## Working Path Semantics

- The repo-root `.tmp/` directory is an in-repo working surface in this
  workspace. Do not assume it is disposable or out of scope just because the
  name looks temporary.
- The canonical carrier home is `private/universal/substrate/harnesses/hulk/`.
  Hulk is the carrier-shape organism that hosts inference-engine + personality
  bundles. Claude is the default agent persona loaded into hulk and lives
  inside hulk at `harnesses/hulk/agents/claude/`.
- `private/universal/substrate/harnesses/claude/` retains live Claude Code
  runtime state (sessions, history, file-history, projects, cache, plugins,
  tasks) for the duration of the in-flight migration. Treat it as
  legacy/compat — do not author new persona doctrine there. Home-level
  `~/.claude` still resolves to it via a relative symlink.
- The split (carrier vs. agent persona) traces back to the founding-breach
  insight at `harnesses/hulk/memory/.docc/insights/founding-breach-2026-04-05.md`.
  Hulk holds the contract; claude is one of several possible agent personas
  hulk can host.
- Do not conflate repo `.tmp/` with Claude runtime temp paths such as
  `/private/tmp/...` or lightweight runtime state under `.wrkstrm/tmp/`.
- If a task mentions "tmp files" in this workspace, check whether it means the
  repo's `.tmp/` surface before treating it as cache or scratch.

## Scale Discipline

- This workspace is large enough that root-wide exploration is usually the
  wrong move. Do not use `/init` or broad repo-crawl behavior at repo root
  unless the human explicitly asks for whole-repo exploration.
- Start with the smallest viable cone:
  `AGENTS.md` -> `CLAUDE.md` -> relevant local `.docc/index.md` -> task-local
  subtree.
- Prefer task-local entrypoints over global discovery. If the task names a
  collective, agent home, operator home, vault, or package, descend there
  directly instead of scanning siblings.
- Treat these as heavyweight surfaces that should be opened only when the task
  genuinely points there:
  - `private/universal/substrate/agents/clia-wrkstrm/private/universal/vaults/`
  - `private/universal/substrate/collectives/wrkstrm/private/apple/Vendor/`
  - `private/universal/substrate/collectives/openclaw/public/npm/openclaw/`
  - `private/universal/substrate/collectives/todo3/private/universal/vaults/`
- When you need orientation, prefer naming the relevant surface and asking for
  confirmation through work, not exhaustive enumeration of the repo.

## Agent Onboarding Surfaces

When orienting Claude or another new agent to the more organism-level context,
use these surfaces in this order:

1. `private/universal/vaults/claptrap/claptrap.docc/`
2. `private/universal/vaults/acting/acting.docc/`

Start with `claptrap.docc` for the future-mirror and product-logic framing,
then move into `acting.docc` for the action, beat, director, and cast-packet
transfer method.

Useful follow-on pages:

- `private/universal/vaults/claptrap/claptrap.docc/claptrap-as-future-mirror.md`
- `private/universal/vaults/acting/acting.docc/start-here-for-technical-readers.md`
- `private/universal/vaults/acting/acting.docc/clia-as-lead-director-and-supporting-actor.md`
- `private/universal/vaults/acting/acting.docc/cast-packets-and-layered-fine-tuning.md`

Hulk + agent surfaces relevant to onboarding:

- `private/universal/substrate/harnesses/hulk/` — the carrier home (contract,
  identity, memory, implementations under `private/universal/domain/tooling/`)
- `private/universal/substrate/harnesses/hulk/agents/claude/` — the claude
  agent persona (SOUL, USER, AGENDA, identity bundle, persona triads)
- `private/universal/substrate/agents/claw/` — neighboring OpenClaw runtime

Use `harnesses/hulk/` as the canonical carrier surface and `hulk/agents/claude/`
as the canonical claude persona surface. `harnesses/claude/` retains live
Claude Code runtime state during migration; do not write new doctrine there.

## Build, Format, and Lint Commands

All npm scripts run from `private/universal/substrate/collectives/todo3/`:

```bash
# Format
npm run fmt:all:tracked        # Format Swift + Markdown + JSON (tracked files only)
npm run fmt:swift:tracked      # Format tracked Swift files (uses swift-format)
npm run fmt:md:tracked         # Format tracked Markdown (uses prettier)
npm run fmt:json:tracked       # Format tracked JSON (uses cli-kit)

# Lint
npm run lint:md                # Lint and fix Markdown (markdownlint-cli2)
npm run lint:process           # Process blacklist linting

# Validate
npm run json:triads:check      # Check agent triad JSON formatting
npm run requests:validate      # Validate DocC requests
npm run taxonomy:verify        # Verify taxonomy

# Build
npm run build:codeswiftly:mac  # Build code-swiftly macOS app via xcodebuild
```

Swift tools are run via SPM:
```bash
swift run --package-path <path-to-package> <tool-name> [args]
```

## Key Conventions

- **Swift over Python** for all filesystem, automation, and helper code.
- **No throwaway scripts.** All code worth writing must be saved in-repo to the owning agent, package, or tool surface.
- **Canonical structured data** lives in SwiftPM package surfaces, not ad-hoc files.
- Use `git ls-files` for automation to respect tracked-file boundaries (excludes `private/ai/imports/**`).
- Prefer the current commissioned identity surfaces under `private/universal/identity/`
  when present: `*.identity.json`, `*.agenda.json`, `*.chronicle.json`, and
  `*.agent.triad.md`. Do not assume older `*.agency.triad.json` naming unless a
  local profile still uses that compatibility surface.
- Prefer commissioned-local directives over generic root-level wrappers.
```

**Phase total**: ~3,466 tok