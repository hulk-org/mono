---
name: wrkstrm Pages app branding
description: Display name "wrkstrm Pages" deliberately uses brand prefix to dodge Apple's Pages trademark; bundle ID is in personal namespace
type: project
---

`wrkstrm Pages` is the SwiftUI macOS workbench for the wrkstrm web sharing
standard. Lives at `wrkstrm-app/private/apple/apps/pages-by-wrkstrm/`.
Job: compose, validate, and deploy `*.share.json` records against the
canonical `gh-pages/{shares,snapshots,docc}` triple layout.

**Naming choices (durable, decided 2026-04-08):**

- Display name (`CFBundleDisplayName`): `wrkstrm Pages`
- Directory slug: `pages-by-wrkstrm`
- Swift type prefix: `PagesByWrkstrm` (direct PascalCase of the slug,
  matches the `schema-lab → SchemaLab` sibling convention)
- Bundle identifier: `me.rismay.pages-by-wrkstrm`
- Marketing tagline: `Pages by wrkstrm`

**Why not just "Pages":** Apple ships an iWork app called Pages and owns
the mark in the productivity-software class. The `wrkstrm` brand prefix
makes the app distinctive in App Store search and avoids the most
predictable rejection path.

**Why personal entity (not wrkstrm Inc) despite "by wrkstrm" framing:**
User explicitly chose personal namespace. Tension to flag if this ever
ships through wrkstrm Inc's developer team — bundle IDs are durable and
a later move costs a re-submission. If migrated, the new bundle ID would
follow foundry's convention: `com.wrkstrm.pages.mac.app`.
