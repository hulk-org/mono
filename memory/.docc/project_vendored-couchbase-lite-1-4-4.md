---
name: vendored-couchbase-lite-1-4-4
description: Substrate already has vendored Couchbase Lite 1.4.4 (build 107, 2018) at wrkstrm/private/apple/Vendor/ with CouchbaseLiteListener.framework for peer-to-peer/REST listener; license is the old Couchbase Community Edition Agreement which is MIT-shaped (free use/copy/distribute/sublicense/sell with attribution) — NOT the modern BSL 1.1; wrkstrm prototype was built on it; this is the substrate-native foundation for vaultd, no commercial dependency.
type: project
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
The substrate already has a vendored **Couchbase Lite 1.4.4** (build
107.0.0, copyright 2018) at:

- `collectives/wrkstrm/private/apple/Vendor/CouchbaseLite.framework`
  — the framework binary
- `collectives/wrkstrm/private/apple/Vendor/Cocoapods/Pods/couchbase-lite-osx/`
  — full CocoaPods install with both `CouchbaseLite.framework` AND
  **`CouchbaseLiteListener.framework`** (the REST listener for
  peer-to-peer multi-app scenarios)
- `maintainers/couchbase/public/universal/libraries/fleece/` —
  separate vendored Fleece source (binary format)

**License — radically more permissive than modern BSL 1.1:**

The vendored copy ships under the **"Couchbase, Inc. Community Edition
License Agreement"** (Copyright 2018). Key grant:

> "Couchbase Inc. hereby grants Licensee, **free of charge**, the
> **non-exclusive right to use, copy, merge, publish, distribute,
> sublicense, and/or sell copies of the Software**, and to permit
> persons to whom the Software is furnished to do so, subject to
> Licensee including the following copyright notice in all copies"

This is essentially **MIT-shaped** — free to use, copy, distribute,
sublicense, sell. With attribution requirement and no-reverse-engineer
clause. **You can ship this freely in commercial products.** This is
NOT the modern BSL 1.1 license that Couchbase Mobile moved to in 2022;
1.4.4 predates that switch.

**Capabilities included (per README):**

- Peer-to-peer replication: "Revision trees allow for complex
  replication topologies, including server-to-server (for multiple
  data centers) and peer-to-peer, without data loss or false conflicts."
- REST listener via CouchbaseLiteListener.framework
- Embedded JSON document store with map/reduce
- Sync with Couchbase Server / Sync Gateway
- Lightweight (~600 KB) + quick startup (<50ms)
- Native APIs: Objective-C (iOS, tvOS, Mac), Java (Android), C#
  (.NET/Xamarin)

**Why this is the substrate's vaultd foundation:**

- **License-clean for shipping** — MIT-shaped grant, no commercial trap
- **Listener included** — peer-to-peer / multi-process REST listener
  is exactly the vaultd shape (one daemon, N apps connect)
- **Already production-tested** — wrkstrm prototype ran on it
- **Already in the substrate** — no new dependency to introduce
- **Couchbase doesn't sell or update this version anymore** — we
  own the fix surface; permissive license means we can fork freely
- **CBL 1.4.4 is THE high-water mark for (Apache 2.0 + listener-in-source).**
  Verified by recursive tree dump at every CBL 2.x and 3.x tag:
  `URLEndpointListener` (the modern listener, introduced 2.8.0
  Oct 2020) has ALWAYS been EE-only — open repo has only
  tests + headers + an EE exports manifest, never the implementation.
  After CBL 2.x rewrote the listener as the EE-binary
  `URLEndpointListener`, the in-source listener path was abandoned.
  CBL 1.4.4's `Listener/CBLListener.m` + `CBLHTTPListener.m` are
  the only versions where the listener implementation lives in
  source under an OSS license.

**Trade-offs vs modern Couchbase Lite:**

- API is Objective-C (1.4.4 predates the Swift-native rewrite)
- No async/await ergonomics (must wrap)
- No EE-vs-CE feature split (it's just one CE version, fully featured
  for that era)
- Couchbase considers it end-of-life from a support perspective —
  but the permissive license means we can patch ourselves
- Modern wire-format efficiencies (Fleece improvements, delta sync
  tuning) absent; depending on use case this may or may not matter
- ~7-year-old API; some idioms have aged

**Implication for vaultd architecture:**

Build vaultd as a Swift daemon that wraps CBL 1.4.4 + uses
CouchbaseLiteListener.framework to expose a REST endpoint on
localhost. Apps (CLI, SwiftUI, Metal 3D world) connect via plain
HTTP — same architectural shape as CES, but with the substrate's
own vendored, license-clean stack. Modern Swift wrapper layer can
be added on top for ergonomics.

This *also* keeps `couchbase/couchbase-lite-C` (Apache 2.0, modern,
actively maintained) on the table as a future migration target if
1.4.4 hits a wall. Two-phase plan: ship vaultd v1 on vendored 1.4.4
(fast, proven), evaluate migration to CBL-C v3.x for v2 if needed.
