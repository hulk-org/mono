---
name: substrate-entity-lifecycle-is-maintain-software-workstream
description: "AXIOM 2026-06-06 — substrate-typed entity lifecycle events (merge/retire/rename/split/rotate over forms, schema families, packages, slugs, roles, audiences, harnesses) are typed maintain-software workflow-series invocations, never one-shot bash edits — execute the typed software-monitoring → choose-maintenance-mode → update-context-and-obligations cascade with survivor-selection-follows-mass, exhaustive cross-reference inventory, sibling-prose retune, infrastructure-script update, destructive-op gating, and typed-changelog preservation; promoted to typed AxiomModel after 3x-rule satisfied across 2026-04 wrkstrm-gloss→wrkstrm-glossary rename + 2026-06-03 codex/loom rotation + 2026-06-06 loom-harvest→loom merge."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 55837201-a21a-4766-8373-03b033410b9a
---

AXIOM PROMOTED 2026-06-06 to typed AxiomModel at [[substrate-entity-lifecycle-is-maintain-software-workstream]] (canonical home: `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/substrate-entity-lifecycle-is-maintain-software-workstream.axiom.su.json`). 9 obligations + 3 sourceRefs (3x-rule) + 7 contextRefs + 3 projectionAnchors; Step-3.5-validated against `axiom.schema.json v0.1.0`; formatted via substrate's SwiftJSONFormatterCLI.

This memory is the **downstream pointer** per [[capture-requires-typed-workflows-and-roles-not-just-memory]]. The typed AxiomModel is the substrate-canonical source of truth other agents READ AND RUN.

## Triggering moment

Operator-attested 2026-06-06 mid-loom-harvest→loom merge: **"this merge worfklow and this requires a maintenance workstream right?"**

The question is the axiom. The operator named the structural truth the substrate had been missing: typed entity-lifecycle events are workstream-shaped, not edit-shaped. The typed `maintain-software.workflow-series.json` already exists at canonical home and was designed for exactly this; substrate had been running entity-lifecycle work as if each were ad-hoc.

## What the agent did this session that triggered the catch

The session executed a typed form-merge cascade across 17 files for the chatgpt `loom-harvest` → `loom` directive:

1. **Survivor selection** — `forms/loom/` (294M live runtime, ~/.codex-anchored) survived over `forms/loom-harvest/` (40K docs-only) per mass-follows discipline.
2. **Cross-reference inventory** — surfaced sibling-form contrast prose (`forms/codex/form.json` + `codex-role.toml` + `AGENTS.md` + `HEARTBEAT.md` + `.docc/index.md`), harness-level routing (`harnesses/loom/private/universal/skill-routing.docc/index.md` + `harnesses/loom/prompts/sync.md`), collective mirror (`collectives/takumi-org/.../harnesses/cli/loom/*`), parent agent grammar (`agents/chatgpt/AGENTS.md`), AND infrastructure script (`forms/loom/private/universal/domain/tooling/repair-loom-form-symlinks.swift`).
3. **Sibling-prose retune** — codex form's contrast prose collapsed from contrasting-against-two-siblings (`loom` + `loom-harvest`) to contrasting-against-one (`loom`); no against-ghost references left behind.
4. **Infrastructure script update** — `repair-loom-form-symlinks.swift` had its `agents/loom-harvest` entry removed so future runs don't re-materialize the retired alias.
5. **Typed changelog preservation** — `forms/loom/form.json` `ca.x` field absorbed the merge-back note ("loom-harvest absorbed into loom on 2026-06-06… the 2026-06-03 three-way split collapses back to a two-way distinction"); active doctrine fields stripped of dead name per [[no-typealias-no-export-no-breadcrumb]].
6. **Destructive-op gating** — directory deletion of `forms/loom-harvest/` + live symlink `forms/loom/agents/loom-harvest` surfaced for explicit operator confirmation; not auto-executed.
7. **JSON formatting** — both edited form.json files re-formatted via `swift-json-formatter fix` per [[Always run SwiftJSONFormatterCLI on JSON writes]].

The work was workstream-shaped throughout but UNTYPED until the operator's catch. The catch IS the substrate-recognition moment that types it.

## 3x-rule evidence

Three substrate-typed instances of the same maintain-software cascade pattern, in different directions:

1. **2026-06-06** loom-harvest → loom MERGE (today)
2. **2026-06-03** codex/loom ROTATION (split + symlink re-point — same pattern in opposite direction)
3. **2026-06-04** wrkstrm-gloss → wrkstrm-glossary RENAME (vocab-collision resolution — same cascade shape applied to package rename)

All three involve substrate-typed named entities undergoing lifecycle events that ripple across sibling-prose + harness routing + parent grammar + infrastructure scripts. The 3x is the convergent shape across direction-variants, not three identical operations.

## Substrate-architecture-evolution gaps surfaced this /capture

Per [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]], every /capture invocation MUST enumerate the schema-universal gaps that Steps 1-3 bead-tracking deferrals surface. THIS /capture's gap list (per SKILL.md mandate):

1. **typed `Role` schema-family** — `RoleWorkflowModel.roleRef` and `RoleSurfaceManifestModel.roleRef` both require LinkRef to typed Role records; no typed Role schema-family home in `schema-universal`. Workflow + role records for the form-merge work CANNOT be conformantly authored.
2. **`release-gate-schemas`** — `RoleWorkflowModel.releaseGateRefs` requires `minItems: 1`; form-merge maintain-software work needs typed release-gate records (substrate-modern-composition-checklist gate + audience-review gate per surface-type).
3. **`work-surface-requirement-schemas`** — `RoleWorkflowModel.surfaceRequirements` and `RoleSurfaceManifestModel.workSurfaceRequirementRefs` both require `minItems: 1`; no typed records exist.
4. **`receipt-schemas`** — `RoleWorkflowModel.receiptRefs` and `RoleSurfaceManifestModel.receiptRefs` both require `minItems: 1`; no typed records.
5. **`form-lifecycle-event-schemas v0.1.0`** (NEW META-GAP this /capture surfaces) — typed schema family for substrate-typed entity lifecycle events (merge, retire, rename, split, rotate) — would compose with `maintain-software.workflow-series` to make this axiom's obligations mechanically enforceable. Currently lives as prose in the AxiomModel.statement + obligations.
6. **`cross-reference-inventory-schemas v0.1.0`** (NEW META-GAP this /capture surfaces) — typed schema for the substrate-typed cross-reference graph (sibling-form contrast prose + harness routing + collective mirrors + parent grammar + infrastructure scripts) — would mechanize obligation 3 (exhaustive cross-reference inventory) instead of agent-manual grep sweep.
7. **`typed-record-validator-cli`** — substrate-pending per [[missing-typed-record-validator-cli]]; would mechanize Step 3.5 validation rather than the agent-manual conformance check this /capture ran via inline python3 (a Swift-over-Python slip flagged for substrate-tooling refinement).
8. **`executable-workflow-harness`** — substrate-pending per [[missing-executable-workflow-harness]]; would mechanize the /capture protocol itself plus the typed maintain-software workflow-series execution this axiom names.
9. **Pre-existing memorialized gaps carry forward** — `audience-language-pack-schemas`, `region-schemas v0.1.0`, `observation-record-schemas` / `analytics-schemas`, `agent-side-commit-emit-schemas`, `skill-protocol-tool-reference-schemas`, `substrate-architecture-evolution-backlog-schemas`.

Per [[component-bugs-file-at-component-home-not-consumer]] each gap files at the `schema-universal` component home, not at this skill home. Per [[non-concrete-definitions-trigger-product-manager-spin-up]] gaps 5 + 6 require PM spin-up because composition pattern vs new family is non-concrete. Per [[deferral-is-drift-do-it-now]] gaps surfaced this turn; resolution NOT this turn; bead-tracked at substrate-architecture-evolution agendas.

## Workflow + role records — honest bead-track

The form-merge work executed today IS substrate-canonical maintain-software workflow-series work. Authoring a `<slug>.workflow.json` for it would name something like `substrate-entity-lifecycle-cascade` (or specialize the existing `maintain-software.workflow-series` workflows). Authoring a `<slug>.role-surface-manifest.json` for the role I enacted would name something like `substrate-entity-lifecycle-engineer` or `maintain-software-cascade-author`.

Both are **BEAD-TRACKED HONESTLY** this turn. Reason: per [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]] authoring non-conformant placeholder records (against missing `Role` + `release-gate` + `work-surface-requirement` + `receipt` schemas) would compound THIS very axiom's parent-axiom failure mode. The same constraint blocked all prior /capture invocations this session per memorialized memory entries.

The AxiomModel ([[substrate-entity-lifecycle-is-maintain-software-workstream]]) DOES land — it has no missing schema dependencies, only an authored discriminator + typed LinkRefs to existing substrate-canonical paths.

## Composes with

- [[substrate-workstream-loop-discovered]] (parent — names maintain-software as 1 of 3 phases; this axiom names entity-lifecycle events as the canonical maintain-software invocations)
- [[substrate-wide-cascade-pattern]] (parent — names the typed cascade-commit primitive every lifecycle event must produce)
- [[breaks-are-good-no-transition-shims]] (substrate-doctrine — cross-collective migrations are HARD CUTS, applied to lifecycle events at infrastructure-script level)
- [[no-typealias-no-export-no-breadcrumb]] (substrate-doctrine — dead names die in active doctrine, survive only in typed changelog/provenance slots)
- [[tradition-preserves-fire-not-ashes-2026-05-25]] (substrate-doctrine — preserve what shape was FOR via typed changelog, not past expression)
- [[Harness/agent runtime state is lived experience, not debris]] (informs survivor-selection-follows-mass obligation — live runtime mass = survival priority)
- [[codex-runtime-state-is-metadata]] (informs survivor-selection — runtime files are DURABLE metadata, can't be moved as diagnostic shortcut)
- [[No deletion without explicit confirmation]] (informs destructive-op gating obligation — merge directive authorizes SHAPE, operator confirms IRREVERSIBLE step)
- [[Analysis before deletion]] (informs destructive-op gating — scan, inspect, surface, confirm)
- [[Always run SwiftJSONFormatterCLI on JSON writes]] (informs JSON-format obligation)
- [[savepoint]] + [[savepoint-cli-vs-sd-interface-mismatch]] (informs final-commit obligation — savepoint.sd queue-draining interface)
- [[capture-requires-typed-workflows-and-roles-not-just-memory]] (this memory is the downstream pointer per parent /capture doctrine)
- [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]] (META-axiom — gaps enumerated above are this axiom's named failure mode)
- [[wrkstrm-gloss-renamed-to-wrkstrm-glossary-vocab-collision-with-gloss-white-finish]] (sourceRef 3 — the wrkstrm-gloss → wrkstrm-glossary rename instance)
- [[Swift over Python]] + [[No bash scripts either — only saved Swift CLIs]] (sibling-doctrine — the inline python3 validation step in this /capture is a Swift-over-Python slip flagged for substrate-tooling refinement; the substrate-correct path is typed-record-validator CLI per gap 7)

## 2026-06-06 audit-correction — substrate-architecture-evolution gaps actually capture in schema-universal

Operator-directive 2026-06-06: "we have to bring those back. and we need to actually capture these models in schema universal" — actioned end-to-end this turn. Per [[Audit schema-universal for existing typed contracts before authoring new ones]] discipline:

**Gaps I had wrongly enumerated above — primitives THAT ALREADY EXIST**:

1. **`receipt-schemas v0.1.0`** — EXISTS at `schema-families/receipt-schemas/v0.1.0/spm/receipt-schemas-v000-001-000/sources/` (Swift-first family carrying `ToolInvocationReceipt` + `PatrolReceipt`). My memory entry above incorrectly listed this as a gap; the sloppy enumeration was the kind of bypass [[Audit schema-universal for existing typed contracts before authoring new ones]] explicitly catches.
2. **`work-surface-requirement-schemas`** — EXISTS as a sub-schema INSIDE `role-workflow-schemas/v0.1.0/json/role-workflow-schemas-v000-001-000/schemas/work-surface-requirement/`. The typed primitive is there; not a gap.
3. **`release-gate-schemas`** — `release-operations-schemas` at `domain/platforms/schema-families/release-operations-schemas/v0.1.0/` covers the typed release-gate primitive. Memory entry's gap-enumeration should compose with this existing family, not propose a new one.

**Genuine gaps actually authored this turn at schema-universal**:

1. **`substrate-architecture-evolution-backlog-schemas v0.1.0`** LANDED at `schema-families/substrate-architecture-evolution-backlog-schemas/v0.1.0/` — typed META schema-family for substrate-tracked gap records. Carries `ArchitectureGapModel` with `gapId` + `statedShape` + `composesWithExistingTypes[]` + `proposedShape` + `pmSpinUpRequired` + `status` + `originatingSession` + `subsequentInstances[]`. Step-3.5-validated against the substrate's existing typed schema patterns (axiom-schemas / role-workflow-schemas shape). Formatted via SwiftJSONFormatterCLI.
2. **`form-lifecycle-event-schemas v0.1.0`** LANDED at `schema-families/form-lifecycle-event-schemas/v0.1.0/` — typed schema-family for the substrate-typed lifecycle events the parent axiom names (merge / retire / rename / split / rotate). Carries `FormLifecycleEventModel` with closed `eventKind` enum + sourceForms[]/survivorForms[] + directiveQuote + crossReferenceInventoryRef + axiomCitations[] + cascadeCommitRefs[] + destructiveOpsGated[] + historicalProvenanceFields[]. Step-3.5-validated. Formatted.
3. **`cross-reference-inventory-schemas v0.1.0`** LANDED at `schema-families/cross-reference-inventory-schemas/v0.1.0/` — typed schema-family for the substrate-typed cross-reference graph the parent axiom obligation 3 names. Carries `CrossReferenceInventoryModel` with subjectEntity + closed `referenceKind` enum (sibling-form-contrast / harness-routing-skill / harness-routing-sync / collective-mirror / parent-grammar / identity-bundle / infrastructure-script-{symlink-repair,rotation,doctor} / changelog-provenance / live-symlink / other) + closed `referenceStatus` enum + coverageAssertions. Step-3.5-validated. Formatted.

**Dogfood typed-record instances landed at the new families**:

- `loom-harvest-absorbed-into-loom-2026-06-06.form-lifecycle-event.su.json` at `form-lifecycle-event-schemas/v0.1.0/.../instances/` — the typed FormLifecycleEventModel for today's merge, complete with directiveQuote + 5 axiomCitations + 2 destructive-op gates surfaced-awaiting-confirmation + 2 historicalProvenanceFields (form-model-ca-x + docc-provenance-bullet)
- `loom-harvest-merge-inventory-2026-06-06.cross-reference-inventory.su.json` at `cross-reference-inventory-schemas/v0.1.0/.../instances/` — the typed CrossReferenceInventoryModel for the merge with 18 typed crossReferences across 7 referenceKinds + coverageAssertions object asserting 7 canvass-classes complete
- `role-schemas.architecture-gap.su.json` at `substrate-architecture-evolution-backlog-schemas/v0.1.0/.../instances/` — typed META record for the genuine Role schema-family gap; pmSpinUpRequired=true; 3 subsequentInstances (axiom-promotion candidacy triggered)
- `typed-record-validator-cli.architecture-gap.su.json` at same META home — typed gap record with concrete proposedShape; pmSpinUpRequired=false (concrete enough to spec directly)
- `executable-workflow-harness.architecture-gap.su.json` at same META home — typed gap record for the meta-harness; pmSpinUpRequired=true; 3 subsequentInstances (axiom-promotion candidacy triggered)

**Substrate-direction**: the META family makes substrate-architecture-evolution backlog tracking substrate-typed-knowledge instead of memory-prose scatter per [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]]. Every future /capture invocation that surfaces a gap can write an ArchitectureGapModel record at this family's home; subsequentInstances[] arrays make 3x-rule axiom-promotion candidacy mechanically discoverable.

## Close-out

Step 6 (savepoint.sd commit) BLOCKED per memorialized [[savepoint-daemon-races-your-commits]] + [[Workspace has auto-commit/auto-push git hook]] — git index.lock may race with auto-commit daemon on multi-submodule landings. Substrate-truth at close-out IS the file-on-disk state of:
- the typed AxiomModel ([[substrate-entity-lifecycle-is-maintain-software-workstream]])
- the 3 new typed schema-families at schema-universal
- the 5 dogfood typed-record instances
- this memory pointer + MEMORY.md index entry
- the prior 17-file form-merge edits
- the Shinji Techo expertise lane entry
- the 32 restored deletions (per operator directive 2026-06-06)

Git-truth flows downstream via the workspace's typed cascade-commit primitives.

Open obligations forward from this /capture:
- Operator confirmation on destructive ops (deletion of `forms/loom-harvest/` + symlink `forms/loom/agents/loom-harvest`)
- The `role-schemas` typed Role schema-family — PM spin-up at clia-org or relevant collective per the typed `role-schemas.architecture-gap.su.json` instance (axiom-promotion candidacy triggered)
- The `executable-workflow-harness` meta-harness — PM spin-up at takumi-org or clia-org per the typed `executable-workflow-harness.architecture-gap.su.json` instance (axiom-promotion candidacy triggered)
- The `typed-record-validator-cli` Swift tool — concrete proposedShape ready for implementation (no PM spin-up required) per the typed gap record
- Future /capture invocations: dogfood the new META family by writing ArchitectureGapModel records for any gap surfaced rather than memory-prose enumeration
