---
name: uxw-department
description: "UXW (User Experience Writing) is the substrate department that owns the audience-projection pipeline end-to-end: typed AudienceModel + AudienceProfileStack, audience-aware-copywriter role, audience-first workflow, audience-review release gate. Industry-standard naming (Google/Apple-style UX Writing department); not invented here."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

**UXW = User Experience Writing.** The substrate department that owns audience-aware copy across every surface — naming follows industry-standard practice (Google, Apple, Stripe, Microsoft all have UX Writing departments). Operator-named 2026-05-26: *"this department btw: UXW... user experience - writing."*

UXW is **not invented substrate terminology** — it's a real industry discipline with established craft. The substrate adopts the name so its audience pipeline reads correctly to anyone familiar with the discipline (no translation needed for new contributors). Treating it as substrate-native would have reinvented vocabulary unnecessarily.

## What UXW owns in the substrate

UXW is the named home for the entire audience-projection pipeline. The work that's been accumulating under different memories now has a single department:

| Layer | Surface | Belongs to UXW |
|---|---|---|
| Typed models | `AudienceModel` (audience-schemas v0.1.0) + `AudienceProfileStack` + `AudienceAwareCopywriterCopyBriefModel` (lens-packet-schemas v0.1.0) | ✓ |
| Role | `audience-aware-copywriter` (`roles/audience-aware-copywriter/`) | ✓ |
| Kura collection | `audiences/` (7th owner tier, typed audience registry — 6 entries as of 2026-05-26) | ✓ |
| Doctrine | [[feedback_audience-projection-pattern]] + [[feedback_audience-first-workflow-public-pages]] + [[feedback_adversarial-audience-the-entity]] | ✓ |
| Release gate | [[feedback_release-gate-audience-review]] (`LaunchGate.audienceReviewPassed`) | ✓ |
| Canonical example | `operators/rismay/public/universal/kura/collections/about-me/` (single-source → 4 audience projections) | ✓ |

## Where UXW lives structurally

The substrate's 7 owner tiers are currently:
`operators / collectives / agents / roles / harnesses / maintainers / audiences`

**Department is not yet a typed tier.** Open question: is UXW...

- (a) **A grouping of existing roles** under `roles/<slug>/` (audience-aware-copywriter + future microcopy-author + future lens-author all tagged as UXW department) — lightest weight, no structural change
- (b) **A new structural tier** `departments/<slug>/` that owns the audience schemas + audience-aware-copywriter role + audiences/ kura — heavier, but matches real-company shape
- (c) **A maintainers-tier entry** `maintainers/uxw/` recording UXW-as-discipline with substrate's specific adoption shape — matches the pattern of "external thing we adopt"

Default disposition until operator decides: **(a) — a conceptual grouping referenced from role metadata.** Each UXW role declares `departmentSlug: "uxw"` in its identity file; substrate-shared knowledge of UXW (vocabulary, frameworks, references like Torrey Podmajersky's *Strategic Writing for UX*) goes in `wrkstrm/` or `kura-org/`-shared knowledge. Promote to (b) only if UXW grows enough roles + standalone artifacts that a dedicated home is warranted.

## Naming consequences

- **Future copywriting-related roles** (microcopy author, voice-and-tone curator, content strategist, localization brief author) all live under UXW as a department, not as separate top-level concerns
- **The audience-aware-copywriter role's docs** can reference "UXW" without explanation — the term carries industry meaning
- **The release gate's approver** is "supervising role from UXW" (currently audience-aware-copywriter; could later be content-strategist or another UXW role)
- **External recruitment language** (if the substrate ever describes its own org chart publicly): "UXW department" reads correctly to anyone in the discipline

## Industry reference (light)

UX Writing as a recognized discipline crystallized ~2017-2019 (Google's *UX Writing Hub* materials, Stripe's blog series, Torrey Podmajersky's *Strategic Writing for UX* book in 2019). Core principles align tightly with what the substrate has independently arrived at:

| Industry UXW principle | Substrate equivalent |
|---|---|
| Voice ≠ Tone (voice is constant, tone is contextual) | `AudienceModel.projectedVoice` + per-profile mustSee shifts tone |
| Microcopy is high-leverage (small text, large UX impact) | `CopyFrame` with per-element copy slots |
| Write to a specific reader, not "the user" | `AudienceProfileStack` with named typed audiences |
| Test copy with real users / readers | (substrate gap — no audience-review tooling yet; manual today) |
| Localization briefs as first-class artifacts | `AudienceAwareCopywriterCopyBriefModel` could grow per-locale variants |

The substrate's contribution beyond standard UXW practice:
- **The Entity at ordinal 1** — adversarial audience formalized as first-class (industry UXW rarely addresses adversarial readers explicitly)
- **AudienceProfileStack as ORDERED SUM** — formal typed composition with stack-ordinal semantics
- **Release-gate enforcement** — substrate makes audience review structural (most UXW orgs rely on team discipline alone)

## How to apply

- When discussing audience/copy/lens work, reach for "UXW" as the department name
- When designing a new role that authors copy, ask "is this a UXW role?" — most copy-authoring roles will be
- When the substrate describes its own structure (org chart, contributor pages, role taxonomies), UXW is one of the named departments
- Avoid inventing parallel terms ("audience-pipeline-team", "copy-org", etc.) — UXW already carries the meaning

## History

Operator-named 2026-05-26 directly after locking the audience-review release-gate doctrine. The audience pipeline had grown enough surface area across roles + models + kura + gates that it needed a single departmental name. Operator chose the industry-standard term rather than coining a substrate-specific one — consistent with [[feedback_executable-naming-slug-at-org-dot-form]] discipline of preferring established vocabulary when one exists.

## Related

- [[feedback_audience-projection-pattern]] — UXW's core typed model
- [[feedback_audience-first-workflow-public-pages]] — UXW's gating design question
- [[feedback_adversarial-audience-the-entity]] — UXW's defining contribution beyond standard industry practice
- [[feedback_release-gate-audience-review]] — UXW's release-time enforcement mechanism
- [[feedback_content-lives-in-its-owners-home]] — placement formula UXW roles + artifacts must follow
