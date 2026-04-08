---
name: Swift over Python (no throwaway scripts, analysis included)
description: Per CLAUDE.md, use Swift for all filesystem/automation/helper code AND data analysis. Never reach for inline `python3 - <<'PY'` heredocs for normalization, refactor batches, or one-off data inspection.
type: feedback
---

In the rismay substrate, **Swift is the only sanctioned language for filesystem,
automation, helper code, and data analysis**. CLAUDE.md says it explicitly, and
the user has corrected me on it more than once.

**Why:** "No throwaway scripts. All code worth writing must be saved in-repo to
the owning agent, package, or tool surface." Python heredocs violate both rules
— they're throwaway and they're the wrong language. This applies to **read-only
analysis too** (streaming a big JSONL file for metrics, counting types in a
rollout, checking field sizes) — not just write-heavy normalization / refactor
batches. If the analysis would otherwise be a Python `heapq`/`re` one-liner, it
belongs in a Swift CLI under an existing tooling SPM.

**How to apply:**
- For one-off filesystem ops (mv, mkdir, ls, cp, rm), bash with the standard
  `git mv` / shell tools is fine — that's CLI usage, not "helper code".
- For anything that would otherwise be a Python script — text substitutions,
  structured rename batches, JSON munging, large-file scanning, byte counting,
  type/payload attribution — use an existing Swift CLI in the relevant SPM, or
  add the capability to one. Acceptable homes:
  `swift-harness-environment-cli`, `swift-codex-session-store-cli` (under
  `clia-org` tooling), the relevant tooling SPM under the collective, or a new
  SPM if the operation is durable.
- For ad-hoc text substitutions, if no Swift tool exists yet, prefer `Edit` /
  `Write` tools or `sed -i ''` over Python.
- **Never reach for `python3 - <<'PY'` heredocs in this substrate**, even for
  "just looking" at files.
