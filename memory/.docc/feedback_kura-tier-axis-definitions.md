---
name: kura-tier-axis-definitions
description: "Definitions of Kura's three content-set tiers by their NORMAL/ESSENTIAL AXIS: timelines = temporal, series = generic-ordered, collections = same-room (co-located, order optional)."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The substrate's three Kura content-set tiers are distinguished by **what their normal axis is** — i.e., what the items in that tier are organized along.

## The three tiers, defined by their axis

| Tier | Normal axis | Essential property | Example |
|---|---|---|---|
| **Timeline** | TEMPORAL | Items anchored to actual dates; chronological reading order is the canonical view | Founder journey events; release history; calendar of moments |
| **Series** | GENERIC (sequence #, chapter, episode, version, etc.) | Order matters; reading order is the point, but ordering isn't time | Artifacts within a room (`sequenceNumber: 1, 2, 3`); book series; lecture series |
| **Collection** | NONE REQUIRED — but items are CO-LOCATED ("same room") | Items belong together by virtue of being grouped, not by being sequenced. **Can** be ordered + have similar aspects, but order isn't essential | Set of related axes; command-line-adventures; "things in the same room" |

## The "same room" diagnostic for collection

Operator's framing 2026-05-26: *"the important part is that it's in the same room."*

When deciding between collection / series / timeline, the test is:

- **If removing the ordering destroys the meaning** → not a collection (it's series or timeline)
- **If items can be reordered freely without losing the point** → collection
- **If the ordering axis is specifically TIME** (dates anchor each item, chronological view is canonical) → timeline
- **If the ordering axis is generic** (sequence numbers, chapter numbers, anything non-temporal but where order matters) → series

A collection CAN have ordering — you can sort its items by date, alphabetically, by tag — but the SET MEMBERSHIP is what defines the collection, not the order. Members can be added without renumbering. Removing the order leaves a valid (if differently-organized) collection.

A series CANNOT have ordering removed without losing essence — artifact 1 → artifact 2 → artifact 3 within a room is meaningful. Skipping artifact 2 and reading 1 then 3 loses something.

A timeline cannot have ordering removed because the ordering IS the time axis the items live on.

## Has-date-metadata ≠ is-a-timeline

The most common mis-classification is treating "items have publication dates" as sufficient evidence for timeline. It isn't. The diagnostic is *whether time is the canonical organizing axis*, not whether time appears as a field.

Operator-stated 2026-05-26: *"blogs are a series — they have moment info, but they are more like a series."*

**Blog posts** have dates (published-at timestamps). But:

- Readers don't read blogs strictly chronologically — they discover posts via topic, search, recommendation, tag
- The canonical organizing axis is *post-sequence* (post #1, #2, ...) or *curated reading order*, not strict time
- Removing the date doesn't destroy a blog post's value — the post stands on its own content
- Reordering posts by topic, popularity, or curator's pick produces a valid alternate view of the same blog

So a blog is a **series** whose items happen to carry date metadata. Date is one attribute among many; the *series-ness* (ordered sequence of authored items) is the structural commitment.

Compare to a true timeline like rismay.me's institutional-axis:

- Each room is a chapter in a chronological life journey
- "Andover came after Prep for Prep" is irreducibly time-anchored — that's how life worked
- Reordering destroys the journey narrative; the chronology IS the structure
- Time isn't metadata; time IS the axis the items live on

**The sharper diagnostic:** ask *"what does the renderer DEFAULT to for ordering?"*

- Default: chronological, dates ARE the navigation → **timeline**
- Default: sequence-by-position, dates are metadata you might also display → **series**
- Default: no canonical ordering, items are presented as a set → **collection**

A renderer can always add ALTERNATE views (chronological filter on a series, topic filter on a timeline). The *default*/*canonical* view is what reveals the storage tier.

## How this clarifies the rismay.me axis mapping

Per [[reference_command-line-adventures-kura-collection]] and the earlier rismay.me kura-tier analysis:

- **Each axis = COLLECTION** — rooms within an axis are united by being in "the same room" (the axis theme). Accession numbers are stable IDs, not essential ordering. Removing the order doesn't destroy the axis-ness.
- **Each room's artifacts = SERIES** — `sequenceNumber` is generic ordering that matters; can't reorder without losing the evidence presentation logic; but it's not time.
- **Optional TIMELINE projection** — IF a room or axis has rich moment refs with dates, the renderer (rismay.me) can PROJECT a timeline view onto the underlying collection storage. Storage stays in collection-shape; the lens applies time-ordering at render.

## How to apply when authoring kura content

When creating a new kura entry, ask in order:

1. Are these items anchored to actual dates with chronological reading order being THE canonical view? → **timeline**
2. Does the ordering matter (sequence/chapter/episode/...) and reordering would lose meaning? → **series**
3. Are these items co-located by theme/group/room, with ordering being optional or arbitrary? → **collection**

Most substrate kura content is collection-shaped because collection is the most general and least constraining. Use the stricter tiers (series, timeline) only when the constraint is real and load-bearing.

## History

Operator-stated 2026-05-26 across two refinements:

1. *"timelines: normal axis is temporal. series: normal axis exists but is generic. order matters. collection: can be ordered and have similar aspects but not necessarily sequential. the important part is that it's in the same room."* — the core tier definitions.
2. *"blogs are a series — they have moment info, but they are more like a series."* — clarifies that date metadata alone doesn't make a timeline; the canonical organizing axis must be time for timeline to apply.

## Related

- [[feedback_kura-storage-typology]] — the broader Kura typology (5 shape tiers × 5 ownership tiers); this refines the content-set tiers (timelines/series/collections)
- [[reference_command-line-adventures-kura-collection]] — the first substrate-shared collection; collection-shape because adventures are co-located by topic, not sequenced
- [[insights/lens-apps-substrate-pattern-2026-05-18]] — the lens doctrine; informs why timeline projections can be lenses on collection storage rather than separate storage shapes
