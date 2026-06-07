---
name: schema-family-bump-investigation-docc-pattern
description: "Hand-off pattern — when operator asks for schema-family v0.X.Y data-model suggestions for a version bump, author a 5-page .investigation.docc (index + gap-analysis + proposed-shape + migration-shape + downstream-impact) at <family>/.docc/v0.X+1.0-design.investigation.docc/ rather than the source/Package itself. Typed substrate-canonical hand-off truth other agents can pick up + execute. Codified as [[schema-family-bump-investigation-authoring]] workflow + [[schema-family-bump-investigator]] role 2026-06-01."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

**TYPED-RECORD CANONICAL TRUTH** (per [[capture-requires-typed-workflows-and-roles]]):

This pattern PROMOTED to typed substrate-canonical workflow + role:

- Workflow: `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/workflows/schema-family-bump-investigation-authoring/v0.1.0/schema-family-bump-investigation-authoring.workflow.json` — 8 stages, 9 disciplines, 9 error taxonomy, 5 axiom citations, 1 architecture-constraint citation
- Role: `private/universal/substrate/roles/schema-family-bump-investigator/private/universal/identity/schema-family-bump-investigator.role-surface-manifest.json` — first holder: claude

This memory is the downstream claude-personal pointer.

---

**Pattern**: operator says *"can you make suggestions on the schema data models and how we can get them via a version bump to be more like primitive A and primitive B"* + clarifies *"we are creating investigation and architecture documents so that we can pass on to others so they can do the work."*

The right move is NOT to author the v0.(X+1) Swift Package + sources directly. The right move is to author a hand-off investigation.docc that documents:

1. **index.md** (TechnologyRoot) — why, who reads it, headline summary
2. **gap-analysis.md** — every v0.X field with v0.(X+1) disposition + line citations
3. **proposed-shape.md** — Swift sketches for every changed model + Package layout
4. **migration-shape.md** — typed schema-migrator.json manifesto + per-field transform rules + receipt format + rollback path
5. **downstream-impact.md** — per-consumer change list + .json instance migration + risks + hand-off worker checklist

Saved at canonical `<family>/.docc/v0.(X+1).0-design.investigation.docc/` (parallel to subprocess-migration.investigation.docc precedent at common-process).

**Why investigation.docc and not direct authoring**: per operator framing — the deliverable is the architecture document set itself. A future agent (or another commissioned operator) picks it up and executes. The investigation IS the work order; executing the bump comes later.

**Substrate-doctrine surfaced**: "A Y-bump that consumes a NEW primitive version SHOULD ALSO migrate the inline-typed fossils that the primitive subsumes." First instance recognized in workstream-schemas v0.2.0 (adopted LinkRef v0.3 at goal layer but not event-log layer). 1x pattern — bead-track as candidate axiom for next /capture if recurs.

**Composes with**: [[typed-primitive-bypass-error]] (SEARCH all source + target files before proposing transforms) + [[do-not-break-domain-driven-design]] (transforms within bounded contexts) + [[capture-requires-typed-workflows-and-roles]] (the investigation IS substrate-canonical hand-off truth) + [[schema-family-version-bump]] (the execution-phase sibling workflow this antecedes).

**Inaugural execution**: workstream-schemas v0.3.0 design investigation 2026-06-01. 5 pages, 1106 lines. Operator added cross-link to kura-packed-workstream-workflow-query-constraints architecture doc post-author — captured as substrate-architecture-constraint citation in the workflow's x-substrate-architecture-constraints extension.
