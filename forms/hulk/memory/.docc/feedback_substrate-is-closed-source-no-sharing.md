---
name: substrate-is-closed-source-no-sharing
description: "The substrate stack the agent is helping build is closed-source and no-sharing — no public web surfaces, no App Store / TestFlight framing, no public showcase routes, no SendUserFile to external recipients, no public release packets"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

The substrate stack the operator and agent are building is **closed-source
and not for sharing**.

**Operator's exact words (2026-06-04, after I authored a public
digikoma-showcase route + framed the launch-review checklist around
public-release blockers):**
> this is all close source and NO sharing.

**What this rules out:**

- Authoring `public/` web directories under any substrate collective for
  "showcase" / "marketing" / "audit projection" purposes.
- Framing release readiness as "shippable to App Store / TestFlight" vs
  "internal proof." There is no public-ship destination.
- Adding a `primary-public` audience packet to the
  `AudienceProfileStack`. Public audiences don't exist in this substrate.
- Proposing public-internet showcase routes (`<domain>/transpile/<id>`,
  `<domain>/labs/`, etc.) for any substrate-typed output.
- Recommending public-issue trackers, public-package-registry uploads,
  public GitHub releases.
- Sharing substrate-typed artifacts to recipients outside the operator's
  own machine via tooling that publishes externally.

**What this DOES NOT rule out:**

- `SendUserFile` of artifacts BACK TO THE OPERATOR via the agent's own
  chat surface — that is the operator viewing their own files, not
  sharing.
- Maintaining the `the-entity` adversarial audience packet — the
  defender check still applies because **future** leakage from screenshots,
  commit-history pushes, or operator-error must be defended against.
  Closed-source is a posture, not a guarantee.
- Building internal-only showcase / studio / audit surfaces under
  `private/`. The substrate uses lots of internal-projection surfaces
  for operator review; those stay closed.
- Engaging operator-curious / operator-internal audiences — the operator
  themselves is an audience, and trusted-collaborator audiences may
  apply per the substrate's invite + signed-room patterns. But "public
  internet" is not in the audience-stack.

**Cross-references:**

- [[adversarial-audience-the-entity]] — defender doctrine still applies
  to closed-source surfaces because of leakage risk.
- [[audience-packet-must-precede-content-reference]] — closed-source
  audience packets still need to exist before any content references
  them.
- [[No GitHub pushes — pending Codeberg or self-hosted git server migration]] —
  reinforces this: substrate stays off public forges.
- [[GitHub remote migration in progress - no push]] — same.
- [[do-not-break-domain-driven-design]] — public/ vs private/ is itself
  a domain boundary; conflating them is DDD violation.
- [[brand-docs-must-reflect-rendered-site]] — closed-source brand-docs
  still need to reflect what would render internally; just not externally.

**How to apply going forward:**

1. When the operator asks for "a site" / "a page" / "a surface,"
   default to `private/` placement and ask before adding `public/`.
2. When framing release packets, the binary is
   "operator-internal-ready" vs "blocked-from-operator-internal-use,"
   NOT "internal-only" vs "public-ship."
3. The AppKind taxonomy
   (`demoGym` → `demoMuseum` → `demoZoo` → `product`) still applies as
   internal-quality tiering, but `product` doesn't mean App Store
   shipped — it means production-quality internal use.
4. The transpile pipeline's `digikoma-showcase` should live at
   `digikoma-org/private/.../studio/` or similar, NOT
   `digikoma-org/public/web/`. The 2026-06-04 cascade authored it in
   `public/` and needs a corrective move.
