---
name: investor-collectives-live-under-collectives
description: "Investor collectives (a16z, etc.) live under `substrate/collectives/<slug>/`, NOT under a separate `substrate/investors/` tier. The investors/ tier is being collapsed into collectives/. Same consolidation pattern as the-entity move."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d9d460c-0cc0-4184-a102-3b6160b868b9
---

**Investor collectives live under `substrate/collectives/<slug>/`, not under a separate `substrate/investors/` tier.** Operator-stated 2026-05-30 (CLIA session, turn 16):

> *"i think we need to do the same thing for investors/a16z to collectives/a16z"*

**The substrate-correct position:**

| Concept | Owner tier | Examples |
|---|---|---|
| **collective** — any organizational entity (firm, investor, partner, accelerator, fund, etc.) | `substrate/collectives/<slug>/` | wrkstrm, openai, schema-universal, **a16z**, **the-entity** |
| **audience** — per-surface reader profile that may REFERENCE collectives | `substrate/audiences/<slug>/` | public-visitor, **a16z-speedrun** (the program reader profile), apple-app-review, investor-first-read, signed-room-user |

This consolidation follows directly from [[feedback_the-entity-is-a-collective-not-an-audience]] (turn 15): "collective" is the substrate-wide owner-tier for any shared organizational entity. Investors are a subclass of collectives — they don't need their own separate tier.

**Move executed 2026-05-30:**

- `substrate/investors/a16z/` → `substrate/collectives/a16z/`
- 28 files inside the moved tree rewritten: `investors/a16z` → `collectives/a16z` (relative path strings, identity-bundle refs, application records, evidence files, collaborator catalogs)
- Zero external references found across the substrate (only internal references existed)
- `substrate/audiences/a16z-speedrun/` UNCHANGED — it's a per-surface reader profile for the a16z Speedrun program, separate concern from the a16z collective home
- `substrate/investors/` tier now empty except for its `.docc/index.md` (orphan tier doc; pending deprecation decision)

**Audience-vs-collective distinction for a16z:**

a16z exhibits the same multi-faceted typing as the-entity (per [[feedback_the-entity-is-a-collective-not-an-audience]]):

| Record | Home | Captures |
|---|---|---|
| **a16z collective home** | `substrate/collectives/a16z/` | The firm itself — identity, relations, investees, applications, evidence, partner correspondence |
| **a16z-speedrun audience profile** | `substrate/audiences/a16z-speedrun/.../a16z-speedrun.audience.json` | The per-surface reader profile for the Speedrun program specifically |
| **a16z-speedrun audience-organism record** | `substrate/audiences/a16z-speedrun/.../a16z-speedrun-audience.organism.json` | Organism-shape projection of the audience |
| **a16z investor-collective identity** | `substrate/collectives/a16z/.../a16z.investor.collective.json` | Local identity marker for the collective home |
| **a16z firm record (canonical)** | `private/universal/vaults/venture-capital/firms/andreessen-horowitz.json` | The factual firm record (separate canonical source — outside both substrate tiers) |

The collective home is *relationship-bearing execution surface* (application state, receipts, relationship notes, correspondence). The audience profile is *per-surface reader projection*. The firm record is *factual entity record*. Three layers; each captures a different facet; joined by slug-equality + LinkRef where typed.

**How to apply:**

1. **No new `substrate/investors/<slug>/` paths going forward.** Place investor collectives at `substrate/collectives/<slug>/` directly.

2. **Audit other investor-coded subtrees.** Any future "should-be-collective-but-living-in-a-typed-subtier" candidate goes to `substrate/collectives/<slug>/`. Tier consolidation is the substrate's current direction.

3. **Same shape applies to other organizational subclasses** if/when they emerge — accelerators, funds, partners, advisors, customers. All collapse to `collectives/` rather than getting their own tiers (unless the operator names a substantive reason to split).

4. **Audience records that reference the collective** stay where they are. The audience-vs-collective separation is per [[feedback_the-entity-is-a-collective-not-an-audience]]: audiences are per-surface; collectives are upstream substrate-wide entities that audiences reference.

5. **The `investors/.docc/index.md` tier doc is now an orphan.** Pending operator decision on whether to delete it, rewrite as a redirect, or convert to documentation history.

6. **When migrating identity content to a Swift Package** (per [[feedback_identity-profiles-are-swift-packages]]), the collective home is the package home. For a16z: `substrate/collectives/a16z/Package.swift` (if/when authored) following the TheEntity proof-of-pattern from [[feedback_the-entity-is-a-collective-not-an-audience]].

## Related

- [[feedback_the-entity-is-a-collective-not-an-audience]] — first instance of the collective-tier doctrine; this memory generalizes it to investor collectives
- [[feedback_content-lives-in-its-owners-home]] — the seven-owner-tier model; collectives are one of the tiers
- [[feedback_identity-profiles-are-swift-packages]] — future a16z package would go at `collectives/a16z/Package.swift`
- [[feedback_adversarial-audience-the-entity]] — the-entity is also a collective; the doctrine applies symmetrically across protagonist/antagonist collectives
