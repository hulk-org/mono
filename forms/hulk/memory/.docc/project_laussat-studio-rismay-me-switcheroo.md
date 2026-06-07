---
name: laussat-studio-rismay-me-switcheroo
description: "The substrate did a brand-identity switcheroo between laussat-studio and rismay.me. The directory/CF-Pages/deploy-target names still pointing at `laussat-studio` are leftover staleness, not a separate site."
metadata:
  node_type: memory
  type: project
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate executed a **brand-identity switcheroo** between laussat-studio and rismay.me at some prior point. The decision is settled; what remains is incomplete file/name cleanup.

**Why:** when you see references to both `laussat-studio` and `rismay.me` co-existing in the same directory tree (notably `collectives/wrkstrm/public/web/laussat-studio-elementary-ui/`), they are NOT separate sites. The "laussat-studio" name is the old brand identity; "rismay.me" is the current canonical public-facing identity for the same underlying site. Stale `laussat-studio` references throughout the codebase are leftover from before the swap was committed.

**How to apply:** when triaging laussat-studio references during cleanup:

1. **Don't assume laussat-studio and rismay.me are distinct sites.** They're not. One site, one brand-identity swap, incomplete rename.
2. **`laussat-studio` references in deploy / CF Pages / vite output / directory paths are STALE and should be renamed to `rismay-me`** (or moved to `operators/rismay/public/web/...` for ownership-correct placement).
3. **The `rismay-me-site-model` Swift package** at `wrkstrm-research/.../gym/frontend/rismay-me-site-model/` is the rismay-me-native renderer awaiting graduation from research/gym. It's the post-switcheroo target package.
4. **CF Pages project rename is two-sided**: rename takes effect on Cloudflare's side too (create new `rismay-me` project, deploy to it, cut Worker over, retire old `laussat-studio` project). The local files mirror that but don't drive it.

## Stale laussat-studio references to clean (as of 2026-05-26)

In `collectives/wrkstrm/public/web/laussat-studio-elementary-ui/`:

- `cloudflare/rismay-me-domain-worker.js` — `PAGES_ORIGIN = "https://laussat-studio.pages.dev"` should be `"https://rismay-me.pages.dev"`
- `deploy-target.json` — `owner`, `sourceRoot`, `deployRoot`, `cloudflarePagesProject`, `cloudflarePagesProjects.{dev,staging,production}`, `cloudflareRouteWorker`, `canonicalDomain`, `additionalRouteWorkers[0].pagesOrigin` all carry `laussat-studio` and should be `rismay-me`
- `package.json` — `deploy:{dev,staging,production}` scripts pass `--project-name laussat-studio[-dev|-staging]`
- `vite.config.ts` — `outDir: "dist/laussat-studio"`
- **Directory itself** — `public/web/laussat-studio-elementary-ui/` should be `public/web/rismay-me-elementary-ui/` OR moved entirely to `operators/rismay/public/web/<rismay-me-site>/` for ownership correctness
- `Sources/SiteRenderer/main.swift` — separately also has the data-in-renderer anti-pattern that the kura migration corrects, but that's not part of the switcheroo per se

## Cross-references

- [[feedback_data-is-one-thing-rendering-is-projection]] — the renderer separation is parallel to the switcheroo cleanup; both touch the same files
- [[feedback_kura-public-vs-private-placement]] — moving the site to `operators/rismay/public/` is the ownership-correct placement
- The existing kura timeline at `operators/rismay/public/universal/kura/timelines/institutional-axis/` (seeded 2026-05-26) is what the renamed site will eventually consume

## History

Operator-stated 2026-05-26 during the cleanup inventory of laussat-studio references: *"we did a switcheroo with laussat-studio and rismay.me this is why this looks this way."* This reframes what looked like a two-move refactor (rename + relocate) as a single incomplete-rename cleanup with a clear endpoint.
