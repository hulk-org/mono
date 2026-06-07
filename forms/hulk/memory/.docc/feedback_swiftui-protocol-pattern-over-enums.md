---
name: swiftui-protocol-pattern-over-enums
description: Avoid closed enums for extensibility surfaces; prefer SwiftUI-style protocol/extension patterns (View/ViewModifier/EnvironmentKey-shaped) so new kinds can be added by downstream packages without editing the source-of-truth file.
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
For surfaces that name a *kind* people will want to add to over time
(execution targets, work surfaces, orchestrators, worker targets, transition
reasons, etc.), avoid closed `enum`s. Prefer SwiftUI-style protocol patterns.

**Why:** Enums look clean but they always need updating. Every new kind
forces a source edit in the schema package, a version bump, a submodule
commit, a pointer bump, and a coordinated update across all consumers that
exhaustively switch on the enum. SwiftUI never models its extensibility
surfaces this way — `View`, `ViewModifier`, `Layout`, `PreferenceKey`,
`EnvironmentKey` are all protocol/key surfaces that downstream packages can
extend without editing the framework. The user has been explicit:
"it's not cool to use enums. They seem fine, but they always need updating.
the SwiftUI patterns are way better."

**How to apply:**
- New extensibility surfaces: model as a protocol with a stable
  string-keyed identifier + capability methods. Conforming types can live
  in any package. Encoding goes through the identifier; decoding looks up
  via a registry keyed by identifier.
- Closed sets that genuinely never grow (lifecycle terminal vs active state
  buckets, true booleans, retry kinds with mathematically defined
  backoff curves) can stay as enums — the test is "do downstream packages
  ever need to add a case?" If yes → protocol. If no → enum is fine.
- Existing enum surfaces: when adding a case is needed in the short term,
  add it (don't block delivery), but flag the addition as evidence the
  surface should be refactored to protocol shape. Each new case grown into
  a closed enum is a vote against the pattern.
- When proposing new schema types: lead with the protocol shape; only fall
  back to enum if the closed-set test passes.
