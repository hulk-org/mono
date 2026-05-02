---
name: Login Driven Thinking (LDT)
description: Every non-trivial structural claim becomes a Swift Testing test under ~/.claude/memory/.docc/repl-proofs/, executed via `swift test --package-path …`. Substrate-wide rule, codified at root AGENTS.md `## Login Driven Thinking (LDT)`.
type: feedback
originSessionId: c051197f-2163-48bf-a3a9-e51c4fe4b87d
---
**Login Driven Thinking (LDT)** is the substrate's reasoning discipline. It
fires at login — when a harness or agent first orients into context, every
non-trivial structural claim it relies on should already have a proof file,
or get one before it ships.

When stating a non-trivial structural claim about substrate contracts, system
invariants, schema shape, or behavioral guarantees, **every proof is a
Swift Testing test**. Save the file at:

```
~/.claude/memory/.docc/repl-proofs/<date>-<topic>.swift
```

The directory is a single Swift Testing package — `Package.swift` declares
one `.testTarget` named `ReplProofs` rooted at `.`. Each proof file is one
function decorated with `@Test`.

The file must:

1. `import Testing` at the top.
2. State the claim, source of truth, and any caught bug in `///` doc
   comments above the test function.
3. Define a `@Test("<short title>")` function — usually
   `func <camelCaseTopic>()`.
4. Model the claim inside the function as nested types/functions.
5. Assert with `#expect(...)` (records each issue and continues — better
   than fail-fast for proofs of disjoint invariants).
6. No `print("ok: …")` — the test runner is the success signal.

Run the corpus with:

```
swift test --package-path ~/.claude/memory/.docc/repl-proofs/
```

No markdown index. The directory listing of `repl-proofs/` is the TOC, the
`///` doc comments inside each `.swift` file are the per-proof metadata,
and `git log` is the change history. Don't create a `reference_*.md`
sibling — it just duplicates what the filesystem and git already provide.

**Why:** rismay codified test-driven thinking as the substrate's reasoning
discipline at root `AGENTS.md` `## Login Driven Thinking (LDT)`
(2026-04-29): "prose is a placeholder, not the contract." rismay then
sharpened it twice: first, every proof must be a compilable `.swift` file
(not an embedded snippet), so a harvester can scrape the directory
directly into a Swift Testing target without parsing markdown. Second, no
markdown index either — the filesystem listing and git history already
serve that purpose. Then on 2026-04-30 rismay asked "can't we use Swift
Testing?" — yes, we can, and we should: `import Testing` doesn't resolve
in pure script mode (verified) but it does in a tiny Package.swift with
one `.testTarget`. Converted from script-mode `precondition` to Swift
Testing `#expect` because `#expect` records each issue and continues
(reveals the full set of broken invariants per run, not just the first),
which is the right shape for proofs of disjoint claims. The first proof
(hulk 11-phase startup) caught a prose off-by-one — I'd been saying
"phase 5" for the persona slot when the index is actually 4 — which is
exactly the kind of slip LDT exists to surface.

**How to apply:** any structural claim ("there are N of X", "exactly one Y",
"swap invalidates only Z", "ordering is …") gets a `@Test func` in a
`.swift` file under `repl-proofs/` written before the claim is shipped.
Use `#expect`, not `precondition` (`precondition` aborts on first failure;
`#expect` collects all failures). Never edit a landed proof file except
to fix a bug — and when you do, add a `// fixed YYYY-MM-DD: <what was
wrong>` line at the top (a `//` regular comment, not `///` — the audit
trail belongs to the file's history, not the test's documentation).
Asserts are append-only: bug fixes *add* asserts, never silently rewrite
existing ones.

LDT applies to ALL harnesses (not just hulk-carried Claude) — the doctrine
lives at the root, equivalent memory paths apply per harness.
