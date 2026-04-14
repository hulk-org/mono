---
name: Vault by wrkstrm product architecture
description: Passwords + Wallet + Reminders hybrid; multi-vault trust compartments; keychain daemon substrate; future sealed agent artifacts; card-first UI
type: project
---

**Vault by wrkstrm** — bundle `me.rismay.vault`, slug `vault-by-wrkstrm`.

Product thesis: NOT a password manager. A system that models identity,
access, and services as composable primitives, projected into accounts with
operational state (expiration, verification, activity). Feels like Passwords
(access) + Wallet (accounts) + Reminders (time pressure/decay).

## Three-layer architecture

1. **Vault (product layer)** — user-facing: accounts, identities, deadlines,
   activity, search. No raw secrets here.
2. **Domain/Core layer** — security posture scoring, token lifecycle, derived
   "needs attention", permissions, projections.
3. **Keychain daemon (secure substrate)** — Keychain + Secure Enclave backed.
   Stores secrets, wrapping keys. Returns opaque refs, not raw values.
   Login item / XPC service shared across Tau/CLIA/etc.

## Multi-vault model (day one)

One user has many vaults (trust compartments):
- Personal (auto-created on first launch)
- Shared (spouse, team)
- Entity (LLC, trust, fund)
- Project
- Agent (future: sealed agent artifacts)

Vaults are the security + organizational boundary, NOT folders inside one vault.

## Core domain objects

- **Vault** — trust compartment with members + roles + policy
- **Account** — projection across Identity × Access × Service
- **Identity** — individual, joint, entity (who)
- **Service** — external system/institution (where)
- **AccessProfile** — login, API key, OAuth, passkey, support PIN (how)
- **CredentialReference** — pointer into keychain, not the secret itself
- **VaultItem** — typed: identity, password, apiKey, oauthAccessToken,
  oauthRefreshToken, sessionToken, etc.
- **Deadline** — token expiry, password rotation, doc expiry, stale verification
- **Activity Event** — append-only audit log
- **Entitlement** — license, subscription, membership (optional layer)

## Two orthogonal dimensions on access

- **Security Level** (static posture): weak → moderate → strong → hardened
  Computed from auth factors, recovery, scoping, last audit.
- **Token Lifecycle** (dynamic decay): issued, expires, rotation interval,
  last rotated, auto-refresh.

## "Needs Attention" engine (core product loop)

Derived attention reasons: expiringSoon, expired, rotationDue, weakSecurity,
missingRecovery, staleVerification, revoked. Ranked by severity × urgency.

## UI structure

macOS: sidebar + content + inspector. Card-first, form-second.
Sidebar: Overview | Needs Attention | Accounts | Activity | Settings.
Account detail sections: Overview, Access, Ownership, Deadlines, Documents,
Activity, Notes, Linked Systems.

## Future: sealed agent artifacts

Compile agent into vault artifact: model instructions, tool permissions,
memory shards, secret refs, policy. Owner-bound via Secure Enclave key.
Runtime mounts only minimal decrypted portions under policy-scoped revelation.

**How to apply:** This is the canonical product spec. Do not flatten into
a password-manager or generic CRUD app. The domain model is normalized;
categories are projections not folders; secrets are references not values.
