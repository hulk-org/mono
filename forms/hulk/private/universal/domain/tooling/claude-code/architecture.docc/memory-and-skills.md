@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# memory-and-skills

Memory and skills are two separate-but-related subsystems. Memory is
about *persistent operator/agent context*; skills are about *callable
prompted behaviors*. They share a directory loader pattern and both
ship bundled defaults plus user-supplied entries.

This is the closest cluster to what operator memory calls "the
persistent agent folder." It is the first thing to look at when
deciding where buddy's `StoredCompanion` should move if it leaves
`getGlobalConfig()`.

## `src/memdir/`

Memory directory abstraction. Files:

- **`memdir.ts`** — Top-level memdir API.
- **`memoryTypes.ts`** — Memory record type definitions.
- **`paths.ts`** — User memory directory paths.
- **`teamMemPaths.ts`** — Team memory directory paths.
- **`teamMemPrompts.ts`** — Team-memory model prompts.
- **`memoryScan.ts`** — Directory scan / enumeration.
- **`findRelevantMemories.ts`** — Per-turn relevance selection.
- **`memoryAge.ts`** — Age / staleness calculation.

The pattern: a *directory of typed memory files* with paths,
relevance scoring, and age decay. The same shape this conversation's
operator memory uses (`~/.claude/memory/.docc/MEMORY.md` plus
per-memory files).

## `src/services/SessionMemory/`

Per-session memory store. Distinct from `memdir/` (which is
cross-session). Connects to `extractMemories/` (writer) and to the
compact pipeline.

## `src/services/extractMemories/`

Reads model output and extracts memory candidates. Writes via
`memdir/` and `SessionMemory/`.

## `src/services/teamMemorySync/`

Syncs team-scoped memories across devices/users. Pairs with
`memdir/teamMemPaths.ts` and `memdir/teamMemPrompts.ts`.

## `src/skills/`

- **`bundledSkills.ts`** — Static list of skills shipped in the
  bundle.
- **`bundled/`** — Bundled skill definition files.
- **`loadSkillsDir.ts`** — Loader for user skill directories.
- **`mcpSkillBuilders.ts`** — Builders that turn MCP servers into
  skills.

The user-visible surface is the `Skill` tool (`tools/SkillTool/`)
plus the `/skills` slash command (`commands/skills/`).

## `src/components/skills/` and `src/components/memory/`

UI for both subsystems. Both have their own directory.

## `src/utils/memory/` and `src/utils/skills/`

Helper functions for both subsystems. By the cross-cutting
observations in <doc:index>, `utils/` is *not* a leaf — these
helpers reach back into `services/` and `memdir/` freely.

## Cross-cutting

- **Memory has three layers.** `memdir/` (durable, on-disk),
  `services/SessionMemory/` (per-session), `services/extractMemories/`
  (writer). `services/teamMemorySync/` adds a fourth axis: scope
  (user vs. team).
- **Skills have two ingestion paths.** Bundled (compiled into the
  binary) and user directory (loaded at runtime). MCP servers can
  be promoted into skills via `mcpSkillBuilders.ts`.
- **Memory and skills both follow the "directory loader" pattern.**
  This is the right pattern for persistent agent state in general:
  a typed directory with bundled defaults and user overrides.

## Implications for the buddy storage move

If buddy's `StoredCompanion` moves out of `getGlobalConfig()` into a
hulk-level "persistent agent folder," the existing patterns to copy
are:

1. **`memdir/paths.ts`-style path resolution.** Single source of
   truth for *where* the file lives, with separate user vs. team
   variants.
2. **Typed file format with version field.** `memoryTypes.ts` is
   the right model. Buddy's existing `StoredCompanion` is already
   versionable; it just needs the field.
3. **Bundled defaults + user override.** If hulk wants out-of-box
   companions before first hatch, the skills "bundled vs. user"
   split is the right shape.
4. **Loader in `services/`, schema in `memdir/`-equivalent, UI
   surface in `components/`.** Three-way split, not a single file.

This is enough pattern to design the move, but **don't pick a
folder yet** — operator memory still owes us the canonical path.

## Open questions

- Whether `memdir/` and `SessionMemory/` share a serialization
  format or use different ones.
- The full type set in `memoryTypes.ts` — are there type families
  we'd inherit if we put a companion in the same folder?
- Whether `findRelevantMemories.ts` runs every turn or only on
  compact boundaries.
- Where `memoryAge.ts` writes its decay back to disk.
