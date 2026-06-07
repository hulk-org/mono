---
name: Substrate layout
description: Current substrate category structure — orchestrators/ for clia, dynamic resolution in sync skill, vaults pattern for archival data.
type: project
---

As of 2026-04-05, `private/universal/substrate/` has these category directories: `agents/`, `collaborators/`, `collectives/`, `harnesses/`, `operators/`, `orchestrators/`.

- `clia` lives at `orchestrators/clia` (moved from `agents/clia`)
- `claude` home is at `harnesses/claude/`
- The sync skill scans all categories dynamically — no hardcoded lookup order
- `.clia/agents/<slug>/` is a dead runtime path convention — never existed on disk
- `vaults/` within any home holds archival data (harvest, receipts, openclaw state)

**Why:** The old hardcoded `agents/` → `collectives/` resolution prevented new categories from being discovered. Dynamic resolution future-proofs the layout.

**How to apply:** When resolving slugs or referencing identity homes, scan the substrate directory tree rather than assuming a fixed category. When moving identity homes, update live references but leave vault contents intact.
