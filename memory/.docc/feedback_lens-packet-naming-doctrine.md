---
name: Lens packet — substrate vocabulary for rendered sublens output
description: every rendered artifact from substrate-typed data via a sublens is a "Lens Packet" with kind/audience/render-format; filename suffix `.lens-packet.<ext>`; typed contract LensPacketModel in lens-packet-schemas
type: feedback
originSessionId: 22a40768-80ea-4704-8439-570fe3664d99
---
The substrate-canonical name for any rendered artifact produced by
applying a sublens (founder / partner / investor / operator / audit) to
substrate-typed catalogs is a **Lens Packet**.

**Filename suffix**: `<kind>.lens-packet.<render-format-extension>`. Examples:
- `investor-grading.lens-packet.md` (partner-sublens render organized by an investor's rubric, Markdown format)
- `founder-self-score.lens-packet.md` (founder-sublens render of the same alignment)
- `rubric-comparison.lens-packet.html` (founder-sublens render of one application against multiple rubrics)
- `evidence-inventory.lens-packet.json` (audit-sublens enumeration of every evidence pointer)

**Location**: `provisioned/<application-slug-or-context>/<kind>.lens-packet.<format>`. The `provisioned/` directory is the substrate's home for rendered/deployed artifacts ready for external consumption.

**Typed contract**: `LensPacketModel` in `schema-universal/private/universal/schema-families/lens-packet-schemas/v0.1.0/spm/lens-packet-schemas-v000-001-000/`. Cross-cutting substrate primitive — flat schema-families layout (not domain-bucketed) because lens packets apply to any domain (capital, identity, design, etc.).

**Three ordinality tables** define the typed shape:
- `LensPacketAudienceOrdinalityTable` — founder / partner / investor / operator / audit
- `LensPacketKindOrdinalityTable` — investor-grading / founder-self-score / rubric-comparison / application-submission / evidence-inventory / claim-ordinality-snapshot
- `LensPacketRenderFormatOrdinalityTable` — markdown / html / pdf / swiftui-view / docc-article / json

**Diagnostic enforcement**: partner/investor-audience packets MUST declare a privacy posture (public-evidence-only) in their notes field — the LensPacketModel emits `lens-packet.partner-audience.privacy-posture-not-declared` otherwise. This is the substrate's anti-leakage discipline made compile-time-adjacent.

**Why this matters**:
- Generic vocabulary scales to any new lens kind (just add an ordinality entry; no schema change)
- Same shape works for every investor (a16z Speedrun, YC, On Deck) — only the source catalog refs differ
- Same shape works for every domain (capital applications, identity profiles, design system explorations) — only the source catalog refs differ
- Filename + schemaKind + audience all align so tooling routing is deterministic

**How to apply**:
- When rendering substrate-typed catalogs into a deliverable artifact, name it `<kind>.lens-packet.<format>` in `provisioned/<context>/`
- Author a `LensPacketModel` typed metadata instance alongside if the packet will be referenced by other substrate records
- Declare privacy posture in notes whenever audience is partner or investor
- The packet's title and display name can be human-readable; the technical naming stays in the filename + schemaKind
