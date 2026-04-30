---
name: Login Driven Thinking (LDT)
description: Every non-trivial structural claim becomes a compilable Swift file under ~/.claude/memory/.docc/repl-proofs/ that runs with plain `swift <file>` and prints `ok: …` on success. Substrate-wide rule, codified at root AGENTS.md `## Login Driven Thinking (LDT)`.
type: feedback
originSessionId: c051197f-2163-48bf-a3a9-e51c4fe4b87d
---
**Login Driven Thinking (LDT)** is the substrate's reasoning discipline. It
fires at login — when a harness or agent first orients into context, every
non-trivial structural claim it relies on should already have a proof file,
or get one before it ships.

When stating a non-trivial structural claim about substrate contracts, system
invariants, schema shape, or behavioral guarantees, **every proof is a
compilable Swift file** — not a code block embedded in markdown. Save it
directly as:

```
~/.claude/memory/.docc/repl-proofs/<date>-<topic>.swift
```

The file must:

1. Run as-is with `swift <file>` (script mode — no project, no `Package.swift`).
2. State the claim, source of truth, and any caught bug in `///` doc
   comments at the top.
3. Model the claim as types/functions in the body.
4. Assert it with `precondition(...)`.
5. Print `ok: <summary>` on success (the success signal — `precondition`
   aborts silently on failure otherwise).

Then add one row to `reference_repl-proofs.md`'s table — date, topic, path,
one-liner. The markdown index is a TOC; the `.swift` file is the artifact.

**Why:** rismay codified test-driven thinking as the substrate's reasoning
discipline at root `AGENTS.md` `## Login Driven Thinking (LDT)`
(2026-04-29): "prose is a placeholder, not the contract." rismay then
sharpened it: every proof must be a compilable `.swift` file, not an
embedded snippet, so a harvester can scrape the directory directly into a
Swift Testing target without parsing markdown. rismay then named the
discipline LDT to make explicit that it fires at login — every harness
that boots into the substrate is governed by it. The memory directory IS
the harvest target. The first proof (hulk 11-phase startup) caught a prose
off-by-one — I'd been saying "phase 5" for the persona slot when the index
is actually 4 — which is exactly the kind of slip LDT exists to surface.

**How to apply:** any structural claim ("there are N of X", "exactly one Y",
"swap invalidates only Z", "ordering is …") gets a `.swift` file under
`repl-proofs/` written before the claim is shipped. Use `precondition` not
`#expect` — the former runs in script mode with zero scaffolding, the
latter requires a test target. When proofs graduate into a real `Tests/`
target, the swap is mechanical: `precondition(p)` → `#expect(p)`, wrap top
level in `@Test func <topic>() throws { … }`. Never edit a landed proof
file except to fix a bug — and when you do, add a `// fixed YYYY-MM-DD:
<what was wrong>` doc-comment line at the top.

Staging on the repo working surface (`.tmp/repl-proofs/`) is fine while
iterating, but the canonical home is `~/.claude/memory/.docc/repl-proofs/`.
LDT applies to ALL harnesses (not just hulk-carried Claude) — the doctrine
lives at the root, equivalent memory paths apply per harness.
