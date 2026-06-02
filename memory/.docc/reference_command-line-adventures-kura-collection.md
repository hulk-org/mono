---
name: command-line-adventures-kura-collection
description: "A kura collection at `kura-org/private/universal/kura/collections/command-line-adventures/` records substrate command-line edge cases (ARG_MAX, FD limits, quoted-path normalization, etc.) with diagnosis + fix + lesson per entry."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate has a dedicated kura collection for command-line surface lessons:

**Path:** `private/universal/substrate/collectives/kura-org/private/universal/kura/collections/command-line-adventures/`

**Purpose:** record each time the Unix command-line surface bites somebody — operator, agent, ghost, daemon — and what was learned. Each entry is one adventure with symptom / diagnosis / fix / lesson / cross-platform notes.

## When to add an entry

Add a new entry when:

- A POSIX limit fires unexpectedly (ARG_MAX, MAX_FD, MAX_PATH, signal-handling races, etc.)
- A shell-quoting / Unicode-normalization edge breaks a substrate tool
- A subprocess wrapper has hidden behavior worth knowing
- Anything that costs >15 minutes to diagnose and the operator says "this will happen again"

**Don't add an entry for** routine bugs in agent-written code (those go in commit messages / agency entries). The collection is specifically about the *command-line surface* being uncooperative, not about substrate bugs.

## Entry naming

`<YYYY-MM-DD>-<short-slug>.md` at the collection root.

## How to use this collection

- Before deep-debugging a command-line failure: search this collection for prior matches
- After fixing one: add the entry while it's fresh
- Cross-reference from memory notes when the lesson also produces a doctrine rule (e.g., `feedback_substrate-toolmaking-checklist` cross-refs this collection's ARG_MAX entry)

## Why kura-org, not personal memory

These lessons are cross-actor. Any agent or operator might bump the same edge — the lessons need to be discoverable from outside one agent's home. The Kura `collections/` tier under kura-org is the substrate's canonical home for shared atemporal knowledge per the Kura typology doctrine.

Memory notes (under `<agent>/memory/.docc/` or `~/.claude/memory/.docc/`) are agent-scoped doctrine; kura collections are cross-actor reference material. Different audiences, different homes.

## History

Operator-stated 2026-05-26 after hitting ARG_MAX with savepoint on 12k file paths: "let's add this to command line adventures. this is the second time i broke the command line." Indicated this was a NEW kura collection (no prior collections under kura-org).

## Related

- [[feedback_substrate-toolmaking-checklist]] — toolmaking discipline
- [[feedback_use-common-process-not-foundation]] — sibling subprocess lesson
- [[feedback_kura-storage-typology]] — why collections live at kura-org and what the tier means
