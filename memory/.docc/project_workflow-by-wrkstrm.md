---
name: Workflow by wrkstrm
description: wrkstrm app backed by Beads — the task management UI for molecules, gates, and Digikoma execution; name is "Workflow"
type: project
---

Workflow is the wrkstrm app that surfaces Beads as a UI.

**Why:** Beads provides the task graph backbone (formulas, molecules, gates,
Dolt persistence). Digikoma provides execution. Ghost bridges them. Workflow is
the operator-facing app that ties it all together — display molecules, approve
gates, pin work to agents, watch Digikoma pipelines execute.

**How to apply:** The app name is "Workflow" (not "Beads" — Beads is the engine,
Workflow is the product). Follow wrkstrm naming: slug `workflow-by-wrkstrm`,
bundle `me.rismay.workflow`, wrkstrm-owned. Beads is a dependency, not the brand.

Discovered 2026-04-20 during Swarm vs Digikoma investigation.
