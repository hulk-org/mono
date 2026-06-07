---
name: no-openai-computer-use-mcp
description: "Don't use the OpenAI/Anthropic-provided computer-use MCP tools (mcp__computer-use__*) — operator drives UI themselves; agent only prepares/builds/configures"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# Don't use OpenAI/Anthropic computer-use MCP tools

**Rule**: Never reach for `mcp__computer-use__*` (screenshot / open_application / left_click / type / scroll / request_access / etc.) in substrate work. When UI interaction is needed, operator drives the UI themselves; agent's job ends at preparing the artifact (building the app, installing it, telling operator where to find it).

**Why**: Operator-attested 2026-06-04 mid-Presense + Launch Review session — "don't use the computer use apps from open ai." Substrate-doctrine reasons that compose:

- **Sovereignty**: substrate is closed-source per [[substrate-is-closed-source-no-sharing]] — computer-use streams screenshots + keystrokes + app titles to an external service the substrate doesn't control. That's a sovereignty + privacy boundary the substrate doesn't cross.
- **Adversarial-audience guard**: per [[adversarial-audience-the-entity]] — every public surface assumes a defender constraint; computer-use's stream IS a public surface that could be intercepted / mined / replayed.
- **Paid-inference cost discipline**: per [[claude-as-thin-shuttle-for-paid-inference]] — computer-use sends screen content to a paid inference layer about the operator's screen state. That's exactly the 2x-token failure mode the substrate refuses.
- **Recursion-grounds-at-operator-identity**: per the 2026-06-04 recursion observation — the substrate's typed-everything investment grounds at YOU (operator). Inserting an agent-driven UI layer ABOVE the operator's tap inverts the substrate-doctrine ground. The OS already enforces operator-identity at the permission gate; substrate respects that gate, doesn't try to route around it.
- **Walter-discipline**: substrate has its own tooling discipline; reaching for an external MCP shortcut when the substrate-canonical move (operator drives UI directly) exists is the typed-primitive-bypass failure mode.

**How to apply**:

- When operator's task involves UI interaction (launching an app, clicking through a flow, walking an approval ceremony), DO NOT call any `mcp__computer-use__*` tool.
- Prepare the artifact instead: ensure the app is built, deployed to canonical install path (per `[[Install paths use /Applications/categories/<kebab-id>]]`), and reachable.
- Give operator clear human-readable instructions on where to find it + what to do.
- For app-launch scenarios specifically: tell operator the Spotlight phrase + the Finder path; let them launch it themselves.
- For verdict-recording scenarios: operator drives the UI; operator reports verdict via chat OR via UI directly persisting the typed record; agent updates downstream typed records based on operator's report.

**Composes with**: [[substrate-is-closed-source-no-sharing]] + [[adversarial-audience-the-entity]] + [[claude-as-thin-shuttle-for-paid-inference]] + [[Human visual verification before user-visible actions]] + [[walter-discipline]] + [[approval-recursion-grounds-at-operator-identity]] (the recursion observation) + [[Trash not rm -rf]] (sibling substrate-doctrine safety discipline).

**First catch (2026-06-04)**: Mid-Launch-Review-session, I called `mcp__computer-use__request_access` to try to open Launch Review.app for operator's review ceremony. macOS Accessibility + Screen Recording permission gate intercepted the call. Operator surfaced this rule before the second attempt: "don't use the computer use apps from open ai." Subsequent path: operator opens Launch Review.app themselves via Spotlight or Finder; agent's role ends at app-is-built-and-at-canonical-install-path.
