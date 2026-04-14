---
name: Komo execution units
description: Komo (short for Tachikoma/タチコマ) are bounded execution units deployed by Tau via CLIDE; context-only, no mid-term memory, one trick per node, closed work graph traversal
type: project
---

Komo = shorthand for Tachikoma (タチコマ = 立ち tachi mobile + 駒 koma piece/unit).

**Why:** Tau (the agent) needs execution units that traverse closed work graphs without accumulating memory drift. Komo are those units. Named from the Ghost in the Shell ontology but with a key divergence: CLIA's Komo never awaken — all improvement is Ghost-driven spec refinement, not internal learning.

**How to apply:** The deployment flow is CLIA → Tau → CLIDE → Komo. Tau decides, CLIDE runs, Komo acts. A Komo carries working context (mission, frontier, visited set) but NO mid-term memory. It performs one trick per node (fetch/clean/mark/trace/validate/index/watch). Species are anatomy presets: Ant (BFS/queue), Hound (DFS/stack), Fox (priority/heap), Spider (adjacency), Owl (ring buffer). Naming convention: `[domain]-[role]-[species]-[variant]-[version]`.
