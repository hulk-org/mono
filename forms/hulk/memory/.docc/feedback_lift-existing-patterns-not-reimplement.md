---
name: lift-existing-patterns-not-reimplement
description: "When the substrate has an existing pattern that solves a problem (sibling primitive, prior app's source, vendored maintainer code), LIFT it — port + cite + reuse tests — rather than authoring a parallel re-derivation. Memory-recall is not search-verified; before claiming a substrate package doesn't exist, grep .gitmodules. 3x-confirmed 2026-06-04 (ExecutableResolution, Architect.cardDragGesture, common-cli)."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2f6e8d5d-6c57-48a2-9fee-ab4870aa2a2f
---

**Rule:** When a substrate-internal pattern already solves a problem, port-the-pattern not invent-your-own.

**Why:** 3x confirmed 2026-06-04 in one Concourse session — each instance a separate operator catch of the same anti-pattern:

1. **PTYRunner authored a parallel executable resolution** when `ExecutableResolution.resolveExecutableAndArgsCompat` already existed as a sibling file in `common-process-runners/`. Operator: *"did you use any of those? during you implementation."*
2. **Concourse panel drag built a from-scratch NSResponder `DraggableHandle`** when Architect's `CanvasView.cardDragGesture` (SwiftUI DragGesture + named coordinate space + incremental delta) already shipped the substrate-canonical canvas-card-drag pattern. Operator: *"look into how architect app did it pleae."*
3. **Memory recited 'no standalone common-cli package exists'** when `.gitmodules` showed common-cli as a substrate-canonical submodule alongside common-shell. Operator: *"there is a common-shell and a common-cli package... maybe it was made to be random?"*

**How to apply:**

- Before authoring any substrate-typed primitive, search for sibling/upstream implementations: `find` against canonical paths AND grep of actual file contents. Memory recall is not search.
- Before claiming a substrate package, primitive, or pattern does not exist, verify via `.gitmodules` + filesystem find + read canonical exemplar. Memory entries are decay-prone; filesystem is canonical truth.
- When lifting a pattern, cite source file + line numbers in code comments AND in the typed-record (commit message, axiom citation, workflow x-instances entry). Lifted patterns must be traceable.
- When two patterns exist for the same problem, the older or more-established is the substrate-canonical version; delete or refactor the newer parallel re-derivation.

**Canonical typed record (substrate-canonical truth — this memory is downstream pointer):**

This memory POINTS AT the typed axiom at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/lift-existing-patterns-not-reimplement.axiom.su.json` per [[capture-requires-typed-workflows-and-roles-not-just-memory]] doctrine. The axiom carries the full statement + obligations + sourceRefs + contextRefs + projectionAnchors. This memory is the agent-perspective pointer; the axiom is the substrate-canonical record.

**Composes with:**

- [[typed-primitive-bypass-3x-rule-confirmed]] — typed-primitive-bypass is the ERROR class; lift-existing-patterns is the CORRECTIVE discipline.
- [[build-components-not-one-offs]] — sibling axiom: generic mechanics belong in shared substrate homes, not prototype-local.
- [[deferral-is-drift-do-it-now]] — sibling axiom: obvious extraction-or-lift should happen NOW, not bead-tracked.
- [[creative-selection-runner-role-discovered]] — the role that inhabits this discipline during creative-selection's source-and-claim-research stage.
