---
name: plug-system-host-contract-vs-plugin-manifest
description: "When substrate architects a plug-system (host + many plugs), TWO typed contracts coexist — narrow HOST contract (provider-agnostic, cross-cutting concerns) vs each PLUG's manifest (product-specific runtime). Don't conflate. Pointer to typed AxiomModel."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 48bb3ae1-1a94-4651-ac23-1a617d8ef0d2
---

Plug-system architecture has TWO distinct typed contracts that MUST stay structurally separate: (1) the HOST's substrate-canonical provider-agnostic contract — narrow, captures cross-cutting concerns (lifecycle, harness availability, cost, account/plan routing, classification taxonomy); (2) each PLUG's manifest — rich, captures product-specific runtime details (embedded prompts, runtime tool-bindings, transport flags, business/distribution rules). The substrate-canonical type is the HOST contract; per-plug manifests live in `maintainers/<org>/` and carry typed LinkRef pointers UP to the host's classification.

**Why:** Surfaced 2026-06-04 mid-session via deep comparison of OpenAI Codex's `codex-rs/models-manager/models.json` (a first-party PLUGIN MANIFEST: 31 fields/model including embedded `base_instructions` prompt, `reasoning_levels`, `apply_patch_tool_type`, ChatGPT plan availability) against substrate's `AIModelCatalog` (a HOST CONTRACT: ~14 fields per AIModel, provider-agnostic, LinkRef-typed availability, no embedded prompts). Operator framed: "we are a plugin system and we need to get it right." The temptation to absorb codex's rich runtime fields into substrate's canonical type would COMPROMISE the plug-architecture (substrate would stop being a host and become codex-shaped). Clean answer: type the codex manifest at FULL fidelity under `maintainers/openai/` (theirs); keep substrate's `AIModelCatalog` narrow (ours); carry typed LinkRef (`familyRef: ai-model-family://openai-codex`) between them.

**How to apply:** When architecting any substrate-typed surface that accepts plugs from multiple parties: identify and type the HOST contract FIRST (narrow). Type each plug's manifest separately under `maintainers/<org>/schema-families/` at full upstream fidelity. Carry typed LinkRef pointers from plug records UP to the host's canonical taxonomy. REFUSE the urge to absorb plug-specific runtime fields into the host contract. REFUSE the urge to add cross-cutting host concerns into a plug manifest. Adapters live in TYPED projection schemas, not as inline embeddings.

Canonical typed source of truth (read this, not this memory): `[[plug-system-host-contract-vs-plugin-manifest]]` AxiomModel at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/plug-system-host-contract-vs-plugin-manifest.axiom.su.json`.

Composes with: `[[do-not-break-domain-driven-design]]` (DDD applied at the plug-system architecture layer) + `[[substrate-agent-ness-does-not-override-partition]]` (companion partition rule) + `[[maintainers-tier-doctrine]]` (path-layout doctrine that operationalizes this axiom) + `[[content-lives-in-its-owners-home]]`.
