---
name: koma-lab コマラブ
description: The Koma lab app (renamed from koma-plant 2026-04-15) — gym + factory for the fleet. Stage World, TurnGraph debug, eval runs, profile persistence. Lives at koma-org/apps/koma-lab/.
type: project
---

**koma-lab** (コマラブ, formerly koma-plant) — the lab where Komo are built, staged, validated, and dispatched.

**Renamed:** `koma-plant` → `koma-lab` on 2026-04-15 for brand consistency with the "Lab" naming convention.

**Target:** `koma-org/private/apple/apps/koma-lab/`

**Surfaces:**
- Stage World gym — fixture-staged isolated worlds for rehearsing Koma inside Seatbelt sandboxes
- TurnGraph debug — visual design + simulation of work graphs with handoff packets
- Eval runs — audit + scoring of the fleet
- Profile persistence — Save Profile button archives `.sb` profiles to koma homes under `profiles/<os-version>/`

**Phase 2 still pending:**
- CLIDE dispatch (invoke any Komo through the daemon)
- Live result streaming
- Metal canvas layer for spatial fleet visualization
- Beat visualization (ephemeral execution traces)

**How to apply:** New work goes into `koma-lab`. The ancestor `koma-by-wrkstrm` in wrkstrm-app is retired Phase 1.
