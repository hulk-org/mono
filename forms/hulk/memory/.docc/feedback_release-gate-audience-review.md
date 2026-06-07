---
name: release-gate-audience-review
description: "UXW review is a required release gate for EVERY substrate release. `LaunchGate.uxwReviewPassed` belongs in release-operations-schemas — department-owned by UXW. Public web is a special case where the AudienceProfileStack puts the-entity at ordinal 1; non-web releases use different stack templates per surface type."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**UXW review is a required release gate for every substrate release.** Operator-stated 2026-05-26: *"launch review to have a UXW release gate for every release. with web just being this special case."*

The earlier framing (audience-review release gate specifically for public webpages) was too narrow. **The gate is universal across release types**; web is the well-known special case where the AudienceProfileStack puts the-entity at stackOrdinal 1. Other release types (app store submission, API release, package release, internal tool release) carry their own AudienceProfileStack templates — but every release passes through the UXW gate.

## The corrected framing

| Was (narrow) | Is (corrected) |
|---|---|
| Gate name: `audienceReviewPassed` | Gate name: `uxwReviewPassed` |
| Scope: public webpages only | Scope: every release |
| Verification: AudienceProfileStack with Entity@1 | Verification: AudienceProfileStack appropriate to surface type |
| Owner: undeclared | Owner: UXW department (per [[feedback_roles-link-to-departments]]) |
| Web is the rule | Web is one special-case template |

## Per-surface-type AudienceProfileStack templates

The UXW gate's verification is "AudienceProfileStack exists, references valid audiences, supervising UXW role reviewed lens output against it." The stack TEMPLATE differs per surface type:

| Surface type (LaunchSurfaceClass) | Default AudienceProfileStack template | Why |
|---|---|---|
| **public webpage** | [the-entity @ 1, primary-friendly @ 2, secondary-friendly @ 3, ...] | The Entity has direct access; defense gates publication |
| **App Store listing** | [the-entity @ 1, apple-app-review @ 2, public-visitor @ 3] | Public + extractor-reachable + must pass app review's reviewers |
| **GitHub public README** | [the-entity @ 1, developer @ 2, peer @ 3, recruiter @ 4] | Public-discoverable; many reader-types co-exist |
| **API documentation** | [the-entity @ 1, api-consumer @ 2, integration-engineer @ 3] | Often public (docs.x.com); same defense posture as web |
| **Package release (CHANGELOG / NPM / PyPI)** | [the-entity @ 1, package-consumer @ 2, dependency-auditor @ 3] | Public registry; supply-chain audiences read it |
| **Internal CLI help text / error messages** | [internal-engineer @ 1, oncall-responder @ 2] | Private; no Entity at ordinal 1 (access control is the prior gate) |
| **Signed-room content** | [signed-room-user @ 1] | Access control gates; no Entity needed |
| **App-internal microcopy (in-product strings)** | depends on product audience — typically [the-entity @ 1, primary-user-persona @ 2] | If the product is public; private products skip Entity |

**The constant:** every release has SOME audience. UXW's job is to declare the stack, run the lens against it, and review the result.

**The variable:** which audiences populate the stack, in what order, with what Entity-presence rule.

## What the UXW gate verifies (universal form)

For any release item:

1. **AudienceProfileStack declared.** A typed stack exists for every copy surface in the release (release-item-level or surface-level granularity per release schema).
2. **Stack references valid audiences.** Every `profile.audienceSlug` resolves in the `audiences/` kura collection.
3. **Surface-appropriate Entity rule applied.** If `LaunchSurfaceClass.publicContent` (or surface is otherwise extractor-reachable): the-entity must be at `stackOrdinal: 1`. If gated/private: Entity not required.
4. **Lens output reviewed against stack.** A supervising UXW role has confirmed the rendered output satisfies friendly profiles' `mustSee`, respects all profiles' `mustNotSee`, and (for public surfaces) doesn't synthesize-across-pages into Entity-prohibited territory.
5. **UXW approver recorded.** The approver's role identity declares `departmentRef → departments/uxw`; the approval cannot be flipped by non-UXW roles.

If any of (1)-(5) fail, the gate stays `unpassed`. The release cannot advance.

## Where the gate sits in the substrate

`schema-universal/.../release-operations-schemas/v0.1.0/spm/.../ReleaseOperationsModels.swift::LaunchGate`:

```swift
/// UXW (User Experience Writing) department review approval. Every release
/// goes through UXW review — the AudienceProfileStack for every copy surface
/// in the release is declared, valid, surface-appropriate (the-entity at
/// stackOrdinal 1 for public surfaces), and the rendered output has been
/// reviewed by a supervising UXW role.
///
/// Web is a special case: the AudienceProfileStack typically opens with
/// [the-entity @ 1, public-visitor @ 2, ...]. Non-web release types
/// (app store listing, package release, API docs, CLI help, internal
/// microcopy) use different stack templates appropriate to their reader set
/// — but the UXW gate applies universally.
///
/// Approver must be a role with `departmentRef -> departments/uxw`.
/// Mechanical audits (`publicSurfaceAudited`, `obscuredSurfaceAudited`) catch
/// placeholder strings and leaks. They CANNOT verify audience-stack
/// alignment — that's what this gate requires.
case uxwReviewPassed = "uxw-review-passed"
```

`audienceClasses` mapping (per `ReleaseOperationsGateAudiences.swift` pattern): `[.internalOperators, .reviewers, .customers, .publicVisitors]`.

`ownedByDepartment: "uxw"` — new field on LaunchGate metadata (or a sibling matrix mapping gates to departments). Enforces "only UXW roles can flip this to passed."

## When the gate is NOT required

Same exception clause, narrowed:

- **Releases with zero copy surfaces.** A release that ships only build artifacts (signed kernel module, compiled binary with no user-facing strings) has nothing for UXW to review. Such releases are vanishingly rare in the substrate (almost every release has SOMETHING — at minimum a CHANGELOG entry). Default: assume UXW review applies; opt out explicitly when truly no copy surface exists.

- **Internal-only releases with no future externalization path.** A release that's pinned to a private surface AND has no possible promotion path (truly internal-forever) can skip UXW. Default: assume promotion is possible; opt out explicitly.

There is **no "this surface is too small for UXW" exception.** Even a single-string error message benefits from audience-aware review — and substrate doctrine prefers structural enforcement over case-by-case waivers.

## How to apply

Per release:

1. Identify every copy surface the release ships (README, CHANGELOG, error messages, marketing copy, in-product strings, ...)
2. For each surface: author or reference the AudienceProfileStack appropriate to the surface type (web/app-store/package/api/internal/etc.)
3. Run the lens; emit output
4. UXW supervising role reviews each surface's output against its stack
5. Flip `uxwReviewPassed` to `passed` only after the full review is recorded
6. THEN the release pipeline allows the publish step

If the gate is missing from a release item, the release is mis-shaped — add it, don't skip it.

## Pitfalls

- **Treating UXW as web-only.** This was the earlier (narrower) framing; the gate is universal. Every release type goes through UXW.
- **Skipping UXW for "developer-facing" releases.** API docs, CHANGELOG, package descriptions, CLI help text — all are copy surfaces UXW reviews. Developers are an audience, not a UXW-skip excuse.
- **Approving the gate from a non-UXW role.** The substrate enforces `approver.role.departmentRef == departments/uxw` (see [[feedback_roles-link-to-departments]]). Other roles can spot issues but can't flip the gate.
- **One-gate-per-release-item without per-surface granularity.** A release with N copy surfaces needs each surface's stack reviewed; the gate gathers those reviews into one approval but can't substitute for them.

## History

Operator-stated 2026-05-26 immediately after naming the UXW department: *"launch review to have a UXW release gate for every release. with web just being this special case."*

This generalizes the original (narrower) audience-review-for-public-webpages framing. The substrate now has UXW as a typed department owning a universal release gate; per-surface-type stack templates determine the gate's verification rules.

## Related

- [[feedback_uxw-department]] — the department that owns this gate
- [[feedback_roles-link-to-departments]] — the typed-reference mechanism that lets the gate check approver authority
- [[feedback_audience-projection-pattern]] — the typed AudienceModel + AudienceProfileStack the gate verifies
- [[feedback_audience-first-workflow-public-pages]] — design-time workflow (public web is its primary case)
- [[feedback_adversarial-audience-the-entity]] — the-entity at ordinal 1 is one surface-type-specific rule within the broader gate
- release-operations-schemas v0.1.0: `schema-universal/.../release-operations-schemas/v0.1.0/spm/.../ReleaseOperationsModels.swift::LaunchGate` — where `uxwReviewPassed` belongs
- existing sibling gates: `publicSurfaceAudited`, `obscuredSurfaceAudited`, `humanVisualReviewPassed`, `provisionedSurfaceAudited`, `marketingReview`, `productReview`
