# 2026-05-18 — Release Discipline Lane + Backend Rubric

A claude-persona expertise note capturing the substrate's first
general-purpose backend evaluation rubric, the release-discipline
lane in vault-campus, and the data-to-interface pattern applied to
release records.

## The lane shape

Vault Campus has a second lane now (sibling to Curry MVP):
**Release Discipline**. It owns the substrate's typed contracts
measured baselines for release-data infrastructure.

Layout:

```
vault-campus/
├── gym/
│   ├── backend-rubric/v0.1.0/                     # 12-dimension rubric
│   ├── release-data-schemas/v0.1.0/               # ReleaseGate + Pass + status ordinality
│   ├── release-data-bench-press/                  # Node, Tier 1 JSON measurements
│   └── release-data-bench-press-swift/            # Swift, Tier 2a JSON (Tier 2b/c TBD)
├── catalogs/
│   ├── backend-candidates/                        # 7 scored candidates
│   ├── release-gates/                             # canonical gate sets
│   └── release-passes/                            # per-launch typed pass records
├── zoo/
│   ├── edge-server-couchdb/                       # Fly deploy project (fly.toml + README)
│   └── release-pass-renderer/                     # port 4183, renders ReleasePass to HTML
├── museum/
│   ├── 2026-05-18-backend-rubric-comparison-summary.md
│   ├── 2026-05-18-release-data-storage-estimate.{json,md}
│   └── 2026-05-18-first-release-pass-record.md
└── school/
    └── 2026-05-18-edge-server-fly-deploy-doctrine.md
```

## The backend rubric

12 dimensions, 5-value scoring (`blocked` / `poor` / `acceptable` /
`strong` / `not-applicable`):

1. license-posture (5/5 weight)
2. protocol-compliance (5)
3. storage-engine-compatibility (4)
4. sync-model (4)
5. encryption-posture (4)
6. operational-complexity (5)
7. cost-posture (3)
8. substrate-native-compatibility (4)
9. source-availability (4)
10. maturity (3)
11. latency-profile (3)
12. backup-restore (3)

Used to score any substrate storage decision — release data, claims
data, telemetry, future vault graduations. The decision is auditable:
all plausible candidates score against the same dimensions with the
same ordinality.

## The v1 backend decision (2026-05-18)

**Apache CouchDB 3.4 on Fly.io, region `sjc`, free-tier
shared-cpu-1x with 3GB persistent volume.** Scored 7 strong / 5
acceptable / 0 poor / 0 blocked. The decision and its alternatives
are recorded in `museum/2026-05-18-backend-rubric-comparison-summary.md`.

Long-term graduation: `vaultd-with-cbl-c-on-fly` (substrate-authored
Swift daemon wrapping Apache 2.0 couchbase-lite-C). Build when (a)
Phase 0 measurements show CouchDB storage is a bottleneck, or (b)
substrate team grows enough to operate a Swift server.

## The release-discipline data-to-interface pattern

Same pattern as application-evidence/claims-renderer, applied to
launches:

1. **Typed contracts** in `gym/release-data-schemas/v0.1.0/`:
   ReleaseGate, ReleasePass, ReleasePassStatusOrdinalityTable.
2. **Canonical gate set** in `catalogs/release-gates/`:
   `inaugural-website-launch-v0.1.0.gates.json` (12 gates across
   4 discipline categories).
3. **Per-launch pass records** in `catalogs/release-passes/`:
   first is `2026-05-18-wrkstrm-com-speedrun.pass.json` (10 passed
   / 2 needs-evidence).
4. **Render lens** in `zoo/release-pass-renderer/`: Node script,
   port 4183, env-overridable inputs so the same renderer handles
   any per-launch pass.

Status changes flow from JSON to HTML automatically. No copy is
hand-authored.

## Cross-language consistency

The Node bench (`gym/release-data-bench-press/`) and the Swift bench
(`gym/release-data-bench-press-swift/`) both use seed 20260518 and
the same record shape. Measurements across both languages within
~1.4% of each other:

- Node 10K: 1232 bytes/record
- Node 100K: 1241 bytes/record
- Node 1M: 1249 bytes/record
- Swift 10K: 1249.51 bytes/record

5 Swift Testing assertions pass in 3ms (gate set size, slug
stability, score count, PRNG determinism, JSON round-trip).

## What's still blocked

- **Fly deploy** — needs user's Fly account credentials, interactive
  auth. README has the four-command sequence ready.
- **Tier 2b (Fleece) measurements** — needs kura-fleece build
  verification in this environment.
- **Tier 2c (SQLite) measurements** — needs Curry-MVP-shaped SQLite
  projection authored.
- **Tier 3 (replication throughput)** — needs Fly edge server live.
- **Speedrun page's `human-visual-verification` gate** — needs a
  timestamped screenshot of the live URL.
- **Speedrun page's `commit-hygiene` gate** — needs the session's
  work committed in logical units.

## How to apply

When next session opens for substrate work involving release data,
storage decisions, or partner-facing launches:

- The backend rubric is the canonical scoring surface. Don't author
  a new evaluation framework; score against the existing 12
  dimensions.
- The release-data schemas in vault-campus are reusable across
  future applications (Speedrun was the first; YC, accelerator B,
  grants will follow).
- The release-pass-renderer specimen is the canonical lens.
  Re-render any pass record by pointing `PASS_RECORD=...` at it.
- The Apache CouchDB on Fly decision stands until evidence
  contradicts it. New candidates can be added to
  `catalogs/backend-candidates/` and scored without changing the
  rubric.

## Adjacent claude memory

- `2026-05-18-research-vs-operational-placement-rule.md` — research
  artifacts live in wrkstrm-research; operational records in
  originating collective. The release-discipline lane is research.
- `2026-05-18-memory-home-follows-synced-agent.md` — memory home
  depends on synced agent. Walter is synced for this session;
  vault-campus + claude-persona expertise are the canonical homes.
- `2026-05-18-value-driven-over-technical-framing.md` — investor
  copy lives in the operational archive; this technical-discipline
  work lives in research.
