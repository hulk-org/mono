---
name: Prep Lab branding and family positioning
description: Prep Lab is the user-facing brand for the study-lab app. Internal codename is study-lab. Belongs to the Laussat Studio or wrkstrm family — NOT the clia family.
type: project
---

**Prep Lab** is the user-facing brand for the macOS / Catalyst study app
that was renamed from `interview-prep` to `study-lab` on 2026-04-08.

**Codename vs brand:**
- **Internal codename:** `study-lab` — used in directories, filenames,
  bundle ids, target names, Swift module/type names, schema package names.
- **User-facing brand:** "Prep Lab" — set as
  `StudyLabDefaults.displayName = "Prep Lab"` in
  `study-lab/study-lab/shared/Sources/App/StudyLabStore.swift`. Shows up
  in onboarding copy, the (now removed) section header chips, and any
  user-visible strings.

**Why:** The user intentionally split the codename from the marketing
name (Apple-style). Don't "fix" the displayName to match the directory
name — they are intentionally different.

**Family / org positioning (resolved 2026-04-08 evening):**
- Owned by **Laussat Studio LLC**.
- Github org: **`github.com/laussat-studio`** (already exists).
- Reverse-DNS root for bundle IDs: **`studio.laussat`** (matches the
  LLC's `laussat.studio` domain).
- Canonical bundle IDs (from `swift-wrkstrm-identifier-cli`):
  - prod macOS: `studio.laussat.preplab.mac.app.prod`
  - beta macOS: `studio.laussat.preplab.mac.app.beta`
  - prod Catalyst: `studio.laussat.preplab.cross.app.prod`
- **NOT** part of the clia family.
- **NOT** a wrkstrm Inc product (wrkstrm is the platform / infra C corp;
  Laussat Studio LLC is the focused-consumer-app studio).
- Currently lives under the `codeswiftly` collective at
  `codeswiftly/private/universal/apple/apps/study-lab/`. There is a doc
  `docs/study-lab-detach-from-code-swiftly.md` indicating intent to
  detach. The destination collective should be a new
  `collectives/laussat-studio/private/apple/apps/prep-lab/` (or
  `.../study-lab/`) when Prep Lab graduates.

**Still pending before first release:**
- Trademark search on "Prep Lab" in the education / test prep
  category. Has NOT been done yet.
- Detach study-lab from `codeswiftly` into a new `laussat-studio`
  collective (mirror layout of `clia-app-org`, `wrkstrm-app`).
- Apple Developer team membership for Laussat Studio LLC needs to be
  set in the shipping target's `DEVELOPMENT_TEAM:` (currently empty).
- Replace placeholder bundle IDs with the canonical
  `studio.laussat.preplab.*` form via `swift-wrkstrm-identifier-cli`.
- App icon: render `PrepLabSectionGlyph` to PNG and replace the ugly
  existing `AppIcon.appiconset`.

**How to apply:**
- When the user asks about "Prep Lab", look in `study-lab/`. They are the
  same product.
- When suggesting brand decisions, default to Laussat Studio or wrkstrm
  framing, never clia.
- When this app eventually moves out of `codeswiftly`, the destination
  collective is most likely a new `laussat-studio` or an existing
  `wrkstrm-app` family. Confirm with user before moving.
- The canonical app icon art is `PrepLabSectionGlyph` (book + flask glyph
  on a dark blue card with gold/blue gradient frame), preserved in
  `study-lab/study-lab/shared/Sources/Shell/StudyLabDetailView.swift`
  with a "PRESERVED FOR APP ICON SOURCE" comment.
