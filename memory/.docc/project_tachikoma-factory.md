---
name: Tachikoma factory
description: rismay wants the carrier/harness layer to become a Tachikoma factory: mint bounded workers from specs, projected work graphs, staged worlds, action bindings, budgets, and receipts rather than spawning full agents for discrete work; pet/trick vocabulary retired (see feedback_no-pet-no-trick)
type: project
originSessionId: d8bf83a5-6455-41dc-86b8-ec518edcee54
---
Decision captured 2026-04-11: **we need to become a Tachikoma factory**.

This extends:

- `project_tachikoma-ontology.md`
- `project_tachikoma-traverser-vocabulary-and-field-worlds.md`
- `project_swift-mincore-package-treaty.md`
- `feedback_harness-spawns-tachikoma-not-agents.md`
- `project_clia-env-carrier-bootstrap.md`

## Factory thesis

The carrier/harness should not mainly spawn full agent sessions for discrete
bounded work. It should manufacture Tachikoma from small, inspectable specs.

The factory takes:

- a projected work graph
- a Tachikoma anatomy / traversal preset
- one or more action bindings
- a staged execution world
- explicit budgets and permissions
- expected receipts (onboarding + offboarding stamps; imprints are gated on both)

and emits:

- a bounded worker
- an execution transcript
- a receipt bundle
- optional promoted learnings back to the Ghost / agent memory layer

## What the factory owns

- **Anatomy catalog** — traversal presets such as Spider, Ant, Hound, Fox, Watcher.
  These are anatomy/traversal defaults, not personalities. (Older notes called
  these "species" — kept as historical naming inside the catalog file names.)
- **Action catalog** — atomic operations such as fetch, clean, mark, trace,
  validate, index, watch, normalize, summarize, diff. When an action is
  performed at a station during traversal, the verb is "scan."
- **World builder** — creates staged disposable filesystems / graph slices.
  Tachikoma never execute against the real host filesystem directly.
- **Budget compiler** — converts intent into bounded limits: max nodes,
  max writes, max wall time, max bytes, network policy, allowed roots.
- **Runner** — executes the Tachikoma with no durable memory and no agent
  persona.
- **Receipt writer** — records inputs, traversal, mutations, failures,
  skipped nodes, and outputs in a replayable form.
- **Promotion gate** — decides what, if anything, returns to durable Ghost /
  agent memory or canonical repo state.

## Factory contract

- Tachikoma are produced from specs, not prompts.
- Tachikoma do not keep memory between runs.
- Tachikoma do not interpret operator intent.
- Tachikoma do not spawn Tachikoma.
- Tachikoma can fail safely because their world is staged and bounded.
- The Ghost reasons, the carrier manufactures, the Tachikoma executes, and the
  receipt teaches the next factory run.

## Relation to clia-env

`clia-env` is the carrier bootstrap layer. It must be able to identify the
active carrier, resolve homes, construct headers, and expose enough environment
truth for a Tachikoma factory to know where it is allowed to stage worlds.

That means `clia-env` is not only startup/header plumbing. It is the first
factory prerequisite: without a truthful carrier environment, the factory mints
workers into the wrong world.

## First factory surfaces

The first useful Tachikoma factory does not need model access. It needs a
boring, safe worker runner.

Initial anatomy/actions should be filesystem and documentation oriented:

- **Spider** — walk a bounded file graph and emit inventory receipts.
- **Watcher** — observe a bounded root and emit change receipts.
- **Cleaner** — apply deterministic cleanup rules inside a staged copy.
- **Validator** — run a declared check and emit structured pass/fail receipts.
- **Normalizer** — canonicalize files through approved formatters.

## Minimal Swift systems

The factory should be able to mint tiny Swift-system worlds as long as each
world remains buildable through `swift build` and `Package.swift`.

The contract from `project_swift-mincore-package-treaty.md` applies:

- `Package.swift` is the treaty.
- Swift is the conductor.
- C is the knife.
- ASM is the ignition spark.

This makes SwiftPM the factory graph while allowing C and ASM leaf targets for
syscalls, allocators, startup stubs, and hot-path experiments.

## Do not confuse with agents

Agents have identity, memory, judgment, and voice. Tachikoma have closure,
context, limits, and receipts.

If the work needs judgment, ask the Ghost/agent. If the work needs bounded
execution, mint a Tachikoma.

## Next implementation question

Where does the first `tachikoma-spec` schema live?

Candidate homes:

- `wrkstrm-core` if the factory is a general carrier primitive
- `clia-org` if the first implementation ships through CLIA tooling
- `schema-universal` if the spec needs to become a reusable organism schema

Default answer: start in `clia-org` as an implementation spec, promote to
`schema-universal` once at least two carriers can consume it.
