---
name: couchdb-replication-protocol-is-the-leverage
description: The CouchDB Replication Protocol is an open HTTP+JSON standard implemented by Couchbase Lite, PouchDB, Apache CouchDB, Sync Gateway, Cloudant, etc.; protocols aren't licensed, so vaultd can speak this protocol via any compliant implementation (Apache CouchDB Apache-2.0, vendored CBL 1.4.4 already in substrate, PouchDB Apache-2.0) without paying Couchbase or accepting BSL.
type: reference
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
The architecturally load-bearing artifact for the substrate's
vaultd is the **CouchDB Replication Protocol** — an open HTTP+JSON
standard documented at
[docs.couchdb.org/en/stable/replication/protocol.html](https://docs.couchdb.org/en/stable/replication/protocol.html).

**Protocols aren't licensed.** Multiple independent implementations
exist, all interoperable:

- **Apache CouchDB** — Apache 2.0, mature (since 2005), ASF project,
  full reference implementation, single-binary install, Fauxton
  admin UI. Erlang runtime.
- **Couchbase Lite (vendored 1.4.4 in substrate)** — old Couchbase
  Community Edition License (MIT-shaped grant), Apple-native,
  speaks the protocol natively.
- **PouchDB** — Apache 2.0, JavaScript, browser + Node.js,
  same protocol.
- **Couchbase Sync Gateway** — BSL 1.1 (avoid for substrate).
- **Couchbase Edge Server** — BSL 1.1 + closed source (avoid).
- **Cloudant** — IBM managed, hosted CouchDB-protocol service.

**Implication for vaultd:**

We don't need any specific Couchbase product. The substrate can
pick:

- **Server (vaultd)**: Apache CouchDB OR roll our own Swift server
  speaking the protocol (HTTP+JSON, well-documented, weeks of
  focused engineering). Apache CouchDB is the boring answer; a
  Swift implementation is the substrate-native answer.
- **Apple client**: vendored CBL 1.4.4 (already in substrate)
  speaking the protocol against vaultd. No new dependency needed.
- **Web/Node client**: PouchDB (Apache 2.0).
- **Plain HTTP client (CLI, etc.)**: `URLSession` + JSON, no CBL
  dependency at all.

All Apache-2.0 / open. All interoperable.

**Why this matters for the substrate's pattern:**

- License-clean for shipping (Apache 2.0 throughout)
- Multi-consumer pattern (CLI + SwiftUI + Metal 3D world) handled
  natively by HTTP clients hitting vaultd
- Live-query reactivity via the `_changes` feed (continuous longpoll
  or EventSource — well-supported in the protocol)
- Existing substrate investments (vendored CBL 1.4.4) compose
  cleanly with whatever vaultd backend gets picked
- Future migration freedom — swap server implementation at any
  time without touching client code, because they all speak the
  same protocol

**The doctrinal lesson:**

Protocols beat products for substrate decisions. The previous
several turns of this conversation chased Couchbase product
licensing (EE vs CE, CES closed source, Sync Gateway BSL 1.1)
when the actual leverage was always the underlying open protocol
the products implement. Applying this principle going forward:
when researching a vendor's product, ask "what's the protocol,
and what other implementations exist?" first. The product is
often the slow, expensive, contractually-constrained way to access
something already standardized and freely available.
