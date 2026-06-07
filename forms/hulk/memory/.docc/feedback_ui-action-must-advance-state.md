---
name: ui-action-must-advance-state
description: "Substrate axiom: every UI action MUST advance the typed state machine to a visibly-different state. A clickable that does nothing is bad state. Typed AxiomModel landed 2026-06-04 at spaces-universal/.../kura-spaces/axioms/ui-action-must-advance-state.axiom.su.json — this memory is downstream POINTER per [[capture-requires-typed-workflows-and-roles-not-just-memory]]."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

**Operator's exact words (2026-06-04, after observing Scene Lab's palette picker accept clicks that did nothing while Auto = Glitch/Linear Shuffle):**
> but then the palletes still show no when we can't select them.
> IF we can do a UI action and it does nothing that is bad state.

Operator follow-up sealing the doctrine:
> can we add this to a software design axiom or somethign? please

**Typed AxiomModel canonical truth** lives at:
`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/ui-action-must-advance-state.axiom.su.json`

This memory entry is the downstream POINTER. The typed JSON record is what other substrate agents READ AND RUN.

---

## Substrate-typed axiom summary

**Every user-clickable UI affordance MUST produce a visible state transition.** Two-axis discipline:

1. **No dead clicks** — UI elements that can be activated but produce no observable state change are FORBIDDEN. Either (a) rebind the action to be unconditionally meaningful or (b) hide the affordance.
2. **No lying captions** — labels describing UI state MUST accurately reflect what controls do. "(palette picker below disabled — cycling)" was a substrate-bad caption because the picker wasn't actually disabled; it was being silently ignored. Lying-to-user UI is the worst bad-state symptom because the operator stops trusting observations.

## Three concurrent symptoms in Scene Lab that surfaced the axiom

| # | Symptom | Fix shipped same turn |
|---|---|---|
| 1 | Palette picker clicks ignored when Auto = Glitch/Linear Shuffle | `paletteCard` Button action now ALWAYS pins + sets `autoColorMode = .staticPalette`. Mirrors Apple Wallpaper UX (tile click exits Spectrum mode). |
| 2 | Caption `(palette picker below disabled — cycling)` lied about the picker state | Rewritten to `(click a palette below to pin + exit Auto)` — accurate description |
| 3 | State machine catalog started empty; Glitch Shuffle rendered black until operator clicked Submit | `.onAppear` now calls `.transitioned(on: .defaultSubmit)` — state machine arrives populated; empty-catalog fallback re-pins picker palette when `validatedCatalog.isEmpty` |

## Why this is a load-bearing substrate axiom (not just UX polish)

The UI is a PROJECTION of the typed state machine ([[everything-is-quantum-state-machine]]). Affordances that don't drive the state machine = incorrect projection. Substrate's typed-everything investment requires the UI surface to faithfully represent state transitions.

**Stack discipline at three layers:**

| Layer | Substrate doctrine | Anti-pattern when violated |
|---|---|---|
| Model | Refinement types make illegal states unrepresentable ([[refinement-types-via-smart-constructor-not-copyable-not-discriminator]]) | Validating-after instead of validating-by-construction |
| State machine | Typed events drive transitions ([[everything-is-quantum-state-machine]]) | Mutable state with no audit trail |
| UI surface | **Every action advances state (this axiom)** | Dead clicks, lying captions, broken initial states |

Bad state at any layer corrupts trust in the layers above and below.

## Apple precedent — macOS Tahoe Wallpaper UX

Canonical positive example: clicking a Mac Purple/Blue/Pink/Yellow tile exits Spectrum/Random mode AND pins that color. The picker IS the "exit auto" gesture; the Color dropdown IS the "enter auto" gesture. Two opposite-direction controls, both always meaningful, neither ever a dead click.

Substrate's typed-everything investment lets us ship the SAME UX without Apple's headcount — `paletteCard` action becomes `paletteSlug = p.slug; if autoColorMode != .staticPalette { autoColorMode = .staticPalette }`. Two lines, no dead clicks, accurate caption.

## How to apply going forward

1. **Before adding a clickable UI element** — identify the typed state-machine event it fires. If you can't name the event, the element doesn't belong.
2. **If conditionally meaningful** — rebind to be unconditionally meaningful (preferred) OR hide when not applicable.
3. **Audit captions** — "disabled" / "cycling" / "click to X" labels must reflect actual control behavior.
4. **State machines that power UI** — must arrive at consumers in a USABLE initial state. Auto-submit / auto-populate / sensible-defaults make the substrate-doctrine first-render correct.
5. **Empty-collection fallbacks** — empty-catalog / empty-pool / no-eligible-state UI MUST render something meaningful, not blank/black/error states (unless the empty IS the error condition the operator needs to see).
6. **UXW release-gate review** — every public clickable surface audited against this axiom; dead-click findings block release.

## Composes with

- [[everything-is-quantum-state-machine]] — UI is the projection of typed QHsm
- [[refinement-types-via-smart-constructor-not-copyable-not-discriminator]] — model-layer "make illegal states unrepresentable"; this axiom does the same at UI layer
- [[typed-primitive-bypass-error]] — parent axiom; dead clicks are UI-surface bypasses of typed state
- [[constraints-belong-in-types-not-tests]] — umbrella discipline
- [[opinionated-synthesis-is-what-user-wants]] — opinionated UI gives every action substantive effect
- [[release-gate-audience-review]] — UXW review gate enforces this axiom at release time
