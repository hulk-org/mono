---
name: Every property fights for its life
description: Substrate aphorism — each property earns its place by pulling load. When a property grows rich semantics it must graduate from an embedded field to its own typed family. Embedded role-shaped types in organism-schemas are the canonical example.
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
**The aphorism**: every property fights for its life. Properties earn their place by pulling load. When a property starts accumulating rich semantics, type variants, or downstream consumers, it has graduated — at that point it must come out of its host's embedded field shape and become its own typed family.

**Canonical example (2026-05-23)**: organism-schemas v0.7.0 still embeds `OrganismRoles` and `OperatorRole` as type definitions. But the substrate has *also* grown a full role-family: `org-role-schemas` (OrgRoleModel + OperatingRhythm), `org-position-schemas` (OrgPositionModel + Occupancy + PositionScope), `org-assignment-schemas` (OrgAssignmentModel + Allocation), `role-workflow-schemas` (RoleWorkflowModel + 4 others). The property *graduated*. The embedded shape in organism-schemas now fights for a life it no longer has — it must come out.

**Why:** Operator articulated 2026-05-23 in the middle of the v1.0.0 manifest investigation: "every property fights for its life. so basically this property became a whole family of properties." The realization came when we discovered org-role-schemas, org-position-schemas, org-assignment-schemas, and role-workflow-schemas are ALREADY members of core-entity-set-v1.0.0 — the substrate had already promoted the family. The cleanup remaining is to **remove the embedded version from organism-schemas**, because the new family is the canonical home.

**How to apply:**
- When you see a property growing rich (more variants, more consumers, more validation logic, downstream type dependencies), treat that as a graduation signal — it wants its own family.
- When you find a property that *already has* a typed family elsewhere in schema-universal, the embedded version in its host should come out. There's an implicit fight-for-life happening: the family WON, the embedded shape LOST. The substrate just hasn't finished the cleanup.
- Watch for the cascade: when a property graduates to a family, agents/entities that USED that property inline now have *implicit instances of the family's types*. Each inline use is an unmaterialized record waiting to be authored. Example: every agent's `roles: []` field is now an unmaterialized OrgAssignmentModel record waiting to be created (agent + role + scope + time).
- Three-way pattern surfaces: ROLE (the reusable mandate) ↔ POSITION (the org-owned seat) ↔ ASSIGNMENT (the time-bounded occupancy of a position by an actor). Once a property graduates to a typed family, this triple is the canonical decomposition.

**Concrete cleanup checklist when a property graduates:**
1. Verify the typed family exists (e.g., org-role-schemas in schema-universal).
2. Audit every host that still has the embedded shape (e.g., organism-schemas with OrganismRoles).
3. Remove the embedded definitions from the host.
4. Update consumers to import from the family, not the host.
5. **Cascade**: materialize the implicit family-typed records on entities that used the inline form. Each unmaterialized record is real authoring work — the substrate isn't complete until the cascade lands.

**Related lessons in the same conversation**:
- `feedback_named-coherent-doesnt-mean-agent.md` — the harvest heuristic that put clip+pollux into `agents/` failed because the substrate didn't have proper role-typing surfaces. Property-fighting-for-its-life predicts that failure: when roles didn't have a clean typed home, the harvest tool defaulted to agent-typing. Promote the family, the heuristic gets sharper.
- `feedback_schemas-live-in-schema-universal-not-consumer-collective.md` — typed families live in schema-universal. When a property graduates, schema-universal is where the family is authored.
