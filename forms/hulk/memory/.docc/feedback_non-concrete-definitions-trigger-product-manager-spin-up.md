---
name: non-concrete-definitions-trigger-product-manager-spin-up
description: "When a typed primitive's definition is non-concrete (abstract / implicit / under-specified), the substrate-canonical response is to SPIN UP A PRODUCT MANAGER — a typed PM role record that owns concretizing the definition. Step 2 of the component-bug doctrine. Operator-named 2026-06-04."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

# Non-concrete definitions trigger product-manager spin-up

**Rule**: When a substrate typed primitive (component, schema family, doctrine, address-taxonomy, style-definition) has a NON-CONCRETE definition — abstract, implicit, under-specified, or missing — the substrate-canonical response is to SPIN UP A TYPED PRODUCT MANAGER ROLE. Filing the bug at the component's home (per `[[component-bugs-file-at-component-home-not-consumer]]`) is step 1; if the bug exposes a missing-concrete-spec, spinning up a PM is step 2.

**Why**: Operator-attested 2026-06-04 mid-Launch-Review component-bug-filing session — *"if a definition is not concrete, we need to spin up a product manager."* Caught me about to file 5 component bugs without recognizing that some of them (e.g., "WrkstrmDesignTokenService bridge to substrate-canonical gloss-white + jet-black themes") expose ABSTRACT definitions that no maintainer can resolve without PM-driven concretization. The bug ticket alone names the gap; the PM role ticket OWNS resolving "what does the concrete spec actually look like?"

Substrate-doctrine reasons that compose:

- **Substrate sequence position 1 is Design + Product** per `[[design-and-product-first-code-last]]` — design + product work IS PM work; abstract primitives missing P1 work need PM to backfill it
- **Walter-discipline applied to definitions** per `[[walter-discipline]]` — substrate refuses rolled-own primitives; symmetrically, substrate refuses abstract typed-primitives. Concrete spec is part of the substrate-canonical primitive definition
- **Roles are typed substrate records** per existing role-surface-manifest.json schema — PMs are first-class typed substrate identities; spinning one up means authoring a typed role record, not just naming a person
- **Component bugs that reveal abstract definitions are TYPED RECORDS pointing at a missing TYPED-ROLE** — bug ticket carries `requiresProductManagerSpinUp: true` field referencing the PM role-surface-manifest the substrate needs to author
- **Substrate's typed-everything investment refuses doctrine-by-attestation** — substrate-canonical primitive needs concrete-spec-via-typed-record; PM-owned concretization is how abstract becomes concrete

**How to apply**:

When filing a component bug per `[[component-bugs-file-at-component-home-not-consumer]]`, ask:

> Does this bug expose a NON-CONCRETE definition?

Symptoms of non-concrete definitions:
- Bug description has to reach for "I think it should..." or "presumably..." language
- The fix is unclear because the underlying concept is unclear
- Multiple reasonable resolutions exist with no canonical guidance
- The component primitive's design intent is implicit (not in a typed PRD / design-truth-packet / axiom)
- Consumer pattern reveals divergence (different consumers handle the gap differently)
- Substrate's typed-record corpus has zero PRD for the component

If ANY of these apply, the substrate-canonical move is to file:
1. The component bug (per the prior doctrine) — at `<component-home>/agenda/beads/`
2. A typed PM role-surface-manifest at `substrate/roles/<component>-product-manager/<slug>-product-manager.role-surface-manifest.json`
3. An assignment record per `[[Assignments live in collective org Kura]]` at `wrkstrm-components/private/universal/kura/assignments/<role>-<agent>/`
4. A position-1 design-truth-packet at the component's spawn-software workstream home (or shared spawn-software/instances/)
5. The bug references the PM via `requiresProductManagerSpinUp: true` + `productManagerRef: LinkRef`
6. The PM owns driving the typed PRD (position 2) + CUJ (position 3) per the substrate sequence

**The PM-spin-up handoff sequence**:

```
1. Consumer hits component gap
2. File typed bug at component's agenda/beads/ (component-bugs doctrine)
3. If bug exposes non-concrete definition:
   a. Spin up typed PM role-surface-manifest
   b. Assignment at wrkstrm-components/.../kura/assignments/
   c. Position-1 design-truth-packet authored by PM
4. PM owns sequence positions 1-3 (Design+Product → PRD → CUJ)
5. Component maintainer (or AI agent) executes positions 4-7 (Bug+Epic → Code → Audience Review → QA → Launch)
6. Consumer's local bead resolves when the typed PRD lands at the component
```

**Catches this session that need PM spin-up**:

1. `WrkstrmDesignTokenService` bridge to `gloss-white` + `jet-black` substrate-canonical themes — non-concrete: what's the canonical semantic-address taxonomy? what makes a theme "substrate-canonical"? how do app-style identities inherit + extend? — PM spin-up needed
2. `wrkstrm-font` canonical typography role semantics — non-concrete: when do consumers use `.label` vs `.caption` vs `.bodyStrong`? what defines "magazine-editorial serif voice" as a canonical preset? — PM spin-up needed
3. `WrkstrmOnboardingTypography` — non-concrete: should `.sans` be a case? what are the canonical typography presets onboarding flows support? — PM spin-up needed
4. `wrkstrm-gloss` macOS 26.0 minimum — likely CONCRETE (just verify intent + document rationale); no PM needed
5. Audience-packet-app-ui schema family (separate substrate-evolution bug) — non-concrete: schema family doesn't exist yet; PM spin-up is mandatory; this whole architecture needs P1 design-truth-packet authored by typed PM

**Composes with**: [[component-bugs-file-at-component-home-not-consumer]] (the parent doctrine — this is step 2 escalation) + [[design-and-product-first-code-last]] (PM owns positions 1-3 of substrate sequence) + [[walter-discipline]] + [[feedback-common-and-mono-are-the-platform-engineers]] (platform engineering needs PM-owned spec) + [[capture-requires-typed-workflows-and-roles-not-just-memory]] (PM spin-up IS typed role + assignment + workflow records) + [[Assignments live in collective org Kura]] (assignment home discipline).
