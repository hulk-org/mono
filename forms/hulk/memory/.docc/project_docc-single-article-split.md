---
name: DocC pipeline rescue (TechnologyRoot scaffolding + dotted-version routing)
description: Three stacked DocC bugs from 2026-04-09 — empty-archive on single-article TechnologyRoots, empty-archive on multi-article bundles missing ## Topics, and dotted-version directory paths 404-ing in DocCStaticSiteServer because URL.pathExtension reads digits from v0.1.0
type: project
---

Three stacked bugs in `DocCBrowserKit` were silently making every `schema-universal` `.docc` bundle render as a 404 in `schema-lab` even though `xcrun docc convert` was succeeding. All three landed together on 2026-04-09 in `wrkstrm-components/8d8987b` (mono `b014ad4232`). Same root cluster, different layers — keep them in mind together because they will recur in any DocC stack that shells out to `xcrun docc convert --transform-for-static-hosting`.

## 1. Empty-archive on lone TechnologyRoot

`xcrun docc convert ... --transform-for-static-hosting` produces a doccarchive with `interfaceLanguages: {}` (no `documentation/` tree, no `data/documentation/`) when the source `.docc` bundle contains only a single `@TechnologyRoot` markdown file with no siblings. The DocC SPA loads at `/`, finds an empty index, and shows its built-in "page can't be found" message. This is *not* a server bug — the archive really is empty.

**Why:** DocC's static hosting transform requires at least one navigable sibling article (or symbol graph, or tutorial) below the TechnologyRoot. A solitary `@TechnologyRoot` is metadata-only; nothing renders. Self-links from `## Topics` to the TechnologyRoot itself do not work — empirically pinned with six `xcrun docc convert` experiments in `/tmp/docc-experiments`.

**Fix shape (durable, content-preserving):** in the scaffolded copy of the bundle, split the lone markdown into:
- `index.md`: thin TechnologyRoot stub with `# Title`, `@Metadata { @TechnologyRoot @PageKind(article) }`, and `## Topics\n- <doc:Overview>`.
- `Overview.md`: the original H1 + body with the leading `@Metadata { ... }` block stripped.

DocC then emits `documentation/overview/index.html` + `data/documentation/overview.json`, the SPA navigation populates, and the visible page title is preserved from the H1 in Overview.md.

## 2. Empty-archive on multi-article bundle missing `## Topics`

A `.docc` bundle with multiple sibling `.md` files but no `## Topics` section in the TechnologyRoot leaves the siblings as orphans and the navigation index is empty in the same way. Surfaced on `universal-schema.architecture.docc`, which had `index.md` + `exact-schema-version-decoding-proposal.md` but never linked them.

**Fix shape:** in the scaffolded copy, scan the non-README sibling `.md` files. If the TechnologyRoot already has a `## Topics` section, trust the author and bail. Otherwise append a synthetic `## Topics` section listing each sibling as `<doc:filename-stem>`.

## 3. Dotted-version directory paths 404 in DocCStaticSiteServer

`DocCStaticSiteServer.fallbackCandidates` only added the `<dir>/index.html` fallback when `baseURL.pathExtension.isEmpty`. For DocC pages with dotted version names like `v0.1.0` or `v0.1.0-spm`, Swift's `URL.pathExtension` reads `0` or `0-spm` from the *last dot in the trailing path component*, so the gate fired exactly where it was needed most. Every dotted-version DocC topic link silently 404'd even though the rendered HTML was sitting on disk waiting to be served.

**Fix shape:** drop the `pathExtension.isEmpty` gate entirely. Always try the literal path, then `<path>/index.html`, then the docs index, then the SPA shell. The user-visible symptom of this bug is the static server's *plain-text* `404 Not Found` body in the WebView (different from the DocC SPA's *styled* "page can't be found" message — the two look almost identical but come from different layers).

**Rule of thumb:** never gate fallback logic on `URL.pathExtension`. Semantic-version segments contain dots and `URL.pathExtension` will read garbage from them.

## Where this lives

- `BundleRenderer.applyTechnologyRootScaffoldingIfNeeded` (and its helpers `splitLoneTechnologyRoot`, `injectTopicsListingSiblings`, `stripLeadingMetadataBlock`) in `wrkstrm-components/private/docc-browser/catalyst/spm/docc-browser-kit/Sources/DocCBrowserKit/BundleRenderer.swift`. Triggered from `prepareRenderBundleURL` for every scaffolded bundle (`.docc` extension or directory).
- `DocCStaticSiteServer.fallbackCandidates` in the same package's `DocCStaticSiteServer.swift`.
- Regression tests in `Tests/DocCBrowserKitTests/DocCStaticSiteServerResolutionTests.swift` (10 Swift Testing cases including explicit dotted-version guards).

## How to apply elsewhere

If a future DocC stack (e.g. the in-house `DocCPreviewUI` / `DoccPreviewer` at `swift-universal/.../swift-docc-preview-ui/`) is wired up, port both fixes:

- The TechnologyRoot scaffolding logic into its `BundleRenderer` — it shells out to the same `xcrun docc convert` and will hit the identical empty-archive cases.
- Audit any local static server for `URL.pathExtension`-based gates and rip them out.

Detect the empty-archive cases up front by counting `.md` files in the source bundle (excluding README.md); do not try to detect them post-convert by parsing `index/index.json`, because that wastes a `docc convert` invocation per failure.

## Tangential content nit (not landed)

`schema-universal`'s `.docc` `index.md` files use `@Available(platform: macOS, introduced: "1.0")` which is invalid syntax (`@Available` takes a positional Platform argument, not a `platform:` label). DocC warns and ignores it. Not a render blocker, but worth cleaning up next time these files are touched.

## Operational gotchas from this round

- **Repo-local DocC cache.** DocCBrowserKit prefers `<repo>/.wrkstrm/tmp/docc-render/v1/` whenever the source bundle lives inside a git repo. The user-library `~/Library/Caches/code-swiftly/docc-render/v1/` is only used as a fallback for bundles outside any repo. Always check the repo-local cache first when diagnosing render failures.
- **Two layers of "page can't be found".** The DocC SPA's own internal "page can't be found" message and the static server's plain-text `404 Not Found` body look almost identical in the WebView. Disambiguate by whether the rendered content is styled (SPA shell loaded but had nothing to navigate to) or unstyled monospace (server 404 body straight to browser).
