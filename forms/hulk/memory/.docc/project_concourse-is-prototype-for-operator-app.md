---
name: concourse-is-prototype-for-operator-app
description: "Concourse Mac app at wrkstrm-core/.../concourse/ is the prototype for Operator.app — substrate's consumer-facing 'who am I — what have I been?' surface. Operator-stated 2026-06-04. Substrate-distinctive feature inventory item #14 (typed-fork-lineage, typed-workspace-state, session-split CLI integration, cross-fork conversation diff) maps to Operator.app's substantive payload."
metadata:
  node_type: memory
  type: project
  originSessionId: 2f6e8d5d-6c57-48a2-9fee-ab4870aa2a2f
---

**Concourse is the prototype for Operator.app.** Operator (rismay) stated 2026-06-04 mid-Concourse-canvas session:

> *"keep concourse --- this the prototype for the Operator.app (who am I - what have I been?) haha)"*

## Why this load-bearing for future work

- Operator.app is the substrate's CONSUMER-FACING product surface. Concourse the Mac app is the PROTOTYPE feeding into it.
- The "who am I / what have I been?" framing names Operator.app's substantive payload: substrate-typed-record-of-your-own-life-and-work, queryable spatially via forked-conversation panels on a canvas.
- The substrate's typed-everything investment — typed PTY ([[PTYSpec]]), typed terminal view ([[CommonProcessTerminalView]]), typed forked-conversation-lanes ([[ConcoursePanel.parentID]]), typed kura-record-persistence — all map to Operator.app's evidence-based identity layer.

## What Operator.app inherits from Concourse

Per the Concourse feature inventory at `private/universal/substrate/collectives/wrkstrm-core/private/apple/apps/concourse/concourse.design.docc/feature-inventory.md` — substrate-distinctive items in group #14 are what make Operator.app structurally distinct from cate-the-consumer-IDE:

- Every panel composes a typed `PTYSpec` (or future `ConcoursePanelSpec` variant for editor/browser/agent).
- Every fork = typed lineage event recorded in a substrate kura.
- Workspace state persisted as substrate-typed records, not opaque JSON.
- session-split CLI ↔ Concourse Unix socket integration (`SessionSplitTerminalTarget.concourse`).
- `pty-spawn@swift-universal.cli` so any shell can post panels to a running Concourse instance.
- Per-panel attribution (which agent / operator / fork produced this panel).
- Cross-fork conversation diff — substrate-distinctive: see how two forked agent lanes responded to the same prompt differently.

## Path B confirmed (Swift Concourse, cate as out-of-tree spec donor)

Same 2026-06-04 turn the operator confirmed Path B over Path A (cate-as-Electron-basis) — Concourse stays Swift-native, [[cate-vendored-at-maintainers-0-ai-ug-cate]] is the substrate-readable specification donor. Operator.app inherits a Swift-native + substrate-typed implementation, not an Electron-wrapped imported codebase.

## Composes with typed substrate-canonical records

- [[lift-existing-patterns-not-reimplement]] — the axiom that gates how Operator.app evolves: lift from cate's spec, do not re-import cate's runtime.
- [[creative-selection-runner]] role — the role that runs Operator.app's spawn cycle (creative-signal-framing → ... → spawn-request-assembly → spawn-software).
- [[cate-substrate-integration-2026-06-03]] investigation — the typed integration plan that fed into the substrate-typed PTY + view + canvas stack Concourse runs on.
- [[2026-06-03-the-iterm-boundary-and-the-cate-pivot]] creative-selection narrative — the doctrinal recognition that became Concourse.

## How to apply

- When Operator.app surface decisions arise (UI, fork-shape, workspace-shape), reference the Concourse feature inventory + the substrate-distinctive group #14 items as the spec.
- When asked about Concourse-the-app, surface BOTH the immediate-prototype framing (running app on the operator's Mac) AND the consumer-product trajectory (Operator.app destination).
- The "who am I — what have I been?" question is THE substrate's operator-facing core question. Operator.app's answer: "browse the typed-record canvas of your forked conversations and workspace history."
