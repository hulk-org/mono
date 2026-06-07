---
name: substrate-apple-first-then-cross-platform-2026-05-26
description: "Substrate strategy: bind to Apple Foundation (electricity-only, platform-bundled, turnkey) FIRST, then expand to substrate-owned cross-platform open-weight families in H2 2026. Phase 1 = no-infrastructure go-to-market on operator's existing hardware; Phase 2 = sovereign-cross-platform deployment. The smoke-lora pipeline is the bridge between phases. Operator-locked 2026-05-26: 'we are going to bind to the electric only Apple first and then go cross platform.'"
metadata:
  node_type: memory
  type: insight
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-locked 2026-05-26 during the model-family DNA design: *"we are going to bind to the electric only Apple first and then go cross platform."* The two-phase strategy is structural — Phase 1 and Phase 2 are typed predicates over the DNA table, not vague roadmap aspirations.

## Phase 1 — Apple Foundation binding (PRODUCTION TODAY)

### Selection predicate

```
T flag set                  // turnkey OS-native runtime
AND inferenceCostShape == .electricityOnly
AND archProfile == .appleMLX
```

### Matches today

`apple-foundation` (singleton). Future expansion: Microsoft Phi-Silica on Windows, Pixel Gemini-Nano on Pixel — those families flip `T` from 0 to 1 when their OS-native runtimes ship.

### What substrate gets

- **Zero substrate runtime-engineering cost** (`T` = 1): Apple ships the FoundationModels framework; substrate calls it.
- **Zero marginal inference cost** (`inferenceCostShape = electricity-only`): after device purchase, inference is OS-bundled.
- **Privacy-by-default** (`V` = 1): on-device, framework-enforced. No data crossing.
- **Substrate-portable LoRA overlay** (`O` = 1) via smoke-lora + Apple's adapter API.
- **Apple's OS lifecycle as durability runway** (`providerDurabilityClass = platform-bundled`).

### What substrate accepts

- Closed weights (`W` = 0) — substrate cannot possess Foundation Models weights independently.
- Apple-platform exclusivity (`R + apple-mlx`) — non-Apple harnesses cannot deploy this family.

### Strategic value

Substrate ships forms / lenses / agents on the **operator's existing hardware with zero infrastructure cost**. Time-to-first-form is hours, not months. This is the no-infrastructure go-to-market that makes substrate's economics work from day one.

## Phase 2 — Substrate-owned cross-platform expansion (H2 2026 TARGET)

### Selection predicate

```
W flag set                                  // open weights
AND weightsLicenseTier == .commercialPermissive
AND providerDurabilityClass == .substrateOwned
AND archProfile == .crossPortable
```

### Matches today

`meta-llama`, `mistral`, `microsoft-phi`, `alibaba-qwen`, `deepseek` — the substrate-owned cluster.

### What substrate gets

- **Sovereign weights** — substrate possesses the artifacts in perpetuity (`W` + `substrate-owned`).
- **Commercial-safe license tier** — ship products without legal anxiety.
- **Hardware portability** — runs on Apple Silicon AND NVIDIA AND AMD AND CPU.
- **Electricity-only cost** — same unit economics as Phase 1.
- **Substrate-portable LoRAs** intact (`O` = 1) — moat-building continues.
- **MoE variants** (Llama 4, Mixtral, DeepSeek-V3) for cost-efficient large-effective-capability inference.
- **Reasoning-tier from DeepSeek R1** — substrate's first sovereign reasoning-mode model.

### What substrate accepts

- **Engineering work to set up the runtime** (`T` = 0): substrate ports, quantizes, integrates with MLX / llama.cpp / vLLM.
- **Some entries carry `disputed` training-data provenance** (Llama, with active IP litigation against Meta) — substrate accepts the risk knowing it lives on Meta's balance sheet, not substrate's.

### Strategic value

Substrate's bet on **hardware-independence and provider-independence**. The runtime engineering investment in Phase 2 produces a stack that survives any single provider's disappearance. Substrate becomes a self-sufficient AI deployment platform, not an AI-API consumer.

## The smoke-lora pipeline as the bridge

Per [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]], the substrate's Swift-owned LoRA pipeline works for both phases:

- **Phase 1 use**: train substrate-portable adapters atop Apple Foundation (closed base). The adapter is substrate-owned even though the base isn't.
- **Phase 2 use**: train substrate-portable adapters atop substrate-sovereign open-weight bases (Llama / Mistral / Phi). Both the adapter AND the base are substrate assets.

The SAME pipeline runs in both phases. The continuity is what makes the strategy executable rather than aspirational. **smoke-lora is substrate's "genetic engineering" capacity** per [[model-families-as-dna-2026-05-26]] — it evolves substrate-favorable traits onto base species across both phases.

## What the strategy reads as for VCs

1. **"We ship today on Apple's free, private, electricity-only runtime"** — Phase 1, the no-infrastructure go-to-market. Operator's Mac IS the production server.
2. **"We expand H2 2026 to substrate-owned cross-platform models for sovereignty and durability"** — Phase 2, the platform-independence story. Substrate's investment survives any single AI provider's failure.
3. **"Both phases run through the same smoke-lora pipeline — our genetic engineering capability"** — the bridging technology AND the defensible moat. Substrate-specific adapters trained on operator data ARE the differentiation.

## How to apply this doctrine

1. **When evaluating a new model family**, run the Phase 1 predicate first (does it satisfy `T + electricity-only + appleMLX`?). If yes, it joins Phase 1 today. If it satisfies Phase 2 predicate instead, it joins the H2 2026 cohort.
2. **When designing a substrate harness binding**, default to Phase 1 families for operator-facing forms (privacy, zero-cost, turnkey). Use Phase 2 families for cloud-deployed lens apps where hardware-portability matters.
3. **When extending the model-family table**, the `substrateDeploymentStatus` field tracks per-family roadmap state. Move families through the lifecycle (`aspirational → h2-2026-target → running-production`) as substrate's binding evolves.
4. **When pitching substrate**, lead with Phase 1 as the immediate-value story; close with Phase 2 as the durability + sovereignty story. The DNA table proves both quantitatively.

## When NOT to apply

- **For non-substrate-deployment work** (e.g., calling Claude from a one-off script), the phase doctrine doesn't apply. Use whatever model is available; the doctrine is about substrate's first-party deployment surface.
- **For exploratory research** that genuinely needs a frontier model substrate hasn't yet bound to (e.g., a future Mercury diffusion LM), bypass the phase doctrine and document the exception.

## Related memories

- [[local-model-doctrine-2026-05-26]] — WHY substrate reaches for local models (the five doctrinal reasons Phase 1 and Phase 2 both serve)
- [[model-families-as-dna-2026-05-26]] — the DNA framing the two-phase predicates run over
- [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]] — the bridge pipeline
- [[agents-have-forms-2026-05-25]] — forms run on top of phased model bindings
- [[harnesses-agnostic-models-constrain]] — model is the constraint axis the phase predicates filter on
- [[substrate-is-digikoma-factory-2026-05-23]] — Phase 1's no-infrastructure factory thesis
- [[lens-apps-substrate-pattern-2026-05-18]] — Phase 1's per-form economics enabling the lens-app studio
