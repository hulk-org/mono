---
name: CLIA Env is the carrier bootstrap layer
description: swift-harness-environment-cli must recognize all carriers (hulk, openclaw, codex) for sync/header/identity to work; P0 alongside Tachikoma
type: project
---

CLIA Environment (`swift-harness-environment-cli`) is the layer that gets
carriers up and running. Without it, sync overrides are cosmetic — the
header still emits `harness: hulk` regardless of what was requested.

**Why:** The operator environment profile
(`operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json`)
is the first sync surface. It defines the harness roster, the active
carrier, the active agent. If the environment CLI doesn't know about a
carrier, that carrier doesn't exist to the substrate tooling layer. Header
renders lie. Sync skill can't resolve the commissioned home honestly.
Identity loading (B-1) can't fire correctly.

**How to apply:**
- Register openclaw (and codex) in the harness roster the environment CLI
  reads — same treatment as hulk
- `header render` must accept `--harness openclaw` and emit the correct
  operator/harness/agent line
- The environment profile is where carrier selection lives — not in
  slash-command cosmetics or per-session overrides that get thrown away
- This is P0 alongside Tachikoma: Tachikoma gives the carrier
  self-awareness (S-5), CLIA Env gives the carrier existence in the
  substrate
