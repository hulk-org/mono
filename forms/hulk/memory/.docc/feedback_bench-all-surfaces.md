---
name: Benchmark all surfaces simultaneously
description: graph-view-bench-press must run ALL backend benchmarks (SpriteKit, SceneKit, Metal) in one invocation — no rebuild between runs
type: feedback
---

Each backend gets its own executable target in graph-view-bench-press. Never overwrite an existing benchmark file — create a new file and target for each engine.

**Why:** On a new machine you re-run all benchmarks. Each lane must be independently runnable and never removed. Adding a new backend = adding a new file + executable target.

**How to apply:** One executable target per backend (e.g. `graph-view-cpu-bench`, `graph-view-scenekit-bench`, `graph-view-metal-bench`). Each is a standalone file that imports its backend and runs the threshold finder. Never modify an existing bench file to add a new backend — create a new one.
