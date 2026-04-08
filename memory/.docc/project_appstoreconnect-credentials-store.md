---
name: App Store Connect credentials store
description: Interim local credentials store for App Store Connect uploads, lives at ~/.appstoreconnect/credentials/, gitignored by being outside the repo
type: project
---

Interim local credentials store for App Store Connect / TestFlight uploads.
Lives at `~/.appstoreconnect/credentials/`, **outside the substrate repo**,
so there is zero chance of credentials landing in git.

**Layout:**

```
~/.appstoreconnect/                          chmod 700
  credentials/                               chmod 700
    com.wrkstrm.ios.app.today.json           chmod 600
    com.wrkstrm.ios.app.<next>.json          chmod 600
    ...
  private_keys/                              (Apple convention for ASC API keys)
    AuthKey_<KEYID>.p8                       chmod 600
```

One JSON file per app, named after the bundle id. Each file holds the
Apple ID, team, app-specific password (or API key reference), App Store
Connect record id (`ascAppId`), and an upload history with delivery
UUIDs. Schema is in `com.wrkstrm.ios.app.today.json` — read it before
adding a second app so the shape stays consistent.

**Why this exists:** rismay said on 2026-04-08 — *"save it somewhere for
the app review process... we'll create a bunch like this and it's ok for
now. we'll put these in a proper keychain soon."* This is the interim
home until a real keychain / secrets manager (1Password, macOS Keychain
via `security`, or HashiCorp Vault) takes over. Treat the files here as
**replaceable**: when migrating to a real keychain, the contents move,
the structure can be discarded.

**How to apply:**
- When uploading a new build via `xcrun altool`, read the credential from
  `~/.appstoreconnect/credentials/<bundle-id>.json` rather than asking
  rismay to paste the password again.
- When adding a new app, drop a new JSON file with the same schema.
- Append to the `history` array on every successful upload — each entry
  records version, build, deliveryUUID, and a one-line note.
- Never commit anything from `~/.appstoreconnect/`. The path is outside
  the repo so this happens by default; do not symlink it in.
- App-specific passwords expire after one year per Apple policy. The
  `auth.createdAt` field tracks the creation date so we know when to
  rotate.
- The `auth.kind` field can be `appSpecificPassword` or `apiKey`. When
  switching an app to API key auth, replace the `auth` block but keep
  the `history` array intact.
- For invocation, the env-var indirection pattern keeps the secret out
  of `ps`:
  `ALTOOL_PASS="$(jq -r .auth.password ~/.appstoreconnect/credentials/<bundle>.json)" \`
  `xcrun altool --upload-app -f <ipa> -t ios -u <appleId> -p '@env:ALTOOL_PASS'`
  (We use `@env:VAR` so the literal password never appears on the
  command line.)
