---
name: exploration-is-substrate-tooling-promoted-2026-06-04
description: 4th-instance confirmation promoted exploration-is-substrate-tooling from feedback memory to typed AxiomModel — symlinks@swift-universal.cli authored mid-session from session-internal bash symlink-hunt. Pointer to typed AxiomModel + role + workflow.
metadata:
  node_type: memory
  type: feedback
  originSessionId: 48bb3ae1-1a94-4651-ac23-1a617d8ef0d2
---

When the agent runs bash exploration commands (find, grep, awk, readlink, sed) over substrate sources to discover/audit/classify primitives, that exploration is a substrate-tooling specification disguised as a one-shot command. Before the third execution of the same exploration shape, author the typed Swift CLI that subsumes it. Bash heredocs containing logic are themselves the anti-pattern.

**Why:** Operator-articulated 2026-05-26 originally. 4th-instance confirmation 2026-06-04: the symlinks find/readlink/classify dance ran 6+ times in the session's first half (finding chatgpt/forms/loom/agents/loom self-loop, classifying short-loop vs ancestor-loop, distinguishing climb-count drift from path-drift, inventorying 12 broken-relative-path symlinks). Operator named the need mid-session: "we really need a symlinks@swift-universal.cli which can maybe use swift directory tools search methods..." The CLI authored same session reproduced the entire first-half diagnosis as one command. Substrate just made every future symlink hunt cost ~1 typed command instead of ~6 bash commands. Three prior instances: repeated find -type l (2026-05 sessions), git submodule scanning (became swift-git-cli + standalone-submodule-scanner), JSON schema searches (became swift-directory-tools).

**How to apply:** Rule of three. First time inline. Second time flag for promotion. Third time the typed CLI must exist. Author at canonical home `<package-tooling-root>/spm/<slug>@<org>.cli/` with library + AsyncParsableCommand executable. Compose existing primitives (SwiftDirectoryTools, common-process, common-shell, swift-git-cli) — don't reinvent. Smoke-test against the bash exploration's original input.

Canonical typed sources of truth (read these, not this memory):
- `[[exploration-is-substrate-tooling]]` AxiomModel at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/exploration-is-substrate-tooling.axiom.su.json`
- `[[substrate-tooling-extraction-from-bash-improv]]` workflow at `private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/workflows/substrate-tooling-extraction-from-bash-improv/v0.1.0/`
- `[[substrate-tool-author]]` role at `private/universal/substrate/roles/substrate-tool-author/private/universal/identity/substrate-tool-author.role-surface-manifest.json`

Composes with: `[[no-bash-scripts-only-saved-swift-clis]]` + `[[async-parsable-command-is-axiom]]` + `[[substrate-toolmaking-checklist]]` + `[[Always run SwiftJSONFormatterCLI on JSON writes]]` + `[[Swift over Python]]`.
