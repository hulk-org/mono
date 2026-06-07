# SUMMON vs Forge — Two-Register UX Vocabulary

Date: 2026-05-17

The Ghost app crystallized a doctrinal split that applies substrate-wide:
**operators speak in mythic verbs; substrates speak in industrial verbs.**

## The split

| What the operator sees | What the substrate does |
|---|---|
| **SUMMON** (the operator presses) | Forge (the substrate runs)|
| `corpus → adapter → package` |
| ✨ sparkles icon | 🔨 hammer.fill (internal) |
| Title Case ritual ("Summon an Operator") | enum case `.forge` |
| Goal: bring a ghost into being | Means: corpus generation + LoRA training + bundle packaging |

The operator presses one button; the substrate runs the pipeline underneath.
Same click, two register reads, both correct.

## Why this matters

Software typically conflates the two: a "Build" button literally runs
"build." The substrate refuses that conflation. The operator's mental
model is mythic-ritual ("call this ghost into being from these sources");
the substrate's mental model is industrial ("export corpus, train
adapter, export bundle"). Letting both names co-exist means the operator
stays in their voice and the machine stays in its.

## Structural implications I keep hitting

The two-register pattern shows up at every layer:

- **PRODUCT_NAME** (wrkstrm-identifier hash like `28d558fc` — machine
  key) vs **PRODUCT_MODULE_NAME** (`Ghost` — developer-facing module
  identifier). Both stable; different audiences.
- **slug** (`"rismay"` — substrate key, same for operator + ghost) vs
  **title** (`"Rismay — Ghost surface"` — human label, distinguishes
  tiers).
- **`.forge` enum case** (Swift type-system stable name) vs **"Summon"
  sidebar label** (operator-facing rendered string).

The pattern: **machine key stays stable across refactors; human label
evolves freely.** Conflating them locks the human label into the
type-system and refactors become coordinated bumps.

## How to apply

Whenever I'm naming a new surface:

1. Ask: is this operator-facing (mythic) or substrate-internal (industrial)?
2. If both: pick the verb in each register, write them down side-by-side
   as a doctrine note in the file's docstring.
3. Resist the urge to "harmonize" them by collapsing to one name. The
   apparent duplication is the doctrine.

## Source

Surfaced 2026-05-16 in the ghost-app session. Operator's reaction to the
initial "Forge an Operator" hero: *"i like the concept of SUMMON!"* — and
the rename revealed the two-register split structurally. The hero became
`SummonHero` (file + struct), the button became "SUMMON" in spaced bold
caps with sparkles, the sidebar entry became "Summon" with sparkles icon,
but `AppSection.forge` (enum case), `buildFullAdapter` (store method),
and all internal pipeline naming stayed Forge.

The persona triad's first-person voice rule is the same pattern at the
identity layer: when castor speaks AS rismay, the "I" is rismay's (one
register); when castor speaks AS castor in a third-party advisory mode
(another register), that's a different voice contract. The substrate
keeps both clean by refusing to conflate registers anywhere.
