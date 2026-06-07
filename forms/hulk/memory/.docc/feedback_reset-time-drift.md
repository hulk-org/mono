---
name: Provider reset times drift ~2 hours early
description: Claude API session reset times are unreliable — actual resets happen up to 2 hours before the reported time; apply a safety buffer
type: feedback
originSessionId: b4c9d58c-0196-4bd0-9c5d-e4accca62e6b
---
Claude's OAuth usage API (`five_hour.resets_at`) reports reset times that are ~2 hours later than the actual reset. Observed 2026-04-23: API said reset at ~12PM but it reset at ~10AM.

**Why:** Anthropic's backend may round, batch, or delay the reported reset timestamp. The actual cooldown window is shorter than advertised.

**How to apply:** Subtract a 2-hour safety buffer from all reported `resets_at` timestamps when computing pacing. This means the fuse burns faster (less remaining time), warnings trigger earlier, and "SPEND NOW" signals arrive before the window actually closes — not after.
