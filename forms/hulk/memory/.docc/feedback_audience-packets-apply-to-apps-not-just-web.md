---
name: audience-packets-apply-to-apps-not-just-web
description: "App UI text is CONTENT, not chrome — must come from typed audience packets + lens-packet rendering, sibling pattern to web. Inline Swift-literal Text(\"...\") is the substrate-doctrine bypass. (operator-named 2026-06-04)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# Audience packets apply to apps, not just web

**Rule**: Every user-facing string in every substrate App MUST come from a typed audience packet (sibling pattern to web's existing audience-packet doctrine), rendered through a lens-packet layer that resolves substrate-doctrine `[[citations]]` + applies localization + applies audience-projection (verbose vs terse, operator-self vs first-time-operator, locale-A vs locale-B). Inline `Text("string literal")` calls in SwiftUI views are the substrate-doctrine bypass — same failure class as hardcoded `Font.system(...)` + `Color(red:green:blue:)` literals were before the substrate-modern token migration.

**Why**: Operator-attested 2026-06-04 mid-Launch-Review-onboarding-visual-verification, with a screenshot showing the substrate-doctrine memory slug `[[substrate-modern-composition-checklist-is-required-spawn-software-proof-gate]]` rendering LITERALLY with brackets in user-facing onboarding body text. Operator quote: *"so you are not using audience packets for apps like we do for web! wooo, we now know what to do and how to localize them."*

The visible bug (literal `[[...]]` brackets in UI) is the symptom; the structural cause is treating app UI text as Swift-string-literal chrome rather than as audience-packet-projected CONTENT. The substrate's typed-everything investment for web (audience-first-workflow + audience-projection + lens-packet) has been silently skipped at the app layer.

Substrate-canonical reasons that compose:

- **Localization** per [[Never compose multi-token user-facing strings via Swift interpolation]] + [[AppStore.SupportedLocale lives in LocalizeCore]] — every user-facing string must be locale-projectable; Swift-literal Text() is the failure mode
- **Doctrine-citation resolution** — `[[slug]]` in agent-facing typed records ≠ same in user-facing UI; user-facing projection must resolve to link OR strip to plain term OR expand to inline explanation, depending on lens
- **Audience projection** per [[audience-projection-pattern]] — same source content projects differently for different audiences (first-time-operator gets verbose; returning-operator gets terse; agent-as-audience gets agent-facing typed records)
- **Per [[audience-packet-must-precede-content-reference]]** — typed audience packet must exist on disk BEFORE any kura-space / route / site content references it. App UI text is content; therefore must reference a typed packet
- **UXW department ownership** per [[uxw-department]] — UX writing is the substrate department that owns the audience-projection pipeline; app UI text falls under their typed contract
- **Lens packet sibling** per [[Lens packet — substrate vocabulary for rendered sublens output]] — every rendered artifact from substrate-typed data via a sublens is a Lens Packet; app UI rendering IS a lens packet emission
- **Force-articulation discipline** — typed packets force the author to think about audience + projection + localization at authoring time rather than at translation-emergency time

**How to apply** (substrate-canonical architecture):

1. **Audience-packet schema family** for app UI text — author at `schema-universal/.../audience-packet-app-ui-schemas/v0.1.0/`. Each packet carries: surface-slug (e.g. `launch-review.onboarding.token-system-page`) + audience-class (first-time-operator / returning-operator / agent-as-audience) + locale + verbose-or-terse variant + body content (with `[[doctrine-ref]]` first-class) + doctrine-citation render-mode (link / strip / inline-expand)

2. **Lens-packet renderer** — Swift view modifier or environment-injected resolver that walks an audience-packet ref, picks the locale + variant, resolves `[[citations]]` per the packet's render-mode policy, returns rendered SwiftUI content. Sibling to the WrkstrmDesignTokenService pattern (injected at root + consumed by views).

3. **App view layer migration** — every `Text("string literal")` in SwiftUI views becomes `Text(audiencePacket: .someSlug)` (or equivalent ergonomic API). View doesn't author content; view PROJECTS the packet.

4. **Typed packet authoring discipline** — packets live at the app's content tree (e.g., `launch-review/private/universal/audience-packets/onboarding/token-system-page.audience-packet.json`). Authored by UXW department; consumed by view layer.

5. **Substrate-modern-composition-checklist UPDATE** — the 7-item checklist gains an 8th item: AUDIENCE-PACKET-DRIVEN APP UI TEXT. Every spawn-software workstream must answer this now.

**Anti-pattern caught**: rendering substrate-doctrine `[[slug]]` brackets literally in user-facing UI text. The brackets are agent-memory notation, not user-content notation. The lens-packet renderer's doctrine-citation-render-mode is the typed answer.

**Composes with**: [[audience-first-workflow-public-pages]] + [[audience-projection-pattern]] + [[Lens packet — substrate vocabulary for rendered sublens output]] + [[audience-packet-must-precede-content-reference]] + [[Never compose multi-token user-facing strings via Swift interpolation]] + [[AppStore.SupportedLocale lives in LocalizeCore]] + [[uxw-department]] + [[substrate-modern-composition-checklist-is-required-spawn-software-proof-gate]] (sibling extension — audience-packet-driven UI is the 8th checklist item) + [[data-is-one-thing-rendering-is-projection]] (axiom this directly enacts at the UI layer).

**Substrate-evolution moment**: this recognition extends substrate's typed-everything-from-web-down architecture to the app layer. Web has had it; apps haven't. Operator caught the gap at the EXACT moment the substrate's typed records leaked into user-facing surface — the visible doctrine-citation bracket bleed-through is the kind of bug that makes the architecture gap legible.
