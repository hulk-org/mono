---
name: typed-axioms-as-typed-tribal-knowledge
description: "Substrate doctrine — typed axioms (AxiomModel instances in kura-spaces/axioms/) ARE the substrate-typed version of \"tribal knowledge\" in engineering teams. The substrate's distinguishing move is making implicit team-doctrine explicit, queryable, and citeable."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

Operator-stated 2026-05-30 (CLIA, wd-doctrine session) after the
16-axiom citation graph landed: "this is called tribal knowledge in
engineering teams." That naming is doctrinally precise.

**The substrate's distinguishing structural move:** make tribal
knowledge typed.

| Engineering teams (tribal knowledge) | Substrate (typed axioms) |
|---|---|
| Implicit — lives in heads | Explicit — `AxiomModel` files |
| Tacit — hard to articulate | Articulated — statement + rationale + obligations |
| Lost when people leave | Persistent — kura-spaces/axioms/ |
| Surfaces only on violation | Queryable — any walker lists by category |
| "Ask the senior" to learn | Citeable — `AxiomCitationRef` from any contract |
| "We've always done it this way" | Auditable — `sourceRefs` trace origin, `projectionAnchors` show enforcement |

**Where this lives in the substrate:**

- Thick doctrine entry: substrate-doctrine kura at
  `kura-org/.../substrate-doctrine/typed-axioms-as-typed-tribal-knowledge.md`
  (**substrate-gap**: not yet authored — flag for follow-up)
- Concrete instances: 16+ axioms at
  `spaces-universal/.../kura-spaces/axioms/<slug>.axiom.su.json`
- Typed schema family: `axiom-schemas v0.1.0`

**How to apply:**

- When you notice you're following a rule "because that's what we
  always do" but can't point to where the rule lives, that's a typed
  axiom waiting to happen. Promote it to `AxiomModel` form with
  statement / rationale / obligations / refs.
- When onboarding a new agent to a workflow, point them at the
  axiom citations on the protocol — that IS the tribal knowledge,
  externalized.
- When a session derives a new axiom (operator-stated, refined
  through pushback), author it as a standalone file rather than
  embedding it inline in a protocol.

Composes with [[feedback_role-classes-as-files-not-catalog]]
(filesystem-pickable typed primitives) and the substrate's recurring
pattern of **typing what other systems leave informal**.
