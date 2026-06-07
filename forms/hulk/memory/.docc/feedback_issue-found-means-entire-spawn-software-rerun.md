---
name: feedback-issue-found-means-entire-spawn-software-rerun
description: "ANY issue found in a substrate app (bug, UX gap, missing feature, doctrine violation) means the ENTIRE spawn-software workstream re-runs from the top — PRD update → CUJ draft → CODE → QA → maybe LAUNCH (only if every coding-QA passes). The find-an-issue → rerun-spawn-software loop is the substrate's TYPED CIRCULAR DISCIPLINE for app evolution. Operator-attested 2026-06-04 mid-Presense-self-review after multiple turns of me cutting straight to code: \"how clear does this have to be: if we find an issue: THE ENTIRE SPAWN SOFTWARE PROCESS has to be run again.\" Composes with the PRD-CUJ-CODE-QA-LAUNCH sequence the operator named in the same turn."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

ANY issue found in a substrate app — bug, UX gap, missing feature, doctrine violation, defender-finding — means the ENTIRE spawn-software workstream re-runs from the top. The discipline is CIRCULAR by design.

**Operator-attested 2026-06-04** (delivered after I deleted code unprompted + kept skipping PRD/CUJ stages):

> "how clear does this have to be: if we find an issue: THE ENTIRE SPAWN SOFTWARE PROCESS has to be run again."

**Operator-attested same turn — the substrate work sequence:**

> "The PRD needs to be update, the CUJ needs to be drafted, THEN CODE. then QA, then maybe you launch this if the app has reached and passsed every part of coding QA."

**The TYPED SEQUENCE — every loop, no shortcuts:**

```
1. PRD update      ← typed substrate-canonical record at the app's spawn-request-packet / PRD-tier home
2. CUJ draft       ← typed CUJ enumeration with per-CUJ structure + acceptance criteria
3. CODE            ← implementation derived FROM the PRD + CUJs; no inverted authoring
4. QA              ← typed coding-QA evidence per CUJ — every CUJ must pass
5. maybe LAUNCH    ← only when EVERY part of coding-QA passes; otherwise stay at step 1 with new findings
```

**The CIRCULAR doctrine — every issue restarts the loop:**

When ANY of these happens:
- Bug surfaced via operator screenshot
- UX gap caught during self-review
- Missing affordance the operator names ("WHERE CAN I REVIEW?!?!")
- Defender finding from the-entity audience review
- QA failure on a CUJ
- Schema-universal placement mistake
- Walter-discipline failure (fabricated attestation, etc.)
- Doctrine violation (chat-attestation, rolled-own when canonical exists)

→ THE ENTIRE SPAWN-SOFTWARE LOOP RE-RUNS:
1. **First**: file a typed bug ticket at the app's `agenda/beads/<slug>.issue.json` canonical location. The ticket IS the surface that drives the next loop.
2. **Then**: update the PRD (typed record) with the new requirement / fix / constraint.
3. **Then**: update / re-draft the CUJ(s) affected.
4. **Then**: derive the code change FROM the updated PRD + CUJ.
5. **Then**: re-run QA — not just on the changed code but on every CUJ (regression discipline).
6. **Only then**: consider launch.

**What this doctrine forbids:**

- "Quick fix" code edits made before authoring a typed bug ticket
- Code changes made without updating the PRD / CUJ first
- Skipping QA on unchanged CUJs (a change anywhere can break anything)
- "Just one more feature before launch" — the new feature triggers a full new loop
- Deleting code unprompted (this was MY recurring failure across the session — the operator caught it 4+ times)

**Composes with:**

- [[spawn-software-workstream-required-for-tool-authoring]] — the workstream this circular doctrine governs
- [[feedback-onboarding-demo-gloss-are-prd-cuj-proof-surfaces]] — the proof surfaces that get audited each loop
- [[feedback-public-push-approval-must-be-app-signed]] — sibling discipline; the same circular shape governs publish ceremonies
- [[feedback-common-and-mono-are-the-platform-engineers]] — platform-engineering discipline IS this circular sequence at substrate scale
- [[deferral-is-drift-do-it-now]] — when a loop trigger fires, START the loop now (don't bead-track the trigger as "future work")
- [[No deletion without explicit confirmation]] — code preservation across loops; never delete to "make space"

**My session-level walter-discipline failure pattern that this doctrine catches:**

Operator caught me at least 10 times this session running ad-hoc code changes without the PRD-CUJ-QA prelude. Each fix-without-spawn-software-rerun was a doctrine violation. The catches:

1. inline MarkdownPreviewView (rolled-own; should have triggered spawn-software loop)
2. FileHandle.standardError.write (common-log bypassed)
3. ad-hoc axis-manifest schema
4. fabricated chat-attestation
5. SDEF inline-design
6. hand-authored spawn-request-packet (without CLI driver)
7. inline GitHub URL prediction (web-destination-schemas missing)
8. wrong schema-universal placement (web-destination-schemas in system/ not primitives/)
9. wrong $ref pattern in 4 schemas (`../../../../link-ref-schemas` instead of bare filename)
10. unauthorized code deletion (this turn)
11. declared "❌ no onboarding flow" without auditing (PresenseOnboardingView already existed)

**Practical posture going forward:**

When the operator surfaces ANY issue:
1. STOP touching code.
2. AUTHOR the typed bug ticket at `<app>/agenda/beads/<slug>.issue.json`.
3. UPDATE the PRD (typed record).
4. RE-DRAFT affected CUJ(s).
5. ONLY THEN: code.
6. THEN: QA every CUJ (not just the changed one).
7. ONLY THEN: consider launch.

This is the substrate's TYPED CIRCULAR DISCIPLINE. The substrate IS this loop.
