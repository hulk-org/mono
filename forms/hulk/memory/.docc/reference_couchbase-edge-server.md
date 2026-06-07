---
name: couchbase-edge-server
description: Couchbase Edge Server (CES) — shipped 2025-03-04, standalone macOS/Linux daemon built on Lite Core, REST + SQL++ + WebSocket BLIP, designed for single-host multi-client sync (IoT gateways, retail, edge); near-perfect architectural fit for substrate vaultd but BSL 1.1 licensed (commercial-only for production).
type: reference
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
**Couchbase Edge Server (CES)** shipped 2025-03-04 as a standalone
server binary built on Couchbase Lite Core. It sits between
Couchbase Server (the full cloud cluster) and Couchbase Lite (the
embedded client) in the product lineup. It's purpose-built for
"single-host multi-client sync hub" scenarios — IoT gateways, retail
POS, in-flight entertainment, edge deployments.

**Architecture:**

- Standalone macOS / Linux daemon (NOT a library to embed)
- Footprint: ~10 MB code, <50 MB RAM, target hardware ~1 GB RAM
- macOS 13+ on Intel AND ARM64 officially supported (unzip binary)
- Linux: Ubuntu 22.04+, Debian 11+, Fedora 40+ on x86_64

**API surfaces:**

- **REST API** (versioned 1.0): CRUD, SQL++ ad-hoc queries, named
  queries, changes feed for HTTP clients
- **WebSocket BLIP replication**: standard Couchbase Mobile sync
  protocol; CBL clients use the normal Replicator API pointed at
  `ws://host:port/...`
- **Auth**: HTTP Basic, Sync Gateway session cookies, OIDC, mTLS

**Why it's a near-perfect fit for substrate vaultd:**

- Separate process by design — no need to elect one app as listener
  host (URLEndpointListener's awkward shape)
- Multi-client live-query reactivity works end-to-end via standard
  CBL Replicator + LiveQuery chain
- REST/SQL++ side door means CLI tools can hit it with `curl`
- Architecturally aligned with "CLI + SwiftUI app + Metal 3D world
  all connecting to one local hub" — exactly the vaultd shape

**Licensing (the blocker):**

- **BSL 1.1 (Business Source License)** — NOT Apache 2.0
- Free for "internal development and evaluation" only
- Production / shipped use requires paid Couchbase Enterprise
  Order with audit rights
- **There is NO Edge Server Community Edition.**
- 4-year delayed conversion to Apache 2.0 (today's CES 1.0
  becomes Apache 2.0 around March 2029)
- The whole Couchbase Mobile stack (Lite, Sync Gateway, Lite Core,
  Edge Server) moved to BSL 1.1 at Couchbase Mobile 3 release
- CE vs EE split is between feature sets, not licenses — both
  editions are BSL 1.1

**Source code is CLOSED (private repo).** Confirmed via the public
build manifest `github.com/couchbase/build-manifests/blob/master/couchbase-edge-server/1.1.0/1.1.0.xml`
which routes the `edge-server` project through `couchbase-priv`
(SSH-only, internal Gerrit at review.couchbase.org). Hitting
`github.com/couchbase/edge-server` directly returns 404. CES is the
outlier in the Couchbase Mobile family — sibling repos
(sync_gateway, couchbase-lite-core, couchbase-lite-ios) are all
PUBLIC; CES alone is private. The closed-source posture is
deliberate (build pipeline explicitly routes through couchbase-priv).

Consequences of closed source: no audit, no custom platform builds
(visionOS, BSD, musl Linux), no patching for vaultd-specific
behavior (alternate auth, custom REST endpoints, telemetry).

**Sources:**

- [Press release (2025-03-04)](https://www.couchbase.com/press-releases/couchbase-unveils-edge-server-to-help-organizations-solve-real-world-edge-application-challenges/)
- [Build manifest proving private source](https://github.com/couchbase/build-manifests/blob/master/couchbase-edge-server/1.1.0/1.1.0.xml)
- [Sample app README confirming binary-only distribution](https://github.com/couchbase-examples/edge-server-meal-order-sample-app)
- [Product page](https://www.couchbase.com/products/edge-server/)
- [Intro docs](https://docs.couchbase.com/couchbase-edge-server/current/introduction/intro.html)
- [What's new in 1.0](https://docs.couchbase.com/couchbase-edge-server/current/introduction/whats-new.html)
- [Install guide](https://docs.couchbase.com/couchbase-edge-server/current/get-started/install.html)
- [Supported platforms](https://docs.couchbase.com/couchbase-edge-server/current/product-notes/supported-platforms.html)
- [REST API landing](https://docs.couchbase.com/couchbase-edge-server/current/rest-based-access/rest-api-landing.html)
- [SQL++ queries API](https://docs.couchbase.com/couchbase-edge-server/current/rest-based-access/queries-api.html)
- [Edge sync with CBL](https://docs.couchbase.com/couchbase-edge-server/current/sync/edge-sync-cbl.html)
- [BSL 1.1 license change announcement](https://www.couchbase.com/blog/couchbase-mobile-changes-source-code-license-to-bsl-1-1/)
- [License agreement (Couchbase blocks WebFetch; access via search snippets)](https://www.couchbase.com/license-agreement/)

**Verdict for vaultd:**

If vaultd never leaves rismay's machine: **free tier covers it
indefinitely**, CES is the strongest architectural fit, ship it.
If vaultd ever gets bundled into a published app or runs on
another operator's machine: **commercial subscription required**,
substrate becomes a Couchbase Inc. paying customer at a load-bearing
layer. The architectural elegance vs commercial commitment trade
is the decision point.

**Apache-2.0 alternatives** (if license is a hard no):

- **GRDB.swift** + Unix socket / XPC RPC — full SQLite reactivity
  via ValueObservation, write our own daemon shell
- **rqlite** — distributed SQLite over HTTP (overkill for one host)
- **Litestream** — streaming replication for SQLite
- **Realm Swift** — MongoDB-owned, has its own license fine print
- **SwiftData + custom IPC** — Apple-native, no third-party deps,
  but no built-in multi-process model

The architecture works in either direction; the difference is
licensing surface and engineering investment.
