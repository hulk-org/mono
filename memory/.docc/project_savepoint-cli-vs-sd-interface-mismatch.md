---
name: savepoint-cli-vs-sd-interface-mismatch
description: "Open issue surfaced 2026-05-26 during savepoint kura-org migration: the substrate's savepoint-cli emit invokes savepointd/savepoint.sd with `--process-intent <path>` (legacy interface), but the new savepoint.sd accepts `--lane <commit|push>` (queue-draining interface). Workaround: symlink ~/.local/bin/savepointd at the LEGACY savepointd binary (also built in the new package), not at savepoint.sd. Real fix: update savepoint-cli emit-side to invoke savepoint.sd via the new lane interface."
metadata: 
  node_type: memory
  type: project
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**Open issue.** As of 2026-05-26 (after the kura-org savepoint migration commits `clia-org@2efa00c3` + `kura-org@9864d7c` + `mono@321633439c`), the substrate's `savepoint-cli emit` invokes the daemon with the LEGACY interface, but the substrate also built a NEW daemon binary (`savepoint.sd`) with a different interface. The two are not compatible yet.

## Symptom

```
$ savepoint-cli emit --harness claude-code --session-id <id> --dry-run
error: unknown argument '--process-intent'
savepoint.sd — sleeping queue drainer for savepoint commit + push work
USAGE:
  savepoint.sd [--working-tree <path> | --git-dir <path>] [OPTIONS]
OPTIONS:
  --lane <all|commit|push>       Queue lane to drain. Default: all.
  --commit-worker <path>         Override digikoma-savepoint path.
  --push-worker <path>           Override digikoma-git-push path.
  ...
```

## Root cause

The `savepoint.sd` package builds TWO executable targets:

- `savepointd` (legacy) — interface: `savepointd --process-intent <path> [--worker-path <path>]`
- `savepoint.sd` (new) — interface: `savepoint.sd [--working-tree <path>] [--lane <commit|push>] [--commit-worker <path>]`

The legacy daemon's contract is "process this one intent file"; the new daemon's contract is "drain the queue at this working-tree, sleep briefly for late arrivals, exit."

`savepoint-cli emit` (the agent-side CLI in `savepoint.cli`) currently only knows the LEGACY contract — it writes a CommitRequestModel to a staging path and invokes the daemon with `--process-intent <staging-path>`. Pointing the symlink at `savepoint.sd` makes `savepoint-cli emit` fail because `--process-intent` isn't recognized.

## Workaround applied (2026-05-26)

```bash
ln -sf '/Users/sonoma/mono/private/universal/substrate/collectives/kura-org/private/universal/tools/savepoint.sd/.build/release/savepointd' \
       ~/.local/bin/savepointd
```

The legacy `savepointd` binary lives in the new home (`savepoint.sd/.build/release/savepointd`); pointing the install symlink at it keeps the CLI working while the substrate completes the source-side migration.

`savepoint.cli` (the new agent-side CLI binary) is also at the new home and matches the OLD savepointd's interface (verified: `savepoint-cli emit` calls landed three commits successfully — `clia-org@2efa00c3`, `kura-org@9864d7c`, `mono@321633439c`).

## Real fix

Update `savepoint.cli/Sources/SavepointEmitterCore/SavepointEmitter.swift` (and `PushEmitter.swift`) to invoke `savepoint.sd` with the new `--lane <commit|push>` interface:

```swift
// Replace:
//   savepointd --process-intent <staging>
// With:
//   savepoint.sd --working-tree <wt> --lane commit --commit-worker <digikoma>
```

The new lane interface is queue-draining: the emitter writes the intent file to the queue staging dir, then the daemon scans that dir for ALL pending intents (not just the one this emitter just wrote), drains them, and exits.

Order of operations for the real fix:

1. Read `savepoint-cli emit`'s current daemon-invocation code (it lives somewhere in `SavepointEmitterCore`)
2. Identify whether the new lane interface needs the emitter to do anything different at write time (queue-dir convention, intent-file naming, etc.)
3. Update the emitter to write to the lane queue + invoke `savepoint.sd` with `--lane` instead of `savepointd --process-intent`
4. Update the default `--savepointd` arg in savepoint-cli to point at `savepoint.sd` instead of `savepointd`
5. Rebuild + re-link symlinks: `~/.local/bin/savepointd → savepoint.sd`
6. Smoke-test: `savepoint-cli emit --dry-run` should succeed
7. Then: remove the legacy `savepointd` executable target from `savepoint.sd/Package.swift` (keep only `savepoint.sd`)
8. Then: update the savepoint skill to call `savepoint.sd` not `savepointd` (or keep `savepointd` as the install symlink name pointing at `savepoint.sd` for Unix-convention familiarity)

## How to apply

- When investigating savepoint-related issues: check whether the symlink is pointing at the legacy or new daemon
- When updating savepoint source: aim for the new lane interface; legacy `--process-intent` is being retired
- DO NOT delete the legacy `savepointd` executable target until savepoint-cli is migrated to the new lane interface — current `~/.local/bin/savepointd` symlink depends on it
- Until the real fix lands: any session updating savepoint-cli should re-link to the legacy binary at the end of the session so subsequent agents have a working CLI

## History

Surfaced 2026-05-26 by an agent attempting to use the new `savepoint.sd` binary as the install target for `~/.local/bin/savepointd`. The migration commits succeeded only after pointing the symlink back at the legacy `savepointd` binary from within the new package. Documented immediately so the substrate's next savepoint-touching session can pick up the lane-interface migration as known work.

## Related

- [[feedback_savepoint-snapshot-at-emit-time]] — the kura-org migration this issue surfaced under
- [[feedback_sd-sleeping-daemon-form-factor]] — defines the `.sd` form-factor; the new lane interface is part of what makes a daemon truly sleeping (queue-driven vs intent-driven)
- [[feedback_harness-canonical-home-clia-org]] — precedent for "old paths retired, new paths canonical, dependents migrate in waves"
- savepoint-cli source: `kura-org/private/universal/tools/savepoint.cli/Sources/SavepointEmitterCore/`
- savepoint.sd source: `kura-org/private/universal/tools/savepoint.sd/Sources/savepoint-sd/Main.swift`
- savepointd legacy source: `kura-org/private/universal/tools/savepoint.sd/Sources/savepointd/Main.swift`
- Migration commits: clia-org `2efa00c3`, kura-org `9864d7c`, mono root `321633439c`
