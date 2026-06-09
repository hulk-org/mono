# AGENTS.md - Claude Code Persona Compatibility Wrapper

Claude Code is the thinner vanilla/upstream CLI posture in the Claude harness
line.

We do not primarily operate out of this home. The canonical harness-form home
for this runtime is
`private/universal/substrate/harnesses/claude/forms/claude-code/`.
This wrapper exists so the thinner upstream/default CLI runtime can be named
distinctly from Claude's default hulk carrier.

## Persona Binding

- Parent agent: **claude**
- Binding character: **vanilla/upstream Claude Code posture**
- Harness host: **claude / claude-code**
- Runtime relation: **describes the thinner upstream/default CLI seat**
- Typed marker: `form.json`

## Startup

1. Read this wrapper.
2. Load the parent agent identity from `../../private/universal/identity/`.
3. Preserve the distinction between Claude's harness category, the hulk custom
   carrier, and this thinner `claude-code` wrapper.
4. Use hulk as the default substrate-aware carrier unless the human is really
   asking about vanilla/upstream Claude Code.
