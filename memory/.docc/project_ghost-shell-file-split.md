---
name: Ghost shell file split plan
description: GhostShellMacApp.swift (1393 lines) needs splitting into 8 files; shared chrome extracted; rest pending
type: project
originSessionId: d053c5da-2b9f-4400-a3f6-4794d7099259
---
GhostShellMacApp.swift is 1393 lines with ~10 types. Partial split started 2026-04-24.

**Done:**
- `GhostShellChrome.swift` — extracted `sectionHeader`, `axisFooter`, `statusDot` helpers

**Remaining extractions from GhostShellMacApp.swift:**
- Lines 13-28 → `GhostShellTypes.swift` (ShellInstance, ConfigurationInstance)
- Lines 30-110 → `GhostRun.swift` (GhostRun, ActiveRun)
- Lines 333-391 → `ShellsSidebar.swift` (ShellsSidebar, ShellRow)
- Lines 393-613 → `ConfigurationsSidebar.swift` (ConfigurationsSidebar, ConfigurationRow, ConfigurationPlayButton)
- Lines 661-816 → `BudgetIndicator.swift` (BudgetHexIndicator, HexagonShape, BudgetActionBanner)
- Lines 822-990 → `RunsDetailPane.swift` (RunsDetailPane)
- Lines 996-1090 → `RunCard.swift` (RunCard — in-process)
- Lines 1098-1339 → `SupervisedRunCard.swift` (SupervisedRunCard — subprocess)
- Lines 1340-1393 → `SharedProcessMetricsPane.swift`

After split, GhostShellMacApp.swift keeps only the @main App struct (lines 112-329).

**Why:** Preparing for v2 architecture with tree-explorer sidebar (Single / Adversarial sections).

**How to apply:** Extract each range into its own file with `import SwiftUI` + any needed imports. Remove the shared chrome helpers from GhostShellMacApp.swift (now in GhostShellChrome.swift). Build after each extraction to catch missing imports.
