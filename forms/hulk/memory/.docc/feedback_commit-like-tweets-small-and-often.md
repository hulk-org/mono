---
name: Commit like you tweet — small and often
description: Substrate's git commit cadence doctrine. Each commit is one logical unit, committed immediately on completion. No batching. Like tweets — bounded scope, complete thought, ship-worthy on its own. Maps to substrate principles: supersession-not-silent-edit, atomic provenance via receipts, test-harness-grade reviewable/revertable/bisectable changes.
type: feedback
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
# Commit like you tweet — small and often

**Rule:** Each substantive change is its own commit, committed immediately on logical completion. Don't batch unrelated changes. Don't let work accumulate uncommitted "until I have something bigger."

**Why (rismay, 2026-05-17): "you should commit like you tweet. small and often."**

The argument:

1. **Atomic units survive context degradation.** A single doctrine Concept + its Exploration/receipt edits = one commit. If a session dies mid-batch, only the in-flight commit is at risk, not 10+ accumulated changes.
2. **Reviewable on its own.** Tweets that try to say too much fail; commits that try to do too much fail the same way. Each commit message should fit the same "complete thought" shape as a tweet.
3. **Revertable + bisectable.** When something breaks downstream, `git bisect` works only if each commit is one logical change. Batched commits hide which change caused the break.
4. **Substrate-pattern aligned.** Supersession-not-silent-edit doctrine = each supersession is a commit. Provenance receipts = each substantive addition gets a receipt + its own commit. Test-harness rigor = each typed change is one testable unit.
5. **Counter the natural batching instinct.** When in flow, the temptation is to keep typing and "commit when done." That instinct produces large commits that hide what changed. Resist; commit small and often.

## How to apply

Default commit granularity for substrate work:

| Change type | Commit grouping |
|---|---|
| New typed Concept in a vault | One commit (the Concept + Exploration update + receipt update that references it) |
| New vault entirely | One commit (index.md + initial records + receipt) — if more than ~10 files, split into seed-commit + secondary-records-commit |
| New schema in schema-universal | One commit (the .schema.json + family-descriptor update) |
| Memory insight | Memory dir lives outside mono; commit separately, also small-and-often |
| Cross-vault index.md edits | One commit per cross-link pair |

**Anti-pattern:** "Let me batch the next 3 Concepts together since they're related." NO. Commit each separately. Related ones cross-reference each other; that's the substrate's job, not git's.

**Anti-pattern:** "Save this for the wd commit at end of session." NO. The wd commit is the chronicle update + journal + bead spin; substantive code/doctrine changes should already be committed by then.

**Specific session-2026-05-17 lesson:** the wrkstrm-doctrine vault got committed at 5b571470b3 as a single 26-file batch only because doctrine had been firing fast without commit checkpoints. The right cadence would have been: 4-5 commits as the vault grew (foundational Concepts first, then framework Concepts, then applied Concepts, then synthesis Concepts, each in its own commit). Going forward: smaller commits, faster cadence.

## Connection to substrate's other doctrines

- `feedback_workspace-auto-commit-hook.md` — existing pattern; auto-commits already do small-and-often when invoked. This principle generalizes the cadence to all substrate commits.
- supersession-not-silent-edit — each supersession is a small commit naturally
- provenance receipts — each typed-addition gets a receipt; one receipt = one commit
- the substrate's chronicle + journal pattern — these are append-only logs that benefit from small atomic appends, not batched dumps

## Lesson for future sessions

When working on substrate ontology / vault / doctrine: commit each substantive addition immediately. Don't wait for "more." Don't bundle "related" changes. Each Concept, each vault record, each schema-family addition is its own commit. Like tweets: bounded scope, complete thought, ship-worthy on its own.
