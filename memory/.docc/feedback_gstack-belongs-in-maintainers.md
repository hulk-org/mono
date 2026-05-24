---
name: gstack-belongs-in-maintainers
description: "gstack (and other third-party skill/tool collections) belongs under substrate's maintainers/ surface, never as flat children of private/universal/substrate/skills/"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 69b77f8e-d423-4eab-8047-cc57f1f69293
---

gstack belongs at `private/universal/substrate/maintainers/gstack/` (third-party-project tracking surface), NOT as ~47 flat `gstack-*` directories under `private/universal/substrate/skills/`.

**Why:** Substrate has a typed top-level layout — `agents/`, `operators/`, `collectives/`, `harnesses/`, `maintainers/`. The `maintainers/` surface is where third-party / external project homes go (peers include `couchbase`, `cloudflare`, `agentify`, `playwright`, etc.). Dumping a vendor's 47 skills into the flat `skills/` tree pollutes the operator's session-time skill list with brand-namespaced entries that aren't substrate-native, and hides the upstream relationship under a coordinate that belongs to substrate-owned skills only.

**How to apply:**
- Skills directly under `private/universal/substrate/skills/` are substrate-native (e.g. `wd`, `roster`, `triads-maintainer`, `agent-setup`, `formatting-core`, `journeychat`, `thread-spin/next/close`, `digikoma-chat-summary`, `agentify-capture`). Author here only when the skill IS a substrate concept.
- Third-party skill/tool collections (gstack, vendor toolkits, anything brand-namespaced) live under `private/universal/substrate/maintainers/<slug>/` and are surfaced via maintainer-home conventions, not by flattening into the skills root.
- If a vendor's skill is needed inside Claude Code's session-time skill list, route it through the maintainer home (symlinks, manifest, or skill adapter under the maintainer's surface) — never by direct placement in `skills/`.
- When cleaning: removing brand-namespaced flat children from `skills/` is correct; recreating the canonical home under `maintainers/` is a separate, explicit decision the operator owns.

Related: [[feedback_assignments-live-in-collective-orgs]] (same shape — typed surface beats flat dumping ground).
