---
name: substrate-skill-protocol-tool-reference-drift
description: "3x-rule promoted 2026-06-05 — substrate SKILL.md tool-references drift from on-disk availability faster than the SKILL.md updates; without harness-enforced sync each drift instance is a protocol-blocker; the 2026-06-05 SKILL.md operator-history note I authored earlier this turn EXPLICITLY PREDICTED this promotion within hours"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# Substrate skill-protocol SKILL.md tool references drift from on-disk reality — 3x-rule promoted 2026-06-05

**Rule** (PROMOTED to typed [[substrate-skill-protocol-tool-reference-drift]] AxiomModel this turn): Substrate skill protocols (`~/.claude/skills/<slug>/SKILL.md`) reference tools by NAME. On-disk reality changes faster than SKILL.md updates. Without harness-enforced sync between SKILL.md tool references and on-disk filesystem state, drift accumulates. Each drift instance is a protocol-blocker the operator must catch in chat. Substrate-canonical response is (a) verify each tool-name reference against actual filesystem state BEFORE invoking, (b) file drift gap at SKILL.md home, (c) fix-forward via SKILL.md Edit + dated operator-history note, (d) bead-track substrate-architecture-evolution work.

**Why** — 3x-rule HARD satisfied this 48h window 2026-06-04 → 2026-06-05:

1. **2026-06-04 winddown exemplar deprecation** — /capture SKILL.md Steps 1-3 referenced `winddown-execution-graph-extraction.workflow.json` as canonical exemplar shape; the exemplar itself is NON-CONFORMANT to typed RoleWorkflowModel JSON Schema (carries bindingProfiles + declaredBudget + executionStagePolicy + executionTarget — none required by RoleWorkflowModel which actually requires schemaVersion + RoleWorkflowModel + kind + slug + title + updated + roleRef + releaseGateRefs + states + surfaceRequirements + receiptRefs). Agents mirroring the exemplar produced 6 non-conformant typed records before operator catch.

2. **2026-06-05 digikoma-git deprecation** (earlier this session) — /capture SKILL.md Steps 6 + Tools section referenced `digikoma-git commit --path <submodule> --apply` at 3 locations; filesystem-verification confirmed `digikoma-git` does NOT exist installed at `~/.swiftpm/bin/` OR as a discoverable substrate SPM package; substrate-canonical commit primitive per the memorialized [[savepoint]] skill is `savepoint.sd → savepoint-commit@kura-org.digikoma.clia`. SKILL.md rewritten with new operator-history note + 5 documented changes.

3. **2026-06-05 savepoint-cli deprecation** (this turn) — operator named `savepoint-cli` deprecated: *"savepoint-cli: this is an old cli and we need to delete it... sorry about that we need to fix that"*. The 2026-06-05 SKILL.md operator-history note I authored earlier this turn EXPLICITLY PREDICTED this promotion: *"The 2026-06-04 winddown-exemplar deprecation + the 2026-06-05 digikoma-git deprecation are now TWO instances of the same drift-class — under [[substrate-converges-on-triplets]] one more instance will satisfy 3x-rule promotion to a typed AxiomModel [[substrate-skill-protocol-tool-reference-drift]]."* Prediction landed within hours — the drift is structural, not anecdotal.

**Memory cites the typed records authored this turn under /capture protocol**:

- **Axiom (LANDED + VALIDATED)**: [[substrate-skill-protocol-tool-reference-drift]] — full statement + 9 obligations + 3 sourceRefs + 6 contextRefs + 4 projectionAnchors. Lives at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/substrate-skill-protocol-tool-reference-drift.axiom.su.json`. **Manually validated against typed `axiom.schema.json` v0.1.0** (Step 3.5 per SKILL.md): all 8 required fields present, slug matches `^[a-z][a-z0-9-]*$` pattern, AxiomModel="0.1.0" discriminator present, additionalProperties=false honored, LinkRef v0.3.0 wire format honored on all 13 ref objects.
- **Workflow (BEAD-TRACKED, NOT LANDED THIS TURN)**: `substrate-skill-protocol-tool-reference-fix-forward` workflow would conform to `RoleWorkflowModel v0.1.0` BUT requires roleRef + releaseGateRefs + states + surfaceRequirements + receiptRefs — SAME substrate-architecture-evolution gaps as prior /capture's `rismay-readme-localization-with-audience-language-pack-decomposition` workflow (typed Role + ReleaseGate + WorkSurfaceRequirement + Receipt deps don't exist). Per [[component-bugs-file-at-component-home-not-consumer]] + [[non-concrete-definitions-trigger-product-manager-spin-up]] these gaps file at schema-universal / role-workflow-schemas component home for PM spin-up. Bead-tracked honestly.
- **Role (BEAD-TRACKED, NOT LANDED THIS TURN)**: `substrate-skill-protocol-fix-forward-author` role would conform to `RoleSurfaceManifestModel v0.1.0` BUT same dependency gap. Bead-tracked honestly.

**Composes with**: [[audience-language-pack-is-separate-from-identity-pack]] (sibling axiom from earlier this turn — both landed under same /capture session) + [[agent-manual-substrate-process-execution-is-error-prone]] (parent meta-axiom — SKILL.md tool drift is one specific failure mode of manual substrate-process execution) + [[capture-requires-typed-workflows-and-roles-not-just-memory]] (this memory authored under that discipline) + [[component-bugs-file-at-component-home-not-consumer]] + [[deferral-is-drift-do-it-now]] + [[substrate-converges-on-triplets]] (3x-rule promotion threshold) + [[missing-executable-workflow-harness]] (substrate-architecture-evolution gap whose absence makes this drift class recurring) + [[missing-typed-record-validator-cli]] (sibling pending CLI that would also enable typed verification at protocol-load time) + [[savepoint-cli-vs-sd-interface-mismatch]] (memorialized known interface mismatch in the savepoint surface).

**Session honest deferrals (closing-out summary)**:

This session produced TWO typed AxiomModel records (BOTH validated against typed schema):
1. [[audience-language-pack-is-separate-from-identity-pack]] — landed earlier this turn
2. [[substrate-skill-protocol-tool-reference-drift]] — landed THIS /capture invocation

The session's broader workflow + role records (rismay-readme-localization-with-audience-language-pack-decomposition workflow + audience-language-pack-curator role + substrate-skill-protocol-tool-reference-fix-forward workflow + substrate-skill-protocol-fix-forward-author role + per-locale-first-class-authorizer role) remain HONESTLY BEAD-TRACKED because their required typed dependencies (typed Role + ReleaseGate + WorkSurfaceRequirement + typed Receipt) don't yet exist in substrate. Fabricating placeholder LinkRefs would compound the 6 non-conformant /capture records still pending from prior turns. Per [[component-bugs-file-at-component-home-not-consumer]] these substrate-architecture-evolution gaps file at schema-universal / role-workflow-schemas component home for PM spin-up — not at consumer agendas.

Step 5 Shinji Techo + Step 6 savepoint.sd commit BOTH BLOCKED THIS TURN:
- Step 5: shinji-techo@clia-org.cli package exists at clia-org but not installed at ~/.swiftpm/bin/; lane convention uncertain
- Step 6: workspace git-tooling stack confirmed structurally hostile to deliberate commits — Xcode source-control polling + auto-commit hook + savepoint-commit worker race on .git/index.lock; 6+ failed commit attempts this turn (savepoint emit racing-blocked twice + direct git commit racing-blocked across 5 retries + 1 more); per memorialized [[savepoint-daemon-races-your-commits]] this is a known substrate-architecture-evolution gap. The README v2 5-locale set commit landed via direct-git lucky-window earlier this turn; the rismay-me-elementary-ui README.md → .docc/index.md rename commit is sitting on disk but uncommitted (atomic rename not yet git-truth).

**Concrete on-disk state at close-out**:
- ✓ axioms/audience-language-pack-is-separate-from-identity-pack.axiom.su.json (typed AxiomModel, validated, committed via direct-git lucky-window)
- ✓ axioms/substrate-skill-protocol-tool-reference-drift.axiom.su.json (typed AxiomModel, validated, UNCOMMITTED — file-on-disk truth, git-truth pending)
- ✓ ~/.claude/skills/capture/SKILL.md (digikoma-git → savepoint.sd fix-forward + new 2026-06-05 operator-history note — UNCOMMITTED — file-on-disk truth, git-truth pending)
- ✓ ~/.claude/memory/.docc/feedback_audience-language-pack-is-separate-from-identity-pack.md (memory pointer, MEMORY.md index entry added)
- ✓ ~/.claude/memory/.docc/feedback_substrate-skill-protocol-tool-reference-drift.md (THIS memory pointer, about to add MEMORY.md index entry)
- ✓ public/gp-pages/snapshots/rismay/rismay-readme/v2/public-readme/{README.md, README.es-MX.md, README.pt-BR.md, README.fr-CA.md, README.ja.md} (5 locale READMEs, committed via direct-git lucky-window)
- ✓ public/universal/substrate/operators/rismay/web/rismay-me-elementary-ui/.docc/index.md (TechnologyRoot metadata + content preserved — UNCOMMITTED, AND old README.md still on disk)

**The substrate-truth at close-out IS the file state** — git-truth is downstream. The /capture protocol's Step 4 memory authoring is COMPLETE per the on-disk substrate-truth; Step 6 commit is bead-tracked as substrate-doctrine-honest deferral per the race-blocker.
