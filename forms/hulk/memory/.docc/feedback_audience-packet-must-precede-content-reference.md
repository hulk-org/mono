---
name: audience-packet-must-precede-content-reference
description: "Substrate doctrine — typed audience packet must exist on disk BEFORE any kura-space, route copy, or site content references it. Enforced as a release gate via the site-navigation-graph's dangling-ref annotation."
metadata:
  node_type: memory
  type: feedback
  originSessionId: d6827382-74c6-4bcf-9c0f-eeaa9e6b51c2
---

When authoring website content (kura-space envelopes, route copy, script copy, site copy), the typed audience packet that the content names must already exist at `private/universal/substrate/audiences/<slug>/private/universal/models/<slug>.audience.json` AND the matching `<slug>-audience.organism.json` AND a `.docc/index.md`. References must not precede typed packets.

**Why:** Operator 2026-06-03 mid-website-content-management workstream authoring: "yes... we should always have a release gate or a copywriting step when we author content that we need an audience packet." The first navigation graph run for rismay.me surfaced 10 `dangling-ref` annotations — every kura-space envelope I had drafted referenced an `operator-curious` audience that didn't exist as a typed packet. The graph caught the failure; the operator codified the rule.

**How to apply:**

1. **Before authoring** any new kura-space, route copy, or script copy that names a target audience: verify the audience packet exists at `audiences/<slug>/private/universal/models/`. If it doesn't, STOP and author the packet first.
2. **Packet shape** mirrors `public-visitor` (the canonical exemplar): the `.audience.json` carries `projectedVoice`, `membership`, `decisionModel` (primaryQuestion + readerState + caresAbout + trustChecks + proofOrder + desiredNextAction), `informationBoundary` (public/gated/private/prohibited), `conceptTranslations`, `surfaceRefs`. The `-audience.organism.json` wraps the audience model in the organism schema (IdentityModel v0.6.0).
3. **Release gate**: site-navigation-graph CLI emits `dangling-ref` annotations for any `audience-of` edge whose `to` doesn't resolve to a known audience node. The graph walks `audiences/` dynamically. Wire the gate into pre-commit or release pipeline: `dangling-refs == 0` is a hard block before merge.
4. **Workstream slot**: `website-content-management.formula.workstream.su.json` codifies this gate as the `audience-conformance` state — required to pass before the `review` state can be entered.
5. **Cross-domain rule**: this is substrate-wide, not site-specific. Every site (rismay.me, wrkstrm.com, laussat.studio, clia.us, future) that references audience packets enforces the same gate.

Composes with [[brand-docs-must-reflect-rendered-site]] (parallel doctrine — typed data must reflect what's actually true), [[substrate-typed-discriminator-pattern]] (typed packet uses LinkRef-shaped wire), [[do-not-break-domain-driven-design]] (audience is its own bounded context — sites don't invent ad-hoc audience slugs).
