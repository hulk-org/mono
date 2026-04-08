---
name: Direct deps over transitive bundling
description: SPM consumers must depend on the narrow source-of-truth package for each import, never on a bundled super-package that re-exports many things
type: feedback
---

When proposing where a Swift library or product should live, do NOT bundle multiple distinct concepts into one "support" or "kitchen-sink" package just because they're conceptually related. Each consumer's `Package.swift` should declare a direct dep on the focused package that originates each import, not transitively pull through a fat boundary.

**Why:** During the clia-agent-cli deletion work, I proposed consolidating `CLIAAgentCoreCLICommands` into `swift-agent-cli-support` "alongside `CLIAAgentCore`" so the launchpads would have one place to import from. The user pushed back: *"why can't those launchpads depend on what they need? this is exactly why transitive deps are bad"*. The point: when launchpad → `clia-agent-cli` (fat package) bundles many products, killing or restructuring `clia-agent-cli` ripples through every consumer because they were depending on it as a unit, not on each thing it contained. If each consumer declares a direct dep on the source-of-truth package for each import, restructuring is local.

**How to apply:** When migrating consumers between packages, look at each `.product(...)` import line individually. For each one, find the smallest, most focused package that originates that product, and have the consumer depend on it directly. Don't propose intermediate bundlers ("move them all into X support") even if it would shrink the dep count — a smaller dep list via bundling is the anti-pattern, not the goal. The substrate's `schema-universal` layout (one schema family per package — e.g., `agency-schemas-v000-005-000`, `backlog-item-schemas-v000-001-000`) is the canonical pattern: many narrow packages, consumers pick exactly what they need.
