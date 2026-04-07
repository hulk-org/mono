---
name: Swift over Python (no throwaway scripts)
description: Per CLAUDE.md, use Swift for all filesystem/automation/helper code. Never reach for inline `python3 - <<'PY'` heredocs for substrate normalization or refactor batches.
type: feedback
---

In the rismay substrate, **Swift is the only sanctioned language for filesystem, automation, and helper code**. CLAUDE.md says it explicitly, and the user has corrected me on it more than once.

**Why:** "No throwaway scripts. All code worth writing must be saved in-repo to the owning agent, package, or tool surface." Python heredocs violate both rules — they're throwaway and they're the wrong language.

**How to apply:**
- For one-off filesystem ops (mv, mkdir, ls, cp, rm), bash with the standard `git mv` / shell tools is fine — that's CLI usage, not "helper code".
- For anything that would otherwise be a Python script (text substitutions across many files, structured rename batches, JSON munging), write a Swift CLI tool in the appropriate SPM package and save it in-repo. Acceptable homes: `swift-harness-environment-cli`, an existing tooling SPM under the relevant collective, or a new SPM if the operation is durable.
- For ad-hoc text substitutions, if no Swift tool exists yet, prefer `Edit`/`Write` tools or `sed -i ''` over Python.
- **Never reach for `python3 - <<'PY'` heredocs in this substrate.**
