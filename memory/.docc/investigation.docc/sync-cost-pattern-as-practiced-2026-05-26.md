# Substrate's first practiced cost-sync pattern (audit, 2026-05-26)

@Metadata {
  @PageColor(green)
}

Substrate's first practiced cost-sync shipped 2026-05-22 (commit `2be1bb9bc4 wd 2026-05-22: sync-cost observability`) on the wrkstrm-app inference-control surface, backed by `inference-account-schemas v0.2.0` (~25 typed primitives). This investigation captures the pattern as PRACTICED so the 13 cost-related beads in claude's agenda — the encumbrance cohort + ability-cost cohort + cross-cutting audit — can compose with the existing typed surface rather than parallel it. Per [[cost-model-non-divergence-discipline]], every new cost primitive MUST reference this report's type bindings before authoring.

## What was implemented (the precedent)

Substrate shipped a canonical **4-layer cost-sync pattern**:

1. **Cost declaration** — typed shapes declaring what an operation SHOULD cost (`InferenceModelEconomics`, `InferenceTokenPriceBand`, `InferenceProvider`)
2. **Invocation invoice** — emitted at call-completion; typed Codable record (`InferenceUsageEvent`)
3. **Append-only ledger** — JSONL stream of invoices at kura-timeline-tier
4. **Diagnostic surface** — `sync-cost-cli` views (summary / markers / projects / models / sessions / weekly / recent / json)

Operator-named substrate-wide doctrine 2026-05-26 — pattern to expand across abilities, vault-app calls, lens renders, forms, harness operations, digikoma executions.

## Canonical types (the 5 most-load-bearing for downstream composition)

### `InferenceUsageEvent` — Layer 2 invoice

Per-invocation immutable record. Fields:
- `id: UUID`
- `providerID`, `modelID`
- `inputTokens: Int`, `outputTokens: Int`
- `totalCostUSD: Decimal`
- `latencyMs: Int`
- `requestedAt: Date`
- `success: Bool`, `statusCode: Int`, `errorMessage: String?`

**Composes with**: `InferenceProvider.id` (FK), `InferenceModel.id` (FK), `InferenceTokenUse` (when more detail is needed), `InferenceCostEstimate` (the typed calculation).

**Substrate-doctrine usage**: every new cost-bearing operation emits a Codable record EXTENDING or PARALLELING this shape. The encumbrance cohort's `SessionEncumbranceState.contributingInvoices` aggregates these.

### `InferenceCostEstimate` — typed cost calculation

**Location**: inlined in `InferenceModelEconomics.swift` lines 155-179 (NOT a standalone file). This is intentional — cost calculation composes tightly with pricing bands + token use.

Fields:
- `currency: String`
- `inputCost`, `cachedInputCost`, `outputCost`, `regionalProcessingCost: Decimal`
- computed `totalCost: Decimal`

**Composes with**: `InferenceTokenUse` (measured tokens) + `InferenceTokenPriceBand` (per-mode pricing rates).

**Substrate-doctrine usage**: every new cost-bearing primitive that needs typed financial-cost calculation composes this shape — does NOT redefine equivalent fields.

### `InferenceQuota` — Layer 1 declaration (token budget)

Fields:
- `currentTokens: Int`, `limitTokens: Int`
- `resetAt: Date`, `resetInterval: TimeInterval`
- `syncIntervalMinutes: Int`
- `thresholdPercent: Int` (warning threshold)
- `dailyFreeTokens: Int`, `dailyResetUTC: String`

**Substrate-doctrine usage**: `SessionStaminaCeiling.tokenCeiling` composes `InferenceQuota.limitTokens`. `EncumbrancePressureLevel` thresholds reference `InferenceQuota.thresholdPercent`.

### `InferenceRateLimit` — Layer 1 declaration (throughput ceiling)

Fields:
- `rpm: Int` (requests per minute)
- `minGapMs: Int`
- `maxConcurrent: Int`
- `tpm: Int` (tokens per minute)

**Substrate-doctrine usage**: `HarnessStaminaProfile.rateLimit` composes this directly. `SessionStaminaCeiling.rateLimitTokensPerMinute` reads `tpm`.

### `InferenceProvider` — Layer 1 declaration (root)

Carries nested `quota` + `rateLimit` + `hosting` + `circuitBreaker`. Fields:
- `id: UUID`, `name: String`
- `apiFormat`, `baseURL`, `usageEndpoint`
- `rateLimit: InferenceRateLimit`
- `quota: InferenceQuota`
- `hosting: Hosting { mode, hostedBy, networkScope, baseEndpoint }`
- `proxyURL: String?`, notes

**Substrate-doctrine usage**: `HarnessStaminaProfile` references the harness's `InferenceProvider` via LinkRef. The provider's nested `rateLimit` + `quota` + `hosting` ARE the stamina-ceiling inputs at the harness layer.

## Ledger location + format

**Location**: kura-timeline-tier (per [[kura-storage-typology]]). Concretely: `~/mono/.wrkstrm/shinji-techo/` paths for the inference-control instance.

**Format**: JSONL — each line is a typed `SyncCostInvocation` Codable. The `sync-cost-cli` scanner reads session JSONL logs and **marker-associates** them via in-source sync markers (`$sync` for financial, `%sync` for percentage, `/sync` for slash-invoked). When a marker appears, the next usage event becomes associated with it.

**Diagnostic surface**: `sync-cost-cli --view summary|markers|projects|models|sessions|weekly|recent|json` returns rollup stats with invocationCount, costedCount, totalTokens, totalCostUSD, median/p90/max distribution.

## What chatgpt's expertise memory captured (5 gotchas)

1. **Provider discovery belongs in scanner + account surfaces** — not UI shader paths. Don't conflate visualization with cost-source-of-truth.
2. **Pacing strings use signed percentage-point deltas** (`+Npp` = ahead/slow-down; `-Npp` = behind/speed-up). Distinct from numeric precision.
3. **Metal shaders for token-descent visuals** is the right rendering layer (not SwiftUI Canvas). Motion + trails compose cleanly as shader.
4. **Gemini is a canonical provider alias** — treat Google/Gemini credentials as the same key in discovery scans.
5. **Keep provider-label coupling isolated** — pacing changes shouldn't touch provider-discovery.

The deepest lesson: **separate cost-source-of-truth (scanner + account surfaces) from cost-visualization (shader/UI layer)**. The encumbrance cohort SHOULD honor this — `SessionEncumbranceState` is source-of-truth typed Codable; `SessionEncumbranceLens` is the rendering layer.

## Mapping: encumbrance + ability-cost primitives → existing types

The 12 cost-related beads in claude's agenda compose with these existing types as follows:

| proposed primitive | composes with existing types |
|---|---|
| `HarnessStaminaProfile` | `InferenceProvider` (root), `InferenceConnection`, `InferenceRateLimit` (nested), `InferenceQuota` (nested) |
| `SessionStaminaCeiling` | `InferenceQuota`, `InferenceRateLimit`, `InferenceCircuitBreaker`, `InferenceContextClass` (from InferenceModelEconomics), AIModelFamilyContextWindowSizeClass (pending bead) |
| `SessionEncumbranceState` | aggregates streams of `InferenceUsageEvent`; references `SessionStaminaCeiling` |
| `EncumbrancePressureLevel` ordinality | NEW — but transitions trigger `InferenceCircuitBreaker` policy logic |
| `SessionEncumbranceLens` (lens-app) | reads `SessionEncumbranceState` + `InferenceUsageEvent` ledger; no NEW typed shapes |
| `wire-substrate-policy-responses` | triggers `InferenceCircuitBreaker` policy at threshold transitions |
| `AbilityCostShape` (proposed) | `InferenceCostEstimate` + `InferenceTokenPriceBand` + `InferenceTokenUse` (all from InferenceModelEconomics) |
| `AbilityPerformanceInvoice` (proposed) | EXTENDS `InferenceUsageEvent` (semantic parallel; possibly subclass via composition) |
| `AgentAbilityCostLedger` (proposed) | kura-timeline of `InferenceUsageEvent` aggregated per-agent |
| `AbilityListingModel` (proposed) | `InferenceModel` + `InferenceModelCapabilities` + `InferenceWorkloadClass` |
| `AgentCapabilityCatalog` (beaded) | references AbilityListingModels via LinkRef; not directly cost-typed |
| `AbilityClassification` ordinality | NEW typed catalog — independent of inference-account-schemas |
| `AbilityFleetTopologyReport` | aggregates across AgentCapabilityCatalogs; no NEW cost types |

## SPM dependency declaration discipline

Per [[cost-model-non-divergence-discipline]] rule 4, every new schema family in the cost layer MUST declare a Package.swift dependency on `inference-account-schemas/v0.2.0/spm/inference-account-schemas-v000-002-000`. Compilation enforces the binding. No "soft references" via prose.

## Missing-but-needed primitives the doctrine work flagged

1. **Session encumbrance (Layer 5)** — operator-stated 2026-05-26. Per-invocation invoices ≠ session-cumulative encumbrance. Substrate needs `SessionStaminaCeiling` (composite per harness × model × operator-policy) + `EncumbrancePressureLevel` ordinality. This investigation's audit confirms substrate has the BUILDING BLOCKS (InferenceQuota + InferenceRateLimit + InferenceCircuitBreaker) but not the SESSION-LEVEL AGGREGATION primitive itself.

2. **Context-weight axis** — distinct from USD + wall-clock. Bigger context = higher context-weight ceiling. Composes with `AIModelFamilyContextWindowSizeClass` (beaded earlier today).

3. **Ledger composability across domains** — current implementation is inference-only. Future expansions (abilities, vault-apps, lens renders) MUST emit compatible invoice shapes so substrate-wide cost reporting becomes a single union query. Probably means: `AbilityPerformanceInvoice` is structurally an `InferenceUsageEvent` + ability-slug FK, not a parallel shape.

## Recommended next moves (per the audit)

For each cost-related authoring bead (12 beads):

1. **Update description with explicit `composesWithExistingTypes[]` list** from the mapping table above. Per [[cost-model-non-divergence-discipline]] rule 3.

2. **Declare SPM dependency** on `inference-account-schemas v0.2.0` in any Package.swift the bead authors.

3. **Author Codable round-trip tests** that synthesize `InferenceUsageEvent` streams + verify the new primitive's aggregation matches direct inference-account ledger sums. Behavioral check at build time.

4. **Reference this investigation report** (`sync-cost-pattern-as-practiced-2026-05-26.md`) in any new file's doc-comment as the canonical lineage.

## Open questions

1. **Should `AbilityPerformanceInvoice` be a SUBTYPE of `InferenceUsageEvent` or a SIBLING with FK ref?** Subtype = strongest non-divergence guarantee but couples; sibling = more flexibility but allows drift. My instinct: subtype/extension when the new shape adds ≤2 fields; sibling-with-FK when the new shape adds substantial new dimensions (ability-slug + acquisition-event + classification refs).

2. **Where does the substrate-runtime cost-attribution layer live?** When the agent invokes an ability, who emits the `InferenceUsageEvent` with the ability-slug attached? Harness layer? CLI wrapper? Pre-LLM-call substrate code? This is the runtime gap from Gap 2 of `[[agent-blame-shielded-workflow-doctrine-2026-05-26]]`.

3. **Cost-attribution across nested operations** — if ability-A invokes ability-B, does B's cost roll up to A or stay independent? Doctrine call.

## Recommended next move

Update the 13 cost-related bead descriptions with explicit composition declarations per the mapping table above. Then proceed to the next-priority bead: `author-agent-capability-catalog-typed-shape` (priority 2) is unblocked once this audit + bead-description-housekeeping complete.

## Related substrate doctrine

- [[substrate-sync-cost-pattern-2026-05-26]] — the canonical 5-layer pattern (with encumbrance refinement)
- [[cost-model-non-divergence-discipline]] — discipline this audit operationalizes
- [[agent-abilities-pokemon-mechanics-with-topology-2026-05-26]] — the capability axis the ability-cost work materializes
- [[audit-schema-universal-before-authoring-new-types]] — initial-state companion (this audit applied that)
- [[same-shape-same-model]] — what the non-divergence discipline enforces
- inference-control implementation (commit `2be1bb9bc4` 2026-05-22) — substrate's first practiced cost-sync
- `agents/chatgpt/memory/.docc/expertise/inference-control-gemini-shader-pacing.md` — operator-captured lessons
