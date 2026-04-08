# 2026-04-08 — env profile cutover out of harnesses/clia/ + clia-org build repair + TriadSchemaVersion fix

@Metadata {
  @PageKind(article)
  @TitleHeading("Journal")
}

A focused evening session to undo a long-standing category error in the
substrate's environment-profile layout, register codex and openclaw as
hulk implementations on paper, repair the pre-existing clia-org build
break that was masking a missing schema dependency, and fix a
contradictory `TriadSchemaVersion.current` constant that was silently
encoding invalid documents.

## The reframe

The session opened with `/sync >hulk` and an ambitious-sounding ask:
"get hulk harness to be the canonical harness so we can move codex and
openclaw over." My first plan was about moving file ownership between
harness homes — restructuring the resolver candidate list so hulk owns
the canonical path, then registering codex and openclaw as hulk
implementations on paper.

Mid-plan-mode the operator caught the category error:

> the header harness is for the environment - not for the harness right?

Reading the file's actual contents made the answer obvious. The 521-line
`rismay-substrate.header.harness.wrkstrm.json` is an
operator/workspace/environment profile in nine layers (`directives`,
`operator`, `org`, `policy`, `preferences`, `realms`, `terminalogy`,
`toolPolicy`, `git`, `sharing`) plus a `header.defaults` block. **Only
ONE field in the entire 521 lines is harness-specific** — the
`header.defaults.participants.harness.identity` slot inside the rendering
defaults. The "harness" in the filename meant "this is the header
rendered at the top of every harness session," not "this file belongs to
a harness." Hosting it under `harnesses/clia/` falsely implied harness
ownership and made the whole hulk-vs-clia-vs-codex framing nonsensical.

The reframe drove every cutover decision after that point: the file's
new home is the **rismay operator submodule**
(`operators/rismay/private/universal/`), not any harness home.
"Make hulk canonical" then meant something different — hulk is the
canonical *harness shape* (the contract owner at
`harnesses/hulk/.docc/CONTRACT.md`) so codex and openclaw can declare
themselves as hulk implementations under that contract. The file move
and the implementation registration are two separable concerns.

## The cutover plan

Designed via plan-mode + 3 parallel Explore agents + 1 Plan agent. The
key constraints:

1. **Cross-repo file move.** Source is parent-mono-tracked
   (`harnesses/clia/`), destination is in the rismay-operator submodule.
   Git can't follow inodes across repo boundaries, so `git mv` doesn't
   work. Use `git rm` in source + `git add` in dest.
2. **Additive-first resolver.** `HarnessHeaderConfig.candidateLocations`
   in wrkstrm-core is an ordered `[String]` array — first existing file
   wins. Extend to `[new, legacy]` BEFORE moving the file, so both paths
   work during the transition window. Shrink to single-entry only after
   every consumer has migrated.
3. **Never delete the legacy file in the same commit as the resolver
   change.** In-flight codex/hulk sessions may hold stale CLI binaries.
   Leave the legacy file in place as a safety cushion until a final
   confirmed cleanup commit.
4. **Submodule commits in dependency order.** rismay-operator must accept
   the new file BEFORE wrkstrm-core's resolver bumps land in the parent,
   so the resolver finds the file when it tries the new candidate first.
5. **Specific `git add` only** in submodules with unrelated dirty state
   (wrkstrm-app had 19 unrelated items at the start, hulk had 10,
   schema-universal had 4 + an untracked WIP file). Never `git commit -a`
   in those.

The final plan was 14 named commits across 7 submodules + 3 parent mono
bumps + 1 user-home edit + 1 confirmed deletion.

## The execution chain

### C0 — Pre-flight (read-only)

- Verified rismay submodule `.gitignore` doesn't block the new path
  (exit 1 from `git check-ignore`).
- Confirmed both `cadence.resume.json` files (parent mono +
  cadence-agent submodule) are independent files, not symlinks (need
  separate edits).
- Verified destination directory exists with `workspace.wrkstrm.json` as
  expected sibling.
- Snapshotted unrelated dirty state in wrkstrm-app (19), schema-universal
  (4 + 1 untracked WIP), codex-agent (2), and hulk (10) so I'd know what
  NOT to sweep up.
- Decided to skip schema-universal investigation md edit because the file
  was untracked WIP (someone's in-progress work).

### C1 — rismay-operator submodule: land the new file

```
cp harnesses/clia/rismay-substrate.header.harness.wrkstrm.json \
   operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json
diff -q  # byte-identical
git -C operators/rismay add private/universal/rismay-substrate.environment.wrkstrm.json
git -C operators/rismay commit
```

521 lines of byte-identical content at the new home. No content edits in
this commit — the participant identity rewire is a separate future pass.
Commit `f1eb4be`.

### C2 — wrkstrm-core: resolver + tests + display literals

`HarnessHeaderConfig.swift` `candidateLocations`: extended from
`["private/universal/substrate/harnesses/clia/...header.harness..."]` to
`["private/universal/substrate/operators/rismay/private/universal/...environment...", "private/universal/substrate/harnesses/clia/...header.harness..."]`
with the new path first.

`main.swift` lines 580, 624, 733: display literals for `header validate`,
`header show`, and the title-show fallback path string updated to the
new filename.

All 17 SwiftHarnessEnvironmentTests fixture-write paths and assertions
updated in lockstep so tests don't silently rely on the legacy fallback.
Used `replace_all` for the directory string + the filename string
patterns. The negative test
`harnessHeaderConfigRequiresOrchestratorLevelArtifacts` still verifies
that legacy non-substrate paths are rejected — its fixture path
intentionally doesn't match the new resolver candidate.

`swift test` → 17/17 pass. Commit `e1e3b36`.

### C3 — Parent mono: first bump + retirement marker + mono-tracked docs

Bumped rismay + wrkstrm-core submodule pointers. Added
`harnesses/clia/README.md` as a forwarding-pointer retirement marker.
Updated mono-tracked docs:

- `harnesses/skills/sync/SKILL.md` line 21 + surrounding "harness-header"
  → "operator environment profile" prose
- `harnesses/AGENTS.md` line 21 + softened "when present"
- `harnesses/codex/prompts/sync.md` line 12
- `private/universal/resumes/cadence.resume.json` line 19

**Did NOT delete the legacy file** — left as safety cushion for
in-flight sessions. Commit `9d27cffb21`.

Verification: `swift-harness-environment-cli header locate --path .`
returns the new operator-home path.

### C4 — clia-org submodule: consumers + broken tests

`EnvironmentProfiler.swift` fallback literal in clia-agent-cli + the
swift-agent-cli-v008 copy. clia-agent-cli tests:
`OperatorWorkspaceActivationTests`, `HeaderIncidentTests`,
`HeaderOpinionTests`. clia-tui tests `HeaderIncidentTests` and
`HeaderOpinionTests` were currently broken (using non-substrate paths
that the resolver doesn't know) — fixed to the new operator-home path.

Hit a snag: a `git stash --include-untracked` from parent mono recursed
into the nested clia-org submodule and stashed my edits there. Popped
the stash to restore them. The clia-agent-cli sub-submodule (a
sub-submodule of clia-org) kept its own working tree state separately.

Two commits: `3618f12` (clia-agent-cli sub-submodule) + `84e248ed`
(clia-org parent).

### C5 — wrkstrm-app: source-control filter literal

`SourceControlWorkspaceOverview.swift` line 319 commit-plan filter
literal — the "Harness doctrine and header rules" bucket filtered on the
old path. Updated to the new path. Single-line edit. Commit `776b8556`.

### C6 — codex-agent: 6 boot/identity surfaces

`AGENTS.md`, `BOOTSTRAP.md`, `codex@rismay.substrate.identity.json`,
the compact + full system-instructions triads, and the persona triad
(2 occurrences). Skipped historical/mirror surfaces (chronicle.json,
beat-journal.md, both mirror.docc copies).

The auto-commit workspace hook fired and committed these as
`cc73ca0 env(codex): cutover references to operator environment profile path`
with my Co-Authored-By trailer preserved — different from the older
memory description of the hook silently committing without trailers.

### C7 — cadence-agent: identity + resume

`cadence@rismay.substrate.identity.json` link entry +
`cadence.resume.json` highlight. Skipped the chronicle (append-only
history). Renamed the link title from "mono harness-header" to "mono
operator environment profile" to reflect the corrected scope.
Commit `5c7f3ca1`.

### C8 — orchestrators/clia: 3 doctrine mirrors

The
`agents-env-harness-header-sync-surfaces-2026-03-27.md` doc exists in 3
places (live expertise + 2 mirror.docc copies). All 3 had the legacy
non-substrate path. Updated each with the new path + a parenthetical
"(path updated 2026-04-08; environment profile moved out of
harnesses/clia into rismay operator home)" to preserve the historical
narrative.

Auto-commit hook split this into two commits: `0df34a4` (the live
expertise doc) + `b29dfb8` (the 2 mirror copies).

### C9 — hulk: memory note + Implementations table

`memory/.docc/user_harness-hulk-claude.md` — updated the path + rewrote
the prose to reflect post-cutover state. The note still flags that the
env profile's `participants.harness.identity` hardcodes `codex@todo3` as
the reason hulk-hosted sessions render a misleading harness line — that
participant rewire is the next pass and was deliberately out of scope.

`.docc/index.md` Implementations table — added two new rows:

```markdown
| `codex` | embedded in rismay/mono@`harnesses/codex` (vendoring `github.com/openai/codex`) | Newly registered 2026-04-08; all clauses unverified — see `harnesses/codex/hulk-compliance.json` |
| `openclaw` | embedded in rismay/mono@`harnesses/openclaw` (relates to `github.com/openclaw/openclaw`) | Newly registered 2026-04-08; all clauses unverified — see `harnesses/openclaw/hulk-compliance.json` |
```

CRITICAL: hulk submodule had 10 unrelated working-tree items I had to
NOT sweep up. Used explicit `git add .docc/index.md memory/.docc/user_harness-hulk-claude.md`,
verified with `git diff --staged` before commit. Commit `354f32e`.

### C11 — Parent mono: second bump + new compliance files

Created `harnesses/codex/hulk-compliance.json` and
`harnesses/openclaw/hulk-compliance.json` with the
`hulk.compliance.v0.1.0` schema:

```json
{
  "schemaVersion": "hulk.compliance.v0.1.0",
  "hulkName": "codex",
  "hulkRepo": "embedded in rismay/mono@private/universal/substrate/harnesses/codex",
  "contractVersion": "0.1.0",
  "contractUrl": "private/universal/substrate/harnesses/hulk/.docc/CONTRACT.md",
  "assessedAt": "2026-04-08",
  "assessedBy": "unverified",
  "overallStatus": "unverified",
  "clauses": {
    "B-1": { "name": "Identity Loading", "status": "unverified", "notes": "TODO: ..." },
    /* B-2..S-7 */
  },
  "breaches": [],
  "remediationPlan": "Initial skeleton — all clauses marked unverified pending witness-suite run and operator audit."
}
```

Status enum: `unverified | partial | compliant | breached`.
`overallStatus` rollup rule: worst-of-all-clauses. Commit `1852a20c84`.

### C12 — wrkstrm-core: resolver shrink

After every consumer was on the new path, shrunk
`HarnessHeaderConfig.candidateLocations` from `[new, legacy]` to `[new]`.
All 17 wrkstrm-core tests still pass (fixtures were already migrated in
C2). Commit `f08bd53`.

### C13 — Parent mono: third bump

Bumped wrkstrm-core pointer to pull in the resolver shrink. Commit
`5e7ef21d10`.

### C14 — User-home skill

`~/.claude/skills/sync/SKILL.md` was already updated by an external sync
process (file isn't a symlink but had the new path content). No-op
verification only.

### Post-C14 — Self-referential directive checklist fix

Grep verification surfaced that the new env profile's OWN
`directives.sync.checklist[0].text` still pointed at the old path. The
file moved but the embedded directive instruction inside it didn't.
Fixed in a follow-up commit (`80f5fc4` in rismay-operator + `5441e78767`
parent bump).

### C15 — Confirmed deletion of legacy file + directory

Operator authorized full retirement of `harnesses/clia/`. `git rm` both
the legacy JSON and the README.md retirement marker. The directory has
no other tracked contents and is removed implicitly. Commit `05c1c659d8`.

### Schema-universal followup — investigation md (commit `12df304` + bump `ec7b7fb5eb`)

The schema-universal investigation md `root-schema-set-manifest-investigation.md`
referenced the old path as a "wrong-scope" example. After operator
confirmation, updated the prose to point at the new operator-home path
and added a parenthetical noting the 2026-04-08 cutover. Preserved the
investigation narrative that the file is still wrong-scope for a root
schema-set declaration.

## clia-org build repair

Operator asked for option 3 from the followup list: fix the pre-existing
`Agent_Schemas_v000_001_000` missing module error in
`CommissionedProfileDocuments.swift` that had been blocking
clia-agent-cli + clia-tui tests for the entire env-profile cutover.

Root cause: the CLIACore target depended on `Agency_Schemas_v000_005_000`
and `CoreTriad_Schemas_v000_001_000` but NOT on `Agent_Schemas_v000_001_000`
(which wasn't even a package dep) or `Agenda_Schemas_v000_001_000` (which
was a package dep but not a target product dep).

Wired both into the Package.swift across CLIACore + CLIAAgentAudit +
CLIAAgentTool + CLIAAgentCoreCLICommandsTests + CLIAAgentAuditTests.
Added the missing imports to **11 source files**:

- `CommissionedProfileDocuments.swift` (the original error site)
- `Merger.swift` (used `AgentDoc` without importing)
- `BackupCleanupCommand.swift` (used `AgentDoc` + `AgendaDoc` without importing)
- `AgentDocCCommandGroup.swift` (used `AgentDoc` without importing)
- `AgentNormalizeCore.swift` (used `AgentDoc` without importing)
- `RecoveryCommand.swift` (used `AgentDoc` + `AgendaDoc` without importing)
- `ProfilesCommand.swift` (used `AgentDoc` + `AgendaDoc` without importing)
- `CLIAAgentAudit.swift` (used `AgentDoc` + `AgendaDoc` without importing)
- `AgendaNormalizeCore.swift` (used `AgendaDoc` without importing)
- `TriadNormalizeCoreV070.swift` (used `IdentityModel.links` which exposes
  v0.2.0 LinkRefModel; needed `import LinkRef_Schemas_v000_002_000` and
  also a closure body rewrite)
- `ConversationCommand.swift` (LinkRefModel `.url` → `.urlString`)

And **9 test files**: TriadDecodingTests, TriadDecodingExtensionsTests,
RosterCommandTests, TriadsAgentNormalizeTests, TriadsAgendaNormalizeTests,
TriadsMirrorAggregateTests, CLIAAgentAuditTests, ModelsDefaultsTests,
AgentDocCGenerateTests.

### LinkRefModel API drift

`LinkRef_Schemas_v000_001_000.LinkRefModel` has `url: String?`.
`LinkRef_Schemas_v000_002_000.LinkRefModel` has `urlString: String`
(non-optional). Files importing both versions get ambiguous-init errors
disguised as type-inference failures. Fixed in 4 places:

- `AgencyLogCore.swift` line 138: `LinkRefModel(title:, url:)` → `(title:, urlString:)`
- `ConversationCommand.swift` lines 154, 156: same pattern, both occurrences
- `AgencyLogCommandTests.swift` line 140: `$0.url ?? ""` → `$0.urlString`
- `AgentNormalizeCore.swift` `sortLinks` + `equalLinks` helper signatures
  were typed for v0.2.0 but operated on v0.1.0 LinkRefModel via
  `AgentDoc.links` — switched the helpers to v0.1.0 to match the
  consumed type
- `TriadNormalizeCoreV070.swift` closure body — `lhs.url?.lowercased()` was
  on v0.2.0 LinkRefModel where url is non-optional and renamed to
  urlString; rewrote to `lhs.urlString.lowercased() < rhs.urlString.lowercased()`

### Test fixture schemaVersion bumps

5 header tests across clia-agent-cli + clia-tui wrote
`"schemaVersion": "0.2.0"` fixtures, which the current
HarnessHeaderConfig schema only accepts as `0.3.0`. Bumped each fixture
string. After this, 8/8 header tests pass and the build is fully green.

## TriadSchemaVersion fix

Final test failure: 3 tests in `TriadSchemaLoaderTests.testSchemaVersionConst`
asserting that `info.allowedSchemaVersions.contains(TriadSchemaVersion.current)`.
The actual values:

- agent: `["0.4.0", "0.5.0", "0.3.0"]` vs `current = "0.1.0"` ❌
- agency: `["0.5.0", "0.3.0", "0.4.0"]` vs `current = "0.1.0"` ❌
- agenda: `["0.5.0", "0.3.0", "0.4.0"]` vs `current = "0.1.0"` ❌

Operator pointed out the contradiction: the file containing the constant
had a comment `// HISTORICAL v0.1.0: preserved legacy schema surface` —
contradictory because a constant named `current` cannot also be marked
historical. The file lives in `core-triad-schemas-v000-001-000` (the
v0.1.0 SPM package), but the constant is named for what it represents
(the current wire version), not for the SPM package version.

Verified the live wire version: the active
`triads.{agent,agency,agenda}.schema.json` files all require
`schemaVersion: "0.5.0"`. Bumped the constant from `"0.1.0"` to `"0.5.0"`
and rewrote the comment:

```swift
// Tracks the live wire version of the triad schemas advertised under
// `.wrkstrm/schemas/triads/`. The SPM package is named
// `core-triad-schemas-v000-001-000` because that was its first stamped
// version, but the constant inside always points at whatever the active
// triad schemas advertise (currently `0.5.0`).
//
// Bumping rules:
// - When the JSON schemas under `.wrkstrm/schemas/triads/` move to a
//   new version, update `current` here in lockstep.
// - Callers (Merger fallbacks, BackupCleanupCommand, ProfilesCommand
//   warning chain) read this constant to encode/validate triad
//   `schemaVersion` fields, so leaving it stale silently encodes
//   invalid documents.
public enum TriadSchemaVersion: Sendable {
  public static let current = "0.5.0"
}
```

This fix unblocked **3 silent runtime bugs** that were masked by the
broken constant:

1. **Merger fallback chain** (3 sites): missing-`schemaVersion` docs
   defaulted to `"0.1.0"` (instantly invalid for any consumer). Now
   defaults to `"0.5.0"` (valid).
2. **BackupCleanupCommand**: cleanup output set `schemaVersion` to
   `"0.1.0"` (rejected by every active schema). Now sets `"0.5.0"`.
3. **ProfilesCommand warning chain**: warned on every doc whose
   `schemaVersion ≠ "0.1.0"` — basically every doc in the substrate.
   Now only warns on actual mismatches.

After this fix the full clia-agent-cli test suite is **117/117 green**
(was failing-to-build → 114/117 → 117/117).

## Final state

| Surface | State |
|---|---|
| `operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json` | New canonical home |
| `harnesses/clia/` | **Deleted** (legacy file + retirement marker README + empty directory) |
| `HarnessHeaderConfig.candidateLocations` | Single entry pointing at the new path |
| `harnesses/hulk/.docc/index.md` Implementations table | 4 rows: claude-code, claw-code, codex, openclaw |
| `harnesses/codex/hulk-compliance.json` | New, all 13 clauses `unverified` |
| `harnesses/openclaw/hulk-compliance.json` | New, all 13 clauses `unverified` |
| `TriadSchemaVersion.current` | `"0.5.0"` (was `"0.1.0"`) |
| clia-agent-cli build | Green (was failing-to-build) |
| clia-agent-cli tests | 117/117 (was 0 / failing-to-build → 114/117 → 117/117) |
| wrkstrm-core SwiftHarnessEnvironmentTests | 17/17 |

## Open follow-ups

1. **Participant identity rewire** — flip
   `participants.harness.identity` from `codex@todo3` → `hulk@todo3` and
   rewrite `environmentHarnessMap` codex/openclaw entries to point at
   hulk-flavored identities. Natural follow-up now that the file is in
   the right home.
2. **Witness-suite scaffolding** for hulk implementations — audit each
   of the 13 contract clauses against actual codex + openclaw runtime
   behavior, flip statuses from `unverified` to actual values.
3. **Stale duplicate `## Recent work` heading** in `claude-expertise.md`
   (lines 163 and 220) — leftover from a previous merge, worth a
   separate cleanup pass.
4. **Update `feedback_workspace-auto-commit-hook.md` memory** — observed
   behavior this session was intelligent + trailer-bearing, different
   from the older memory description.
