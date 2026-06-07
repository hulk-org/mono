---
name: Clia Day Pa distribution
description: Today (clia-day) Pa lens ships via rismay's personal account, bundle com.wrkstrm.ios.app.today, ASC record 1153239848
type: project
---

The Today app (clia-day's locked Pa lens) is distributed via **rismay's
personal Apple Developer / App Store Connect account** (Cristian A
Monterroza, personal legal entity — team `BM6B69ZQSR`). TestFlight under
that account is the delivery channel.

**Concrete identifiers (do not re-derive these):**

- Apple ID: `cmonterroza@gmail.com`
- Team ID: `BM6B69ZQSR` (set in `clia-day/project.yml` `settings.base.DEVELOPMENT_TEAM`)
- Bundle id: `com.wrkstrm.ios.app.today`
- App Store Connect app id: `1153239848`
- App Store name: `Today: Relive your Favorite Moments` (legacy 2016 slot,
  reused — ASC name is the historical 2016 product name; on-device display
  name from `CFBundleDisplayName` is `Today`)
- Provider id seen by xcrun: `69a6de73-a58e-47e3-e053-5b8c7c11a4d1`
- Distribution cert in keychain: `Apple Distribution: Cristian Monterroza
  (BM6B69ZQSR)` SHA `1ACA88CAC471CD861C3691DD9B25A00D93AF7332`
- Credentials store: `~/.appstoreconnect/credentials/com.wrkstrm.ios.app.today.json`
  (see `project_appstoreconnect-credentials-store.md`)

**Why personal:** the audience is rismay himself (the "Pa" framing is
design language, not a literal customer — see `user_today-app-real-customer.md`).
Personal-account distribution matches that, keeps signing simple, and
avoids mis-attributing a personal product to a commercial entity. The
`com.wrkstrm.*` bundle id prefix is **historical naming only** — it was
registered under the personal team in 2016 before wrkstrm Inc existed.
Do not assume `com.wrkstrm.*` implies wrkstrm Inc ownership.

**Build + ship loop (CLI, manual story push, V1):**

1. Edit `Sources/Shared/today-pa.json` with the new session story
2. Bump `CURRENT_PROJECT_VERSION` in `clia-day/project.yml`
3. `xcodegen generate --spec project.yml` from `clia-day/`
4. Archive: `xcodebuild archive -project clia-day.xcodeproj -scheme
   clia-day-ios-app -destination 'generic/platform=iOS' -archivePath
   /tmp/clia-day-ios.xcarchive -configuration Release
   -clonedSourcePackagesDirPath /tmp/clia-day-spm-fresh`
5. Export with **`-allowProvisioningUpdates`** (REQUIRED, see
   `scripts/export-options.plist` header for why)
6. Validate: `xcrun altool --validate-app -f /tmp/clia-day-ios-export/clia-day-ios.ipa
   -t ios -u <appleId> -p '@env:ALTOOL_PASS'`
7. Upload: same command with `--upload-app`
8. Apple processes (5–15 min). Build appears in TestFlight on Pa's iPad
   (or rismay's iPad — the real customer).

**How to apply:**
- When the user says "ship the Today app", follow the build+ship loop
  above with the credentials from
  `~/.appstoreconnect/credentials/com.wrkstrm.ios.app.today.json`.
- Do not migrate this app to Laussat or wrkstrm Inc without rismay
  explicitly changing this decision.
- Other Today/clia-day audiences (e.g. clia-agents) may eventually use
  different distribution channels — this rule is specifically about the
  iOS Today shipping target.
- Cross-reference: see `user_legal-entities.md` for the three-entity
  split; this is the personal-entity case.
