---
name: web-scenes-live-in-kura-spaces-tier
description: "Substrate web scenes (capture + web-emission arms) live under the owning collective's kura-spaces tier — `<org>/private/universal/kura-spaces/scenes/<slug>/` — not in a custom `web-scenes/` directory at the universal root"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

Substrate web scenes live in the **kura-spaces tier** of their owning
collective. The canonical home shape is:

```
<org>/private/universal/kura-spaces/scenes/<slug>/
  <slug>.scene.json
  README.md
  capture/
    ...verbatim creator-published files...
  web-emission/
    ...substrate-authored re-rendering files...
```

**Operator's exact words (2026-06-04, after I had placed
sabosugi-magical-landscape at `clia-org/private/universal/web-scenes/`):**
> the web-emmisions should be a kura-space in the right place.

**What this rules out:**

- Custom top-level directories like `web-scenes/`, `scenes/`,
  `wallpapers/` directly under `private/universal/` — these bypass the
  kura-spaces tier and won't be discovered by substrate kura walkers.
- Inventing a new tier name when an existing kura-spaces home applies
  (workflows/, audiences/, mythos/, threads/ are siblings of scenes/).

**What this requires:**

- `<org>/private/universal/kura-spaces/scenes/<slug>/` as the
  per-scene home.
- The `.scene.json` typed instance + capture/ + web-emission/ all live
  inside that home.
- Cross-arm refs (e.g. `desktopSiblingRef`) point at the desktop arm's
  home, which is the Swift-Package per [[per-scene-independent-spm-packages]]
  living at `laussat-studio/private/apple/desktop-scenes/<slug>/`.

**Why:**

- Kura-spaces is the substrate's canonical organizational tier — every
  collective uses the same path shape, so cross-collective walks
  (catalog tools, Scene Lab's discovery, future automation) can find
  scenes without bespoke directory knowledge.
- Per [[kura-public-vs-private-placement]] kura directories use the
  same tier model regardless of public/private branch. Scenes are a
  kura-tier concept, just like workflows/audiences/etc.

**How to apply going forward:**

1. Every new web scene goes at
   `<org>/private/universal/kura-spaces/scenes/<slug>/`.
2. Migrate existing scenes from `web-scenes/` (or similar custom homes)
   to the kura-spaces path when touched.
3. Scene Lab's discovery walks `kura-spaces/scenes/` across known orgs
   — no hardcoded paths beyond the kura-spaces root.

**Cross-references:**

- [[kura-storage-typology]] — kura's tier model.
- [[kura-public-vs-private-placement]] — public vs private branches use
  the same kura tier shape.
- [[per-scene-independent-spm-packages]] — desktop scenes are SPM
  Packages at the apple/ arm; this feedback addresses the web arms only.
- [[three-artifacts-per-ported-scene-capture-canonical-emission]] — the
  three-arm structure that lives inside this kura-spaces home.
- [[content-lives-in-its-owners-home]] — kura-spaces is the canonical
  shape of "owner's home" for typed records.
