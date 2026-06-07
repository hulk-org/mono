---
name: no-typealias-no-export-no-breadcrumb
description: "Sharpening of the [[insights/tradition-preserves-fire-not-ashes-2026-05-25]] doctrine. Ashes belong in git history, not in active documentation or code. No typealias, no re-export, no historical-name parenthetical that keeps the dead name \"known.\" When the substrate evolves, the old form dies completely. Active docs/code carry the current truth only. Operator-stated 2026-05-26 after I left a \"(formerly `swift-harness-environment-cli`)\" parenthetical in a SKILL.md."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

The "ashes can stay where they fell" doctrine is about **git history and old commits/records** — NOT about active documentation or code. When the substrate evolves a name, the OLD form should die completely in living surfaces:

- **No `typealias OldName = NewName` shims** in Swift.
- **No `public typealias` re-exports** that keep the old symbol importable.
- **No `(formerly X)` parentheticals** in active SKILL.md / README.md / CLAUDE.md / AGENTS.md.
- **No "deprecated, prefer X" notes** that still mention the old name as a recognizable identifier.

If a future reader needs the history, they use `git log` / `git blame`. Active living documentation carries one truth: what the substrate IS NOW.

**Operator-stated 2026-05-26:** "no... that is an ash. no typealias, no export." (Reacting to my "(formerly `swift-harness-environment-cli` under `wrkstrm-core`)" parenthetical in sync SKILL.md after the binary rename.)

**Why:**
- Every historical-name breadcrumb in active docs creates a search trap. New agents/readers hit the old name and aren't sure if it's still valid. They have to reason about "is this current or historical?" — cognitive load the substrate shouldn't impose.
- Typealiases and re-exports actively SUSTAIN the old name as a working identifier. The compiler still resolves it. The IDE still autocompletes it. The doc still indexes it. That's not "preservation" — that's keeping the dead alive enough to confuse the living.
- McLuhan applies (see [[insights/medium-is-the-message-substrate-2026-05-26]]): if the medium carries the old name, the message includes the old name, regardless of how it's labeled. "Formerly X" is still X being communicated.

**How to apply:**
- When renaming a Swift identifier, **delete every reference to the old one** in active code. No `typealias`, no `@available(*, deprecated, renamed:)` shim. Old commits keep the history.
- When renaming a binary, file, or package, **strip every active-doc reference to the old name** as part of the rename PR. No "(formerly X)" notes.
- When updating an existing doctrine memory, the doctrine itself can mention the old shape for *origin context* (the doctrine documents itself). The DELTA between old and new is the doctrine's content; the OLD NAME isn't a feature of the substrate to preserve.
- If you find yourself writing "this used to be called X" in an active surface, stop. The reader doesn't need that breadcrumb; the present-tense surface should carry only present truth.

**Boundary:**
- This applies to **active surfaces**: living documentation, current code, current configs, current memory doctrines that describe substrate-as-it-is.
- This does NOT apply to:
  - **git history** — commits keep their names forever (that's the whole point of git).
  - **historical journal entries** (`memory/.docc/journal/articles/journal-2026-XX-XX.md`) — those are dated records of past sessions; the past names are accurate to those dates.
  - **session-bound rollout summaries** under `harnesses/<slug>/memories/rollout_summaries/` — same: dated, past-tense, historical.
  - **the doctrine memory documenting the rename ITSELF** — when explaining WHY a rename happened, naming both old and new is the content. Example: this very memory file mentions `swift-harness-environment-cli` because the doctrine IS about not-mentioning-it; meta-mention is allowed inside its own doctrine record.

**Test for "ash vs. active":**
- Is this surface read in the present tense to drive current behavior? → ACTIVE. Strip old names.
- Is this surface explicitly past-dated (journal article, rollout summary, git commit) or describing the rename rationale itself? → HISTORICAL. Old names accurate to context can stay.

**Companion entries:**
- [[insights/tradition-preserves-fire-not-ashes-2026-05-25]] — the parent doctrine this sharpens.
- [[insights/medium-is-the-message-substrate-2026-05-26]] — why breadcrumb-in-active-doc IS message-pollution.
- [[feedback_no-rewrite-history]] — the inverse pair: historical records stay valid as-of-their-date; this rule says active surfaces don't.
