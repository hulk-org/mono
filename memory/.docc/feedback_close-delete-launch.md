---
name: Close, delete, then launch
description: When testing app changes, always quit the running app, delete the .app bundle, rebuild, then launch — never relaunch over a stale binary
type: feedback
---

When verifying app changes: quit the running app, delete the old .app from DerivedData, rebuild, then launch. Relaunching over a stale binary masks whether the fix actually landed.

**Why:** Stale binaries in DerivedData can persist old behavior even after a successful build, especially with incremental builds.

**How to apply:** Every time I rebuild an app to test a fix, follow the close → delete → build → launch sequence.
