---
name: IdentityRefModel v0.1.0 is dead — use LinkRefModel v0.3.0
description: Substrate doctrine — IdentityRefModel was a pre-LinkRef-v0.3 mistake. Every typed ref into another substrate entity uses LinkRefModel v0.3.0. Don't author new IdentityRefModel refs; migrate existing ones.
type: feedback
originSessionId: 16ef30b5-1753-4832-9904-ef681c971ce8
---
**The rule**: every typed reference from one substrate entity to another uses `LinkRefModel v0.3.0`. `IdentityRefModel v0.1.0` is dead.

**Why:** IdentityRefModel was invented before LinkRefModel v0.3.0 existed. Once LinkRef v0.3 shipped — with its richer tagged-binding (`tg[]`) shape and explicit subject tags (`s[]`) — IdentityRefModel had no unique load it could carry that LinkRef couldn't carry better. Operator articulated 2026-05-23: "identity ref model was a mistake. it was invented before link ref v0.3 so we now know what to do." Both shapes were members of `core-entity-set-v1.0.0` (under `identity-ref-model-schemas v0.1.0` and `link-ref-schemas v0.3.0`), but LinkRef won the fight-for-life — IdentityRefModel is now legacy debt to migrate, not a choice.

**Two shapes for reference:**

IdentityRefModel v0.1.0 (DEAD):
```json
{
  "IdentityRefModel": "0.1.0",
  "kind": "org-role",
  "slug": "lead-program-manager",
  "title": "Lead Program Manager",
  "url": "private/universal/substrate/roles/lead-program-manager/private/universal/identity/lead-program-manager.org-role.json"
}
```

LinkRefModel v0.3.0 (CANONICAL):
```json
{
  "LinkRefModel": "0.3.0",
  "tg": [
    {"k": "rp", "v": "private/universal/substrate/roles/lead-program-manager/private/universal/identity/lead-program-manager.org-role.json"}
  ],
  "t": "Lead Program Manager",
  "s": ["org-role", "lead-program-manager"]
}
```

The same information, but LinkRef's `tg[]` is extensible (can hold scheme-side refs like `ss: agent://slug` alongside relative-path refs in `rp`), and `s[]` provides typed subject tags for queries. IdentityRefModel's flat `kind`/`slug`/`title`/`url` couldn't carry that.

**How to apply:**
- **Author new refs as LinkRef v0.3.0.** No IdentityRefModel in any newly authored file. (When I authored `operator-onboarding-steward.org-role.json` in this session, I already correctly used LinkRefModel v0.3.0 in the `links[]` field — that pattern is the doctrine.)
- **When touching a file that has IdentityRefModel refs**, migrate them to LinkRefModel v0.3.0 in the same edit. Don't leave dead-shape refs untouched in files you're already editing.
- **Cascade scope**: every bound agent's `roles[]` array currently uses IdentityRefModel v0.1.0 (verified 2026-05-23 on cadence, carrie, tau, etc.). All of them need migration. Substrate-wide ref-type sweep.
- **No backwards-compat shims.** Substrate doctrine: just change the shape. Don't introduce a "translate-IdentityRefModel-to-LinkRefModel" layer; just rewrite the refs.

**Related lessons in the same conversation**:
- `feedback_every-property-fights-for-its-life.md` — IdentityRefModel vs LinkRefModel is the canonical example of two property shapes fighting for the same semantic load; LinkRef v0.3 won, IdentityRefModel must come out as cleanup.

**Living cascade catalog (as of 2026-05-23):**
Agents observed using IdentityRefModel v0.1.0 in roles[]: cadence, carrie, tau, walter, common, patch, prime, quill, catch. Plus there may be others not in roles[] (e.g., other typed refs scattered through identities, agendas, chronicles). Real audit needed before migration sweep.
