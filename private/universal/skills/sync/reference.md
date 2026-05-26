# Sync Reference

This file holds the expensive sync contract. Load it only when `SKILL.md`
routes here.

## Roster Resolution

- `>h:<slug>` selects the active harness.
- `>a:<slug>` selects a commissioned agent.
- `>o:<slug>` selects an operator.
- Bare `>slug` is agent shorthand only when the slug is unambiguous and does
  not also name a harness, operator, collective, orchestrator, or other scoped
  home.
- Duplicate slugs require explicit scope.
- An operator-only bare slug such as `>rismay` is a ghost/self session where
  the operator is talking to themself through the harness and no commissioned
  agent is active.
- Mentions may be comma-separated or space-separated.
- Examples: `>h:codex >a:chatgpt`, `>a:clia >a:claw`, `>chatgpt,>clia`,
  `>rismay`.

## Routing Tables

Before applying the default commissioned agent, consult the Codex agent-skill
routing table only when the task or skill invocation clearly names a routed
skill:

`private/universal/substrate/harnesses/codex/private/universal/skill-routing.docc/resources/codex-agent-skill-routing.json`

Before writing copy, page prose, route manifests, or investor-facing framing,
consult the Codex role-autoload route table only when the task clearly names a
routed surface or audience:

`private/universal/substrate/harnesses/codex/private/universal/role-autoload.docc/resources/codex-role-autoload-routing.json`

Role autoload does not change the commissioned agent. It loads the role stack
that frames the work: requesting actor, writing actor, and reader projection.

## Session State

- Persist active harness and synced agents in
  `.wrkstrm/tmp/header-session-state-<sessionId>.json` when a session ID is
  available.
- Use `.wrkstrm/tmp/header-session-state.json` only for true default-session
  compatibility.
- Do not write live roster state to workspace-global
  `.wrkstrm/tmp/synced-agents.jsonl`.
- When no synced agents are active, write an empty
  `participants.attendees` array for the current session.

## Home And Workspace Boundaries

Keep these surfaces distinct:

- active harness: the session host, for example `codex`
- repo/session root: where the chat is running
- commissioned home: selected `agents/<slug>`, `collectives/<slug>`, or
  `orchestrators/<slug>` profile
- operator/workspace home: the operator profile that owns the active workspace
  contract

Resolve the active workspace contract separately from the commissioned profile.
In substrate repos, prefer:

1. `private/universal/substrate/operators/*/private/universal/workspace.wrkstrm.json`
2. `private/universal/substrate/operators/*/private/workspace.wrkstrm.json`

If the commissioned home is itself workspace-bearing, report that as
commissioned-home metadata. Do not collapse it into the canonical operator
workspace path.

## Identity Resolution

Resolve identity artifacts from the commissioned home in this order:

1. `<home>/private/universal/identity/`
2. `<home>/private/universal/agent/profile/`
3. `*.triad.json` directly from `<home>/`

When the commissioned home is a collective, prefer
`<home>/private/universal/identity/<slug>.json` and `*.agent.triad.json` as
the canonical identity bundle. Treat wrapper entrypoints such as `AGENTS.md`
or `TOOLS.md` as routing surfaces rather than durable identity state.

## Incidents

Read `.wrkstrm/incidents/active.incident.wrkstrm.json` when present. Apply
`blockedTools`, `doNotModify`, and severity constraints as environment-level
context. Render the incident in the header. Do not override the session mode;
incidents are global, modes are per conversation.

## Profile And DocC Recovery

Use `swift-agent-cli profile` for a merged profile read. If SwiftPM manifest
cache I/O fails under default parallelism, retry with `swift run --jobs 1`.

```sh
swift run --jobs 1 --package-path private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/swift-agent-cli swift-agent-cli profile --slug <slug> --kind agent --path . --format json
```

Use `swift-agent-cli v000_008_000 reload-profile` only when sync explicitly
needs the combined reload view of merged profile, environment directives, and
active incident.

For loaded agents with `profile/docc/`, `memory/.docc/`, `memory.docc/`, or
`private/memory.docc/`, run `agent-docc generate` only when regenerated docs
matter to the task. If DocC generation cannot resolve the current profile root,
open the existing DocC entrypoint and report the unresolved commissioned-home
assumption instead of failing sync.

```sh
swift run --jobs 1 --package-path private/universal/substrate/collectives/clia-org/private/universal/domain/tooling/spm/swift-agent-cli swift-agent-cli v000_008_000 agent-docc generate --slug <slug> --path . --merged --write
```
