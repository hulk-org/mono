---
name: smart-things-digikoma-clia-form-factor
description: "Smart things (digikomas — and presumably other intelligence-bearing shapes) now use the two-segment form factor: <slug>@<org>.<shape>.clia. Digikomas specifically are <slug>@<org>.digikoma.clia. Non-intelligent shapes keep their single-segment form (.cli / .lib / .sd) — the .clia suffix is the intelligence marker."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

**Rule**: Substrate executables that carry intelligence (inference, LoRA-adapted personality, bounded judgment) use a **two-segment** form factor under the existing `<slug>@<org>.<form>` pattern from [[feedback_executable-naming-slug-at-org-dot-form]]:

```
<slug>@<org-slug>.<shape>.<intelligence-marker>
```

- `<shape>` = the structural form (e.g., `digikoma`, presumably `supplement` / `ghost` for other smart shapes)
- `<intelligence-marker>` = **`clia`** for things that carry intelligence

**Canonical form for digikomas (operator-stated 2026-05-26)**:

```
<slug>@<org-slug>.digikoma.clia
```

Example renames mapping the existing pipeline:

| Legacy directory name | New name |
|----------------------|----------|
| `digikoma-launch-status` | `launch-status@digikoma-org.digikoma.clia` |
| `digikoma-file-gate` | `file-gate@digikoma-org.digikoma.clia` |
| `digikoma-ship-apple-app` | `ship-apple-app@digikoma-org.digikoma.clia` |
| `digikoma-audit-leak-surface` | `audit-leak-surface@digikoma-org.digikoma.clia` |
| `digikoma-savepoint` (existing) | `savepoint@digikoma-org.digikoma.clia` |
| (legacy `digikoma-` directory prefix pattern across all of `digikoma-org/private/universal/domain/<domain>/`) | All migrate to `<verb>@digikoma-org.digikoma.clia` |

**Non-intelligence exception**: things that *look* like digikomas (live under `digikoma-org/`) but are deterministic — i.e., make no inference / no judgment — do NOT carry `.clia`. They keep single-segment form factor. Canonical case study: `digikoma-release-features` whose own `identity.md` says: *"This is a pure SwiftPM CLI package. It is not a digikoma: it does not open a bounded intelligence session, does not use a personality fixture, and does not make semantic judgments."* That one renames to `release-features@digikoma-org.cli` — `.cli` only, no `.clia`.

**Diagnostic**: when picking the form factor for a new substrate executable, ask:
- Does it open a bounded intelligence session? → `.digikoma.clia`
- Does it run during-turn parallel to the agent? → likely `.supplement.clia` (hypothesis — confirm with operator)
- Is it a LoRA-adapted personality? → likely `.ghost.clia` (hypothesis — confirm with operator)
- Is it deterministic — same input always produces same output, no judgment, no inference? → `.cli` / `.lib` / `.sd` (single segment, no `.clia`)

**Why this matters**:
- The naming itself is the doctrine carrier — a future reader sees `xyz@digikoma-org.cli` (no `.clia`) and immediately knows it's deterministic, even though it lives in `digikoma-org/`. The convention enforces the "form follows function" principle from [[feedback_shape-tier-vs-org-domain]].
- Composes with [[feedback_org-prefix-on-module-names]]: Swift module names still take the org PascalCase prefix; the form-factor segments live in the directory + executable names.
- Composes with [[feedback_sd-sleeping-daemon-form-factor]] — `.sd` is non-intelligence form (a queue drainer is deterministic), so it stays single-segment. A *smart* sleeping daemon (hypothetical) might be `.sd.clia`.

**Hazard**: per [[feedback_harness-canonical-home-clia-org]] + [[feedback_savepoint-snapshot-at-emit-time]], substrate-restructure passes silently wipe legacy paths. The 20+ existing `digikoma-<slug>/` directories under `digikoma-org/private/universal/domain/<domain>/` are at that hazard. They should be renamed in one deliberate operator-approved sweep, not piecemeal, so all consumers' `Package.swift` path references update together.

**Operator quotes 2026-05-26**:
- "smart things like digikoma are now : @{org}.digikoma.clia"
