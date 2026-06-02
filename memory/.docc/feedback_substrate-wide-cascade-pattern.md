---
name: feedback-substrate-wide-cascade-pattern
description: Substrate-wide schema changes ship via a 5-step cascade (typed schema cut → migrator package → Python mirror → per-submodule commits → umbrella) — promoted to typed AxiomModel after 3x proof in one session
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c5a791f0-7c27-4647-986a-a89122fc8571
---

**Substrate-wide cascade pattern** — any change crossing ≥3 substrate-typed records (or ≥3 submodules) must land via the canonical 5-step shape:

1. Cut a typed schema version in `schema-universal`
2. Author a typed migrator package with Swift tests proving the JSON-shape transform
3. Mirror the transform in Python for the bulk data sweep (identical output to the Swift migrator)
4. Commit each touched submodule with its own focused `chore(...)` / `feat(...)` commit + parent pointer bump
5. Close with one umbrella `chore(substrate)` mono root commit naming the cascade

**Why:** Proven 3x in the 2026-05-30 Claude session: (a) Contribution typeRef (3453 records), (b) SwiftCheck strict-Sendable (15 files), (c) IdentityModel v0.X→v0.8 (42 records, 27 owners). Each cascade reused prior automation — pattern compounds. Ad-hoc per-file edits across N submodules are a substrate-weight failure: per-home git blame loses cascade context, and the transform isn't verified once-applied-N-times. Operator's "1. yes. 2. yes" was the explicit go-ahead pattern.

**How to apply:** When you're about to walk N≥3 files/submodules with the same edit, STOP — author the typed migrator first. The substrate carries the typed-discipline cost specifically so cascades like this become cheap; ad-hoc edits skip the test-verified-transform guarantee. Also: run `npm run fmt:json:tracked` (or substrate's canonical formatter) after the sweep — Python json.dump formatting differs from the canonical shape. Re-verify each submodule's HEAD before umbrella commit (transient checkouts can detach HEAD; recover via reflog).

**Promoted to typed AxiomModel** at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/substrate-wide-cascade-pattern.axiom.su.json` (commit `0ece725a0f` 2026-05-31, persistence category). Three sourceRefs (Techo expertise lane, 2026-05-30 cascade commits, operator quote) + three projectionAnchors (the two identity-agent-migrations packages + contribution-migrations).

Composes with [[feedback_breaks-are-good-no-transition-shims]] (the cascade IS how hard cuts ship), [[feedback_pause-and-plan-when-decisions-accumulate]] (cascade discipline IS pause-and-plan applied to schema changes), [[feedback_typed-axioms-as-typed-tribal-knowledge]] (cascade pattern promoted from tribal knowledge to typed axiom via this very pattern).
