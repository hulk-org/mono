---
name: role-classes-as-files-not-catalog
description: "Substrate doctrine — typed enumerations (role classes, audiences, etc.) should be ONE FILE PER ITEM on the filesystem, not bundled into a catalog JSON. Catalog is a projection."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

Role classes — and analogously every typed enumeration the substrate maintains
(audiences, kura collections, agent forms, etc.) — must live as **one file per
item** under the owning directory, not bundled into a single catalog JSON. The
catalog (if one exists) is a PROJECTION over those files, not the source of
truth.

Concrete instance corrected 2026-05-30: role classes were embedded in
`private/universal/substrate/roles/classes/role-class-catalog.json` as a `.cs[]`
array of `OrgRoleClassModel 0.2.0` objects. Correct shape: one
`<slug>.org-role-class.json` per class at
`private/universal/substrate/roles/classes/`, and the leftover catalog file
keeps substrate-level metadata (axes, sources, composition rules) WITHOUT the
embedded classes — becoming a thin index that walks the directory.

**Why:** filesystem-picker doctrine. When items are individual files you can:
- `ls classes/*.org-role-class.json | fzf` to pick one
- reference an item from another schema as `tg.rp` = filesystem path, not
  catalog-internal `id` (which requires the consumer to also load the catalog)
- diff, version, and own each item independently (git history per class, not
  per-catalog-edit)
- add/retire items by adding/removing files (deletions don't require catalog
  surgery)

Composes with [[feedback_data-is-one-thing-rendering-is-projection]] (the
catalog is the projection; per-file is the data) and
[[feedback_content-lives-in-its-owners-home]] (each enumerable item is a
first-class artifact with its own home).

**How to apply:**
- When authoring a new typed enumeration, default to one-file-per-item from
  day one. Only add a catalog file if substrate-level metadata (axes,
  composition rules, sources) needs a home — and only put metadata there, never
  the items themselves.
- When encountering an existing catalog that embeds items: propose explosion
  as a substrate-hygiene step before depending on it. Don't author new
  references against catalog-internal IDs that you know will be moved.
- Suffix the per-item file with the typed model name in dotted form (e.g.
  `<slug>.org-role-class.json`, `<slug>.audience.json`), so the file IS
  self-identifying.
- A catalog that remains after explosion should be regenerable from the
  directory — never hand-authored to drift from filesystem truth.

Operator-stated 2026-05-30 during incident-closure workflow design:
"the role class should not be a catalog but a bunch of different files so we
can pick from just the filesystem."
