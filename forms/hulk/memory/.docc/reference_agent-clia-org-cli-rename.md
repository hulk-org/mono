---
name: agent-clia-org-cli-rename
description: swift-agent-cli was renamed to agent@clia-org.cli — canonical SPM path + subcommand surface for reload-profile / agent-docc / profile during /sync. Quote the product name in shells. harness@takumi-org.cli (header CLI) is unchanged.
metadata:
  node_type: memory
  type: reference
  originSessionId: a483eea4-aab6-42d9-971e-505066caba2e
---

The substrate's commissioned-agent CLI was renamed: `swift-agent-cli` (and its host package under `collectives/clia-org/.../spm/swift-agent-cli/`) is gone. The canonical successor is **`agent@clia-org.cli`**.

- **Package home**: `private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/agent@clia-org.cli/`
- **Executable products** (from that Package.swift):
  - `agent@clia-org.cli` (target `CLIAOrgAgentCLI`) — the agent-CLI surface
  - `substrate@clia-org.cli` (target `CLIAOrgSubstrateCLI`) — substrate router exposed by the same package
  - `CLIAOrgAgentCommandRouter` library — fans out to versioned subcommand groups
- **Versioned subcommand packages** (siblings, all under `collectives/clia-org/.../spm/`): `agent-v000_005_000@clia-org.cli` through `agent-v001_000_000@clia-org.cli`, plus `agent-support@clia-org.cli`. `v000_008_000` is the group that owns `reload-profile` and `agent-docc generate`.
- **Shell quoting**: ALWAYS quote `"agent@clia-org.cli"` (and `"harness@takumi-org.cli"`) because of the `@` and `.` — bare zsh expansion breaks the `--package-path` form.

Sync skill canonical commands now read:

```sh
# merged profile + directives + incident view
swift run --jobs 1 \
  --package-path "private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/agent@clia-org.cli" \
  "agent@clia-org.cli" v000_008_000 reload-profile --slug <slug> --path . --format text

# agent DocC refresh (when regenerated docs matter)
swift run --jobs 1 \
  --package-src "private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/agent@clia-org.cli" \
  "agent@clia-org.cli" v000_008_000 agent-docc generate --slug <slug> --path . --merged --write

# merged profile read
"agent@clia-org.cli" profile --slug <slug> --kind agent --path . --format json
```

`harness@takumi-org.cli` (header CLI at `collectives/takumi-org/.../spm/harness@takumi-org.cli/`) is **unchanged** — it still owns `header state set --render --quiet`. The two CLIs are now separate substrate organisms: header rendering = takumi-org; commissioned-agent profile / DocC / merged-reload = clia-org.

Apply when:
- writing or repairing `/sync`, `/header`, `/wd`, `/capture`, or any skill that previously invoked `swift-agent-cli`
- a clone reports `swift-agent-cli not found` — the binary genuinely doesn't exist anymore; route to `agent@clia-org.cli`
- updating doctrine, AGENTS.md wrappers, or operator profiles that quote the old name

Composes with [[clia-is-cli-assistant-form-factor]] (the `@<org>.cli` form-factor pattern confirmed again) + [[deferral-is-drift-do-it-now.md]] (operator caught the stale skill mid-`/sync` → retrofit in-turn rather than bead-track) + [[typed-primitive-bypass-3x-rule-confirmed]] (the skill was referencing a substrate-typed primitive by its old name — search-before-author would have caught the rename earlier).
