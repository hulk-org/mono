---
name: Graph rendering needs Metal
description: SpriteKit force-directed graph is too slow for 900+ package nodes; experiment with Metal rendering in wrkstrm-performance
type: project
---

SpriteKit SKShapeNode-per-node + per-frame CGMutablePath edge redraws is too slow for substrate-scale graphs (900+ packages in Foundry, 80+ submodules in Source Control). The force simulation itself is fine — it's the rendering that's the bottleneck.

**Why:** SKShapeNode creates CPU-side paths every frame, doesn't batch draw calls, and each node is its own scene graph entry. At 900 nodes + edges, frame time tanks.

**How to apply:** Experiment in wrkstrm-performance with:
- Metal compute shader for force simulation (GPU-parallel O(n²) repulsion)
- Metal render pass for nodes (instanced circle drawing) and edges (line list)
- MTKView instead of SKView — direct Metal, no SpriteKit overhead
- Keep the same force parameters (repulsion 8000, spring 0.004, damping 0.88) but run on GPU
- The SwiftUI bridge pattern (NSViewRepresentable → MTKView) stays the same

Three apps share this engine: Source Control, Collectives, Foundry. Once the Metal renderer is proven in wrkstrm-performance, port it back as a shared package.
