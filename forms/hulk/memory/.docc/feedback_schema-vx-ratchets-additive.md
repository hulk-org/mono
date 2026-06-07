---
name: Schema v0.x ratchets are additive only
description: Versioned schema bumps in v0.x must add or refine, never collapse — losing a field/constraint is the wrong shape of change for a v0.x release in this substrate
type: feedback
originSessionId: e45c8d90-ebba-4176-9460-670eb736f881
---
Schema v0.x ratchets only add or refine; never collapse. A v0.x bump that *removes* a field, *softens* a validator, *optionalizes* a previously-required value, or *renames back* to an earlier spelling is the wrong shape of change.

**Why:** v1.0.0 of `web-deploy-share-record` (`collectives/wrkstrm/private/universal/schemas/web-deploy/share/record/v1.0.0/`) was rejected as a mistake because it collapsed v0.3.0's `provider`/`remoteHost` split back into a single `host`, made `source.path` optional, dropped the `commitHash` regex, and removed the `missingSnapshot` validation case. That's the shape of someone still experimenting, not the shape of a 1.0 commitment. The substrate principle: a major-version bump is a downstream-consumer promise; without external consumers there's nothing to make that promise to. Schema families stay in v0.x until at least one shipped, user-facing surface depends on them.

**How to apply:**
- When proposing a schema bump, audit each field-level change: is it adding structure, refining a type, or removing/loosening? If any change is the third kind, push back — find a way to *add* the thing the corpus needs without erasing the constraint.
- v0.4.0 of share-record corrects v1.0.0 by *adding* axes that were missing (Genre, Surface, Runtime, Artifact) and *factoring* overloaded fields (`kind` → `genre + artifact`, `provider` → `surface + host`) instead of collapsing them. v1.0.0 stays in tree as a historical snapshot but is renamed/re-cut.
- Reserve v1.0.0 for the actual frozen contract — when page-deploy or another shipped surface depends on it deliberately, not by accident.
- Treat field rename + constraint removal as two separate ratchets, not one bundle. Renames are reversible; constraint removals usually aren't (downstream code starts relying on the looseness).
