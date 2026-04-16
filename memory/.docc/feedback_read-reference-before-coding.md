---
name: Read reference before coding
description: When told to match an existing app's look, read the FULL reference implementation before any edits — don't skim and guess
type: feedback
---

When the user says "make it look like X app," read the entire root view and palette system of X before touching any code. Don't skim a few lines, grab one color, and start iterating.

**Why:** Repeated failure on Source Control header — user said "look at koma-plant" three times. Each time I skimmed fragments, guessed at colors, and shipped something wrong. The issue was never one color — it was the full palette system (canvas, paper, ink, steel, sign, signDeep), sidebar styling, shell configuration, and font choices all working together. I kept fixing the header while ignoring that the whole app needs the same palette discipline.

**How to apply:** When matching a visual reference:
1. Read the reference app's root view end-to-end
2. Extract the full palette/style system
3. Map each palette role (canvas, paper, card, accent, header) to the new color family
4. Apply ALL roles before building — don't ship with only the header changed
5. Never guess at RGB values — transpose the reference's actual values
