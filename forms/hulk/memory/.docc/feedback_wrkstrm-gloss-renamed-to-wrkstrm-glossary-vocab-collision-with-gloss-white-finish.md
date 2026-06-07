---
name: wrkstrm-gloss-renamed-to-wrkstrm-glossary-vocab-collision-with-gloss-white-finish
description: "wrkstrm-gloss renamed to wrkstrm-glossary 2026-06-04 because \"gloss\" overloaded substrate vocabulary with \"gloss-white\" canonical light theme finish. Hard cut, no transition shim. Operator-named the new vocabulary entry."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# wrkstrm-gloss renamed to wrkstrm-glossary

**Rule**: The substrate-canonical scholarly-margin-note primitive is `wrkstrm-glossary` (package, product, library, modifier). The prior `wrkstrm-gloss` name is RETIRED — no typealias, no transition shim, no re-export per `[[breaks-are-good-no-transition-shims]]`.

**Why**: Operator-attested 2026-06-04 mid-Launch-Review-test-session — *"gloss is a bad name because we have gloss-white as a token design system."* — followed by *"wrkstrm-glossary - i'm fine with this. and i'm glad we are adding that word to our vocabulary."*

The substrate had a vocabulary collision:
- `gloss-white` — substrate-canonical light theme finish (`AppleGlossWhiteTheme` in WrkstrmCatalogCards) — design-system "glossy-surface" vocabulary
- `wrkstrm-gloss` — scholarly-margin-note SwiftUI modifier primitive — linguistic/manuscript "gloss as marginal definition" vocabulary

Per `[[Filename compound suffix disambiguates overloaded types]]` + `[[no-typealias-no-export-no-breadcrumb]]` + `[[medium-is-the-message-substrate-2026-05-26]]` — substrate refuses overloaded vocabulary; the medium IS the message; the colliding name is itself the bug.

**Resolution**: `glossary` stays in the gloss family but carries its own precise substrate-doctrine meaning (a collection of brief definitions of terms — exactly what the primitive provides). Distinct from "gloss-white" finish. Operator-attested addition to substrate's vocabulary.

**How to apply**:

Cascade scope (all instances of `wrkstrm-gloss` / `WrkstrmGloss` / `.wrkstrmGloss` / `wrkstrmGloss`):

- Package dir: `wrkstrm-components/private/gloss/macos/spm/wrkstrm-gloss/` → `.../wrkstrm-glossary/`
- Package.swift: `name: "WrkstrmGloss"` → `"WrkstrmGlossary"`; product + target names same
- Source file: `sources/wrkstrm-gloss/WrkstrmGloss.swift` → `sources/wrkstrm-glossary/WrkstrmGlossary.swift`
- Swift symbol: `WrkstrmGlossStyle` → `WrkstrmGlossaryStyle`; `WrkstrmGlossModifier` → `WrkstrmGlossaryModifier`
- View modifier API: `View.wrkstrmGloss(_:style:)` → `View.wrkstrmGlossary(_:style:)`
- Consumer project.yml: `package: WrkstrmGloss` → `WrkstrmGlossary`; `product: WrkstrmGloss` → `WrkstrmGlossary`; path
- Consumer source: `import WrkstrmGloss` → `import WrkstrmGlossary`; `.wrkstrmGloss { ... }` → `.wrkstrmGlossary { ... }`
- Memory + docs + bug ticket references: substrate-wide grep + replace where they discuss the primitive
- Per `[[Don't defend implementation when shown a contrast]]` + the same-session prior catch — action-button misapplications (Approve / Reject / Open / Reveal / Take a stab / Set verdict / etc.) DROP entirely in the same cascade pass; only text-label-with-substrate-doctrine-terms uses keep the new `.wrkstrmGlossary` modifier

**Composes with**:
- `[[Filename compound suffix disambiguates overloaded types]]` — sibling doctrine on substrate vocabulary precision
- `[[no-typealias-no-export-no-breadcrumb]]` — substrate-evolution discipline; hard-cut renames
- `[[breaks-are-good-no-transition-shims]]` — cross-collective renames are hard cuts
- `[[medium-is-the-message-substrate-2026-05-26]]` — name structure IS message
- `[[Tradition preserves fire not ashes]]` — substrate evolution preserves intent, retires expressions
- `[[feedback-substrate-wide-cascade-pattern]]` — 5-step cascade pattern (typed schema cut → migrator → mirror → per-submodule commits → umbrella)
- `[[component-bugs-file-at-component-home-not-consumer]]` — the rename triggers a typed bug at the component's home
- `[[wrkstrm-gloss-misapplied-on-action-buttons]]` (open if not yet saved) — action-button misapplications drop in same cascade pass
