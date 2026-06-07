---
name: localization-never-outruns-audience-review
description: "Audience passes happen before localization, and rendered locale surfaces are reviewed twice: source-first, render-second. This memory is a downstream pointer to the typed workflow/role/axiom repair."
metadata:
  node_type: memory
  type: feedback
---

**Typed-record canonical truth**: this failure is now captured in typed substrate records, not just memory.

- Axiom: `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/localization-never-outruns-audience-review.axiom.su.json`
- Gate workflow: `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/workflows/localized-public-surface-release-gate/v0.1.0/localized-public-surface-release-gate.workflow.json`
- Repaired pipeline: `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/workflows/audience-aware-content-pipeline/v0.2.0/audience-aware-content-pipeline.workflow.json`
- Review role surface: `private/universal/substrate/roles/launch-review-audience-approver/private/universal/identity/launch-review-audience-approver.role-surface-manifest.json`
- Review role workflow: `private/universal/substrate/roles/launch-review-audience-approver/private/universal/agenda/role-workflows/launch-review-audience-approver-role-workflow.role-workflow.json`

This session exposed a specific failure mode on `rismay.me`: the pipeline acted as if localization infrastructure could proceed ahead of the audience pass, and the review surface was too narrow. Source packets and string catalogs were reviewed, but rendered HTML and emitted JSON projections were allowed to move forward without the same defender pass. That is why internal/path-bearing language and mechanism vocabulary escaped into public output.

The correction is:

1. Audience review happens before localization.
2. Localization outputs stay staged until rendered previews exist.
3. Launch review inspects the staged rendered artifact itself, including emitted route metadata and JSON/data projections.
4. Pending operator approval blocks public render handoff.

The important distinction is that this was **not** just a weak-copy problem. It was a process inversion and a boundary mistake. The-Entity-style review existed, but it was applied to authored packets rather than the full projected surface.

Use [[localized-public-surface-release-gate]] when a public surface carries localization.
Use [[localization-never-outruns-audience-review]] when the temptation is to treat locale work as infrastructure exempt from source-side audience review.
Use [[launch-review-audience-approver]] as the role that must inspect built HTML plus emitted JSON/data, not only catalogs or copy packets.
Use [[audience-aware-content-pipeline]] `v0.2.0` as the repaired order of operations.

Related doctrine:
- [[release-gate-audience-review]]
- [[capture-requires-typed-workflows-and-roles-not-just-memory]]
- [[agent-manual-substrate-process-execution-is-error-prone]]
