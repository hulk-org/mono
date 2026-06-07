---
name: assignments-specify-required-forms
description: "Assignments are `role × actor × org-scope × REQUIRED-FORM`. Adding the required-form axis turns an assignment from shape-blind (\"carrie does biographer work\") into capacity-honest (\"biographer-carrie runs on carrie's walter form\"). Foundational pattern for capacity-aware routing — operator-articulated 2026-05-26."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

Substrate assignments are now four-axis, not three. The four axes:

1. **role** — what work is being done (slug like `biographer`, `design-system-steward`)
2. **actor** — which agent fulfills it (slug like `carrie`, `castor`)
3. **org-scope** — which collective the work happens in (slug like `wrkstrm`, `google`)
4. **required-form** — which form (capacity binding) of the actor MUST run the work — a LinkRef to `agents/<actor>/forms/<form-slug>/`

Operator-articulated 2026-05-26 in the walter migration discussion:
"we should still have the assignment, we should just specific that that
it requries the special form. this is important because this is the
beginning of specificying forms. for example, spark will be a future
requested form."

**Why:** assignments without the required-form axis are shape-blind. "Carrie does biographer work" doesn't say whether biographer work runs on:
- carrie's frontier capacity (default agent persona, expensive),
- carrie's `walter` form (Codex CLI + gpt-5.2-codex + xhigh reasoning + live web search — specifically tuned for biography research with rigorous provenance),
- carrie's chibi form (low-cost replay binding — wrong fit for source-critical work),
- some other capacity yet to be commissioned.

Without the requirement encoded, the assignment is a hopeful pointer; with it, the assignment is a contract a router can enforce. This is the substrate equivalent of "kubernetes pod with resource limits" — the *demand* side of capacity allocation.

**The walter ↔ biographer-carrie pair (canonical first example):**

```
agents/carrie/forms/walter/                              # the FORM (capacity binding)
├── form.json                                            #   carrie × codex × gpt-5.2-codex × biographer-overlay
└── ...                                                  #   "carrie running in walter mode"

collectives/wrkstrm/private/universal/kura/assignments/biographer-carrie/
├── assignment.json                                      # the ASSIGNMENT (role-actor binding with required-form)
│   "role": "biographer",
│   "actor": → agents/carrie,
│   "scope": → collectives/wrkstrm,
│   "requiredFormRef": → agents/carrie/forms/walter/      # ← THE NEW AXIS
└── .docc/index.md                                       #   "biographer-carrie REQUIRES the walter form"
```

Same character (carrie) shows up in BOTH structural locations:
- as the actor whose forms are listed (`agents/carrie/forms/walter/`)
- as the actor an assignment binds (`biographer-carrie` assignment's `actor` field)

The form home is canonical capacity; the assignment is canonical demand. They reference each other.

**The spark precedent for "future requested form":** chatgpt's `spark` form is already authored as a chibi/TK:64K capacity binding (codex-spark model, replay discipline). It currently has no assignments that REQUIRE it — but per operator's framing, future assignments will say "this role on chatgpt requires the spark form" rather than "this role on chatgpt" (shape-blind). The spark binding's existence anticipates that demand.

**How to apply:**

1. **When authoring a new assignment**, ALWAYS specify `requiredFormRef` (LinkRef to `agents/<actor>/forms/<form-slug>/`). Default to the actor's canonical/frontier form if no specialized form fits; never leave it unset.
2. **When commissioning a new form**, the form is the supply; assignments are the demand. Forms can exist without assignments (anticipating future demand — spark is in this state today). Assignments cannot meaningfully exist without a required form.
3. **The existing ~10 legacy assignments** at `collectives/<org>/private/universal/assignments/<slug>/` don't have `requiredFormRef` yet. When migrating to `kura/assignments/<slug>/` per [[feedback_assignments-live-in-collective-orgs]], also fill in `requiredFormRef` — pick the actor's frontier or commission a new form if a specialized capacity is implied.
4. **Schema impact:** `OrgAssignmentModel v0.1.0` (in `collectives/schema-universal/.../org-assignment-schemas/v0.1.0/`) likely needs an additive field `requiredFormRef: LinkRefModel`. Bump to `v0.2.0` if the family follows additive-only-with-version-bump discipline, or treat as a new optional field within v0.1.0 if the family allows in-version extension.
5. **Router behavior** (when work scheduling lands): a router presented with an assignment looks up `requiredFormRef` and routes the task to the corresponding (actor × harness × model × overlay) binding — refusing to dispatch if that form isn't available.

Related: [[feedback_assignments-live-in-collective-orgs]] (assignments-in-Kura placement, doctrinal evolution), [[insights/agents-have-forms-2026-05-25]] (form doctrine), [[feedback_forms-outside-kura-own-kura-instance]] (form home placement), [[feedback_kura-storage-typology]] (assignments are the 6th Kura tier, forms are NOT a Kura tier — they're agent-peer homes with their own Kura).
