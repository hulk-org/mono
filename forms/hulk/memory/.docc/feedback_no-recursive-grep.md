---
name: Never use bash grep -r on substrate; always use the Grep tool
description: Recursive grep/find across rismay's substrate hangs for tens of minutes. Always use the Grep tool (ripgrep) for content searches and Glob for path searches, even when you think it'll be fast.
type: feedback
---

The rismay substrate is large enough that `grep -rln <pattern> private/universal/substrate/collectives` (or similar wide bash grep/find scans) **regularly hangs for 20–30+ minutes**. I burned 31 minutes of the user's time on this in 2026-04-07.

**Why:** The collectives tree contains hundreds of submodules with nested .build/, .derived-data/, checkouts/, harvest archives, vault exports, derived xcode caches, etc. Even with `--exclude-dir` flags, bash grep is unusably slow.

**How to apply:**
- For content searches: **always use the Grep tool** (ripgrep). It's the only fast option at substrate scale.
- For file path searches: **use the Glob tool**. Don't `find ... -name ...` across collectives.
- If you need a quick targeted search, bash grep is fine inside a single small package — but never across `collectives/`, never across the substrate root, never across `harnesses/`.
- If a Grep tool query needs to span many file types, run multiple Grep tool calls in parallel rather than one big bash sweep.
- **Never** use `grep -rln`, `find ... -exec grep`, or similar against the substrate root or `private/universal/substrate/collectives`. Even with exclusions.
- If you accidentally start one, kill it immediately with `pkill -f` rather than waiting.
