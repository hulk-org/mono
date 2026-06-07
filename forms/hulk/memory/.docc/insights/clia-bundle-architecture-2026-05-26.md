---
name: clia-bundle-architecture-2026-05-26
description: "CLIA = Command Line Interface Assistant; <slug>.<kind>.clia is the substrate's executable-assistant bundle primitive built on .fmadapter (trained LoRA) + session schema + .tui — unifying digikoma/agent/ghost under one factory shape"
metadata:
  node_type: memory
  type: insight
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

Session 2026-05-26 architectural cut with operator rismay, mid-build after
shipping the push factory + dogfood-pushing 14 agent submodules via
savepoint-cli. Operator surfaced the unifying name + primitive that ties
together the substrate's executor (digikoma), persona (agent), and human-
shadow (ghost) axes.

## The grammar

`<slug>.<kind>.clia` is a **directory bundle** representing an executable
assistant. Parsed:

- **`.clia`** — the executable-assistant marker. CLIA = **C**ommand **L**ine
  **I**nterface **A**ssistant. The substrate's existing "clia" branding
  (clia-org collective, clia-agents app, CLIACore module) stops being a
  brand and starts being the typed primitive it was always pointing at.
- **`<kind>`** — what kind of intelligence sits behind the surface.
  Three named today; more possible later:
  - `.digikoma` — adapter trained on a **tool/skill** (bounded executor with
    that tool's behavior internalized)
  - `.agent` — adapter trained on a **digital persona** (synthetic identity)
  - `.ghost` — adapter trained on a **human persona** (digital twin/shadow)
- **`<slug>`** — instance identifier (`git-push`, `carrie`, `rismay`).

Reads naturally: `git-push.digikoma.clia`, `carrie.agent.clia`,
`rismay.ghost.clia`.

## The primitive underneath

All three kinds are specializations of `.fmadapter` — a trained LoRA on
Apple FoundationModels — differing only by what corpus the adapter was
trained against. The shared envelope is `session-schema + .tui`. Grounds
in real substrate infrastructure: smoke-lora path + Apple Python LoRA
toolkit both already produce real `.fmadapter` checkpoints (see
[[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]]).

So `.fmadapter` is the typed primitive at the bottom; `<slug>.<kind>.clia`
is the executable-assistant bundle built on top.

## Bundle contents (proposed)

```
<slug>.<kind>.clia/
  manifest.json              — typed CLIABundleManifestModel
  adapter/                   — .fmadapter weights + training provenance
  session-schema.json        — typed session protocol declaration
  tui/                       — .tui spec (rendering surface)
  intent-contract.json       — typed Intent/Artifact contract (for queue dispatch)
  bin/<slug>                 — the actual executable (loads adapter, runs intents)
```

Substrate-native bundle, not SwiftPM-buildable (Swift's bundle types
weren't designed for ML-adapter sidecars; substrate controls the manifest
schema fully).

## Machinery vs assistants — the rename-visible split

```
machinery (NOT .clia)        assistants (.clia bundles)
---------------------------  --------------------------------
savepointd                   git-push.digikoma.clia
savepoint-cli                savepoint.digikoma.clia
agentd (sibling)             carrie.agent.clia
agent-cli (sibling)          castor.agent.clia
ghostd (sibling)             rismay.ghost.clia
                             ...
```

The queue-manager daemons (savepointd-equivalents for agent + ghost)
thin agent-side CLIs (savepoint-cli-equivalents) are MACHINERY: they
dispatch to assistants but they aren't assistants themselves. Only things
with trained intelligence behind a TUI surface get `.clia`.

## The .agent move — collapse the soft seam

Today's substrate agents (carrie, castor, claude, etc.) are configured via
identity bundle + persona triad + roles[] + system prompt running against
a generic LLM. "Who an agent is" lives partly in JSON (identity), partly
in prompt construction (system), partly in roles binding (agency triad).
Under this scheme, an `.agent.clia` *merges* the identity bundle into the
adapter's training data — the digital persona becomes the LoRA, not a
prompt-time wrapper.

Existing Shinji Techo ledgers (chronicle/journal/expertise) become
training corpora for `.agent` adapters. "The substrate ate its own data"
moment: every wd we've ever written contributes to the next-generation
training set.

## What this replaces / unifies

- Per-digikoma SPM packages with absolute relative paths (the
  digikoma-org/private/universal/domain/core/digikoma-* layout) → bundle
  colocated with owning library
- Today's agent identity-bundle + system-prompt construction → trained
  adapter (one artifact, one provenance chain)
- The implicit "what is CLIA?" confusion → CLIA is the substrate's
  executable-assistant primitive, period
- Separate ghost vs agent vs digikoma codebases → one shape (`.clia`),
  three axes of training-data

## Open architectural decisions (for the implementation bead)

1. Migration vs parallel-track for existing identity-bundle agents
   (carrie/castor/claude — retrain into `.agent.clia` or keep both)
2. Session-scope shape: one-shot-per-turn vs one-shot-per-session
   (probably per-turn with `SessionScope` continuation type, matches
   substrate's bounded-executor pattern)
3. Bundle discovery mechanism (directory scan? typed registry?
   substrate-wide manifest?)
4. agentd / ghostd as sibling daemons to savepointd, or one
   unified `cliad` that hosts service per-kind
5. Training pipeline integration — Apple Python LoRA + substrate's
   smoke-lora both produce adapters; bundle ingestion + provenance
   capture pattern

## Related substrate doctrine

- [[smoke-lora-end-to-end-without-apple-toolkit-2026-05-17]] — `.fmadapter`
  is a real producible artifact today
- [[ghosts-as-substrate-top-level-category-2026-05-17]] — ghost-shell-org
  chassis + ghosts/<slug>/ instance pattern
- [[substrate-is-digikoma-factory-2026-05-23]] — factory shape for
  bounded executors; digikoma is the pre-rename name for what becomes
  `.digikoma.clia`
- [[apple-generable-canonical-architecture]] — Apple shipped substrate's
  typed-record discipline as @Generable; pairs with .fmadapter
- [[named-coherent-doesnt-mean-agent]] — "who-I-am vs what-I-do-for-anyone"
  test; under .clia grammar, that's literally `.agent.clia` vs
  `.digikoma.clia` — the doctrine becomes the file extension
