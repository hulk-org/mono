---
name: sibling-composite-pattern-for-generable-types
description: Substrate-canonical sibling-composite @Generable pattern PROMOTED 2026-06-05 to typed AxiomModel after 3x-rule satisfied IN A SINGLE SUBSTRATE-PACE SESSION across three substrate-architecture instances; memory entry is downstream POINTER to the typed axiom + the 3 typed instances
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2f6e8d5d-6c57-48a2-9fee-ab4870aa2a2f
---

**SUBSTRATE-CANONICAL SIBLING-COMPOSITE @GENERABLE PATTERN — when authoring a substrate @Generable type that must compose with substrate-typed metadata (LinkRefModel, UUIDs, timestamps, typed enums), split into TWO typed contracts: (1) @Generable narrow type carrying ONLY fields the LM generates from input + (2) sibling Codable composite wrapping the @Generable result + substrate-side metadata. Promoted to typed AxiomModel 2026-06-05 after 3x-rule satisfied IN ONE SESSION.**

**Why:** Apple's `@Generable` macro auto-generates `init(_ content: GeneratedContent) throws` calling `content.value(forProperty:)` for every field; each field type must conform to `FoundationModels.ConvertibleFromGeneratedContent`. Substrate-foundational types (LinkRefModel from link-ref-schemas v0.3.0, UUIDs, ISO timestamps, typed enums) don't conform — and shouldn't be FORCED to. Forcing `link-ref-schemas` (consumed by HUNDREDS of substrate packages) to import FoundationModels for one consumer's @Generable contract is a substrate-doctrine VIOLATION of [[do-not-break-domain-driven-design]]. The sibling-composite split solves this structurally: @Generable narrow type lives in its own struct (only primitive/array-of-primitive fields); Codable composite wraps it + carries substrate metadata; both ship in the same schema-family.

**How to apply:**
1. Define the @Generable narrow type with ONLY LM-generated fields (primitives + arrays of primitives). Apply `@Guide(description:...)` annotations.
2. Define the sibling Codable composite that embeds `content: <GeneratedContentType>` + adds substrate metadata (LinkRefModel pointers, UUIDs, ISO timestamps, typed enums).
3. Both wrapped in `#if canImport(FoundationModels)` / `#else` to provide the same data shape at lower-platform-availability builds.
4. `Package.swift` platform minimums encode the FoundationModels-availability requirement (macOS 26+/iOS 26+/etc.) — no per-type `@available` annotations needed.
5. Typed availability sentinel (`*FoundationModelsAvailability { .available | .unavailable | .notYetQueried }`) per schema family per [[Open-extensible catalogs require three-valued logic — UNKNOWN is first-class]].

Memory cites typed AxiomModel [[sibling-composite-pattern-for-generable-types]] (9 obligations + 3 sourceRefs + 8 contextRefs + 4 projectionAnchors). The 3x-rule instances ALL shipped in the same session:

1. [[concourse-fr-port-002-generable-linkref-conformance]] (this session) — substrate's FIRST encounter with the `@Generable + LinkRefModel` conformance error; discovery + resolution that named the sibling-composite pattern
2. session-summary-schemas v0.1.0 (this session, FR-PORT-002 ship) — substrate's FIRST canonical Apple Foundation Models @Generable contract, sibling-composite pattern, BUILD-GREEN + 4/4 TEST-GREEN. SessionSummaryGeneratedContent (narrow @Generable) + SessionSummaryModel (Codable composite with laneRef LinkRefModel)
3. launch-review-feedback-schemas v0.1.0 (this session, operator-named substrate-shadowing direction) — substrate's SECOND canonical @Generable contract using sibling-composite + typed-submitter-enum extension (.operatorSubmitter / .agent / .digikoma), BUILD-GREEN + 5/5 TEST-GREEN. LaunchReviewFeedbackGeneratedContent (narrow @Generable) + LaunchReviewFeedbackModel (Codable composite with packetRef LinkRefModel + typed LaunchReviewFeedbackSubmitter enum)

Composes with [[apple-generable-canonical-architecture]] (parent — names @Generable as substrate-canonical Swift expression of one-type-many-projections) + [[do-not-break-domain-driven-design]] (companion — foundational substrate packages must not take consumer-driven deps; sibling-composite enforces this) + [[same-shape-same-model]] (substrate-doctrine that this pattern instantiates structurally — distinct names for narrow @Generable vs composite because composite adds fields the narrow type cannot) + [[substrate-apple-first-then-cross-platform-2026-05-26]] (Apple Foundation Models binding at package contract layer) + [[shadowing]] (substrate's typed alignment loop; launch-review-feedback-schemas typed-submitter-enum is the structural extension that makes substrate-shadowing training corpus substrate-scoring-comparable) + [[Open-extensible catalogs require three-valued logic — UNKNOWN is first-class]] (typed availability sentinel per @Generable-bearing schema family) + [[content-lives-in-its-owners-home]] (both narrow + composite live at schema-universal canonical home) + [[lift-existing-patterns-not-reimplement]] (instance 3 lifted the pattern from instance 2 within the same session) + [[Audit schema-universal for existing typed contracts before authoring new ones]] (pre-authoring audit discipline) + [[apple-generable-canonical-architecture]] + [[capture-requires-typed-workflows-and-roles-not-just-memory]] (typed-record-first discipline). Substrate-direction: every future substrate @Generable schema family inherits this pattern.

## Schema-universal gaps surfaced by this /capture invocation

Per SKILL.md doctrine — /capture invocations that bead-track workflow + role records reveal substrate-architecture-evolution gaps. This /capture honestly bead-tracks workflow + role authoring because typed dependencies don't yet exist; gaps enumerated below per the SKILL.md `## Schema-universal updates surfaced by /capture` discipline:

**Bead-tracked workflow (NOT authored conformantly this turn):**
- `substrate-typed-generable-schema-family-authoring.workflow.json` — typed multi-step workflow for authoring sibling-composite @Generable schema families. Blocked on substrate-architecture-evolution gaps:
  - typed `Role` schema-family (gap #1 from SKILL.md gap-list) — workflow's `roleRef` requires it
  - `release-gate-schemas` (gap #2) — workflow's `releaseGateRefs` requires `minItems: 1`
  - `work-surface-requirement-schemas` (gap #3) — workflow's `surfaceRequirements` requires `minItems: 1`
  - `receipt-schemas` (gap #4) — workflow's `receiptRefs` requires `minItems: 1`
- Same gap-set memorialized in prior session-2026-06-05 /capture invocations ([[audience-language-pack-is-separate-from-identity-pack]] + [[substrate-skill-protocol-tool-reference-drift]] + [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]]).

**Bead-tracked role (NOT authored conformantly this turn):**
- `generable-schema-family-author.role-surface-manifest.json` — role inhabited by substrate-agents (and eventually substrate-digikoma per [[shadowing]]) that authors sibling-composite @Generable schema families. Blocked on:
  - typed `RoleSurfaceManifestModel` JSON Schema search-or-gap-file (SKILL.md Step 2 — "search schemas-universal; if absent, this is a substrate-gap to file at the schemas home before authoring")
  - typed `Role` schema-family same as workflow blockers above

**Additional schema-universal gap NEWLY surfaced this session:**
- typed `launch-review-packet-schemas v0.1.0` — the 8 existing `*.launch-review-packet.json` instances at `spaces-universal/.../spawn-software/instances/` all carry `schemaVersion: "0.1.0-untyped"`. This /capture's substrate-direction lead [[launch-review-app]] workstream packet PHASE A bead-tracks this gap as FR-LRA-001 + FR-LRA-002. The `launch-review-feedback-schemas v0.1.0` shipped this session has `packetRef: LinkRefModel` that will eventually point at typed launch-review-packet records once the packet schema family lands.

**Substrate-direction note on the gap-list:**
- Per [[substrate-architecture-evolution-backlog-must-be-typed-not-memory-only]] (typed AxiomModel from earlier 2026-06-05 session) — the substrate's schema-universal-gap-list is itself substrate-typed-knowledge-work. The typed AxiomModel + memory-pointer pattern this /capture invocation uses honors that doctrine. Operator-direction needed for `substrate-architecture-evolution-backlog-schemas` family PM spin-up.

## Substrate-pace honest summary

This /capture honored the substrate-doctrine [[capture-requires-typed-workflows-and-roles-not-just-memory]] discipline by:
- ✅ READING the typed JSON Schemas (role-workflow.schema.json + axiom.schema.json) FIRST per SKILL.md
- ✅ AUTHORING the typed AxiomModel ([[sibling-composite-pattern-for-generable-types]]) with full conformance to axiom.schema.json (all 8 required fields + 4 optional)
- ✅ STEP-3.5-VALIDATING the typed AxiomModel manually (typed-record-validator CLI substrate-pending per [[missing-typed-record-validator-cli]])
- ⏸️ BEAD-TRACKING workflow + role per substrate-architecture-evolution gaps (typed Role schema-family + release-gate-schemas + work-surface-requirement-schemas + receipt-schemas don't yet exist; SAME gap-set as prior session-2026-06-05 /capture invocations)
- ✅ AUTHORING this memory entry as DOWNSTREAM pointer to the typed axiom + enumerating the substrate-architecture-evolution gaps surfaced

Per [[deferral-is-drift-do-it-now]] — the substrate-pace HONEST move is the axiom (achievable now per typed contract) + honest bead-track (blocked on gaps memorialized in SKILL.md). Per [[non-concrete-definitions-trigger-product-manager-spin-up]] — the substrate-architecture-evolution gap-list needs PM spin-up; operator-direction needed.

## Step 5 + Step 6 honest deferral

Per [[savepoint-daemon-races-your-commits]] + [[Workspace has auto-commit/auto-push git hook]] memorialized substrate-doctrine — Step 5 Shinji Techo ingestion + Step 6 savepoint.sd commit cascade DEFERRED to operator-direction. Substrate-truth at this /capture close-out IS the file-on-disk state: typed AxiomModel landed at `spaces-universal/.../axioms/sibling-composite-pattern-for-generable-types.axiom.su.json` + this memory entry at `~/.claude/memory/.docc/feedback_sibling-composite-pattern-for-generable-types.md` + memory index entry pending.
