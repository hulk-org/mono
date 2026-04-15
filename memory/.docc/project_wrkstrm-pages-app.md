---
name: Page Deploy app branding
description: Display name "Page Deploy"; renamed from "wrkstrm Pages" 2026-04-15; slug page-deploy-by-wrkstrm; bundle me.rismay.page-deploy
type: project
---

`Page Deploy` is the SwiftUI macOS workbench for the wrkstrm web sharing
standard. Lives at `wrkstrm-app/private/apple/apps/page-deploy-by-wrkstrm/`.
Job: compose, validate, and deploy `*.share.json` records against the
canonical `gh-pages/{shares,snapshots,docc}` triple layout.

**Naming choices (updated 2026-04-15):**

- Display name (`CFBundleDisplayName`): `Page Deploy`
- Directory slug: `page-deploy-by-wrkstrm`
- Swift type prefix: `PagesByWrkstrm` (unchanged — internal identifier only)
- Bundle identifier: `me.rismay.page-deploy`
- Marketing tagline: `Page Deploy by wrkstrm`

**Renamed from:** `wrkstrm Pages` / `pages-by-wrkstrm` / `me.rismay.pages-by-wrkstrm`
(original name avoided Apple's "Pages" trademark via brand prefix; new name
is clearer about the app's actual job — deploying pages).

**Why personal entity (not wrkstrm Inc) despite "by wrkstrm" framing:**
User explicitly chose personal namespace. Tension to flag if this ever
ships through wrkstrm Inc's developer team — bundle IDs are durable and
a later move costs a re-submission. If migrated, the new bundle ID would
follow foundry's convention: `com.wrkstrm.page-deploy.mac.app`.
