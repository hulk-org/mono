---
name: harness-canonical-home-clia-org
description: "Substrate harness CLI canonical home is `collectives/clia-org/private/universal/domain/tooling/spm/harness@clia-org.cli`. ONE package, no `-core` sibling — `core` is a subcommand if needed, not a package suffix. The old `wrkstrm-core/private/cross/spm/swift-harness-cli` is RETIRED — don't edit there."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate's canonical harness CLI is **one package**:

`collectives/clia-org/private/universal/domain/tooling/spm/harness@clia-org.cli/`

Product/binary name: `harness@clia-org.cli`. Subcommands (as of 2026-05-26): `contract`, `header`, `environment`, `startup`, `session`, `substrate`, `doctor`. A `core` subcommand may be added when needed.

Naming follows the substrate dotted form-factor vocabulary ([[feedback_substrate-dotted-form-factor-vocabulary]]): `<slug>@<scope>.<form>` — `harness` at `clia-org` as a `.cli` form. Dotted-form-factor suffixes describe **runtime shape** (`.cli`, `.lib`, `.sd`, `.daemon`), not internal layering.

## NO `-core` sibling package — `core` is a subcommand, not a package suffix

**Operator-stated 2026-05-26:** "i don't think the cli is called harness-core it should be harness@clia-org.cli and have a core command, but not in the name."

The currently-existing on-disk `harness-core@clia-org.cli/` sibling package is **misnamed-by-substrate-doctrine**. It contains:
- `sources/harness-core/` — lib targets with the home/identity resolver (`AgentCustomizationWorkbenchPlan.swift`, etc.)
- `sources/harness-cli/` — produces a `swift-harness-cli` binary (the help output shows `USAGE: swift-harness-cli <subcommand>`)

Per doctrine, this sibling should be **absorbed INTO `harness@clia-org.cli`** as internal Swift targets:
- `HarnessCore` (library target) — the resolver/identity/contract code
- The existing `swift-harness-cli` exec consolidated under the canonical `harness@clia-org.cli` product
- `harness-core@clia-org.cli` retired as a separate dotted-form-factor home.

**Reason:** `.cli` describes a runtime shape; `-core` is an internal layering concern that belongs as a module/target name or subcommand, not as a sibling package's slug. Two `.cli` siblings where one is just "the lib for the other" is a doctrine smell — pick a runtime shape per package and consolidate the layering inside.

## Consolidation status (landed 2026-05-26)

**The consolidation has been performed.** `harness-core@clia-org.cli/` was removed and its contents absorbed into `harness@clia-org.cli/`:
- `sources/harness-core/` (lib target `CLIAOrgHarnessCore`)
- `sources/harness-cli/` (exec target `CLIAOrgHarnessCLI` — now produced as `harness@clia-org.cli`)
- `sources/harness-foundation-models-tool/` (lib target `CLIAOrgHarnessFoundationModelsTool`)
- `tests/{harness-core-tests,harness-foundation-models-tool-tests}/`

The `swift-harness-cli` argparse `commandName` is now `harness@clia-org.cli` (matches the binary name). The forwarder source (`sources/harness.cli/main.swift`) is gone. Library product names (`CLIAOrgHarnessCore`, `CLIAOrgHarnessFoundationModelsTool`) were preserved so consumer `import` statements didn't have to change — only Package.swift `path:` / `name:` / `package:` refs needed updates.

**Consumers updated (6 packages, all in clia-org/.../tooling/spm/):**
`agent-v000_009_000@clia-org.cli`, `agent-v000_008_000@clia-org.cli`, `clia-agent-cli`, `clide-v1`, `clide-v1-sre-free`, `swift-active-profile-resolver-cli` — each now declares `path: "../harness@clia-org.cli"` + `name: "harness@clia-org-cli"` and references products via `package: "harness@clia-org-cli"`.

**Pre-existing broken refs preserved (NOT fixed in consolidation PR):** `clide-v1`, `clide-v1-sre-free`, and `swift-active-profile-resolver-cli` reference a library product called `HarnessCore` that has never existed in this package (which only exposes `CLIAOrgHarnessCore`). Those consumers were broken before consolidation and remain broken after — the consolidation was a no-op refactor by scope, so fixing the broken refs is separate cleanup work. The fix is likely `HarnessCore` → `CLIAOrgHarnessCore` in those Package.swifts.

**Build verified 2026-05-26:** consolidated `harness@clia-org.cli` builds clean; live consumer `agent-v000_009_000@clia-org.cli` builds clean; `harness@clia-org.cli header state set --render` produces the same header it did before consolidation.

## Retired path — do not edit

`collectives/wrkstrm-core/private/cross/spm/swift-harness-cli/` and `swift-harness-environment-cli/` USED TO host the harness CLI. They've been retired. Editing those paths after the retirement results in the work being silently wiped when the next substrate-restructure pass commits the deletion.

This-session lesson (2026-05-26): I made a `defaultAgentRef` lookup edit to `HarnessSessionResolver.swift` in the RETIRED `wrkstrm-core` path, built and verified it ran — then a background substrate-restructure deleted the whole source tree, wiping the work. The doctrine (default agent should live on harness identity) survived in memory; the implementation in the retired home did not.

## How to apply

- **When writing/speaking about the harness CLI:** always `harness@clia-org.cli`. Never `harness-core@clia-org.cli`. If you need to refer to internal layering, say "the `HarnessCore` lib inside `harness@clia-org.cli`" or "the `core` subcommand".
- **When proposing new functionality (form resolution, etc.):** land it inside `harness@clia-org.cli`'s product surface. If the `harness-core@clia-org.cli` sibling still physically owns the relevant Swift target, you may need to work there transitionally — but track its consolidation back into the canonical package as part of the deliverable scope, not as separate cleanup work.
- **When invoking via swift run:** point at the canonical `harness@clia-org.cli` package path.
- **When the operator says "the harness CLI" or "the core command":** parse it as `harness@clia-org.cli <subcommand>` — not as a separate `-core`-suffixed binary.
- **DO NOT edit** `wrkstrm-core/private/cross/spm/swift-harness-cli/` or `swift-harness-environment-cli/` — retired, may be wiped.

## Related

- [[feedback_substrate-dotted-form-factor-vocabulary]] — `<slug>@<scope>.<form>` naming and form-factor doctrine
- [[feedback_savepoint-daemon-races-commits]] — background actor on the working tree; same pattern surfaces here
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — the broader factoring this CLI participates in
- [[feedback_codex-is-a-form-of-chatgpt]] — form-resolution work that will land in this canonical CLI
