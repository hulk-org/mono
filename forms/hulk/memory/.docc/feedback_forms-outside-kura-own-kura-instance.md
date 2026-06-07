---
name: forms-outside-kura-own-kura-instance
description: "forms are PEERS to the agent's private/, NOT children of the agent's kura/; each form is its own home with its own complete private/universal/kura/{vaults,collections,series,timelines,threads}/ instance"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

Substrate doctrinal correction 2026-05-26: forms live at `agents/<agent>/forms/<form-slug>/`, NOT inside the parent agent's Kura. Each form gets its OWN complete `private/universal/kura/{vaults,collections,series,timelines,threads}/` instance.

**Why:** A form IS the binding `(agent × harness × model × overlay)` — when chatgpt is *instantiated* as codex, that's a distinct execution context with its own threads, timelines, vault content, and series semantics. Burying form artifacts inside the parent agent's collections/forms/ collapses that distinction and prevents forms from accumulating their own work-graph state independently. A form is closer to a sub-home than to a collection entry — it deserves identity-adjacent treatment, not set-membership treatment.

**How to apply:** when authoring a new form (eliza, spark, future migrations) or correcting prior misplaced forms (codex, symphony, openclaw, nous, clia currently sit at the wrong location `<agent>/private/universal/kura/collections/forms/<form>/`), the canonical layout is:

```
agents/<agent>/
├── private/universal/                # parent agent's home
│   ├── identity/                     # parent agent's identity bundle
│   └── kura/                         # parent agent's Kura instance
│       ├── collections/              # NO forms/ subdir
│       ├── series/
│       ├── timelines/
│       ├── threads/
│       └── vaults/
└── forms/                            # ← OUTSIDE kura, peer to private/
    └── <form-slug>/
        ├── form.json                 # FormModel v0.1.0 marker
        ├── .docc/index.md            # DocC home (NOT README, per DocC-first)
        └── private/universal/kura/   # form's OWN complete Kura instance
            ├── collections/
            ├── series/
            ├── timelines/
            ├── threads/
            └── vaults/
```

**Existing-form fix-up:** as of 2026-05-26 the prior 5 forms (codex, symphony, openclaw, nous, clia) all live at the wrong location (`<agent>/private/universal/kura/collections/forms/<form>/`) and need a separate corrective sweep. Migrate to `<agent>/forms/<form-slug>/` + add a per-form Kura instance.

Related: [[insights/agents-have-forms-2026-05-25]] (the doctrine itself), [[feedback_kura-storage-typology]] (Kura's 5-tier × ownership-scope structure), [[feedback_named-coherent-doesnt-mean-agent]] (which standalone "agents" need to be reversed to forms — eliza + spark are the remaining cohort members).
