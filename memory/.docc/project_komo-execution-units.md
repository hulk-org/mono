---
name: Komo execution units
description: Komo (short for Tachikoma/タチコマ) are bounded execution units deployed by Tau via CLIDE; context-only, no mid-term memory, one scan per station, closed work graph traversal
type: project
originSessionId: d8bf83a5-6455-41dc-86b8-ec518edcee54
---
Komo = shorthand for Tachikoma (タチコマ = 立ち tachi mobile + 駒 koma piece/unit).

**Why:** Tau (the agent) needs execution units that traverse closed work graphs without accumulating memory drift. Komo are those units. Named from the Ghost in the Shell ontology but with a key divergence: CLIA's Komo never awaken — all improvement is Ghost-driven spec refinement, not internal learning.

**How to apply:** The deployment flow is CLIA → Tau → CLIDE → Komo. Tau decides, CLIDE runs, Komo acts. A Komo carries working context (mission, frontier, visited set) but NO mid-term memory. It performs **one scan per station** while on patrol of a chartered route. Scans are bounded inspections: fetch/clean/mark/trace/validate/index/watch are scan kinds. Species are anatomy presets: Ant (BFS/queue), Hound (DFS/stack), Fox (priority/heap), Spider (adjacency), Owl (ring buffer). Naming convention: `[domain]-[role]-[species]-[variant]-[version]`. Imprints on the substrate are gated on bookend receipts (onboarding + offboarding); a scan that yields findings only becomes an imprint after the host receives both stamps. See `feedback_patrol-scan-vocabulary.md` for the macro/micro verb pair.
