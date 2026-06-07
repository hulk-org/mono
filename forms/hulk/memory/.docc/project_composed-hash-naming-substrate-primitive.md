---
name: Composed-hash naming as substrate primitive (CLI-only)
description: Substrate-wide adoption of SHA256-derived <hash>-cli exec names for OPSEC/imitation-game; applied to 105 CLIs May 2026; apps keep readable PRODUCT_NAME per post-session doctrine correction
type: project
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---

Substrate adopted **composed-hash naming** as the canonical exec-name primitive for CLI tools. Replaces brand-y / language-revealing names (swift-agent-cli, wrkstrm-identifier) with deterministic 8-hex hashes derived from `SHA256(SHA256(slug)[:6] + SHA256(version)[:6])[:8] + "-cli"`.

**Scope:** CLI-only. Apps keep readable PRODUCT_NAME values.

**Why:** Hides Swift toolchain identity (swift- prefix) AND substrate vendor identity (wrkstrm-/clia-/digikoma- prefixes) AND relationships between tools (composed hash means two versions of the same slug produce unrelated-looking exec names). Combined with `~/.swiftpm/bin/` install destination, the on-disk CLI fleet looks like generic tooling to outside observers; substrate-internal machines + operators discover via the registry vault + aliases.zsh.

**Why apps are excluded:** Doctrine correction landed May 2026 — `ApplyAppRenamesCommand` is now audit-only (rejects `--execute` with ValidationError) and only `apply-cli-renames` mutates. App PRODUCT_NAME stays readable because (a) bundle filename hashing would confuse Finder navigation, (b) Apple App Store stability around bundle identity, (c) the OPSEC win for apps is much smaller than for CLIs (apps live in `/Applications/` where Finder uses CFBundleDisplayName anyway).

**How to apply (CLIs):**
- Doctrine bundle at `clia-org/private/cli-rename-master-plan.docc/` (index + composed-hash-naming + install-architecture + hardening-tiers).
- Compute via `wrkstrm-identifier hash-name --slug X --version Y`.
- Apply via `wrkstrm-identifier apply-cli-renames --execute`.
- Registry at `clia-org/private/cli-rename-master-plan.docc/substrate-cli-registry.json` (105 CLIs).

**Open item:** mid-session 109-app PRODUCT_NAME hash sweep needs revert per the corrected doctrine. Tracked as bead in claude's agenda.

May 2026 CLI sweep landed across 13 collectives + mono pointer bumps. Future renames apply the same function — for CLIs only.
