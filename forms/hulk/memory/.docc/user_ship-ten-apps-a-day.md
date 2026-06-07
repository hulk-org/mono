---
name: Ship 10 Apple apps a day via FoundationModels spine
description: Scale target and architecture thesis for rismay's Apple shipping loop — batch tool backed by Apple's FoundationModels framework, not a Claude Code session
type: user
---

rismay's operational target for Apple app shipping is **roughly 10 apps per day** via a single automated tool running on the operator's Mac. This is the load-bearing constraint behind any "Foundry productionization" work for Apple releases.

Two corrections to my earlier mental model, both important:

1. **"Foundation session" in rismay's workspace means Apple's `FoundationModels` framework**, not a Claude Code sub-session or a generic LLM API. The judgment layer of the shipping loop runs on-device via `LanguageModelSession` + `@Generable` structured output. This collapses the spine + session into one Swift binary — no out-of-process handoff, no JSON round-trip, no API cost, offline, ~100ms-1s per call.

2. **The scale target rewrites the operator-attention budget.** At 1 app/day the design can afford "operator confirms each copy draft." At 10/day the budget is ≤90 sec of operator attention per app, spent on glancing at novelty-flagged drafts and approving the final ship-run report. Everything else — disclaimer blocklist, sibling-permission table, hardcoded-CFBundleVersion trap, path-scoped git commits, codex-sessions push guard — must be **invariants enforced in Swift before the session ever runs**, not advisory prompts to the model.

Consequences for how I should approach any shipping automation request:

- Default to a **batch tool shape** (`swift-ship-apple-app-cli` plural, registry-driven, `ship-all` as endgame), not single-app scripts.
- Use `@Generable` Swift types for every judgment the FoundationModels session makes; post-validate every field in Swift before writing anything to disk.
- Assume Apple Silicon Mac + macOS 26+ + Xcode 26+ as the execution substrate.
- Treat disclaimer strings, sibling permissions, and packaged-plist-vs-source-plist divergence as hard invariants, not soft guidance.
- Design for a brand-identities registry (`brand-identities/<bundle-id>.brand.json`) that lists apps in scope; assume per-app metadata is read from there, not hardcoded.
- Serial `xcodebuild archive` is the expected critical path at ~30 min wall clock for 10 apps; that's acceptable for a daily run.

**Why:** Established 2026-04-08 during the clia-day-ios (Today) ITMS-90683 remediation session, after I proposed a Claude Code sub-session architecture in a Foundry investigation and rismay corrected the framing. The 40-minute manual loop for one app, scaled to 10, would consume an entire workday — unacceptable. The full design rationale lives at `private/.wrkstrm/foundry/investigations/apple-app-release.investigation.md` (which needs a §10 update reflecting this thesis).

**How to apply:** Whenever rismay asks to "automate" or "productionize" Apple shipping, default to the batch-tool + FoundationModels spine architecture. Don't propose Claude Code sub-sessions or out-of-process JSON handoffs unless explicitly asked to. Don't design for single-app shipping unless explicitly asked to. When in doubt about an operator-attention cost, assume the 10-apps/day budget and cut accordingly.
