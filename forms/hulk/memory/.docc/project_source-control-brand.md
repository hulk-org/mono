---
name: Source Control brand (was clia-git)
description: Source Control Mac app brand spec — finalized 2026-04-08; display name, slug, bundle ID, type prefix, legal entity, and agents-suite membership
type: project
---

The Mac app originally named `clia-git` was rebranded to **Source Control** under
the wrkstrm brand on 2026-04-08. It lives in the wrkstrm-app collective, not
clia-app-org.

**Canonical home:**
`private/universal/substrate/collectives/wrkstrm-app/private/apple/apps/source-control-by-wrkstrm/`

**Durable brand spec (finalized 2026-04-08):**

- Display name (`CFBundleDisplayName`): `Source Control`
- Directory slug / Xcode target / scheme: `source-control-by-wrkstrm`
- `PRODUCT_NAME`: `source-control` (so `.app` bundle = `source-control.app`,
  matches the bundle-ID last segment)
- Bundle identifier: `me.rismay.source-control` (deliberately omits
  `-by-wrkstrm` — the `by-wrkstrm` differentiator lives in the repo slug, not
  the shipped artifact)
- Swift type prefix: `SourceControl` (short form, not `SourceControlByWrkstrm`)
- DocC folders: `source-control-by-wrkstrm.{architecture,design,specs,app-store}.docc/`
- Legal entity (long-term): **wrkstrm Inc**
- Legal entity (current shipping): **Cristian A Monterroza (personal)** — all
  ASC submissions go through rismay personal until wrkstrm Inc dev team is set up
- Agents-suite membership: **NOT** in the clia-app-org agents suite; this is a
  wrkstrm product. It belongs to a future "wrkstrm BUILD suite" (which does not
  exist yet as of 2026-04-08). Removed from
  `clia-app-org/private/apple/apps/scripts/{build-and-open,close,check-agents-suite-liveness}-agents-suite.sh`
  and from `clia-app-org/private/apple/apps/.docc/index.md`
  + `AGENTS_VISUAL_IDENTITY.md` during the rebrand.

**Why the wrkstrm framing:** It's a git client for maintainers and operators —
wrkstrm is the developer-tools brand. Per rismay: "The wrkstrm brand keeps CLIA
agents in check." Source Control is the cockpit that reviews what CLIA agents
(and humans) actually changed before it lands — so it must read as a wrkstrm
operator surface, not as another CLIA agent.

**Why bundle ID drops `-by-wrkstrm`:** `me.rismay.source-control` is cleaner
for App Store listing and OS-level identity. The `-by-wrkstrm` suffix is a
repo-organization hint, not a product identity. Display name alone carries the
brand to users.

**Follow-ups not done in the initial rebrand:**

- `CliaCollectivePartnerships` SwiftPM dependency remains (the package name is
  clia-framed but provides GitHub-starred analysis helpers; renaming it is a
  separate larger change).
- `.agentGit` palette case in the shared `AgentIdentityStyle` /
  `ModernSharedAppShell` package is unchanged (renaming ripples across every
  CLIA agent app that consumes the same shared component).
- No ASC credentials file exists at
  `~/.appstoreconnect/credentials/me.rismay.source-control.json` yet; mint one
  before the first TestFlight submission.
- "wrkstrm BUILD suite" scripts do not exist. When created, Source Control
  should be the first entry.
