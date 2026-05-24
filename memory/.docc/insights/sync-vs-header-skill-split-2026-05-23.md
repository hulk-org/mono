---
name: sync-vs-header-skill-split-2026-05-23
description: "Skill kernels should split \"first-sync bootstrap\" (expensive, once per session) from \"header refresh\" (cheap, once per turn). The CLI should expose a combined state-set+render flag so refresh is one Swift startup, not two."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: eac73541-c0e4-4641-b5d7-46bc8c96a06c
---

When the same skill conflates two cost classes — an expensive bootstrap and a
cheap per-turn refresh — the kernel inevitably documents only the expensive
path, and the cheap path either drifts or pays the bootstrap cost on every
turn. Split them.

**Concrete substrate application (2026-05-23):**

- `/sync` skill is the **first-sync bootstrap**. Reload operator profile,
  resolve commissioned home(s), read the **full** active incident
  (`affectedPaths`, `doNotModify`, `blockedTools`), run
  `swift-agent-cli reload-profile`, optionally `agent-docc generate`, then
  write header state and render in one CLI invocation. Once per session.
- `/header` skill is the **in-session refresh**. Single CLI call:
  `swift-harness-environment-cli header state set --render --quiet`. No
  profile reads, no beat reads, no incident reads. Per-turn safe.
- `swift-harness-environment-cli header state set` now takes `--render` and
  `--quiet` flags so the canonical refresh is one Swift CLI startup, not two
  (`state set` + `header render`). Saves ~0.5s per turn, since
  reply-standard rule 7 demands a re-render whenever mode/title change.

**Why:** The previous `/sync` skill kernel had 8 Fast Path steps but the
operator's `$sync` directive in `rismay-substrate.environment.wrkstrm.json`
listed 12 required checklist items. Two (`reload-profile`,
`agent-docc generate`) were silently dropped by the kernel. Splitting the
skills lets the bootstrap skill faithfully implement the directive while the
refresh skill stays minimal and per-turn cheap.

**How to apply:** Any time a "do everything" skill is being asked to fire on
every turn, look for the bootstrap/refresh axis and split. The bootstrap
skill should match a directive contract item-for-item; the refresh skill
should be one CLI call. If the CLI doesn't yet expose a one-call refresh,
add the combined flag before splitting the skill — otherwise the refresh
skill ends up paying two Swift startups.

Related: [[feedback_definitions-are-json-not-markdown]] — the operator's
`$sync` directive is JSON, and the markdown kernel is a summary of it. A
summary that drops required items is a behavior bug, not brevity.
