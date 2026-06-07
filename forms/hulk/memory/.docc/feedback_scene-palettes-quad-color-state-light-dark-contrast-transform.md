---
name: scene-palettes-quad-color-state-light-dark-contrast-transform
description: Scene palettes carry a typed quad-color state (primary/secondary/tertiary/accent) with semantic roles preserved across palettes. Display state is just light/dark (2-valued). Increased contrast is a SINGLE runtime transform (HSL saturation amplification on a 0-1000 scale) — not split into light/dark variants. Target distinguishes desktop (standout colors fine) vs website-background (muted required).
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

When a substrate scene carries a palette catalog, the typed shape is:

**Quad color state (the 4 colors are semantic roles, not gradient stops):**

```
QuadColorState {
  primary       // dominant / base
  secondary     // mid-tone
  tertiary      // highlight
  accent        // far / contrast color
}
```

These names are preserved across palettes. Swapping palette = swap the
4 values, but `primary` is always "the dominant one," `accent` is always
"the contrast/accent one." Operator-readable across the whole catalog.

The shader binds:
- `uColor1` ← primary
- `uColor2` ← secondary
- `uColor3` ← tertiary
- `uColor4` ← accent

Per the original creator's `getGradient(t, c1, c2, c3, c4)` walking the
4 in cycle, so the order matters at the renderer surface even though
the API exposes named slots.

**Display mode is 2-valued (light or dark):**

```
DisplayMode { light, dark }
```

NOT four-valued. Earlier I authored `increased-contrast-light` and
`increased-contrast-dark` as separate modes — that's WRONG. There is no
"increased light" and "increased dark" — see Increased Contrast below.

**Increased Contrast is a SINGLE runtime transform:**

Operator's definition (2026-06-04):
> increased contrast means: colors less than 500 saturation get -100.
> colors above it +100.

Algorithm per channel:
1. Convert RGB → HSL.
2. Read saturation on a 0–1000 scale (HSL S × 1000).
3. If `S < 500`: new_S = max(0, S − 100).
4. If `S ≥ 500`: new_S = min(1000, S + 100).
5. Convert HSL back → RGB.

Result: muted colors get more muted, saturated colors get more saturated.
Net effect = greater dynamic range across the 4 quad-state colors.

This is a **runtime boolean transform** on the renderer state, not a
variant axis on the palette catalog. One contrast flag. Applies to
whichever colors are currently rendering, regardless of which palette
or mode or target.

**Scene target distinguishes use cases:**

```
SceneTarget {
  desktop                // standout colors fine — wallpaper, Backdrop scene
  websiteBackground      // muted colors required — sits behind CLI text
}
```

Operator's framing 2026-06-04:
> the desktop is fine to pick a palette that stands out.
> but then the website background, that requires a more muted palette.

When target is `websiteBackground`, the renderer applies a MUTE
transform (HSL saturation halved + lightness reduced) to the
current variant's colors UNLESS the palette has an explicit
(mode, .websiteBackground) variant — explicit variant wins.

**Composition rule (resolveColors):**

```
1. Look up palette.variant(mode, target).
2. If not found and target == .websiteBackground:
     take palette.variant(mode, .desktop).colors, apply muteTransform.
3. Else fall back to palette.primaryVariant.colors.
4. If increasedContrast: apply withIncreasedContrast to all 4 colors.
5. Bind to uniform slots primary→uColor1, ..., accent→uColor4.
```

**Catalog shape per palette:**

Required variants: `(.light, .desktop)` + `(.dark, .desktop)` (the
quad-color state for each base mode).

Optional explicit variants: `(.light, .websiteBackground)`
`(.dark, .websiteBackground)` — author these when the auto-mute
transform doesn't produce the desired look for a specific palette
(e.g. `substrate-nerv` for clia.sh).

**UI surface:**

Three small toggle rows + palette buttons:
- Mode: Light / Dark
- Target: Desktop / Website Background
- Contrast: Standard / Increased
- Palette: 7 named palettes

**Cross-references:**

- [[three-artifacts-per-ported-scene-capture-canonical-emission]] — the
  doctrine this palette architecture serves.
- [[per-scene-independent-spm-packages]] — palettes ship inside the
  scene's Package.
- [[role-classes-as-files-not-catalog]] — quad-color semantic roles
  parallel the substrate's typed-role approach.
- [[Open-extensible catalogs require three-valued logic — UNKNOWN is
  first-class]] — palette.variant() lookup returns nil when unknown;
  the resolve function decides the fallback (muteTransform vs primary).

**How to apply going forward:**

1. Any new scene palette catalog uses `QuadColorState` with
   primary/secondary/tertiary/accent as the typed slots.
2. Don't author `increased-contrast-*` as separate variants. Contrast
   is a runtime transform.
3. Author explicit websiteBackground variants only when the auto-mute
   doesn't land the right look.
4. HSL ↔ RGB math is shared via helpers (Swift extension, JS module
   function) so the transform is identical across arms.
