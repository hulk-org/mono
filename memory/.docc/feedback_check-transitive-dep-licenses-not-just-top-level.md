---
name: check-transitive-dep-licenses-not-just-top-level
description: A package's top-level LICENSE file can lie by omission — its transitive dependencies may be more restrictively licensed; always walk the dep graph and verify each LICENSE before claiming a stack is Apache 2.0; verified concretely against couchbase-lite-ios 3.x (claims Apache 2.0, requires BSL 1.1 lite-core submodule).
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
When researching whether a software stack is "open source friendly,"
**verify the LICENSE file of every transitive dependency, not just
the top-level one**. A package's top-level LICENSE can claim Apache
2.0 / MIT / BSD while its required submodules carry restrictive
licenses (BSL 1.1, GPL, commercial-only) that propagate
obligations transitively.

**Why:** Verified concretely against `couchbase-lite-ios`:

- The repo's top-level `LICENSE` file says **Apache 2.0** at every
  tag from 1.4.4 through 4.0.0 (current).
- The README at every 3.x tag says *"Like all Couchbase source
  code, this is released under the Apache 2 license."*
- BUT the **required submodule `couchbase-lite-core` is BSL 1.1**
  from the Mobile 3.x train (March 2022) onward.
- Consuming `couchbase-lite-ios` 3.x means consuming BSL 1.1
  transitively. Production use requires commercial licensing
  regardless of what the wrapper's LICENSE file claims.

This pattern is generalizable. A "permissively licensed" wrapper
can sit on top of a restrictively licensed implementation. The
top-level LICENSE only governs the wrapper's *own code*, not the
underlying engine.

**How to apply:**

- For any new dependency, list its transitive deps (via
  `Package.swift` resolved files, `package-lock.json`, `Cargo.toml`,
  CocoaPods Podfile.lock, etc.) and verify each one's LICENSE.
- For Swift Packages: `swift package show-dependencies` enumerates
  the tree.
- For C/C++ dep graphs: check submodules with `git submodule status`
  and recursively-included third-party directories.
- When the source-of-truth license is buried in an engine submodule
  (a common pattern: thin wrapper + heavy engine), trust the engine's
  license, not the wrapper's.
- Document the licensing of every load-bearing transitive dep in a
  reference memory so future research doesn't repeat the work.
- The hollow-LICENSE pattern is also a tell: if a wrapper claims a
  permissive license but the engine is restrictively licensed,
  the wrapper's claim is technically true but practically misleading
  — flag it as such when summarizing.
