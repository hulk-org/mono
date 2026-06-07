# Smoke-LoRA Path Works End-to-End Without Apple's Toolkit

Date: 2026-05-17

The Ghost app has TWO summon paths. Knowing the difference unblocks
shipping.

## The two paths

**Path A — full Apple LoRA (train-adapter)**
- Runs Apple's Python adapter training module (`examples.train_adapter`)
- Produces a real `.fmadapter` bundle loadable by Foundation Models
- **Requires Apple's Foundation Models adapter training toolkit on disk**
- Requires `--working-directory` pointing at that toolkit
- `GhostTrainingProcess.Command.trainAdapter` invokes this path
- **The screenshot's failure was here**: toolkit missing →
  `ModuleNotFoundError: No module named 'examples.train_adapter'`

**Path B — Swift-owned smoke (train-smoke-lora)**
- Pure Swift LoRA training inside digikoma-forge
- Produces `ghost.smoke-lora.v1` checkpoint JSON (not a real .fmadapter)
- Base model: deterministic hashed linear projection
- No Python toolkit dependency, no Apple binaries required
- `GhostTrainingProcess.Command.makeOneSessionLora` invokes this path

## Verified end-to-end metrics (smoke path)

Ran on 50-line sample of real corpus at /tmp/ghost-mini-train.jsonl:

```
smokeLora.examples         = 50
smokeLora.trainingSteps    = 5000
smokeLora.lossBefore       = 0.0036
smokeLora.lossAfter        = 0.0000673    ← 53× reduction
smokeLora.totalSeconds     = 4.7
smokeLora.stepsPerSecond   = 1088
smokeLora.checkpoint       = adapter-final.ghost-lora.json (63 KB)
smokeLora.descriptor       = adapter-descriptor.json (19 KB)
```

The checkpoint exists on disk; the loss reduction is real; the pipeline
ran in 4.7 seconds. This is a working ghost summon, just not a Foundation
Models one.

## Stage 1+2 verified at scale (also today)

Ran `export-corpus` on the real `private/universal/vaults/ai/exports/
open-ai/codex/sessions` vault:

```
corpus.examples       = 25,645
train.sessions        = 755 / 20,778 examples
validation.sessions   = 89 / 2,124 examples
holdout.sessions      = 94 / 2,743 examples
train.jsonl           = 93 MB
```

So we have: real corpus (25k+ examples) + real smoke training (real loss
reduction) = a real end-to-end ghost summon. The only missing piece for
the *full* Foundation Models path is Apple's Python toolkit.

## Adapter-descriptor honesty

The descriptor JSON refuses to lie about what it is:

```
"compatibility": "Smoke-test LoRA checkpoint for Ghost only;
                  not an Apple Foundation Models .fmadapter."
"family":        "ghost-smoke"
"runtime":       "Swift GhostTrainingCore"
```

That metadata is structurally honest — anyone loading the smoke adapter
sees immediately it's not the full thing. Good substrate discipline.

## Ship strategy implication

For Ghost v1 — two viable framings:

1. **Smoke-as-default** — ship with smoke-lora as the SummonHero's
   action. Apple-LoRA becomes Pro Mode (toggle, requires toolkit
   install). v1 ships today; v1.1 unlocks Apple-grade adapters.

2. **Hold for Apple toolkit** — wait until Apple's toolkit is downloaded
   and `--working-directory` is wired through GhostTrainingProcess.
   Higher polish; longer wait.

The smoke path is the cheap-and-good-enough demo. The Apple path is the
production-grade adapter. Both produce artifacts the Adapter Library
can recognize — just different formats.

## CUJ 07 error catalog entry

When the train-adapter stage fails with `ModuleNotFoundError: No module
named 'examples.train_adapter'`, the actionable error surface should
say:

> *"Apple's Foundation Models adapter training toolkit isn't installed
> or `--working-directory` isn't wired. Either download the toolkit from
> developer.apple.com and configure GhostTrainingProcess to pass
> --working-directory, OR use the smoke-lora path for a Swift-only
> SUMMON that doesn't need the toolkit."*

That's the v1 polish for CUJ 07's recovery loop.

## Source

Pre-flight verification on 2026-05-16 / 2026-05-17 after surfacing the
screenshot's two-day-old training failure. Discovered the path split by
reading `digikoma-forge`'s `d770a604-cli` subcommand list. Ran both
`export-corpus` (Stages 1+2) and `train-smoke-lora` (Stage 3 Swift path)
to verify each end-to-end against the real substrate state.
