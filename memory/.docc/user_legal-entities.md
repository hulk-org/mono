---
name: Three legal entities for shipping apps
description: Cristian A Monterroza (personal), Laussat Studio LLC, wrkstrm Inc (C corp). Each can ship apps under different bundle ID prefixes, signing identities, and App Store seller names.
type: user
---

The operator (rismay / Cristian A Monterroza) has **three distinct legal
entities** that can ship Apple software, each with its own Apple
Developer team / signing identity / bundle ID prefix / App Store seller
name:

1. **Cristian A Monterroza (personal)** — personal Apple Developer
   account. Simplest: individual seller name on the App Store, personal
   liability, personal taxes. Good for portfolio pieces, side projects,
   experimental releases.

2. **Laussat Studio LLC** — limited liability company. Pass-through
   taxation, some liability protection, can have multiple members. Good
   for small business / studio-branded apps where the LLC owns the IP.

3. **wrkstrm Inc** — C corp. Separate taxable entity, can issue stock,
   raise capital, hire formally. More overhead but the right home for
   anything that might need outside investment or scale.

**How to apply:**
- When the user discusses shipping a specific app, ask **which of the
  three entities** owns it. The answer determines bundle ID prefix,
  Apple Developer team, signing identity, seller name, tax treatment.
- "wrkstrm" the github org / brand maps to **wrkstrm Inc** (the C corp).
  Apps under `wrkstrm-app` family or that ship as `com.wrkstrm.*` bundle
  IDs go through the C corp.
- "Laussat Studio" maps to **Laussat Studio LLC**. Future
  `collectives/laussat-studio/` or apps under a `studio.laussat.*`
  bundle ID prefix go through the LLC.
- Personal apps go under **Cristian A Monterroza** account, often with
  bundle IDs like `me.rismay.*` (which is what `study-lab.mac` currently
  uses — `me.rismay.studylab.mac.beta`). Note that the bundle ID prefix
  alone does not bind a legal entity; the Apple Developer team
  membership does.
- **Per-app entity assignment is durable** — moving an app from one
  entity to another after launch is non-trivial (App Store transfer
  process, bundle ID can't be reused, user data implications). Worth
  getting right before first release.

**Resolved decisions (as of 2026-04-08 evening):**
- **Reverse-DNS roots** (used as `--root` for `swift-wrkstrm-identifier-cli`):
  - **Laussat Studio LLC** → `studio.laussat` (the LLC owns the
    `laussat.studio` domain; reverse-DNS form is `studio.laussat`)
  - **wrkstrm Inc** → `com.wrkstrm` (existing canonical)
  - **Cristian A Monterroza personal** → `me.rismay`
- **GitHub orgs:**
  - `github.com/laussat-studio` exists (created 2026-01-08, billing
    email `cmonterroza@laussat.studio`, free plan, 1 private repo so far)
  - `github.com/wrkstrm` exists (the wrkstrm Inc canonical org)
  - `github.com/wrkstrm-components` exists (private kits sub-org)
  - `github.com/clia-org`, `github.com/clia-app-org`, `github.com/codeswiftly`
    are all separate orgs with their own positioning
- **wrkstrm Inc platform layer is private for everything.** No
  open-source for the platform. Treat all wrkstrm-org packages as
  proprietary IP held by the C corp.
- **codeswiftly is its own coding brand**, not an incubator. Code Swiftly
  stays as a distinct product surface; it does not get merged into
  Laussat Studio LLC or wrkstrm Inc unless explicitly transferred.

**Still pending:**
- Per-app entity assignment for each clia-app-org app, each
  wrkstrm-app app, and each codeswiftly app. (Prep Lab is decided:
  Laussat Studio LLC, see `project_prep-lab-brand.md`.)
- Trademark search on "Prep Lab" in the education / test prep category
  before printing it on the App Store. Operator has not done this yet.
