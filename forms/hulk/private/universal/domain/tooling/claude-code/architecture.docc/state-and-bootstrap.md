@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# state-and-bootstrap

There are **two state surfaces** in this codebase, and they should
not be conflated:

1. **`bootstrap/state.ts`** — Immutable session facts written once
   during early boot in `main.tsx`. Read everywhere afterwards.
2. **`state/AppState.tsx`** — Reactive app state container that UI
   components subscribe to.

## `src/bootstrap/state.ts`

Single file. Holds:

- `sessionId` (with `getSessionId` accessor and an
  `isSessionPersistenceDisabled` companion).
- `projectRoot` (with `getProjectRoot`).
- Additional CLAUDE.md directories
  (`getAdditionalDirectoriesForClaudeMd`).
- Cached CLAUDE.md content (`setCachedClaudeMdContent` writer).

Imported by `QueryEngine.ts`, `history.ts`, `context.ts`, and
others. Treat the values as **immutable after `main.tsx`**.
Anything that needs to change at runtime belongs in `state/`.

## `src/state/`

- **`AppState.tsx`** — Type definition for the reactive app state.
- **`AppStateStore.ts`** — Store implementation.
- **`store.ts`** — Public store entrypoint / factory.
- **`onChangeAppState.ts`** — Change subscription helper.
- **`selectors.ts`** — Pure state selectors.
- **`teammateViewHelpers.ts`** — Helpers specific to the teammate
  (multi-agent) view.

## `main.tsx` boot sequence (read from comments)

The first few lines of `main.tsx` are deliberately ordered for
performance:

1. `profileCheckpoint('main_tsx_entry')` — Marks entry before any
   heavy module evaluation.
2. `startMdmRawRead()` — Fires MDM subprocesses (`plutil`,
   `reg query`) so they run in parallel with the next ~135 ms of
   imports.
3. `startKeychainPrefetch()` — Fires both macOS keychain reads
   (OAuth + legacy API key) in parallel. `isRemoteManagedSettingsEligible`
   would otherwise read them sequentially via sync spawn inside
   `applySafeConfigEnvironmentVariables` (~65 ms on every macOS
   startup).
4. Remaining imports.

These are the only blocks tagged
`// eslint-disable-next-line custom-rules/no-top-level-side-effects`,
which means **top-level side effects are normally banned** and
this file is a deliberate exception. Adding any new top-level side
effect here is a contract decision.

## `src/setup.ts`

The non-interactive bootstrap path. Calls into:
- `analytics.logEvent` (with the verbose verified-not-code metadata
  type).
- `setCwd` (`utils/Shell.ts`) and `getCwd` (`utils/cwd.ts`).
- `checkForReleaseNotes` (`utils/releaseNotes.ts`).
- `initSinks` (`utils/sinks.ts`).
- `getIsNonInteractiveSession` + `getProjectRoot` (`bootstrap/state`).

`replLauncher.tsx` and `dialogLaunchers.tsx` are the equivalents for
the interactive path.

## `src/projectOnboardingState.ts`

First-time project onboarding state machine. Distinct from the
session-level bootstrap above; tracks per-project state about
whether the user has completed onboarding for *this directory*.

## Cross-cutting

- **Two state surfaces ≠ duplication.** The split is *temporal*:
  `bootstrap/` is "facts known at boot," `state/` is "facts that
  change during the session." They never overlap.
- **`profileCheckpoint`** is sprinkled across `main.tsx` and a few
  other files. The reports are written via
  `utils/startupProfiler.ts`. Worth a follow-up if startup time
  matters.
- **`utils/cleanupRegistry.ts`** is the symmetric "shut down"
  surface. Anything boot-time should register a cleanup here.

## Open questions

- Whether `state/AppState.tsx` is Zustand, a custom store, or
  something else.
- The `teammateView` shape — connects to `tasks/InProcessTeammateTask`
  and the carrier-vs-persona conversation.
- Whether `bootstrap/state.ts` is *truly* immutable after boot or
  whether some setters are called later (e.g.
  `setCachedClaudeMdContent` looks like it's not).
- The full set of `profileCheckpoint` call sites and what gets
  reported.
