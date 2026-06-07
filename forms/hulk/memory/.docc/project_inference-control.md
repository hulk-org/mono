---
name: Inference Control app
description: inference-metrics renamed to Inference Control; joins Source Control + Directory Control in the wrkstrm control family
type: project
originSessionId: b4c9d58c-0196-4bd0-9c5d-e4accca62e6b
---
Inference Metrics is now **Inference Control**. Part of the wrkstrm "control family" alongside Source Control and Directory Control.

Display name updated in: AppIdentity, Info.plist (both targets), header, menubar popover.

Bundle ID stays `me.rismay.inference-metrics` and directory stays `inference-metrics/` for now — deeper slug/bundle rename is a separate task.

**Why:** consistent product family naming — all wrkstrm system-monitoring apps are "[Domain] Control."

**How to apply:** use "Inference Control" in all user-facing strings. Internal type names (`InferenceMetrics*`) can migrate later.
