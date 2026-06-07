---
name: Stop defaulting to trash
description: Reaching for `mv → ~/.Trash/` as the default cleanup move contradicts the substrate's harvest-not-discard doctrine. Working code stays unless explicitly named as dead; "unused right now" ≠ "should be deleted."
type: feedback
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
Reaching for trash as the first cleanup move is wrong-shaped for this substrate. Every time the question is "what do we do with this code that exists but isn't currently consumed?", default to **keep**, not **trash**.

**Why:**
- Memory `feedback_freeze-means-steal.md` — freeze means harvest, not discard
- Memory `feedback_never-trash-under-investigation.md` — build the inspection tool first
- Memory `feedback_no-deletion-without-confirmation.md` — explicit per-file authorization required
- The operator's recurring pattern: merge into canonical (preserve), refactor in place (preserve), surface for review (preserve). Not delete.
- "Unused by the current consumer" is a status, not a verdict. Code can be unused today and consumed by a different surface tomorrow.
- A live example: after we merged `vapor-wares-core` + `vapor-wares-digikoma` from the wrkstrm-app legacy into the new vapor-wares-org canonical (16/16 tests green), I proposed trashing them on the next turn because "the canonical view layer doesn't import them." Operator called this out — the merge purpose was preservation; trashing one turn later reverses the intent.

**How to apply:**
- Default to keep. Working code stays on disk even if the current consumer doesn't use it.
- When something feels orphaned, ask "what could consume this?" before asking "should this be removed?"
- Cleanup proposals are: documenting non-use, marking deprecation in source, flagging in a memory file — NOT trash.
- Actually-broken or actually-superseded artifacts can be trashed with explicit per-file authorization. The bar is "literally cannot be used because it's broken" or "the operator has named it dead."
- When in doubt, surface as a finding ("X is unconsumed right now, what do you want to do?") rather than recommending trash.
- Migrations preserve work in two locations until the destination is proven; the source isn't trashed until the operator confirms parity.
