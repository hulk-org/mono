---
name: common-archive library design
description: rismay wants a swift-universal common-archive package with multiple selectable backends (Apple-native, Linux shell-out, pure-Swift) and a guaranteed common default available to every supported platform. ReproducibleArchive becomes the Linux/macOS shell-out backend; CommonLZFSE is the Apple-native single-file path; the common default still TBD.
type: project
---

rismay wants a `common-archive` library in `swift-universal/private/universal/spm/domain/system/common-archive/`
that:

1. Exposes a single high-level API for "create / extract / list an
   archive of these files".
2. Supports **multiple backends** with explicit `prefer:` selection
   (`.apple`, `.linuxShellOut`, `.pureSwift`, `.auto`).
3. Always has a **common backend** that is available on every
   platform the substrate cares about (macOS, Linux, iOS, Catalyst,
   Windows, Android), and that backend is the **default** for
   `prefer: .auto` when no platform-specific backend is preferred or
   available.
4. Lets consumers fall back automatically — if the requested backend
   is unavailable on the current platform, the library uses the
   common one rather than crashing.

Existing pieces that fit into this design:

- **`ReproducibleArchive`** (currently in `todo3/.../code/spm/library/reproducible-archive/`)
  is the **Linux + macOS shell-out backend**: walks a directory,
  shells out to `tar` + `gzip` via `CommonShell`, produces a
  byte-deterministic `.tar.gz`. Already works on GitHub Actions Linux
  runners. Should be relocated to swift-universal as a sibling
  library, or as the implementation of the `.linuxShellOut` backend
  inside `common-archive`.
- **`CommonLZFSE`** (already in `swift-universal/.../common-lzfse/`)
  is the **Apple-native single-file backend**: in-memory
  `(NSData).compressed(using: .lzfse)` for one Data buffer at a time.
  Apple-only because Compression.framework is Apple-only. Useful for
  the `.apple` preference when the operation is "compress one file".
- **The common default backend** is the open question. Candidates:
  - **ZIPFoundation** (third-party, BSD-licensed, mature, pure-Swift,
    works on every swift-corelibs-foundation platform). Output is
    `.zip`, per-file compression — worse ratio than solid `.tar.gz`
    on JSONL but portable. New external dep on swift-universal.
  - **Pure-Swift tar streamer + pure-Swift gzip** — write or vendor
    ~500-1000 lines of TAR header + DEFLATE. No new external deps
    but significant engineering risk and surface area.
  - **Plain uncompressed tar (pure Swift)** — universal, no
    compression. Useful as a baseline but doesn't solve the
    rollout-shrink use case.

Existing platform realities (confirmed 2026-04-09):

- `CommonProcess` and `CommonShell` work on Windows, Android, Linux,
  macOS, and Catalyst. **NOT pure iOS** — Apple's app sandbox forbids
  Process() at runtime even though the code links. tvOS / watchOS /
  visionOS inherit the same restriction. Catalyst is fine.
- `Compression.framework` (which `NSData.compressed(using:)` is built
  on) is Apple-only — not in swift-corelibs-foundation. So
  `CommonLZFSE` can never become the common default.
- This means the **common default backend** has to be a code path that
  works on **iOS without Process() AND on Linux/Android/Windows
  without Compression.framework** simultaneously. Only pure-Swift
  options qualify (e.g. ZIPFoundation, pure-Swift tar+gzip, etc.).
  Shell-out CANNOT be the common default because of iOS, and
  Compression.framework CANNOT be the common default because of
  Linux/Android/Windows.

**Open design questions:**

1. **Which pure-Swift backend should be the common default?**
   ZIPFoundation vs custom tar+gzip vs uncompressed tar vs other?
2. **Single API for files + directories, or split?** Should
   `common-archive` cover both "compress one file" (CommonLZFSE-style)
   AND "bundle a directory" (ReproducibleArchive-style)? Or should
   `common-lzfse` stay focused on single-file and `common-archive`
   cover only directory-tree archives?
3. **Where does ReproducibleArchive live after the move?** A standalone
   `swift-universal/.../common-archive/` package containing all the
   backends as separate targets/products, or one
   `swift-universal/.../reproducible-archive/` for the Linux/macOS
   shell-out backend plus a separate `swift-universal/.../common-archive/`
   that depends on it as one of several backend options?
4. **Do we update CommonShell/CommonProcess platform declarations in
   the same change?** Today they declare only Apple platforms. If
   `.linuxShellOut` is going to be a real backend, the underlying
   primitives should claim Linux/Windows officially.
5. **Determinism contract.** ReproducibleArchive guarantees
   byte-deterministic output (sorted entries, normalized perms,
   `--mtime=@0`, no AppleDouble metadata). Does the new
   `common-archive` make this guarantee universal across backends, or
   leave it as a property of the `.linuxShellOut` backend only?
6. **What does "extract" look like across backends?** The shell-out
   backend can use `tar -x`. The pure-Swift backend needs its own
   extractor. Is extraction in scope for the first cut, or can we
   ship create-only and add extract later?

**Don't move ReproducibleArchive** until the design questions are
answered — the move and the rewrite are linked, and getting the API
shape right matters more than relocating the existing implementation.

**Discovery 2026-04-09: 431 real `.data.json.lzfse` chat-gpt conversation
files exist on disk** under
`private/universal/substrate/operators/rismay/private/vaults/ai/imports/open-ai/chat-gpt/conversations/<YYYY>/<MM>/<DD>/`,
each paired with a `.json` human-readable sibling. They were produced
by `ConversationsCLI.swift:491` via `(canonicalJSON as NSData).compressed(using: .lzfse) as Data`,
verified by `file` reporting `lzfse compressed, compressed tables` and
the first 4 bytes being `62 76 78 32` (`bvx2` LZFSE v2 frame magic).
Same wire format that `CommonLZFSE` produces and reads.

**Critical correction 2026-04-09: rismay clarified the design intent
and I had it backwards.** The conversations README explicitly labels
the formats:

- `*.tar.gz` = "Canonical conversations (reproducible archives)" — the
  CURRENT canonical format. Produced via `ReproducibleArchive` which
  shells out to `tar` + `gzip` via `CommonShell`. This is the
  cross-platform cross-compat layer that the substrate is migrating
  TOWARD.
- `*.data.json.lzfse` = "Legacy canonical JSON blobs (still emitted
  during transition)" — being deprecated. The 431 existing files are
  transitional artifacts, not a forward-looking format choice. The
  reason they're being deprecated is precisely that LZFSE via
  Foundation is Apple-only.

**rismay deliberately chose `ReproducibleArchive`'s shell-out shape
because it works on GitHub Actions Linux runners.** Adding
`liblzfse` Linux bindings to `CommonLZFSE` would be moving in the
wrong direction — adding complexity to a format that's being phased
out, when the canonical answer is already chosen.

**The compatibility options rismay already chose** (the "options that
need to be set" — these are what makes the canonical archive
byte-deterministic across BSD tar, GNU tar, multiple machines, and
git diffs):

- JSON encoder: `JSONSerialization.data(withJSONObject:options: [.sortedKeys])`
  — sorted-keys, minified, via `JSONSerialization` (not `JSONEncoder`)
  for cross-Swift-version stability.
- Tar shared: `--format=ustar`, NUL-terminated `--null -T <names.list>`
  from a `localizedStandardCompare`-sorted relative path list.
- GNU tar: `--owner=0 --group=0 --numeric-owner --mtime=@0 --mode u=rwX,go=rX`.
- BSD tar (macOS default): `--uid=0 --gid=0 --uname root --gname root
  --no-mac-metadata`, plus a stage-and-chmod-the-copy workaround
  because BSD tar lacks inline `--mode`.
- Tar env: `COPYFILE_DISABLE=1` to suppress macOS AppleDouble
  `._*` metadata files.
- gzip: `-n -<level> -c` with default level 6. `-n` strips the original
  filename and timestamp from the gzip header so identical content
  produces identical bytes regardless of when/where compressed.

**Updated architecture:**

- **`common-archive`** = move `ReproducibleArchive` to swift-universal,
  preserve its design verbatim, document the determinism contract
  BSD/GNU tar flavor handling explicitly. NO multi-backend abstraction.
  NO "common default vs platform-preferred". The shell-out IS the
  common implementation. The Linux compatibility was already done.
- **`common-lzfse`** = legacy reader path for the 431 `.data.json.lzfse`
  files and any surviving consumers. Stays narrow + Apple-only. Do NOT
  add `liblzfse` Linux bindings — that's deprecated-format complexity.
  Document its deprecated-for-new-code status; new write paths should
  use `common-archive` (`.tar.gz`).
- **The conversations CLI's two output paths** stay as-is:
  `.tar.gz` (canonical, via `common-archive`) + `.data.json.lzfse`
  (legacy, via `CommonLZFSE`) "still emitted during transition" until
  the legacy consumers are migrated.

**Resolved 2026-04-09**: rollout-compress switched to `.jsonl.tar.gz`
via `CommonArchive` (just moved to swift-universal). Round-trip
verified end-to-end through the line reader's new sync `tar -xzf`
extract path.

**But the gzip layer is the wrong algorithm for Codex rollouts.**
Bench on a real 152 MiB rollout (`/Users/sonoma/mono/private/universal/vaults/ai/exports/open-ai/codex/sessions/current/2026/01/31/rollout-2026-01-31T01-23-58-019c135d-c608-7553-8482-283dc55ea6eb.jsonl`):

| Format | Size | Ratio | Wall time |
|---|---|---|---|
| `gzip -6` (current default) | 50.7 MiB | 3.0× | 13.4s |
| `gzip -9` | 50.6 MiB | 3.0× | 12.5s |
| `zstd` default (level 3) | **3.7 MiB** | **40.5×** | **0.11s** |
| `zstd -19` | 2.3 MiB | 65.8× | 3.2s |
| `xz` default | 2.4 MiB | 62.7× (multi-threaded, non-deterministic) | 2.1s |
| `xz -9` | 2.1 MiB | 74.0× | 12.0s |
| LZFSE (Apple-only reference) | ~3.4 MiB | ~46× | similar |

**Why gzip loses so badly**: 1989-vintage DEFLATE with a 32 KB sliding
window. Can't see cross-line redundancy in 152 MiB JSONL where every
line repeats `"type":"response_item"`/`"payload"`/etc. Modern
algorithms (zstd, xz, LZFSE) have block-level entropy coding with
much larger windows.

**Recommendation for next session**: switch `common-archive`'s gzip
shell-out to `zstd`. Reasons:

- 13× better ratio than gzip on Codex rollouts
- 100× faster than gzip
- byte-deterministic by default in single-threaded mode (zstd has no
  timestamp or filename in the frame header)
- ships natively on macOS 12+ and every modern Linux distro
- bsdtar 3.5.3+ and GNU tar both support `--zstd` flag for create
  and auto-detect on extract
- matches the "modern lossless cross-platform default" that backup,
  package, and distribution tooling has converged on since ~2018

**On-disk format change**: `.tar.gz` → `.tar.zst`. The line reader's
extract path needs `tar -xf` (libarchive auto-detects compression) or
explicit `tar -x --zstd -f`. The clia-mem `isRolloutFileURL` and
`isAlreadyCompressed` predicates need a third suffix.

**xz isn't quite right** despite its slightly better ratio: xz default
mode (multi-threaded) is NOT byte-deterministic across machines with
different core counts. Forcing `xz -T 1` for determinism gives up the
2-second wall time and lands at 12 seconds. zstd is deterministic out
of the box.

**Largest rollout impact**: 343 MiB original →
- gzip: ~117 MiB (still over 100 MiB GitHub limit) ❌
- zstd default: ~8 MiB ✅
- zstd -19: ~5 MiB ✅
- xz -9: ~4.6 MiB ✅
- LZFSE: ~7.5 MiB (Apple-only) ✅

The switch to zstd is what makes common-archive actually useful for
the operator's largest oversize rollouts, not just the smallest
ones.
