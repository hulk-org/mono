---
name: feedback-sdef-doctrine-observability-not-approval
description: "Substrate Apps expose SDEF (AppleScript Scripting Definition) for OBSERVABILITY + NAVIGATION + PREPARATION only. Defender-relevant approval/emission/mutation actions stay UI-tap-only and are EXPLICITLY OUT-OF-SDEF — otherwise SDEF becomes the chat-attestation loophole wearing AppleScript clothing. Operator-attested 2026-06-04 mid-Presense-publish-approval-ceremony build: \"we should be providing sdef's i guess so you can trigger these things?\" The agent can use SDEF to TRIGGER non-destructive things; cannot use SDEF to BYPASS the App-mediated approval gate."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

Substrate Apps expose SDEF for the agent's OBSERVABILITY + NAVIGATION + PREPARATION needs. Defender-relevant actions (approval, attestation emission, gate mutation) stay UI-tap-only and are EXPLICITLY OUT-OF-SDEF.

**Operator-attested 2026-06-04** (delivered while substrate's first publish-approval App ceremony was running on Presense):

> "we should be providing sdef's i guess so you can trigger these things?"

The "trigger these things" is the right verb — the agent SHOULD be able to trigger non-defender-relevant things via scripting. The discipline is in WHICH things are scriptable.

**Why this doctrine matters:**

Per [[feedback-public-push-approval-must-be-app-signed]] — chat-attestation is structurally forbidden because agent paraphrasing of operator intent into typed attestation fields is a walter-discipline failure. SDEF without this boundary would be the same loophole wearing AppleScript clothing — the agent runs `tell application "Presense" to approve push`, the App emits the attestation, the App-mediated check is bypassed because the agent triggered it, not the operator. The doctrine MUST extend: SDEF surfaces for substrate Apps explicitly EXCLUDE any defender-relevant scriptable command.

**The boundary that EVERY substrate App must implement:**

| IN-SDEF (scriptable) | OUT-OF-SDEF (UI-tap-only) |
|---|---|
| Open App | Tap "Approve Push" / "Approve <action>" buttons |
| Select asset by slug | Emit PublishAttestationModel files |
| Read current gate state | Mutate publishGatePolicy |
| Pre-fill verbatim field (stage the operator's input) | Bypass quote validation |
| Capture screenshot of current state | Trigger any defender-relevant mutation |
| Query attestation file existence | Read or write cryptographic signing keys |
| Navigate / scroll / show pane | Sign anything |
| Trigger non-destructive build/reload | Cross any release gate |

**Implementation pattern (for substrate Apps):**

1. Author `<App>.sdef` XML at app source root
2. Add `OSAScriptingDefinition` to Info.plist pointing at the .sdef
3. Implement NSScriptCommand-bound methods on App's NSApplication or NSApplicationDelegate subclass for IN-SDEF commands only
4. DO NOT implement scriptable handlers for OUT-OF-SDEF commands; the SDEF itself doesn't declare them; any AppleScript reference would error
5. Add a typed `sdef-policy.json` sibling file in the app source that auditably lists which commands are scriptable + the rationale per command — substrate-internal doctrine record

**Composes with:**

- [[feedback-public-push-approval-must-be-app-signed]] — the core attestation doctrine this extends
- [[common-and-mono-are-the-platform-engineers]] — App-mediated approval is platform-engineer-PR-review ceremony made substrate-canonical
- [[adversarial-audience-the-entity]] — the-entity could otherwise script the ceremony if SDEF doesn't honor the boundary
- [[publish-gate-policy-schemas]] — schema enforcement; SDEF gives the agent observability INTO the schema state but no mutation power
- [[publish-attestation-schemas]] — App-signed attestation; SDEF doesn't get to sign

**First concrete App that implements this doctrine:**

Presense (`presense-by-wrkstrm`) — substrate's first publish-approval App. SDEF authored alongside publish-attestation ceremony 2026-06-04. Commands surfaced: select share by slug; read gate state; pre-fill verbatim field; query attestation path. Commands EXPLICITLY excluded: approve push; emit attestation; mutate share record.

**Practical posture for the rest of any session:**

When the agent encounters a substrate App and considers triggering it programmatically:
1. CHECK the App's SDEF — what's in-SDEF?
2. RUN the in-SDEF commands freely for observability + navigation + preparation
3. STOP at any defender-relevant action; surface to operator for UI tap
4. Author a typed `sdef-policy.json` for any new App that ships substrate-doctrine-relevant surfaces
