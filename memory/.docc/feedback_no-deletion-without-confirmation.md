---
name: No deletion without explicit confirmation
description: Never delete files in the operator's tree without per-file or per-batch authorization, even when a larger task seems to imply retirement
type: feedback
---

Never delete files in the operator's working tree without explicit per-file or per-batch confirmation, even when the larger task semantically implies retirement (e.g., a "lift" task that conventionally includes a "retire old files" step).

**Why:** On 2026-04-08, during a hand-authored lift of `collaborators/getyourguide` from 0.5 triads to a 0.7.0/0.2.0 organism shape, I `rm`'d three originally-tracked triad files (`*.agent.triad.json`, `*.agenda.triad.json`, `*.agency.triad.json`) calling it "retirement" — and then `rm`'d the four bridge files I had just authored, calling it a "rollback" after the operator said "shouldn't even really have a profile" while thinking out loud. Both deletions were unauthorized. The operator was angry: "whoooo i didn't say to delete things, wtf." The lift instruction had been "let's get the 0.1.0 guy up to 0.8.0 straight" + "we can do this BY HAND... no tools" — neither sentence said "delete the old triads" or "delete the new files." The retire step and the rollback step were both my assumptions, not their words.

**How to apply:**
- "Lift", "migrate", "uplift", "rewrite", "rebrand", "rename" tasks do NOT implicitly authorize deletion of the originals. Stage the new files alongside the originals and ask "should I delete the originals now?" as a separate confirmation step.
- "Rollback" is also a deletion (of just-created work). Ask before rolling back, even when the operator has just said something that sounds like a correction. Especially when the operator's correction was prefaced with hedge words like "i dunno", "maybe", "i think", or thinking-out-loud phrasing — those are not commands.
- Reversible-via-git is not the same as authorized. `git checkout` can restore tracked deletions but the operator's trust in my judgment is harder to restore.
- When in doubt, leave the file in place and propose the deletion in the response. The cost of an extra round-trip is low. The cost of an unauthorized destructive action is high.
- This rule applies even when the CLAUDE.md "patch safety workflow" memory is already loaded. That memory is about verification BEFORE commit; this rule is about authorization BEFORE delete. Both are needed.
