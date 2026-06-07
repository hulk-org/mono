---
name: Backends are peers not versions
description: Graph rendering backends are not v1/v2/v3 — they are parallel implementations (SpriteKit, SceneKit, Metal, UIKit Dynamics); never imply one supersedes another
type: feedback
---

Don't number backends as v1/v2/v3 — they are independent rendering strategies, not sequential versions. Name them by what they are: SpriteKit, SceneKit, Metal GPU, UIKit Dynamics.

**Why:** Numbering implies progression and obsolescence. Each backend has different trade-offs (visual quality, abstraction level, performance) and may be the right choice for different node counts.

**How to apply:** Use the engine/framework name as the label in benchmarks, code, and logs. Never "v1 SpriteKit" — just "SpriteKit". The bench-press comparison table should sort by performance, not by creation order.
