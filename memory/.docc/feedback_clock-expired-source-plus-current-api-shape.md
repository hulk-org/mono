---
name: clock-expired-source-plus-current-api-shape
description: For BSL-converted dependencies, pin to the latest clock-expired source AND shape the substrate's public API to match upstream's current API/protocol; APIs and protocols aren't copyrightable (Google v Oracle 2021); use the public issue tracker to identify required backports of bugs without re-importing restrictive-licensed source.
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
When the substrate adopts a BSL-converted dependency under the
clock-expired strategy (per `feedback_use-bsl-clock-expired-versions.md`),
combine three legal pillars to maintain a real LTS posture:

1. **Pin the engine to clock-expired source** (Apache 2.0 today). This
   gives us the implementation under a permissive license.
2. **Shape the substrate's public API to match upstream's CURRENT API**
   (not just the API of the clock-expired version). When we eventually
   upgrade engines, our downstream consumers see API continuity.
3. **Use the upstream public issue tracker as a backport map**. Identify
   bugs fixed AFTER our pinned version that affect us. Rewrite the
   fixes against our pinned engine. We import the bug *knowledge*
   (public information not subject to copyright), not the patch *code*
   (which would reimport restrictive-licensed source).

**Why:** APIs and protocols aren't copyrightable in the practical sense
established by *Google v. Oracle* (US Supreme Court, 2021) and decades of
clean-room reimplementation precedent (Phoenix BIOS, ReactOS, Wine, GNU
coreutils, etc.). Couchbase owns its specific implementation source; it
doesn't own the *shape* of `Database.replicate(to:)`, the wire format
of a `_changes` longpoll, or the existence of a known bug.

The user articulated this clearly:
- "Look at the current API + protocols — they don't own that."
- "Issue tracking history to see what bugs we have to fix."

This is the standard LTS-distribution pattern. Linux distributions
(RHEL, Ubuntu LTS, Debian stable) maintain old kernel/library versions
this way: pinned source, target current upstream API shape, backport
bug fixes by re-implementing using upstream's bug knowledge.

**How to apply:**

- For each BSL-converted dependency, document the substrate's "API
  shape target" — which upstream version's API surface our public
  wrapper should mirror. Default: latest stable upstream API.
- Survey upstream's public issue tracker (JIRA, GitHub Issues, etc.)
  for bugs filed against our pinned version. Triage:
  - Critical (security, data corruption) — backport immediately
  - High (crashes, sync stalls) — backport within sprint
  - Low (cosmetic, edge case) — track but defer
- Re-implement fixes from scratch using the bug description, not by
  copying upstream's patch code. The patch code is under the upstream
  license (often restrictive); the bug description is public information.
- Document each backport in the substrate with a comment noting the
  upstream issue number it corresponds to (so future maintainers can
  trace the lineage without seeing upstream patch code).
- The "API shape target" can advance independently of the pinned
  source. As upstream evolves its API, the substrate's wrapper layer
  evolves to match — even though the underlying engine stays on the
  clock-expired source until the next conversion wave.

**Concrete first application — Couchbase Lite:**

- Pinned source: `couchbase-lite-core@3.2.1` + `couchbase-lite-ios@3.2.1`
  (both Apache 2.0 since Nov 1, 2025)
- API shape target: current `couchbase-lite-ios` HEAD (4.x era)
- Issue tracker: [issues.couchbase.com](https://issues.couchbase.com)
  CBL project — filter "Fixed Version: 3.2.2..4.0.x" + "Affects Version: 3.2.x"
- Wire protocol: CouchDB Replication Protocol
  ([docs.couchdb.org/en/stable/replication/protocol.html](https://docs.couchdb.org/en/stable/replication/protocol.html))

**Caveat — when this strategy doesn't fit:**

- When the CURRENT upstream API is itself substantially the upstream's
  proprietary innovation (e.g., a brand-new query language with no public
  spec). Then matching the API may be borderline — though the *signatures*
  remain non-copyrightable, the *semantics* of brand-new APIs may have
  patent risk we'd need to evaluate separately.
- When the bug surface area is too large to backport reasonably — at
  some point the substrate's engineering cost of patches exceeds the
  cost of just adopting the new BSL version commercially.
- When upstream's API churns aggressively across versions (every release
  is breaking) — chasing a moving API target adds engineering friction.
