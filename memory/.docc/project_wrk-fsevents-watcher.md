---
name: WrkstrmFSEvent package
description: New wrkstrm-core package implementing WrkstrmFSEventWatcher (actor, AsyncStream) + its integration into collectives-by-wrkstrm
type: project
---

`WrkstrmFSEvent` package lives at `wrkstrm-core/private/cross/spm/WrkstrmFSEvent/`. macOS-only (CoreServices). Added to rismay-substrate.xcworkspace.

**Why:** Consolidates three competing FSEventStream wrappers (CliaDirFSEventWatcher, two CoalescingFSEventsWatcher copies) into a single canonical actor with `AsyncStream<Event>` interface and structured Task cancellation.

**How to apply:** All new watcher consumers `for await` over `watcher.events(for:latency:pathFilter:)`. No manual `stop()`. Filter by `pathFilter` to suppress irrelevant deep-tree events.

`collectives-by-wrkstrm` calls `substrateModel.startWatching()` in its root `.task`. Filter: depth ≤ 3 from substrate root OR path ends with `workspace.wrkstrm.json`. Deeper source-file edits are ignored.

Four design proposals now in `wrkstrm-core/.docc/`:
- `fsevents-watcher-design.md`
- `directory-traversal-and-event-architecture.md`
- `daemon-ipc-and-watcher-inventory.md`
- `async-progress-primitives.md` — canonical contract: all wrkstrm-core primitives expose AsyncStream with typed progress + structured cancellation.
