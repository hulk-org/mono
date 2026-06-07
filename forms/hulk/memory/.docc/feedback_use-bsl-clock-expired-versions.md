---
name: use-bsl-clock-expired-versions
description: For BSL 1.1 dependencies (Couchbase Mobile, MariaDB, others), pin to versions whose Change Date has already passed — the license has automatically converted to Apache 2.0 (or whatever Change License the package specifies); annually re-evaluate and bump to newer-converted versions; license-clean for shipping with no commercial license required.
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
For dependencies under BSL 1.1 (Business Source License — Couchbase
Mobile, MariaDB, others), use **versions whose Change Date has
already passed**. By the BSL's own terms, those versions have
automatically converted to the Change License (typically Apache 2.0).
No commercial license required. No conversation needed with the
licensor when they discover usage — the license has already converted
per their own published terms.

**Why:** Verified directly from `couchbase-lite-core` BSL-Couchbase.txt
at tag 3.0.0:

> "Licensed Work: Couchbase Lite Version 3.0"
> "Change Date: November 1, 2025"
> "Change License: Apache License, Version 2.0"

> "Effective on the Change Date, OR the fourth anniversary of the
> first publicly available distribution of a specific version of the
> Licensed Work under this License, whichever comes first, the
> Licensor hereby grants you rights under the terms of the Change
> License, and the rights granted in the paragraph above terminate."

CBL 3.0/3.1/3.2.0/3.2.1 source converted to Apache 2.0 on
**November 1, 2025**. Today (2026-05-15) using `couchbase-lite-core@3.2.1`
and `couchbase-lite-ios@3.2.1` is fully Apache 2.0, including the
lite-core engine, REST listener implementation, and c4Listener C API.

**TWO POSTURE CHOICES for substrate adoption:**

1. **Strictly clock-expired (commercial-ship-safe today):** pin to
   3.2.1. License has already converted; can ship commercially today.
   Trade: misses ~3 years of features (vector search refinements
   from 3.3, Version Vector Database from 4.0).

2. **Strictly clock-expired LATEST = CBL 3.2.1 (substrate's pick):**
   pin to 3.2.1 (released 2024-11-19, converted to Apache 2.0 on
   Nov 1, 2025). License is genuinely Apache 2.0 today — no BSL
   Additional Use Grant gymnastics, no "must stay non-commercial
   until 2029" caveat, no commercial-trigger anxiety. The substrate
   can ship CBL 3.2.1 commercially the moment we want to.
   Develop against it now in prototype phases; ship commercially
   later without re-licensing.

The user's strategic call (corrected): "the BSL version that is
converting to apache at the end of this year. So we can start
developing against that while we are in prototype phases." Timing
clarification: the conversion wave actually happened Nov 1, 2025
(~6.5 months before the user said this in May 2026). 3.2.1 is the
latest CBL in that converted cohort. Next conversion wave: Feb 28,
2029 (3.2.2-3.2.4) → May 1, 2029 (3.3.x + 4.0.x).

Substrate pin: **CBL 3.2.1** + matching `lite-core@3.2.1` + Fleece
pin SHA `adec5e362a...` (bundled by lite-core@3.2.1, also Apache 2.0).
Includes vector search (3.2.0+), scopes & collections (3.1), modern
Swift API, full c4Listener implementation in source, BLIP/WebSocket
replication, Fleece. Everything vaultd needs without commercial
license risk.

**How to apply:**

- Before adopting a BSL 1.1 dependency, find the canonical license file
  (typically `licenses/BSL-*.txt` or `LICENSE.txt`) and read the
  Change Date for the specific version.
- Pin to a version whose Change Date is in the past at adoption time.
  Document the version + Change Date in the substrate's dep manifest.
- Annually (or when a new feature is needed): re-evaluate which BSL
  versions have newly converted. Bump if a converted version offers
  features the current pinned version lacks.
- Document the "currently pinned version + its converted-on date" as
  reference memory so the substrate's BSL-trailing-edge strategy is
  reviewable.
- This generalizes beyond Couchbase: MariaDB, Sentry, CockroachDB,
  Liquibase, others use BSL 1.1 with similar 4-year clocks. Same
  strategy applies.
- **Caveat**: Each version of a BSL'd library has ITS OWN Change Date
  in its OWN license file. The "License applies separately for each
  version" clause means you must check the specific version's file,
  not the repo's HEAD license file.
- **Additional Use Grant**: even during the BSL period, the
  Couchbase-specific Additional Use Grant permits non-commercial
  production use. So personal-substrate-only deployment of a NOT-yet-
  converted version may be permitted; but anything shipped to other
  operators or bundled in a commercial app crosses into commercial-
  license territory. The clock-expired strategy avoids that line
  entirely.
