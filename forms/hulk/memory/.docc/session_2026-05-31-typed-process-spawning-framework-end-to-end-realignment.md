---
name: session-2026-05-31-typed-process-spawning-framework-end-to-end-realignment
description: "SESSION CAPTURE — multi-arc super-attack session realigning the substrate's main process spawning framework (swift-subprocess 0.5 migration + typed ProcessGroupSpec primitive family + DDD-correct clia-ghost-runtime composition + 5-workstream-Package retrofit). ~91 commits across 5 submodule levels."
metadata:
  node_type: memory
  type: project
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

operator 2026-05-31 invoked `/capture` at end of session. This memory is the session-level molecular-composition view; atom-level doctrine entries (referenced below) carry the typed-record specifics.

## Five major arcs landed

1. **Workstream Swift Packages as 3-product family** (early-session continuation): 5 workstream Packages each ship library + `.cli` + `.clia`. Per [[feedback_workstream-package-ships-library-cli-and-clia]] + [[feedback_async-parsable-command-is-axiom]] + [[feedback_clia-is-cli-assistant-form-factor]] + [[feedback_workstream-ghost-chat-protocol-super-attack]].

2. **swift-subprocess 0.5 migration** (mid-session): common-process source migrated from 0.2.x APIs to 0.5 via closure-based `SubprocessExecHolder` refactor. 87/87 common-process tests pass. Per `subprocess-migration.investigation.docc` (typed DocC bundle landed). Bumped `from: "0.2.0"` → `from: "0.5.0"` after operator caught pinning as drift.

3. **Typed ProcessGroupSpec primitive family** (mid-session): 4 typed Swift files in common-process — `SafeGroupAuthority` (Curry-Howard safe-pairing proof) + `ProcessGroupAuthority` + `ProcessTeardownStep` + `ProcessGroupSpec`. Plus 3-page `process-group.investigation.docc`. Per [[feedback_ghost-as-process-group-commander]].

4. **DDD architectural correction** (late-session): operator caught me putting `GhostProcessGroup` inside common-process (Unix-primitive domain); tagged `#axiom`. Renamed types Ghost* → Process* in common-process; authored NEW `clia-ghost-runtime` package in clia-org composing `GhostIdentity` + `ProcessGroupSpec` → `GhostProcessGroup`. Per [[feedback_do-not-break-domain-driven-design]] (#axiom-tagged). 5/5 clia-ghost-runtime tests pass including safe-pairing validation.

5. **Schema family v0.2.0 bump + 4-workstream-Package replication** (closing): common-process-schemas v0.1.0 → v0.2.0 with 5 new typed contract models (ProcessGroupAuthorityModel + SafeGroupAuthorityModel + ProcessSignalNameModel + ProcessTeardownStepModel + ProcessGroupSpecModel) + generable-schemas v0.2.0 variant. Then replicated `.cli` + `.clia` + AsyncParsableCommand + CommonShellArguments pattern across 4 sibling workstream Packages (spawn-software, maintain-software, creative-selection-loop, clia-rpg-spawn-run). 38/38 workstream tests pass across the 5-package fleet.

## Typed-record atoms authored this session (memory entries)

The substrate's typed-doctrine library grew by ~14 entries this session:

1. [[feedback_workstream-ghost-chat-protocol-super-attack]] — workstreams ship typed ghost protocol fed workstream context
2. [[feedback_clia-is-cli-assistant-form-factor]] — `.clia` = conversational CLI form-factor
3. [[feedback_workstream-package-ships-library-cli-and-clia]] — 3-product canonical family
4. [[feedback_typed-primitive-bypass-3x-rule-confirmed]] — search→compose→confirm→author discipline
5. [[feedback_async-parsable-command-is-axiom]] — ArgumentParser CLIs always AsyncParsableCommand
6. [[feedback_common-process-shell-cli-typed-primitives]] — typed family at swift-universal
7. [[feedback_greek-alphabet-tui-axiom-alphabeta-apps]] — α/β/γ labels + one-app-per-letter
8. [[feedback_deferral-is-drift-do-it-now]] — deferral = drift class
9. [[feedback_ghost-as-process-group-commander]] — production-shape ghost = process-group commander
10. [[feedback_do-not-break-domain-driven-design]] (#axiom) — typed primitives live in their bounded context

(Plus pre-existing entries cited and composed: [[feedback_substrate-composes-typed-idea-molecules]], [[feedback_substrate-IS-pokemon-formally]], [[feedback_clia-rpg-trainer-role-power-tool-product-vision]], etc.)

## 3x-rule promotion candidates surfaced

Per [[feedback_substrate-wide-cascade-pattern]] axiom-promotion rule (3+ confirmed instances of a pattern):

- **`typed-primitive-bypass-error`** — confirmed 3 instances this session (md@swift-universal.cli + workstream-ghost-hardcoded-Chat + GhostProcessGroup-in-common-process). Promotable to typed AxiomModel.
- **`substrate-adopts-typed-superset-by-default`** — 3 instances (process-group + closure-escape contract + AsyncParsableCommand). Promotable.
- **`deferral-is-drift`** — 1st formal instance; companion to [[feedback_rehome-not-archive-substrate-cleanup]] + [[feedback_breaks-are-good-no-transition-shims]]. 2 more instances → promotable.
- **`do-not-break-domain-driven-design`** — 1st formal instance (#axiom-tagged). 2 more instances → promotable to typed AxiomModel.
- **`alphabeta-naming-doctrine`** — 1st formal instance. 2 more instances → promotable.

## Cascade-shape across submodule levels

The session's commits cascaded across 5 submodule levels at maximum depth:
`common-process → swift-universal → schema-universal → clia-org → wrkstrm → mono`

Per [[feedback_turn-is-commit]] + [[feedback_substrate-wide-cascade-pattern]] — each substantive turn produced a typed cascade-shape commit at every affected level.

Total: ~91 commits across the session.

## Substrate-typed primitives landed (cross-package)

| Package | New typed surface |
| --- | --- |
| `common-process` (swift-universal) | `SafeGroupAuthority`, `ProcessGroupAuthority`, `ProcessTeardownStep`, `ProcessGroupSpec`, `ProcessSignalName` + `subprocess-migration.investigation.docc` + `process-group.investigation.docc` |
| `common-process-schemas` (schema-universal) | v0.2.0 family with 5 new typed contract models + generable-schemas v0.2.0 variant |
| `clia-ghost-runtime` (clia-org, NEW package) | `GhostIdentity`, `GhostProcessGroup` typed wrapper composing common-process primitives |
| `creative-selection@wrkstrm.workstream` | `.cli` + `.clia` executables with CommonShellArguments + ConversationProtocol_Schemas |
| `spawn-software@wrkstrm.workstream` | Same as above |
| `maintain-software@wrkstrm.workstream` | Same as above |
| `creative-selection-loop@wrkstrm.workstream` | Same as above |
| `clia-rpg-spawn-run@wrkstrm.workstream-instance` | Same as above |

## Operator framing arcs (key quotes)

In sequential order — these quotes capture the doctrinal turns:

- "did you use a ghost protocol?" → surfaced typed-primitive-bypass on first hardcoded Chat
- "this is our GUNDAM x999. our attack weapon" → process-group is the at-the-limit ghost
- "we have a desktop studio app" → led to LM Studio plugin pattern discovery
- "let's see the whole chat() function... we treated the chat to be a bunch of tools below it. it is a whole different conversation format" → surfaced the typed conversation protocol
- "now a workstream comes with a SUPER powered chat ghost protocol we can feed the context to which YOU can talk to!" → workstream-ghost-chat-protocol-super-attack axiom
- "cli tools that you can talk to are .clia - get it a cli ASSISTANT" → .clia form-factor named
- "please, always use AsyncParsable command.... that should be axiom" → AsyncParsableCommand axiom
- "NOOOOOO you should not make drift" → deferral-is-drift class named
- "subprocess is all the way up to 0.5... so going back seems wrong" → migrate forward, not pin back
- "i think it's time to move to 0.5 and just bite the bullet" → migration confirmed
- "we can't let this ROT" → investigation.docc commissioned
- "process group is HUGE. this allows a ghost to add to a process group!" → ghost = process-group commander
- "the ghost process group does not belong in common-process. that might be a clia thing" → DDD violation caught
- "do not break domain driven design. #axiom" → DDD axiom marker

## What capture should ingest next (Shinji Techo lane)

This memory entry IS the molecular-composition view; the atom-level memory entries are already on disk at `~/.claude/memory/.docc/`. For full substrate-typed promotion via Shinji Techo:

1. Project this `.md` + the 10+ session memory entries via `md project new` → typed JSON
2. Ingest via `shinji-techo@clia-org.cli ingest` into the operator-rismay Techo lane
3. Author typed `AxiomModel` instances for the 3x-rule-promotion-candidates listed above
4. Cite the new axioms from the affected workflows (capture-state-execution-graph-extraction.workflow.json, etc.)

Bead-tracked for focused next-session work.

## Open beads at session-end

- `clia-ghost-runtime-schemas` — establish CLIA-substrate schema family for cross-package GhostProcessGroupModel
- `ghost-process-group-typed-primitive-implementation` — CAN CLOSE (landed this session)
- `workstream-ghost-foundation-models-binding` (P2) — Apple FoundationModels Phase 2 binding
- `common-shell-retrofit-blocked-by-common-process-build` (P1) — CAN CLOSE (migration landed)
- `clia-rpg-phase-1-swiftui-read-only-views` (P1) — still open

## Final state — substrate's main process spawning framework

- swift-subprocess at LATEST (0.5; bumped from 0.2.x, 4 months of upstream fixes integrated)
- common-process typed primitive family in place (4 new files, ghost-agnostic)
- common-process-schemas v0.2.0 with cross-package typed contract
- clia-ghost-runtime composes ghost identity + typed primitive (DDD-respecting)
- 5 workstream Packages ship library + .cli + .clia with typed conversation protocol
- 38 cumulative workstream tests pass; 87 common-process tests pass; 5 clia-ghost-runtime tests pass

The substrate's typed-everything investment grew substantially this session. Capture is complete; doctrine is on disk; future sessions inherit the typed graph.
