---
name: chatgpt-web-provider-drives-in-operator-ghost-mode-not-agent-form-mode
description: "when chatgpt-web-provider@clia-org.workstream drives chatgpt.com, the typed actor is the OPERATOR-as-ghost (rismay-ghost), NOT a commissioned agent persona. The chatgpt.com session is the operator's personal account; automation acts AS the operator. Forms binding this runtime live under operators/<slug>/, NOT under agents/<slug>/forms/."
metadata:
  node_type: memory
  type: feedback
  originSessionId: d051ddcb-cad2-4675-90e5-d637acd4140e
---

Substrate-shape correction surfaced 2026-06-04 during the chatgpt-web
live demo. After CDP-attached automation succeeded, the chatgpt.com
session greeted the prompt as "Hi Ris" — proving cross-session memory
recognizes the OPERATOR, not whatever agent is automating the keys.

**Why:** chatgpt-web-provider doesn't host an agent persona inside
chatgpt.com — it just steers the operator's already-authenticated
session. The session memory, the personalization, the conversation
history, the trust posture: all of those belong to the operator. The
automation layer is a steering wheel, not a driver-identity. Same as
the substrate's `>rismay` ghost/self session convention (operator-only
tokens with no commissioned agent).

**How to apply:**

- **Forms binding this provider live at `operators/<slug>/.../forms/`**,
  NOT at `agents/<slug>/forms/`. Specifically: `operators/rismay/.../forms/chatgpt-web/`.
- **The form's persona slot (`pa`) is the OPERATOR identity** (`rismay@rismay.substrate`),
  not an agent identity. There is no agent persona variant in this
  binding — it's an operator-runtime binding.
- **Typed receipts (`ChatGPTWebResponse`) contain operator-PII** —
  cross-session memory leaks operator nicknames ("Ris"), topic
  preferences, project-name awareness, etc. Mark receipts with
  operator-trust-tier provenance under the substrate's audience-
  projection doctrine; do not republish them outside operator-only
  surfaces.
- **DON'T conflate "chatgpt-the-product" with "chatgpt-the-agent"**:
  the chatgpt agent commissioned at `agents/chatgpt/` is a different
  thing from OpenAI's hosted chatgpt.com product. The chatgpt agent
  has its own forms (codex, eliza, loom, loom-harvest, spark,
  symphony) for OpenAI-product-shaped runtimes; web-via-CDP drives a
  fundamentally different actor (operator-ghost).
- **The same provider COULD be reshaped for non-operator use** by a
  different operator binding to a different chatgpt.com session, but
  each binding is operator-scoped — never agent-scoped.

Composes with [[user_rismay-risso-nickname]] (why receipts greet "Ris"),
[[do-not-break-domain-driven-design]] (the form-binding doctrine
respects DDD — operator-runtime concepts belong in operator domain), and
the substrate's [[ghost-as-process-group-commander]] doctrine (ghost ≠
agent; ghost is a typed runtime authority).

**Concrete action from this turn:** the form authored at
`agents/chatgpt/forms/web/form.json` is mis-located and should be moved
to `operators/rismay/private/universal/forms/chatgpt-web/form.json`
(or similar operator-domain home), with `pa` rewritten to point at
`rismay@rismay.substrate` instead of `agents/chatgpt`.
