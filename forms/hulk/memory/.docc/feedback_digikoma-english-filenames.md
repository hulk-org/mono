---
name: digikoma-english-filenames
description: "Digikoma metadata files use English names (`identity.md`, `install.md`, `spec.json`, `persona.md`) — Japanese `アイディ.md` / `インスト.md` / `スペック.json` / `レイ.md` are retired."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

Digikoma packages under `digikoma-org/private/universal/domain/<domain>/digikoma-*/` ship with four metadata sidecars. The substrate uses **English filenames** for these, not Japanese.

## Rename map

| Old (Japanese) | New (English) | What it holds |
|---|---|---|
| `アイディ.md` | `identity.md` | digikoma identity / wrapped binary / protocol version |
| `インスト.md` | `install.md` | install + usage surfaces (CLI commands, exit codes) |
| `スペック.json` | `spec.json` | typed spec contract (action, invocation, declaredEffects, outputContractRef) |
| `レイ.md` | `persona.md` | persona / role / character description for the digikoma |

Other digikoma sidecars (`lineage.json`, `interface/`, `Package.swift`, `sources/`, `tests/`) keep their existing English names.

## Why

Two distinct reasons:

1. **savepoint v0.1 Unicode bug.** When git status shows the Japanese names quoted as `\343\202\242\343\202\244...`, savepoint v0.1's `git add` invocation fails with "pathspec did not match any files." This blocks routine commits of digikoma re-forges. The bug surfaced 2026-05-26 during digikoma-prove v0 → v1. Until savepoint v0.2 fixes the Unicode path handling, English filenames sidestep the issue entirely.
2. **Toolchain compatibility.** Some downstream tools (greppers, fzf, IDE search, find-with-regex) handle ASCII filenames more reliably than multi-byte Japanese. English names reduce friction across the typed-tool surface.

## How to apply

When **forging** a new digikoma: use the English filenames from the start. `アイディ.md` etc. should not appear in new packages.

When **re-forging** an existing digikoma with Japanese sidecars: rename to English as part of the re-forge. Update `Package.swift` resources block to reference the new names.

When **touching** an existing Japanese-sidecar digikoma for any reason: rename to English if savepoint commits will be involved.

When **leaving** existing Japanese-sidecar digikomas alone: they keep their old names until they're touched. The substrate has thousands of binary-backed digikomas in the org; a wholesale rename sweep is separate work. New forges and re-forges land in English; legacy stays where it is unless touched.

## Naming derivations

- `アイディ` ≈ phonetic shortening of アイデンティティ (identity) → `identity.md`
- `インスト` ≈ phonetic shortening of インストール (install) → `install.md`
- `スペック` ≈ phonetic of "spec" → `spec.json`
- `レイ` ≈ ambiguous (could be 例 example, 礼 manner, 霊 spirit); the canonical content is persona/role/character of the digikoma → `persona.md`

## History

Operator-stated 2026-05-26 during cleanup after savepoint failed on the Japanese filenames: "i think we need to switch to english filenames for now." Applied immediately to digikoma-prove; doctrine locked for future forges.

## Related

- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — digikoma vocabulary
- [[feedback_substrate-toolmaking-checklist]] — savepoint is part of the substrate-toolmaking surface affected by this
- [[feedback_digikoma-lineage-long-form-versions]] + [[feedback_digikoma-versions-start-at-zero]] — version naming, different but adjacent doctrine surface
