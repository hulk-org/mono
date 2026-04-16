---
name: Telemetry schemas live in schema-universal
description: FoundationModels session telemetry / logging event types belong under schema-universal/private/universal/schema-families/, not in the consuming app or a sibling org
type: project
---

FoundationModels session telemetry models (turn events, pieces, partial turns, terminus tags, log levels) belong under `schema-universal/private/universal/schema-families/` — not in the consuming app, not in ghost-shell-org, not in koma-org.

**Why:** schema-universal is the canonical home for cross-collective schema contracts. Telemetry is consumed by multiple clients (ghost-shell-org observer, wrkstrm-chess debug panel, future Pa-facing analytics, etc.); duplicating the shape per consumer would fracture the contract. `ghost-shell-org/protocols/v000_000_000/Sources/GhostShellIPC/` describes the XPC wire protocol for that shell's specific runtime; the schema family is the abstract data-shape contract, which belongs one level up.

**How to apply:**
- New FoundationModels telemetry types → new schema family under `schemas-families/`, e.g. `inference-session-schemas/v0.1.0/json/...` + matching `spm/...` codegen.
- Siblings to look at: `inference-engine-schemas` (engine identity), `claude-usage-schemas` (usage metrics), `koma-schemas` (koma primitives).
- Convention per existing families: `schema-catalog.family.descriptor.json` at family root; version dirs hold `json/<family-v000-N-M>/schemas/<subdir>/*.schema.json` (source of truth) and `spm/<family-v000-N-M>/` (generated Swift package with Model.swift + SchemaVersion.swift).
- Apps consume the generated SPM package, not the JSON directly.
- Ghost-shell-org's `GhostTelemetry` @objc protocol stays where it is — it's the XPC *wire format*, not the data shape. It should import / mirror the schema-universal shapes rather than define them.
