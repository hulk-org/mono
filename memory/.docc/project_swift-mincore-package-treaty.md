---
name: Swift mincore package treaty
description: rismay wants minima of Swift systems: SwiftPM/Package.swift as the treaty, Swift as control plane, C at systems boundaries, ASM at startup/hot-path boundaries, as the base for tiny Tachikoma executable worlds
type: project
---

Decision captured 2026-04-11: **create minima of Swift systems**.

The constraint boundary is:

- If `swift build` works from a `Package.swift`, the system is inside the
  acceptable organism graph.
- Swift does not need to own every byte of the substrate.
- Swift should own the package graph, orchestration, typing, testing, and
  human/agent operability.
- C and ASM are allowed where they make the system smaller, sharper, or more
  controllable.

## Doctrine

**`Package.swift` is the treaty.**

**Swift is the conductor.**

**C is the knife.**

**ASM is the ignition spark.**

Swift should stay at the control plane:

- package graph
- command routing
- agent / Tachikoma orchestration
- protocol modeling
- typed config
- plugins
- domain logic
- test harnesses

C should own systems-boundary surfaces where overhead or ABI precision matters:

- syscall wrappers
- allocators
- ring buffers
- shared memory
- process bootstrap
- tiny parsers
- terminal I/O
- crypto primitives where needed

ASM should stay extremely narrow:

- custom `_start`
- platform entry stubs
- context switching experiments
- syscall trampolines
- tight `memcpy` / `memset` experiments
- tiny benchmark kernels

## Architecture preference

Prefer:

1. SwiftPM root package.
2. Swift orchestration targets.
3. C leaf targets for substrate work.
4. ASM only for narrow startup or hot-path experiments.

Avoid starting from C/ASM as the root and bolting Swift on later. That path
shrinks the first binary but tends to destroy composability, fragment tooling,
and create opaque build glue. The organism needs a package graph more than it
needs early cleverness.

## Branches

**Branch 1: pragmatic tiny.**

Keep a normal Swift entry point and push low-level work into C. This is the
first production route.

**Branch 2: extreme tiny.**

Own startup with `_start` in ASM/C and then invoke Swift manually. This is
research until there is benchmark evidence that the complexity pays for itself.

## First package milestone

Create a `swift-mincore` package with:

- one executable target
- one Swift runtime/core target
- one C shim target
- one syscall target
- one benchmark target
- one optional ASM startup experiment
- metrics for binary size, startup latency, RSS, and hello-world syscall path

The point is to get evidence, not vibes.

## Tiny worlds

A Swift package can define many tiny worlds:

- standard CLI
- stripped CLI with C shims
- daemon
- XPC service
- micro-VM guest payload
- Firecracker guest executable
- container entrypoint

This maps directly onto the Tachikoma factory: Package.swift preserves the
factory's operability while C/ASM let individual Tachikoma worlds become small
and sharp.

## Rule for implementation

Do not chase full no-libc or full custom startup first. Preserve SwiftPM, build
the measurable baseline, then carve away overhead with evidence.
