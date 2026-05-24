---
name: LinkRef v3 canonical, v4 research-only
description: link-ref-schemas v0.3.0 is the active substrate LinkRef wire format; any v4 work lives in wrkstrm-research, never in canonical schema-universal or downstream consumers
type: feedback
originSessionId: aff9b2ba-846c-4843-8912-82ba1c8e0af1
---
LinkRef v0.3.0 is the substrate's canonical link reference format. The Swift
type is `LinkRefModel` (semanticVersion `0.3.0`) at
`schema-universal/.../link-ref-schemas/v0.3.0/spm/link-ref-schemas-v000-003-000/sources/link-ref-model.swift`.
Wire shape uses compact keys (`t`/`d`/`s`/`tg`) + target objects with `k`/`v`/`rt`.
The version discriminator `"LinkRefModel": "0.3.0"` must appear explicitly on each
LinkRef instance when authoring new ones.

**Why:** Operator correction 2026-05-22 — earlier framing slipped and called
the corpus migrator a "v4 migrator." That phrasing implies v4 is a planned
substrate target. It isn't. v4 (`LinkRef_Schemas_v000_004_000`) lives only in
`collectives/wrkstrm-research/.../computational-ontology-discovery/gym/schema-packet-bench/`
as research/gym work. Schema-universal canonically has v0.1.0 + v0.2.0 +
v0.3.0 only.

**How to apply:**
- Author new LinkRefs as v0.3.0 with explicit `"LinkRefModel": "0.3.0"` discriminator.
- Do not introduce v0.4.0 references into canonical schema-universal,
  agent identities, role templates, position records, assignment records, or
  any consumer outside wrkstrm-research.
- When discussing future LinkRef revisions, frame them as wrkstrm-research
  exploration, not as substrate-bound migration targets.
- If a future v4 promotion happens, it will come from a deliberate operator
  call to move it out of wrkstrm-research — not from agents speculating
  about it. Until then, treat any v4 reference outside wrkstrm-research as a
  red flag.
- The CLI is `swift-link-ref-corpus-migrator-cli` (corpus migrator, not
  versioned migrator). Operator does not trust it for autonomous runs —
  hand-convert LinkRef arrays per file when touching them.
