---
name: tools-back-derive-roles-reverse-derivation
description: Substrate gains by walking workflow→roles→tools FORWARD and tools→roles REVERSE. Catalog the tools each workflow stage uses; back-derive the role-shape per stage; compose the META-ROLE. Mirrors forward derivation but surfaces gap signals + role decomposition.
metadata:
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

The substrate's role-derivation has two directions:

- **Forward**: workstream → roles → role-classes → contribution-types (the canonical pattern; how roles are designed from above)
- **Reverse**: workflow.x-tools-by-stage → role-shape per stage → composed META-ROLE (the new pattern; how roles are decomposed from below)

Both directions hold. Operator 2026-05-31 named the reverse direction: "we can now know what workflows require which roles, which tools. and we can now define the tools which the unknown workflow uses... and then BACK INTO the roles!"

**Why:** the forward pattern is good for AUTHORING roles from scratch but doesn't surface tool gaps or decompose existing role-shapes. The reverse pattern catalogs concrete tools first (which surfaces missing-tool gap signals naturally) and back-derives role-shapes per stage (which exposes the composition mix as a typed contribution-mix). Walking both directions gives the substrate two independent provenance paths for any role.

**How to apply:** For any typed workflow:

1. **Author the tool catalog** at the workflow's `x-tools-by-stage` extension. Each stage carries `tools[]` with `{ slug, kind, ref, purpose }`. Tools that don't exist yet go in a sibling `missingTools[]` block with `candidateForAuthoring` notes — typed gap signals for future substrate authoring.
2. **For each stage's tools, ask "who uses these tools when?"** The answer is a role-shape with a contributionKind (steward / judge / classifier / scout / archivist / liaison / scene-partner / conductor / runner / etc.).
3. **Compose the META-ROLE** that holds all stage role-shapes. Per substrate's role-class-files-not-catalog doctrine, the composed role gets its own home at `substrate/roles/<slug>/` with role-surface-manifest + role-workflow files.
4. **The composition mix is the contribution-mix** for the META-ROLE: weight each contributionKind by how many stages it owns + how load-bearing those stages are.
5. **File missing tools as typed beads** with `candidateForAuthoring` pointing at where the tool should live (digikoma / Swift CLI / harness skill).

**Canonical worked example (2026-05-31)**: unknown-workflow.workflow.json gained `x-tools-by-stage` (7 stages × N tools) + `x-roles-back-derived-from-tools` (7 stage role-shapes → 1 META-ROLE: unknown-workflow-conductor). The META-ROLE landed at `substrate/roles/unknown-workflow-conductor/` with 4-slot contribution-mix (classifier-judge 40%, scout-archivist 20%, liaison-scene-partner 20%, conductor-runner 20%). 3 missing tools surfaced as typed gaps (signal-classification-judge digikoma, workflow-invoker skill, workflow-creation-invoker skill).

**Diagnostic for when to use reverse direction:**

- You have an existing workflow without a typed role → reverse-derive from x-tools-by-stage
- A workflow surfaces tool gaps repeatedly → catalog tools first (forward direction misses gap signals)
- A workflow's role responsibilities feel ambiguous → reverse-derive to expose the contribution mix
- Designing a META-ROLE that spans multiple stages → composition naturally emerges from reverse direction

Composes with [[feedback_role-classes-as-files-not-catalog]] (composed META-ROLE gets its own home file) + [[feedback_share-by-default-skills-and-protocols]] (META-ROLE for shared workflows lives at community substrate/roles/) + [[feedback_error-taxonomy-maps-to-workstream-layer]] (missing tools are typed gap signals in the layer-confusion category).
