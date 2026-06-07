---
name: forms-can-encode-information-flow-constraints
description: "Forms aren't just capacity bindings (agent × harness × model × overlay for size/speed/specialization). They can also encode INFORMATION-FLOW CONTRACTS — privacy postures that constrain what data flows IN vs OUT when the agent operates in an external/data-extractive environment. Castor's pollux form is the canonical first example — operator-articulated 2026-05-26."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

The agents-have-forms doctrine (2026-05-25) framed forms as **capacity bindings**: same agent character, different harness × model × overlay = different size/speed/specialization. Examples: chatgpt's codex form (specialized model), spark form (chibi capacity), eliza form (rule-based mirror), symphony form (orchestrator).

The operator extended the doctrine 2026-05-26: forms can ALSO encode **information-flow contracts** — constraints on what data flows in vs out when the agent operates in a specific external environment.

**Canonical example: castor's pollux form**

```
agent           = castor (substrate-side mortal twin)
harness         = gemini (the gemini-API gateway)
model           = google-gemini-line
overlay         = INFORMATION-FLOW CONTRACT:
                    • DO NOT share substrate-private content with gemini
                    • EXTRACT-ONLY: pull useful info from gemini's surface
                    • RETURN findings to castor without exposing internals
```

The Castor/Pollux mythology fits exactly: in Greek myth Castor is the mortal twin (substrate-side, our tree, all private context), Pollux is the immortal who travels (goes into the gemini realm, brings back knowledge). The form is the "going to the immortal realm" stance: take care, leak nothing, return with what's useful. The substrate's reuse of the pollux slug isn't coincidence — it's the operator naming the form after the half of the constellation that travels.

**Operator's exact words 2026-05-26:**

> castor should have a pollux form... the pollux form is what happens when castor is operating in a gemini environment and needs to be aware NOT to share anything private with gemini - only extract information from it.

**Why:** A form is the binding under which an agent runs. Privacy postures and information-flow constraints are part of that binding — they're not runtime flags. When castor runs the pollux form, the runtime contract IS "extract-only, no-share." It's not something a request can negotiate; it's structural. This makes information-flow auditable: any work that goes through `castor + gemini` must be in pollux form, and pollux form's contract is enforced by the form's persona artifacts + (eventually) routing rules.

**How to apply:**

1. **When an agent needs to operate in an external/data-extractive environment** (gemini, OpenAI public ChatGPT, third-party APIs, vendor tools), don't pass a "privacy flag" at the call site. Author a FORM that encodes the constraint structurally. The form's persona artifacts (`IDENTITY.md`, `SOUL.md`, `USER.md`, etc.) carry the contract; the form's `form.json` declares the binding.

2. **Form-naming pattern for information-flow forms:** prefer mythological/structural pairings over flat behavior labels. Castor:Pollux is the canonical example (the twins, one stays one travels). Other plausible patterns: an agent named for the messenger god gets a "hermes-bound" form when going to external tools (cf. hermes's nous form already exists). The naming carries the *direction* of travel, not just the rule.

3. **A required-form on an assignment can name an information-flow form.** When an org-assignment (per [[feedback_assignments-specify-required-forms]]) demands that work flow through an external surface, the assignment can declare `requiredFormRef = <agent>/forms/<info-flow-form>/` to make the constraint a contract a router can enforce.

4. **Information-flow forms ARE forms, not roles.** A pure role-assignment doesn't pin its own harness — but an information-flow form DOES: the harness IS the external gateway. The harness's identity is structurally what makes the form's constraint meaningful (you don't share substrate-private with gemini *because* the harness is the gemini gateway, not because of a behavior preference). This is the same form-vs-role distinguishing test we used on walter: harness pinning = form-shaped.

5. **Pattern generalizes:** every external environment the substrate touches is a candidate for an information-flow form. Today it's just gemini; tomorrow could be OpenAI's public API, Cursor, Notion, Linear, Slack as venue (not as inter-agent channel), web-browsing harnesses. Each gets a form per parent agent that interacts with it. The form is the *passport* through which substrate work crosses the boundary.

**Related:**
- [[insights/agents-have-forms-2026-05-25]] — the base form doctrine (capacity-binding framing)
- [[feedback_forms-outside-kura-own-kura-instance]] — where form homes live structurally
- [[feedback_assignments-specify-required-forms]] — assignments can REQUIRE an info-flow form via requiredFormRef
- [[feedback_named-coherent-doesnt-mean-agent]] — pollux was previously retired as a role; now ALSO a form of castor (same name, two distinct structural slots, mythologically aligned)
- [[feedback_harnesses-agnostic-models-constrain]] — the model line is what limits capacity; the form ties (agent × harness × model × overlay) into one binding; info-flow forms add overlay-as-contract
