---
name: Port means expand not simplify
description: When porting code from one app to another, preserve ALL features and expand; never simplify or drop functionality
type: feedback
---

When porting/merging code from one app to another, preserve ALL existing features and expand. Never simplify or drop functionality during a port.

**Why:** The user expects the successor app to be strictly better than the source. Dropping sidebar actions, inspector panels, summary cards, or selection state during a port means the new app is a regression, not a graduation.

**How to apply:** Before porting, list every feature/view/interaction in the source. After porting, verify each one is present in the destination. Add new features on top — never subtract.
