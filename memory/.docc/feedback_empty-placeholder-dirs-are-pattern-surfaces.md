---
name: empty-placeholder-dirs-are-pattern-surfaces
description: "Empty (0-byte) named directories in the substrate are intentional pattern-spotting surfaces, NOT dead code. They mark slots the operator is watching for future occupancy. Do not delete just because they have no files inside. Operator-stated 2026-05-26."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

When you find a named, empty directory in the substrate (e.g., `<slug>/` paths with zero files), it can be one of two things — **and only the operator knows which**:

1. **Intentional pattern-spotting placeholder** — the operator named the slot to watch for a future occupancy. The empty directory IS the signal: "the substrate needs this; I'm watching for the right shape to emerge."
2. **Refactor leftover** — a directory that *used* to have content but was emptied during some prior reorganization, then never cleaned up. Functionally dead.

**Default:** ask before deleting. Don't infer from emptiness, age, or absence-of-references — those signals are identical for both cases. The substrate doesn't currently encode the distinction in metadata; only the operator can tell you.

**Why:** the substrate's design discipline includes *pre-naming* slots that aren't filled yet, so the right place to put future work is already reserved and discoverable. But it also accumulates refactor leftovers that are noise. The two are visually indistinguishable. Operator-stated 2026-05-26 when I deleted `swift-agent-cli-commands/` AND `swift-agent-cli-audit/` thinking both were dead. Operator's refinement: "audit should be a command of agent@clia-org.cli" (intentional placeholder — kept), then "agent-commands might be from a previous refactor and can be deleted if it's 0 bytes" (refactor leftover — confirmed deletable).

**How to apply:**
- When an empty named directory shows up in a sweep, surface it to the operator: "I see `X/` is empty — is this a reserved slot for future work, or a refactor leftover I can remove?"
- Don't assume "0 bytes, 0 files, no references = dead." Don't assume "named slot = always keep" either. The signal is intent, not state.
- If the operator confirms it's intentional, the directory has implicit doctrine: the future contents land HERE (subcommand source, sibling package, etc. — depends on the slot's location and naming).
- If the operator confirms it's refactor debris, plain `rmdir` it (works for empty dirs; preserves audit trail in their answer).
- Same caution for empty `.docc/` directories, `tests/` directories without test files, `Sources/<Target>/` shells with only a `.gitkeep`.
- Companion to [[feedback_codex-runtime-state-is-metadata]] (don't treat large-and-old as deletable) and [[tradition-preserves-fire-not-ashes-2026-05-25]] (preserve intent across evolution). The "fire" here is the slot's reservation — if the operator confirms it exists; the "ashes" would be a specific historical naming that may yet change.

**Boundary:**
- Empty *unnamed* scratch directories (e.g., `/tmp/foo-xyz/`, build artifacts, junk-drawer caches) are still fair to clean up without asking.
- The distinction requiring operator confirmation is *intentional naming* in a substrate-canonical location, not the empty state itself.

**Concrete 2026-05-26 record:**
- `swift-agent-cli-audit/` — KEEP (operator-confirmed placeholder for the future `audit` subcommand of `agent@clia-org.cli`).
- `swift-agent-cli-commands/` — DELETED (operator-confirmed refactor leftover; never tracked in git, not propagating across clones).
