---
name: feedback-clia-us-operators-is-operator-home-projection
description: "`clia.us/operators/<slug>` is the canonical PUBLIC WEB PROJECTION of a substrate operator home — storage at `operators/<slug>/`, projection at the URL; Amanda is the first instance, but the pattern applies to every operator"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a49b7129-8123-47ec-8e5e-da15541654ec
---

Operator-stated 2026-05-26: *"so this is the first clia.us/operators/***
profile essentially. it's the web version of an operators profile!"*

**The rule:** every substrate operator home gets a public web projection
at `clia.us/operators/<slug>/`. The substrate-side path
(`private/universal/substrate/operators/<slug>/`) is the source of
truth; the URL is one rendering of that source. This is the
[[feedback_data-is-one-thing-rendering-is-projection]] doctrine reaching
the operator-graph layer.

**Composes with:**

- [[feedback_data-is-one-thing-rendering-is-projection]] — same source,
  many lenses possible (JSON export for partner-app, print-CV,
  README-roster-card, etc.); `/operators/<slug>` is one projection
- [[feedback_content-lives-in-its-owners-home]] — the public projection
  inherits ownership from the operator home; misplaced content does
  not get rescued by a renderer
- [[feedback_audience-first-workflow-public-pages]] — every operator
  profile is a public page, so each needs an AudienceProfileStack with
  [[feedback_adversarial-audience-the-entity]] at ordinal 1
- [[feedback_release-gate-audience-review]] — the audience-review
  release gate applies per-profile; no operator profile ships public
  without passing it
- [[project-clia-us-wrkstrm-com-shared-invite-infra]] — the shared
  invite infrastructure now has a destination beyond `/join`: the
  invited operator's `/operators/<slug>` profile, which becomes live
  on acceptance
- [[user-clia-voice-imagined-as-amanda]] — voice samples (vault, in
  her home, private) project as a synthesized playback sample on her
  public profile; raw corpus sealed, synthesis public

**Implications for substrate work:**

- New typed family needed: `operator-profile-projection-schemas`
  defining which operator-home fields are public-renderable, which
  stay private, and how the lens converts one to the other. Status:
  not yet authored.
- The renderer (likely a Cloudflare Worker route consuming the
  operator home as data) becomes a substrate primitive consumed by
  both `clia.us/operators/*` and (per 2-for-1) any other domain that
  wants to render an operator roster.
- 2-for-1 framing now potentially 3-for-1: clia.us + wrkstrm.com both
  render the same operator profiles, possibly with different
  audience stacks (clia.us audience = builders/partners; wrkstrm.com
  audience = investors/diligence) producing different sub-projections
  from the same underlying operator home.
- Amanda being the FIRST means we're not just inviting her — we're
  scaffolding the entire `/operators/*` URL pattern with her as the
  canonical instance. Subsequent operators (rismay, johnwhitecastle,
  etc.) clone the pattern she validates.

**How to apply:**

- When the user says "invite X to clia.us/operators," read it as
  "build the projection layer with X as the first instance" — not
  just an invitation.
- When designing what goes public on an operator profile, run the
  audience-first workflow first (Entity-at-1, friendly profiles
  after) before deciding fields.
- When a new operator joins, the substrate-side onboarding (home,
  identity bundle, kura) AND the projection-side onboarding (profile
  page) are two halves of the same act, not separate steps.
- When the renderer ships, all existing operator homes become
  retroactively projectable — but the audience-review gate still
  applies per profile, so they don't auto-ship; each operator's
  consent + Entity-defense check is per-instance.

**Inverse direction:**

If we ever want to add public-facing data about an operator that
isn't backed by their home, that's an anti-pattern — projection
without source. Add to the home first, then the projection renders
naturally.
