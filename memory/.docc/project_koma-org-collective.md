---
name: koma-org collective
description: The コマ collective graduated from wrkstrm-app to its own org at collectives/koma-org; koma-plant is the app (was koma-by-wrkstrm), 6 live komo specs + 41 domain komo packages across 5 domains
type: project
---

koma-org is the canonical home for all Komo. Graduated from wrkstrm-app on 2026-04-12.

**Why:** The tool-eval workbench (originally "Generable Studio", then "Tachikoma by wrkstrm", then "Koma by wrkstrm") outgrew wrkstrm-app and became its own collective.

**How to apply:** All Komo work now lives at `collectives/koma-org/`, NOT `wrkstrm-app/.../koma-by-wrkstrm/` (stale). The app is now **koma-plant** (コマプラント — "the factory where Komo are built, tested, dispatched, and observed").

## Layout

```
koma-org/
├── CLAUDE.md
├── apps/
│   └── koma-plant/               ← the app (was koma-by-wrkstrm)
│       ├── アイディ.md            ← identity
│       ├── koma-plant.architecture.docc
│       ├── koma-plant.design.docc
│       ├── koma-plant.roadmap.docc
│       └── Sources/mac-app/
├── koma/                          ← live komo instances (6 with specs)
│   ├── echo/spec.json
│   ├── game-enrich/
│   ├── probe-context/
│   ├── read-file/
│   ├── scan-directory/spec.json
│   ├── vision-scan/
│   └── xcode-run/
├── domain/                        ← 41 komo packages across 5 domains
│   ├── core/       (echo, read-file, scan-directory)
│   ├── context/    (summarize-context, split-concept, probe-context)
│   ├── intelligence/ (thread-close, triage, claude, foundation-models, codex, thread-next, winddown, issue-scan, thread-spin, issue-create, trace-graph)
│   ├── meta/       (list, classify, need)
│   ├── directory/  (validate-naming, fix-case, flatten-directory, validate-empty)
│   └── build/      (xcode-test, swift-format, xcode-show-sdks, swift-run, xcode-build, swift-test, swift-build, swift-resolve, etc.)
├── spm/                           ← Swift packages (game-enrich, vision-komo)
└── koma-apps/                     ← (empty — future app komo?)
```

## Key facts
- 6 live komo with `spec.json` files under `koma/`
- 41 domain komo packages under `domain/` across core/context/intelligence/meta/directory/build
- App renamed to **koma-plant** (コマプラント)
- `spec.json` is the komo's identity — action is one field inside it
- No `trick.json` — term retired, use "action"
- `wrkstrm-performance/tool-eval-core/ToolEvalManifestKit` still provides the inventory schema types
