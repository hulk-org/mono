---
name: shape-tier-vs-org-domain
description: "Kura's five shape tiers (vaults/collections/series/timelines/threads) describe HOW data is stored — they're horizontal across all orgs. The OWNING collective for a package or record is determined by DOMAIN (the concept it serves), not by which shape tier it uses. A \"vault\" can be a vault-shape thing owned by any org. Operator-stated 2026-05-26 after I tried to push build-system vaults into kura-org."
metadata:
  node_type: memory
  type: feedback
  originSessionId: fcfa9bf2-1437-4f26-8939-e3384126b4f2
---

The substrate has two orthogonal axes that I keep conflating:

1. **Shape tier** (the Kura typology) — `vaults/` `collections/` `series/` `timelines/` `threads/`. Describes the SHAPE of how data is stored and accessed. Horizontal across the substrate. Every org has its own kura tree with these five tiers.
2. **Org domain** — the concept a record/package SERVES. `wrkstrm-core` for build systems / identifiers / naming policy. `clia-org` for AI-coordination. `kura-org` for the Kura storage primitive itself. `digikoma-org` for bounded executors. Vertical (each concept lives in exactly one org).

These are **independent**. A vault-shaped thing can be owned by any org — the question is "what concept does it serve?" not "is it a vault?"

**Examples:**
- `substrate-registry-vault` is vault-SHAPED, but it serves the **build system** (tracks CLI/app identifier composition, install paths, aliases, source packages). Domain = build systems. Owner = **wrkstrm-core**.
- `substrate-workspace-vault` is vault-SHAPED, but it serves **Xcode workspace tooling**. Domain = build systems. Owner = **wrkstrm-core**.
- A vault that stored **agent identity records** would be vault-shaped + AI-coordination-domain → owner = clia-org.
- A vault that stored **Kura's own indexes** of cross-org shared storage = vault-shape + Kura-primitive domain → owner = kura-org.

**The trap I keep falling into:** name-prefix confusion. The `substrate-` prefix on package names announces "substrate-wide," but doesn't tell you WHICH org owns the concept. "Substrate-wide" is an availability claim (any org can consume it), not an ownership claim. The org is determined by what the concept IS, not by who consumes it.

**How to apply:**
- When deciding a package's home: ask "what concept does this serve?" — not "what shape is it?" or "who consumes it?"
- The Kura shape tier tells you HOW the data is stored (file-based vault, atemporal collection, time-series, etc.). It doesn't tell you WHO owns the concept stored there.
- Operator's earlier doctrine for executables [[feedback_executable-naming-slug-at-org-dot-form]] is the canonical statement of this principle: "**org segment is domain-driven**: the collective that owns the *concept*, not whoever happens to host the source." Same rule, same axis, applied to packages instead of executables.

**Concrete 2026-05-26 corrections:**
- substrate-registry-vault: **wrkstrm-core**, not kura-org (build-system infrastructure)
- substrate-workspace-vault: **wrkstrm-core**, not kura-org (build-system infrastructure)
- (Earlier in session) harness-core: **clia-org**, not universal (AI-coordination concept)
- (Earlier in session) swift-tool-launcher-cli: **wrkstrm-core** (build-system concept)

**Companion entries:** [[feedback_executable-naming-slug-at-org-dot-form]] (same rule, executable layer) · [[feedback_kura-storage-typology]] (the shape-tier doctrine) · [[feedback_org-prefix-on-module-names]] (org-prefix derives from the same domain logic).
