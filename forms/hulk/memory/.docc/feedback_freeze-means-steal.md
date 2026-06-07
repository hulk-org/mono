---
name: Freeze means quarantine + harvest, not memorial
description: When rismay says "freeze X as rejected reference," that's a theft warrant — port aggressively from X's body, don't just label its bones in a matrix
type: feedback
originSessionId: 1f57eef6-e9e0-491c-89ea-32f0ba567e29
---
When the operator instructs to freeze a prototype/codebase/branch as a
"rejected reference" before building its successor, the freeze is not a
preservation ritual. It is a **theft warrant**. The frozen reference exists so
that stealing from it is *easy and labelled* — a quarantine boundary that lets
you harvest aggressively without confusing the active product.

**Why:** during the Content Pass → Vapor Wares pivot (2026-05-05), I performed
the freeze ritual properly (insight doc, beads annotations with PORT/REJECT/
REWORK labels, tag, commit) but then scaffolded the new app from a *clean
adjacent template* (`localize`) instead of from the frozen body. I shipped 16
hand-written hipster taglines while a 2800-line `ContentPassCatalog.swift`
sat untouched. I built a fresh `VaporWaresStore` while a 1166-line
`ContentPassStore.swift` with workflows, receipts, and tool-library state sat
untouched. The 26KB `investigation.md` was never opened. The "PORT" labels
in the matrix became *promissory* rather than *operational*.

The failure mode is the path-of-least-resistance template. A clean adjacent
codebase is faster to model on than a messy prior body — but the prior body is
where the actual domain knowledge lives. The freeze exists to remove every
remaining excuse for not stealing from it.

**How to apply:** when the operator says "freeze X as reference + build Y,"
the very next action — *before any scaffolding* — is to:

1. `cd` into X and read the most substantial files (largest `.swift`, the
   investigation doc, any catalog/seed data). Treat them as the working
   material for Y, not as historical context.
2. Build a steal-list, not just a port matrix. Per file or feature:
   "STEAL verbatim", "STEAL with rename", "STEAL the structure, replace
   the chrome", "REJECT". Make the verb explicit.
3. Scaffold Y by *copying X's body* into Y and adapting in place, not by
   modeling Y on a different clean template. The brand pivot is on the
   surface; the substance lives underneath, and it is supposed to survive.
4. The freeze artifacts (insight doc, bead annotations) document *what the
   theft was* — they should match what actually shipped in Y, not what the
   triage *intended*.

If a slice of Y could plausibly have been ported from X but was built fresh
instead, that is the smell. Either rename it as REJECT in the matrix
(honest), or actually port (correct). Don't let "PORT" be aspirational.

**Memory of how this slipped:** modeling on `localize` was faster on turn 1.
The clean template gave me a working scaffold in one batch of writes. By the
time the model lock-in cost was visible (Phase 3 ports built fresh, the
`investigation.md` never read, the workspace-view onboarding never ported),
the architecture had already cemented around fresh-built versions. Catching
this earlier means: open the frozen body *first*, model on it *first*, and
only reach for adjacent templates for surfaces the frozen body didn't have.
