---
name: clia-mem app live
description: clia-mem is now a substrate memory browser (was Codex sessions browser); session cleanup functionality moved to session-lab in wrkstrm-app
type: project
---

**clia-mem** pivoted from Codex sessions browser to substrate memory browser on 2026-04-13.

- **Location**: clia-app-org/private/apple/apps/clia-mem/
- **Bundle**: me.rismay.clia-mem
- **Pattern**: @Observable + @State (same as egm-compendium)
- **Scans**: substrate/{agents,collectives,operators,harnesses}/*/memory/.docc/ (+ compat fallbacks)
- **Identity probing**: reads *.identity.json for schemaVersion, schemaSetRef, displayRole, status, updated

Session cleanup functionality (the original clia-mem) was copied to **session-lab** in wrkstrm-app with type prefix SessionLab and bundle me.rismay.session-lab.

**Why:** clia-mem's name implies memory, not sessions. The session cleanup work is a wrkstrm product concern, not clia-specific.

**How to apply:** clia-mem = memory browser. session-lab = session cleanup. Don't conflate them.
