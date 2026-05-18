---
name: No -owl suffix on Koma names
description: Don't use -owl as a Koma name suffix; the animal/Harry-Potter coding is unwanted
type: feedback
originSessionId: ca04fb50-02c6-4138-8d8a-fb4513e46abf
---
Never name a new Koma with the `-owl` suffix (e.g. `privacy-review-owl`,
`baseline-capability-owl`, `launch-gate-owl`, `design-token-owl`,
`gate-sync-ant`). The animal-mascot pattern reads as Harry Potter / fantasy
naming and rismay actively dislikes it.

**Why:** Direct rismay correction during the secret-labs Koma design ("ajnd
please stop with the owls. we are not harry potter."). Pattern crept in via
the chronicle's mention of `launch-gate-owl + design-token-owl` and propagated
to `privacy-review-owl` (existing directory) and `baseline-capability-owl`
(default komaSlug I introduced).

**How to apply:**
- New Koma names use plain slugs: `secret-labs`, `privacy-review`,
  `baseline-capability`, `launch-gate`, `design-token`. Descriptive, no animal.
- When introducing a `komaSlug` default in a Codable receipt schema, omit
  `-owl`. Use the bare slug.
- Do NOT rename existing `-owl` directories or chronicle entries
  unilaterally — that's separate cleanup work that requires explicit user
  authorization. Just stop spreading the pattern forward.
- If the user wants species/role suffixes for differentiation, ask — don't
  guess. Possible non-animal directions if asked: `-reviewer`, `-checker`,
  `-scout`, `-sentinel`, `-auditor`, or a numeric/role discriminator.
