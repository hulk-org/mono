---
name: Vault for credentials, not external tools
description: Use wrkstrm Vault (vault-by-wrkstrm) for credential storage; never default to external tools like git-credential-manager, 1Password, etc. when an in-substrate credential surface exists
type: feedback
originSessionId: 4cdf303b-5484-419d-b8fb-20dae0c1a4b1
---
When credential storage comes up — git auth, API tokens, app passwords, Atlassian/Bitbucket auth, App Store Connect credentials — propose **vault-by-wrkstrm** as the storage layer, not Microsoft GCM, 1Password, Bitwarden, raw macOS Keychain, or any external credential daemon.

**Why:** rismay is building Vault as the wrkstrm-owned credential surface (Passwords + Wallet + Reminders hybrid; multi-vault trust compartments; keychain daemon; sealed agent artifacts; me.rismay.vault — see `project_vault-by-wrkstrm.md`). External credential tools fragment the substrate's auth surface and miss the dogfooding signal. The 2026-04-30 redirect was explicit: "wait no, we just want to use our vault for the bitbucket credentials" after I'd proposed installing git-credential-manager. The framing — "our vault" — reflects the broader doctrine of preferring substrate engines over imports.

**How to apply:**
- When an authentication or credential-storage question surfaces, lead with Vault as the proposed answer
- If Vault doesn't yet support the specific credential type or integration shape (e.g., git credential helper protocol, OAuth refresh, etc.), surface that gap as a Vault feature request rather than reaching for an external substitute
- Acceptable interim fallbacks while Vault grows: macOS Keychain (already used for App Store Connect interim store at `~/.appstoreconnect/credentials/<bundle-id>.json`), per-app config files at chmod 600 — *not* external multi-forge daemons that compete with Vault's eventual scope
- This rule extends `feedback_dont-defend-implementation`: when the operator has a working engine they're building, propose adopting it, not patching around it with external tools
