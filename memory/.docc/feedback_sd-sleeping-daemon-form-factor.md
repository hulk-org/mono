---
name: sd-sleeping-daemon-form-factor
description: "`.sd` = sleeping daemon is a substrate form-factor suffix sibling to `.cli` / `.lib`. Names a queue-driven daemon that wakes on intent arrival, processes the queue, then sleeps until the next trigger — distinct from always-running daemons (`.daemon`) and one-shot CLIs (`.cli`). First canonical use: `savepoint@kura-org.sd` (package slug stays bare — form-factor carries the daemon semantic; pre-rename `savepointd@kura-org.sd` was operator-corrected for redundancy)."
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
| CLI (one-shot) | `.cli` | Invoke → exit | `harness@clia-org.cli`, `savepoint@kura-org.cli` |
| Library (in-process) | `.lib` | Linked into other executables | `savepoint-core@kura-org.lib` (if naming follows the harness-core precedent) |
| Sleeping daemon | **`.sd`** | Sleep → wake on trigger → process queue → sleep | **`savepoint@kura-org.sd`** |
| Always-running daemon | `.daemon` (when needed) | Boot → run forever → restart on failure | (substrate has few of these — most background work is sleeping-daemon shape) |

## Why sleeping-daemon ≠ always-running daemon

The substrate's economic model ([[feedback_substrate-cost-circle]]) penalizes always-on resources: an always-running daemon holds memory + CPU even when there's no work to do, and consumes operator-time-loss when it misbehaves silently. Sleeping daemons match the substrate's preference for:

- **Cost only when needed** — zero compute footprint between intents
- **Easier debugging** — process restart is the default state, not an exception
- **Visible activity** — each wake-cycle is a discrete event with clear start/end
- **Operator-controllable** — an operator can disable a sleeping daemon by removing its trigger; an always-on daemon needs explicit stop signals

`.sd` makes that economic discipline VISIBLE at the executable's name. Reading `savepoint@kura-org.sd` immediately tells the reader: "this daemon sleeps by default — don't expect it to be running unless something just triggered it."

## How a `.sd` daemon gets triggered

The substrate hasn't fully formalized the trigger mechanism, but the pattern (per savepointd v0.1):

- **Foreground synchronous invocation**: `savepointd --process-intent <path>` — the daemon executable wakes, processes one intent, exits. v0.1 mode; literally one-shot.
- **Future daemon mode** (v0.2+): a watch loop on a queue directory (filesystem events on `~/.local/share/savepoint/staging/`), HTTP/Unix-socket trigger, or a launchd/systemd activation event that wakes the daemon when intents land.

Either way, the substrate's contract is the same: the daemon's *resting state* is asleep; *active state* is queue-draining; it returns to sleep when the queue is empty.

## Naming composition

The full pattern is `<slug>@<org-slug>.<form-factor>` where:

- `<slug>` is the discipline BASE name (savepoint, fs-touch, ghost-feed) — **no `d` suffix**; the `.sd` form-factor already carries the daemon semantic
- `<org-slug>` is the owning collective (kura-org, clia-org, digikoma-org, ...)
- `<form-factor>` is one of `.cli` / `.lib` / `.sd` / `.daemon` / etc.

The form-factor disambiguates within a slug family. Same slug + different form-factor reads at a glance as "different shapes of the same discipline":

| Substrate primitive | Naming |
|---|---|
| Savepoint agent-side CLI (one-shot) | `savepoint@kura-org.cli` |
| Savepoint sleeping daemon | `savepoint@kura-org.sd` |
| Savepoint core library (if needed) | `savepoint-core@kura-org.lib` (or per the harness-core precedent if the lib supports a CLI specifically) |
| (Future) fs-touch sleeping daemon | `fs-touch@kura-org.sd` |
| (Future) ghost-feed sleeping daemon | `ghost-feed@<owner>-org.sd` |

**Drop the `d` suffix on the slug.** Operator-corrected 2026-05-26: *"savepoint should be moved too... savepoint@kura-org.sd"* — the form-factor IS the daemon marker; the `d` suffix is redundant once form-factor naming is the medium. Pre-rename `savepointd@kura-org.sd` was wrong (information duplicated); post-rename `savepoint@kura-org.sd` is right (form-factor does the work).

The Unix `<slug>d` convention (sshd, launchd, systemd) is preserved at the BINARY level if needed — the package can still ship a `savepointd` executable target (the binary readers/scripts invoke). The PACKAGE-level naming uses just `savepoint` because the package is one shape of the savepoint discipline, not a separate concern. Naming-as-medium ([[insights/medium-is-the-message-substrate-2026-05-26]]) — what the directory name communicates matters more than what 1980s Unix conventions communicate.

## How to apply

- When authoring a new background processor: ask "does this sleep by default and wake on trigger?" → if yes, use `.sd`
- When naming the PACKAGE: `<slug>@<org>.sd` (no `d` suffix on slug — form-factor carries the daemon semantic)
- When naming the BINARY/EXECUTABLE TARGET inside the package: the `<slug>d` Unix convention is fine if downstream readers/scripts/operators expect it (e.g., `~/.local/bin/savepointd` symlink); the BINARY can be `savepointd` while the PACKAGE is `savepoint@kura-org.sd`
- When documenting the daemon: explicitly call out its sleep/wake/queue contract in the daemon's `.docc/index.md` so future readers don't expect always-on semantics
- When configuring deployment: don't add it to launchd's `KeepAlive=true` set — sleeping daemons are activation-on-demand by design

## Pitfalls

- **Conflating `.sd` with an always-running daemon and adding "process supervision" infra.** The whole point of `.sd` is to avoid that infrastructure. If you find yourself adding always-on monitoring, the executable probably wants `.daemon`, not `.sd`.
- **Polling instead of triggering.** A `.sd` daemon that wakes every N seconds to check for work is a `.daemon` in disguise. Real sleeping daemons wake on inbound trigger (filesystem event, signal, IPC).
- **Doubling the daemon marker by putting `d` on the slug AND `.sd` form-factor.** Operator-corrected 2026-05-26 — pick one. Substrate convention: form-factor carries the semantic at the PACKAGE level (`savepoint@kura-org.sd`); the `<slug>d` Unix convention can survive at the BINARY level for operator recognition (`~/.local/bin/savepointd`). Don't double-mark the package directory.

## History

Operator-named 2026-05-26 during the savepoint kura-org migration directive: *"yes please move to kura-org. and remember that savepoint uses a .sd - sleeping daemon."* The doctrine landed mid-migration so the new home paths use the correct form-factor suffix from the start.

## Related

- [[feedback_substrate-dotted-form-factor-vocabulary]] — the broader form-factor naming convention (this is a new entry in that vocabulary)
- [[feedback_executable-naming-slug-at-org-dot-form]] — `<slug>@<org>.<form-factor>` discipline
- [[feedback_harness-canonical-home-clia-org]] — precedent for `<slug>@<org>.cli` naming
- [[feedback_substrate-cost-circle]] — economic model that motivates preferring `.sd` over `.daemon`
- [[feedback_savepoint-snapshot-at-emit-time]] — companion doctrine — savepoint is the canonical first `.sd` use
- [[insights/substrate-is-digikoma-factory-2026-05-23]] — sleeping-daemon shape composes with the digikoma-factory pattern (daemon wakes, spawns digikomas, sleeps)
