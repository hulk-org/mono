---
name: Directory Control app
description: Unified filesystem watcher merging NightWatch+Spiders+clia-tmp+clia-dir; 15 routes, WrkstrmFont, lives in wrkstrm-app alongside Source Control
type: project
---

Directory Control (directory-control-by-wrkstrm) is the unified filesystem watcher app. Bundle: me.rismay.directory-control.

**Why:** Merged 4 predecessors (NightWatch, Spiders, clia-tmp, clia-dir) into one 15-route app with two stores (DirectoryControlStore for scans, CliaDirStore for real-time FSEvents + git hooks).

**How to apply:**
- 15 sidebar routes: Home (Overview, Configuration), Live (Pulse, Tools, Git, Quiet, Feed), Space (Hotspots, Ownership, Sweep Plan, Retention), Hygiene (Naming, Empty Dirs, Symlinks), Operations (Launch Patrol)
- Configuration page split: File Watcher / Git Watcher / App sections
- WrkstrmFont design system throughout
- xcodegen-managed project.yml
- Git Watcher observes commits; Source Control acts on git — link between the two, don't duplicate
- Next: git commit detail in Configuration, deep link to Source Control for actions
- Next: rename CliaDir* types to DirectoryControl* (koma-rename job)
- Next: wire SwiftDirectoryTools into hygiene routes (replace inline scanners)
- Next: add to rismay-substrate.xcworkspace
