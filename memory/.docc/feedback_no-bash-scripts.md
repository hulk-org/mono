---
name: No bash scripts either — only saved Swift CLIs
description: The "Swift over Python" rule extends to bash. Inline bash logic in the Bash tool (for-loops, while-read pipelines, multi-step verification scripts, heredocs that contain logic) is the same throwaway-script anti-pattern. Save anything beyond a discrete command as a Swift CLI in the canonical SPM tooling tree.
type: feedback
---

## Rule

Inline bash scripting in `Bash` tool calls is forbidden in the rismay
substrate. The same prohibition that applies to python3 heredocs
(`feedback_swift-not-python.md`) applies to bash. **Saved Swift CLIs are
the only sanctioned helper-language surface.**

This includes:

- `for ... do ... done` loops
- `while read` pipelines
- Multi-line shell logic with conditionals
- Heredoc-embedded scripts (`bash <<'EOF' ... EOF`)
- Shell scripts written into `/tmp/` and then executed
- Any pipeline that does meaningful logic beyond a single command

Discrete shell commands are still fine — `git add`, `git commit`, `mv`,
`rm -rf`, `cp`, `ls`, `pgrep`, `pkill`, `stat`, etc. The line is:
**one command, fine; many commands stitched into logic, save it as a Swift
CLI.**

## Why

- **No throwaway scripts** — repo policy is "all code worth writing must
  be saved in-repo to the owning agent, package, or tool surface." Bash
  pipelines in tool calls are throwaways by definition.
- **Reusability** — a Swift CLI written once for "compare hardlink parity
  between two trees" can be used by every future agent. A bash one-liner
  in a tool call cannot.
- **Reviewability** — a saved Swift CLI gets code review, tests,
  documentation, and version history. A bash inline gets none of that.
- **Cross-platform** — Swift compiles for macOS and Linux. Bash idioms
  drift across `/bin/sh`, `/bin/bash`, BSD vs GNU `stat`, BSD vs GNU
  `find`, `ggrep` vs `grep`, etc.
- **Consistency** — the substrate already has dozens of `swift-X-cli`
  tools under `swift-universal/.../tooling/spm/`. Bash in tool calls
  fragments that pattern.

## How to apply

When tempted to write inline bash logic in a `Bash` tool call:

1. **Stop.** Recognize the urge.
2. **Identify the verb** — what is the bash trying to do? "Compare two
   trees by inode," "List submodule states," "Walk a dir and count files
   per subdir," "Verify hardlink parity between paths X and Y."
3. **Find an existing Swift CLI** for that verb under
   `private/universal/substrate/collectives/swift-universal/private/universal/domain/tooling/spm/`.
   Many already exist (`swift-git-cli`, `swift-directory-tool-cli`,
   `swift-spm-package-maintainer-cli`, `swift-harness-environment-cli`,
   `swift-hardlink-drain-cli`, etc).
4. **If none exists, write one.** Create a new `swift-X-cli` package in
   the same neighborhood, with library + executable targets, ArgumentParser,
   tests. Build, install to `~/.swiftpm/bin/`, then invoke via `Bash`.
   Yes, this is heavier than a one-liner. That's the point.
5. **Only fall back to a single shell command** if the work is genuinely
   one syscall (`mv A B`, `rm -rf X`, `pgrep foo`, `git status`).

## Examples of violations from this session

- `for f in $(find claude/ -type f); do stat ... ; done` — should have been
  a `swift-tree-parity-cli` or similar that takes two paths and emits a
  parity report.
- `cd hulk && git status && git diff && cd ../wrkstrm && git status` —
  should have been a `swift-multi-submodule-status-cli`.
- `pkill -f X; sleep 1; pgrep -fl X || echo dead` — should have been a
  `swift-process-control-cli` or just two discrete `Bash` calls.

## Inheritance

This rule sharpens `feedback_swift-not-python.md` from "no python3 heredocs"
to "no inline scripting languages of any kind in tool calls — only saved
Swift CLIs." Both rules trace back to the substrate's "Swift over Python
for all filesystem, automation, and helper code" policy in CLAUDE.md.
