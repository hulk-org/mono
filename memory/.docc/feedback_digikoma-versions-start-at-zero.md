---
name: digikoma-versions-start-at-zero
description: "Digikoma long-form versions are SEMANTIC versions encoded as `MMM_NNN_RRR` (major_minor_revision), zero-indexed at `000_000_000`. Initial forge = v0.0.0; first minor re-forge = v0.1.0; breaking change = v1.0.0; small revision bump = v0.0.1."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 641cb123-ea3e-422a-9376-e45c244bcca0
---

The long-form digikoma version string is a **SEMANTIC VERSION** encoded as three underscore-separated three-digit triplets: **`MMM_NNN_RRR`** = `MAJOR_MINOR_REVISION`. Each triplet has range 000–999. The third triplet is the **revision** — the smallest deliberate iteration unit.

## Vocabulary note

The third triplet is a **revision**, not a build. The distinction matters:

- A *build* is typically an automated CI artifact bump (e.g. every compile increments build) — not a substrate concept.
- A *revision* is a deliberate human-decided small iteration — a substrate concept. It records that someone made a conscious incremental change (prose fix, fixture refresh, error-message tightening) without claiming a contract movement worth a minor bump.

Revisions are the substrate's finest-grained intentional iteration knob. Bump them freely for small deliberate changes; do not bump them automatically.

## Decoding

| Long-form | Semver | Meaning |
|---|---|---|
| `000_000_000` | v0.0.0 | initial forge baseline (zero-indexed start) |
| `000_001_000` | v0.1.0 | minor re-forge — backwards-compatible feature/contract change |
| `000_002_000` | v0.2.0 | another minor re-forge |
| `000_001_001` | v0.1.1 | revision increment — small deliberate change, no contract movement |
| `001_000_000` | v1.0.0 | major re-forge — breaking change to the digikoma's typed contract |
| `001_002_003` | v1.2.3 | major 1, minor 2, revision 3 |

## Two important rules

1. **Start at `000_000_000`** (v0.0.0) for every new forge. The first lineage entry has `version: "000_000_000"`, `parentVersion: null`. Legacy digikomas auto-minted at `000_001_000` by the forge protocol's initial run stay where they are; don't shift them backward.

2. **Bump per semver semantics**, not as a flat counter:
   - **revision bump** (`000_001_000` → `000_001_001`) — small deliberate change, no contract impact (e.g. prose fix, performance tweak, fixture refresh)
   - **minor bump** (`000_001_000` → `000_002_000`) — backwards-compatible feature/contract extension (e.g. add new optional field, add new method)
   - **major bump** (`000_001_000` → `001_000_000`) — breaking change to the typed contract (e.g. rename a field, change a Codable shape, remove a method)

## Reset cascade (standard semver, must follow)

When a higher-order triplet bumps, ALL lower-order triplets reset to `000`:

| Starting from | Bump | Next version | What reset |
|---|---|---|---|
| `000_001_005` (v0.1.5) | **revision** | `000_001_006` (v0.1.6) | nothing — only revision changed |
| `000_001_005` (v0.1.5) | **minor** | `000_002_000` (v0.2.0) | **revision → 000** |
| `000_001_005` (v0.1.5) | **major** | `001_000_000` (v1.0.0) | **minor → 000, revision → 000** |
| `002_003_007` (v2.3.7) | **revision** | `002_003_008` (v2.3.8) | nothing |
| `002_003_007` (v2.3.7) | **minor** | `002_004_000` (v2.4.0) | **revision → 000** |
| `002_003_007` (v2.3.7) | **major** | `003_000_000` (v3.0.0) | **minor → 000, revision → 000** |

**Never** carry forward a lower triplet across a higher-order bump. A minor bump after a string of revision releases (v0.1.0 → v0.1.1 → v0.1.2 → v0.1.5) goes to v0.2.0 (`000_002_000`), not v0.2.5 (`000_002_005`). The revision counter for the new minor line starts fresh at 000.

The **integer-form ordinality counter** does NOT reset — it counts re-forge events monotonically and is independent of semver step size. A major bump still increments the integer by exactly 1, even though the semver string had two triplets reset.

## Integer-form sibling values

`スペック.json.version` and `ToolInvocationReceipt.digikomaVersion` are integers that count *re-forge ordinality* (which entry in `lineage.json`, zero-indexed) — independent of semver step size or reset cascades. So:

- lineage[0] = `"000_000_000"` (v0.0.0) → integer `0`
- lineage[1] = `"000_001_000"` (v0.1.0, minor bump) → integer `1`
- lineage[2] = `"000_001_001"` (v0.1.1, revision bump) → integer `2`
- lineage[3] = `"000_002_000"` (v0.2.0, minor bump — revision reset) → integer `3`
- lineage[4] = `"001_000_000"` (v1.0.0, major bump — minor + revision reset) → integer `4`

The integer counts *how many times this digikoma has been re-forged*; the semver string describes *how each re-forge relates to the prior contract* including the reset cascade. They're orthogonal axes — the integer is monotonic +1 per re-forge; the semver can take any step size at any re-forge AND must reset lower triplets per the cascade table above.

## How to apply

When **forging** a new digikoma:
- lineage entry: `"version": "000_000_000"`, `"parentVersion": null`
- スペック.json: `"version": 0`
- Swift static lets: `digikomaVersion = "000_000_000"`, `digikomaVersionInt = 0`

When **re-forging** an existing digikoma:
- decide semver step (revision / minor / major) based on contract impact
- apply the reset cascade if minor or major bumps
- new lineage entry: `version` = new semver long-form, `parentVersion` = prior lineage entry's `version`
- integer counters: increment by exactly 1 (one more entry in lineage)
- Swift static lets: match the new semver string + new integer

## Why "revision" terminology matters

Calling the third triplet a "revision" rather than a "build":

1. Aligns with the substrate's typed-contract discipline — revisions are deliberate, human-decided, recorded in lineage with a `summary` explaining the change. Builds (in the CI sense) would be silent and automated.
2. Prevents the misreading that the substrate runs CI-style auto-bumping per compile. It doesn't — every triplet bump is a forge/re-forge event with operator or agent intent.
3. Gives the substrate a fine-grained intentional iteration knob that's distinct from "no version change at all" and distinct from "minor contract bump."

## History

Operator-stated 2026-05-26 across four clarifications:
1. "We should start digikoma at 000_000_000" — zero-indexed start
2. "The versions are semantic versions with the last 3 000 being builds essentially" — semver structure (third triplet is the smallest unit)
3. "The build resets back to 0 when there is a minor bump" — standard semver reset cascade
4. "I mean the 3rd triplet is a revision right?" — terminology correction: the third triplet is a **revision**, not a build

Together these define the digikoma version contract.

## Related

- [[feedback_digikoma-lineage-long-form-versions]] — companion rule on the wire format + the version-format table across surfaces
- [[feedback_supplements-vs-digikomas-during-vs-turn-end]] — broader digikoma vocabulary doctrine
- [[feedback_substrate-toolmaking-checklist]] — re-forging is a substrate toolmaking activity
