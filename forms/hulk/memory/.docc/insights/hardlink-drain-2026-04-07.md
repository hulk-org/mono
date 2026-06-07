# Hardlink Drain — 2026-04-07

## What this is

A technique for migrating a directory that a **live process** is actively
reading and writing — without stopping the process, without losing writes,
and without leaving compatibility symlinks behind that you'll forget to
clean up.

It was invented mid-migration when moving `harnesses/claude/` →
`harnesses/hulk/` while running inside the Claude Code session whose own
home was being migrated.

## The problem

You want to move all data from path `A/` to path `B/` while a long-running
process keeps `A/` open. Three layers of pain:

1. **Open file descriptors.** The process holds `fd`s on files in `A/`. You
   want those writes to land in `B/` from now on, not in `A/`.
2. **Cached absolute paths.** The process resolved `A/` once at startup
   (via `realpath()` on a symlink, or via a hardcoded constant) and kept
   the absolute string. Even if you re-point the symlink that originally
   produced `A/`, the process keeps writing to `A/` because it cached the
   resolved string, not the symlink.
3. **New file creation.** The process creates new files (per-tool shell
   snapshots, periodic backups, fresh JSONLs) on demand. Those new files
   are *born* at `A/`, not `B/`, and there's nothing you can do about that
   while the process is running.

Naïve fixes that don't work:

- **`mv A/* B/`** — Open `fd`s follow inodes through `mv` (✅), but new file
  creation continues to land at `A/` because the process re-`open()`s by
  the cached absolute path (❌).
- **Re-point the home symlink (`~/.claude → B`)** — Helps for things that
  resolve through the symlink each time, but cached `realpath()` results
  inside the running process don't see the new symlink target (❌).
- **`cp -a A/ B/` then delete `A/`** — `cp` snapshots a moment in time. By
  the time you delete `A/`, new writes have already landed there and you
  lose them. The destination drifts from the source (❌).
- **Compat symlink `A → B`** — Works mechanically, but the operator forgets
  about it, future agents grep for the legacy path, and the migration is
  never actually finished. Soft veto by operator policy (❌).
- **Bind mount / firmlink `A → B`** — Linux has bind mounts; macOS has
  firmlinks but they require `/usr/share/firmlinks` edits and a reboot. Not
  available mid-session (❌).

## The insight

> **Two paths, one inode.**
>
> A hardlink is not a copy. It is a second directory entry that points at
> the same inode as the first. There is no "original" and "copy" — both
> entries are equally real, and writes through either path land on the
> same data. The filesystem treats them as the same file because, at the
> inode level, they *are* the same file.

This is exactly the property the live-process problem needs:

- The process opens `A/foo` via its cached absolute path → reads/writes the
  shared inode.
- A separate path `B/foo` is a hardlink to the same inode → reads/writes
  the same data.
- Anything that walks through `B/` (a different process, a backup script,
  the new home symlink target) sees the same content as the live process,
  in real time, with zero copy overhead and zero sync delay.

It is a **path alias at the filesystem layer**, not a userspace one. The
operator never sees a symlink. There is no "compat layer" to forget about,
because both paths are first-class.

## The drain daemon

Hardlinks solve the *existing* files. They don't solve the *new* files the
process creates after the migration starts. For that, run a small daemon
that watches `A/` and hardlinks anything new into `B/` within a small time
window.

The canonical implementation is the Swift package
[`swift-hardlink-drain-cli`](../../../../../../../collectives/swift-universal/private/universal/domain/tooling/spm/swift-hardlink-drain-cli/)
under `swift-universal/.../tooling/spm/`. It uses FSEvents
(`CoalescingFSEventsWatcher`, adapted from openclaw's production wrapper)
for push-based notification — not polling — so the latency between a write
at `A/` and the corresponding hardlink appearing at `B/` is on the order of
the configured coalescing delay (default 120 ms), regardless of how often
the write happens.

CLI usage:

```bash
# Daemon mode — watches forever, exits cleanly on SIGINT/SIGTERM:
swift-hardlink-drain-cli \
  --source /path/to/legacy \
  --destination /path/to/canonical

# Single-shot mode — one sweep then exit (useful for cron / pre-shutdown):
swift-hardlink-drain-cli \
  --source /path/to/legacy \
  --destination /path/to/canonical \
  --once
```

Core logic in [`Drainer.swift`](../../../../../../../collectives/swift-universal/private/universal/domain/tooling/spm/swift-hardlink-drain-cli/sources/swift-hardlink-drain/Drainer.swift)
walks `source` and reconciles each regular file with its sibling at
`destination`:

The three branches matter:

- **`bino` empty** → file exists only in A/. Create a hardlink at B/ so both
  paths share the inode. From this moment on, both paths are equally real.
- **`aino == bino`** → already hardlinked. Skip silently.
- **`aino != bino`** → split-brain: both paths exist with different inodes.
  Pick the canonical one (newer mtime wins, on the assumption that whichever
  side received the most recent write is the live one), delete the loser,
  hardlink it to the winner. The cost is one lost write on the losing side,
  bounded by the loop interval.

## Constraints and edge cases

- **Same filesystem only.** Hardlinks cannot cross filesystem boundaries.
  Both paths must be on the same volume. APFS containers count as one
  filesystem even across firmlinks, so on a default macOS install
  `/Users/...` and `/private/var/...` are one filesystem.
- **Directories cannot be hardlinked.** Only regular files. The daemon
  must walk the tree and link file by file, recreating directory structure
  on the destination side as it goes.
- **Permissions and ownership are shared.** Because there is one inode,
  there is one set of mode bits, one owner, one mtime. If something `chmod`s
  via path A, both paths reflect the new mode immediately.
- **Symlinks inside the tree.** A symlink is a file too — hardlinking it
  duplicates the directory entry but keeps the same target text. Usually
  fine.
- **`rm` is path-local.** Removing one of the two paths doesn't delete the
  inode if the other path still references it. To actually free the bytes,
  every reference must be removed. This is what makes the final cleanup
  step trivial: when the live process exits, you `rm -rf A/` and the
  inodes survive as long as B/ still references them.
- **Atomicity.** `rename(2)` (`mv`) is atomic for single files within the
  same directory. `ln` is atomic too. The daemon can race with the live
  process for a sub-second window, but the worst case is "one `LINK`
  attempt fails this tick, succeeds next tick."

## The retire step

When the live process finally exits, finishing the migration is one
command:

```bash
rm -rf /path/to/legacy
```

That's it. The inodes are still referenced by `B/` and stay alive. There is
no symlink to clean up. There is no rsync state file. There is no cron job
to disable (kill the daemon, since it's pointless without the source). The
legacy path simply ceases to exist, and `B/` is the only home.

## Why this matters for hulk

Hulk's whole purpose is to **survive what it carries**. The founding-breach
insight (`founding-breach-2026-04-05.md`) names the principle: a hulk that
crashes its host is wreckage. That principle has a corollary the breach
didn't articulate but this migration revealed:

> **A hulk that crashes itself while restructuring its own home is
> wreckage too.**

You cannot move the home of a running hulk via the obvious approaches —
they all either drop writes or leak compatibility surfaces. Hardlinks
drain daemon is the only technique I've found that satisfies all four
constraints simultaneously:

1. **Zero data loss** — every write lands on the canonical inode, regardless
   of which path the writer used.
2. **Zero compat layer** — no symlink, no firmlink, no shim. After the
   retire step, there is no trace of the legacy path.
3. **Live operation** — the hulk keeps running. No restart, no degraded
   mode, no "please end your session before we proceed."
4. **Operator-legible** — `find . -type f` lists the same files at both
   paths until cleanup. Nothing is hidden behind a redirect that the
   operator might miss.

The technique generalizes. Any hulk implementation that needs to migrate
its substrate path during operation should reach for this pattern first.

## See also

- `founding-breach-2026-04-05.md` — why hulk exists, and why "survive what
  you carry" is the highest-priority clause in the contract.
- `MIGRATION-STATUS.md` (hulk root) — the in-flight status of the
  `harnesses/claude/` → `harnesses/hulk/` migration that produced this
  insight.
- macOS `stat(1)` flags `%i` (inode), `%m` (mtime), `%z` (size).
- POSIX `link(2)` — the syscall behind `ln`.
