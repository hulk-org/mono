---
name: Clia Day Pa distribution
description: Clia Day's Collective view ships to Pa via rismay's personal App Store account, not wrkstrm or Laussat
type: project
---

Clia Day's Collective view (the `pa` collective lens) is distributed to Pa
through **rismay's personal Apple Developer / App Store Connect account**
(Cristian A Monterroza, personal legal entity — team `BM6B69ZQSR`, already
configured in `clia-day/project.yml`). TestFlight under that team is the
delivery channel for builds Pa actually installs.

**Why:** Clia Day is a clia-family app, but the Pa-facing distribution is a
personal/family channel — not a business one. It does not belong under
Laussat Studio LLC or wrkstrm Inc. Keeping it on rismay's personal account
matches the audience (a family member), keeps signing simple, and avoids
mis-attributing a personal distribution to a commercial entity.

**How to apply:**
- When wiring TestFlight, App Store Connect, or signing for any Pa-facing
  build of Clia Day, use rismay's personal account / team `BM6B69ZQSR`.
- Do not migrate Clia Day's Pa distribution to Laussat or wrkstrm without
  rismay explicitly changing this decision.
- Other Clia Day collectives (e.g. `clia-agents`, future teammate audiences)
  may use different distribution channels — this rule is specifically about
  the `pa` collective.
- Cross-reference: see `user_legal-entities.md` for the three-entity split;
  this is the personal-entity case.
