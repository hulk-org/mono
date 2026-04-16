---
name: Stage World Gym
description: koma-plant Stage World panel = gym for foundation sessions; staged worlds let you rehearse what a Koma + FoundationModels session would encounter
type: project
---

The Stage World panel (Factory → Stage World) in koma-plant is the "gym for foundation sessions" — a place to exercise Koma against controlled fixture inputs before they touch the live substrate.

**Why:** rismay's insight 2026-04-15 after seeing `koma-stage-world` run live in the app for the first time. The panel stages an isolated world (graph/ + out/ + tmp/), runs any Koma executable inside it, captures the result, and tears it down. This is exactly the rehearsal surface needed before wiring a Koma into a real Foundation Models turn.

**How to apply:** When designing a new Koma or debugging a turn graph node, the workflow is: design the node in TurnGraph Debug → identify what fixtures that node needs → stage those fixtures in Stage World → run the Koma → verify the handoff matches the expected receipt. No live substrate needed until the Koma passes in the gym.

**Documented at:** `koma-plant.architecture.docc/stage-world-gym.md`, `koma-stage-world/アイディ.md`, `koma-stage-world/インスト.md`
