---
name: Beads CLI takes JSON not flags
description: swift-beads-cli should accept schema-shaped JSON via file path or stdin, not one CLI flag per field
type: feedback
originSessionId: be58b7d8-d669-43ea-8d74-0bd27945a843
---
Beads CLI commands (`bd pour`, `bd close`, `bd status`, etc.) should accept their input as JSON — either a file path or piped from stdin. Do not make each BeadsIssue/BeadsFormula/BeadsMolecule field an individual CLI option.

**Why:** The schemas have 20-60+ fields (BeadsIssue has 40+). Flag-per-field CLIs become unusable at that scale. The canonical data shape is already JSON; the CLI should read the same shape. Agents and scripts produce JSON naturally.

**How to apply:** `bd pour commonai-migration --input formula.json` or `echo '{"id":"x","title":"y"}' | bd issue create`. The CLI validates against the schema, fills defaults, and writes the issue/molecule/formula to the `.wrkstrm/beads/` surface.
