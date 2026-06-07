---
name: copy-dont-overwrite-when-versioning
description: "When iterating to a new version of any substrate artifact (scene Package, schema family, renderer source, .metal shader, design doc), COPY the prior version to a new sibling with the new version stamp — never overwrite the prior version in place"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

When the substrate iterates to a new version of ANY artifact — scene
Package, schema family, renderer source, `.metal` shader, design doc,
brand-doc, audience packet — the new version lives as a **sibling
copy** alongside the prior version. The prior version is **never
overwritten in place**.

**Operator's exact words (2026-06-04, right after savepoint committed
sabosugi v2 having overwritten v1 in place):**
> and remember when you make a different version: copy it, don't overwrite!

**What this rules out:**

- In-place edit of the v0.1.0 file when authoring v0.2.0.
- "git history is enough" framing — git is a recovery mechanism, not a
  *parallel inspection* surface. The substrate wants both versions
  *visible side-by-side on disk*.
- Versioning ONLY at the schema-family directory level (e.g.
  `desktop-scene-schemas/v0.1.0/` vs `v0.2.0/`) while allowing per-file
  in-place mutation INSIDE a version. The rule applies recursively to
  iterations within a version's lifecycle.

**What this requires:**

- Authoring v0.2.0 means copying v0.1.0's artifact(s) to a new sibling
  with the bumped version, then editing the COPY.
- The prior version stays untouched, available for diff, comparison,
  test, and demo.
- For scenes: `sabosugi-magical-landscape-v0.1.0/Package.swift` + sibling
  `sabosugi-magical-landscape-v0.2.0/Package.swift`, OR versioned source
  subdirectories inside the same Package (operator chooses the granularity).
- For schemas: this is already the substrate's canonical schema-family
  pattern (see [[preserve-prior-schema-versions]]).

**Why:**

- Comparison: "what changed between v1 and v2 of the wave?" is a
  one-glance question when both files exist on disk; a multi-step
  git-log walk otherwise.
- Recovery: a v3 mistake doesn't lose v2.
- Migration: downstream consumers can pin to a specific version without
  forcing the substrate to maintain a single-version moving target.
- Evolution-preserving discipline ([[tradition-preserves-fire-not-ashes-2026-05-25]]) —
  prior versions are the *fire that made the next version possible*,
  not ashes to discard.

**Cross-references:**

- [[preserve-prior-schema-versions]] — same rule already canonical at
  the schema-family level; this feedback extends it substrate-wide.
- [[per-scene-independent-spm-packages]] — each scene's own Package is
  the unit that gets COPIED when versioning, not mutated.
- [[tradition-preserves-fire-not-ashes-2026-05-25]] — preserve evolution
  by carrying prior shapes forward.
- [[content-lives-in-its-owners-home]] — owner-home decisions don't
  change between versions; the sibling-copies live in the same home.

**How to apply going forward:**

1. When the operator says "make v2" / "iterate" / "new version" / "fix this":
   - If a meaningful version boundary applies, COPY the artifact(s) to
     a sibling with the bumped version stamp.
   - Then edit the COPY.
2. When unsure whether an edit is a v1.x revision or a v2.0 cut, ASK —
   don't default to in-place edits.
3. When v1 was accidentally overwritten (like the sabosugi v2 misstep
   that produced this feedback), offer to RECOVER v1 from git history
   and materialize it as a sibling so the rule applies retroactively.
