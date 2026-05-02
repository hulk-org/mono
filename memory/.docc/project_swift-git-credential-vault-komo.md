---
name: swift-git-credential-vault Komo
description: Planned Komo that bridges git's credential helper protocol to VaultCore.TokenResolver, giving every git push a vault-doctrinal auth path across forges (Bitbucket, GitHub, GitLab, Azure DevOps)
type: project
originSessionId: 4cdf303b-5484-419d-b8fb-20dae0c1a4b1
---
A future Komo (`swift-git-credential-vault`) sits between git's credential helper protocol and `VaultCore.TokenResolver`. Git invokes it on push for any host that has `credential.https://<host>.helper=swift-git-credential-vault` configured; the Komo reads `protocol/host` from stdin, looks up the matching vault entry via `TokenResolver.resolve(.<provider>)`, and writes `username=…\npassword=…\n` to stdout. Result: every forge git pushes to gets vault-served credentials with no per-host helper duplication, no manual keychain pastes, no external multi-forge daemons (no GCM, no 1Password CLI).

**Why:** rismay's substrate doctrine is that credential storage belongs to wrkstrm Vault (`vault-by-wrkstrm`) and `VaultCore` is the engine layer. The current state has each forge wired through a different helper — `!gh auth git-credential` for github.com, `osxkeychain` for bitbucket.org (added 2026-04-30), nothing for hosts not yet encountered. This patchwork fragments the auth surface and bypasses Vault. A single Swift Komo unifies it: one helper, one source-of-truth (VaultCore), one protocol implementation tested with Swift Testing invariants. Operator framed this 2026-04-30 with "we just want to use our vault for the bitbucket credentials" after declining git-credential-manager.

**How to apply:**
- Treat this as the *durable* answer to "how does git push authenticate to a forge in rismay's substrate?" When that question surfaces, propose the Komo, not external tools
- Path A (file-based vault entries at `~/.<service>/credentials/<scope>.json` chmod 600) is the *interim* — the JSON files are the future inputs to either Vault.app or this Komo's loader. Don't propose Path A as the final answer; surface the Komo as the migration target
- Build prerequisites: extend `WrkstrmSecrets` with `BitbucketAccountsSecret` (and eventually GitHubAccountsSecret, GitLabAccountsSecret), add the matching cases to `VaultCore.TokenProvider`, then write the Komo as a sibling SPM target near VaultCore (`wrkstrm-core/private/cross/spm/`)
- Komo shape: `swift-git-credential-vault get|store|erase` per git's credential helper API. Map host → TokenProvider via a small dispatch table. Exit cleanly when no entry matches so git falls through to other configured helpers
- Swift Testing invariants to lock in: "given a vault entry for host X, helper outputs expected protocol response"; "given no entry, helper exits 0 with no output"; "store/erase don't corrupt other vault entries"; "username field comes from vault `atlassianAccount` for BB and `username` for GH"
- Once shipped: rewrite the per-host `credential.helper` lines globally to point at this Komo, deprecate the keychain helper for credential-helper duty (it stays as a backend for VaultCore's secrets store, not a direct git participant)
