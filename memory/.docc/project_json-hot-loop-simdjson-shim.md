---
name: JSON hot-loop — use simdjson via C++ interop or C shim, not Decodable
description: For Swift JSON hot loops, Decodable is 35-70× slower than the parser underneath; use a pImpl'd C++ shim imported via Swift 6.3 C++ interop (fastest and cleanest) or a narrow C shim over simdjson, or a direct yyjson walk
type: project
---

For any Swift CLI or tool that decodes JSON **in a loop** (bulk
validation, JSONL streaming, event parsing, sweeps), `Foundation.JSONDecoder`
is 35–70× slower than the JSON parser underneath it. The tax is the
`Decodable` protocol machinery — class allocations for
`_JSONDecoder`/containers, `DecodingError.Context` records, PWT
dispatch, generic type lookups. Swapping the parser underneath (ReerJSON,
ZippyJSON, custom Decoder on yyjson) saves 8–40%. Dropping `Decodable`
entirely and walking the tree via a narrow C shim saves ~98%.

**Why:** wrkstrm-performance's `cli-arg-bench-press` experiment
proved it across 14 binaries in 5 languages on 2026-04-09. The
full data lives at
`private/universal/substrate/collectives/wrkstrm-performance/private/universal/spm/cli-arg-bench-press/.docc/engineering-report.md`.
Headline numbers on a 1722 B `Greeting` payload, 100k decodes each:
- Swift Foundation `JSONDecoder`: 86.2 μs/decode
- Swift + `ZippyJSONDecoder` (same simdjson, through Decodable): 78.8 μs
- Swift + custom `Decoder` on yyjson: 69.6 μs
- Swift + `ReerJSON` (wraps yyjson): 52.6 μs
- Swift + raw yyjson walk (`YyjsonInspectCLI`): 2.0 μs
- Swift + simdjson via narrow C shim (`SimdJsonInspectCLI`): 1.7 μs
- **Swift + simdjson via pImpl'd C++ shim + C++ interop (`SimdJsonCxxCLI`): 1.6 μs** ← fastest Swift
- C++ simdjson ondemand (`cpp-simd-json-cli`): 1.2 μs (ceiling)

The Swift→C++-interop→simdjson path lands within 33% of raw C++ and
is **54× faster** than `JSONDecoder` on the same workload. Even
better, it's **slightly faster than the C-shim path** because
Swift's `String(<std.string>)` bridge is cheaper than manual
`String(decoding: UnsafeBufferPointer(...)...)` dance. The C++ shim
is ~100 lines hiding the simdjson ondemand parser behind a
forward-declared `Impl` struct in a pImpl class — the public header
exposes only `std::string` + primitives, so Swift's C++ importer
never sees simdjson's template-heavy move-only types. Swift 6.3 C++
interop imports the non-copyable class as `~Copyable` with RAII
lifetime and `inout`-bridged `std::string &` parameters.

**How to apply:**
- **GUI apps / user-facing Apple binaries**: keep using `JSONDecoder`.
  The per-decode tax doesn't dominate app runtime and `Decodable` is
  genuinely ergonomic. Don't over-engineer.
- **Batch tooling / build-system CLIs / sweep runners / JSONL streaming**:
  write a pImpl'd C++ class per hot-path schema and import via
  Swift 6.3 C++ interop. Model it on `cli-arg-bench-press/sources/SimdJsonCxxShim/`
  + `cli-arg-bench-press/sources/SimdJsonCxxCLI/`. Requires
  `cxxLanguageStandard: .cxx20` at package level and
  `swiftSettings: [.interoperabilityMode(.Cxx)]` on the Swift target.
  Caller code is `parser.parseGreeting(ptr, len, &name, &loud)` with
  `import CxxStdlib` + `String(<std.string>)` bridging.
- **Alternative if avoiding C++ interop**: the C-shim pattern at
  `cli-arg-bench-press/sources/SimdJsonShim/` works identically,
  lands at 1.7 μs instead of 1.6 μs, and compiles ~5 s faster cold.
  Use this if targeting older Swift versions or if toolchain
  stability for Swift C++ interop on non-Apple platforms is a
  concern.
- **Cross-platform concerns**: both yyjson and simdjson are portable C/C++
  (Linux, Windows, Android all fine). Swift 6.3 C++ interop works
  well on Apple + Linux but needs per-toolchain verification on
  Windows/Android. ReerJSON and ZippyJSON are Apple-only because of
  JJLISO8601DateFormatter.
- **When deciding** between yyjson and simdjson for a new hot path:
  yyjson is simpler (C, easier to compile, less code), simdjson is
  ~1.2× faster on big payloads. Both are 40–50× faster than
  `JSONDecoder`. Pick whichever is easier to integrate; the speed
  difference between them is rounding error vs the `Decodable` tax
  you're removing.
