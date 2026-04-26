---
name: Inference Metrics NERV state management
description: hex badge state machine needs Cadence review — loading/standby/online/offline states, poll timeout transitions
type: project
originSessionId: b4c9d58c-0196-4bd0-9c5d-e4accca62e6b
---
The NERV hex badges in inference-metrics need proper state management for provider poll lifecycle: STANDBY → LOADING → ONLINE → OFFLINE. Current implementation is ad-hoc with boolean isLoading. Cadence (/sync) should review and formalize the state machine — transitions, timeouts (offline after N failed polls), retry backoff.

**Why:** hex badges show stale "STANDBY" indefinitely if a provider never responds; need explicit OFFLINE after timeout so the pilot knows the unit is unreachable, not just waiting.

**How to apply:** next session with Cadence, bring up inference-metrics hex badge states as a state management task.
