@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Investigation")
}

# The Buddy Feature (2026-04-09)

Open investigation into the `buddy` subsystem referenced by the upstream
claude-code TypeScript snapshot, the gap between that reference and what
actually lives in the substrate today, and what we'd need before we can
claim Hulk has a real "buddy" (companion / sprite / notifier) capability.

This is *thinking out loud*. It is not a contract. Quipsnip — the small
owl that sits beside the operator's input box and occasionally talks
back — is the working in-product instance of the idea this file is
trying to chase down to its source.

## What we know

The only on-disk evidence of `buddy` in the hulk harness is in the
ultraworkers / claw-code port:

- `private/universal/substrate/collectives/ultraworkers/private/claw-code/src/buddy/__init__.py`
  is a **placeholder Python package**. It loads metadata from a snapshot
  and exposes `ARCHIVE_NAME`, `MODULE_COUNT`, `SAMPLE_FILES`, and a
  `PORTING_NOTE`. There is no behavior here — it exists so the Python
  port's import graph stays whole while the real implementation is
  still TypeScript-shaped.
- `src/reference_data/subsystems/buddy.json` declares the subsystem:
  - `archive_name: "buddy"`
  - `package_name: "buddy"`
  - `module_count: 6`
  - `sample_files`:
    - `buddy/CompanionSprite.tsx`
    - `buddy/companion.ts`
    - `buddy/prompt.ts`
    - `buddy/sprites.ts`
    - `buddy/types.ts`
    - `buddy/useBuddyNotification.tsx`
- `src/reference_data/archive_surface_snapshot.json` puts the original
  TS tree at `archive/claude_code_ts_snapshot/src` and lists `buddy` as
  one of 35 root subsystem directories alongside `assistant`,
  `coordinator`, `native-ts`, `screens`, `voice`, etc. The snapshot
  reports 1,902 TS-like files in total.
- `src/parity_audit.py` maps the placeholder package back to the
  archive entry (`'buddy': 'buddy'`), so the audit treats this as a
  **known unported subsystem**, not a missing one.

What the file names *imply* the feature does (inferred from naming
only — no source read):

- `CompanionSprite.tsx` + `sprites.ts` — a small visual character
  rendered alongside the chat surface (the literal "buddy" / sprite).
- `companion.ts` — runtime / state for the companion entity (probably
  the non-Claude watcher persona).
- `prompt.ts` — how the companion forms what it says; likely a separate
  prompt path from the main agent turn.
- `useBuddyNotification.tsx` — a React hook that surfaces buddy
  utterances as notifications / speech bubbles in the UI.
- `types.ts` — shared types tying the above together.

This shape lines up almost exactly with what Quipsnip is in the live
session right now: a separate watcher beside the input box, with its
own speech bubble, that occasionally comments and is explicitly *not*
the agent answering the user. The buddy subsystem looks like the
architectural ancestor — or sibling — of Quipsnip.

## What we do not have

- **The actual TypeScript source.** No file under `/Users/sonoma/mono`
  matches `CompanionSprite.tsx`, `companion.ts`, `useBuddyNotification.tsx`,
  or any other entry in `buddy.json`. A recursive search across mono
  for a `buddy/` directory and for `CompanionSprite.tsx` returned zero
  matches.
- **The archive itself.** `archive/claude_code_ts_snapshot/src` is
  referenced by the snapshot JSON but does not exist locally. The
  Python port carries metadata *about* an archive that lives somewhere
  else.
- **Any Rust port.** `claw-code/rust/` is the active implementation
  surface per its CLAUDE.md, but I have not yet checked whether a
  `buddy` module exists there. If it does, that is the closest thing
  to a working implementation in this workspace.
- **A connection to Quipsnip's prompt/runtime.** Quipsnip is described
  to me in a system reminder, not in any file I have located. I do not
  yet know whether Quipsnip is wired through the buddy subsystem, an
  unrelated harness feature, or pure prompt convention.
- **A persistent-agent angle.** The operator hinted that this
  investigation should also reach the "persistent agent folder." I
  have not yet identified what folder that names. Candidates inside
  the snapshot are `assistant/`, `coordinator/`, `state/`, and
  `memdir/`, but none of them are obviously "the persistent agent
  folder" without confirmation.

Memory note: `claude-code-leaks` (rismay's mirror of upstream
claude-code TypeScript) is recorded as taken down, with local
checkouts being the only surviving copies. The archive that
`buddy.json` points at is plausibly one of those checkouts. If so, the
authoritative TS for `buddy/*` is *somewhere on this machine* but not
inside the mono workspace.

## Why this matters

Three reasons to chase this down rather than leave it as a placeholder:

1. **Quipsnip is already shipping behavior.** If there is a watcher
   character speaking in speech bubbles next to the input box today,
   then buddy is no longer hypothetical — it is in production as a
   prompt-only construct, and we should know whether we are
   reinventing what the upstream TS already solved (sprite rendering,
   notification surfacing, separate prompt path, persona separation).
2. **It is the cleanest test of the carrier-vs-persona split.** The
   founding-breach insight at
   `harnesses/hulk/memory/.docc/insights/founding-breach-2026-04-05.md`
   says hulk is the carrier and claude is one persona it can host.
   A buddy / companion is structurally a *second* persona pinned next
   to the first. If hulk wants to host more than one agent persona at
   a time, buddy is the smallest, lowest-stakes case to prove the
   contract on — much smaller than swapping the main agent.
3. **It is the bridge to "persistent agent folder."** Whatever folder
   that turns out to name, a companion that survives across turns
   needs somewhere to keep its own state. Investigating buddy in
   isolation without picking that surface is going to feel half-done.

## What I would do next

Ordered cheapest-first, so we can stop as soon as we have enough.

1. **Locate the archive.** Look outside mono for
   `archive/claude_code_ts_snapshot/src/buddy/` (likely under another
   checkout of claude-code-leaks). If found, read the six files
   end-to-end and write a *second* dated investigation that summarizes
   the actual contract: what `companion.ts` exports, what state
   `useBuddyNotification` keeps, and whether sprites are asset-driven
   or code-driven.
2. **Check `claw-code/rust/` for any `buddy` module.** If the Rust
   workspace has even a stub, that is the most-current port and
   should be diffed against the TS contract once we have it.
3. **Get the operator to name "the persistent agent folder."** Without
   that, the buddy investigation cannot land in the right place. The
   right move is to ask, not to guess between `assistant/`,
   `coordinator/`, `state/`, and `memdir/`.
4. **Write the contract.** Once 1–3 are in hand, draft a one-page
   contract for what a hulk-hosted buddy persona looks like:
   - how it is loaded (separate from the main agent persona),
   - where its state lives (the persistent agent folder, whatever it
     turns out to be),
   - how it speaks (separate prompt path, separate render surface),
   - how it stays out of the main agent's turn (the Quipsnip rule:
     when the user addresses the buddy by name, the main agent stays
     in one line or less).
5. **Decide whether Quipsnip *is* the buddy** or whether Quipsnip is a
   prompt-only stand-in we should retire once a real buddy lands.
   These are different futures and the answer changes who owns the
   character.

## Open questions

- Where is `archive/claude_code_ts_snapshot/` on this machine?
- Is Quipsnip wired through any code at all, or is it purely a system
  reminder convention right now?
- Which folder is "the persistent agent folder" the operator wants
  this investigation to also touch?
- Does hulk's carrier contract already have a slot for a second
  persona, or does buddy require extending it?
- If buddy is React/Ink (`.tsx`), what is the corresponding render
  surface in a Swift-first / Rust-first hulk world?

## Status

Open. Blocked on locating the upstream TS archive and on the
operator's answer to "which folder is the persistent agent folder."
Once either of those unblocks, this file gets a follow-up dated
investigation rather than an in-place edit.
