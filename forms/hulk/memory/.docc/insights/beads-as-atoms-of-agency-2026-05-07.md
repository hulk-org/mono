# Beads Are Atoms Of Agency, Not Open-Work Tickets

Date: 2026-05-07

The wd skill's framing "beads are open work only" is about WHEN to spin a
bead, not what beads ARE. Operator's correction: beads are durable atoms of
agency. They record discrete units of agent action with provenance
(`sourceType`, `relatedChronicleEntry`), assignment (`assignee`), priority,
and lifecycle. Closure is part of the lifecycle, not an erasure event.

## Implications

- Closed beads stay on disk as historical record, not deleted or archived
  out of `agenda/beads/`. They remain peers of open beads in the same
  directory.
- Closure adds two fields rather than removing any:
  - `status: "closed"` (was `"open"`)
  - `closedAt: <ISO-8601 UTC>`
  - `resolutionNote: <short summary of what fixed it + any deliberate
    out-of-scope follow-ons>`
- Same-session-completed beads still get spun (the wd "open-work-only" rule
  doesn't apply when the work is genuinely an atomic agency unit worth
  recording), and they get closed in the same session via the schema
  extension above.
- Treat the bead JSON like a small event log per atom: spin = open event,
  close = resolution event. Future fields could include reopen events,
  cross-references to other beads, etc., but the schema extension stays
  conservative (status + closedAt + resolutionNote covers most cases).

## Why this matters going forward

When future winddowns surface work that gets done before the wd writes,
spin the bead anyway and close it in the same artifact set. The bead
preserves what was done and why, separately from the chronicle (which
records WHO/WHEN at agent-history granularity) and the journal (which
records the prose narrative). Each layer answers a different question.

## Source

In-session correction during the 2026-05-07 winddown follow-up after I
asked whether to delete or leave the bead I'd just closed. Operator: "wd?
really no... i think beads are atoms of agency!"
