---
name: xcodebuild stderr separate from stdout when parsing JSON
description: xcodebuild's stderr warnings DO NOT block JSON emission on stdout; always redirect stderr separately before diagnosing scheme/list issues
type: feedback
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
When parsing `xcodebuild -list -json` output, **always separate stderr from stdout**. xcodebuild emits structured JSON on stdout AND warnings/errors on stderr; merging them with `2>&1` makes warnings look like they're corrupting JSON when they aren't.

**Why:** Burned a long debugging arc on the substrate xcworkspace assuming warnings about `.swiftpm/xcode` "Folder Reference" mismatches were blocking JSON emission. They weren't. xcodebuild's stdout JSON channel is independent of stderr noise. Once I redirected stderr to /dev/null, the JSON came through cleanly (empty in this case — SPM-only workspaces have no shared schemes — but that's truthful, not a bug).

**How to apply:**
- In Swift Process invocations, use separate Pipe for `standardOutput` vs `standardError`; only read stdout for JSON.
- In shell diagnostics, prefer `xcodebuild ... 2>/dev/null` for the "what does the JSON say" question; only merge with `2>&1` when you actually want to see warnings.
- If `xcodebuild -list` returns empty/zero schemes for an SPM-only workspace, **that's correct** — Xcode auto-generates per-package schemes at GUI open time, NOT during command-line `xcodebuild -list`. Don't chase "fix this" — it's working as designed.
- mono-xcode-cli (`df0f249d-cli` post-rename) already does this correctly via Process pipes; no change needed there.

**Don't fight `.swiftpm/xcode` cache regeneration.** SPM regenerates these directories on every package read. Deletion is Sisyphean. The right answer is stream separation, not cache nuking. (workspace-validate's cache deletion is cosmetic at most.)
