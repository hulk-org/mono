# thread-spin SOP

@Metadata {
  @TechnologyRoot
}

Human-readable companion to `thread-spin.operating-protocol.json`. The typed JSON is the executable contract; this markdown is the operator-facing description of why and how the procedure runs.

## Why this skill exists

Threads are the substrate's typed canonical surface for the knowledge-graph ↔ work-graph bridge (per [[threads-bridge-knowledge-and-work-graphs]]). Spinning a new thread is a CONSEQUENTIAL substrate operation — it creates a durable record other agents will read and reference for years. Doing this ad-hoc produces inconsistent threads that downstream agents can't reliably consume.

The thread-spin operating protocol exists so EVERY thread creation follows the same typed contract: same required opener fields, same slug derivation, same persistence layout, same provenance for spawned beads.

## When this skill fires

Three triggers per the typed `OperatingProtocolModel.triggers`:

1. **Operator directive**: any message containing `%thread-spin` (or a line beginning with it).
2. **Scope shift**: the agent recognizes a new intent / scope / lane / risk-posture that warrants a separate thread from the current one.
3. **Handoff need**: an on-disk thread artifact is needed so a different agent can pick up the work.

## The four axioms (substrate-invariants the protocol enforces)

These are the invariants that MUST hold every time thread-spin runs. They're typed in `thread-spin.operating-protocol.json` under `axioms[]`:

1. **Opener contract required** — WHO / ORG / SCOPE / GOAL / DONE-WHEN are all REQUIRED. Missing one = halt and ask. Never infer; never default.
2. **Deterministic slug** — slug derives from GOAL via kebab-case + token budget + hash suffix. Same GOAL → same slug. Enables cross-agent LinkRef-by-slug.
3. **Canonical state on disk first** — substrate filesystem is the canonical record. Discord/room-side state is downstream; `discord.threadId: pending` until the room exists.
4. **Bead provenance** — beads spawned from thread beats carry `sourceType: thread-beat` + `sourceThreadId` + `sourceBeatId`. No orphan beads.

## The seven steps (the typed procedure)

In order, per `OperatingProtocolModel.steps[]`:

1. **Parse directive** — extract the opener fields. Halt if any required field is missing.
2. **Canonicalize owner** — resolve WHO to substrate canonical slug; confirm if unknown.
3. **Build slug** — kebab-case GOAL with hash suffix on collision.
4. **Write canonical state** — `thread.json`, `<slug>.summary.thread.clia.json`, `<slug>.moments.thread.clia.jsonl`, `<slug>.contributions.thread.clia.jsonl`.
5. **Add evidence moments** — if evidence refs provided, append `thread.evidence.added` moments.
6. **Update index** — register in `index.threads.clia.json` for cross-agent discoverability.
7. **Optionally rebuild DocC** — invoke swift-triage-cli docc-site rebuild if the thread should be immediately visible in the substrate's DocC site.

## Expected outcomes

The protocol's `outcomes[]` declares four success conditions:

1. Thread directory created with all four canonical files.
2. Initial `thread.beat` captured (opening direction).
3. Substrate-internal canonical state with `discord.threadId: pending`.
4. Thread index updated.

## When it fails

- **Missing required opener fields**: halt and ask for them by name.
- **Unknown owner / invalid profile metadata**: confirm with operator before creating files.
- **Schema mismatch**: mirror a known thread folder and reopen with corrected fields.

## Substrate-doctrine alignment

This SOP is the first skill graduated to typed `OperatingProtocolModel` per [[agent-blame-shielded-workflow-doctrine-2026-05-26]]. The substrate's existing `operating-protocol-schemas` v0.1.0 is the contract layer; this is the first concrete instance landing under a claude-agent home.

The companion typed JSON (`thread-spin.operating-protocol.json`) is the executable contract substrate tools can validate against. This markdown is the human-facing description. Same content, two registers — agent reads the typed JSON; operator reads the markdown.

## Related substrate doctrine

- [[agent-blame-shielded-workflow-doctrine-2026-05-26]] — operations have typed envelopes; this is one
- [[threads-bridge-knowledge-and-work-graphs]] — why threads matter as substrate's typed surface
- [[bead-vs-thread-vs-beat-shapes]] — the 4-shape work-vocabulary thread-spin produces members of
- [[ordinality-table-entries-immutable-once-released]] — applies to any future enums in this protocol (none yet)
