---
name: Never compose multi-token user-facing strings via Swift interpolation
description: Use String(localized:) with interpolation inside the localizable key so per-locale translations can rearrange tokens via positional placeholders (%1$@, %2$@); applies fleet-wide to every substrate app
type: feedback
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
When building a user-facing string from multiple parts, **never** use Swift
string interpolation to compose them directly:

```swift
// BAD — hardcodes English subject-verb-object order
.accessibilityLabel("\(hello) \(world)")
let title = "Posted by \(user)"
let status = "\(count) items in your \(name) cart"
```

The Swift `"\(...)"` syntax produces a `String` of the *English* concatenation.
Per-locale translation cannot rearrange the tokens because the composition
happens at the Swift call site, not in the localization layer.

**The substrate-doctrinal pattern** is `String(localized:)` with interpolation
**inside** the localizable key, OR `Text(...)` / `LocalizedStringKey(...)`
when the surface accepts those types directly:

```swift
// GOOD — format string is one localizable unit; per-locale entries can
// rearrange via positional placeholders (%1$@, %2$@, ...).
.accessibilityLabel(Text("\(hello) \(world)"))
let title = String(localized: "Posted by \(user)",
                   comment: "Attribution line on a post; %@ = user display name")
let status = String(localized: "\(count) items in your \(name) cart",
                    comment: "Cart status; %1$lld = item count, %2$@ = cart name")
```

The `.xcstrings` entry for each format then carries per-locale translations:
- `en` → `"%1$lld items in your %2$@ cart"`
- A language that flips → `"%2$@ cart の中に %1$lld 個のアイテム"` (rearranged)

**Why:** token order varies across languages — Japanese / Hungarian / Chinese
put many constructions in different order from English; some languages have
particles, agreement-suffixes, or honorifics that interleave with the
substantive tokens; case agreement may change. Hard-coding the order in
Swift makes those translations either grammatically wrong or impossible.

**How to apply:**
- Audit every `"\(...) \(...)"` pattern in UI text and convert to a single
  `String(localized:)` or `Text(...)` with interpolation inside.
- For `Text` view bodies, prefer the literal-string-as-`LocalizedStringKey`
  form: `Text("Hello \(name)")` — SwiftUI auto-resolves the format key.
- For `accessibilityLabel`, the bare String overload is NOT auto-localized
  — wrap in `Text(...)` or `LocalizedStringKey(...)` to force the
  localizable overload.
- Always include `comment:` describing the token roles so translators know
  which `%@` is which.

**For the substrate-fleet shipping target:** every new app should follow
this doctrine. Combined with `STRING_CATALOG_GENERATE_SYMBOLS=YES` for
type-safe key references, the substrate gets fleet-wide
typo-and-token-order safety for free.

**Hello World note:** the specific case
`.accessibilityLabel("\(hello) \(world)")` is mostly hypothetical for this
demo — Hello + World as two-token compositions don't have idiomatic order
flips across our 7 verified locales. But the doctrinal pattern still
applies because the substrate is templating future apps.
