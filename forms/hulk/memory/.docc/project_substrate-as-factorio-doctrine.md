---
name: Substrate-as-factorio doctrine
description: Operating metaphor for the substrate; structural in operator surfaces (Foundry UI, doctrine, vocabulary), neutral in code; landed as committed doctrine bundle May 2026
type: project
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
The substrate's operating metaphor is **factorio** — factories that build factories, compositional recipes, supply-chain visibility, research-tier progression. Recognized this session as not just decorative but operationally diagnostic: tells you what's missing and what to build next.

**Mapping (selected):**
- Iron plate → source code in Package.swift
- Furnace → discover-clis / discover-apps
- Assembly machine → apply-cli-renames / install-cli
- Logistic network → aliases.zsh + symlink farm + install receipts
- Main bus → swift-universal common-* libraries
- Blueprint book → AppDisplayManifest + project.yml templates
- **Recipe browser** → Foundry's FleetView (Tier 1)
- **Production statistics** → Tier 2 (telemetry, TODO)
- Research tree → AppKind (gym/museum/zoo/prototype/product)
- **Rocket** → sustained 10-apps-per-day (the substrate's victory condition)
- **Logistic chest** → a vault — typed storage routing items by declared shape

**Where it's structural vs neutral:**
- Operator-facing surfaces (Foundry UI strings, doctrine prose, internal Slack, agent prompts): use factorio vocabulary
- Swift code APIs / type names: stay neutral (`SubstrateRegistryVault`, not `RecipeBookFurnace`)
- This split is committed doctrine

**Where the doctrine lives:** `clia-org/private/substrate-as-factorio.docc/` — index.md (mapping + research tiers + when structural) + research-tiers.md (5-tier progression) + operator-vocabulary.md (official terminology).

**How to apply:** When the substrate seems undirected, read it through the factorio lens — the question "what's our next research tier" usually surfaces the obvious move. We were mid-Tier 1 (Map view) as of this session.
