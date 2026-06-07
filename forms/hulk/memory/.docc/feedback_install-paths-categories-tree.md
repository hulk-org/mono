---
name: Install paths use /Applications/categories/<kebab-id>
description: Substrate apps install under /Applications/categories/<kebab-case-category-id>[/<sub-id>]/<App>.app — never the localized display name; rismay confirmed 2026-05-15
type: feedback
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
Substrate app install paths follow this shape:

```
/Applications/categories/<category-id>[/<subcategory-id>]/<App>.app
```

- `categories/` is an explicit parent that groups substrate apps together
  in Finder; substrate apps don't go flat in `/Applications/` alongside
  Adobe, Microsoft, etc.
- `<category-id>` and `<subcategory-id>` are the **kebab-case `id`
  fields** from `app-store.categories.json` (e.g., `developer-tools`,
  `business`, `productivity`, `games`, `games/simulation`).
- **Never** use `category.displayName.value(for: "en-US")` for the path
  — that's locale-aware display text, not identity.

**Why:**
- **Cross-machine stability.** `developer-tools` is the same string on every
  machine in every locale. Display names change per locale; ids don't.
- **Cross-substrate isolation.** `categories/` parent keeps substrate apps
  clustered, doesn't collide with third-party flat-install conventions.
- **Single source of truth.** The category id flows from JSON →
  resolver → INSTALL_PATH → on-disk path with no string transformation.
- rismay confirmed enthusiastically on 2026-05-15 after the resolver shape
  flipped from `/Applications/Developer Tools/` to
  `/Applications/categories/developer-tools/`.

**How to apply:**
- When emitting `INSTALL_PATH` for any substrate app's project.yml:
  - Use `wrkstrm-identifier install-path --org <org> [--app <name>]` or
    `swift-install-path-cli` to derive the value.
  - The resolver uses `category.id` (not `displayName`). Don't override.
  - Path always starts with `/Applications/categories/`.
- When adding a new category to `app-store.categories.json`: pick a clean
  kebab-case `id` (no spaces, no ampersands — e.g., `health-fitness`,
  `photo-video`, `social-networking`). The id IS the on-disk dirname.
- Localized Finder display is a **future** follow-up via macOS's `.localized`
  folder convention (`developer-tools.localized/.localized/fr-FR.strings`
  shows "Outils de développement" in French Finder). That layer sits ON
  TOP of the kebab-case identity, never replaces it.
- Don't add display-name parsing or capitalization shims into the resolver
  to "make it look nicer" — Finder localization is the correct fix.

**Reference commits:**
- swift-universal `679188dd` — resolver shape change
- digikoma-org `f6d48f3c` — digikoma-plant adopts the pattern
- vapor-wares-org `034ef4601b` — vapor-wares.app adopts the pattern
- mono `4b76bb4838` — pointer bumps
