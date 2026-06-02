---
name: local-model-doctrine-2026-05-26
description: "Substrate doctrine: five interlocking reasons substrate reaches for local AI models on Apple Silicon AND generic hardware. Sovereignty + per-form economics + privacy + experimentation velocity + offline resilience. Articulated 2026-05-26 during the AI model-family bitmask design. This is the WHY that the model-family DNA table encodes structurally."
metadata:
  node_type: memory
  type: insight
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Substrate's reach for local AI models is not preference or aesthetic — it's a structural requirement made of five interlocking reasons. None stands alone; together they make local inference doctrinally non-optional.

## Why substrate reaches for local models — five reasons

### 1. Sovereignty — bounded executors don't depend on third-party gates

Per [[substrate-is-digikoma-factory-2026-05-23]], substrate's industrial purpose is producing **bounded executors that ship complete**. Every remote API call is a gate substrate doesn't own: Anthropic's API uptime, OpenAI's deprecation cadence, Google's TOS changes, billing card expiry. Local inference inverts this — substrate owns the gate. Same doctrine as [[substrate-fork-cbl-3-2-1-data-engine]] (forking Couchbase Lite), [[no-github-pushes-pending-codeberg-or-self-hosted]] (moving off GitHub), the openclaw self-hosting work. The pattern is consistent: substrate owns its foundations or it doesn't ship.

### 2. Per-form economics — the factory only works at fixed marginal cost

Per [[lens-apps-substrate-pattern-2026-05-18]] and [[agents-have-forms-2026-05-25]], substrate's output is *many lenses, many forms* — apps and agent-specializations shipped cheaply because the studio's marginal cost is low. Remote inference makes that marginal cost LINEAR in usage. Local inference makes it **approach zero after the fixed hardware investment**. Buy the Mac Studio once, run unlimited inference. That's what makes the "factory" framing economically real — fixed-cost compute = unbounded form production.

### 3. Privacy — operator data must not cross the substrate boundary

Per [[ghosts-as-substrate-top-level-category-2026-05-17]], substrate's ghost system trains **personalized adapters on operator data**: chronicle, journal, expertise, agenda, Shinji Techo. These define who the operator IS. If those adapters train against a remote API, operator data crosses to a third party. If inference runs against a remote endpoint, every prompt carries operator context out to someone else's logs. Structurally incompatible with what substrate is FOR. Apple's choice to put Foundation Models on-device is the same call substrate is making, for the same reason.

### 4. Experimentation velocity — model-swapping must be cheap

Per [[harnesses-agnostic-models-constrain]], substrate's architecture deliberately makes harnesses agent-agnostic but model-constrained. The model is the swap-axis. Substrate wants to **try a new model the same way it tries a new font** — cheap, reversible, no committee. Remote inference makes every experiment cost money; operators with budget anxiety stop experimenting. Local inference makes experiments **free**: quantize a new family overnight, A/B it tomorrow, discard it the next day. That cadence produces the model-savvy substrate the operator is building.

### 5. Offline resilience — substrate runtime can't require network

The operator works in transit, in cafes, on planes, in places with bad connectivity. Substrate's runtime — agents, beads, Shinji Techo, digikomas, forms — should work **anywhere the laptop boots**. Remote inference makes substrate dead-on-arrival without WiFi. Local inference makes substrate's "always-there" promise structurally true.

## Why Apple Silicon AND generic hardware (the dual-platform reason)

### Apple Silicon (the `apple-mlx` archProfile)

- **Operator's primary platform** — substrate is built on Apple hardware first; the operator's daily harness runs on Mac.
- **Unified memory** lets consumer-grade hardware run models that would need an A100 elsewhere. Mac Studio M2 Ultra with 192GB unified memory hosts 70B+ quantized models. That's a desktop, not a server.
- **MLX is Swift-friendly** — substrate is Swift-first across the stack. MLX integrates natively with the Swift toolchain; PyTorch+CUDA does not.
- **smoke-lora pipeline targets Apple Silicon** per [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]] — the substrate's chosen LoRA-training surface is Apple-native.
- **Apple Intelligence integration possible** — Apple Foundation Models gives substrate a privacy-preserving inference path even before substrate ships its own quantized weights.

### Generic hardware (the `nvidia-cuda` / `amd-rocm` / `cross-portable` archProfile values)

- **Substrate ships beyond the operator's Mac.** Digikomas may deploy on Linux servers running NVIDIA or AMD. End-user clients of substrate apps may run on Windows / Linux / phones / boxes substrate doesn't control.
- **Cloud-burst when needed.** If substrate needs to fine-tune a 70B model and the operator's Mac is busy, rent NVIDIA on demand.
- **Production deployment.** Substrate's lens apps hosted for end-users likely run on NVIDIA-equipped servers (vLLM / Together / Bedrock).
- **Portability beyond Apple.** Eventually substrate may run on operator workstations that aren't Macs.
- **Llama-class models often run optimally on NVIDIA.** Even with MLX support, raw throughput on quantized Llama-70B is higher on a single A100 than on M2 Ultra.

The split isn't either-or — it's **Apple Silicon for operator-side privacy-preserving inference; generic GPU for cloud-burst and production hosting**. Substrate needs both because it's building both layers.

## How this doctrine encodes in the model-family DNA table

The five reasons inform specific bits/fields in `AIModelFamilyOrdinalityTable`:

- **Sovereignty** → `W` flag (open weights) + `providerDurabilityClass.substrate-owned`
- **Per-form economics** → `inferenceCostShape.electricity-only` + `T` flag (turnkey)
- **Privacy** → `V` flag (private inference path)
- **Experimentation velocity** → `O` flag (substrate-portable overlay) + `L` (local-runtime via archProfile)
- **Offline resilience** → derived from archProfile != .none

A family with `WVOT + electricity-only + apple-mlx + substrate-owned + commercial-permissive` is substrate's ideal genotype. No current family carries all of it — Apple Foundation is closest (missing W), substrate-owned cluster is close (missing T). The gap between them is substrate's research frontier.

## Related memories

- [[substrate-is-digikoma-factory-2026-05-23]] — sovereignty doctrine (#1)
- [[lens-apps-substrate-pattern-2026-05-18]] — per-form economics doctrine (#2)
- [[agents-have-forms-2026-05-25]] — per-form economics + privacy (#3)
- [[ghosts-as-substrate-top-level-category-2026-05-17]] — privacy doctrine (#3)
- [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]] — Apple-native LoRA pipeline
- [[harnesses-agnostic-models-constrain]] — experimentation velocity doctrine (#4)
- [[substrate-fork-cbl-3-2-1-data-engine]] — sovereignty pattern (data engine analog)
- [[no-github-pushes-pending-codeberg-or-self-hosted]] — sovereignty pattern (hosting analog)
- [[model-families-as-dna-2026-05-26]] — the DNA framing that encodes this doctrine structurally
- [[substrate-apple-first-then-cross-platform-2026-05-26]] — the two-phase deployment strategy
