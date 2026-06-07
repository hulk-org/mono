---
name: wrkstrm-identifier subcommand suite (13 verbs as of May 2026)
description: Canonical entry point for substrate CLI/app/workspace identity, naming, installation, and maintenance; lives at clia-org/.../tooling/spm/wrkstrm-identifier
type: reference
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
`wrkstrm-identifier` (installed as `eadaac6f-cli` post-hash-rename) at `clia-org/private/universal/domain/tooling/spm/wrkstrm-identifier/`. Subcommands shipped as of May 2026 sweep:

**App identity:**
- `app describe` — full app naming/path contract
- `app artifact-name`, `app bundle-id`, `app applications-path`, `app derived-data-path`
- `app build-xcode` — invoke xcodebuild + export
- `app validate` / `app fix` / `app sweep` — project.yml PRODUCT_BUNDLE_IDENTIFIER audit

**Install + path resolution:**
- `install-path` — resolve INSTALL_PATH from (org, app, category) via retail-schemas
- `patch-install-path` — patch project.yml install settings

**Display + icons:**
- `scaffold-display-manifest` — emit `<slug>.display.json` with brand/phrase tagged union
- `generate-icons` — AppKit renderer into AppIcon.appiconset

**Composed-hash naming:**
- `hash-name --slug X --version Y` — compute composed-hash exec name
- `bootstrap-registry --input <tier-N-input.json>` — emit full registry with hashes

**CLI sweeps:**
- `discover-clis` — walk substrate, emit input JSON (built-in allowlist filter)
- `apply-cli-renames --execute` — sweep Package.swift `.executable(name:)` to hash
- `emit-aliases` — generate aliases.zsh from registry
- `install-cli --execute` — SPM install per registry entry (also `--only <slug>` for one-CLI tests)

**App sweeps:**
- `discover-apps` — walk substrate apps, emit inventory JSON
- `apply-app-renames --execute` — sweep project.yml PRODUCT_NAME to hash

**Workspace (substrate xcworkspace):**
- `workspace-sync --execute` — add missing Package.swift FileRefs to substrate workspace
- `workspace-validate --execute` — prune broken FileRefs + delete stale `.swiftpm/xcode` caches (use `--substrate-wide` for broader sweep)

Default `--dry-run` on every mutating verb; `--execute` applies.
