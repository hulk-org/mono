---
name: Opinionated synthesis is what user wants
description: When given partial direction or "your call," respond with opinionated synthesis (named pick + typed model + workflow + UI sketch + per-choice rationale) and explicit redirect affordances; do NOT stepwise permission-ask
type: feedback
originSessionId: e45c8d90-ebba-4176-9460-670eb736f881
---
When the user gives partial direction ("whatever you want," "your call," or describes constraints without naming the thing), respond with **opinionated synthesis**: a named pick + concrete typed model + workflow + UI sketch, where every choice has visible rationale, closed with "doing X next unless you redirect Y/Z" rather than asking permission for each micro-decision.

**Why:** Confirmed loudly on 2026-05-12 during the press-by-wrkstrm design session. After several turns of propose-then-confirm pacing, the user said: "you know what... I'm going with it. i like it when you do this. this type of synthesis is exactly what I am looking for." The session pattern that worked:

- Picked the name (`press`) myself with **multi-signal rationale** (publicity-adjacent + the editor/publicist roles the user described + EGM-faithful aesthetic from prior memory) instead of asking
- Locked rubric axes, role workflow, storage shape with explicit "my lean" markers
- Honored aesthetic micro-details (the 1/16 step → retina/Risograph signature, the EGM hero-ranking treatment) without bikeshedding
- Showed the typed Swift model concretely with full Codable shape, not just prose description
- Every choice carried a one-sentence "why this and not the alternative"
- Closed with "scaffolding next turn unless you redirect [name / rubric / workflow / step]" — gives the user one-sentence redirect path per axis without asking N questions

**Anti-pattern:** asking the user to pick name + storage + scale + workflow + axes one at a time across multiple turns. Burns their attention on bikeshedding when they hired me to synthesize. Stepwise permission-asking reads as deferral, not collaboration.

**How to apply:**

- When briefed with constraints + partial direction, draft the WHOLE shape (name, model, UI, rationale) before composing the response
- Pick the contentious things (naming especially) yourself with rationale tying to MULTIPLE constraints, not just one
- Show typed Swift code for any non-trivial schema; prose alone is too vague to redirect against
- Honor aesthetic micro-details when the user mentions them; treat them as load-bearing signals about their design language (the riso/Risograph/retina cluster is a recurring rismay signature)
- Close with explicit "doing X unless you redirect [these specific axes]" — single sentence with the named axes the user can ping back on
- Pacing: when the user has been giving short green-lights ("yes," "ok," "go"), they want momentum, not more bikeshedding
- This pattern is for design/synthesis moments specifically — for surgical edits or destructive ops, default safety still applies (still confirm before rm/push/etc.)
