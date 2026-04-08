---
name: App Store Connect credentials JSON schema
description: Schema of the per-bundle-id credentials files at ~/.appstoreconnect/credentials/<bundle-id>.json and the altool invocation that works with them on Xcode 26
type: reference
---

Per-app credentials for `xcrun altool` uploads live at `~/.appstoreconnect/credentials/<bundle-id>.json`, chmod 600, one file per app. Each JSON carries the metadata needed to upload that app from CLI without exposing secrets in shell history.

## Top-level fields

- `schemaVersion` — integer, currently 1
- `appleId` — Apple developer account email (used as `--username` in altool)
- `ascAppId` — App Store Connect App ID (the numeric one, e.g. 1153239848)
- `bundleId` — CFBundleIdentifier, matches the filename
- `appName` — full App Store display name
- `displayName` — short name variant
- `team` — object with `id` and `name` (team id matches pbxproj `DEVELOPMENT_TEAM`)
- `auth` — nested auth object (see below)
- `history` — array of past credential rotations

## `auth` object fields

- `kind` — `"appSpecificPassword"` for altool app-specific password flow, or `"apiKey"` if rotated to App Store Connect API keys
- `label` — human-readable label (e.g. "Today altool")
- `password` — the actual secret, only present for `appSpecificPassword`
- `createdAt` — ISO timestamp
- `expiresAfter` — string like "1y per Apple policy"
- `notes` — migration guidance, often points at moving to API keys + keychain/secrets manager

## altool invocation (Xcode 26+)

Xcode 26's altool renamed the flags: `--apple-id` is now `--username`, and `--password` is now `--app-password`. The legacy flags error out with `AuthenticationFailure`. Use:

```
APP_PASSWORD="$(jq -r '.auth.password' ~/.appstoreconnect/credentials/<bundle-id>.json)" \
xcrun altool --upload-app \
  --type ios \
  --file /path/to/app.ipa \
  --username "$(jq -r '.appleId' ~/.appstoreconnect/credentials/<bundle-id>.json)" \
  --app-password "@env:APP_PASSWORD"
```

The `@env:APP_PASSWORD` reference keeps the secret out of `ps auxe` beyond the scoped env var lifetime. Never echo `$APP_PASSWORD` or pass the literal password on the command line.

Run `xcrun altool --validate-app` first with the same flags — it surfaces ITMS-* errors without consuming an App Store Connect upload slot.

**How to apply:** Any future CLI upload of a wrkstrm / rismay iOS app. First check `~/.appstoreconnect/credentials/<bundle-id>.json` exists and is readable, then pull `appleId`, `ascAppId`, `auth.password` with `jq` into scoped env vars, then drive altool.
