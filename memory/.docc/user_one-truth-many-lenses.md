---
name: One truth, many lenses
description: Rismay's cross-substrate design axiom — canonical data is singular; the view is a function of who's looking
type: user
---

**Axiom:** *One truth, many lenses.* The data is canonical and singular. The
view is a function of who is looking.

This is a cross-substrate design principle rismay reaches for repeatedly, not
just a Clia Day feature. Its first product expression is the **Collective view**
in Clia Day, where the same day is rendered differently for `pa` (human, plain
voice, XL type), `clia-agents` (structured, terse, includes refs), `self` (full
planning surface), and future audiences.

It also already lives in the substrate as:
- triads (one identity → agency / agenda / agent projections)
- collectives (one body of work → wrkstrm / clia / openclaw audiences)
- harness headers (one session → per-harness rendering)
- DocC (one source → human vs. tooling renderings)

**How to apply:**
- When designing any user-facing surface in this substrate, ask "who's the
  audience, and what lens do they need?" before designing the screen.
- Never let a view read raw content directly. Route it through a `Lens` (or the
  equivalent projection layer) so the audience — not the author — picks the
  rendering.
- Adding a new audience should mean adding a lens, not a screen.
- The product test for Clia Day specifically: every feature must improve at
  least one collective's answer to "How's your day looking?"

**Why:** rismay coined this in the 2026-04-07 Pantera/Clia Day conversation,
when generalizing "an app for Pa" into "Collective view" — the moment the
substrate vocabulary (`collectives/`) snapped together with the product idea.
The principle is bigger than the feature and is meant to anchor future design
decisions across the substrate.
