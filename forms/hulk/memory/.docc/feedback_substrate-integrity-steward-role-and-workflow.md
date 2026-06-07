---
name: feedback-substrate-integrity-steward-role-and-workflow
description: "The 32-standalone-submodule absorb cascade landed three typed substrate-canonical records (axiom + workflow + role) — pointer entry for those records, NOT a substitute for them."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c5a791f0-7c27-4647-986a-a89122fc8571
---

**Substrate Integrity Steward** — a typed role enacted 2026-06-01 by claude under operator rismay's direction. Repairs substrate git-internals integrity (specifically the 2-step submodule move discipline) when other authoring work leaves submodules in standalone state.

This memory entry is a DOWNSTREAM POINTER. The canonical substrate-truth records are:

- **Axiom** [[submodule-moves-are-2-step-process]] — `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/submodule-moves-are-2-step-process.axiom.su.json` — 7 obligations, persistence category, 4 sourceRefs naming the 3+ instances that triggered the 3x-rule promotion.
- **Workflow** [[substrate-submodule-integrity-repair]] — `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/workflows/substrate-submodule-integrity-repair/v0.1.0/substrate-submodule-integrity-repair.workflow.json` — 6 stages: scan → safety-check → canary-absorb → batch-absorb → verify → document-receipt.
- **Role** [[role-surface-manifest-substrate-integrity-steward]] — `private/universal/substrate/roles/substrate-integrity-steward/private/universal/identity/substrate-integrity-steward.role-surface-manifest.json` — required disciplines, contribution mix (maintenance + governance + tool), 5 stateRefs covering the operational lifecycle.

**Why these records exist (the WHY this memory captures that the typed records don't):**

Operator rismay's 2026-05-31 pushback ("i feel like git submodules didn't have the internal git data also updated. remember, do not reinitialze the submodules are updating their sumodule paths. git submodule moves are a 2 step process") corrected my premature claim that submodule moves were "outside the cascade scope" because their content was untracked. The pushback exposed:

1. Commit `a4a1c3a45b` had renamed operators/{jakor,johnwhitecastle,tkoh,khegh,amanda-champagne,natashenough} → collaborators/X at the .gitmodules layer only — leaving all 6 in-tree .git directories standalone.
2. Substrate-wide audit found 32 of 143 submodules in this state (13 agents + 7 collaborators + 5 collectives + 1 harness + 1 harvest + 3 maintainers + 2 public).
3. 4 additional spaces-universal submodules (gemini-sessions, codex/sessions, chat-gpt-asset-store, egm-page-vault) had the inverse: .gitmodules pointed at the new spaces-universal path, worktree stayed at legacy `private/universal/kura-spaces/X`.

Three confirmed instances of the same doctrine → typed AxiomModel earned (3x-rule).

**The cascade I executed:**
- Canary absorb on `tempo-agent` (retired) — verified .git directory → .git file pointer + `.git/modules/<path>/` populated + worktree intact.
- Batch absorb on remaining 31 via sequential loop (`/tmp/absorb-all.sh`).
- Post-state: 0 standalone, 139 canonical, 4 missing-worktree (the spaces-universal incomplete renames, deferred to separate fix).

**Method lesson — when operator pushes back, listen and verify, don't restate the original claim.** My first response to "can submodule moves be fixed via gitlink updates?" was "no, content is untracked" — too narrow. The operator's second pushback ("the internal git data also") forced the deeper investigation that found the actual 32-broken pattern. This is the inverse of the [[feedback_pause-and-plan-when-decisions-accumulate]] failure mode: there, decisions accumulate without operator nod; here, operator nod was given but I held an over-narrow frame anyway.

**Cascade evidence the substrate-wide-cascade-pattern axiom now has:**
- Cascade #1 (2026-05-30): Contribution typeRef sweep (3453 records)
- Cascade #2 (2026-05-30): SwiftCheck strict-Sendable (15 files)
- Cascade #3 (2026-05-30): IdentityModel v0.X→v0.8 (42 records, 27 owners)
- Cascade #4 (2026-06-01): Substrate submodule integrity repair (32 absorbs)

Composes with:
- [[feedback_submodule-moves-are-2-step-absorbgitdirs]] — the original memory entry from this session's first pass; this entry is the second-pass typed-record-citing version.
- [[feedback_substrate-wide-cascade-pattern]] — the cascade pattern axiom that this absorb cascade was a fourth confirmed instance of.
- [[feedback_typed-axioms-as-typed-tribal-knowledge]] — the doctrine that justified promoting submodule-moves-are-2-step-process from memory to typed AxiomModel.
- [[feedback_breaks-are-good-no-transition-shims]] — `absorbgitdirs` is the substrate-correct "break the standalone state" fix; never use deinit+add transition shims.
