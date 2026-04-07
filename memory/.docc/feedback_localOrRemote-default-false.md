---
name: localOrRemote useLocalDeps must default to false
description: In substrate Package.swifts using localOrRemote toggles, useLocalDeps must default to false. Only flip true on explicit truthy SPM_USE_LOCAL_DEPS values. Never invert.
type: feedback
---

In rismay's substrate, every Package.swift that uses the `localOrRemote` toggle pattern must default `useLocalDeps` to **false**, and only return **true** when `SPM_USE_LOCAL_DEPS` is explicitly set to a truthy value (`1`, `true`, `yes`, `on`).

**Why:** I tried flipping the default to `true` (defending it as "substrate is local-first") to fix a build issue. The user corrected me sharply: that's the wrong direction. The downstream contract is "remote by default, local only when explicitly opted in", and inverting it changes resolution semantics for every consumer that doesn't opt in.

**How to apply:**
- Never flip `useLocalDeps` default from `false` to `true`.
- The canonical pattern is:
  ```swift
  let useLocalDeps: Bool = {
    guard let raw = ProcessInfo.processInfo.environment["SPM_USE_LOCAL_DEPS"] else { return false }
    let v = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return v == "1" || v == "true" || v == "yes" || v == "on"
  }()
  ```
- If a build needs local deps, the right move is to set `SPM_USE_LOCAL_DEPS=1` in the calling environment (or fix whatever is preventing the env var from propagating to SPM manifest evaluation), not to invert the default.
- If you've already inverted defaults, revert immediately.
