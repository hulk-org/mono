---
name: First real Komo mission
description: vision-komo OCR'd 261 EGM page images and extracted 953 game profiles in ~2 minutes — the first Komo that did real work, proving the ontology end-to-end
type: insight
---

# First Real Komo Mission (2026-04-12)

## What happened

The vision-komo — the second Komo after echo — ran its first
mission. It OCR'd 261 page images from the EGM Compendium vault
and extracted 953 structured game profiles from the footer strips
of the "1000 Best Games Ever" list.

## The numbers

- **Input**: 261 PNG images (pages 19-279)
- **Output**: 953 game JSON profiles
- **Runtime**: ~2 minutes
- **Binary**: 147 lines of Swift
- **Action**: crop bottom 8% → VNRecognizeTextRequest → regex parse → write JSON
- **One bug**: CG coordinate system is bottom-left origin; visual bottom of page = high Y, not y=0. Fixed in one line.

## Why this matters

This is the first time a Komo did real work. Not a ping. Not an
echo. A bounded mission with a real work graph (261 images), a
real action (OCR + parse), and real structured output (953 game
profiles that the Compendium app immediately loaded and displayed).

The ontology held:

- **Bounded**: 261 nodes, finite, closed
- **One action per node**: crop → OCR → parse → write
- **No memory between nodes**: each page processed independently
- **Context only**: the regex pattern and crop fraction, not accumulated state
- **Structured output**: one JSON per game, Codable, immediately consumable
- **Ghost-driven refinement**: the 8% crop fraction and regex pattern are the spec; improving them = Ghost work, not Komo work
- **Exited**: the process ran and stopped

The echo komo proved CLIDE can spawn things.
The vision-komo proved a Komo can produce value.

## The data flow

```
EGM vault (261 PNGs)
  → vision-komo (OCR + parse)
    → 953 game JSONs
      → egm-page-vault/games/
        → Compendium app loads them
          → CollectionDetailView shows sortable game list
            → GameProfileView shows individual profiles
```

From page image to clickable game profile in one Komo mission.

## The Fuchikoma connection

The EGM 1000 Best Games list includes the very pages where Ghost
in the Shell is mentioned (page 134). The Komo that reads those
pages is named after the think-tanks from that franchise. The
tool reads its own ancestry.

## What the spec looked like

```json
{
  "name": "vision-scan",
  "version": 1,
  "action": "fetch",
  "traversal": { "strategy": "breadthFirst" },
  "control": { "maxDurationSeconds": 300 }
}
```

That's the whole behavior envelope. The rest is the binary.

## The lineage

```
echo (v1)         → proves the contract
vision-scan (v1)  → proves the mission
??? (v2)          → RecognizeDocumentsRequest on macOS 26
                    for table extraction + data detectors
```

## Key sentence

The first Tachikoma walked the walls.
This one walked the footers.
