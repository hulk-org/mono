---
name: feedback-grep-substrate-common-star-before-authoring-tool-code
description: "BEFORE authoring any Swift tool source code, grep substrate for existing common-* / shared / universal packages that provide the primitive — common-log for logging, common-process for subprocess, common-shell for shell ops, wrkstrm-components for UI, markdown-preview for markdown render, etc. Recurring failure mode this session — operator caught TWICE; sharpening the existing [[grep-common-star-before-adding-primitives]] discipline. Operator-attested 2026-06-04: \"common-log! why aren't you looking for swift-universal and other universal packages so you don't keep making bad architecture decisions?\""
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

BEFORE authoring any Swift tool source code (CLI / library / executable), grep substrate for existing common-* / shared / universal packages that provide the primitive being used.

**Why:** The substrate has invested heavily in shared common-* packages — `common-log` (CommonLog), `common-process` (CommonProcess), `common-shell` (CommonShell, CommonShellArguments), `common-cli` (TinyArgv), `common-imprint` (CommonImprint), and dozens of wrkstrm-components packages (markdown-preview, modern-app-shell, modern-mac-tab-chrome, design-token-service, etc.). Bypassing these to roll my own primitive (FileHandle.standardError.write instead of Log; raw print instead of structured logging; inline markdown parser instead of importing markdown-preview) creates substrate-doctrine debt that compounds badly. Each bypass forks the substrate's logging/parsing/UX behaviors and undermines the substrate's typed-everything thesis.

**Operator's recurring frustration this session (2026-06-04):**
1. First miss: authored `MarkdownPreviewView.swift` inline in Presense when `wrkstrm-components/markdown-preview` package existed
2. Second miss: built `finding-corpus-query@spaces-universal.cli` with `FileHandle.standardError.write` + raw `print` warnings when `common-log` exists at `swift-universal/private/universal/spm/domain/system/common-log/` with the canonical `Log(system:, category:, maxExposureLevel:)` API + 5 backends (Print, OS, File, Swift, Disabled)

Operator-attested 2026-06-04: "common-log! why aren't you looking for swift-universal and other universal packages so you don't keep making bad architecture decisions?"

**How to apply (the pre-authoring check):**

Before writing the FIRST line of Swift source in a new tool/library/app, run this checklist:

1. **Logging?** → grep `common-log` first. Lives at `collectives/swift-universal/private/universal/spm/domain/system/common-log/`. Public API: `Log(system: String, category: String, maxExposureLevel: .warning)` + `.trace` / `.debug` / `.verbose` / `.info` / `.notice` / `.warning` / `.error`. Sample consumer: `wrkstrm-components/modern-mac-tab-chrome/.../WrkstrmMacNativeTabDiagnostics.swift`.
2. **Subprocess invocation?** → use `common-process` (CommonProcess). Per [[common-process-banned-foundation-process]] — `Foundation.Process` is banned.
3. **Shell argument parsing / shell ops?** → use `common-shell` (CommonShell, CommonShellArguments). Per [[common-process-shell-cli-typed-primitives]].
4. **ArgumentParser?** → both `swift-argument-parser` (industry-standard) AND `common-cli` (TinyArgv, substrate's sibling) are acceptable. Use `swift-argument-parser` for consistency with sibling substrate tools unless TinyArgv is explicitly preferred.
5. **UI components?** → grep `wrkstrm-components/` packages list (~70 packages). Markdown rendering → `markdown-preview` package exists. Modern app shell → `modern-app-shell`. Tab chrome → `modern-mac-tab-chrome`. Design tokens → `design-token-service`. Onboarding → `onboarding`. Etc.
6. **Storage / vault primitives?** → grep `wrkstrm-core/private/cross/spm/` for vault primitives.
7. **Telemetry / receipt emission?** → grep substrate for receipt-schemas, kura receipt packages.

**Concrete grep commands (memorize):**

```bash
# Find common-* swift packages
find /Users/sonoma/mono/private/universal/substrate/collectives/swift-universal -path '*common-*/Package.swift' -not -path '*/.build/*' | head -10

# Find wrkstrm-components packages
ls /Users/sonoma/mono/private/universal/substrate/collectives/wrkstrm-components/private/

# Find any package by primitive concept
find /Users/sonoma/mono/private/universal/substrate/collectives -path '*<concept>*/Package.swift' -not -path '*/.build/*' | head -5
```

**Composes with:** [[grep-common-star-before-adding-primitives]] (antecedent, broader doctrine) + [[Direct deps over transitive bundling]] + [[per-scene-independent-spm-packages]] + [[common-process-banned-foundation-process]] + [[common-process-shell-cli-typed-primitives]] + [[Swift over Python]] + [[exploration-is-substrate-tooling]].

**3x-rule promotion candidate**: 3rd confirmed instance this session means typed AxiomModel promotion warranted. Bead-track or promote next /capture.

**This memory is a downstream POINTER**: the substrate-canonical fix would be to ship a `grep-substrate-common-star.tool.json` typed tool that runs the pre-authoring check mechanically. Bead-track for next session.
