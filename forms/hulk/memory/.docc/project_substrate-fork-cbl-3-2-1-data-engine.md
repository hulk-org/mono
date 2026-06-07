---
name: substrate-fork-cbl-3-2-1-data-engine
description: Substrate forks Couchbase Lite at the 3.2.1 cohort tag (clock-expired Apache 2.0) and owns the data engine forward — couchbase-lite-core, couchbase-lite-ios, and the bundled Fleece pin become substrate-owned LTS code; rationale is that the 3-year wait for next Couchbase conversion (Feb 2029) is too long for substrate pace.
type: project
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
The substrate's data engine strategy is a **fork at CBL 3.2.1** and
own it forward. Pinning passively to upstream's release schedule was
ruled out because the next Couchbase conversion wave (3.2.2-3.2.4 →
Feb 28, 2029; 3.3.x + 4.0.x → May 1, 2029) is 2.5-3 years away, and
the substrate's "ship 10 apps/day" pace cannot wait that long for
upstream features or fixes.

**The pin (verified Apache 2.0 today, since Nov 1, 2025):**

- `couchbase-lite-core@3.2.1` (engine, C++)
- `couchbase-lite-ios@3.2.1` (Objective-C/Swift wrapper)
- `couchbase/fleece` SHA `adec5e362a0e8f7051982581c3b60427905de3d2`
  (binary format, bundled by lite-core@3.2.1)

All three sources verified via gh CLI against the canonical
`licenses/BSL-Couchbase.txt` files at each tag — Change Date
November 1, 2025 (already past), Change License Apache 2.0.

**What forking earns the substrate:**

- Full ownership of the data engine — modify, extend, ship freely
- No dependence on Couchbase's release calendar
- Substrate-specific features can be added (vaultd REST endpoints,
  integration with refinement primitives, @Generable composition,
  custom auth, etc.)
- Backports from later upstream releases (using JIRA bug knowledge
  to rewrite fixes against the forked source — bug knowledge isn't
  copyrightable per Google v Oracle 2021)
- License-clean for substrate's commercial trajectory — Apache 2.0
  permits use/modify/distribute/sublicense/sell

**What forking commits the substrate to:**

- Engineering ownership of the LTS branch (substrate now patches
  bugs + maintains the build matrix Couchbase no longer tests for us)
- Tracking upstream's API shape as a forward-compat reference
  (per `feedback_clock-expired-source-plus-current-api-shape.md`)
- Backport queue from JIRA (~6-8 substrate-relevant bugs initially —
  CBL-7006 P2P delta sync blob, CBL-6822 replicator shutdown hang,
  CBL-6886 disk-full handling, CBL-6820 listener cert callback,
  CBL-6981 weak cache crash, CBL-6540 background-replication flag,
  CBL-6678 log dir, CBL-7014 cert locality)

**Naming + identity:**

Apache 2.0 requires retaining Couchbase's copyright notices in
source headers (file-level attribution). Substrate ADDS its own
copyright for substrate modifications. The package as a whole is
renamed to a substrate-native identity (working name candidates:
`vault-engine-by-wrkstrm`, `wrkstrm-lite-db`, or operator pick) to
signal substrate ownership. This follows the substrate's existing
"openclaw is compat surface, not our identity" precedent — the
fork is substrate-native, even though it acknowledges its origin.

**Concrete next-step components needed:**

1. Vendored fork repos under substrate (location TBD: under
   `collectives/wrkstrm/` or new `collectives/data-substrate-org/`)
2. Build/test verification on current Xcode + Swift 6
3. CHANGELOG-substrate.md tracking divergence from upstream 3.2.1
4. Backport queue tracking + first-pass implementation
5. Modern Swift wrapper layer matching upstream 4.x API conventions
6. Custom Swift binding to c4Listener (the EE-only Swift class we
   bypass by binding directly to the C API in source)
7. Vaultd daemon built on top of the substrate-owned fork

**Why this works long-term:**

The substrate's typed-everything investment + forward-compat
primitives (LinkRefModel.unknown state, NonEmpty<T>, refinement
vocabulary) shield consumers from engine churn. The fork's API
target shape tracks upstream's current API for forward-compat
optionality. If/when the substrate ever wants to migrate back to
upstream (or switch to a different engine entirely — Apache CouchDB,
PouchDB, custom Swift CouchDB-protocol server), the wrapper layer
abstracts the engine choice. The fork is the answer NOW; the
abstraction layer keeps future answers open.
