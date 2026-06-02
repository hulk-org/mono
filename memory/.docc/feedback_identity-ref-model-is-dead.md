---
name: All ad-hoc *Ref / *RefModel types are dead — use LinkRefModel v0.3.0
description: Substrate doctrine — LinkRefModel v0.3.0 is THE canonical typed reference shape. Every ad-hoc <Name>Ref / <Name>RefModel is legacy debt (originally noticed for IdentityRefModel 2026-05-23; generalized 2026-05-26 across the full sprawl of 24 ad-hoc ref types). Don't author new ad-hoc ref types; migrate existing ones. EXCEPTION: composite anchoring shapes that wrap a LinkRef PLUS structured metadata (MomentAnchorRef et al.) are legitimate — but those should be named *Model not *Ref since they're not pure pointers.
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
**The rule**: every typed reference from one substrate entity to another uses `LinkRefModel v0.3.0`. Every other ad-hoc `<Name>Ref` / `<Name>RefModel` type is dead (or worth re-examining as a composite shape, not a pure ref).

**Why:** IdentityRefModel was invented before LinkRefModel v0.3.0 existed. Once LinkRef v0.3 shipped — with its richer tagged-binding (`tg[]`) shape and explicit subject tags (`s[]`) — IdentityRefModel had no unique load it could carry that LinkRef couldn't carry better. Operator articulated 2026-05-23: "identity ref model was a mistake. it was invented before link ref v0.3 so we now know what to do." Both shapes were members of `core-entity-set-v1.0.0` (under `identity-ref-model-schemas v0.1.0` and `link-ref-schemas v0.3.0`), but LinkRef won the fight-for-life — IdentityRefModel is now legacy debt to migrate, not a choice.

**Two shapes for reference:**

IdentityRefModel v0.1.0 (DEAD):
```json
{
  "IdentityRefModel": "0.1.0",
  "kind": "org-role",
  "slug": "lead-program-manager",
  "title": "Lead Program Manager",
  "url": "private/universal/substrate/roles/lead-program-manager/private/universal/identity/lead-program-manager.org-role.json"
}
```

LinkRefModel v0.3.0 (CANONICAL):
```json
{
  "LinkRefModel": "0.3.0",
  "tg": [
    {"k": "rp", "v": "private/universal/substrate/roles/lead-program-manager/private/universal/identity/lead-program-manager.org-role.json"}
  ],
  "t": "Lead Program Manager",
  "s": ["org-role", "lead-program-manager"]
}
```

The same information, but LinkRef's `tg[]` is extensible (can hold scheme-side refs like `ss: agent://slug` alongside relative-path refs in `rp`), and `s[]` provides typed subject tags for queries. IdentityRefModel's flat `kind`/`slug`/`title`/`url` couldn't carry that.

**How to apply:**
- **Author new refs as LinkRef v0.3.0.** No IdentityRefModel in any newly authored file. (When I authored `operator-onboarding-steward.org-role.json` in this session, I already correctly used LinkRefModel v0.3.0 in the `links[]` field — that pattern is the doctrine.)
- **When touching a file that has IdentityRefModel refs**, migrate them to LinkRefModel v0.3.0 in the same edit. Don't leave dead-shape refs untouched in files you're already editing.
- **Cascade scope**: every bound agent's `roles[]` array currently uses IdentityRefModel v0.1.0 (verified 2026-05-23 on cadence, carrie, tau, etc.). All of them need migration. Substrate-wide ref-type sweep.
- **No backwards-compat shims.** Substrate doctrine: just change the shape. Don't introduce a "translate-IdentityRefModel-to-LinkRefModel" layer; just rewrite the refs.

**Related lessons in the same conversation**:
- `feedback_every-property-fights-for-its-life.md` — IdentityRefModel vs LinkRefModel is the canonical example of two property shapes fighting for the same semantic load; LinkRef v0.3 won, IdentityRefModel must come out as cleanup.

**Living cascade catalog (as of 2026-05-23):**
Agents observed using IdentityRefModel v0.1.0 in roles[]: cadence, carrie, tau, walter, common, patch, prime, quill, catch. Plus there may be others not in roles[] (e.g., other typed refs scattered through identities, agendas, chronicles). Real audit needed before migration sweep.

---

## 2026-05-26 generalization — the full ad-hoc-ref-type sprawl

The doctrine generalizes from IdentityRefModel (one specific case) to the entire pattern of ad-hoc reference types. Operator 2026-05-26 surveying the 325-name substrate-canonical baseline: "omg, we gotta get rid of these... these are supposed to be LinkRefModel."

### The 24 ad-hoc ref types in core-entity-set-v1.0.0 + companions

**Probably pure pointers (migrate to LinkRefModel):**

- `AgendaAgentRefModel` (agenda-agent-ref-model-schemas — whole family is just this ref)
- `AgentRefModel`, `PersonRefModel` (actor-ref-schemas — whole family is two refs)
- `CollectiveMemberRef` (collective-schemas)
- `PersonaRefs` (identity-schemas)
- `RoleWorkflowRefModel` (role-workflow-schemas)
- `ScenarioRef`, `ScenarioActorRef` (scenario-schemas)
- `SchemaFamilyRef` (harness-schemas)
- `SlugRefModel` (slug-ref-model-schemas — whole family is just this ref)
- `ThreadGoalRefModel` (thread-schemas)
- 9 × `Workstream*RefModel` variants — agenda/proof/receipt/release-gate/role-need/role/step/thread/workflow (workstream-schemas)

**Schema families that exist ONLY to host ad-hoc refs (candidates for retirement):**
- `agenda-agent-ref-model-schemas`
- `actor-ref-schemas`
- `slug-ref-model-schemas`
- `json-lines-object-ref-model-schemas`

**Composite anchoring shapes (legitimate, but misnamed):**

These wrap a LinkRefModel PLUS structured metadata — they're not pure pointers. They warrant a typed model, but should be named `<Name>Model` not `<Name>Ref` because the suffix is misleading:

- `MomentAnchorRef` (note-schemas v0.4.0) — wraps segmentRef (LinkRef) + MomentIndexRow + summary
- `ThreadArtifactRef` (thread-schemas) — wraps a LinkRef + artifact kind
- `BeadsBondRef` / `BondPoint` / `BondPosition` (beads-schemas) — wraps a LinkRef + bond policy
- `JSONLinesObjectRefModel` (json-lines-object-ref-model-schemas) — wraps a LinkRef + objectID + slug

Rename direction: `<Name>Ref` → `<Name>Model` (or `<Name>Anchor`, `<Name>Binding`, whatever the composite truly IS). Original name stays as legacy alias during transition.

### Test for "pure ref vs composite"

Read the type's fields. If they reduce to "a target path + maybe a title + maybe a slug list," it's a pure ref and `LinkRefModel` already covers it — migrate. If the type carries additional structural data alongside the link (an index, a policy, a state, a kind enum), it's a composite — keep the type but rename away from the `Ref` suffix.

### Migration scope (substrate-wide sweep)

Migrating all 24 ad-hoc ref types touches:
- ~20+ schema-universal Swift modules (each ref-using model)
- The Swift consumers across the substrate (CLI tools, agent code, etc.)
- ~thousands of JSON instance records that carry these ref types in the wire
- core-entity-set-v1.0.0.json manifest (4 ref-only families come out; ~24 ref-type entries in `definitions` arrays come out)
- substrate-canonical.terminology.json (24+ entries to remove from the baseline once families retire)

The CRISPR corpus migrator pattern ([[feedback_json-crispr-corpus-migrator-pattern]]) is exactly the tool for this — typed bridge `OldRef → LinkRefModel`, lifted in place across all on-disk records.

### Companion fire-not-ashes doctrine

The substrate's `tradition-preserves-fire-not-ashes` discipline applies cleanly here: every ad-hoc ref type was a *honest first attempt* to name "a typed pointer at another entity." LinkRefModel v0.3 generalized that attempt into one shape with tagged-binding extensibility. The FIRE is "we need typed refs between entities"; the ASHES are the 24 different names that ad-hoc'd it before LinkRef won.
