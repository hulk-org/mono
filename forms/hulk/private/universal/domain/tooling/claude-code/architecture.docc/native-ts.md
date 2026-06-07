@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# native-ts

`src/native-ts/` is where TypeScript ports of native modules live.
The point: **avoid platform-specific binary dependencies** by
reimplementing the small subset of native functionality the codebase
actually uses, in pure TypeScript.

## Subdirectories

- **`color-diff/`** — `index.ts`. Color difference calculation
  (perceptual delta). Likely used by the diff renderer in
  `src/components/diff/` and `src/components/StructuredDiff/`.

- **`file-index/`** — `index.ts`. File index / search structure.
  Likely the backing store for `GlobTool` and the file suggestion
  hooks (`hooks/fileSuggestions.ts`,
  `hooks/unifiedSuggestions.ts`).

- **`yoga-layout/`** — `enums.ts` + `index.ts`. Port of the Yoga
  layout engine (Facebook's flexbox implementation). Bound from the
  Ink fork at `src/ink/layout/yoga.ts`.

## Why this matters

- **Bundleability.** The whole codebase ships as a single
  Bun/Node bundle. Native dependencies break that — they need
  `node-gyp`, prebuilt binaries per platform, install-time
  compilation. A pure-TS port is the price of one-binary
  distribution.
- **The Ink fork depends on it.** `src/ink/layout/yoga.ts` is the
  only consumer of `native-ts/yoga-layout/`. The Ink fork exists
  partly *because* upstream Ink takes a hard dependency on a native
  Yoga binding.
- **Performance trade-off is accepted.** A pure-TS Yoga port is
  slower than the native binding. The codebase accepts that cost
  in exchange for the bundling property.

## Cross-cutting

- This is the **opposite pattern** from the JSON hot-loop note in
  operator memory (`project_json-hot-loop-simdjson-shim.md`), which
  argues for a C shim because Decodable is 35–70× slower than
  parser. Different systems make different bets:
  - Claude Code (this tree): pure TS, accept the perf hit, win on
    distribution.
  - wrkstrm-performance benchmarks: native shim, accept the
    distribution complexity, win on perf.
  Both are right for their constraints. Worth naming explicitly so
  we don't mistakenly apply one bet to the other system.

- The `native-ts/file-index/` port is interesting because file
  search is normally where this trade-off hurts most. If `GlobTool`
  ever feels slow, this is the file to check first.

## Open questions

- Which Yoga features are actually implemented vs. omitted.
- Whether `file-index/` uses an in-memory trie, a flat sorted
  array, or something else.
- Whether `color-diff/` is the only color comparison surface or if
  there's a separate `utils/color/` path.
- Performance gap (native Yoga vs. this port) — never measured in
  this tree as far as I can see.
