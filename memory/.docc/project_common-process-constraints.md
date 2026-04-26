---
name: common-process is infrastructure-grade
description: common-process is the hot path for the entire substrate — every OS back 10 years, performance down to the syscall, assembly optimization on the roadmap
type: project
originSessionId: 3f7ca7d5-00cd-4a21-babe-4039af3d2525
---
common-process is the heart of the operation. Every CLI tool, komo, build step, and agent action goes through it.

**Why:** It's the most-called package in the substrate. Abstraction tax is multiplied by every process launch.

**How to apply:**
- Model layer (CommonProcess target) must have zero platform conditionals — compiles everywhere
- Runner backends degrade: Subprocess → Foundation → TSCBasic
- No allocations in the hot path — value types only
- Executable resolution should be cached per session, not per-call
- Simplification (kill factories, flatten executors) is performance work, not cleanup
- Benchmark against raw posix_spawn — delta is the accountability metric
- C shim for posix_spawn wrappers and vfork path are explicit future milestones
- Never "fast enough" — infrastructure-grade performance discipline
