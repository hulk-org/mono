---
name: press-by-wrkstrm app
description: Publicity grading dashboard for web-visible substrate records — editors take stabs, publicist gives verdict, 1/16-retina scoring, EGM-faithful hero ranking aesthetic, worst-first triage to fix accumulated content rot
type: project
originSessionId: e45c8d90-ebba-4176-9460-670eb736f881
---
`press-by-wrkstrm` is a wrkstrm-app sibling to `page-deploy`. Its purpose: grade and manage everything actually visible on the web in the substrate, with worst-first triage to "fix the embarrassment of our public identity" (rismay's framing 2026-05-12).

**Locked design as of 2026-05-12:**

- **Slug:** `presense-by-wrkstrm` (renamed from `press-by-wrkstrm` on 2026-05-13); type prefix `Presense` (was `Press`); Swift module `PresenseSidecar_v000_001_000`
- **Display name:** `presense` (lowercase). Portmanteau of *presence* + *sense* + the original *press* metaphor — "your sense of presence online." Tagline: "your sense of presence online" (was "the magazine for your public face")
- **Bundle ID:** `me.rismay.presense-by-wrkstrm.macos.release` (was `me.rismay.press-by-wrkstrm.macos.release`). Pattern: `me.rismay.<slug>.<platform>.<channel>`.
- **Sidecar suffix:** `.presense.json` (was `.press.json`)
- **Schema directory** still at `wrkstrm/private/universal/schemas/press/sidecar/v0.1.0/` (path not yet renamed; only the Swift module and types renamed). Future v0.2.0 schema bump can move the directory to `presense/sidecar/v0.2.0/` cleanly.
- **Filter scope:** v0.4.0 records where `status == .published && visibility != .privateVis && surface ∈ {.staticSite, .dynamicSite}`. Source-mirrors, inline-markdown, drafts, and private records are excluded — those aren't "visible on the web."

**press vs. Compendium (product split confirmed 2026-05-12):**

- **press** — internal workflow app. Editors, publicist verdicts, worst-first triage queue, the doing.
- **Compendium** — sellable consumer brand for the rating workflow's *output*. The published magazine-issue / shareable archive. Probable revenue path. EGM is the model: EGM was the magazine staff did the work for; readers bought EGM (issues) + the Compendium (bound archive). For us: press is the office; Compendium is the magazine.
- v0.x lean: Compendium is a *mode inside press* ("publish issue" → renders the rated assets as a magazine-style HTML/PDF artifact), not yet a separate app. Split later if it earns it.
- Onboarding bar is magazine-quality polish because Compendium is a real revenue path. Onboarding IS the first review (5 steps: cover splash → pick a beat → add asset → take a stab → hero reveal → welcome to the desk). Last screen produces a sharable cover that's free marketing.

**Two-role workflow:**

- **Editor** (any agent — claude, gemini, rismay-as-editor) takes a stab; multiple `Editorial` entries per record allowed. Each Editorial has: editor slug, overall Score, Rubric (5 axes), notes, ISO-8601 editedAt timestamp.
- **Publicist** (mostly rismay) gives final `PublicistVerdict`: state ∈ `{promote, hold, archive, kill}`, reasoning, verdictAt. Verdict history is append-only — kill-and-revive cycles preserved as forensic record.

**Score type:** `Double` 1.0 to 10.0 in steps of `0.0625` (1/16). 145 valid values total. The 1/16 step is rismay's riso/Risograph/retina signature encoded into scoring. Display: hero rounds to nearest 0.5 (EGM-faithful "8.5"), tap-to-reveal shows full retina precision ("8.5625"), inspector shows step metadata.

**Rubric axes (5):** currency, clarity, design, depth, accessibility. Each scored independently. Overall is operator-set (not computed from rubric) — sometimes a record has F-tier currency but A-tier design that justifies keeping it.

**Storage:** sidecar `<slug>.press.json` next to `<slug>.share.json`. Same separation pattern as the share-record's notes-as-audit-trail. The corpus stays source-of-truth; press is metadata-on-top. Killing the press app means deleting `*.press.json` and the share-records are untouched.

**Attribution:** `.gemini | .rismay | .claude | .other(name) | .unknown` — the explicit Gemini-flag drives the "show only attribution=gemini" triage filter. Set per-record manually or by heuristic (oldest commitTimestamp, obscured visibility) on first triage.

**Default sort:** worst-first by editor-averaged overall score, ascending. Operator opens the app → sees the worst record they haven't killed yet. EGM Compendium aesthetic: hero score badge, color-coded attribution chip, live-URL reachable indicator, sub-rubric chips, verdict badge, editor-disagreement footer.

**`kill` is the only verdict with side effects:** marks share-record `status = .archived`, removes the gh-pages artifact, adds tombstone note. Every other verdict is sidecar-only metadata. UI requires a confirm dialog with the de-deploy plan.

**Why:** The substrate has accumulated content rot from prior contributors (notably "Gemini and team" from 2025). The corpus has no quality signal — page-deploy is the publish *engine* but has no opinion about what *should* be public. Without press, content rots invisibly and embarrassment accumulates. The app makes content rot a *visible* metric and gives editors+publicist a structured workflow to fix it.

**How to apply:**

- Build as a wrkstrm-app sibling at `wrkstrm-app/private/apple/apps/press-by-wrkstrm/`
- Schema family lives as its own SPM package (likely `wrkstrm/private/universal/schemas/press/sidecar/v0.1.0/`) — do NOT add fields to the share-record family; press is metadata-on-top
- Reuse `ShareCorpusLoader` filtering logic via a shared `ShareCorpusKit` package (extract from page-deploy when needed)
- v0.1 ships read-only worst-first dashboard with hero cards; editing + verdict-setting layers in v0.2
- v0.4.0 of share-record is what makes the filter predicate clean — `record.status` and `record.surface.kindLabel` and `record.visibility` are typed; v0.3.0 couldn't have expressed this
- Worst-first sort is load-bearing UI — do NOT default to alphabetical or chronological
- The riso/Risograph aesthetic shows up in: the 1/16 sub-pixel scoring step, the hero badge typography, the color palette (consider risograph-style overprint colors for the score badge)
