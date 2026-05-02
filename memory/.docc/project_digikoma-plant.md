---
name: digikoma-lab コマラブ
description: The Digikoma lab app (renamed from digikoma-plant 2026-04-15) — gym + factory for the fleet. Stage World, TurnGraph debug, eval runs, profile persistence. Lives at digikoma-org/apps/digikoma-lab/.
type: project
---

**digikoma-lab** (コマラブ, formerly digikoma-plant) — the lab where Komo are built, staged, validated, and dispatched.

**Renamed:** `digikoma-plant` → `digikoma-lab` on 2026-04-15 for brand consistency with the "Lab" naming convention.

**Target:** `digikoma-org/private/apple/apps/digikoma-lab/`

**Surfaces:**
- Stage World gym — fixture-staged isolated worlds for rehearsing Digikoma inside Seatbelt sandboxes
- TurnGraph debug — visual design + simulation of work graphs with handoff packets
- Eval runs — audit + scoring of the fleet
- Profile persistence — Save Profile button archives `.sb` profiles to koma homes under `profiles/<os-version>/`

**Phase 2 still pending:**
- CLIDE dispatch (invoke any Komo through the daemon)
- Live result streaming
- Metal canvas layer for spatial fleet visualization
- Beat visualization (ephemeral execution traces)

**How to apply:** New work goes into `digikoma-lab`. The ancestor `digikoma-by-wrkstrm` in wrkstrm-app is retired Phase 1.
