---
name: Design goals are not UI chrome
description: Internal design-goal codenames like "Operator 2027" / "Collective 2027" are aspirational targets, never UI labels
type: feedback
---

Codenames the team uses to describe a design intent — "Operator 2027",
"Collective 2027", "Operator2027 cockpit", "Substrate 2030", and similar
year-tagged design goals — are **internal aspirations**, not strings to
render in the UI. Never put them in `Text(...)` labels, sidebar tags,
header chrome, footer copy, or visible chips.

**Why:** rismay called this out explicitly when I added
`Text("Collective 2027")` as an uppercase gold tag at the top of the
collectives-by-wrkstrm sidebar header card. They said: *"Collective 2027
was supposed to be design goal — not something you write down."*
Year-tagged codenames are how the team aligns on design direction
internally; they are not product surface area, they don't ship to users,
and they make the app look unfinished / draft-stamped when they appear
on screen.

**How to apply:**
- If a `MARK:` comment, helper name, or doc comment uses one of these
  codenames as architectural shorthand, that's fine — source code is
  internal.
- If the codename ends up in an SF symbol's accessibility label, a
  `Text("…")`, a navigation title, an SF Symbol caption, or any visible
  chrome — strip it. Replace with copy that describes what the surface
  *is* ("Substrate-backed governance", "Operator inspector"), not the
  codename for *why we're building it*.
- This applies symmetrically to source-control-by-wrkstrm
  ("Operator 2027 / Dense repo posture, review before action") — the
  copy describing posture is fine, the codename label is not.
- When in doubt: would a user care about this string? If no, it's
  internal language; keep it out of visible UI.
