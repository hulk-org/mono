# MEMORY.md

Compatibility pointer only.

## Canonical claude memory — typed Shinji Techo records (NOT .md files)

Substrate-canonical truth for claude's memory lives at typed Shinji Techo
records, not at .md files:

- **Expertise lane**: `memory/.docc/resources/agency/techo/expertise/claude.expertise.techo.jsonl`
- **Chronicle lane**: `memory/.docc/resources/agency/techo/chronicle/`
- **Journal lane**: `memory/.docc/resources/agency/techo/journal/`

Each entry is a typed `ShinjiTechoEntryModel` (from `shinji-techo-schemas v0.2.0`)
with: `rt` (record type), `id`, `m` (moment anchor), `k` (kindRef), `p`
(payload), `qt` (quote), `hk` (haiku), `nt` (NoteModel v0.4.0 for long-form
body), `t` (tags), and `l` (links).

## Authoring workflow

`.md` is throwaway authoring scaffolding — NEVER canonical anywhere. The
substrate-correct workflow:

```
1. Author draft at /tmp/<slug>.md (temp; human-friendly)
2. Audit + lint + format the draft
3. Project to typed JSON via:
     md project new
4. Ingest into the Shinji Techo lane via:
     shinji-techo@clia-org.cli ingest --agent claude --kind <kind> ...
5. Typed record lands at canonical-memory path
6. Draft .md dissolves (per no-deletion-rehome-and-prove axiom: REHOME → PROVE → DISSOLVE)
```

Per the `no-deletion-rehome-and-prove` axiom: substrate-cleanup MAY NEVER
delete substrate-content. The workflow is REHOME (.md body → typed-record
`nt` field as NoteModel v0.4.0) + PROVE (read-back verify content survived)
DISSOLVE (delete source .md). The PROVE gate is non-optional.

## Why typed records over .md

- Typed records validate against substrate-canonical schemas; .md files don't.
- Typed records carry typed quote + typed haiku + typed body + typed
  provenance + typed moment-anchor — substrate-canonical fields that .md
  frontmatter can't enforce.
- Typed records survive across harness changes; .md formats are
  harness-managed and can be normalized away by the host.
- Typed records compose into typed-set queries (e.g., "all expertise entries
  from a date range"); .md catalogs require ad-hoc parsing.

## Harness auto-memory (separate concern)

The Claude Code harness reads `~/.claude/memory/.docc/*.md` files as an
agent-recall convenience surface via the `autoMemoryDirectory` settings.json
key. That surface is **harness-managed**, **not substrate-canonical truth**.
Anything substrate-doctrinal that lands there should also live in the
typed-record canonical surface above (and ideally be REGENERATED as a
projection from typed records, not authored independently).

## Tools

- `md project new` — projects authored .md to typed JSON projection
- `shinji-techo@clia-org.cli` — typed Shinji Techo lane CLI (ingest, mirror, show, validate)
- Located at: `collectives/clia-org/private/universal/domain/memory/spm/shinji-techo@clia-org.cli/`
