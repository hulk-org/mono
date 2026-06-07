---
name: agent-abilities-pokemon-mechanics-with-topology-2026-05-26
description: "Substrate doctrine: agents have abilities (not skills); abilities are typed JIT-acquired envelopes. Pokemon-mechanics analogy applies (HM = mandatory utility, TM = situational specialty, archetype-fit constrains what an agent can learn) — EXCEPT substrate uses TOPOLOGY-BASED balance diagnostics, NOT a hard slot-cap. Substrate counts per-agent abilities and emits warnings based on fleet-balance (over-equipped vs under-equipped, orphan abilities, fleet-coverage gaps). Two corollaries: the `~/.claude/skills/` folder is structurally the root agent's personal ability roster (not a runtime-shared pool); MCP is a misplaced vaults app — most MCP tools are local-machine vault operations that should be typed kura-vault primitives instead of protocol-based tool registry."
metadata:
  node_type: memory
  type: insight
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-articulated 2026-05-26 immediately after the workflow-doctrine landed two graduated skill envelopes (wd, thread-spin). The framing unifies three observations into one architectural shift.

## The three observations

### (1) Pokemon attacks / HMs / TMs — bounded abilities, topology-diagnosed

Pokemon's 4-move-slot constraint maps to substrate's bounded-attention-window — *with one substrate-specific refinement*. Pokemon has a HARD CAP (4 moves, period); substrate has **NO hard ability-slot cap**. Substrate measures topology and emits WARNINGS, not enforcement.

| Pokemon | Substrate-agent equivalent |
|---|---|
| 4-move slot HARD CAP | NOT applied — substrate has no hard cap |
| HM (Hidden Machines) — mandatory utility | core abilities every agent acquires (`wd`, `roster`, maybe `thread-spin`/`close`) |
| TM (Technical Machines) — situational specialty | swappable abilities (agentify-capture, playwright, build-macos-apps) |
| Type effectiveness | ability-to-context match score |
| "This Pokemon can't learn this move" | archetype-fit constraint (e.g., apple-pi can't learn cloud-deploy because no cloud surface) |
| Move-forgetting curation | SOFT — warnings when over-equipped, not eviction-required |

**Operator's refinement (the critical part)**: *"there is no [hard budget] — just a count and maybe warnings based on the balance of what other agents can or cannot do. see? topology based."*

This means substrate's capability discipline is:
- COUNT per-agent abilities (not capped)
- COMPUTE the (agent × ability) topology — the matrix
- WARN on imbalance: "claude has 23 abilities; chatgpt has 4 — claude is over-equipped relative to fleet"
- WARN on fleet-coverage gaps: "no agent has cloudflare-deploy — gap"
- WARN on orphan abilities: "this ability held by 0 agents"
- WARN on near-universal abilities: "held by 8 of 9 agents — should it be fleet-baseline?"

This is the SAME PATTERN substrate's existing `roster analyze` subcommand uses for ROLES (specialists / core roles / fleet baseline tiers). Substrate already lives this topology-based diagnostic discipline at the role layer — applying it to the ability layer is structural continuity, not new doctrine.

### (2) The `~/.claude/skills/` folder is structurally the root agent's abilities

`~/.claude/skills/` is currently treated as a runtime-shared skill pool. But structurally it IS claude-the-agent's personal ability roster.

Implications:
- The canonical path is `agents/claude/private/universal/skills/<slug>/` (where wd + thread-spin abilities landed earlier this session).
- `~/.claude/skills/` is the runtime-mounted PROJECTION of the canonical path.
- Other agents (chatgpt, gemini, apple-pi) have their own `agents/<slug>/private/universal/skills/` — disjoint ability sets, agent-owned.
- Cross-agent shared abilities are either duplicated per agent OR referenced via LinkRef from a substrate-shared abilities catalog.
- When substrate ships a new agent, the agent-setup ability creates `agents/<slug>/private/universal/skills/` and seeds the agent's starter moveset.

### (3) MCP is a misplaced vaults app

MCP tools by category map to typed substrate vault primitives:

| MCP capability | Substrate vault-app primitive (proposed) |
|---|---|
| `mcp__computer-use__screenshot` | `screen.vault` |
| `mcp__computer-use__read_clipboard` | `clipboard.vault` |
| `mcp__computer-use__type` | `keyboard.vault` |
| `mcp__claude-in-chrome__*` | `browser.vault` |
| `mcp__agentify-desktop__*` | `agentify.vault` |
| `mcp__notion__*` | `notion.vault` (or kura-collection with sync) |

Each vault-app is a typed substrate primitive (per [[kura-storage-typology]]) exposing typed operations the agent acquires as abilities. The MCP protocol becomes implementation detail underneath substrate's typed vault-app abstraction.

This is structurally the same move substrate has done across other domains: replace external-protocol-abstractions with typed substrate-internal primitives. Same as the [[substrate-fork-cbl-3-2-1-data-engine]] pattern (substrate owns the data engine instead of consuming external protocol-driven library).

## The unified architectural shift

All three observations are facets of one shift:

**FROM**: skills (eager-loaded markdown) + MCP tools (protocol-registered at boot) + global capability pool
**TO**: abilities (typed JIT-acquired envelopes) + vault-apps (typed kura-tier primitives) + per-agent topology-diagnosed roster

The shift unlocks substrate-quantifiable answers to previously vibes-based questions:
- "Is claude over-equipped?" → compute claude's ability count relative to fleet topology
- "What's our fleet coverage on cloudflare?" → grep the (agent × ability) matrix for cloudflare-deploy
- "Should apple-pi acquire this new ability?" → check archetype-fit + topology imbalance
- "Did we accidentally make every agent know wd separately when it should be substrate-shared?" → topology detects near-ubiquity, flags for promotion to LinkRef-shared

## Substrate gap analysis (what doesn't exist yet)

| typed primitive | substrate has it? |
|---|---|
| `OperatingProtocolModel` / `WorkflowModel` (ability content) | ✓ exists in workflow-schemas + operating-protocol-schemas |
| `AgentCapabilityCatalog` (per-agent ability roster) | ✗ gap |
| `AbilityClassification` enum (HM-equivalent / TM-equivalent / starter) | ✗ gap |
| `AbilityFleetTopologyReport` (computed from agent × ability matrix; counts + warnings) | ✗ gap — BUT roster-analyze pattern exists for roles |
| `VaultAppModel` (typed vault-operation primitive — MCP replacement) | ✗ gap |
| `AbilityAcquisitionEvent` / `DischargeEvent` (runtime JIT events) | ✗ gap |
| Runtime trigger-matching + JIT loader | ✗ gap (harness-layer work) |

The data layer needs ~5 new typed primitives. The runtime layer is harness-side. The MCP-as-vault-app translation is substantial substrate-architecture migration.

## Diagnostic questions the topology model unlocks

Once substrate has `AbilityFleetTopologyReport` computed across all agents:

1. **Per-agent**: count of abilities; classification breakdown (HM / TM / specialty); abilities-held-uniquely (would-be-lost-if-this-agent-retires); archetype-mismatch flags.
2. **Per-ability**: how many agents have it; classification (universal / fleet-tier / specialty / orphan); recommended action (promote to substrate-shared if near-universal; deprecate if orphan).
3. **Fleet-wide**: total abilities tracked; coverage gaps (capability classes no agent provides); concentration risk (capabilities held by exactly 1 agent — SPOFs).
4. **Curation**: when an agent considers acquiring a new ability, the topology informs the decision — "this ability has 0 coverage and matches your archetype; recommended" vs "this ability is held by 7/9 agents already; redundancy warning."

## Substrate-doctrine triad becomes a four-axis frame

The 2026-05-26 doctrine refinements compose:

```
1. Data         [[ordinality-table-entries-immutable-once-released]]
2. Work         [[bead-vs-thread-vs-beat-shapes]] (4 shapes with Phase added)
3. Operation    [[agent-blame-shielded-workflow-doctrine-2026-05-26]]
4. Capability   [[agent-abilities-pokemon-mechanics-with-topology-2026-05-26]] ← THIS
```

Capability is distinct from operation: operation = what a workflow describes; capability = which workflows an agent has acquired AND can acquire. Pokemon Pikachu IS-CAPABLE-OF Thunderbolt (capability axis); when Pikachu USES Thunderbolt in battle (operation axis). Same shape pattern at substrate scale — and the topology-diagnosed fleet view is what makes the capability layer substrate-quantifiable rather than vibes-based.

## Substrate already lives the topology pattern at the role layer

The `roster analyze` subcommand groups roles into three tiers (Specialists / Core Roles / Fleet Baseline) based on coverage distribution. Same pattern at the role-coverage layer that the ability-coverage layer needs. Implementation path: extend the roster CLI or author a parallel `swift-ability-topology-cli` that runs the same group-by-distribution analysis over the (agent × ability) matrix.

## How to apply

1. **When proposing a new agent ability**: check topology first. Is this ability already held by N agents? Is the new agent's archetype a fit? Would adding it to this agent create imbalance vs fleet?
2. **When proposing an MCP tool**: ask "what vault-app does this belong to?" — author the typed vault-app primitive, expose the operation as an ability the relevant agents can acquire.
3. **When commissioning a new agent**: declare starter moveset (HM-equivalents the agent boots with). Don't pre-load everything; the agent acquires TM-equivalent abilities JIT.
4. **When diagnosing why an agent is "missing" a capability**: check the ability topology — is it orphan (no agent has it; substrate-gap), specialty (1 agent has it; concentration risk), or this-agent-just-doesn't-know-it (acquirable on demand)?

## When NOT to apply

- For **trivial inline operations** (read this file, run this command) the ability-acquisition envelope is overhead. Abilities are for operations with multiple steps, lifecycle, axioms — not one-off commands.
- For **research / exploration** when the substrate-canonical workflow doesn't exist yet — author the workflow first, then graduate it to an ability when the pattern stabilizes.
- When the agent is **bootstrapping** — the starter moveset can be eager-loaded; JIT only matters for the post-starter expansion.

## Related substrate doctrine

- [[agent-blame-shielded-workflow-doctrine-2026-05-26]] — workflows are the typed contract; this doctrine adds the load-model + topology dimensions
- [[bead-vs-thread-vs-beat-shapes]] — 4 work shapes; abilities produce work that flows into these shapes
- [[ordinality-table-entries-immutable-once-released]] — AbilityClassification enum case mappings freeze
- [[harnesses-agnostic-models-constrain]] — abilities are agent-owned, not harness-owned; harness JIT-loads abilities the agent declares it can acquire
- [[kura-storage-typology]] — vault-apps are kura-tier primitives; MCP tools collapse into vault-app operations
- [[substrate-fork-cbl-3-2-1-data-engine]] — substrate-owns-the-primitive pattern; same play for MCP→vault-app migration
- [[every-property-fights-for-its-life]] — "skill" graduated to "ability" because the load-model became typed; "MCP tool" graduated to "vault-app operation" because the protocol became typed-substrate-primitive
- [[no-github-pushes-pending-codeberg-or-self-hosted]] — substrate sovereignty pattern (own the surface; don't depend on external protocol)
- roster `analyze` subcommand — existing substrate pattern for capability topology at the role layer; ability topology mirrors it
