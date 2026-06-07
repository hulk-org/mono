---
name: WrkstrmKeychain.set switched to update-or-add (2026-05-18)
description: Keychain.set no longer does delete-then-add for non-biometric items; uses SecItemUpdate to avoid the macOS "<app> wants to use the keychain" prompt storm that hit inference-control on every launch.
type: project
originSessionId: 49a1a45f-fe1a-4811-a3d4-690cee60bec6
---
LANDED 2026-05-18 in `WrkstrmKeychain` (substrate-collectives/wrkstrm-core/.../WrkstrmKeychain/Sources/WrkstrmKeychain/Keychain.swift):

`Keychain.set(_:for:requiresBiometry:synchronizable:)` now follows update-or-add semantics for the **non-biometric** path:

1. Try `SecItemUpdate` first. On `errSecSuccess`, done.
2. On `errSecItemNotFound`, fall through to `SecItemAdd`.
3. On any other status (e.g., ACL transition), fall through to the legacy delete-then-add path.

The biometric path (`requiresBiometry: true`) still uses delete-then-add because the ACL must be recreated atomically when biometry requirements change.

**Why:** The 2026-05-18 a16z Speedrun deploy session surfaced operator pain: *"always asks for everything and i can't say give it always."* Root cause: `Keychain.set` did `SecItemDelete` before `SecItemAdd` on every write. On macOS, `SecItemDelete` against an item whose code-signing ACL doesn't list the current binary triggers the macOS "<app> wants to use the keychain" prompt. With inference-control importing 5-10 providers on launch, that's 5-10 prompts in a row — and each prompt's "Always Allow" decision binds to *that specific item's* ACL, so the next item triggers a fresh prompt. `SecItemUpdate` doesn't require the per-item ACL list; only the shared access group entitlement.

**How to apply:**
- New WrkstrmKeychain consumers: just call `keychain.set(...)` as before. The upsert behavior is now built in.
- Items previously stored under the delete-then-add path are forward-compatible — the next `set(...)` runs SecItemUpdate against them, which only requires access-group entitlement match, not per-item ACL membership.
- Biometric items: behavior unchanged — ACL recreation on every write is by design.

**Verified by:**
- `@Test func resettingSameKeyUpdatesInPlace()` in `WrkstrmKeychain/Tests/WrkstrmKeychainTests/KeychainTests.swift` — asserts three consecutive writes with different values all succeed and the latest value reads back.
- `swift test --filter CredentialDaemonTests` in `VaultCore` — all 14 tests still pass (transitively confirms the upsert doesn't break the credential daemon scaffolding that shipped this morning).

**Known follow-on UX:**
- Items created by other CLIs (Claude Code, codex, gemini) under the same service name but different access groups will still fall through to delete-then-add when overwritten. The substrate fix is to *not* overwrite those items in place — import their values into inference-control-owned items via the new code path, then leave the originals alone. The `InferenceProviderSecureTokenStore.storeCredential(...)` flow already writes to inference-control's credentialRefID-keyed entries (not the external CLI's keychain key), so this is mostly handled.
- For users on rapidly-changing debug signing identities, consider adding an explicit `SecAccessControl` with empty flags (`SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlocked, [], &error)`) so the item's ACL is "any binary in the access group" rather than "this specific signed binary." Bead-worthy follow-up.

**Cross-references:**
- Credential daemon scaffolding (`insights/credential-daemon-typed-scaffolding-2026-05-18.md`) — same Keychain layer underneath.
- Audit not eyeball-clone (`feedback_audit-not-eyeball-clone`) — the fix is verified via assertions, not visual prompt-counting.
- Constraints belong in types (`feedback_constraints-belong-in-types-not-tests`) — the upsert semantics now live in the function contract, not in caller-side retry logic.
