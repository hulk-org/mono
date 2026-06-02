---
name: deferral-is-drift-do-it-now
description: "AXIOM (PROMOTED 2026-06-01 to typed AxiomModel at kura-spaces/axioms/deferral-is-drift-do-it-now.axiom.su.json — this memory is downstream POINTER) — deferring an applicable typed-substrate-primitive retrofit to a future bead/turn = DRIFT — same error class as rehome-not-archive; when the primitive applies NOW and the discipline is named, ship the retrofit NOW"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

**TYPED-RECORD CANONICAL TRUTH**: This pattern PROMOTED to typed `AxiomModel` instance at:
`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/deferral-is-drift-do-it-now.axiom.su.json` (authored 2026-06-01 under /capture protocol). Promotion was itself a dogfood: the axiom says 'ship inline' — landed during /capture rather than bead-tracked to a future session.

---


operator 2026-05-31 in response to my deferral proposal for CommonShell retrofit: "NOOOOOO you should not make drift."

**Rule**: When a typed-substrate primitive has been identified + memorized + IS APPLICABLE to in-flight code, the retrofit MUST happen in the SAME turn the directive arrives. Deferring to "next focused turn" or "bead-track for later" = SUBSTRATE DRIFT.

**Why**: per [[feedback_rehome-not-archive-substrate-cleanup]] — substrate drift accumulates when work that COULD land now is sidelined as future-work. Beads should track NEW work, not WORK YOU SHOULD HAVE DONE THIS TURN. The same diagnostic applies: "if we were authoring this today, where would it live?" — if the answer is "with the typed primitive applied," then the typed primitive MUST be applied this turn; deferring writes substrate-debt the same way archive tiers warehouse substrate-dead content. Per [[feedback_breaks-are-good-no-transition-shims]] — sharp commits + immediate application + no preservation of pre-axiom shapes.

**How to apply**:
- When the operator names an applicable typed primitive (CommonShell, CommonProcess, DigikomaConversationPacketFactory, ghost-shell-IPC, AsyncParsableCommand, etc.) AND I have in-flight code where the primitive applies → retrofit in THIS turn's cascade commit.
- Do NOT propose "bead-track for next focused turn" when the work can land now. The cost of one extra commit-cascade in this turn beats the cost of substrate-debt accumulating across turns.
- The ONLY exceptions to immediate-retrofit: (a) the retrofit introduces an unresolved build failure WITHOUT a clean workaround AND I've verified the unresolved failure (not a guess); (b) the operator explicitly says "defer it"; (c) the retrofit scope is unbounded (e.g. "retrofit ALL 100 substrate Packages") in which case scope-shape the retrofit but DO the immediately-touched file's retrofit.
- When in doubt, the discipline says: SHIP IT NOW.

**Failure mode I demonstrated this turn**: I proposed "(β) Defer the CommonShell retrofit to a focused turn with bead `common-shell-retrofit-workstream-packages` covering all 5 workstream Packages at once." Operator caught immediately: "NOOOOOO you should not make drift." The deferral was substrate-bypass disguised as discipline. The right move was always (α) ship now — the typed primitive applies, I'm IN the file, the directive is FRESH.

**3x-rule check**: per [[feedback_substrate-wide-cascade-pattern]] this is the FIRST formally-named instance of "deferral-is-drift" as a distinct doctrine. Composes with [[feedback_rehome-not-archive-substrate-cleanup]] (same error class for substrate-content), [[feedback_breaks-are-good-no-transition-shims]] (same error class for transitional shims), [[feedback_typed-primitive-bypass-3x-rule-confirmed]] (same error class for typed-primitive bypass). All four point at the same metarule: SUBSTRATE WORK THAT CAN LAND NOW SHOULD LAND NOW; future-tracking creates drift; sharp commits + immediate application is the discipline.

**Operational consequence**: I retrofit the CommonShell + CommonShellArguments deps into creative-selection's `.cli` + `.clia` in the SAME turn this memory was authored. No bead-track. Commit + cascade now.

**Composes with**: [[feedback_rehome-not-archive-substrate-cleanup]] + [[feedback_breaks-are-good-no-transition-shims]] + [[feedback_typed-primitive-bypass-3x-rule-confirmed]] + [[feedback_common-process-shell-cli-typed-primitives]] (the typed precedent that triggered this) + [[feedback_turn-is-commit]] (the turn = the cascade-commit shape).
