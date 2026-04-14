---
name: Add Xcode targets yourself
description: Never ask the user to manually add Xcode targets or configure projects — do it programmatically
type: feedback
---

Never ask the user to manually add Xcode targets, configure build settings, or wire things in Xcode. Do it yourself by editing the pbxproj or using tooling.

**Why:** The user expects Claude to handle all mechanical work, including Xcode project configuration.

**How to apply:** Edit project.pbxproj directly, or use available tooling to add targets, set build settings, add dependencies, and configure Info.plist paths.
