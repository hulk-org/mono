---
name: No hardcoded fps
description: Never hardcode preferredFramesPerSecond; read the monitor's maximumFramesPerSecond at runtime
type: feedback
---

Never write `preferredFramesPerSecond = 120` (or any constant). Use `NSScreen.main?.maximumFramesPerSecond ?? 60` so the app respects the actual display hardware. Bench numbers come from the offscreen harness, not from display fps.

**Why:** Saying "120 fps" when the monitor is 60hz is a lie. The bench measures offscreen throughput; the display framerate is whatever the monitor reports.

**How to apply:** Any MTKView setup, any Metal render loop, any fps-related claim in docs or comments.
