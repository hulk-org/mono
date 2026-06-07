---
name: project-clia-us-wrkstrm-com-shared-invite-infra
description: clia.us and wrkstrm.com share signup/invite infrastructure — the InvitationModel + invite-flow web component + Firebase Auth handoff + token-resolution Worker are one substrate layer that both sites render as projections (2026-05-26)
metadata:
  node_type: memory
  type: project
  originSessionId: a49b7129-8123-47ec-8e5e-da15541654ec
---

Operator-stated 2026-05-26: *"this will be shared infra with wrkstrm.com —
which we need so this is a 2 for 1."*

The signup/invite flow for clia.us is **not a clia-only surface**. It is
shared substrate infrastructure that both `clia.us` and `wrkstrm.com`
consume. Building it serves both domains in one motion.

**Shared layers (build once, consume twice):**

- `InvitationModel` typed schema in
  `schema-universal/.../domain/<identity|org>/schema-families/invitation-schemas/v0.1.0/`
- Invitations kura collection at
  `kura-org/.../kura/collections/invitations/` — typed records, audit trail
  across both sites
- Invite-flow web component inside
  `collectives/wrkstrm/public/web/wrkstrm-com-elementary-ui/web-components/`
  — rendered by both `wrkstrm-com-elementary-ui` and (new)
  `clia-us-elementary-ui`
- Firebase Auth handoff — already proven in wrkstrm.com's
  `infra/firebase-runtime.ts`; reused
- Token-resolution Cloudflare Worker — sibling pattern of
  `wrkstrm-app-mirror-worker`

**Per-site surfaces:**

- `wrkstrm-com-elementary-ui` already registered in
  `public-site-stack.wrkstrm.json`; gains `/join` + `/operators/*` routes
- `clia-us-elementary-ui` does NOT exist yet; clone the wrkstrm-com
  pattern, register as fourth `siteInstance`, set up its own Pages
  projects + apex routing

**Backend choice (2026-05-26):** Worker + Fly/CouchDB pattern, same
topology as wrkstrm.com diligence-room data path. No new credential
refs needed — reuses `vault://credentials/cloudflare-api-token`,
`vault://credentials/firebase-service-account`,
`vault://credentials/fly-couchdb`. CouchDB design doc mirrors
`collective-invitation-schemas` v0.1.0 record shape. Worker endpoints:
`GET /join?token=X` (render acceptance page),
`POST /join/accept` (finalize after Firebase Auth + trigger GitHub
org-invite + write accept to CouchDB), `GET /operators/<slug>` (render
operator profile from operator home + CouchDB).

**Open sync-direction problem:** kura `invitations/*.invitation.json` is
substrate-truth; CouchDB is the Worker's runtime cache. Bidirectional
sync needed (substrate issues → CouchDB; CouchDB mutations → substrate
commits). Three candidate patterns: one-way + nightly scan daemon,
event-sourced live emission, or accept CouchDB-canonical-during-runtime
with kura as eventual-consistency archive (NOTE: third option breaks
substrate-truth doctrine; only acceptable with explicit operator
sign-off). Worth its own design session before Phase 2 begins. Bead
candidate: `clia-org` or `kura-org` agenda.

**Why this matters:**

- Avoids two divergent signup flows across the two flagship domains
- Lets [[feedback_data-is-one-thing-rendering-is-projection]] reach the
  auth/membership layer, not just the content layer
- First invitation record (Amanda) becomes the canonical instance
  exercising the shared schema before wrkstrm.com adopts it for its own
  invites

**How to apply:**

- Any schema or web-component work for invites lands in the shared layer
  FIRST, the per-site surfaces consume it
- Future ask "build a signup for X" — check whether the shared layer
  covers it before forking
- After the deploy lands, both `clia.us/join` and `wrkstrm.com/join`
  should resolve through the same Worker route logic with different
  audience/branding

Related:
- [[user-relationship-amanda-champagne]]
- [[project-amanda-thursday-interview-2026-05-28]]
- [[feedback_data-is-one-thing-rendering-is-projection]]
- [[feedback_content-lives-in-its-owners-home]]
