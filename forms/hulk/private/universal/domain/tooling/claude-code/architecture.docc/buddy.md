@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# buddy

The `buddy/` subsystem is the **companion character** that sits
beside the input box. Quipsnip is a buddy instance.

This article is a pointer. The full investigation lives in the
hulk investigations bundle, not this architecture bundle, because
it covers history, design intent, and comparison material that
doesn't belong in a code-shape doc:

- [The Buddy Feature (2026-04-09)](../../../../../../hulk.investigations.docc/buddy-feature-2026-04-09.md)
  — first-pass investigation, filed before the source was located.
- [Buddy vs. S-Type (2026-04-09)](../../../../../../hulk.investigations.docc/buddy-vs-s-type-2026-04-09.md)
  — full read of the actual TypeScript and a side-by-side against
  the A\* Triads / S-Type Contribution System.

## Files at a glance

`src/buddy/`:

| File | Role |
| --- | --- |
| `types.ts` | Companion type model: `Rarity`, `Species` (18), `Eye`, `Hat`, `STAT_NAMES`, `CompanionBones`, `CompanionSoul`, `Companion`, `StoredCompanion`. |
| `companion.ts` | Roll engine: mulberry32 PRNG seeded from `hash(userId + SALT)`, weighted rarity, scaled stat floors, single-slot memoization. |
| `sprites.ts` | 18 species × 3 frames of 5×12 ASCII; eye templating via `{E}`; hats only on blank line 0. |
| `prompt.ts` | `companionIntroText` (the system prompt) + `getCompanionIntroAttachment` (dedupes + gates on `feature('BUDDY')` and `companionMuted`). |
| `useBuddyNotification.tsx` | Rainbow `/buddy` teaser notification (April 1–7 2026 local-date window) + `findBuddyTriggerPositions` for prompt highlighting. |
| `CompanionSprite.tsx` | Ink render component (not yet read in detail). |

## Storage

Today the buddy soul lives inside `getGlobalConfig()` from
`utils/config.ts` — i.e., the Claude Code global config blob.
Bones are recomputed from `userId` on every read so they never
persist.

## Connections to other subsystems

- **`prompt.ts` → `types/message.ts` + `utils/attachments.ts`** —
  the companion intro is delivered as an attachment in the message
  stream, not a side channel.
- **`useBuddyNotification.tsx` → `context/notifications.tsx`** —
  reuses the standard notification context.
- **`useBuddyNotification.tsx` → `utils/thinking.ts`** — uses
  `getRainbowColor` (the same one the spinner uses).
- **`feature('BUDDY')` from `bun:bundle`** — compile-time gate on
  every public surface.

## See also

- <doc:components-and-ink> — for how `CompanionSprite.tsx` plugs
  into the render tree.
- <doc:memory-and-skills> — for the directory-loader pattern that
  buddy storage should adopt if it leaves `getGlobalConfig()`.
- <doc:state-and-bootstrap> — for where companion state would
  belong if it became a session-level concept rather than a
  config-level one.
