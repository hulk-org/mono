---
name: cate-vendored-at-maintainers-0-ai-ug-cate
description: "cate (0-AI-UG, MIT, Electron canvas IDE) is vendored at substrate/maintainers/0-ai-ug/cate/ as the substrate-readable specification donor for Concourse and downstream Operator.app. Path B chosen 2026-06-04 (Swift Concourse, cate as out-of-tree spec, NOT in-tree Electron runtime). Concourse feature inventory at concourse.design.docc/feature-inventory.md serves as the spawn-software PRD."
metadata:
  node_type: memory
  type: reference
  originSessionId: 2f6e8d5d-6c57-48a2-9fee-ab4870aa2a2f
---

**Location:** `private/universal/substrate/maintainers/0-ai-ug/cate/` — 33MB TypeScript Electron source, MIT-licensed, upstream `github.com/0-AI-UG/cate.git`.

**Why vendored under maintainers/:**

Per [[gstack-belongs-in-maintainers]] doctrine, third-party SOURCE TREES go in `maintainers/<org>/` — never inline-vendored under a consumer app's directory. Cate joins ~10+ existing maintainer tracks (abhixdd, activitywatch, agentify, beads, bysiber, cerebroapp, …) the substrate is actively attribution-tracking.

**What it's used for:**

Per the Path B decision (substrate-canonical choice 2026-06-04 — operator: *"keep concourse --- this the prototype for the Operator.app"*):

- cate is the substrate-READABLE SPECIFICATION DONOR for Concourse.
- Concourse stays Swift-native (substrate-typed PTY, substrate-typed canvas, substrate-typed view-layer via CommonProcessTerminalView).
- Each feature port from cate → Concourse uses cate's TypeScript source as the spec; Swift implementations port the shape.
- The Concourse feature inventory at `private/universal/substrate/collectives/wrkstrm-core/private/apple/apps/concourse/concourse.design.docc/feature-inventory.md` enumerates ~80 cate features in 14 categories with status tags + phasing recommendation.

**Path A (rejected):** import cate's full Electron runtime into the substrate, swap node-pty for substrate's PTYSpec via IPC, progressively retypify. This was rejected because it accepts Electron + Node ≤ 22 ceiling + foreign-runtime surface inside the substrate. Violates `[[substrate-apple-first-then-cross-platform-2026-05-26]]`.

**Composes with:**

- [[concourse-is-prototype-for-operator-app]] — the project framing.
- [[gstack-belongs-in-maintainers]] — the canonical placement doctrine.
- [[lift-existing-patterns-not-reimplement]] — the discipline applied: substrate-internal patterns first, then maintainers/ exemplars, then author new.

**Prebuilt cate.app for reference UX:**

- `/Applications/Cate.app` — quarantine-stripped install of `Cate-1.1.1-arm64-mac.zip` from `github.com/0-AI-UG/cate/releases`. Run alongside Concourse during development to compare UX patterns.
