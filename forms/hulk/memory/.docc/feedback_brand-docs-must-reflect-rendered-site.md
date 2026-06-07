---
name: brand-docs-must-reflect-rendered-site
description: "Substrate brand-identity docs (`<slug>.brand.su.json`) must accurately reflect what the typed renderer would emit. Audit each brand-doc field against the live site before driving renderer from it."
metadata:
  node_type: memory
  type: feedback
  originSessionId: d6827382-74c6-4bcf-9c0f-eeaa9e6b51c2
---

When wiring a typed renderer to consume `<slug>.brand.su.json`, audit the brand-doc fields against the rendered site BEFORE writing any code that reads them. Fields that misrepresent the live site (e.g. wrong `titleHeading`, missing `palette`, missing axis taxonomy) will cause the typed-renderer output to look nothing like the existing site.

**Why:** Operator pushback 2026-06-03 mid-rismay.me v2 wiring: "this looks nothing like the public site though..." + "our brand docs should be updated to be rismay.me still if necessary. be very SPECIFIC." A typed renderer is only as honest as the typed data it reads; brand docs that drifted from the actual rendered visual identity cause the renderer to produce a stranger's site, not the operator's site.

**How to apply:** Before the typed renderer reads `<slug>.brand.su.json` to drive HTML output, run a per-field audit:

1. **MUST-UPDATE fields** — anything where the brand-doc value contradicts visible text on the live site. For rismay.me v2 (2026-06-03): `metadata.titleHeading: "Personal Brand"` was the contradiction — appears nowhere on rismay.me; wordmark is "rismay.me", footer says "rismay.me / axis gallery". Such fields actively mislead the renderer.

2. **SHOULD-ADD fields** — typed clusters the renderer needs but the brand doc lacks. For rismay.me v2: (a) `metadata.palette` carrying typed `ColorSourceModel` entries per era role (era-maps/era-jpm/era-prep/era-wrkstrm-zero/era-wrkstrm-one), each with the real OKLCH values from the existing CSS (`oklch(58% 0.2 148)` for era-maps primary, etc.); (b) typed `axes` taxonomy (the 4-axis IA: blog-axis / institutional-axis / speedruns-axis / about-me-axis with accession codes AX-0001..AX-0004) so the renderer can read axis nav from data instead of hardcoded Swift.

3. **LEAVE-AS-IS fields** — already correct or aspirational. For rismay.me: `id`, `name`, `brandFamily`, `pageImages`, `coreIdentity`, `publicPresence.publicBrandedUrl`, `topics.identitySystem.elements` (12 design-system surfaces as the brand-system roadmap), `topics.explorations.items`.

4. **DECIDE fields** — semantic mismatches that aren't strictly wrong but aren't aligned. For rismay.me: `mission` and `vibe` describe a brand-design-practice persona while the rendered site is an institutional-timeline projection. Decide whether to tighten them or accept that brand-doc and site serve different purposes.

The audit yields a concrete commit list: edits to brand-doc → renderer update to read new fields → re-render → visible difference. Without the audit step, the typed renderer either fails to render correctly OR renders incorrectly with confidence (both bad).

Composes with [[substrate-typed-discriminator-pattern]] (typed palette uses ColorSourceModel discriminator), [[do-not-break-domain-driven-design]] (brand-doc is bounded context for brand-identity, not site-content), [[operator-intuition-is-substrate-truth-ahead-of-articulation]] (operator caught the gap before I did by visually comparing).
