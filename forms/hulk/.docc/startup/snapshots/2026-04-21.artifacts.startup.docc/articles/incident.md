# incident

Active incident file, read when present. Conditional — only contributes tokens when an incident is active.

> Note: This phase is conditional — only contributes when the surface exists.

### ✓ `.wrkstrm/incidents/active.incident.wrkstrm.json`
7,871 bytes · ~1,967 tok

```json
{
  "affectedPaths" : [
    "private/universal/vaults/acting/acting.docc",
    "private/universal/vaults/acting/acting.pdf",
    "private/universal/vaults/acting/auxiliary-sources",
    "private/universal/vaults/acting/beat-sheet.pdf",
    "private/universal/vaults/acting/tools",
    "private/universal/harnesses/codex/AGENTS.md",
    "private/universal/harnesses/codex/agent-dialogues",
    "private/universal/harnesses/codex/archived_sessions",
    "private/universal/harnesses/codex/auth.json",
    "private/universal/harnesses/codex/automations",
    "private/universal/harnesses/codex/brand-board.html",
    "private/universal/harnesses/codex/cache",
    "private/universal/harnesses/codex/config.toml",
    "private/universal/harnesses/codex/history.jsonl",
    "private/universal/harnesses/codex/internal_storage.json",
    "private/universal/harnesses/codex/log",
    "private/universal/harnesses/codex/logs_1.sqlite",
    "private/universal/harnesses/codex/logs_1.sqlite-shm",
    "private/universal/harnesses/codex/logs_1.sqlite-wal",
    "private/universal/harnesses/codex/memories",
    "private/universal/harnesses/codex/model-catalogs",
    "private/universal/harnesses/codex/models_cache.json",
    "private/universal/harnesses/codex/prompts",
    "private/universal/harnesses/codex/rules",
    "private/universal/harnesses/codex/session_index.jsonl",
    "private/universal/harnesses/codex/sessions",
    "private/universal/harnesses/codex/shell_snapshots",
    "private/universal/harnesses/codex/skills",
    "private/universal/harnesses/codex/skills.pre-single-link-2026-02-23",
    "private/universal/harnesses/codex/sqlite",
    "private/universal/harnesses/codex/state_5.sqlite",
    "private/universal/harnesses/codex/state_5.sqlite-shm",
    "private/universal/harnesses/codex/state_5.sqlite-wal",
    "private/universal/harnesses/codex/tmp",
    "private/universal/harnesses/codex/tmpcli",
    "private/universal/harnesses/codex/vendor_imports",
    "private/universal/harnesses/codex/version.json",
    "private/universal/substrate/collectives/universal-schemas/AGENDA.md",
    "private/universal/substrate/collectives/universal-schemas/AGENTS.md",
    "private/universal/substrate/collectives/universal-schemas/BOOTSTRAP.md",
    "private/universal/substrate/collectives/universal-schemas/HEARTBEAT.md",
    "private/universal/substrate/collectives/universal-schemas/IDENTITY.md",
    "private/universal/substrate/collectives/universal-schemas/SOUL.md",
    "private/universal/substrate/collectives/universal-schemas/TOOLS.md",
    "private/universal/substrate/collectives/universal-schemas/USER.md",
    "private/universal/substrate/collectives/universal-schemas/memory",
    "private/universal/substrate/collectives/universal-schemas/memory.md",
    "private/universal/substrate/collectives/universal-schemas/private",
    "private/universal/substrate/collectives/universal-schemas/public",
    "private/universal/substrate/collectives/openai/public/universal/codex/AGENTS.md",
    "private/universal/substrate/collectives/openai/public/universal/codex/BUILD.bazel",
    "private/universal/substrate/collectives/openai/public/universal/codex/CHANGELOG.md",
    "private/universal/substrate/collectives/openai/public/universal/codex/LICENSE",
    "private/universal/substrate/collectives/openai/public/universal/codex/MODULE.bazel",
    "private/universal/substrate/collectives/openai/public/universal/codex/MODULE.bazel.lock",
    "private/universal/substrate/collectives/openai/public/universal/codex/NOTICE",
    "private/universal/substrate/collectives/openai/public/universal/codex/README.md",
    "private/universal/substrate/collectives/openai/public/universal/codex/SECURITY.md",
    "private/universal/substrate/collectives/openai/public/universal/codex/announcement_tip.toml",
    "private/universal/substrate/collectives/openai/public/universal/codex/cliff.toml",
    "private/universal/substrate/collectives/openai/public/universal/codex/codex-cli",
    "private/universal/substrate/collectives/openai/public/universal/codex/codex-rs",
    "private/universal/substrate/collectives/openai/public/universal/codex/defs.bzl",
    "private/universal/substrate/collectives/openai/public/universal/codex/docs",
    "private/universal/substrate/collectives/openai/public/universal/codex/flake.lock",
    "private/universal/substrate/collectives/openai/public/universal/codex/flake.nix",
    "private/universal/substrate/collectives/openai/public/universal/codex/justfile",
    "private/universal/substrate/collectives/openai/public/universal/codex/package.json",
    "private/universal/substrate/collectives/openai/public/universal/codex/patches",
    "private/universal/substrate/collectives/openai/public/universal/codex/pnpm-lock.yaml",
    "private/universal/substrate/collectives/openai/public/universal/codex/pnpm-workspace.yaml",
    "private/universal/substrate/collectives/openai/public/universal/codex/rbe.bzl",
    "private/universal/substrate/collectives/openai/public/universal/codex/scripts",
    "private/universal/substrate/collectives/openai/public/universal/codex/sdk",
    "private/universal/substrate/collectives/openai/public/universal/codex/shell-tool-mcp",
    "private/universal/substrate/collectives/openai/public/universal/codex/third_party",
    "private/universal/substrate/collectives/openai/public/universal/codex/tools",
    "private/universal/substrate/collectives/openai/public/universal/codex/workspace_root_test_launcher.bat.tpl",
    "private/universal/substrate/collectives/openai/public/universal/codex/workspace_root_test_launcher.sh.tpl",
    "private/universal/vaults/ai/exports/open-ai/codex/sessions/current/2025",
    "private/universal/vaults/ai/exports/open-ai/codex/sessions/current/2026"
  ],
  "blockedTools" : [
    "normalize-schema.apply",
    "recovery.restore",
    "cleanup-backups.apply"
  ],
  "doNotModify" : [
    "private/universal/substrate/collectives/universal-schemas/AGENDA.md",
    "private/universal/substrate/collectives/universal-schemas/AGENTS.md",
    "private/universal/substrate/collectives/universal-schemas/BOOTSTRAP.md",
    "private/universal/substrate/collectives/universal-schemas/HEARTBEAT.md",
    "private/universal/substrate/collectives/universal-schemas/IDENTITY.md",
    "private/universal/substrate/collectives/universal-schemas/SOUL.md",
    "private/universal/substrate/collectives/universal-schemas/TOOLS.md",
    "private/universal/substrate/collectives/universal-schemas/USER.md",
    "private/universal/substrate/collectives/universal-schemas/memory",
    "private/universal/substrate/collectives/universal-schemas/memory.md",
    "private/universal/substrate/collectives/universal-schemas/private",
    "private/universal/substrate/collectives/universal-schemas/public",
    ".wrkstrm/incidents/patch"
  ],
  "id" : "2026-03-23-oss-adoption-blocked-by-startup-and-organism-drift",
  "links" : [
    {
      "title" : "Acting auxiliary startup evidence",
      "url" : "/Users/sonoma/mono/private/universal/vaults/acting/auxiliary-sources/startup-response-samples.md"
    },
    {
      "title" : "CLIA directing doctrine",
      "url" : "/Users/sonoma/mono/private/universal/vaults/acting/acting.docc/clia-as-lead-director-and-supporting-actor.md"
    }
  ],
  "owner" : "patch",
  "severity" : "S1",
  "started" : "2026-03-23T22:00:58Z",
  "status" : "active",
  "summary" : "Startup ritual, organism drift, and compaction opacity are blocking OSS cast-layer adoption. Git upload (large files) resolved 2026-04-14. Remaining blocker: scaffold upgrade.",
  "title" : "OSS adoption blocked by startup and organism drift",
  "updates" : [
    {
      "timestamp" : "2026-04-14T13:10:00Z",
      "note" : "Git upload problem resolved — large files no longer blocking pushes. Remaining work: scaffold upgrade to complete OSS readiness."
    }
  ]
}
```

**Phase total**: ~1,967 tok