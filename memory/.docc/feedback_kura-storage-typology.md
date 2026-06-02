---
name: kura-storage-typology
description: "Substrate's storage typology under Kura — SIX shape tiers (vaults, collections, series, timelines, threads, assignments) sit under `collectives/kura-org/` (governance) and per-home + substrate-shared Kura instances. Each tier captures a distinct access pattern over typed records; the typology is generative — extended from 5 to 6 on 2026-05-26 when the operator promoted assignments to a Kura tier."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

The substrate names its shared-storage primitive **Kura** (蔵, Japanese for storehouse) — operator-decided 2026-05-25 (later) on branding + SEO grounds: "everyone will have vaults. but kura is unique. SEO." The Japanese-rooted distinctive name matches the substrate's existing naming register (Hobonichi → Shinji Techo 神事手帳, Ikigai イキガイ).

## Hierarchy (6 tiers × 5 ownership scopes + substrate-shared + org)

```
collectives/kura-org/                          ← governance org (renamed from vaults-org)
   ├── kura-server-schemas v0.1.0 (typed control plane, already exists)
   ├── kurad daemon (already exists)
   ├── thread-schemas (already exists; promoted to 5th-tier canonical)
   ├── org-assignment-schemas (already exists; promoted to 6th-tier canonical 2026-05-26)
   └── access-grant taxonomy + policy

# Per-commissioned-home personal kura (5 ownership tiers — EVERY commissioned home gets one):
operators/<slug>/private/universal/kura/{vaults,collections,series,timelines,threads,assignments}/
collectives/<slug>/private/universal/kura/{vaults,collections,series,timelines,threads,assignments}/
roles/<slug>/private/universal/kura/{vaults,collections,series,timelines,threads,assignments}/
agents/<slug>/private/universal/kura/{vaults,collections,series,timelines,threads,assignments}/
harnesses/<slug>/private/universal/kura/{vaults,collections,series,timelines,threads,assignments}/

# Substrate-wide shared kura:
private/universal/kura/{vaults,collections,series,timelines,threads,assignments}/
```

The 6th tier (`assignments/`) was added 2026-05-26 when the operator
extended the typology with: "assignments should live in the new kura
directory: kura/assignments/*". Assignments fit Kura more naturally than
their prior peer-of-Kura placement (`private/universal/assignments/`) —
see [[feedback_assignments-live-in-collective-orgs]] for the doctrinal
evolution and corrective sweep cohort.

Each commissioned home has its OWN kura tree (lived state stays per-home); the substrate-wide kura is the SHARED layer on top for things no single home owns.

**Harness retroactive validation**: harnesses are commissioned homes too (they ship identities at IdentityModel 0.6.0 like agents do). Operator named the insight 2026-05-25: openclaw's ad-hoc `automation/` `canvas/` `chat-state/` `completions/` `cron/` `delivery-queue/` `devices/` `plugins/` `sessions/` are ALL instances of the 5 Kura tiers — sessions/chat/completions/automation become timelines, cron/delivery-queue become series, devices/plugins become collections, plugin-secrets become vaults. Kura canonicalizes what harnesses were already building ad-hoc. Pairs with **harness-portability**: when each harness has typed memory in canonical Kura tiers, agents become portable across harnesses (their kura travels with the agent).

## Defining property per shape

The 5 shapes are **independent access patterns**, not exclusive categories. A record can live under multiple shapes (the same content represented through different access lenses):

- **Vault**: confidentiality is the gating property. Encrypted at rest; access-grants gate reads. Whether 1 record or 1M doesn't matter; the wall around it is what defines the shape. Maps to `KuraAccessGrantModel`.
- **Collection**: curation is the gating property. Hand-picked, browseable, may be heterogeneous record kinds inside. A museum exhibit, a roster of agents, the public-surfaces catalog. Documents (SOPs, architecture docs, design docs, investigations) live here as curated cross-agent communication surfaces.
- **Series**: ordinality is the gating property. Numbered/ordered, completeness matters (volume 1, 2, 3... gap at 7 is a defect). Schema-set versions, release cuts, numbered scientific runs.
- **Timeline**: temporal is the gating property. Append-only, chronologically ordered, "what happened when" semantics. Shinji Techo chronicle/journal/expertise ledgers ARE timelines.
- **Thread** (operator-promoted to 5th tier 2026-05-25): the KNOWLEDGE-GRAPH ↔ WORK-GRAPH bridge. Threads reference prior knowledge artifacts (specs, designs, decisions = knowledge graph) AND spawn work artifacts (beads, beats, derived[] = work graph). Crossings are bridge events; boundary opens at one moment and closes at another; derived[] indexes the work-graph emissions. No other tier has that structural role. Maps to `ThreadModel` from `thread-schemas v0.3.0`.
- **Assignment** (operator-promoted to 6th tier 2026-05-26): binding is the gating property. An assignment expresses `role × actor × org-scope` — a typed contract between a named role and a specific actor (agent) within the owning collective's scope. The org's Kura is the natural home because the binding IS org-knowledge (who-does-what-in-this-org). Maps to `OrgAssignmentModel` from `org-assignment-schemas v0.1.0`. Slug convention: `<role-slug>-<actor-slug>/`. See [[feedback_assignments-live-in-collective-orgs]].

## Cross-agent communication doctrine (operator rule 2026-05-25)

Agents have PRIVATE agendas. Inter-agent coordination does NOT happen through shared bead pools or cross-agent threads. Coordination flows through **typed document exchange**:

- **SOPs** (`operating-protocol-schemas`) — how multiple agents handle a recurring kind of work
- **Architecture documents** — substrate-wide structural decisions (DocC indexes)
- **Design documents** — feature/product designs that agents reference
- **Investigation documents** — exploratory work surfaced for cross-agent reading

Each agent reads documents authored by others; agents do not share burn-down beads with each other. This forces inter-agent work to flow through DURABLE TYPED ARTIFACTS rather than ephemeral shared queues. Cross-agent coordination is a knowledge-graph operation (documents) not a work-graph operation (shared beads).

## Mapping existing substrate records to shapes

| current substrate record | kura tier | reason |
|---|---|---|
| `private/universal/vaults/public-surfaces/<domain>.public-surface.json` (the 14 surfaces I just landed) | **collection** | curated roster of 14 domain profiles; not encrypted, not numbered, not chronological |
| `agents/<slug>/memory/.docc/resources/agency/神事手帳/{chronicle,journal,expertise}/<slug>.<lane>.techo.jsonl` | **timeline** | append-only Shinji Techo ledgers; chronologically anchored |
| `schema-universal/.../schemas-sets/core-entities/v{0.7.0,0.8.0,0.9.0,1.0.0}/` | **series** | ordinal versioned releases of a typed family; gaps would be defects |
| Operator personal credentials / API tokens / private secrets | **vault** | genuinely encryption-required; access-grant gated |
| `agents/<slug>/private/universal/identity/<slug>@<owner>.substrate.identity.json` | (boundary) | singular record in the commissioned home; Kura-indexed but not Kura-stored |
| `agents/<slug>/agenda/beads/<slug>.issue.json` | **collection** (in agent's personal kura) | curated set of open work units; priority-sorted but not strictly ordinal-complete; agent-private per Axis 3 |
| Threads (`agents/<slug>/agenda/threads/<slug>.thread.json`) | **thread** (5th tier) | knowledge-graph ↔ work-graph bridge; not a multi-shape derivative |
| SOPs (`operating-protocol-schemas` instances) | **collection** (substrate-shared) | typed document for cross-agent coordination; the canonical substrate cross-agent comm channel |
| Architecture / design / investigation DocC pages | **collection** (substrate-shared) | cross-agent communication via typed documents per Axis 3 |
| Beats (within scenarios) | **series** (within owning home's kura) | ordered tactical units inside a scenario stage |

## How to apply

1. **When designing a new substrate record kind, ask: what's the defining access pattern?**
   - Need confidentiality → vault
   - Need curation → collection
   - Need ordinality → series
   - Need temporal append-only → timeline
   - Need multiple? → the record is multi-shape; pick a primary home + cross-reference

2. **Path convention**: `private/universal/kura/<shape>/<slug>/<record>.json`. The shape tier is part of the canonical path.

3. **Org governance**: `collectives/kura-org/` owns the schemas, the daemon, the access-grant taxonomy, and the typology rules. Sub-orgs aren't needed at this level — Kura is one org with four storage shapes.

4. **The typology is generative + open**: 4 shapes is the v0; future shapes might include `streams/` (live, non-append-only), `registries/` (canonical-name lookups), `indices/` (computed views). The doctrine permits extension.

5. **Multi-shape records**: when a record's access patterns span multiple shapes, the canonical home is the shape that matches its PRIMARY access pattern; lighter projections live in other tiers as cross-references (LinkRefs back to the canonical home). A thread's primary home is `timelines/<thread-slug>.thread.jsonl`; its derived[] artifacts live as records under `collections/<thread-slug>-derived/...` with LinkRefs back to the thread record.

## When NOT to use

- Lived agent state (Techo ledgers, beads, threads) currently lives under each agent's commissioned home, not under `private/universal/kura/`. The typology APPLIES to those records (a Techo ledger IS a timeline) but the physical location stays agent-local. Kura-aware tools index across agent homes; Kura the org doesn't relocate them.
- One-off configuration files (Package.swift, .gitmodules) don't need to be Kura-classified. The typology is for typed substrate RECORDS, not infrastructure files.

## Related memories

- [[no-github-pushes-pending-codeberg-or-self-hosted]] — Kura-as-canonical for shared storage informs the substrate-self-hosted vs Cloudflare-Artifacts choice
- [[lens-apps-substrate-pattern-2026-05-18]] — apps are lens functions over canonical vault records; this typology refines what "vault record" means (one of four shapes)
- [[bead-vs-thread-vs-beat-shapes]] — the 3 work-item shapes map onto kura tiers (beads ≈ collection, threads ≈ timeline+collection, beats ≈ series-within-scenario)
- [[vaultd-fleece-couchbase-lite]] — Kura's data-plane backends; kurad is the daemon that fronts them
- [[substrate-dotted-form-factor-vocabulary]] — Kura's tier names follow lowercase kebab-case path discipline (`vaults/` `collections/` `series/` `timelines/`)
- [[summon-vs-forge-two-registers]] — Kura uses the Japanese-rooted distinctive register (蔵 = storehouse), matching Shinji Techo, Ikigai
