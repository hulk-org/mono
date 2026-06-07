---
name: kura-public-vs-private-placement
description: "Kura directories that back a public-facing website live under `<owner>/public/.../kura/`; substrate-internal kura lives under `<owner>/private/.../kura/`. Same tier model (vaults/collections/series/timelines/threads), different parent branch."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

Kura directories split between **public** and **private** parents based on whether their content is consumed publicly:

| Surface | Path pattern | Examples |
|---|---|---|
| **Private kura** (substrate-internal) | `<owner>/private/universal/kura/<tier>/<slug>/` | `kura-org/private/universal/kura/collections/command-line-adventures/` (substrate lessons, agent reference) |
| **Public kura** (website-backing or otherwise externally served) | `<owner>/public/universal/kura/<tier>/<slug>/` | (proposed) `operators/rismay/public/universal/kura/collections/institutional-axis/` to back rismay.me |

The Kura tier model (`vaults/` / `collections/` / `series/` / `timelines/` / `threads/`) and the diagnostic for choosing a tier ([[feedback_kura-tier-axis-definitions]]) apply identically in both branches. Only the parent — `private/` vs `public/` — changes based on audience.

## Diagnostic for the split

The test is *who is meant to read this kura tree*:

- If the answer includes "the public" (a website, a public github pages site, an external collaborator viewing a rendered surface) → **public kura**
- If the answer is "agents and operators inside the substrate" → **private kura**

A kura entry meant for both audiences should *live in public and be referenced from private* (one source of truth + private bookkeeping pointing at it) — not duplicated.

## Why the placement matters

1. **gitignore / publishing pipelines** can blanket-include `public/` for site generation and blanket-exclude `private/` — the placement IS the signal to deployment tooling.
2. **Information-flow doctrine.** Anything in `public/` is implicitly an *intentional publication* — its contents can be assumed to be share-safe. `private/` content has no such guarantee. Treating these as different branches enforces the constraint at the filesystem level.
3. **Owner-scoping carries through.** `operators/rismay/public/.../kura/` is rismay's personal public kura. `kura-org/public/.../kura/` would be substrate-shared public kura. The `<owner>/` prefix tells you whose publication this is; the `public/` vs `private/` tells you whether it's published.

## Mapping rismay.me content

rismay.me lives at `operators/rismay/public/gh-pages/rismay-github-io/`. Its current data source is `data/rismay-axis-catalog.json` (one big JSON of all axes).

Migration target:

```
operators/rismay/public/universal/kura/collections/
├── institutional-axis/        ← AX-0001 (Institutions)
├── speedruns-axis/            ← AX-0002 (Speedruns)
├── <next-axis>/
└── ...
```

The existing site build step that generates `data/axis-site-projection.json` becomes the *renderer* — walks the kura tree, projects to JSON for the HTML/JS to consume. The kura tree is the source of truth; the projection is the lens.

## Cross-platform/publishing notes

Public kura under operator homes works fine for personal sites (rismay.me).

For substrate-shared public kura (e.g., things multiple agents want public), the home would be `kura-org/public/universal/kura/<tier>/<slug>/` — kura-org doesn't have a `public/` branch yet, but adding one is straightforward when needed. The pattern is: any owner who has a `private/` MAY add a sibling `public/` with the same internal layout.

## History

Operator-stated 2026-05-26 after describing how rismay.me's site reads from local data files and would migrate to kura: *"remember if these are on a website, these kura directories are in public."* This refines [[feedback_kura-storage-typology]] which named the tiers but didn't distinguish the public/private parent split.

## Related

- [[feedback_kura-storage-typology]] — five-tier × five-owner model; this adds the public/private parent split as a sixth dimension
- [[feedback_kura-tier-axis-definitions]] — collection vs series vs timeline diagnostic; tier choice is independent of public/private placement
- [[insights/lens-apps-substrate-pattern-2026-05-18]] — sites/UIs are lenses on kura storage; the public/private split aligns with the lens-vs-storage decoupling
