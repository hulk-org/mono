---
name: clia-mem app live
description: clia-mem is a live Codex-sessions browser app inside clia-app-org, Sessions-only lane
type: project
---

**clia-mem** is a live macOS app — not planned — at
`private/universal/substrate/collectives/clia-app-org/private/apple/apps/clia-mem/`.
It reads Codex session history via `CliaMemCodexSessions` +
`CodexSessionStoreCore`, with a Sessions-only routing lane (`CliaMemRoute`),
an Apply queue with batch actions, and Swift Testing invariants
(`CliaMemRouteTests`, `CliaMemQueuedOptimizationTests`).

**Why:** Sessions are the canonical corpus; clia-mem is the clia-family lens
onto them (one truth, many lenses). It was split out of the old `clia-git`
surface in commit `3fffe0ca57` along with `source-control` (wrkstrm side).
Subsequent beats aggressively simplified it: dropped Overview, Collectives,
and Git Repos routes; rebranded away from "Operator by CLIA"; pruned all
git-client deps. Sessions is the only lane now.

**How to apply:** When session-history, memory browsing, or Codex rollout
reading comes up, go straight to `clia-app-org/private/apple/apps/clia-mem/`.
The clia agents suite roster is also being trimmed — `clia-tok` and `clia-git`
are being dropped; token/economics UI is moving to an external
"Inference Stats by wrkstrm" app. Don't add new routes to clia-mem casually;
the active direction is fewer lanes, better Sessions depth, and more
Swift Testing coverage of route and apply-queue invariants.
