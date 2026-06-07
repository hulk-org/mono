---
name: component-bugs-file-at-component-home-not-consumer
description: "When a consumer finds a gap in a substrate-canonical component (wrkstrm-font, wrkstrm-color, wrkstrm-gloss, WrkstrmDesignTokenService, WrkstrmOnboarding, etc.), the typed bug ticket files at the COMPONENT's agenda/beads/, not at the consumer's agenda. Platform engineers (component maintainers) own the gap. (operator-named 2026-06-04)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# Component bugs file at the component's home, not the consumer's agenda

**Rule**: When a substrate consumer (app, downstream package) finds a gap in a substrate-canonical component (`wrkstrm-font`, `wrkstrm-color`, `wrkstrm-gloss`, `WrkstrmDesignTokenService`, `WrkstrmOnboarding`, etc.), the TYPED BUG TICKET files at the COMPONENT's `agenda/beads/<slug>.issue.json`, NOT at the consumer's agenda. The platform engineer (component maintainer) owns the gap; the consumer references the typed bug from their own bead. Substrate doctrine: bugs follow ownership.

**Why**: Operator-attested 2026-06-04 mid-Launch-Review test-coverage session — *"I remember that if we find a bug in a component - we need to file a bug for that component."* Caught me silently bypassing this all session: I noted `wrkstrm-font lacks serif preset` in Presense's PRD Q-001 + my own audit notes, `WrkstrmOnboarding lacks .sans typography preset` when I tried to use it (BUILD FAILED), `wrkstrm-gloss requires macOS 26.0` (forced launch-review's deployment-target bump), `WrkstrmDesignTokenService` doesn't bridge `AppleGlossWhiteTheme` + `JetBlackTheme` (the substrate's canonical standard themes per LaunchReviewRelease.checklist). I filed NONE of these as typed bugs at the components' homes; I bead-tracked them at the consumer's agenda + inside my Memory entries.

Substrate-doctrine reasons that compose:

- **Platform engineers own the gap** per [[feedback-common-and-mono-are-the-platform-engineers]] — common + mono are platform engineering; when consumers hit a platform gap, the platform team needs the typed bug to triage + resolve. Bead-tracking only at the consumer hides the gap from the platform team.
- **Walter-discipline applies symmetrically** per [[walter-discipline]] — substrate refuses rolled-own primitives; symmetrically, substrate refuses gap-hiding at consumer level. If the platform primitive has a gap, file there.
- **Bug-graph follows ownership-graph** — substrate's typed-everything investment includes typed bug records that compose with typed identity records (operator-identity → app-identity → package-identity → component-maintainer-identity). Bugs SHOULD flow up the ownership graph, not stay at the consumer's local agenda.
- **Substrate-canonical contribution-back pattern** per [[wrkstrm canonical one-liner — app studio for creators]] + the platform engineering doctrine — consumers find gaps; contributors send typed PRs (bug + fix + test); platform team integrates. The typed bug AT THE COMPONENT'S HOME is the substrate-canonical first step of contribution-back.

**How to apply**:

- When a consumer (app or downstream package) finds a substrate-canonical component gap, file `<component-home>/agenda/beads/<gap-slug>.issue.json` with:
  - `reporter` = the consumer + the operator
  - `sourceQuote` = the operator's catch OR the consumer's failure mode (compile error, build failure, runtime behavior)
  - `affectedConsumer` = LinkRef to the consuming app/package where the gap surfaced
  - `proposedFix` = concrete typed proposal (new preset, new API, new bridge, deployment-target adjustment)
  - Standard substrate bug-ticket fields (priority + severity + labels + composesWith)
- The CONSUMER's local bead (if it needs one) REFERENCES the component bug via LinkRef, not duplicates the description.
- For SUBSTRATE-WIDE evolution (e.g., new schema family, new Swift package), file at the appropriate substrate-shared home (schema-universal, wrkstrm-components, etc.) — not just at the first consumer's agenda.

**Component homes for typical substrate primitives**:

- `wrkstrm-font` → `wrkstrm-components/private/primitives/wrkstrm-font/agenda/beads/`
- `wrkstrm-color` → `wrkstrm-components/private/primitives/wrkstrm-color/agenda/beads/`
- `wrkstrm-gloss` → `wrkstrm-components/private/gloss/macos/spm/wrkstrm-gloss/agenda/beads/`
- `WrkstrmOnboarding` → `wrkstrm-components/private/onboarding/spm/wrkstrm-onboarding/agenda/beads/`
- `WrkstrmDesignTokenService` → `wrkstrm-components/private/design-token-service/agenda/beads/`
- `WrkstrmCatalogCards` (gloss-white + jet-black themes) → `wrkstrm-components/private/catalog-cards/spm/wrkstrm-catalog-cards/agenda/beads/`
- Substrate-shared schema families → `schema-universal/<area>/<family>/agenda/beads/` if pattern + family exist; otherwise lift to substrate-shared
- Substrate-shared workstream evolution (e.g. new spawn-software stage) → axiom file at `kura-spaces/axioms/<slug>.axiom.su.json` + workflow files

**Catches this session that violated the doctrine**:

1. `wrkstrm-font` lacks serif preset matching magazine-editorial voice — caught in Presense PRD Q-001 + my audit; should have filed at `wrkstrm-font/agenda/beads/missing-serif-preset.issue.json`
2. `wrkstrm-font` lacks tiny-caps role for 8pt black mono — caught in Presense's font-migration analysis; should have filed at `wrkstrm-font/agenda/beads/missing-tiny-caps-role.issue.json`
3. `WrkstrmOnboardingTypography` lacks `.sans` case — caught at compile time when I tried it; should have filed at `WrkstrmOnboarding/agenda/beads/missing-sans-typography-preset.issue.json`
4. `wrkstrm-gloss` requires macOS 26.0 — forced launch-review's deployment-target bump from 15.0 → 26.0; verify intentional or relax; file at `wrkstrm-gloss/agenda/beads/macos-26-0-minimum-deployment-target.issue.json`
5. `WrkstrmDesignTokenService` doesn't bridge `AppleGlossWhiteTheme` + `JetBlackTheme` substrate-canonical themes — `LaunchReviewRelease.checklist` says "gloss-white + jet-black are required but not bound in the app" — bridge is the substrate-canonical missing piece; file at `WrkstrmDesignTokenService/agenda/beads/bridge-canonical-themes-gloss-white-jet-black.issue.json`

**Composes with**: [[feedback-common-and-mono-are-the-platform-engineers]] + [[walter-discipline]] + [[substrate-modern-composition-checklist-is-required-spawn-software-proof-gate]] + [[feedback-issue-found-means-entire-spawn-software-rerun]] + [[audience-packets-apply-to-apps-not-just-web]] (same axis — substrate-architecture work goes where the primitive lives) + [[data-is-one-thing-rendering-is-projection]] (bug is one thing — local downstream bead is the projection).
