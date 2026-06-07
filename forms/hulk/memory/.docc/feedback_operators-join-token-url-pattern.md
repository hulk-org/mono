---
name: feedback-operators-join-token-url-pattern
description: "Canonical substrate URL shape for invite acceptance is `<surface>/operators/join/<token>` — same namespace as `/operators/<slug>` profiles, path IS the credential, `join` is a reserved sub-slug"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a49b7129-8123-47ec-8e5e-da15541654ec
---

Operator-stated 2026-05-26: *"wait we can have an operators/join/{invite}"* —
this is the canonical URL pattern for substrate invite acceptance.

**The pattern:**

```
https://<surface>/operators/join/<token>      ← invite acceptance
https://<surface>/operators/<slug>            ← public operator profile
```

Both live in the same `/operators/*` namespace and are rendered by the
same Worker. The Worker pattern-matches:

- `/operators/<slug>` where `slug != "join"` → render profile
- `/operators/join/<token>` → render invite-acceptance flow → on
  accept, redirect to `/operators/<new-slug>` (the newly-live profile)

**Why this beats `/join?token=X` alongside `/operators/<slug>`:**

1. One URL namespace owns the whole operator graph — view existing
   operators AND add new ones via invite-accept
2. The path IS the credential (URL-as-credential pattern); no query
   string, cleaner shape, no `?token=` to copy-paste-mangle
3. The transition from invitee to operator is encoded in the URL
   grammar — `/operators/join/<token>` → redirect to
   `/operators/<new-slug>` is a sibling-path move, not a scheme jump
4. Same Worker, same backend (Fly/CouchDB per
   [[project-clia-us-wrkstrm-com-shared-invite-infra]]), no new
   route family
5. Composes with [[feedback_clia-us-operators-is-operator-home-projection]] —
   the projection layer at `/operators/*` is the public face of the
   operator graph; invite-accept IS the moment of joining that graph,
   so it belongs in the same namespace

**Reserved sub-slugs** (operators cannot claim these because of URL
collision):

- `join` (definitely reserved as of this pattern landing)
- Likely future reservations: `all`, `me`, `new`, `index`

When a new operator's slug is proposed, check against this reserved
list before commissioning their home.

**Applies to:**

- `clia.us/operators/join/<token>` and `clia.us/operators/<slug>`
- `wrkstrm.com/operators/join/<token>` and `wrkstrm.com/operators/<slug>`
- Any future surface that renders the operator graph; the URL pattern
  travels with the renderer, not the domain

**How to apply:**

- When generating invite URLs for any future operator invitation, use
  `https://<surface>/operators/join/<token>`, never `?token=X`
- When designing the Worker route table, this is one route with
  branching, not two routes
- When proposing an operator slug, run it through the reserved-slug
  check first
- When designing other live-mutation flows in the operator graph
  (operator-profile-edit, voice-donation-consent, etc.), prefer
  path-as-credential patterns over query-strings for the same
  reasons that justify this one
