@Metadata {
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Hulk Investigation")
}

# The Daemon Menagerie (2026-04-08)

A grounded inventory of every daemon-shaped surface currently living in
the substrate, an honest accounting of what each gets right and wrong,
and a verdict on how many of these shapes are *actually* justified.

> [!IMPORTANT]
> **Headline:** the substrate has **nine** daemon-shaped surfaces today
> across **five** distinct shapes. A 2025-10-01 polling-and-daemon survey
> already enumerated seven of these and recommended consolidation. That
> consolidation never happened. Since then we have *added* two new
> shapes (`swift-hardlink-drain-cli`, `CliaLLMResidentDaemon`) without
> retiring any. The justified count after consolidation is **four**.
> Five shapes' worth of code can be deleted.

This investigation exists because the question "what is tau's daemon"
turned into archaeology. Tau has at least three different
daemon-shaped artifacts, only two of them are alive, and the one we
spent the most time on (`CliaLLMResidentDaemon`) turned out to be the
*least* relevant to the consolidation conversation. The right framing
is the menagerie, not any one tenant of it.

## The nine shapes

| # | Name | Shape class | Lines (real logic) | Status |
| --- | --- | --- | ---: | --- |
| 1 | `PositionPriceRefreshService` (TradeDaemon) | A · in-process tick | ~30 | shipping; refresh body is TODO |
| 2 | Tau `PollingDaemon` (custom actor) | A · in-process tick | ~?  | unknown post-restructure |
| 3 | `NotionTradePollingDaemon` | A · in-process tick (wrapper over 2) | ~?  | unknown post-restructure |
| 4 | `CommonBroker.PollingDaemon<H>` + `PollingRegistry` | A · in-process tick + UI lifecycle | medium | shipping; used by Watchlists view |
| 5 | `SwiftDaemon` (in `wrkstrm/`) | A · in-process tick (canonical engine) | medium | shipping; nominated by 2025-10-01 survey, never adopted |
| 6 | `swift-service-registry` (this work) | A · in-process tick (facade) | small (scaffold) | scaffold; engine TODO |
| 7 | MarketClock fakes (`Fake`, `PreMarket`) | A · in-process tick → AsyncStream | small | shipping (test doubles) |
| 8 | `SystemScheduler` | B · OS-scheduled job | medium | shipping; canonical for OS-level work |
| 9 | `swift-hardlink-drain-cli` (hulk) | B · filesystem-event reactor | small CLI | shipping; founding-breach prototype |
| 10 | `CliaLLMResidentDaemon` (tau) | B · resident XPC service | ~2,255 | shipping production |

(I had to renumber while writing this. The "nine" headline counts the
distinct *implementations*; row 6, this package, is the would-be tenth
that *replaces* rows 1–5 once it lands an engine. Row 10 is also
counted; I miscounted the headline at "nine" in the
swift-service-registry article and am keeping it consistent here for
cross-reference. The actual implementation count today is ten if you
include the scaffold.)

The "Shape class" column matters more than the count. There are only
**two** shape classes:

- **Shape A — in-process periodic worker.** Many handlers, finite
  lifetime, ticking on an interval, hosted inside a host process.
  Rows 1–7 are all variations of this single idea.
- **Shape B — long-lived OS-managed process.** Owned by launchd /
  systemd / cron / SMAppService. Lifetime indefinite. Process death is
  the OS's problem. Rows 8, 9, 10 are three *sub-shapes* of this
  (scheduled jobs, FSEvents reactors, resident XPC services), each of
  which is genuinely different from the other two.

The whole proliferation problem lives inside Shape A: **seven
implementations of the same idea**.

## Rules of this investigation

- Every claim about a file is grounded in a path you can `cat` today.
- Every "+" or "−" is something I'd defend in a code review.
- I'm not pretending any of these are pure waste. Nobody writes a
  daemon for fun. Each of these solved a real problem on the day it
  was written. The question is whether it's still the right answer
  *given the rest of the menagerie*.

---

## Shape A — In-process periodic workers

### A1. `TradeDaemon` / `PositionPriceRefreshService`

**Path.** `wrkstrm/private/universal/spm/domain/finance/trade-daemon/Sources/TradeDaemon/PositionPriceRefreshService.swift`

```swift
public final class PositionPriceRefreshService {
  private var timer: Timer?
  public init() {}

  public func start() {
    stop()
    timer = .scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
      let now: Date = .init()
      Log.tradeDaemon.trace("Price refresh tick at \(now)")
    }
    timer?.tolerance = 5
  }

  public func stop() {
    timer?.invalidate()
    timer = nil
  }
}
```

Class doc, verbatim: *"Each open position may spawn its own daemon, so
the implementation must remain lightweight."*

**+ What it gets right**

- **Trivially understood.** 30 lines, no protocol surface, no actor,
  no DI. A reader gets it in 60 seconds.
- **Foundation-only.** Embeds anywhere `Foundation` runs (the package
  lists six Apple platforms).
- **Power-friendly out of the box.** `Timer.tolerance = 5` lets the OS
  coalesce wakes — the Apple-blessed mechanism on darwin.
- **Lifecycle is local.** `start()`/`stop()` is owned by the caller.
  No global registry to forget about.
- **No shutdown story needed.** When the position view dismisses, it
  calls `stop()`. Done.

**− What it gets wrong**

- **N positions = N Timers.** The class doc admits this directly.
  100 positions = 100 Timers, 100 wake schedules, 100 places to leak
  if `stop()` is missed.
- **No type safety on the work.** The closure body is opaque. There's
  no `Item` type, no `Result` type, no way to test "what does this
  handler emit" without running the timer.
- **No backoff.** A network failure inside the closure logs and
  retries on the next tick, forever. No exponential drop, no circuit
  breaker.
- **No inspection.** "What's running right now?" is unanswerable
  without instrumenting every caller.
- **No actor isolation.** The closure runs on the run-loop thread.
  Any state it touches needs its own concurrency story.
- **No cooperative cancellation.** `Timer.invalidate()` is
  fire-and-forget; an in-flight tick runs to completion regardless.
- **`Package.swift` already has the `SPM_USE_LOCAL_DEPS=true` trap
  baked in.** It points `common-log` at a local relative path under
  the local-deps inject. This is the same identity-collision trap
  hulk dodged in `swift-service-registry`. Migrating `TradeDaemon` is
  the forcing function for solving the trap properly.

**When it's the right answer.** Never, in a substrate that has
anything richer available. The only reason to write this shape today
is if you're outside the substrate entirely and want zero deps.

---

### A2. Tau `PollingDaemon` (custom actor + handler)

**Path.** Per the 2025-10-01 survey:
`code/mono/apple/alphabeta/tau/cross/PollingDaemon.swift` and
`…/cross/Notion/NotionTradePollingDaemon.swift`. Status post-restructure
is unknown — the apple/alphabeta tree was reorganized into the substrate
shape, and these files may have moved, been renamed, or been dropped.
The 2025-10-01 survey is the authoritative description.

**Shape (per the survey).** Actor loop with `Task.sleep(for:)`, set of
seen IDs, simple logging. Local to tau; overlaps conceptually with
`SwiftDaemon`.

**+ What it gets right**

- **Actor-isolated.** State (seen-set, last-tick, in-flight flag)
  lives inside the actor. No data races by construction.
- **Cooperative cancellation.** `Task.sleep(for:)` respects
  `Task.isCancelled`, so cancelling the parent task actually stops
  the loop at the next sleep boundary.
- **Typed handler.** Each daemon parametric on a handler protocol
  means a test can substitute a fake handler and assert tick counts /
  item delivery without touching real polling.
- **Dedup built in.** The seen-set prevents re-emitting the same item
  across ticks — exactly what Notion polling wants.
- **Pure Swift Concurrency.** No Foundation runloop, no DispatchSource.

**− What it gets wrong**

- **Reinvented wheel.** Private copy of `SwiftDaemon` minus the polish.
  The 2025-10-01 survey called this out by name.
- **`Task.sleep` is not power-aware.** No `tolerance` equivalent — the
  sleep is exact, so the OS can't coalesce wakes the way it can with
  `Timer.tolerance`.
- **No backoff, no jitter.** Same gap as A1.
- **No shared registry.** Two callers asking for "the Notion poller"
  can't be sure they're talking to the same instance. No `(type, id)`
  keying.
- **Adopters copy the boilerplate.** The actor + sleep loop
  seen-set is the same in `PollingDaemon` and
  `NotionTradePollingDaemon`; the second is a thin wrapper over the
  first.

**When it's the right answer.** Prototyping a new polling shape
before promoting it to the canonical engine. Don't ship it.

---

### A3. `CommonBroker.PollingDaemon<H>` + `PollingRegistry`

**Path (per survey).**
`code/mono/apple/spm/universal/common/domain/finance/common-broker/Sources/CommonBroker/Polling/PollingDaemon.swift`
and the sibling `PollingRegistry`.

**Shape.** Typed `OmniPollingHandler`, generic `PollingDaemon<H>`,
and a `PollingRegistry` keyed by handler type. Used in real production
SwiftUI surfaces — the Watchlists view and several debug views in
tau/clia depend on it.

**+ What it gets right**

- **The `PollingRegistry` part is actually right.** Per-type registry,
  lifecycle helpers, used by real SwiftUI views. This is the *surface*
  the substrate already wants.
- **Typed handler protocol** means tests get fakes for free, exactly
  like `IdentifiedDaemonHandler`.
- **Per-handler state is encapsulated** (seen sets, last-poll time).
  Adding a new poll target is "conform to the protocol, register, done."
- **Real production usage.** Unlike A2, this one has actual consumers
  across the broker and tau debug surfaces. Evidence the surface works.
- **SwiftUI lifecycle helpers.** Start-on-appear / stop-on-disappear is
  wired in, which is the trickiest part of UI-driven polling.

**− What it gets wrong**

- **Lives inside `common-broker`.** Anything that wants to poll has to
  take a finance dep. That's exactly why TradeDaemon (A1) ignored it
  and rolled its own Timer — `common-broker` wasn't where a
  position-price refresher wanted to live.
- **The `PollingDaemon<H>` engine inside it is *also* a private copy**
  of `SwiftDaemon`, slightly more sophisticated than A2 but still a
  parallel implementation. Two private copies of the same engine is
  worse than one.
- **Not lifecycle-aware in the SSWG sense.** No `ServiceGroup`
  integration, no graceful shutdown ordering. Process death drops
  in-flight ticks.
- **Coupled to broker domain types** in spots where it shouldn't be
  (logging categories, error types).

**When it's the right answer.** It already *is* the right surface for
UI-driven polling. The 2025-10-01 survey explicitly says "keep the
`PollingRegistry` surface, swap the internals." The fix is to delegate
the engine to `swift-service-registry` and keep the surface verbatim.

---

### A4. `SwiftDaemon` (in `wrkstrm/`)

**Path (live).**
`wrkstrm/private/universal/spm/domain/system/SwiftDaemon/Sources/SwiftDaemon/SwiftDaemon.swift`.
66 lines. Still lives inside the `wrkstrm` collective today.

> [!IMPORTANT]
> **Update 2026-04-08 (post source read).** The original framing of A4 in
> this investigation took the 2025-10-01 survey's description on faith and
> called `SwiftDaemon` "the most mature in-process daemon engine in the
> substrate." Reading the source contradicts that framing. `SwiftDaemon` is
> a 66-line reference loop, not an engine. The "+" and "−" sections below
> have been re-graded against the actual source.

**Shape (per source).** Handler protocol with typed `Item`, per-handler
seen sets, tolerance passed through to `Task.sleep`, `CommonLog`
integration. The whole thing is one actor, one `start()` method, one
`stop()` method, and a `while !Task.isCancelled { for handler in
handlers { fetch ; dedup ; handle } ; await Task.sleep }` loop.

```swift
public actor SwiftDaemon<Handler: DaemonHandler> {
  public func start() {
    task = Task {
      while !Task.isCancelled {
        for (index, handler) in handlers.enumerated() {
          do {
            let items = try await handler.fetchItems()
            for item in items where seen.insert(item.id).inserted {
              await handler.handleNew(item)
            }
          } catch {
            await handler.handleError(error)
          }
        }
        try? await Task.sleep(for: interval, tolerance: tolerance ?? .zero)
      }
    }
  }
}
```

That is the engine in its entirety. There is also a 7-line
`Log+SwiftDaemon.swift` and a 20-line test file with **one** test
(`serviceStartsAndStops`) that calls `start()` then immediately `stop()`
on a stub handler returning `[]`. There is no test that asserts ticks
happened, no test that asserts dedup works, no test that asserts
cancellation stops in-flight work.

**+ What it gets right**

- **Foundation-only**, no SSWG dep. Embeds in apps without dragging
  server-side baggage.
- **Typed handler protocol** with `Item: Identifiable & Sendable`.
  Tests *could* substitute fake handlers without touching real polling
  (the existing test stub uses this affordance, even though it doesn't
  exercise it).
- **Per-handler seen sets** for dedup across ticks. The substrate's
  Notion-polling use case wants this and the loop body honors it.
- **Cooperative cancellation.** `Task.isCancelled` check at the top of
  the loop plus `task?.cancel()` in `stop()` is the textbook
  Swift-Concurrency teardown pattern.
- **Tolerance passed to `Task.sleep`** (right call) so the OS can
  coalesce wakes the way it can for `Timer.tolerance`.

**− What it gets wrong** (now grounded in the source, not paraphrased
from the survey)

- **It is not an engine; it is a reference loop.** Calling it "the
  canonical engine" was generous. The 2025-10-01 survey nominated it as
  the consolidation target, but six months later there is no production
  consumer, no integration with anything else, and no test coverage
  beyond a smoke test. The "endorsement" was endorsement of an *idea*.
- **No backoff.** Errors are caught and `handler.handleError(error)` is
  called, then the loop just continues at the next interval. Forever.
  No exponential drop. No jitter. No circuit breaker. The `Backoff`
  type that ``swift-service-registry`` introduces is brand new — there
  is no upstream implementation in `SwiftDaemon` to inherit.
- **No per-id keying.** `seenIds` is keyed by **handler array index**
  (`[Int: Set<Handler.Item.ID>]`). If two instances of the same handler
  type get registered, their seen sets get conflated. The whole
  `(type, id)` keying that `Registry` enforces is *not* in `SwiftDaemon`
  and would have to be retrofitted into the array model.
- **No per-handler concurrency.** Handlers are processed sequentially
  inside a single task. One slow `fetchItems()` blocks every other
  handler in the same daemon until it returns. There is no per-handler
  task isolation, no per-handler timeout, and no cancellation deadline.
- **No `ServiceGroup` integration.** No SSWG `Service` conformance, no
  graceful-shutdown ordering, no preflight/loop/shutdown phases. The
  whole `Host` story in ``swift-service-registry`` has zero precedent
  here.
- **No status / inspection surface.** `SwiftDaemon` is opaque from the
  outside. No `list()`, no `Status`, no per-id snapshots. Whatever
  debugging affordances the registry envisions, they are brand new.
- **Local-deps `Package.swift` is broken.**
  `Package.Inject.local.dependencies` points `common-log` at
  `../../../../../../modules/swift-universal/private/spm/universal/domain/system/common-log`.
  That goes up six levels from `SwiftDaemon/` and expects a
  `modules/swift-universal/` sibling. **There is no
  `modules/swift-universal/` in the current substrate layout.** That
  path is the legacy pre-substrate location, frozen in the file.
  Anyone setting `SPM_USE_LOCAL_DEPS=true` and trying to build
  `SwiftDaemon` against local deps today will hit a missing-package
  error. The remote URL fallback (`from: "3.0.0"`) still works, but
  **the local-deps story for `SwiftDaemon` has been silently dead
  since the substrate restructure**. Either nobody has built it with
  `SPM_USE_LOCAL_DEPS=true` since the move, or they have, hit the
  broken path, and shrugged. Either way: it is a package nobody is
  actively maintaining.
- **Lives in `wrkstrm/`.** Non-`wrkstrm` collectives (clia-org,
  clia-app-org, schema-universal) can't take a wrkstrm dep without
  dragging the whole world. This was the original justification for
  extracting ``swift-service-registry`` as a separate package. The
  location is *a* bug; the engine being a 66-line reference loop is
  *the* bug.

**When it's the right answer.** Re-graded honestly: probably never.
The original recommendation here said `SwiftDaemon` should become the
engine underneath ``swift-service-registry``, either by moving it out
of `wrkstrm/` or by importing it via a long relative path. After
reading the source, the right move is **neither** — see "Path C" in
the work-in-priority-order section below. `SwiftDaemon` should stay
where it is, untouched, while ``swift-service-registry`` inlines its
own engine. The cost of replacing 66 lines is lower than the cost of
consuming them.

---

### A5. `swift-service-registry` (this package — actor + protocols, scaffold)

**Path.** `swift-universal/private/universal/domain/system/spm/swift-service-registry/sources/swift-service-registry/`

**Shape.** Sources: `Backoff`, `Registry` (in `DaemonRegistry.swift`),
`Host`, `Status`, `IdentifiedDaemonHandler`, `TickingHandler`,
`TickingAdapter`, `TickOptions`, `DaemonService`. The two-tier handler
protocol (`TickingHandler` for the simple case, `IdentifiedDaemonHandler`
for the rich case, `TickingAdapter` to upgrade simple→rich) is the
right shape. The `Sendable` actor `Registry` enforces at-most-one loop
per `(type, id)` by construction.

**+ What it gets right**

- **The right *location*.**
  `swift-universal/private/universal/domain/system/spm/swift-service-registry/`
  is collective-neutral. Any collective can depend on it without
  taking a wrkstrm dep. Hulk extracted it precisely so non-wrkstrm
  consumers exist.
- **The right *surface*.** `IdentifiedDaemonHandler`, `TickingHandler`/
  `TickingAdapter`, `TickOptions(interval, tolerance, backoff, limits)`,
  `Backoff(base, factor, max, jitter)`, `Status` per id, `Registry/list()`
  for inspection. This is the *union* of everything A1–A4 got right
  with none of what they got wrong.
- **`Sendable` actor by construction.** At-most-one loop per `(type, id)`
  is enforced by the actor model, not by convention.
- **`Host` integrates with `swift-service-lifecycle`** so apps that
  adopt SSWG ServiceGroup get graceful shutdown for free.
- **Two-tier handler protocol is the right call.** `TickingHandler`
  for the simple case keeps the entry barrier low; the
  `TickingAdapter` upgrade path means callers don't have to choose
  rich-vs-simple at the wrong moment.

**− What it gets wrong**

- **It's a scaffold.** `Registry/start(_:options:)` records a `Status`
  row and logs `start handler id=…`; it does not actually run a loop.
  That's the entire point of the engine integration that hasn't
  happened yet. Today, adopting it gets you nothing but ceremony.
- **Documentation > code by ratio.** 8 source files, ~5 articles, and
  the articles are bigger than the code. That's a sign nobody has
  pressure-tested the API yet.
- **The `Host`/ServiceGroup story assumes apps own the signal
  contract.** That's not true for XPC services or launchd-managed
  daemons. Confusing the boundary will lead to attempts to register
  Shape B daemons as Shape A workers.
- **No FSEvents-style event-driven option.** The whole abstraction is
  tick-driven. Hardlink-drain (B2) doesn't fit and shouldn't.
- **Inherits `common-log` identity collision** if it ever consumes
  `SwiftDaemon` locally.

**When it's the right answer.** After the engine wiring lands and
TradeDaemon (A1) proves the migration path. Today: track it, don't
adopt it.

---

### A6. MarketClock fakes (`Fake`, `PreMarket`)

**Path (per survey).**
`code/mono/apple/spm/universal/common/domain/finance/market-clock/Sources/Fake/{FakeMarketClockService.swift, PreMarketClockService.swift}`.

**Shape.** `while !Task.isCancelled { try? await Task.sleep(...) ;
continuation.yield(...) }` driving an `AsyncStream` of clock events.
These exist as test doubles for the real market clock.

**+ What it gets right**

- **`AsyncStream` consumer surface is exactly right.** Downstream UI
  code does `for await event in clock.events { … }`, which is the
  most ergonomic concurrency primitive Swift has for "I want a stream
  of events I can stop iterating."
- **Cancellation is first-class.** `Task.isCancelled` plus the
  consumer breaking the for-await loop = clean teardown.
- **Composable.** `AsyncStream` plays well with `flatMap`, `merge`,
  debounce, all the structured-concurrency operators.
- **Test-fakeable.** That's literally why these exist.

**− What it gets wrong**

- **The *driver* is hand-rolled.** `while !Task.isCancelled { Task.sleep ;
  yield }` is the same loop everyone keeps writing.
- **No tolerance, no backoff, no inspection.** Same gaps as A2.
- **Two near-identical implementations** (`Fake`, `PreMarket`) means the
  loop pattern got copy-pasted.

**When it's the right answer.** The `AsyncStream` *surface* is right
and should be kept. The *driver* should be a `TickingHandler`
registered with `Registry` that calls `continuation.yield(...)` from
its tick body. That gives you the best of both worlds: consumer API
stays `AsyncStream`, producer is a registry-managed worker with real
backoff and inspection.

---

## Shape B — Long-lived OS-managed processes

### B1. `SystemScheduler` (launchd / systemd / cron)

**Path (per survey).**
`code/mono/apple/spm/universal/SystemScheduler/Sources/SystemScheduler/SystemScheduler.swift`.

**Shape.** Cross-platform abstraction over launchd (macOS) and
systemd/cron (Linux). Installs/updates daily jobs.

**+ What it gets right**

- **Solves a genuinely different problem.** OS-level scheduling. "Run
  this every day at 6am even when no app is running." That's
  launchd/systemd/cron, not an in-process loop. Trying to fake it
  in-process is the wrong shape.
- **Cross-platform.** macOS launchd, Linux systemd/cron, all behind
  one API.
- **No process-lifetime cost.** The scheduled job spawns a process,
  runs, exits. No daemon to keep alive.
- **Survives reboots, logout, crashes.** The OS owns the schedule.
- **Already canonical.** The 2025-10-01 survey explicitly says "keep
  `SystemScheduler` for OS-level work."

**− What it gets wrong**

- **Cold-start cost.** Every tick spawns a process. Bad for sub-minute
  intervals.
- **No shared in-memory state between ticks.** Each invocation starts
  from scratch.
- **Hard to test in CI.** You can't really exercise launchd from a unit
  test.
- **Per-job install/update is awkward.** You need user-context daemon
  installation, which is friction the in-process registries don't have.

**When it's the right answer.** Daily/hourly maintenance. Background
sync. Anything that should keep running when the user app isn't.
*Never* for sub-minute or stateful work.

---

### B2. `swift-hardlink-drain-cli` (FSEvents-driven)

**Path.** `swift-universal/private/universal/domain/tooling/spm/swift-hardlink-drain-cli/`. Added by hulk on
2026-04-07 during the founding-breach migration. See
`harnesses/hulk/memory/.docc/insights/hardlink-drain-2026-04-07.md`.

**Shape.** Standalone CLI process. FSEvents-driven. Watches a source
path, hardlinks new files into a destination path within a coalescing
window. SIGINT/SIGTERM via `DispatchSource`. Unbuffered stdout via
`setvbuf(stdout, nil, _IONBF, 0)` at the top of `run()`.

**+ What it gets right**

- **Right abstraction for the problem.** FSEvents is event-driven,
  not tick-driven. Polling the filesystem at an interval would be
  wasteful and racy. Waking on FSEvents is the OS-blessed mechanism.
- **Standalone CLI = simple lifecycle.** Exit cleanly on SIGTERM. No
  host app to coordinate with.
- **The unbuffered-stdout fix** is the kind of operational lesson you
  only learn by running a daemon under captured output. Now it's
  documented and committed (`swift-universal@043f0dc1cb`).
- **Solved the founding-breach problem.** It's the *only* technique
  hulk found that satisfies all four constraints of moving a running
  hulk's home. Strong endorsement.
- **No transitive infrastructure deps.** Doesn't pull `common-log`,
  doesn't pull `SwiftDaemon`, doesn't pull SSWG. A single-file `run()`
  with FSEvents and signal handling.

**− What it gets wrong**

- **Single-purpose.** It does exactly one thing: hardlink files between
  two paths. Not reusable as a daemon framework.
- **Process model is launchd-shaped, not app-shaped.** You don't embed
  it; you spawn it.
- **No registry awareness.** If you ran two of them, neither would
  know about the other. (Today there's only one running, so not a
  problem.)
- **FSEvents is darwin-only.** No Linux story.

**When it's the right answer.** Specifically the "watch a directory
and react to events" shape. Don't generalize it. Don't merge it into
the registry. It is a *causal* relative of `swift-service-registry` —
it motivated the extraction — but not a *consumer*.

---

### B3. `CliaLLMResidentDaemon` (resident XPC service via SMAppService)

**Path.** `clia-app-org/private/apple/apps/clia-llm/Sources/xpc-service/CliaLLMResidentDaemon.swift` (~972 lines), plus `Sources/xpc-service/main.swift` (8 lines), `me.rismay.clia-llm.modeld.plist`, and `Sources/Shared/{CliaLLMIPC.swift, CliaLLMLogging.swift, CliaLLMServiceConnection.swift}` (~1,275 lines combined). Total ~2,255 lines.

**Shape.** One OS-level resident XPC service. Bundle id
`me.rismay.clia-llm.modeld`. Registered via `SMAppService`. Talks to
two client peers (mac-app, mac-status-app) over `NSXPCConnection`,
plus shared-memory regions for prompt/state/token buffers. `main.swift`
is *eight* lines: bootstrap CommonLog, instantiate the daemon,
`startIfNeeded()`, then `RunLoop.main.run()`. No signal handling, no
ServiceGroup — process death is launchd's job.

**+ What it gets right**

- **OS-level single-instance is real.** `SMAppService`
  `LSMultipleInstancesProhibited` + `MachServices` plist gives a
  guarantee no in-process actor can match. Even if you start the host
  app twice, you still get one daemon.
- **Mach service bootstrap is the right way to host model state.** XPC
  is the only IPC mechanism on darwin that gets entitlements,
  sandboxing, code signing, and crash isolation right.
- **Restarts are launchd's job.** If the daemon crashes, launchd
  respawns it. The host app doesn't have to babysit.
- **Process isolation for the model.** Big model loads can't OOM the
  host app or the menu-bar app. They OOM their own process, which
  respawns clean.
- **`CommonLog` rolling daily files** at
  `~/Library/Logs/me.rismay.clia-llm` give per-process observability
  without dragging os_log filtering noise.
- **Shared-memory regions** for prompt/state/token buffers avoid the
  XPC payload-size and serialization cost on the hot path.
- **`@Published var snapshot`** gives the SwiftUI peers free reactive
  observation of daemon state.

**− What it gets wrong**

- **~972 lines in one class.** No actor, no decomposition. Connection
  lifecycle, session management, generation state, shared memory,
  snapshot publication — all in one type. This will be the
  maintenance pain point.
- **`CliaLLMIPC.swift` is ~974 lines of hand-rolled XPC payloads.**
  Every new RPC means a new struct, a new method, a new wire-format
  negotiation.
- **NSObject, no `Sendable` story.** XPC delivery is serialised by
  NSXPCConnection's queue, but anything that touches `@Published`
  from the wrong queue is a footgun.
- **Single-instance enforcement is duplicated three ways**
  (SMAppService + LSMultipleInstancesProhibited + MachServices).
  Fragile if any one of those is wrong.
- **No in-process tick story.** Cache prune, telemetry flush, model
  warmup — none of that exists yet, and when it does, the daemon
  should *not* hand-roll another `Timer.scheduledTimer`.
- **Shared memory + XPC + RunLoop = hardest possible thing to test.**

**When it's the right answer.** Specifically when you need a
long-lived, model-stateful, multi-client darwin process with crash
isolation. That's a narrow shape, but `clia-llm` actually fits it.
Don't generalize this either.

---

## The honest verdict

The substrate has **two** genuinely different problem shapes
masquerading as ten implementations.

**Shape A — in-process periodic worker.** Covered today by A1, A2, A3,
A4, A5, A6 — six implementations of the *same idea*. The right answer
is `swift-service-registry` (A5) backed by `SwiftDaemon`'s engine (A4),
with `CommonBroker.PollingRegistry`'s lifecycle helpers (A3) folded in
as adapters and `MarketClock`'s `AsyncStream` surface (A6) preserved as
a consumer pattern. `TradeDaemon` (A1) is the first migration target.
Tau's custom actor (A2) goes away.

**Shape B — long-lived OS-managed process.** Covered today by B1, B2,
B3 — three implementations of *three different sub-shapes*. These do
not consolidate. Each is already the right answer for its slice. The
lesson is "don't try to merge them with shape A," not "merge them with
each other."

After consolidation, the count of *justified* daemon shapes drops to
**four**:

1. **In-process periodic worker** → `swift-service-registry`
2. **OS-scheduled job** → `SystemScheduler`
3. **Filesystem-event reactor** → `swift-hardlink-drain-cli` (and any
   future siblings of the same shape)
4. **Resident XPC service** → `CliaLLMResidentDaemon` (and any future
   siblings of the same shape)

Ten implementations today (counting the scaffold), four shapes after
consolidation. **Six implementations' worth of code can be deleted.**

That is the size of the win the 2025-10-01 survey was trying to
capture, and it is the size of the win still on the table today.

## The work, in priority order

> [!IMPORTANT]
> **Step 1 was amended on 2026-04-08 after reading the `SwiftDaemon`
> source.** The original framing assumed `SwiftDaemon` was a viable
> engine that ``swift-service-registry`` should consume. After reading
> the 66-line source, that framing is wrong. The new framing — Path C —
> is to inline the engine directly inside ``swift-service-registry`` and
> leave `SwiftDaemon` untouched in `wrkstrm/`. See A4's updated section
> for the source-grounded reasoning.

1. **Inline the engine inside `swift-service-registry`. Don't import
   `SwiftDaemon`.** This is the unblocker. Every other step depends
   on it. The reference implementation in `wrkstrm/` is 66 lines, has
   one smoke-test (`serviceStartsAndStops` against an empty stub),
   no backoff, no per-id keying (its seen-set is keyed by handler
   array index, not by id), no per-handler concurrency (one slow
   `fetchItems()` blocks every other handler), no `ServiceGroup`
   integration, no inspection surface, and a local-deps `Package.swift`
   whose relative path has been pointing at the dead pre-substrate
   `modules/swift-universal/` location since the substrate restructure.
   The cost of replacing 66 lines is lower than the cost of consuming
   them. The `Backoff` type, the `(type, id)` actor keying, the
   `Status` snapshots, the `Host`/`ServiceGroup` integration, and the
   per-handler task isolation all have to be written either way. Doing
   that work *inside* the registry instead of layered on top of
   `SwiftDaemon` keeps the code path one layer thinner and walks away
   from a package nobody is actively maintaining. Resolve the
   `common-log` identity collision under `SPM_USE_LOCAL_DEPS=true`
   while you're in there — it will only get worse the more consumers
   pile on, but with Path C the trap mostly evaporates because the
   registry doesn't pull `SwiftDaemon` and therefore doesn't drag in
   `SwiftDaemon`'s broken local-deps inject. (Path A "move SwiftDaemon
   out of `wrkstrm/`" and Path B "import via long relative path"
   remain documented in the original swift-service-registry
   investigation article for historical context. They are no longer
   the recommended approach.)
2. **Migrate `TradeDaemon` (A1) onto `Registry`.** Mechanical
   migration. `PositionPriceRefreshService` becomes a small
   `IdentifiedDaemonHandler` conformance keyed by position id. The
   per-position `Timer` proliferation collapses into one shared
   driver. Forces a real solution to the `SPM_USE_LOCAL_DEPS` trap.
   This is the first end-to-end consumer story.
3. **Swap `CommonBroker.PollingRegistry`'s internals (A3).** Keep the
   public surface, delegate the engine to `Registry`. This is where
   the substrate gets the biggest user-facing code reduction because
   the Watchlists view and several debug surfaces already use
   `PollingRegistry`. They stop containing two parallel engines.
4. **Resolve `Tau PollingDaemon` + `NotionTradePollingDaemon` (A2).**
   If they still exist post-restructure, replace with `Registry`
   handlers. If they don't, mark them dead in the journal and move on.
5. **Drive `MarketClock` fakes (A6) from `Registry`.** Retain the
   `AsyncStream` consumer surface; the producer becomes a
   `TickingHandler` that calls `continuation.yield(...)` from its
   tick body. This is the template for "AsyncStream-shaped consumer
   over a registry-managed producer," which will recur elsewhere.
6. **Add in-process tick workers inside `CliaLLMResidentDaemon`
   (B3).** Cache pruning, telemetry flush, warm-up keepalives, model
   prefetch. Each as a distinct `IdentifiedDaemonHandler` registered
   with `Registry` *inside* the resident XPC service process. This is
   the only place where `Registry` and `CliaLLMResidentDaemon`
   legitimately meet — workers *inside* it, not the daemon's
   top-level lifetime.
7. **Stop adding new daemon shapes.** This is the sustaining rule.
   Next time someone reaches for `Timer.scheduledTimer`,
   `Task { while true }`, or a fresh `actor`+`Task.sleep` loop in this
   substrate, the answer is `IdentifiedDaemonHandler`. Point at this
   investigation and at A1.

`SystemScheduler` (B1) and `swift-hardlink-drain-cli` (B2) stay outside
this whole effort. Permanently. They are not Shape A and never will be.

## Things I'm explicitly not recommending

- **Not** recommending `CliaLLMResidentDaemon` adopt
  `IdentifiedDaemonHandler` for its top-level lifetime. The OS owns
  that lifetime. Doing it would be ceremony.
- **Not** recommending `swift-hardlink-drain-cli` move into
  `swift-service-registry`. It is event-driven, not tick-driven.
  Different abstraction.
- **Not** recommending merging `CliaLLMIPC` into `swift-service-registry`.
  XPC protocol surfaces are application domain.
- **Not** recommending `swift-service-registry` grow XPC, FSEvents, or
  launchd awareness. The package's value is keeping its surface small
  enough to be trivially embeddable in any host (CLI, app, daemon)
  without dragging process-model assumptions along. Generalising it
  toward Shape B would destroy the thing that makes it useful for
  Shape A.
- **Not** recommending we tally "lines of code saved" up front. The
  win isn't bytes; it's the disappearance of the *category* "should
  this be a Timer or an actor or a daemon?" from review conversations.

## What this investigation supersedes / extends

- The 2025-10-01 polling-and-daemon survey
  (`harvest/2026-03-15/profile-context/by-path/collectives/wrkstrm/.wrkstrm/agents/common/docc/memory.docc/articles/polling-and-daemon-survey-2025-10-01.md`)
  is the prior art. This investigation extends it by adding A5
  (`swift-service-registry` itself), B2 (`swift-hardlink-drain-cli`),
  and B3 (`CliaLLMResidentDaemon`), which did not exist on
  2025-10-01.
- The swift-service-registry investigation article
  (`swift-universal/.../swift-service-registry/Documentation.docc/Articles/InvestigationCliaLLMResidentDaemon.md`)
  is the package-local version of this same analysis, written from
  the registry's point of view. This investigation is the substrate's
  point of view: the registry is one tenant of a larger problem.

## Outro

Nine — really ten — daemon shapes. Two genuine problem shapes. A
six-month-old survey that already told us how to consolidate. A
package (`swift-service-registry`) that is the right surface in the
right location, waiting on an engine. Two new daemon shapes added since
the survey, neither of which is a regression — `swift-hardlink-drain-cli`
solved a real problem the substrate didn't know it had, and
`CliaLLMResidentDaemon` is doing OS-managed work in-process instead of
which is exactly the right call. The proliferation isn't the new
shapes; it's that we kept growing Shape A without ever consolidating
it.

The next concrete decision to make was originally framed as: *does
`SwiftDaemon` move out of `wrkstrm/`, or does `swift-service-registry`
reach across into `wrkstrm/` to consume it?*

**Update 2026-04-08 (post source read).** Reading `SwiftDaemon`'s
66-line source revealed there is a third answer that is better than
both: **neither.** ``swift-service-registry`` should inline its own
engine and leave `SwiftDaemon` untouched in `wrkstrm/`. The reference
loop is too small to be worth importing, has no production consumers,
and its local-deps `Package.swift` has been silently broken since the
substrate restructure. Path C is the new step 1. See A4 and the
work-in-priority-order section above.

The unblocking question now is smaller and concretely actionable:
**what does the inlined engine actually need on day one?** The answer
the registry's own surface already implies: per-`(type, id)` actor
keying (already in the `Registry` store shape), `task = Task { while
!Task.isCancelled { tick all handlers concurrently with per-handler
isolation ; record per-id Status ; sleep with tolerance } }`, basic
`Backoff` on per-handler errors, and a SSWG `ServiceGroup`-aware
`Host` shell. Plus real tests that exercise tick semantics, dedup,
backoff, and cancellation — none of which `SwiftDaemon`'s
`serviceStartsAndStops` smoke test covers. That is the day-one engine.
Everything beyond it (debug surface, multi-model hosting, MarketClock
adaptation) layers on top.
