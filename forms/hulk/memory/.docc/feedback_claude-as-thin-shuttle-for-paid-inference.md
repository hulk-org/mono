---
name: claude-is-a-thin-shuttle-for-paid-inference-workflows-never-reason-about-content-the-operator-is-paying-chatgpt-another-provider-to-reason-about
description: "Substrate cost-economics rule surfaced 2026-06-04 during the chatgpt-web-provider demo. When the operator drives a workflow through Claude → ChatGPT (or any provider they pay for), Claude MUST NOT consume reasoning tokens on the same content — that's 2x cost for one reasoning act. Claude's role collapses to mechanical shuttle: parse directive, invoke a typed CLI/digikoma, forward typed receipt. All actual reasoning lands at the paid provider."
metadata:
  node_type: memory
  type: feedback
  originSessionId: d051ddcb-cad2-4675-90e5-d637acd4140e
---

**The rule:** When the operator drives a workflow THROUGH Claude that ultimately
calls a different paid inference surface (chatgpt-web-provider, Anthropic API
via a sibling agent, Apple FoundationModels under a metered seat, etc.), Claude
MUST NOT reason about the content. Claude shuttles; the paid provider thinks.

**Why:** Claude tokens AND ChatGPT tokens both cost real money. If Claude
reasons about a creative-selection prompt before forwarding it, the operator
pays for the reasoning twice — once at Claude, once at ChatGPT. The substrate's
cost-circle doctrine ([[substrate-cost-circle]] + [[substrate-is-digikoma-factory-2026-05-23]])
is built specifically to AVOID this — digikomas save agent Stamina by absorbing
work agents would otherwise spend tokens on. Operator stated 2026-06-04:
"i want to be able to do creative selection through you, but I DON'T want you
to consume the tokens because then it's 2x tokens."

**How to apply:**

- **Recognize the shape**: any time the operator says "do X through you using
  chatgpt-web / api-key / FoundationModels / etc." — this rule applies.
- **The substrate-typed answer is a `.digikoma`** (bounded executor) that wraps
  the entire wire dance: templates the prompt from typed records, drives the
  paid provider, captures the typed receipt, returns it. Per
  [[clia-is-cli-assistant-form-factor]] — this is `.cli`/`.digikoma`
  (deterministic), NOT `.clia` (conversational), because conversation IS
  reasoning and reasoning is what we're moving to the paid layer.
- **Claude's allowed token spend per turn** in shuttle mode:
  - parse operator directive (O(directive length))
  - select + invoke the right digikoma (O(1))
  - read + forward typed receipt (O(receipt length))
  - NO reasoning about content semantics, NO prompt engineering mid-flight,
    NO "let me think about whether this is the right stage" — that's the
    paid provider's job.
- **Prompt construction MUST be deterministic-templated from typed records**,
  not Claude-composed. Templates live in the digikoma's source, not in
  Claude's conversation context. If Claude has to "think about how to phrase
  the prompt," the rule has been violated.
- **The discipline applies to the SUBSTANTIVE work content, not workflow
  bookkeeping.** Claude can still:
  - validate the operator's directive against the workstream's typed state
  - choose which digikoma to invoke based on the typed state machine
  - format the typed receipt for human-readable presentation
  - flag errors / schema mismatches in the typed records
  These are O(small) bookkeeping tokens, not reasoning tokens.
- **First concrete instance**: `creative-selection-via-chatgpt-web@wrkstrm.digikoma`
  (proposed 2026-06-04) — wraps `CreativeSelectionWorkstream` library
  `ChatGPTWebProvider` library into one typed CLI. Composes the prompt
  mechanically from typed workstream state, drives chatgpt.com, captures
  `ChatGPTWebResponse` with full provenance triple, advances workstream state.
  Claude invokes the digikoma, never sees inside the wire dance.

**3x-rule promotion candidates** (this rule earns an AxiomModel when seen in 3+
distinct workflow contexts):
1. creative-selection (this turn — instance 1)
2. spawn-software (anticipated — ChatGPT-driven code-gen behind a thin shuttle)
3. maintain-software (anticipated — routine maintenance behind a thin shuttle)
4. workstream-ghost chat (the existing CLIA composeGhostReply Phase-2 binding
   per [[workstream-ghost-chat-protocol-super-attack]] — when reasoning is
   bound to a paid provider, Claude becomes shuttle there too)

Composes with [[substrate-cost-circle]] (the economics this rule
operationalizes), [[substrate-is-digikoma-factory-2026-05-23]] (digikomas as
the bounded-executor primitive), [[feedback_chatgpt-web-runs-as-operator-ghost]]
(why ChatGPT is the operator's reasoning surface, not the substrate's),
[[clia-is-cli-assistant-form-factor]] (`.cli`/`.digikoma` vs `.clia`
distinction), [[constraints-belong-in-types-not-tests]] (the prompt template
is a typed constraint, not Claude's runtime decision).
