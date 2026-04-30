---
name: Delete old apps every iteration
description: Quit the running app + trash the old .app bundle before every rebuild — never let stale binaries persist
type: feedback
originSessionId: 8e2e8083-6e85-471f-958d-0599afb24d1b
---
Every rebuild iteration must follow the **close → delete → build →
launch** rhythm. Don't rebuild over a running stale binary; don't leave
old .app bundles in `/Applications/` between rebuilds.

**Why:** xcodebuild's "Deploy to Applications" script overwrites the
.app file in place, but a running process holds the binary pages it
launched from — replacing the file does not migrate the live process.
The operator burned at least one cycle reviewing screenshots that came
from a pre-fix binary while believing they showed the post-fix code.

Confirmed on 2026-04-26: operator asked "have you been deleting old
apps?" → "we should be." Habit, not a one-off.

**How to apply:** Before every `xcodebuild` invocation that targets a
running app:

1. `kill <pid>` (or `osascript -e 'quit app "..."'`) — terminate the
   current process so it releases the binary.
2. `mv /Applications/<app>.debug.app ~/.Trash/<app>.debug.app.<ts>` —
   trash, not `rm` (substrate doctrine: deletions stay recoverable).
3. Run the build.
4. Launch the freshly-deployed `.app` from `/Applications/` (the
   xcodebuild Deploy script puts it there).

This applies to all schema-lab / workflow / clia-* / collective /
ghost-shell / etc. dev loops in this substrate.
