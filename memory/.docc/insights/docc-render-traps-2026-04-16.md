# DocC Render Traps — 2026-04-16

## What this is

Three traps that silently break `xcrun docc convert` output on
`.docc/` bundles in this substrate, discovered while rendering
greatest-hits engineering tours for three collectives
(`wrkstrm-performance`, `wrkstrm-metal-components`, `wrkstrm-games`).

Each trap produces a render that *looks* successful (exit 0, an
archive is produced) but is actually broken — an article silently
absent from `data/documentation/`, or cross-references emitting
warnings that resolve nowhere. The archive opens in Xcode's DocC
viewer; you just can't navigate to half the content.

Capturing here so the next agent rendering a new `.docc/` bundle
skips the full afternoon of diagnosing why their root article
doesn't show up.

## Trap 1 — `@Metadata` before `# H1` silently skips the article

### Symptom

`xcrun docc convert some/.docc --allow-arbitrary-catalog-directories
...` exits 0. The output archive contains sibling articles but
**not** the `index.md` / root article. Warning emitted (but not
fatal):

```
warning: An article is expected to start with a top-level heading title
```

### Cause

DocC requires every article to start with a `# H1`. If
`@Metadata { ... }` appears above the H1, DocC parses the block,
fails to find the title, and skips the article's render instead of
errorring out the whole convert. The directives inside `@Metadata`
(including `@TechnologyRoot`) never take effect because the
article was rejected before metadata was applied.

### Example that fails

```markdown
@Metadata {
  @TechnologyRoot
  @PageColor(gray)
  @TitleHeading("My Collective")
}

# My Collective
```

### Example that works

```markdown
# My Collective

@Metadata {
  @TechnologyRoot
  @PageColor(gray)
  @TitleHeading("My Collective")
}
```

### How to detect

Run `xcrun docc convert` and check `data/documentation/` in the
output archive. If the directory contains sibling articles but
**not** `index.json`, the root article was rejected. Check the
first line of `index.md`.

## Trap 2 — `<doc:path/article>` from siblings can't resolve

### Symptom

Warnings like:

```
warning: 'investigations' doesn't exist at '/Bundle-Name/greatest-hits'
  --> greatest-hits.md:45:3-45:45
```

The link renders in HTML but points nowhere useful — DocC emits the
text as a broken ref, not a clickable link.

### Cause

DocC resolves `<doc:foo>` **relative to the current article's
curation path**, not relative to the bundle root. From
`index.md` (whose curation path is the bundle root),
`<doc:investigations/json-decoder-shootout>` resolves to
`/Bundle/investigations/json-decoder-shootout`. From a sibling
article `greatest-hits.md` (whose curation path is
`/Bundle/greatest-hits`), the same reference tries
`/Bundle/greatest-hits/investigations/json-decoder-shootout` and
fails.

This is why existing `.docc/index.md` files that cross-reference
articles via `<doc:investigations/X>` render fine, but the same
syntax copy-pasted into a sibling article produces warnings.

### The fix

Cross-reference sibling articles by **basename only**. DocC's
global symbol table resolves basenames regardless of current
context:

```markdown
<!-- From index.md (root) — path form works, basename also works: -->
<doc:json-decoder-shootout>
<doc:investigations/json-decoder-shootout>

<!-- From sibling article (greatest-hits.md) — basename only: -->
<doc:json-decoder-shootout>     <!-- ✅ resolves -->
<doc:investigations/json-decoder-shootout>   <!-- ❌ warning -->
```

Rule of thumb: **always use `<doc:basename>`**. Works from any
article. Works during curation reorganization (you can move
`foo.md` between directories without updating cross-refs). Only
break this rule if you have two articles with the same basename
and need disambiguation.

## Trap 3 — `@Available(platform: macOS, introduced: "26.0")` is malformed

### Symptom

Two warnings per `@Available` directive:

```
warning: Unknown argument 'platform' in Available. These arguments
are currently unused but allowed: '', 'deprecated'.
warning: Missing argument for unlabeled parameter
Available expects an argument for an unnamed parameter that's
convertible to 'Platform'
```

Does not block rendering on its own, but combined with Trap 1 (H1
ordering) may compound into a silent article skip.

### Cause

DocC's `@Available` directive takes the platform as the **first
positional argument**, not as a labeled `platform:` argument. The
labeled form was likely copy-pasted from Swift source's
`@available(macOS 26, *)` attribute, which *does* use unlabeled
positional syntax but in a different grammar.

### The fix

Either drop the directive (it's optional metadata) or use the
positional form:

```markdown
<!-- ❌ malformed -->
@Available(platform: macOS, introduced: "26.0")

<!-- ✅ correct -->
@Available(macOS, introduced: "26.0")

<!-- ✅ also fine — just omit it -->
(no @Available line)
```

## The canonical article skeleton (copy-paste this)

### Root article (`index.md`) — one per bundle, carries @TechnologyRoot

```markdown
# Collective Name

@Metadata {
  @TechnologyRoot
  @PageColor(blue)
  @TitleHeading("Collective Name")
}

> One-sentence TL;DR in a blockquote for prominent rendering.

## Start here

- <doc:greatest-hits> — curated entry-point tour.

## Topics

- <doc:article-a>
- <doc:article-b>
```

### Sibling article — @PageKind(article), basename refs

```markdown
# Article Title

@Metadata {
  @PageKind(article)
  @PageColor(blue)
  @TitleHeading("Short Display Heading")
}

> One-sentence TL;DR in a blockquote for prominent rendering.

... body ...

## Cross-references

- <doc:sibling-basename-a>
- <doc:sibling-basename-b>
```

## Running the render

```bash
xcrun docc convert path/to/.docc \
  --allow-arbitrary-catalog-directories \
  --fallback-display-name "Collective Name" \
  --fallback-bundle-identifier io.example.mycollective \
  --output-dir /tmp/MyCollective.doccarchive
```

The `--allow-arbitrary-catalog-directories` flag is required
because our catalog directories are named `.docc` (a hidden
dotfile) without the `.docc` file extension DocC normally expects.
Per the CLAUDE.md DocC standard, `.docc/index.md` is the canonical
contract, not `README.md`.

## Validation checklist

After running the convert, check:

1. `output.doccarchive/data/documentation/index.json` exists → root
   rendered (Trap 1 clear).
2. Every sibling `.md` has a matching `.json` in
   `data/documentation/<bundle-slug>/` → siblings rendered.
3. Render output has zero `warning:` lines from your new files
   (grep the convert output; pre-existing warnings in other files
   are someone else's problem).
4. The archive opens in Xcode's DocC viewer via `open`.

## Cross-references

- `wrkstrm-performance/.docc/playbooks/swift-hot-path-playbook.md` —
  Discipline 8 of the substrate hot-path playbook codifies the same
  rules as a forward-looking standard (as opposed to this
  insight's backward-looking incident log).
- `wrkstrm-performance/.docc/greatest-hits.md` +
  `wrkstrm-games/.docc/greatest-hits.md` +
  `wrkstrm-metal-components/.docc/greatest-hits.md` — three
  greatest-hits tours landed this session; all three needed the
  Trap 1 / Trap 2 / Trap 3 fixes before they rendered cleanly.
