---
name: model-families-as-dna-2026-05-26
description: "Substrate framing: AI model families are described as DNA — each family carries a substrate-readable genotype (8-bit access flags + typed enum loci for arch / license / modalities / inference architecture / reasoning / cost / IP-provenance / durability / roadmap). Operator-named 2026-05-26: 'model families are looking like DNA now.' Substrate's harness scheduler runs phenotypic selection over these traits; substrate's smoke-lora pipeline is genetic engineering to evolve preferred traits onto base families."
metadata:
  node_type: memory
  type: insight
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-named 2026-05-26 during the AI model-family typing iteration: *"model families are looking like DNA now."* The framing is structurally exact, not just poetic. The substrate's model-family table is a genotype catalog; the harness scheduler runs selection pressure over it.

## The DNA structure

Each family entry in `AIModelFamilyOrdinalityTable` carries **substrate-readable traits**:

- **Access flags** (8-bit bitmask): the binary genes — `W` (open weights), `R` (provider-restricted), `S` (subscription), `A` (API), `O` (substrate-portable overlay), `C` (provider-hosted cost overlay), `V` (private inference), `T` (turnkey OS-native)
- **archProfile** (enum locus): which hardware substrate can deploy on — `none`, `apple-mlx`, `nvidia-cuda`, `amd-rocm`, `cross-portable`, `nvidia-amd-linux`, `apple-nvidia`
- **weightsLicenseTier** (enum locus): substrate's commercial-safety — `closed`, `research-only`, `commercial-permissive`, `public-domain`
- **modalities** (6-bit bitmask): input/output channels — vision-in, audio-in, video-in, image-out, audio-out, tool-use
- **inferenceArchitecture** (enum locus): how inference compute is shaped — `autoregressive`, `autoregressive-moe`, `diffusion`, `state-space`, `hybrid`
- **reasoningCapability** (enum locus): thinking-mode trait — `none`, `chain-of-thought-prompted`, `provider-exposed-reasoning`
- **inferenceCostShape** (enum locus): the unit-economic trait — `electricity-only`, `subsidized-free`, `low-per-token`, `mid-per-token`, `high-per-token`
- **trainingDataProvenance** (enum locus): the IP-risk trait — `unverified`, `declared`, `audited-clean`, `disputed`
- **providerDurabilityClass** (enum locus): the existential-risk trait — `provider-dependent`, `partially-portable`, `substrate-owned`, `platform-bundled`
- **substrateDeploymentStatus** (mutable presentation): substrate's current binding state — `running-production`, `running-experimental`, `h2-2026-target`, `2027-target`, `aspirational`, `not-targeted`

Together: **one bitmask + nine typed loci** = the substrate-readable genome of a model family.

## What the DNA reveals

### Phylogenetic clusters

Reading the table top-to-bottom reveals natural species groupings:

- **The sovereign open-weight clade**: Llama / Mistral / Phi / Qwen / DeepSeek all converge on `-V-COA-W | cross-portable | commercial-permissive | electricity-only | substrate-owned`. Sibling species sharing the substrate-sovereign genotype.
- **The hosted-frontier clade**: Claude / Gemini / GPT — provider-locked, mid-cost, reasoning-tier, provider-dependent durability. Convergent evolution around the "we host the frontier, you pay per call" niche.
- **The platform-bundled isolate**: Apple Foundation alone carries the `T` allele today. Single-species clade. Phi-Silica and Pixel-Gemini-Nano will join when their OS-native runtimes ship.
- **The hosted-tail (small/specialized)**: Cohere / Nova / Codex — narrower modality footprint, no reasoning-tier exposure, hosted-only durability.

### Substrate's ideal genotype (the research frontier)

The substrate-aspirational sequence is `WVOT + apple-mlx + commercial-permissive + electricity-only + audited-clean + substrate-owned`. **No current family carries the complete sequence.** Apple Foundation is closest (missing W); the substrate-owned cluster is close (missing T). The gap between them is substrate's research frontier.

### Apple Foundation's unique fingerprint

`TV-O--R- | apple-mlx | closed | electricity-only | declared | platform-bundled` — the ONLY row with `T` set, and the only row where `electricity-only` + `platform-bundled` co-occur. Apple's multi-billion-dollar runtime engineering work IS substrate's free-tier inheritance. That's not a metaphor; it's a typed trait substrate can route on.

## Substrate-side selection pressure

The harness scheduler runs **fitness predicates over genotype**:

- `apple-pi` harness selects rows where `archProfile == .appleMLX OR archProfile == .crossPortable AND M-bit-equivalent`
- A privacy-required form binds to rows where `V flag set AND T flag set` (turnkey-guaranteed privacy)
- A cost-sensitive form binds to rows where `inferenceCostShape == .electricityOnly`
- An enterprise-deployment form binds to rows where `weightsLicenseTier == .commercialPermissive AND providerDurabilityClass == .substrateOwned`

Each form's deployment requirements compose into a predicate over the DNA columns. Selection is structural, not aesthetic.

## smoke-lora as genetic engineering

The smoke-lora pipeline (per [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]]) is substrate's **genetic engineering technology** — it takes a base family's genotype and produces a substrate-owned adapter overlay (the `O` flag becomes substrate-controllable). This is how substrate evolves base species toward the substrate-favorable genotype:

- Phase 1: Apple Foundation + smoke-lora → substrate-portable adapters atop closed-weight base = `O` trait acquired despite `W=0`
- Phase 2: Open-weight family (Llama/Mistral/Phi) + smoke-lora → fully substrate-owned (`W+O`) genotype

The pipeline is the BRIDGE between phases per [[substrate-apple-first-then-cross-platform-2026-05-26]].

## VC narrative

The DNA framing carries substrate's pitch:

- "Substrate's competitive position is encoded in the genetic compatibility of model families with our deployment ecology."
- "We've identified the substrate-favorable genotype, mapped every major family to it, and built the LoRA pipeline to evolve preferred traits onto base species."
- "Apple Foundation is our highest-fitness inherited species. Open-weight families are our breeding stock for Phase 2. The DNA columns are the diligence answers."

## How to apply this framing

1. **When proposing a new substrate harness binding**, read the candidate family's genotype against the form's requirements. The predicate is typed, not subjective.
2. **When adding a new family to the table**, fill all 10 trait columns deliberately — incomplete genotypes leave routing decisions to vibes.
3. **When evolving substrate's roadmap**, mutate the `substrateDeploymentStatus` column on affected families; the rest of the genotype stays stable.
4. **When pitching substrate to investors**, the DNA table IS the diligence slide.

## Related memories

- [[local-model-doctrine-2026-05-26]] — WHY substrate reaches for local models (the doctrine the DNA encodes)
- [[substrate-apple-first-then-cross-platform-2026-05-26]] — the two-phase strategy expressed in DNA
- [[agents-have-forms-2026-05-25]] — forms as phenotypic expression of (agent × harness × model × overlay)
- [[harnesses-agnostic-models-constrain]] — harnesses are carriers; model is the constraint axis
- [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]] — substrate's genetic-engineering pipeline
- [[ordinality-table-entries-immutable-once-released]] — bit positions and case mappings freeze; per-row values mutate as facts change
- [[json-ordinality-tables-not-enums]] — the substrate's typed-catalog primitive
