---
name: sd-sleeping-daemon-form-factor
description: "`.sd` = sleeping daemon is a substrate form-factor suffix sibling to `.cli` / `.lib`. Names a queue-driven daemon that wakes on intent arrival, processes the queue, then sleeps until the next trigger — distinct from always-running daemons (`.daemon`) and one-shot CLIs (`.cli`). First canonical use: `savepoint.sd` at `kura-org/private/universal/tools/savepoint.sd/` (package slug stays bare — form-factor carries the daemon semantic; AND no `@<org>` infix because the parent dir already names the org. Pre-rename names `savepointd@kura-org.sd` then `savepoint@kura-org.sd` were operator-corrected in two passes for redundancy)."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**`.sd` = sleeping daemon** is a substrate executable form-factor suffix. Operator-named 2026-05-26: *"savepoint uses a .sd - sleeping daemon."*

## What sleeping-daemon names

A **sleeping daemon** is a queue-driven background executable that:

1. **Sleeps by default** — no always-running process holding sockets or polling
2. **Wakes on intent arrival** — triggered by an inbound CommitRequestModel / IntentEnvelope / equivalent typed record landing in its queue
3. **Processes the queue** — drains pending work, spawning workers (digikomas, subprocesses, etc.) as needed
4. **Sleeps again** — releases resources and returns to dormant state until the next trigger

Distinct from sibling form-factors:

| Form-factor | Suffix | Lifecycle | Canonical example |
|---|---|---|---|
| CLI (one-shot) | `.cli` | Invoke → exit | `harness@clia-org.cli` (shared spm/), `savepoint.cli` (kura-org/tools/) |
| Library (in-process) | `.lib` | Linked into other executables | `savepoint-core@kura-org.lib` (if naming follows the harness-core precedent) |
| Sleeping daemon | **`.sd`** | Sleep → wake on trigger → process queue → sleep | **`savepoint.sd`** (at `kura-org/tools/`) |
| Always-running daemon | `.daemon` (when needed) | Boot → run forever → restart on failure | (substrate has few of these — most background work is sleeping-daemon shape) |

## Why sleeping-daemon ≠ always-running daemon

The substrate's economic model ([[feedback_substrate-cost-circle]]) penalizes always-on resources: an always-running daemon holds memory + CPU even when there's no work to do, and consumes operator-time-loss when it misbehaves silently. Sleeping daemons match the substrate's preference for:

- **Cost only when needed** — zero compute footprint between intents
- **Easier debugging** — process restart is the default state, not an exception
- **Visible activity** — each wake-cycle is a discrete event with clear start/end
- **Operator-controllable** — an operator can disable a sleeping daemon by removing its trigger; an always-on daemon needs explicit stop signals

`.sd` makes that economic discipline VISIBLE at the executable's name. Reading `kura-org/.../tools/savepoint.sd/` immediately tells the reader: "this daemon sleeps by default — don't expect it to be running unless something just triggered it."

## How a `.sd` daemon gets triggered

The substrate hasn't fully formalized the trigger mechanism, but the pattern (per savepointd v0.1):

- **Foreground synchronous invocation**: `savepointd --process-intent <path>` — the daemon executable wakes, processes one intent, exits. v0.1 mode; literally one-shot.
- **Future daemon mode** (v0.2+): a watch loop on a queue directory (filesystem events on `~/.local/share/savepoint/staging/`), HTTP/Unix-socket trigger, or a launchd/systemd activation event that wakes the daemon when intents land.

Either way, the substrate's contract is the same: the daemon's *resting state* is asleep; *active state* is queue-draining; it returns to sleep when the queue is empty.

## Naming composition

The package name depends on its **location relative to its owner home**:

- **Inside the owner's tools/ dir** (e.g. `kura-org/private/universal/tools/`): `<slug>.<form-factor>` — no `@<org>` infix because the parent directory already names the org. Example: `kura-org/private/universal/tools/savepoint.sd/`.
- **Outside the owner's tools/ dir** (e.g. shared `spm/` dirs that can mix multiple orgs' packages): `<slug>@<org>.<form-factor>` — the `@<org>` infix is the *fallback* signal when home doesn't tell the reader. Example: `clia-org/private/universal/domain/tooling/spm/harness@clia-org.cli/`.

The decision is **let the parent dir do the work when it can**. If the home already says "kura-org," don't repeat it in the package name.

Form components:

- `<slug>` is the discipline BASE name (savepoint, fs-touch, ghost-feed) — **no `d` suffix**; the form-factor already carries the daemon semantic
- `<form-factor>` is one of `.cli` / `.lib` / `.sd` / `.daemon` / `.app` / etc.
- `@<org>` is conditional (see decision above)

Same slug + different form-factor reads at a glance as "different shapes of the same discipline":

| Substrate primitive | Naming | Why |
|---|---|---|
| Savepoint agent-side CLI (one-shot) | `kura-org/private/universal/tools/savepoint.cli/` | inside org tools/, no @org needed |
| Savepoint sleeping daemon | `kura-org/private/universal/tools/savepoint.sd/` | inside org tools/, no @org needed |
| Savepoint operator app (macOS) | `kura-org/private/universal/tools/savepoint.app/` | inside org tools/, no @org needed |
| Savepoint core library (if needed) | `kura-org/private/universal/spm/savepoint-core/` | kura-org's spm/ dir, no @org needed |
| Harness CLI in clia-org's shared spm/ | `clia-org/.../spm/harness@clia-org.cli/` | shared spm/ context — @clia-org disambiguates |
| (Future) fs-touch sleeping daemon | `<owner-home>/tools/fs-touch.sd/` (org from parent) | inside owner tools/, no @org |
| (Future) ghost-feed sleeping daemon | `<owner-home>/tools/ghost-feed.sd/` (org from parent) | inside owner tools/, no @org |

**Two operator corrections (2026-05-26)** built up the doctrine in one session:

1. *"savepoint should be moved too... savepoint@kura-org.sd"* — first correction: drop the `d` suffix on slug (form-factor carries daemon semantic; `savepointd@kura-org.sd` was redundant).
2. *"this should be `/Users/sonoma/mono/.../tools/savepoint.sd` `.../tools/savepoint.cli`"* — second correction: drop the `@kura-org` infix too (parent tools/ dir already names the org; `savepoint@kura-org.sd` was still redundant). Final form is `savepoint.sd`.

Each correction removed a redundant signal until only the load-bearing parts remained. Naming-as-medium ([[insights/medium-is-the-message-substrate-2026-05-26]]) — the directory should communicate what isn't already communicated by its container.

The Unix `<slug>d` convention (sshd, launchd, systemd) is preserved at the BINARY level if needed — the package can still ship a `savepointd` executable target (the binary readers/scripts invoke). The PACKAGE-level naming uses just `savepoint` because the package is one shape of the savepoint discipline, not a separate concern.

## How to apply

- When authoring a new background processor: ask "does this sleep by default and wake on trigger?" → if yes, use `.sd`
- When naming the PACKAGE: `<slug>.sd` if inside the owner's tools/ dir (parent home names org); `<slug>@<org>.sd` if in a shared/generic spm dir. NEVER `<slug>d.sd` (form-factor carries the daemon semantic; `d` suffix is redundant)
- When naming the BINARY/EXECUTABLE TARGET inside the package: the `<slug>d` Unix convention is fine if downstream readers/scripts/operators expect it (e.g., `~/.local/bin/savepointd` symlink); the BINARY can be `savepointd` while the PACKAGE is `savepoint.sd`
- When documenting the daemon: explicitly call out its sleep/wake/queue contract in the daemon's `.docc/index.md` so future readers don't expect always-on semantics
- When configuring deployment: don't add it to launchd's `KeepAlive=true` set — sleeping daemons are activation-on-demand by design

## Pitfalls

- **Conflating `.sd` with an always-running daemon and adding "process supervision" infra.** The whole point of `.sd` is to avoid that infrastructure. If you find yourself adding always-on monitoring, the executable probably wants `.daemon`, not `.sd`.
- **Polling instead of triggering.** A `.sd` daemon that wakes every N seconds to check for work is a `.daemon` in disguise. Real sleeping daemons wake on inbound trigger (filesystem event, signal, IPC).
- **Doubling the daemon marker by putting `d` on the slug AND `.sd` form-factor.** Operator-corrected 2026-05-26 — pick one. Substrate convention: form-factor carries the semantic at the PACKAGE level (`savepoint.sd`); the `<slug>d` Unix convention can survive at the BINARY level for operator recognition (`~/.local/bin/savepointd`). Don't double-mark the package directory.
- **Repeating the `@<org>` infix when the parent dir already names the org.** Operator-corrected 2026-05-26 (second refinement in the same session) — `kura-org/private/universal/tools/savepoint@kura-org.sd/` doubles "kura-org" because the parent path already says "kura-org/." The substrate-honest form is just `savepoint.sd/` under that home. The `@<org>` infix is for SHARED dirs (e.g. clia-org's deep-nested spm/ dir where multiple orgs' packages might coexist), not for an org's own tools/ dir.

## History

Operator-named 2026-05-26 during the savepoint kura-org migration directive: *"yes please move to kura-org. and remember that savepoint uses a .sd - sleeping daemon."* The doctrine landed mid-migration so the new home paths use the correct form-factor suffix from the start.

## Related

- [[feedback_substrate-dotted-form-factor-vocabulary]] — the broader form-factor naming convention (this is a new entry in that vocabulary)
- [[feedback_executable-naming-slug-at-org-dot-form]] — `<slug>@<org>.<form-factor>` discipline
- [[feedback_harness-canonical-home-clia-org]] — precedent for `<slug>@<org>.cli` naming
- [[feedback_substrate-cost-circle]] — economic model that motivates preferring `.sd` over `.daemon`
- [[feedback_savepoint-snapshot-at-emit-time]] — companion doctrine — savepoint is the canonical first `.sd` use
- [[insights/substrate-is-digikoma-factory-2026-05-23]] — sleeping-daemon shape composes with the digikoma-factory pattern (daemon wakes, spawns digikomas, sleeps)
