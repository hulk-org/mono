---
name: Koma not Komo
description: canonical standalone noun is `Koma` (with -a) per Ghost in the Shell etymology — drop `Komo` (with -o) wherever it appears in prose, slugs, or types
type: feedback
originSessionId: 17bca72f-ee91-4f7a-8002-180df199eef5
---
Always spell the standalone noun as **`Koma`** (with -a), never `Komo` (with -o).

**Why:** the etymology is Japanese — コマ (koma), meaning "frame / piece /
top / standing unit." All three Ghost in the Shell ancestors of the substrate's
Komo concept end in `-koma` with -a:

- Fuchikoma (フチコマ) — Masamune Shirow's original spider-tank
- Tachikoma (タチコマ) — Stand Alone Complex evolution
- Logikoma (ロジコマ) — GiTS: Arise predecessor model

`Komo` with -o would be a different Japanese word (コモ) entirely. The substrate's
"Komo" appearances were drift from a single early typo that propagated through
prose memories without being challenged. Filesystem and schema layers always
kept the correct `koma`; only the standalone English-prose noun drifted.

**How to apply:**

- **Standalone**: `Koma` (the chassis, the execution unit, "deploy a Koma")
- **Compound prefix**: `Tachikoma`, `Logikoma`, `Digikoma` — already correct, never change
- **Slug / filesystem / schema**: `koma` (lowercase, -a) — already canonical
- **Katakana surface**: コマ — already canonical
- **Type names**: `KomaCard`, `KomaCaste`, `KomaFamily`, `KomaArcana`, `KomaSummonCost` — never `KomoCard` etc.

If you encounter `Komo` (with -o) in older memory entries, journal articles,
or prose, treat it as a typo and silently translate to `Koma` when reading.
When writing new prose, use `Koma`. The canonicalization decision was made
2026-05-06 in conversation with rismay; this entry is the doctrinal anchor.

Compound forms like `Digikoma`, `Tachikoma`, `Logikoma` were already correct
and stay unchanged. The fix is exclusively about the standalone -o → -a swap.
