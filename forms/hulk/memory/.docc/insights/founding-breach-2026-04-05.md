# Founding Breach — 2026-04-05

## What happened

On 2026-04-04 and 2026-04-05, the Claude Code hulk consumed approximately
160GB of host RAM and crashed the operator's machine. Twice in three days.

The agent inside the hulk (Claude Opus 4.6) had no visibility into its own
memory usage. From inside, the agent kept running tools — recursive submodule
scans, file reads across thousands of files, long-running session state —
with no signal that the host was approaching catastrophic failure.

## Why this matters

This is the founding breach. It is the reason the `hulk` organism exists.

Before this incident, "harness" was a vague term for "the runtime that loads
an agent." After this incident, harness has a contract: bones + skin, with
specific clauses for bounded memory, bounded disk, bounded subprocess trees,
self-awareness, and host citizenship.

## What the breach revealed

1. **Conflation of carrier and agent.** The `harnesses/claude/` directory was
   named after the agent (Claude) when it should have been named after the
   carrier shape (hulk). The carrier is reusable; the agent is not.
2. **Vendor-tied naming.** Calling things `anthropic-harness` or
   `claude-code-org` ties the carrier to a vendor. Carriers should be
   vendor-agnostic so multiple implementations can be measured against the
   same contract.
3. **No self-awareness.** The agent had no API for querying its own resource
   usage. This is the S-5 clause in the contract — the most violated and the
   most important.
4. **No bound enforcement.** The Claude Code process had no upper bound on
   memory consumption. It would keep allocating until the kernel killed
   something — usually the operator's other work.

## What the breach produced

- The `hulk` organism (this home)
- The hulk contract (bones + skin clauses)
- The `hulk-org` GitHub organization
- The plan for `claw-code` as a second implementation under `ultraworkers`
- A new naming pattern: carriers get carrier-shaped names, not vendor or
  model names

## The principle

**A hulk that crashes the host it runs on is wreckage, not a hulk.**

Every clause in the contract traces back to this principle. When in doubt
about whether a behavior is acceptable in a hulk implementation, ask:
"Does this protect the host?"
