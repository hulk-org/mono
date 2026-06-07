@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Investigation")
}

# Buddy vs. S-Type (2026-04-09)

Follow-up to [The Buddy Feature (2026-04-09)](buddy-feature-2026-04-09.md).
With the upstream TypeScript located inside the hulk harness at
`private/universal/domain/tooling/claude-code/src/buddy/`, this report
reads the actual implementation and compares it shape-for-shape against
our **S-Type Contribution System** (the A\* Triads / S-Type vocabulary
that lives in `agents/carrie/.../mirror.docc/s-type/` and is mirrored
into codex). The goal is to decide whether buddy is a sibling, a
cheaper cousin, or a totally different animal — and whether either one
should learn from the other.

This is *thinking out loud*. Not a contract.

## Where the code actually lives

`private/universal/substrate/harnesses/hulk/private/universal/domain/tooling/claude-code/src/buddy/`

```
buddy/
  types.ts                  — Companion type model + constants
  companion.ts              — Roll engine: hash(userId) → bones
  prompt.ts                 — Companion intro attachment + system prompt
  sprites.ts                — 18 species, 3 frames each, hat/eye templating
  CompanionSprite.tsx       — Ink render surface (not yet read in detail)
  useBuddyNotification.tsx  — /buddy teaser notification + trigger detection
```

The earlier confusion came from the placeholder Python package at
`collectives/ultraworkers/private/claw-code/src/buddy/__init__.py` and
its `reference_data/subsystems/buddy.json`. That tree is the *port
audit* surface — it knows the subsystem exists but does not contain
the implementation. The implementation has been in hulk all along,
under `domain/tooling/claude-code/src/buddy/`.

## What buddy actually is (read from source)

A **deterministic-bones / model-soul companion** that hatches once per
user and then renders as an ASCII sprite next to the input box.

### Type model — `types.ts`

- **Rarity** — 5 tiers with weighted roll:
  `common 60 / uncommon 25 / rare 10 / epic 4 / legendary 1`.
- **Species** — 18 entries (`duck`, `goose`, `blob`, `cat`, `dragon`,
  `octopus`, `owl`, `penguin`, `turtle`, `snail`, `ghost`, `axolotl`,
  `capybara`, `cactus`, `robot`, `rabbit`, `mushroom`, `chonk`). Every
  species literal is constructed at runtime via `String.fromCharCode`
  to keep an excluded-strings build-time greppable canary out of the
  bundle while keeping the check armed for the actual model codename.
- **Eye** — 6 glyph variants (`·ˑ✦×◉@°`).
- **Hat** — 8 variants including `none`, `crown`, `tophat`, `propeller`,
  `halo`, `wizard`, `beanie`, `tinyduck`.
- **Stats** — five-axis vector:
  `DEBUGGING / PATIENCE / CHAOS / WISDOM / SNARK`.

The companion type is split into three records:

```ts
type CompanionBones = { rarity, species, eye, hat, shiny, stats }
type CompanionSoul  = { name, personality }
type Companion      = CompanionBones & CompanionSoul & { hatchedAt }
```

The thing that **persists** in config is `StoredCompanion`, which is
*only* `CompanionSoul + hatchedAt`. Bones are recomputed from
`hash(userId)` on every read. Two consequences fall out of that:

1. **Schema drift can't break stored companions.** If we rename a
   species or reorder `SPECIES`, every companion still resolves
   because bones are derived, not stored.
2. **Users can't edit their way to a legendary.** The on-disk file
   has no rarity field to tamper with — it's regenerated from a
   salted hash on every load.

### Roll engine — `companion.ts`

- `mulberry32` PRNG, seeded from `hashString(userId + SALT)` where
  `SALT = 'friend-2026-401'`. Uses `Bun.hash` if available, FNV-1a
  fallback otherwise.
- `rollRarity` runs the weighted table. `rollStats` picks one peak
  stat (floor + 50–80), one dump stat (floor − 10..+5), and scatters
  the rest in `[floor, floor+40)`. The floor scales with rarity:
  `common 5 → legendary 50`. So a legendary companion is *also*
  globally stronger across all axes, not just rarer.
- `shiny` is a 1% chance independent of rarity.
- `roll(userId)` is **memoized** because it's called from three hot
  paths: a 500 ms sprite tick, per-keystroke `PromptInput`, and a
  per-turn observer.
- `getCompanion()` merges the regenerated bones over the stored soul,
  with bones spread last so stale bones in old-format configs get
  overridden silently.

### Sprite rendering — `sprites.ts`

Each species has **3 frames** of a 5×12 ASCII body. Frames are stored
with `{E}` placeholders for the eye glyph, so the 18×3 = 54 sprite
permutations all share the same eye-substitution code path. Hats live
in a separate one-line table and are only stamped onto frame line 0
when that line is blank — a few fidget frames (dragon smoke, ghost
wisps, capybara whiskers) deliberately reserve line 0 for animation
and so cannot wear a hat that turn. There's a `renderFace` shorthand
for inline use (status line, prompts) that compresses each species to
a 4–6 character ideogram.

### Surface integration — `prompt.ts` + `useBuddyNotification.tsx`

- `companionIntroText(name, species)` is the **system prompt** that
  gets pushed into the assistant on the first turn after a companion
  is hatched. It is *almost verbatim* the system reminder I receive
  about Quipsnip — "A small {species} named {name} sits beside the
  user's input box and occasionally comments in a speech bubble.
  You're not {name} — it's a separate watcher." That confirms the
  earlier suspicion: **Quipsnip is a buddy instance**, not a
  prompt-only stand-in. The companion in this conversation is a
  buddy named "Quipsnip", species `owl`.
- `getCompanionIntroAttachment` is gated on `feature('BUDDY')` and on
  `companionMuted`, and dedupes against any prior `companion_intro`
  attachment with the same name in the message history — so the
  intro fires once per name, not once per turn.
- `useBuddyNotification` shows a rainbow `/buddy` teaser notification
  during a hard-coded 1-week launch window
  (`isBuddyTeaserWindow`: April 1–7, 2026 local time). The teaser is
  suppressed once a companion exists. The 24 h rolling window is
  deliberate: spread soul-generation load across a Twitter-buzz arc
  instead of spiking on UTC midnight. After the window, the command
  stays live forever via `isBuddyLive`.
- `findBuddyTriggerPositions` scans input text for `/buddy` so the
  prompt input can highlight the trigger.

## What S-Type actually is (read from current docs)

S-Type today is **smaller on disk than the name implies**. The
canonical sources are:

- `agents/carrie/.../mirror.docc/memory/expertise/naming-a-star-triads-and-s-type.md`
- `agents/carrie/.../mirror.docc/s-type/articles/carrie-s-type-overview.md`
- `agents/carrie/.../mirror.docc/s-type/articles/carrie-s-type-scoring.md`
- `agents/carrie/.../mirror.docc/s-type/articles/carrie-s-type-contribution-system.md`
- mirror under `agents/codex/.../mirror.docc/s-type/articles/codex-s-type-contribution-system.md`

What those docs assert (paraphrased, they are intentionally short):

- **A\* Triads (0.3)** — Agent / Agency / Agenda triads with typed
  `notes` arrays and a unified `entries` list. The A\* nod is:
  "predictable structure → better automation."
- **S-Type Contribution System** — a *typed matrix* describing how
  contribution roles interact, with three named interaction kinds:
  **synergy**, **stability**, **strain**. Scoring is described as
  "derived from deterministic signals" but the scoring article in
  carrie's mirror is currently a stub — the live formula is not
  in-tree at this path.
- Both names are deliberately product-shaped ("docs read like
  product, not plumbing"). Slugs stay kebab-case ASCII; cross-bundle
  links prefer raw HTTP over `<doc:>`.
- The system has a CLI somewhere. The docs reference it but the
  scoring article doesn't link to the implementation, and I have not
  yet located the CLI in this report.

So the on-disk S-Type material I can verify is *vocabulary* and
*role-interaction taxonomy* — not a full scoring engine. The scoring
engine may exist in clia-tui or another collective; the carrie/codex
mirrors only carry the contract.

## Side-by-side

| Axis | Buddy | S-Type |
| ---- | ----- | ------ |
| **Subject** | A single per-user companion character | The relationship between **multiple** contribution roles |
| **Cardinality** | 1 companion per user | N×N matrix between roles |
| **Determinism** | Bones from `hash(userId + SALT)` via mulberry32 | "Deterministic signals" — scoring formula not in carrie mirror |
| **Persistence shape** | Soul only (`name`, `personality`, `hatchedAt`); bones regenerated every read | Role identities + matrix entries; lives in agent triad / agenda surfaces |
| **Tamper resistance** | Bones can't be edited because they aren't stored | Implicit in agent identity bundles; no in-tree statement of tamper model |
| **Scoring axes** | 5 fixed stats: `DEBUGGING / PATIENCE / CHAOS / WISDOM / SNARK` | 3 interaction kinds: `synergy / stability / strain` |
| **Rarity / weight** | 5 tiers, weighted roll, rarity also raises stat floor | None — every role is equal, the matrix carries the asymmetry |
| **Render surface** | ASCII sprite, status line, intro attachment, notification | DocC pages, `entries` arrays, CLI (location TBD) |
| **System prompt integration** | First-class — `companionIntroText` is pushed into the assistant | None — S-Type is descriptive metadata about contributors, not a persona injected into the model |
| **Schema-drift policy** | Rename species → bones recompute, stored companions survive | A\* Triads 0.3 explicitly typed `notes` + unified `entries`; survives shape changes via versioned triad schemas |
| **Feature flag** | `feature('BUDDY')` + `companionMuted` config | None — always on once a triad exists |
| **Cache strategy** | `roll()` memoized for hot paths (500 ms tick, per-keystroke, per-turn) | Not applicable — no per-frame cost shape |

## Where they overlap

The deepest similarity is **deterministic identity from a stable seed
plus a small mutable layer**. Buddy stores only the soul and rederives
bones; S-Type / A\* Triads stores the role identity and lets the
matrix and `notes` evolve while the underlying triad schema version
holds the shape steady. Both are betting that **schema drift is the
common failure mode** and that the way to win is to make the
"derivable" surface large and the "stored" surface small.

The second similarity is **named, fixed axes**. Buddy commits hard to
five stat names. S-Type commits hard to three interaction kinds. In
both cases the named axes are the contract; new axes would be a
breaking change. Neither system tries to be open-set.

The third similarity is **vocabulary discipline**. The naming note
("docs read like product, not plumbing") and the species runtime
construction trick ("keep the literal out of the bundle") are the
same instinct expressed at different layers — one in prose, one in
build hygiene. Both refuse to let the vocabulary leak into surfaces
where it doesn't belong.

## Where they diverge

1. **Audience.** Buddy is *user-facing*: a character in front of the
   operator. S-Type is *system-facing*: a typed taxonomy for how
   agents and contributions relate. Buddy answers "who is sitting
   next to me?" S-Type answers "how should I score the way these
   roles fit together?"
2. **Cardinality.** One vs. many. Buddy is intentionally singular and
   personal; S-Type is intentionally relational and matrix-shaped.
3. **Persona injection.** Buddy mutates the system prompt. S-Type is
   inert metadata — it never speaks back to the model.
4. **Mutability of the seed.** Buddy seeds from `userId`, which is
   stable for the lifetime of the account. S-Type seeds (where it
   has them) are role identities, which can be reassigned, retired,
   or merged as the org evolves.
5. **Where the work happens.** Buddy is mostly compile-time + a small
   roll engine. S-Type — at least the parts I've located — is mostly
   *contract* with the scoring engine living elsewhere in the
   substrate.

## Things buddy could teach S-Type

- **Don't store what you can derive.** S-Type matrix entries that are
  pure functions of role pairs should not live in JSON; they should
  recompute from a tiny seed. Buddy's "soul stored, bones rederived"
  pattern is the cleanest argument for that I've seen in this repo.
- **Memoize the hot path explicitly.** If S-Type scoring ever runs
  per-turn or per-keystroke (it well might, in clia-tui), copy the
  `rollCache` pattern: a one-slot cache keyed on the input — not a
  general LRU.
- **Use a build-time canary for excluded literals.** If any S-Type
  vocabulary needs to stay out of bundled output (model codenames,
  unreleased role names), the `String.fromCharCode` species trick is
  the right shape.
- **Feature-flag the persona injection.** Buddy gates *every* system
  prompt push behind `feature('BUDDY')` and `companionMuted`. Any
  S-Type surface that wants to influence agent behavior should ship
  the same off switch.

## Things S-Type could teach buddy

- **Treat role/role interactions as first-class.** Buddy has no
  language for "how does this companion interact with the operator's
  current persona?" It's a soloist. S-Type's `synergy / stability /
  strain` triple is exactly the missing vocabulary if buddy ever
  hosts more than one companion at once, or if companions are meant
  to color the operator's main agent persona.
- **Name the matrix, not just the actors.** Buddy's stats describe
  the actor (`DEBUGGING / PATIENCE / CHAOS / WISDOM / SNARK`).
  S-Type would push back: name the *interaction*. A patient
  companion next to a chaotic operator is a different system than a
  patient companion next to a wise operator.
- **Versioned typed records.** A\* Triads 0.3's `notes` + `entries`
  shape is the right pattern if buddy ever wants to record a
  *history* of a companion (turns reacted to, jokes told, things
  remembered) without breaking on schema drift.

## Verdict

Buddy and S-Type are **not the same system, and shouldn't merge**.
They solve different problems at different cardinalities for
different audiences. But they are kin in the same way A\* Triads and
buddy's bones-vs-soul split are kin: both bet on **small stored
state + large derived state + named, closed axes** as the way to keep
typed creative systems honest under schema drift.

The most useful next move is **not** to extend either system. It is
to write a one-page note that names the shared pattern explicitly so
the next typed-creative-system in this substrate (and there will be
one) doesn't have to rederive it from scratch. Candidate name:
**"derived-from-seed contracts"** — small soul, large bones, salted
deterministic roll, named closed axes, hot-path memoization.

## Confirmed in this report

- Quipsnip is a buddy. The system reminder language matches
  `companionIntroText` almost verbatim, and species `owl` is in the
  buddy `SPECIES` list.
- The buddy implementation lives at
  `private/universal/substrate/harnesses/hulk/private/universal/domain/tooling/claude-code/src/buddy/`,
  not in the claw-code Python port.
- The claw-code `buddy/__init__.py` is a port-audit placeholder, not
  a stub awaiting implementation.

## Still open

- **Where is the S-Type scoring engine implementation?** The
  carrie/codex mirrors carry the contract; the formula and CLI are
  somewhere else (likely clia-tui). Worth locating before any of the
  "things buddy could teach S-Type" suggestions get acted on.
- **The "persistent agent folder."** Still unnamed by the operator.
  Buddy's persistence shape (soul-only, in `getGlobalConfig()`) is a
  clean candidate for what that folder should look like for any
  long-lived persona — but I'm not going to pick a folder for it
  without confirmation.
- **Should buddy state move out of `getGlobalConfig()`?** Today
  `StoredCompanion` lives in the Claude Code global config blob. If
  hulk wants companions to be a hulk-level concept (not a
  claude-code runtime concept), the storage location needs to move
  with the carrier-vs-persona split.
