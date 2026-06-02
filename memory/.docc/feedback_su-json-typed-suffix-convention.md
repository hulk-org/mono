---
name: su-json-typed-suffix-convention
description: "Substrate convention — typed JSON instances use <slug>.<type>.su.json filenames where the middle segment is the schema name (role, class, audience, etc.). Distinct schemas get distinct suffixes; never collapse."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

Substrate-typed JSON files use the convention `<slug>.<type>.su.json` where
the middle segment is the **schema type** the file is an instance of, and
`.su.json` is the shared substrate-unit-JSON extension.

Established 2026-05-30 when role classes were exploded from
`role-class-catalog.json` into per-file form. The 10 files are the first
instances of the `.su.json` convention; prior typed-JSON instances used the
longer `<slug>.<schema-family-name>.json` form (e.g. `<slug>.org-role.json`,
`<slug>.org-role-class.json`).

**Two schemas, two suffixes — never mix:**
- `<slug>.role.su.json` — instances of the ROLE schema (role templates)
- `<slug>.class.su.json` — instances of the CLASS schema (role classes)

Operator-stated 2026-05-30: "there are ROLE schema and CLASS schema, that's
why we can't mix" — the suffix encodes the schema type so filesystem-picking
works without opening files. If both used the same suffix, a `ls` would not
distinguish role templates from role classes; the consumer would have to open
each file and read its `*Model` field to know which schema it implements.
That defeats the filesystem-picker doctrine.

**Why:** the file-name encodes type so:
- `ls *.class.su.json` returns exactly the class instances, not the role
  templates or any other typed file
- Validators can route by suffix → schema family without parsing
- Filesystem pickers (fzf, swift-agent-cli) work without per-file inspection
- Renaming a schema family (e.g. dropping the `org-` prefix as happened here)
  doesn't force a content edit — just a filename change

**How to apply:**
- When authoring a new typed-JSON instance, default to `<slug>.<type>.su.json`
  where `<type>` is the short name of the schema the file instantiates.
- When the substrate has BOTH a parent schema and a child/specialization
  schema (role vs class, audience vs audience-profile, etc.), give each its
  own short suffix. Don't try to express the parent/child relationship in the
  filename — that's the schema's job.
- The `<type>` segment should be short, lowercase, kebab-case, and ideally a
  single noun. Long compound forms like `org-role-class` are exactly what this
  convention replaces.
- Default to alphabetical key sort + 2-space indent (substrate JSON
  formatter convention, matches `npm run fmt:json:tracked` output).

Composes with [[feedback_role-classes-as-files-not-catalog]] (per-item files
instead of catalog) and [[feedback_form-factor-suffixes-name-homes]] (dotted
suffixes name typed shape, not just packaging).
