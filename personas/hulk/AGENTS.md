# AGENTS.md - Hulk Persona Compatibility Wrapper

This file is a thin persona-local wrapper.

`private/universal/substrate/harnesses/claude/forms/hulk/` is the canonical
Claude hulk harness-form home. This `agents/claude/personas/hulk/` tree is a
Claude-side compatibility seat for runtimes and config-home links that still
expect a persona-shaped binding.

Do not describe this persona path as owning the hulk carrier. Keep startup,
sync, contract, runtime state, and durable compatibility-index doctrine
anchored in the canonical Claude hulk harness form.

## Startup

1. Read `private/universal/substrate/harnesses/claude/forms/hulk/AGENTS.md`.
2. Follow that harness file as the canonical startup surface.
3. Use this wrapper only for Claude persona-binding details that the harness
   file does not already own.

## Persona Binding

- Canonical harness-form home:
  `private/universal/substrate/harnesses/claude/forms/hulk/`
- Parent commissioned agent:
  `private/universal/substrate/agents/claude/`
- Persona binding record:
  `private/universal/substrate/agents/claude/personas/hulk/form.json`
- Canonical harness selection:
  `$sync >h:hulk`
- Default commissioned agent in that harness:
  `$sync >h:hulk >a:claude`
