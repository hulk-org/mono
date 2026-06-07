---
name: couchbase-lite-server-is-enterprise-only
description: There is no separate "Couchbase Lite Server" product; the daemon-shape feature is `URLEndpointListener` (WebSocket+BLIP listener inside CBL), which lives ONLY in couchbase-lite-swift-ee (Enterprise) — the Apache-2.0 Community Edition does not ship it; EE free tier covers internal dev + eval only, production/shipped use requires paid Order with audit rights.
type: reference
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
**There is no separate "Couchbase Lite Server" product.** The
daemon-shape feature people refer to as "Couchbase Lite server" is
**`URLEndpointListener`** — a class inside Couchbase Lite (since
2.8, Feb 2021) that turns an in-process CBL database into a
**WebSocket+BLIP sync endpoint**. It's the same role Sync Gateway
plays for cloud sync, but embedded in a process you write.

**Critical licensing fact:** `URLEndpointListener` is **Enterprise
Edition only**.

- `couchbase-lite-swift` ("CE") — **does NOT ship URLEndpointListener.**
  Use as a client only.
- `couchbase-lite-swift-ee` ("EE") — ships URLEndpointListener,
  delta-sync, encryption-at-rest, predictive query, etc.

**Licensing — verified directly via gh CLI on each repo's LICENSE file**:

**Apache 2.0 (verified)**:
- `github.com/couchbase/couchbase-lite-ios` — Apache 2.0 ✓
- `github.com/couchbase/couchbase-lite-net` — Apache 2.0 ✓
- `github.com/couchbase/couchbase-lite-java` — Apache 2.0 ✓
- **`github.com/couchbase/couchbase-lite-C` — Apache 2.0 ✓**
  (Couchbase officially recommends this as the canonical embedded
  path; the lite-core README says "Instead, use Couchbase Lite for C")
- `github.com/couchbase/couchbase-lite-java-listener` — Apache 2.0 ✓
  (proves the REST-over-CBL pattern exists in Apache-2.0 form for Java)

**BSL 1.1 (verified — literal LICENSE.txt content quotes
"Business Source License 1.1 (BSL)" on each)**:
- `github.com/couchbase/sync_gateway`
- `github.com/couchbase/couchbase-lite-core` (the engine)
- `github.com/couchbase/fleece` (the binary format)
- `github.com/couchbase/go-blip` (BLIP-over-WebSocket protocol)

**Closed source + BSL 1.1**:
- `github.com/couchbase/edge-server` — private repo via couchbase-priv

**Implication for vaultd**: a fully Apache-2.0 architecture is
viable. Embed CBL-C inside vaultd (the Apache 2.0 wrapper around
the BSL engine), expose a custom REST API, clients use plain HTTP.
URLEndpointListener (EE) becomes unnecessary because vaultd does
its own listening. CES becomes unnecessary because we wrote vaultd
ourselves around CBL-C. CBL-C feature note: peer-to-peer
replication (URLEndpointListener equivalent) is NOT in CBL-C and
remains EE-only — this is the reason vaultd has to roll its own
client transport rather than use CBL replication for client-to-vault.

**EE license terms:**

- Free tier covers "internal development use and evaluation" only.
- Production, QA, and "testing beyond evaluation" require a paid Order.
- Couchbase reserves audit rights.
- Pricing is opaque (contact-sales-only).
- Sources: [ESLA02152018](https://www.couchbase.com/ESLA02152018/),
  [License Agreement](https://www.couchbase.com/license-agreement/),
  [Pricing](https://www.couchbase.com/pricing/).

**Architecture (when EE is adopted):**

- One writer process (e.g., `vaultd`) opens the `.cblite2` database.
- vaultd runs `URLEndpointListener` on `127.0.0.1:<port>`.
- N client processes (CLI, SwiftUI app, Metal 3D-world app) each
  open *their own small local CBL database* and run a continuous
  `Replicator` against `ws://127.0.0.1:<port>/vault`.
- Live queries propagate via replication: client mutates → BLIP
  push → vaultd writes → BLIP push to other clients → their local
  change-listeners fire. Sub-100ms on loopback.
- **Multi-process direct file access is unsafe** per LiteCore's
  thread-safety wiki — the daemon-with-listener shape IS the
  supported pattern.

**Sources:**

- [Data Sync Peer-to-Peer (Swift)](https://docs.couchbase.com/couchbase-lite/current/swift/p2psync-websocket.html)
- [Passive Peer (Swift)](https://docs.couchbase.com/couchbase-lite/current/swift/p2psync-websocket-using-passive.html)
- [Active Peer (Swift)](https://docs.couchbase.com/couchbase-lite/current/swift/p2psync-websocket-using-active.html)
- [couchbase/couchbase-lite-ios — CE/EE split SPM packages](https://github.com/couchbase/couchbase-lite-ios)
- [URLEndpointListenerConfiguration 2.8 (EE-labeled docs)](https://docs.couchbase.com/mobile/2.8.0/couchbase-lite-java/com/couchbase/lite/URLEndpointListenerConfiguration.html)
- [LiteCore Thread Safety wiki](https://github.com/couchbase/couchbase-lite-core/wiki/Thread-Safety)

**Apache-2.0-friendly alternatives** (if substrate wants to avoid
the commercial commitment):

- **GRDB.swift** (Apache 2.0/MIT) — SQLite with `ValueObservation`
  reactive Combine publishers; one writer + N readers via WAL.
- **rqlite** — distributed SQLite over HTTP (overkill for single
  machine but real).
- **Litestream** — streaming replication for SQLite.
- **Hand-rolled vaultd**: SQLite WAL + Unix socket / XPC RPC
  custom change-feed protocol (BLIP-shaped or JSON-RPC over WS).

The architecture works in either path; the difference is the
licensing surface and the engineering investment.
