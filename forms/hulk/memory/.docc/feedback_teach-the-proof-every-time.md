---
name: Teach the proof every time
description: Whenever an LDT proof is written or referenced, walk rismay through what the proof claims, how each construct in it enforces the claim, and which line is load-bearing — don't just report "ok: passed".
type: feedback
originSessionId: c5584c6e-7067-4c18-ba07-6e11d5bc5cff
---
When an LDT proof file is written, run, or referenced in conversation, walk rismay through the proof. Don't just print "ok: <summary>" and move on. The proof file IS doctrine, but the *reading* of it is how rismay internalizes the design.

**Why:** rismay introduced LDT as a substrate-wide reasoning discipline (see AGENTS.md "Login Driven Thinking"). The proof's value isn't only that it compiles and asserts — it's that the proof *teaches* the structural claim it encodes. If I write a proof and just say "ok, it passed," rismay learns nothing from the work. If I walk through the proof every time, the type machinery, the lock semantics, the load-bearing lines all become legible. Rismay specifically asked "can you make sure that you teach me the proof every time?" on 2026-04-29 right after the broker constraint-matrix + `~Copyable` proof landed.

**How to apply:**
- After writing an LDT proof, before the "ok" line is the end of the conversation, give a structured walkthrough:
  1. **Claim in plain language** — what does this proof demonstrate, in one sentence.
  2. **Pieces of the construction** — name the types/functions and what role each plays (e.g., "the constraint matrix encodes the rules", "the `~Copyable` session forbids unintended copies", "the `consuming` keyword forces explicit ownership transfer").
  3. **The load-bearing line(s)** — call out which line(s) are the type-level proof, vs. which are runtime preconditions. Usually one of these is a commented-out "misuse" line that the reader can uncomment to feel the compile error.
  4. **How to extend or modify it** — what would need to change to add a new provider/broker/case, and what to expect when it fails.
- This applies even when *referencing* a proof from a previous session — if the conversation cites an LDT proof, walk through it again unless rismay says "I remember this one."
- Compile failures and `precondition` failures are both teaching moments — explain what the failure says about the claim before fixing.
- Keep the teaching tight — one paragraph per piece, no essay-length tutorials. The proof file itself is the long-form spec; the walkthrough is the index into it.

**Positive + negative proof pair (added 2026-04-29):**
Every LDT proof should aim to ship as a *pair*: a positive section that demonstrates the desired behavior compiles + runs (preconditions hold), and a negative section that demonstrates the forbidden behavior would FAIL to compile if uncommented. The negative proof is the type-level enforcement made tangible — readers can uncomment one line, run `swift <file>`, and watch the compiler refuse. Without the negative half, "the type system enforces this" is a claim the proof cannot back. Mark the two sections with `// MARK: - Positive proof (runtime asserts)` and `// MARK: - Negative proof (compile-time refusal)`. If the claim genuinely has no compile-time edge — e.g. a pure runtime invariant — say so explicitly in the doc comment instead of inventing a fake negative.
