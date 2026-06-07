---
name: Never trash data under investigation
description: Never delete/trash data that's actively being investigated; build the inspection tool first, then let the operator decide
type: feedback
---

Never trash data that's actively being investigated or that the user wants to study. Build the inspection tool first, then let the operator decide what to delete.

**Why:** Trashed the 126GB Claude Code sandbox runaway before building Session Lab's Sandbox Telemetry panel to inspect it. The data was gone by the time the tool was ready. Investigation data is irreplaceable.

**How to apply:** When the user says "we should look at that" or "study it," that means BUILD THE TOOL FIRST. Do not offer to clean up. Do not trash on confirmation. Wait until the operator has inspected the data through the tool and explicitly says "delete this specific thing."
