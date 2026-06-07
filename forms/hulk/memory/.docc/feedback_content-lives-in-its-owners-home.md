---
name: content-lives-in-its-owners-home
description: "Substrate content lives in its OWNER's home, not somewhere else's. Personal sites under operators/<slug>/; collective artifacts under collectives/<slug>/. Ownership is the structural axis; historical placement is not load-bearing."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**Content lives in its owner's home.** This is the substrate's universal placement principle: every typed artifact (site, kura collection, package, doctrine doc, schema, fixture) lives under the home of *whoever owns it*, regardless of where it historically ended up.

## The outer shell: the parent substrate IS the rismay.me "org"

Operator-clarified 2026-05-26: *"this parent substrate is the rismay.me 'org' fyi."*

The whole mono substrate (everything under `private/universal/substrate/`) is the **rismay.me organization** — not a directory, an organizational identity. The rismay.me brand owns the substrate; everything inside is a sub-unit of the org.

Within the rismay.me org, content-owners are the sub-tiers — `operators/`, `collectives/`, `agents/`, `roles/`, `harnesses/`, `maintainers/`. The placement formula below applies *within* the org: it picks which sub-unit home a given artifact belongs to.

This means:
- The CF Pages project `rismay-me` is named after the **org**, not a sub-unit
- The deploy-target's `owner: rismay-me` correctly names the org as owner of the deployment
- Sub-units within the org (operators/rismay = rismay-the-operator's personal home; collectives/wrkstrm = the wrkstrm collective; etc.) are content-owners *under* the rismay.me umbrella
- An artifact's owner-sub-unit determines its placement inside the substrate; the org as a whole determines the outer-shell identity (CF Pages naming, deploy ownership, public domain, etc.)

Operator-stated 2026-05-26 after we relocated rismay.me's site source from `collectives/wrkstrm/public/web/...` (wrong sub-unit: rismay's site as a guest in wrkstrm's home) to `operators/rismay/public/web/...` (right sub-unit: rismay's site in rismay-the-operator's home, within the rismay.me org).

## The substrate's universal placement formula

Every artifact's location decomposes into three orthogonal axes:

```
<owner-tier>/<owner-slug>/(public|private)/<content-shape>/<slug>/
└──────┬──────┘ └──────┬──────┘ └──────────┬──────────┘ └────┬────┘
   WHO owns it         IS IT PUBLIC?     WHAT shape is it?  WHICH instance?
```

| Axis | Values | Doctrine |
|---|---|---|
| Owner tier (7 tiers) | `operators/` `collectives/` `agents/` `roles/` `harnesses/` `maintainers/` `audiences/` | this rule (content-lives-in-its-owners-home) |
| Public/private | `public/` or `private/` | [[feedback_kura-public-vs-private-placement]] |
| Content shape | `universal/kura/<tier>/` `web/<site>/` `spm/<package>/` `docc/<bundle>/` `identity/` etc. | [[feedback_kura-tier-axis-definitions]] for the kura tiers; sibling doctrines for web/spm/docc |

**The seven owner tiers, with their content-domain semantics:**

| Tier | Owns content about... | Can host own kura? |
|---|---|---|
| `operators/<slug>/` | a specific human operator's work + identity | ✓ |
| `collectives/<slug>/` | a specific collective/team/org's shared code + content | ✓ |
| `agents/<slug>/` | a specific commissioned agent persona's identity + memory | ✓ |
| `roles/<slug>/` | a specific role's responsibilities + canonical work | ✓ |
| `harnesses/<slug>/` | a specific harness's carrier-shape contract + memory | ✓ |
| `maintainers/<slug>/` | a specific third-party tool/library substrate vendors | ✓ |
| **`audiences/<slug>/`** | a specific typed AudienceModel reader-organism + accumulated audience-specific evidence (kura) | ✓ |

The `audiences/` tier was implicit until 2026-05-26 (the substrate had `audiences/<slug>/private/universal/models/` records but the tier wasn't named in this doctrine). Recognizing it explicitly closes the loop: audiences are first-class owner-homes that can grow their own kura subtrees (per-audience timelines of TTD events, collections of accumulated patterns, series of audience-conversation templates, etc.). The audience contract (`<slug>.audience.json`) is static; the audience's own kura is the typed evidence the substrate accumulates *about* that audience over time.

Decision algorithm for a new artifact:

1. **Who owns this?** → picks the owner tier + slug
2. **Is this published or substrate-internal?** → picks public or private
3. **What shape is it?** (data, code, render-target, doctrine, etc.) → picks the content-shape subdirectory
4. The full path falls out mechanically.

## The diagnostic

When you find content that doesn't fit the formula — typically because it's living in a *sibling* owner's home — the move is to relocate, not to leave it in place.

The test:
- "Does this artifact belong to <owner-of-this-home>?"
- If yes → stays
- If no → relocate to its actual owner's home

This was the switcheroo cleanup's biggest move: rismay.me's site source was in `collectives/wrkstrm/public/web/` because of a historical brand-identity sequence (laussat-studio was once a wrkstrm-adjacent brand → became rismay.me → site didn't follow the rename). The fix wasn't the rename; it was applying the rule "rismay.me is rismay's site, so it lives in `operators/rismay/`."

## Why this matters

1. **Reasoning about ownership becomes mechanical.** Anyone reading a path can answer "whose is this?" by looking at the first two segments after `substrate/`. No need to infer from filenames or content.
2. **Permission boundaries align with filesystem boundaries.** Operators/agents/collectives that own a home are the natural authority for what's inside it. Cross-owner edits become structurally visible (you're editing in someone else's home).
3. **Submodule splits reflect ownership splits.** Most owner homes are their own git submodules. When the filesystem placement matches ownership, the submodule split does too. Cross-owner edits become cross-submodule commits — visible as the substrate's natural unit of "this change crosses an ownership boundary."
4. **Moves are reversible without renaming.** When a brand-identity changes (the laussat-studio → rismay.me switcheroo), the artifact moves *between owner homes* but the artifact's internal identity (filenames, package names, content) can stay stable. Renames and moves become independent operations.

## How to apply

When creating a new artifact:
- Ask "who owns this?" — answer dictates owner tier + slug
- Don't default to "wherever's convenient" (usually some collective)
- An operator's personal site / data / collection goes under `operators/<slug>/`, not under any collective

When discovering misplaced content:
- Check whether the artifact's owner matches the home it's in
- If mismatched → relocate
- Don't leave content in someone else's home "because it's working there"

When renaming brands or identities:
- The rename touches names + paths
- The owner-correct placement may need a separate move
- Doing both in one pass is fine (this session's switcheroo cleanup did both)

## Cross-owner content (the exception clause)

Some artifacts genuinely cross owner boundaries:
- A shared kura collection that multiple actors contribute to → lives under `kura-org/` (the shared-storehouse collective per [[feedback_kura-storage-typology]])
- A doctrine document referenced by multiple agents → lives under `kura-org/` or `wrkstrm/` (the substrate-shared collective)
- A digikoma in the canonical fleet → lives under `digikoma-org/` (the digikoma collective)

The pattern: there's a *designated cross-owner home* for each shared concern. Use it. Don't park shared content in one specific owner's home and ask everyone else to look there.

## History

Operator-stated 2026-05-26 after the rismay.me cross-submodule relocation from `collectives/wrkstrm/public/web/laussat-studio-elementary-ui/` (incorrect, brand-identity-historical) to `operators/rismay/public/web/rismay-me-elementary-ui/` (correct, ownership-honest).

The session's three placement axes are now all named:

1. [[feedback_data-is-one-thing-rendering-is-projection]] — WHAT is the thing (storage vs projection)
2. [[feedback_kura-public-vs-private-placement]] — IS IT PUBLISHED (public vs private)
3. this — WHO OWNS IT (which owner home)

Together they form a complete placement decision.

## Related

- [[project_laussat-studio-rismay-me-switcheroo]] — the canonical case study for this doctrine; the brand-identity move + cross-submodule relocation that surfaced this rule
- [[feedback_kura-public-vs-private-placement]] — public/private axis (sibling)
- [[feedback_kura-tier-axis-definitions]] — content-shape axis (sibling for kura tiers)
- [[feedback_kura-storage-typology]] — the broader 5×5 Kura typology that names the owner tiers
- [[feedback_data-is-one-thing-rendering-is-projection]] — the storage-vs-rendering principle that decouples WHAT from where it renders
