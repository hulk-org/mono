---
name: Bundle IDs are derived by wrkstrm-identifier
description: Canonical bundle IDs are produced by the `wrkstrm-identifier` CLI in clia-org. Pattern is `me.rismay.<app>.<platform>.<surface?>.<configuration>` — NOT the flatter `me.rismay.<slug>` form many existing apps drifted into.
type: project
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
The substrate has a canonical bundle-identifier CLI:

**`wrkstrm-identifier`** — at
`private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/wrkstrm-identifier/`.

It derives bundle IDs, artifact names, applications-shelf paths, and shared
DerivedData paths from `(appName, platform, configuration, surface)`. Run it
to get the canonical answer — do NOT hand-author bundle IDs.

## Canonical shape

```
<bundle-prefix>.<app-name>.<platform>.<surface?>.<configuration>
```

- **bundle-prefix** defaults to `me.rismay` (overridable via `--bundle-prefix`)
- **app-name** is the kebab-case app slug (validated against `[a-z0-9]+(?:-[a-z0-9]+)*`)
- **platform** ∈ `macos` · `catalyst` · `ios` · `tvos` · `watchos` · `visionos`
- **surface** is OMITTED when `.app` (the default); included when `.status`, `.daemon`, `.widget`, `.share`, `.xpc`
- **configuration** ∈ `debug` · `release`

Examples (derived by the tool):
- `me.rismay.vapor-wares.macos.release`
- `me.rismay.vapor-wares.macos.debug`
- `me.rismay.hello-world-google.macos.release`
- `me.rismay.inference-control.macos.status.release` (status menu surface)
- `me.rismay.launch-calendar.macos.release`

## Filesystem conventions paired with the tool

- **Applications shelf**: `$WORKSPACE_ROOT/private/.wrkstrm/Applications/<app-name>.<platform>.<configuration>.app`
- **DerivedData**: `$WORKSPACE_ROOT/private/.wrkstrm/DerivedData/<app-name>.<platform>.<configuration>`
- **`.app` bundle name** (`WRAPPER_NAME`): `<app-name>.<platform>.<configuration>.app`

The tool's `build-xcode` subcommand wires xcodebuild to land binaries at these
canonical locations.

## Drift in existing apps

Many wrkstrm-app projects use a flatter `me.rismay.<slug>` form (launch-calendar,
brick-works, choreograph, etc.) — that's pre-tool drift, not the canonical
answer. New apps should use the wrkstrm-identifier output verbatim. Migration
of the drift is its own project; do not propagate the flat form to new apps.

## How to apply

- **Before scaffolding any app**: run `wrkstrm-identifier app describe --name <slug> --platform <p> --configuration <c>` and use ALL the values it returns (bundle-id, wrapper-name, applications-root, derived-data-root).
- **In `project.yml`**:
  - Base `PRODUCT_BUNDLE_IDENTIFIER` = the release-config bundle ID
  - `configs:` override for `Debug:` flips the configuration suffix to `.debug`
  - `WRAPPER_NAME` per-config matches the tool's artifact-basename output
- **In brew casks**: `zap trash:` paths reference the **release** bundle ID since casks install the release variant
- **In ASC credentials**: file path is `~/.appstoreconnect/credentials/<release-bundle-id>.json` (chmod 600)
- **Team**: `BM6B69ZQSR` (rismay personal Apple Developer team — currently the only one until more entities are provisioned per `user_legal-entities.md`)

## Memory-write history

- 2026-05-12: First written as `me.rismay.<slug>` flat form. **Wrong.** Corrected the same day after operator pointed at the wrkstrm-identifier CLI.
