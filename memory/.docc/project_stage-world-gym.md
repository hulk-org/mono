---
name: Stage World Gym
description: digikoma-plant Stage World panel = gym for foundation sessions; staged worlds let you rehearse what a Digikoma + FoundationModels session would encounter
type: project
---

The Stage World panel (Factory → Stage World) in digikoma-plant is the "gym for foundation sessions" — a place to exercise Digikoma against controlled fixture inputs before they touch the live substrate.

**Why:** rismay's insight 2026-04-15 after seeing `digikoma-stage-world` run live in the app for the first time. The panel stages an isolated world (graph/ + out/ + tmp/), runs any Digikoma executable inside it, captures the result, and tears it down. This is exactly the rehearsal surface needed before wiring a Digikoma into a real Foundation Models turn.

**How to apply:** When designing a new Digikoma or debugging a turn graph node, the workflow is: design the node in TurnGraph Debug → identify what fixtures that node needs → stage those fixtures in Stage World → run the Digikoma → verify the handoff matches the expected receipt. No live substrate needed until the Digikoma passes in the gym.

**Documented at:** `digikoma-plant.architecture.docc/stage-world-gym.md`, `digikoma-stage-world/アイディ.md`, `digikoma-stage-world/インスト.md`
