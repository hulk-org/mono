---
title: clia-tui CLIACore structural brokenness + swiftc 6.2 internal diagnostic bug
date: 2026-04-08
context: CLIACoreModels dedup work
---

# clia-tui CLIACore is structurally broken pre-existing — and triggers a swiftc internal compiler bug

## TL;DR

While migrating clia-tui's harness-header consumers off `CLIACoreModels` as part of the broader CLIACoreModels dedup, discovered that **clia-tui's `CLIACore` target was already broken before any of my changes**. The target's source files (`Merger.swift`, `OriginDeriver.swift`, `TriadSidecarJSONL.swift`) reference types (`AgentDoc`, `AgendaDoc`, `BacklogItem`) that no declared dep on the CLIACore target actually provides. Either the files were copied from `swift-agent-cli-v008` at a prior point and never updated when v008's CLIACore moved to depend on `core-entity-set-v000-008-000` (which exposes `AgentDoc`/`AgendaDoc`/`BacklogItem` via an @_exported chain), or clia-tui's CLIACore has been a known-broken target nobody runs `swift build` against.

The fact that clia-tui still ships in this state suggests either (a) clia-tui is not actively built and is on a deprecation path, or (b) it builds via some other path that hides the brokenness.

## The swiftc internal bug we won

Trigger conditions:

- Package: `clia-org/private/universal/domain/ai/spm/clia-tui`
- File: `sources/core/clia-core/TriadSidecarJSONL.swift`
- Lines: 89, 147, 150
- Code: `try? decoder.decode(BacklogItem.self, from: Data(line.utf8))` where `BacklogItem` is unresolvable
- Build env: `SPM_USE_LOCAL_DEPS=true swift build`, swift-tools-version 6.2

The compiler correctly emits the real diagnostic:

```
error: cannot find 'BacklogItem' in scope
```

Then immediately follows with an INTERNAL compiler bug:

```
error: failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)
```

This second error is an internal failure of the diagnostic infrastructure — the compiler hit the type-not-found error and then crashed trying to produce a follow-up diagnostic for the same expression. Rare but reproducible.

**Worth filing upstream** at swift.org/contributing/#reporting-bugs once we have a minimal repro that doesn't depend on the substrate's full dep graph. The trigger requires a real type-not-found error AND specific generic decoder context (`try? decoder.decode(<UnresolvedType>.self, from: Data(...))`).

## Workaround for the brokenness (not a real fix)

To get clia-tui's CLIACore compiling:

1. Add `core-entity-set-v000-008-000` as a path dep in clia-tui's `Package.swift`
2. Wire it into the `CLIACore` target's deps
3. Add `import CoreEntity_Set_v000_008_000` to:
   - `sources/core/clia-core/Merger.swift`
   - `sources/core/clia-core/OriginDeriver.swift`
   - `sources/core/clia-core/TriadSidecarJSONL.swift`
   - any other CLIACore files referencing `AgentDoc`, `AgendaDoc`, or `BacklogItem`

The first two were applied during this session. TriadSidecarJSONL.swift and possibly other cascading sites still need fixing for the CLIACore target to actually compile.

This is a band-aid, not a real fix. The deeper problem is that clia-tui has a stale copy of CLIACore that diverged from v008 at some point and was never resynced. Either clia-tui's CLIACore should be deleted entirely (clia-tui depends on v008's CLIACore via a path dep), or clia-tui's CLIACore should be brought up to date with v008's structure.

## CLIACoreModels dedup status checkpoint (2026-04-08)

So that we don't lose context: this is where the broader dedup work paused.

### Done

- ✅ **4 narrow packages extracted** in `clia-org/private/universal/domain/tooling/spm/`:
  - `swift-validation-issue-cli` (CLIAValidation library — `ValidationIssue`, `ValidationIssueKind`)
  - `swift-signal-handling-cli` (CLIASignalHandling library — SIGPIPE init shim)
  - `swift-incident-cli` (CLIAIncident library — `Incident`, `IncidentSeverity`)
  - `swift-active-profile-resolver-cli` (CLIAProfileResolver library — `ActiveProfileResolver`, migrated to `WorkspaceContract` from schema-universal `workspace-schemas-v0.5.0` + swift-harness-environment-cli's load extension)
  - All 4 build green standalone
- ✅ **v008/CLIACore: 9 dead `import CLIACoreModels` removed.** Source files no longer reference any CLIACoreModels symbols. Target builds clean.
- ✅ **v008/SwiftAgentCommandsV008: 7 consumer files migrated.** TerminalogyService, ToolUsePolicy, EnvironmentProfiler, HeaderPresenter, ReloadProfileCommand, WorkspaceValidateCommand, CanonicalLayoutCommand all rewritten to import schema-universal types directly (`HarnessHeader_Schemas_v000_003_000`, `Workspace_Schemas_v000_005_000`) + `SwiftHarnessEnvironment` for the load extensions and `HarnessHeaderRenderer` / `HarnessEnvironmentSummary` helpers. `HarnessContract` renamed to canonical `WorkspaceContract`. `HarnessEnvironmentOverview.render` rewritten as inline directives renderer using `HarnessEnvironmentSummary.load`. `HarnessHeaderConfig.renderLines` renamed to `HarnessHeaderRenderer.render`. All `await` removed from sync `.load` calls. Full v008 package builds green.
- ✅ **v008/Package.swift: 3 new path deps added** — `harness-header-schemas-v000-003-000`, `workspace-schemas-v000-005-000`, `swift-harness-environment-cli` — wired into SwiftAgentCommandsV008 target.
- ✅ **Memory rules saved** for future sessions:
  - `feedback_direct-deps-not-transitive.md` — SPM consumers depend on the narrow source-of-truth package per import; never bundle into kitchen-sink super-packages
  - `feedback_no-reexport-typealias.md` — never `public typealias X = OtherPackage.X` to dodge import updates; consumers import the source-of-truth and use canonical names
- ✅ **clia-tui's 7 harness-header consumer files rewritten** in source: TerminalogyService, ToolUsePolicy, WorkspaceValidateCommand, HeaderPresenter (clia-agent-core-cli-commands target); AskCommand, WindCommand (clia-agent-tool target); HeaderIncidentTests (test target). Same migration pattern as v008. clia-tui's `Package.swift` got the 3 new path deps + wiring into CLIAAgentCoreCLICommands, CLIAAgentTool, and CLIAAgentCoreCLICommandsTests targets. Plus a separate fix to clia-tui's stale `swift-directory-tools` path (was pointing at non-existent `swift-directory-tools`, fixed to `swift-directory-tool-cli`).

### Blocked / Deferred

- 🟡 **clia-tui build verification** — partially blocked by pre-existing CLIACore structural brokenness (BacklogItem and other unresolved types in `TriadSidecarJSONL.swift` and possibly more files). My harness-header migration in clia-tui is structurally complete but unverifiable until either (a) the pre-existing CLIACore brokenness is fixed, or (b) we accept the build can't complete and move on with the v008 verification as proof of concept.
- 🟡 **Dead `"CLIACoreModels"` target deps** in v008's Package.swift — `CLIACore` target's dep at line 55 and `SwiftAgentCommandsV008` target's dep at line 91 are now unused (sources don't import CLIACoreModels anymore). They can be dropped without breaking the build. Cosmetic cleanup.
- 🟡 **CLIAIncidentCoreCommands** in v008 still depends on CLIACoreModels for `Incident` type. Migration would be: rewire to import `swift-incident-cli` (which has `CLIAIncident.Incident`). Small change but not yet done.

### Pending

- ❌ CLIACoreModels target deletion (after CLIAIncidentCoreCommands migrates and the target is genuinely orphaned)
- ❌ clia-tui's CLIACoreModels, CLIACore, CLIAAgentCoreCLICommands, CLIAAgentAudit local target dedup (parallel to v008 — same pattern, not started for non-harness-header content)
- ❌ Launchpads + foundry + agent-smoke migrations to direct narrow deps (codex agent-cli launchpad, cadence agent-cli launchpad, foundry's CLIAAgentAudit import, agent-smoke's CLIACore import)
- ❌ clia-agent-cli submodule deletion (after all dependents are migrated)
- ❌ The original task that started all this: roster grammar required field on schema-universal v0.3.0 + canonical JSON + sync SKILL.md update

## Lessons

- **Stale source duplication can hide structural brokenness for a long time.** clia-tui's CLIACore was a copy of v008's CLIACore at some past point. v008 evolved (added core-entity-set dep, updated imports), clia-tui didn't, but nobody noticed because clia-tui wasn't actively built. The dedup work surfaces this kind of latent rot. Future dedup efforts should expect similar findings.
- **`SPM_USE_LOCAL_DEPS=true` and `localOrRemote` patterns can hide path typos.** clia-tui's `swift-directory-tools` path was wrong (should have been `swift-directory-tool-cli`) but the error only surfaced when local resolution was attempted. A package that builds with `false` can be silently broken under `true`.
- **swiftc 6.2 has at least one diagnostic-infrastructure bug** that can be tickled by `try? decoder.decode(<UnresolvedType>.self, ...)` patterns. Worth filing upstream when we have time.
