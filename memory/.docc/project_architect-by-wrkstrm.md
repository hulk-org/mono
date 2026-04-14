---
name: Architect by wrkstrm — spatial agent orchestration
description: "Architect by wrkstrm" is a spatial operating environment for agents on Metal 4; infinite canvas where Komo execute, operators draw, and the output is a running application. Maestri (themaestri.app) is the reference for the canvas UI — we have the engine underneath.
type: project
---

**Product:** Architect by wrkstrm — the flagship.
**Tagline:** "Draw software." (= you draw, and what comes out is a running application)
**Entity:** wrkstrm Inc
**Bundle ID:** `me.rismay.architect`
**Team:** BM6B69ZQSR

## The vision (crystallized 2026-04-13)

Maestri (themaestri.app) showed the canvas: multiple terminals on
an infinite spatial surface, connected by arrows, sticky notes
alongside, sketches mixed with code. But it's 2D AppKit rendering
over standard terminal emulators.

Architect by wrkstrm is the same vision on a Metal 4 engine with
Komo as the execution units. Not terminals on a canvas — **agents
in a world**. The operator doesn't alt-tab between terminals. The
operator walks through rooms where agents physically work.

## Maestri → Architect mapping

| Maestri | Architect by wrkstrm |
| --- | --- |
| Infinite canvas (2D pan/zoom) | Metal 4 isometric world (CameraIsometric, billboard sprites) |
| Terminal windows | Komo CLIs dispatched by CLIDE |
| Agent connections (wires) | LineRenderer connections between Komo |
| Drawing/sketches | QuadRenderer + LineRenderer (instanced, dirty-range tracked) |
| Spatial layout | RoomScene / StudioScene (directories as rooms, filesystem as world) |
| Ombro (agent watcher) | Beat ledger (ephemeral observation, log then discard) |
| Sticky notes | GameLabel overlay (NSTextField on Metal) |
| Floor plans | Domain architecture (core/context/meta/build/directory/intelligence) |
| Apple Intelligence | Cognition bridge (--prompt at every node, Foundation Models on-device) |
| Slop Jail | koma-validate-* family (validate before commit) |

## What we have that Maestri doesn't

1. **Metal 4 engine** — 500K quads at 3,241 fps. Dirty-range tracking. Double-buffer. Billboard sprites. Isometric projection.
2. **31 Komo across 6 domains** — bounded execution units with spec, lineage, cognition bridge. Not terminal emulators — typed JSON in/out/exit.
3. **CLIDE v2** — C membrane daemon that dispatches Komo over Unix socket. The harness.
4. **Organism ontology** — Ghost/Shell/Sprite/Komo/Action hierarchy. The separation that makes the system trustable at scale.
5. **Domain architecture** — core/context/meta/directory/build/intelligence. Semantic boundaries with DAG dependencies.
6. **Agent RPG** — the proof that the filesystem IS a navigable world. Rooms, doors, bookshelves, walking character, sound effects, labels. The game IS the workspace.

## Architecture

Two apps, one engine:
- **Architect macOS native:** NSApplication → MTKView → Metal 4. AppKit input.
- **Architect Mac Catalyst:** UIApplication → MTKView → Metal 4. UIKit touch input (60 Hz display).
- **Shared core:** MetalGameEngine + WrkstrmMetalComponents + StrokePipeline.
- AppDelegate root. Metal owns the frame. SwiftUI is HUD/chrome only, via NSHostingView overlay.

## The canvas

The canvas is the Metal 4 rendering surface. On it:
- **Komo terminals** — each running Komo is a billboard sprite on the isometric grid
- **Connections** — LineRenderer draws wires between Komo showing data flow
- **Operator drawings** — touch/mouse → bezier → LineInstance → Metal 4
- **Labels** — GameLabel overlay for names, status, output snippets
- **Rooms** — zoom into a directory and it becomes a room you can explore
- **Studio** — the home base where your agent team sits at desks (Agent RPG studio)
- **Beat visualization** — ephemeral particles/effects showing Komo executing at nodes

## The output

What comes out is a running application. The organisms ARE the primitives.
The operator draws connections between Komo. The connections ARE the work
graph. The work graph executes. The result is software.

## How to apply

- Architect by wrkstrm is the convergence of: Metal engine + Komo fleet + CLIDE dispatch + Agent RPG world + touch input + organism ontology
- Maestri is the UI reference. Our engine is the substrate underneath.
- Next steps: connect MetalGameEngine to wrkstrm-mac-touch-draw for drawing, wire CLIDE dispatch for agent terminals on the canvas, port Agent RPG spatial navigation as the world layer
