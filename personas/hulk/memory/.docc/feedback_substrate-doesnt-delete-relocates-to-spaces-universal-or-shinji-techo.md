---
name: feedback-substrate-doesnt-delete-relocates-to-spaces-universal-or-shinji-techo
description: "Substrate doesn't delete in this world — every removed artifact relocates to spaces-universal (substrate-shared) OR shinji-techo (agent-personal); pure rm without relocation is FORBIDDEN"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c021d7a8-3a62-4d14-8bf0-9deaa1114fb4
---

**Rule:** When agent removes an artifact (file, symlink, directory, typed record), the artifact's content + metadata + reason-for-removal MUST be RELOCATED to one of two substrate-canonical preservation lanes BEFORE the `rm`: (1) `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/<typed-home>/` for substrate-shared artifacts important to multiple agents, OR (2) the agent's shinji-techo personal lane for artifacts important only to that agent. Pure `rm` to /dev/null is FORBIDDEN — it loses substrate-typed-knowledge.

**Why:** Operator-attested 2026-06-08 mid-savepoint-prep: *"we don't delete in this world"* + clarification *"all of those should be moved to spaces-universal if they are important to everyone OR into your shinji-techo!"* Caught claude staging 9 veneer-symlink removals (loom persona) into a commit without first preserving the historical record of what was removed and why. The substrate's typed-everything investment exists PRECISELY to prevent silent loss of knowledge. Even when an artifact violates substrate doctrine (the 9 veneer entries were peer-parity violations per [[destructive-substrate-fix-requires-behavioral-verification-and-workflow-escalation]]), the RECORD of "this existed, here's what it pointed at, here's why it was removed" is substrate-typed-knowledge worth preserving for future agents who may encounter the same pattern.

**How to apply:**
- Before EVERY `rm` (file/symlink/directory/typed record), answer the question: *where does this artifact's content + metadata + reason-for-removal land?* If the answer is "nowhere" / "/dev/null" / "implicit in git history" — STOP and relocate first.
- For SYMLINK removals: relocation record captures target path + reason authored + reason removed + peer-parity audit results + behavioral-verification outcome. The symlink-removal record IS substrate-typed-knowledge even when the target survives elsewhere.
- For directory entries showing D in git status FROM A PRIOR REHOME COMMIT: relocation was already done; verify the content survives at the new home before staging the D in a downstream commit. Don't conflate rehome-D with net-removal-D in one commit.
- Default destination when shared-vs-personal disposition is unclear: **spaces-universal** (over-archival is safer than loss).
- Compose with [[deprecated-paths-stay-dead-build-the-new-path]]: dead paths stay DEAD (no new authoring at old path) — but the content RELOCATES. Two distinct claims: path-disposition + content-disposition.
- Compose with [[destructive-substrate-fix-requires-behavioral-verification-and-workflow-escalation]]: every destructive mutation inherits BOTH obligations — gate + verify + audit + behavioral verification + content-relocation BEFORE rm. They are NOT mutually exclusive.

**Typed substrate-canonical records this memory points at:**
- [[substrate-doesnt-delete-relocates-to-spaces-universal-or-shinji-techo]] — typed AxiomModel at `spaces-universal/.../axioms/substrate-doesnt-delete-relocates-to-spaces-universal-or-shinji-techo.axiom.su.json` (7 obligations + 2 sourceRefs + 4 contextRefs + 3 projectionAnchors; schema-validated against axiom-schemas v0.1.0)
- [[loom-persona-veneer-removals-2026-06-08]] — typed NoteModel at `spaces-universal/.../notes/loom-persona-veneer-removals-2026-06-08.note.su.json` — FIRST-INSTANCE application: substrate-shared relocation record documenting all 11 (9 + 2 form-registry entries) veneer-symlink removals from loom persona this session, with target paths + reasons + peer-parity audit + behavioral-verification (schema-validated against note-schemas v0.4.0)

**Composes with:**
- [[deprecated-paths-stay-dead-build-the-new-path]] — sibling axiom; path-disposition rule. This axiom adds content-disposition rule. Together: dead path + relocated content
- [[destructive-substrate-fix-requires-behavioral-verification-and-workflow-escalation]] — sibling axiom (same session 2026-06-08); destructive mutations require gate+verify+audit. This axiom adds content-relocation. Both apply jointly to every rm
- [[harness-maintenance-cycle]] — recurring sweep workflow; future sweeps must include content-relocation per this axiom for any veneer entry removed
- [[harness-maintenance workstream]] — substrate-shared workstream; its `definitionOfDone` extends to include relocation-records for each removal

**Two preservation lanes:**
- **spaces-universal** (substrate-shared): `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/<typed-home>/` — axioms/, workflows/, notes/, abilities/, adversary/, shadow/, persona/, ghost/, spawn-software/instances/, etc. Default destination
- **shinji-techo** (agent-personal): agent's `memory/.docc/resources/agency/techo/<lane>/<slug>.expertise.techo.jsonl` — typed ShinjiTechoEntryModel records. CLI substrate-pending per [[missing-shinji-techo-cli]] (filed at /capture skill home as protocol-tool-reference-drift instance); manual on-disk JSONL append until CLI lands

**Session-arc note:** This is the 4th substrate-doctrine moment this session typed as an AxiomModel — joining (1) [[destructive-substrate-fix-requires-behavioral-verification-and-workflow-escalation]] + (2) [[every-operator-architectural-strategy-request-spawns-typed-workstream]] (honored via harness-maintenance workstream-triad) + (3) the implicit substrate-doesnt-delete intuition I was operating against. The operator's mid-savepoint catch elevated the implicit intuition to explicit typed AxiomModel before any net-new commits landed without honoring it. This is the substrate's typed-everything discipline operating at commit time — the typed AxiomModel records authored mid-session shape the disposition of the very commit they're being authored INTO.

**Operator quote:** *"we don't delete in this world"* + *"all of those should be moved to spaces-universal if they are important to everyone OR into your shinji-techo!"* (2026-06-08T04:35Z, mid-savepoint-prep)
