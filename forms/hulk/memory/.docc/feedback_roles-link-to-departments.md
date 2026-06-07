---
name: roles-link-to-departments
description: "Substrate roles declare department membership via typed `departmentRef: LinkRefModel?` in their identity record. Departments are first-class owner-homes (new 8th tier `departments/<slug>/`) that own release gates, schemas, kura, and canonical references. Roles inherit department context at load time."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**Roles declare department membership structurally.** Operator-stated 2026-05-26: *"so we need roles to link to this right?"* (in the context of UXW). Same shape as agents declaring ghosts ([[ghost-schemas]]) and harnesses declaring default agents ([[identity-schemas]] v0.6.0's `defaultAgentRef`): the role's identity record carries a typed reference to its owning department.

## Schema addition

`roles/<slug>/<role>.identity.json` gains a `departmentRef` field:

```json
{
  "RoleIdentityModel": "0.X.0",
  "slug": "audience-aware-copywriter",
  "displayName": "Audience-Aware Copywriter",
  "departmentRef": {
    "LinkRefModel": "0.3.0",
    "tg": [{"k": "rp", "p": "private/universal/substrate/departments/uxw"}]
  },
  ...
}
```

Same `LinkRefModel` v0.3.0 wire format as every other typed reference in the substrate. Optional initially (existing roles can backfill); required for new roles in any role-identity-schema bump that ratifies departments.

## Departments as the 8th owner tier

Adding this reference promotes `departments/` from "conceptual grouping" to typed owner-home alongside the existing 7 tiers ([[feedback_content-lives-in-its-owners-home]]):

| Tier | Owns content about... | Can host own kura? |
|---|---|---|
| `operators/<slug>/` | specific human operator | ✓ |
| `collectives/<slug>/` | specific collective/team/org | ✓ |
| `agents/<slug>/` | specific commissioned agent persona | ✓ |
| `roles/<slug>/` | specific role's responsibilities | ✓ |
| `harnesses/<slug>/` | specific harness contract + memory | ✓ |
| `maintainers/<slug>/` | specific third-party vendored tool/library | ✓ |
| `audiences/<slug>/` | specific typed AudienceModel reader | ✓ |
| **`departments/<slug>/`** (NEW) | specific department's roles + release gates + canonical references | ✓ |

Department homes can contain:
- `<slug>.department.json` — typed DepartmentModel record (org-prefix, owned gates, owned schemas, charter)
- `private/universal/identity/` — typed identity bundle
- `private/universal/kura/` — department-owned kura (e.g. UXW's collection of audience-aware-copy patterns, voice-and-tone references, localization briefs)
- `private/universal/doctrine/` — department doctrine documents (UXW's writing style guide, audience taxonomy rules, etc.)
- `public/...` — if the department publishes anything externally (rare; usually surfaces are owned by the consuming home)

## What linking gives us

1. **Department context loads with the role.** When a substrate tool loads `audience-aware-copywriter`, it can follow the `departmentRef` to UXW and inherit:
   - Department-wide voice/style conventions
   - Department-shared canonical references (audience taxonomy, lens primitives)
   - Department-owned gates (so the role knows which release gates it can approve)
2. **Release gates can be department-owned.** `LaunchGate.uxwReviewPassed` ([[feedback_release-gate-audience-review]] generalized) becomes a department-owned gate; only UXW roles can approve it. The substrate enforces gate-approval authority by walking `gate.ownedByDepartment` → match against `approver.role.departmentRef`.
3. **Roster + analytics can group by department.** `roster analyze` could show department-level coverage ("UXW: 1 role audience-aware-copywriter, covering 3/N audiences" vs "InfoSec: 2 roles, covering N/N threat surfaces"). Today the roster groups by role-tier only.
4. **Career-paths-as-graph become possible.** Roles within a department compose (microcopy-author → audience-aware-copywriter → content-strategist within UXW). The substrate can model role-progression graphs once department-membership is typed.
5. **Cross-department roles become explicit.** A role serving two departments declares both; today such overlap is invisible because there's no typed link to begin with.

## Default disposition for existing roles

When the role-identity schema gains `departmentRef`:

| Role | Department |
|---|---|
| audience-aware-copywriter | uxw |
| (future) microcopy-author | uxw |
| (future) content-strategist | uxw |
| (future) localization-brief-author | uxw |
| (future) voice-and-tone-curator | uxw |
| (future) security-reviewer | infosec (TBD) |
| (future) legal-reviewer | legal (TBD) |
| (future) product-reviewer | product (TBD) |

The departments themselves are seeded as we name them. UXW is the first one — operator-named 2026-05-26 ([[feedback_uxw-department]]).

## Schema work needed

1. Bump role-identity-schema to add `departmentRef: LinkRefModel?` field (matches agenda/ghost/default-agent precedent for typed-optional refs)
2. Create new `department-schemas/v0.1.0/` schema family with `DepartmentModel` (slug + displayName + organismKind: "department" + ownedSchemaFamilies + ownedGates + charter)
3. Author `departments/uxw/<uxw>.department.json` as first typed record + `departments/.docc/index.md` declaring the new tier
4. Backfill `audience-aware-copywriter`'s identity record with `departmentRef → departments/uxw`
5. Update [[feedback_content-lives-in-its-owners-home]]'s 7-tier table to 8 tiers (add departments row)

## How to apply

- When authoring a new role: ask "which department owns this role?" → declare `departmentRef`
- When authoring a new LaunchGate case: ask "which department approves this gate?" → record `ownedByDepartment` on the gate
- When organizing kura/doctrine that spans multiple roles in the same discipline: lift it to `departments/<slug>/` rather than duplicating across role homes
- When discovering a role with no plausible department: that's a hint the substrate is missing a department-naming pass; surface the question to the operator

## Pitfalls

- **Treating department as a tag, not a typed reference.** A free-form string `"department": "uxw"` is fragile (no validation, no follow-the-link semantics). Use `LinkRefModel` like every other typed substrate reference.
- **Over-creating departments.** Departments earn their existence by owning multiple roles + canonical references + release gates. A department with 1 role and no gates is premature — promote when the role's surface area justifies it.
- **Skipping the department on infrastructure-y roles.** Even "internal-platform" roles benefit from department membership (release gates, shared doctrine). Default to declaring the department even when it feels obvious.

## History

Operator-stated 2026-05-26 during the UXW naming session: *"so we need roles to link to this right?"* The question is short but doctrinally large — it converts UXW from a tag into a typed structural home that roles, gates, and kura can all reference.

## Related

- [[feedback_uxw-department]] — first department named; canonical example for this rule
- [[feedback_release-gate-audience-review]] — gate that becomes department-owned (UXW)
- [[feedback_content-lives-in-its-owners-home]] — placement formula; promotes from 7 tiers to 8 with departments added
- [[feedback_org-prefix-on-module-names]] — same pattern (typed declared-not-mechanically-derived ownership reference)
