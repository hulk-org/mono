---
name: substrate-web-emission-is-transitional-surface
description: "Substrate web emission is a TRANSITIONAL surface — the substrate's primary distribution is native (Mac apps, TestFlight, private substrate, eventually AI-agent distribution). Web is showcase/preview/sharing in this era; substrate plans to retire it. Therefore: substrate web infrastructure investment should be MILDLY PORTABLE (low retirement cost), NOT heavily-shared (high investment that becomes dead weight when web retires). Operator-articulated 2026-06-05."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-05) while reviewing the ArchitectureOptionMatrix's three-way comparison:**

> we need to make is so our swift metal code can be mildly ported over to the web... we plan on web going away anyways.

## Substrate-doctrine framing this names

Substrate web emission (scene web siblings, clia.sh, rismay.me, comparison demos, etc.) is a **TRANSITIONAL SURFACE**. The substrate's primary distribution surfaces are native:
- Mac apps (Scene Lab, Source Control, Inference Control, Backdrop, etc.)
- TestFlight + App Store distribution
- Private substrate (operator-only)
- Eventually AI-agent distribution (typed records flow through agent APIs)

Web is the substrate's CURRENT-ERA showcase / preview / sharing surface. Substrate plans on retiring it.

## Architectural calculus reframed by this doctrine

| Substrate investment | Old framing (web permanent) | New framing (web transitional) |
|---|---|---|
| L1 typed primitives → wasm | Heavy investment worth it | **Still worth it — value is substrate-typed-everything, not web** |
| L2 renderer orchestration shared | Heavy investment worth it | **Thin abstraction only — `SceneRenderer` protocol, NOT fully-shared impl** |
| L3 shader source unification (WGSL→MSL via naga) | Worth toolchain investment | **Skip — hand-port `.metal` → `.glsl` mildly when needed** |
| Tokamak SwiftUI-on-DOM | Worth it for shared UI | **Skip — over-engineered for transitional surface** |
| Reference-render diff harness across platforms | Substrate-grade fidelity contract | **Skip — visual fidelity by code-sharing, transitional surface doesn't need CI diff** |
| Full Swift renderer compiled to wasm | Worth the lift | **Replace with mild port** |

## What "mildly ported" means concretely

1. **Thin platform abstraction** — `SceneRenderer` protocol that both `MetalSceneRenderer` (Mac, source-of-truth) and `WebGLSceneRenderer` (web, transitional) implement. Same Swift orchestration code calls either.
2. **Hand-authored web variants** — when a scene needs a web port, hand-author the WebGL/Three.js version. Don't invest in transpilation toolchains.
3. **Retire cleanly** — when web goes away, delete the web variant. Native is unaffected. The substrate's typed-everything investment in L1 primitives remains useful for whatever comes next (AI-agent distribution, future channels).
4. **Goodnotes pattern WITHOUT Goodnotes scale** — Goodnotes spent 1.47M shared LOC because their web is a permanent product surface. Substrate's web is showcase/preview, so the investment shape is right but the SCALE is much smaller.

## The `mildPortability` dimension landed in ArchitectureOptionMatrix

Added 2026-06-05 to `wrkstrm-color/.../ArchitectureOptionMatrix.swift` as the heaviest-weighted dimension (0.21) in the substrate web-emission comparison. The dimension scores: how easy is the architecture to RETIRE when web goes away?

- `.pass` = low retirement cost (mild port; delete the web variant cleanly)
- `.warn` = moderate (some infrastructure becomes dead weight)
- `.fail` = high (heavy investment that becomes dead weight when web retires)

Re-running the matrix produced:
- Hand-ported `.mjs`: 51% (up from 38% — easy retirement valued)
- SwiftWasm + Tokamak: 65% (down from 83% — heavy invest becomes dead weight)
- SwiftWasm + JSKit + WebGL (Goodnotes): 98% (unchanged — already mild-portable)

The Goodnotes-style approach STILL wins, but for a substrate-doctrine-coherent reason: it's the right typed-everything answer AND it's structurally retirable when web retires.

## What this means for the next substrate-grade move

Author a thin `SceneRenderer` protocol in wrkstrm-color (or `wrkstrm-render` sibling). Both Mac Metal + future WebGL implementations. The substrate's typed primitives + renderer orchestration code runs against the protocol. The WebGL variant is the transitional-surface implementation; when web retires, delete that file. Native Metal implementation is unaffected; substrate's typed-everything investment carries forward.

## Composes with

- [[refinement-types-via-smart-constructor-not-copyable-not-discriminator]] — substrate-typed primitives carry value REGARDLESS of distribution surface
- [[everything-is-quantum-state-machine]] — sibling typed-everything investment, substrate-permanent
- [[constraints-belong-in-types-not-tests]] — substrate-permanent investment direction
- [[deferral-is-drift-do-it-now]] — but don't over-engineer for transitional surface
- [[substrate-typed-comparison-matrix-pattern]] — the matrix THIS sharpened
- [[lift-existing-patterns-not-reimplement]] — for the web variant, lift hand-port patterns; don't invent transpilation tooling
- [[substrate-is-closed-source-no-sharing]] — substrate's primary distribution is private; web is the externally-visible-but-transitional surface
- [[release-gate-audience-review]] — the substrate's audience packets distinguish "the entity" (defender, web surface) from internal substrate consumers; this aligns
