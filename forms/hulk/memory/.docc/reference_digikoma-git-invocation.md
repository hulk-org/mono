---
name: digikoma-git invocation path
description: digikoma-git is a Swift CLI under digikoma-org, not on PATH; invoke via swift run with the full package path and session-id
type: reference
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
The `digikoma-git` CLI lives at:

```
private/universal/substrate/collectives/digikoma-org/private/universal/domain/core/digikoma-git/
```

and ships a binary at `<that-path>/.build/arm64-apple-macosx/debug/digikoma-git`
after a Swift build. It is **not** installed on PATH.

**Canonical invocation:**

```bash
swift run --package-path private/universal/substrate/collectives/digikoma-org/private/universal/domain/core/digikoma-git \
  digikoma-git commit \
  --message "<commit message>" \
  --path . \
  --apply \
  --session-id <session-id>
```

The `--session-id` field threads session metadata into the commit attribution
(via the `cmonterroza+<agent>@wrkstrm.com` plus-tag pattern). The
`--apply` flag actually performs the commit; without it the CLI dry-runs.

**Sibling subcommands:**

- `digikoma-git add --files <paths> --path . --apply --session-id <id>` —
  stage paths
- `digikoma-git commit --message "<msg>" --path . --apply --session-id <id>`
  — commit staged changes

**When to use plain `git commit` instead:**

- The auto-commit hook is running concurrently and has the mono index lock,
  and you need to finish a recovery commit on a different submodule. Plain
  `git commit` is a tactical fallback when the hook is busy. The hook will
  normalize the resulting commit's attribution later.
- Inside a submodule (digikoma-git operates at mono root). For per-submodule
  commits, plain `git commit` is currently the working path.

**The wider doctrine:** `feedback_digikoma-commits-not-agent.md` says to
prefer digikoma-git over plain git. That preference still holds at mono
root — the binary exists, route through it when possible.
