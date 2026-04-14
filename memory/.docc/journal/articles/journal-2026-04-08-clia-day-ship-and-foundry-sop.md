# 2026-04-08 (evening) — Clia-day build 3 shipped + Foundry apple-app-release SOP seeded

## Context

The Today product (clia-day, bundle `com.wrkstrm.ios.app.today`, App ID
`1153239848`) shipped as build 1 earlier in the day via the personal-account
TestFlight path. App Store Connect then rejected build 1 with **ITMS-90683**:

> Missing purpose string in Info.plist — Your app's code references one or
> more APIs that access sensitive user data... The Info.plist file for the
> "clia-day-ios.app" bundle should contain a `NSSpeechRecognitionUsageDescription`
> key with a user-facing purpose string...

The rejection is the load-bearing trigger: the app has `com.wrkstrm.ios.app.today`
reserved in ASC, a build slot occupied by build 1, and no way to ship a fix
without bumping the build number and re-uploading. Goal for the session was
remediation → build 3 upload → and, after the operator asked for
productionization, codifying the pattern into Foundry so the next rejection
doesn't cost another 40-minute hand-crafted session.

## Actions

### Phase 1 — Rejection remediation (build 2 archive, never uploaded)

- **Diagnosed the dependency chain** that pulled `Speech.framework` symbols
  into `clia-day-ios`: the iOS target links `CLIAChatSwiftUI` (swift package
  under `private/clia-chat/catalyst/spm/clia-chat-swiftui`) which depends on
  `common-voice-input` (package under
  `wrkstrm-components/private/common-voice-input`) which imports `Speech` and
  uses `SFSpeechRecognizer` and the iOS 26+ `SpeechTranscriber`. The app's own
  source has **zero** references to `Speech.framework`; the symbol is fully
  transitive. Key file: `CLIAVoiceEvidence+WrkstrmVoiceInput.swift` — the
  CLIAChatSwiftUI voice input flow captures transcribed text as "voice
  evidence" attached to the day's chat/record.
- **First-attempt purpose string was dishonest and caught immediately.** I
  wrote *"Today does not use speech recognition. This description is required
  because a bundled dependency references the speech recognition API."* In
  the same message I had warned that Apple reviewers reject "we don't use it"
  language — then wrote exactly that language. The operator called it: the
  string is self-contradictory and, worse, the system permission dialog shows
  the string to the user at the exact moment the API is invoked, so a
  "does-not-use" string lies to the user while voice input is firing. Reverted
  and rewrote.
- **Honest string, grounded in observable behavior:**
  `NSSpeechRecognitionUsageDescription` → *"Today transcribes your voice into
  text so you can speak into your day instead of typing."* Grounded in the
  voice-input-into-your-day behavior visible in `CLIAChatSwiftUI`. Split the
  microphone side into a separate string because the mic captures audio and
  speech recognition turns it into words — two different user-facing stages.
- **Added `NSMicrophoneUsageDescription` pre-emptively** — the sibling
  permission speech recognition actually needs at runtime. Apple's validator
  only flagged the speech key on upload, but `SFSpeechRecognizer.startListening`
  hard-crashes on the mic prompt the moment the user triggers voice input if
  the mic key is missing. String: *"Today listens through the microphone while
  you speak, so your words can be added to your day."*
- **Build bump 1 → 2**: `CURRENT_PROJECT_VERSION = 1;` → `2` in both project
  Debug and Release configs of `clia-day.xcodeproj/project.pbxproj`. Target
  configs inherit from project level, so one replace covered all three
  targets (ios, mac, catalyst).
- **Commit `clia-app-org@34d7aa2`** via path-scoped `git commit` with both
  files named explicitly. Workspace auto-hook auto-pushed the submodule.
- **Commit `rismay/substrate@30cde5deb6`** for the mono pointer bump via
  path-scoped commit so the pre-staged `.gitmodules` `getyourguide` URL
  rename didn't get bundled into my commit. Pushed mono.
- **Archive succeeded** (`** ARCHIVE SUCCEEDED **` to
  `/tmp/clia-day-ios-b2.xcarchive`) but **never uploaded** — operator pivoted
  mid-session to a productionization investigation before I ran altool.

### Phase 2 — Foundry investigation

- **Wrote `private/.wrkstrm/foundry/investigations/apple-app-release.investigation.md`**
  (141 lines, 9 sections). Captured today's 12-step manual flow as a case
  study; classified each step as rule-based (9) or judgment-based (3) with
  the rule-based set being fully mechanizable; mapped steps to existing
  Foundry surfaces (`sop-procedure.v0.1` schema, `brand-identities/`,
  `operator-profiles/`, `commission.schema.json`) and to three new schemas
  (`apple-app-release.sop.json`, `apple-permission-table.v0.1.json`,
  `apple-copy-library.v0.1.json`) plus a standalone Swift CLI
  (`swift-ship-apple-app-cli`). Documented the judgment-layer boundary around
  purpose string copy authoring with a disclaimer-phrase blocklist invariant,
  7 traps to encode as named rules (disclaimer strings, sibling permissions,
  mixed version sources, `.gitmodules` pre-staging contamination, codex-
  sessions push guard, auto-hook races, packaged-plist vs source-plist
  divergence), a minimal diagnose-only first slice, and 6 open decisions.
- **Committed `rismay/substrate@1edf8c52a0`** with the investigation file.

### Phase 3 — mac + catalyst plist mirror + build 3 ship

- Operator said "2. YES" to mirroring purpose strings into mac and catalyst
  target plists. Added both `NSMicrophoneUsageDescription` and
  `NSSpeechRecognitionUsageDescription` to `Sources/mac-app/Info.plist` and
  `Sources/catalyst-app/Config/InfoCatalyst.plist`. Used "CLIA Day" in the
  copy for those two because their current `CFBundleDisplayName` is literally
  "CLIA Day" — Apple reviewers flag purpose strings that don't match the
  observable app name. Flagged a latent trap: both those plists **hardcode**
  `CFBundleVersion = 1` and `CFBundleShortVersionString = 1.0` rather than
  referencing `$(CURRENT_PROJECT_VERSION)` / `$(MARKETING_VERSION)`, so the
  project-level build bump did not propagate to them.
- **Bumped build 2 → 3**. Same `CURRENT_PROJECT_VERSION = 2;` → `3` across
  both project configs.
- **Commit `clia-app-org@c365cc3`** — path-scoped, three files (mac plist,
  catalyst plist, pbxproj).
- **Commit `rismay/substrate@008c5c50cb`** — path-scoped mono pointer bump.
  Auto-hook also created a follow-up commit bundling the pre-staged
  `.gitmodules` URL rename + `operator-collaborator-split.md` edits into
  `98af2941e9` — legitimate and rode along on the push.
- **Archive `** ARCHIVE SUCCEEDED **`** to `/tmp/clia-day-ios-b3.xcarchive`.
- **Packaged plist verified via PlistBuddy readback** on
  `clia-day-ios.app/Info.plist`: `CFBundleVersion=3`,
  `CFBundleShortVersionString=0.1.0`, `CFBundleIdentifier=com.wrkstrm.ios.app.today`,
  both purpose strings present with the final copy. Packaged-plist readback
  is the gate because `GENERATE_INFOPLIST_FILE=YES` + unsynced
  `INFOPLIST_KEY_*` build settings can make a source plist look correct while
  the archived plist is missing keys.
- **Export** via `xcodebuild -exportArchive` with a local
  `/tmp/clia-day-export-options.plist` (`method=app-store`, `teamID=BM6B69ZQSR`,
  `signingStyle=automatic`, `stripSwiftSymbols=true`, `destination=export`).
  Export succeeded with a deprecation warning: `method="app-store"` is
  deprecated in Xcode 26 in favor of `"app-store-connect"` — both currently
  accepted, flagged for a future cleanup.
- **altool flag rename discovered the hard way.** First `altool --validate-app`
  call with the Xcode 15/16 legacy flags (`--apple-id`, `--password`) errored
  with `AuthenticationFailure: Either JWT (--api-issuer and --api-key) or
  username and app password (--username, --app-password and
  --provider-public-id) authentication is required.` Xcode 26's altool has
  renamed the flags. Retry with `--username cmonterroza@gmail.com
  --app-password @env:APP_PASSWORD` succeeded with `VERIFY SUCCEEDED with no
  errors`. App-specific password pulled from
  `~/.appstoreconnect/credentials/com.wrkstrm.ios.app.today.json` auth.password
  via `jq` into a scoped shell env var so the secret never touched
  stdout or the `ps auxe` command line.
- **Upload `UPLOAD SUCCEEDED with no errors`** — Delivery UUID
  `aae939eb-7020-46a6-9473-cef455ac82a4`, 4,981,727 bytes transferred in
  0.715s @ 7.0 MB/s.

### Phase 4 — Foundation session design + tool naming correction

- Operator asked about automation and raised "use a foundation session"
  as an alternative. I initially interpreted "foundation session" as a
  triggered Claude Code sub-session and sketched an out-of-process JSON
  handoff architecture. **Operator corrected me: "b)" meant Apple's
  on-device `FoundationModels` framework**, not Claude Code. The architecture
  collapsed into a single Swift binary with a `LanguageModelSession` +
  `@Generable` typed output for the judgment layer. Zero API cost, offline,
  ~100ms-1s per judgment call on Apple Silicon.
- **Scale target set at 10 apps per day.** This rewrote the operator-
  attention budget from "confirm each copy draft" to "glance at novelty-
  flagged drafts only," forcing invariants (disclaimer blocklist, sibling
  permissions, packaged-plist readback, path-scoped commits, codex-sessions
  push guard) into **hard Swift-level enforcement** rather than advisory
  prompts to the model. A 3B on-device model can't be trusted to follow
  prompt-level guidance 10 times a day without occasional drift; at scale
  every advisory prompt is one silent regression per day.
- **Tool name corrected** from my initial `swift-ship-apple-apps` (plural,
  no `-cli`) to `swift-ship-apple-app-cli` (singular, `-cli` suffix). Matches
  the substrate convention: `swift-harness-environment-cli`,
  `swift-web-deploy-cli`, `swift-git-cli`. Batch behavior belongs inside a
  subcommand (`ship-all`), not in the tool's name.
- **Standalone SPM package** confirmed as the right shape (not a subcommand
  of `swift-harness-environment-cli`). One source of truth per tool, per the
  existing "Direct deps not transitive" rule.

### Phase 5 — hack-nu exploration (no writes)

- Operator asked "can we try this with hack nu?" Located
  `todo3/private/apple/apps/hack-nu/` — a Hacker News reader with a full
  fastlane pipeline (`Fastfile` with `archive` + `beta` lanes,
  `upload_to_testflight` via ASC API key not altool, Appfile pointing at
  `com.wrkstrm.ios.app.hackernews` team `BM6B69ZQSR`, scheme `HackerNews`,
  two plists at `App/Resources/Info.plist` and `Widgets/Resources/Info.plist`
  with NO purpose strings because the app doesn't link any permission-
  requiring frameworks). No pending rejection, no credentials file in
  `~/.appstoreconnect/credentials/` for hack-nu. Stopped before any writes
  because the auth model differs, the shipping pipeline differs, and the
  SOP design needs to absorb this heterogeneity as a `shippingFlow`
  discriminator in the brand identity.

### Phase 6 — Foundry SOP + reference tables seeded (uncommitted)

Operator said "the pattern we did today... we should work on that." Codified
the lived flow as three Foundry artifacts in a new
`schemas/apple-app-release/` subdir:

- **`SOP.apple.app-release.v1.json`** — 19-step doc-level SOP conforming to
  `sops/sop.schema.json`. Status `draft`. Required keys (schemaVersion,
  docType, id, title, status, intent, procedure, updated) present; no
  extra top-level keys (schema has `additionalProperties:false`); every
  procedure item has `step` + `action`; every input has `name` + `type`;
  every link has `title` + `ref`. 5 typed inputs, 13 named failure modes
  (ITMS-90683, disclaimer strings, sibling permissions missed, hardcoded
  CFBundleVersion trap, packaged-vs-source divergence, auto-hook sweeping,
  codex-sessions push, altool flag rename, build number collision, creds
  expiry, fastlane-vs-altool heterogeneity, novelty overflow, hallucinated
  evidence paths), 10 links (to the investigation, sibling tables, reference
  commits, ASC API docs, Foundation Models docs, and three memory files).
- **`apple-permission-table.v0.1.json`** — 14 Apple frameworks mapped to
  `(symbols, requiredKey, siblingKeys, itmsCode, reason)`: Speech,
  AVFoundation.Microphone, AVFoundation.Camera, Photos, CoreLocation,
  Contacts, EventKit.Calendars, EventKit.Reminders, HealthKit,
  LocalAuthentication, CoreMotion, CoreBluetooth, Network.LocalNetwork,
  NaturalLanguage.Translation. Each entry seeded with the Apple-documented
  symbol set + the sibling-permission rule that applies (Speech→Mic,
  HealthKit update→share, Photos read→add, Location WhenInUse→Always).
  Speech entry carries `verifiedBy` provenance pointing at today's
  clia-day remediation.
- **`apple-copy-library.v0.1.json`** — 2 approved drafts keyed by
  `(common-voice-input, NSMicrophoneUsageDescription)` and
  `(common-voice-input, NSSpeechRecognitionUsageDescription)`, each with
  `evidenceFiles` (actual paths of `CLIAVoiceEvidence+WrkstrmVoiceInput.swift`
  and `WrkstrmVoiceInputController.swift`), a `grounding` sentence, and
  `shippedInBuilds` history including the build 3 Delivery UUID. 11-phrase
  `disallowedPhrases` blocklist ("does not use", "not used by",
  "required because a dependency", "bundled dependency references", "this
  description is required", etc.) enforcing the no-disclaimer invariant.

All three files **left uncommitted** at end of session — operator approved
the shapes verbally but explicitly did not approve bundling a commit into
the winddown pass.

## Artifacts

### Production commits and ship

- `clia-app-org@34d7aa2` — iOS plist mic + speech strings (tightened copy,
  honest), CURRENT_PROJECT_VERSION 1 → 2
- `clia-app-org@c365cc3` — mac + catalyst plist mirror with
  display-name-matched copy, CURRENT_PROJECT_VERSION 2 → 3
- `rismay/substrate@30cde5deb6` — mono pointer bump for build 2
- `rismay/substrate@1edf8c52a0` — Foundry investigation
- `rismay/substrate@008c5c50cb` — mono pointer bump for build 3
- Delivery UUID `aae939eb-7020-46a6-9473-cef455ac82a4` — Today build 3
  uploaded to ASC App ID `1153239848` at 2026-04-08T14:48:26Z local, 4.9 MB
  IPA, `VERIFY SUCCEEDED` + `UPLOAD SUCCEEDED` with no errors

### Foundry artifacts

- `private/.wrkstrm/foundry/investigations/apple-app-release.investigation.md`
  (committed, 141 lines, 9 sections)
- `private/.wrkstrm/foundry/schemas/apple-app-release/SOP.apple.app-release.v1.json`
  (**uncommitted**, 19 procedure steps)
- `private/.wrkstrm/foundry/schemas/apple-app-release/apple-permission-table.v0.1.json`
  (**uncommitted**, 14 frameworks)
- `private/.wrkstrm/foundry/schemas/apple-app-release/apple-copy-library.v0.1.json`
  (**uncommitted**, 2 drafts + 11-phrase blocklist)

### Memories persisted

- `hulk/memory/.docc/feedback_purpose-strings-honest.md` — NS*UsageDescription
  strings must describe real user-observable behavior. Never disclaimer
  language. Never assume a permission is only transitive without asking.
  Grounded in today's specific failure mode.
- `hulk/memory/.docc/reference_appstoreconnect-credentials-schema.md` —
  `~/.appstoreconnect/credentials/<bundle-id>.json` top-level fields
  (`appleId`, `ascAppId`, `bundleId`, `team`, `auth`, `history`,
  `schemaVersion`), `auth` sub-object (`kind`, `label`, `password`,
  `createdAt`, `expiresAfter`), and Xcode 26 altool flag rename from
  `--apple-id` / `--password` to `--username` / `--app-password`.
- `hulk/memory/.docc/user_ship-ten-apps-a-day.md` — scale target and
  architecture thesis correction: on-device Apple `FoundationModels` as
  judgment layer in a Swift batch tool named `swift-ship-apple-app-cli`,
  NOT a Claude Code sub-session.
- `hulk/memory/.docc/MEMORY.md` updated with index entries for all three.

## Lessons

- **Purpose strings are user-facing, not compliance artifacts.** The
  disclaimer pattern I wrote first was wrong in multiple ways at once:
  self-contradictory ("I said Apple rejects this pattern, then wrote it"),
  dishonest to the user at the exact moment of the permission dialog, and
  factually wrong about the app's own behavior. The right failure mode is to
  refuse to write a string at all until you've read the source to understand
  what the user will actually experience — a hard invariant that now lives
  as a disallowed-phrases blocklist in the Foundry copy library.
- **Sibling permissions are table-driven, not rejection-driven.** Apple's
  validator only flagged the speech key on upload, but
  `SFSpeechRecognizer.startListening` requires microphone access at runtime.
  The rule is "Speech implies Mic" — not "Apple told me to add Mic." The
  permission table encodes the rule so the next speech-recognition app
  doesn't have to rediscover it via a runtime crash.
- **Packaged-plist readback is the gate, not source-plist presence.** With
  `GENERATE_INFOPLIST_FILE=YES`, the source plist and the `INFOPLIST_KEY_*`
  build settings together produce the final packaged plist; they can
  diverge silently. Always verify against the embedded Info.plist inside
  the `.xcarchive`, never trust the source file alone.
- **Path-scoped git commits are load-bearing in this workspace.** The
  auto-commit hook stages unrelated files (sometimes intelligently with
  coherent messages and Co-Authored-By trailers, sometimes sweeping
  unrelated working-tree state). `git commit <path>` — not `git add -a`
  or `git commit -a` — bypasses the index and captures only the named
  path's current content. Used twice today to avoid bundling unrelated
  `.gitmodules` changes into my commits.
- **Xcode 26 renamed altool flags.** `--apple-id` → `--username`,
  `--password` → `--app-password`. Legacy flags error out with
  `AuthenticationFailure` naming all three required flags in one message,
  so the error is self-documenting. Wrap altool behind a typed Swift
  helper in `swift-ship-apple-app-cli` so the rename is a one-line change
  in one place if it happens again.
- **"Foundation session" means Apple FoundationModels, not Claude Code
  sub-session.** This is a workspace-specific vocabulary and operator
  correction. I wasted ~15 minutes sketching out a JSON handoff protocol
  between a Swift CLI and a triggered Claude Code sub-session before the
  operator corrected me. At scale this would have been the wrong
  architecture — FoundationModels is in-process, offline, free, and
  integrates with the spine as a `@Generable` struct exchange, not a
  JSON round-trip. Saved as durable user memory.
- **At 10 apps/day scale, invariants must be Swift-enforced, not prompt-
  advised.** A 3B on-device model prompted with "do not write disclaimer
  strings" will occasionally write disclaimer strings. A Swift regex
  blocklist that rejects the write before it hits disk will not. Every
  guardrail from today's session — disclaimer blocklist, sibling permission
  expansion, packaged-plist readback, path-scoped commits, codex-sessions
  push guard, altool flag abstraction — belongs in the spine, not in the
  session's prompt.
- **Codifying the pattern before writing any code is cheaper than the
  other way around.** The 9-section investigation took ~20 minutes to
  write, then the three SOP / table / library JSON files took another
  ~15 minutes. The result is a concrete shape the next session can start
  building against without re-discovering the failure modes. An equivalent
  "let me just start coding" pass would have re-lived the same surprises
  (disclaimer strings, sibling permissions, flag renames, auto-hook races)
  because there was no durable record of them.

## Next

- **Commit the three Foundry artifacts** — SOP + permission table + copy
  library are uncommitted at end of session. Single path-scoped commit:
  `foundry: seed apple-app-release SOP + permission table + copy library`
  with the three files explicit.
- **Update the investigation doc** to add a §10 reflecting the spine +
  FoundationModels session split and the `swift-ship-apple-app-cli` naming
  fix. Keep the historical §1-9 intact.
- **Scaffold `swift-ship-apple-app-cli`** as a standalone SPM package at
  the default proposed home:
  `private/universal/substrate/collectives/wrkstrm-components/private/apple-release/swift-ship-apple-app-cli/`
  (operator to confirm or redirect). Minimum viable first slice:
  `swift-ship-apple-app-cli diagnose --bundle <id>` — reads brand identity,
  scans project symbols, computes required + sibling permission keys,
  prints a remediation plan. No writes, no archives, no uploads. This is
  the smallest slice that exercises every boundary (pbxproj parsing,
  permission table lookup, plist reading) without committing to the
  judgment layer yet.
- **Seed `brand-identities/` registry** with day-one apps. Known entries:
  Today (`com.wrkstrm.ios.app.today`), hack-nu
  (`com.wrkstrm.ios.app.hackernews`, fastlane shipping flow). Need operator
  input on the full day-one list (Prep Lab, Source Control, wrkstrm Pages,
  clia-mem, others?) and on the per-app `shippingFlow` discriminator
  (`altool` vs `fastlane-beta`).
- **Resolve the latent CFBundleVersion trap** in clia-day mac and catalyst
  target plists. They hardcode `CFBundleVersion = 1` and do not reference
  `$(CURRENT_PROJECT_VERSION)`. Two options: (a) rewrite to
  `$(CURRENT_PROJECT_VERSION)` and lift to project settings for single-
  source versioning, or (b) leave hardcoded and track independently in the
  SOP's `versioningTraps` field. Deferred — iOS target ships correctly
  today; mac and catalyst haven't gone to a store yet.
- **Decide on ASC API key rotation** — credentials today are
  app-specific-password with 1y expiry per Apple policy. At 10 apps × 1y,
  credential rotation will burn once every ~5 weeks on average. The
  `reference_appstoreconnect-credentials-schema.md` memory documents the
  current schema; the rotation tool doesn't exist. Separate thread.
- **Read the auto-commit hook source** still on the followup list from
  earlier today's env-profile cutover winddown. The layered behavior
  (intelligent edit-batching with trailers + still-active sweep of
  unrelated files) is understood from observation, but I've never
  actually opened `.git/hooks/` or `core.hooksPath` to see what's going
  on. Mark for the next breathing room.
