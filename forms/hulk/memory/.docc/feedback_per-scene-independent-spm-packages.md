---
name: per-scene-independent-spm-packages
description: "Every desktop scene (view, wallpaper, Backdrop layer) is its own standalone Swift Package with its own Package.swift — no umbrella catalog Package that bundles multiple scenes as targets"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

When the substrate catalogs **views / scenes / wallpapers / Backdrop
layers** (e.g. the typed catalog under
`laussat-studio/private/apple/desktop-scenes/`), each one must be its
own standalone Swift Package — its own `Package.swift`, its own
`Sources/`, its own `Tests/`, importable independently by any consumer.

**Operator's exact words (2026-06-04, mid-cascade after I authored an
umbrella `desktop-scenes` Package with multiple scene-targets):**
> every one of these views has to be their own swift package we import

**What this rules out:**

- Umbrella `Package.swift` that declares multiple scene targets as
  siblings (`SaboSugiMagicalLandscape`, `AnotherScene`, etc. all under
  one Package).
- Bundling a catalog library + multiple per-scene libraries in the same
  Package — splits the catalog from the scenes.
- Forcing consumers (desktop-studio, future hosts) to depend on every
  scene to use one.

**What this requires:**

- `desktop-scenes/<scene-slug>/Package.swift` per scene.
- Per-scene library product (e.g. `SaboSugiMagicalLandscape`)
  optional sibling exec for preview.
- Per-scene `Tests/` directory inside that scene's Package.
- Per-scene `.scene.json` typed instance (validates against
  `schema-universal/.../desktop-scene-schemas/v0.1.0`) at the Package
  root.
- Consumer apps add the specific scene Packages they want as SPM
  dependencies — no umbrella import.

**Catalog discovery (when needed):**

A catalog of available scenes lives in ITS OWN Package (or simply as
typed `.scene.json` files on disk that any consumer can walk). The
catalog does NOT take per-scene Packages as dependencies — that would
recreate the umbrella problem. The catalog reads metadata from disk.

**Why:**

Same root cause as [[Direct deps over transitive bundling]]
([[feedback_direct-deps-over-transitive-bundling]]) applied at the
scene-catalog layer: when a consumer wants ONE scene, they should
depend on ONE Package, not on a super-bundle that drags in the world.
Per-scene Packages also let each scene evolve at its own version cadence,
ship its own platform requirements (some scenes might need newer Metal
features), and gate its own attribution / license tests independently.

**How to apply going forward:**

1. New scene = new directory at `desktop-scenes/<slug>/` with its own
   `Package.swift`.
2. The `Package.swift` declares one library product (the renderer)
   optionally one exec product (a preview app).
3. The scene's `.scene.json` lives at the Package root, alongside
   `Package.swift`.
4. The scene's `.metal` source + Swift renderer go under
   `Sources/<LibraryName>/`.
5. Tests go under `Tests/<LibraryName>Tests/`.

**Cross-references:**

- [[Direct deps over transitive bundling]] — the umbrella anti-pattern
  this rule extends to the scene-catalog layer.
- [[content-lives-in-its-owners-home]] — desktop scenes live at
  Laussat Studio (the owner of desktop-studio).
- [[credit-our-creators-even-in-closed-source]] — each scene's
  Package preserves creator attribution + verbatim license text.
- [[All schemas live in schema-universal]] — the typed contract
  (`desktop-scene-schemas`) lives at schema-universal, NOT inside any
  individual scene's Package.
