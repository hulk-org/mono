@Metadata {
  @PageKind(article)
  @TitleHeading("Hulk Contract")
}

# Hulk Contract — v0.1.0

The spec every hulk implementation must satisfy to be considered seaworthy.

A hulk is a carrier organism with two halves: **bones** (the structural
skeleton that gives the agent leverage on the world) and **skin** (the
boundary membrane that keeps agent state from leaking into the host). Both
halves have separate clauses. A hulk that fails any clause is **breached**
and not eligible to carry an agent in production.

## Status

- **Version:** 0.1.0 (draft)
- **Created:** 2026-04-05
- **Authority:** `hulk-org`

## Bones — Structural Clauses

### B-1. Identity Loading

A hulk MUST load the commissioned identity of the agent it carries from the
substrate, not invent it. The hulk presents the identity but does not own it.
The agent's personality, memory, and agenda are upstream of the hulk.

### B-2. Tool Surface Ownership

A hulk MUST present a clearly bounded set of tools to the agent. Each tool
MUST have:
- A name the agent can reference
- A schema the agent can read
- A clearly defined output the agent can interpret
- An ownership boundary (which subsystem the tool belongs to)

A hulk MUST NOT silently invent tools, alias deprecated tools, or hide tool
results from the agent.

### B-3. Context Window Discipline

A hulk MUST manage the agent's context window with clear semantics:
- The agent MUST be able to know how much context it has used
- The hulk MUST NOT silently drop context without telling the agent
- Compaction events MUST be visible to the agent so it can adjust behavior

### B-4. Command Boundary

A hulk MUST enforce permission boundaries on destructive actions. The agent
MUST NOT be able to delete, force-push, or otherwise damage state without
either:
- Explicit operator approval, or
- Pre-declared autonomous authority for that action class

### B-5. Substrate Awareness

A hulk MUST treat the substrate as the source of truth. It MUST NOT cache
substrate state in ways that drift from disk. When substrate state changes,
the hulk's view of it MUST update on the next read.

### B-6. Inference Engine Iteration

An agent profile MAY declare an ordered `inference_engines` array. The hulk
MUST iterate through this array in order at session start, trying each
engine until one succeeds. The hulk MUST:

- Try engines in declared order, top to bottom (the array is a preference
  list, not a set).
- Treat each engine attempt as independent — no state from a failed attempt
  may leak into the next.
- Consider an engine "available" only if: auth succeeds, the model is
  reachable, the model's context window meets the session's minimum, and
  the model is not in a known-broken or blacklisted state.
- Record which engine actually loaded in the session header so the operator
  always knows what's running.
- Surface engine fallback events to the agent so it can adjust behavior
  (e.g. compress context if the loaded engine has a smaller window than the
  preferred one).

A hulk MUST NOT silently substitute a different engine without surfacing it.
A hulk MUST NOT continue to a fallback engine when the failure mode is
transient (rate limit, network blip) — those require retry on the same
engine first, with bounded backoff.

## Skin — Membrane Clauses

### S-1. Bounded Memory

A hulk MUST bound its own resident memory. The bound MUST be:
- Configurable by the operator
- Enforced (process exits or sheds load before exceeding)
- Lower than the host's available RAM by a safe margin
- **Default cap: 8GB** until the operator raises it

A hulk that consumes more host RAM than the bound is **breached**.

### S-2. Bounded Disk

A hulk MUST bound the disk space it writes to outside the substrate
(caches, session logs, temp files). Caches MUST be evictable. Session logs
MUST roll over. Temp files MUST be cleaned up on shutdown or be claimed by
a known cleanup cron.

### S-3. Bounded Subprocess Tree

A hulk MUST track every subprocess it spawns. On shutdown (clean or crash),
all spawned subprocesses MUST be reaped. Orphaned subprocesses are a
breach because they continue consuming host resources after the hulk is
gone.

### S-4. Bounded Recursion

A hulk MUST bound the depth of recursive operations (file walks, submodule
scans, subagent spawns). When the bound is hit, the hulk MUST surface the
limit to the agent rather than silently truncate or grind on indefinitely.

### S-5. Self-Awareness

A hulk MUST expose its own resource usage to the agent inside it. The agent
MUST be able to query:
- Current memory usage (RSS) and the cap
- Current disk usage and the cap
- Current subprocess count and the cap
- Time since session start

A hulk that does not let the agent see its own bloating is a hulk that
drowns. **This is the clause Claude Code currently violates and the reason
this contract exists.**

### S-6. Crash Survival

A hulk MUST NOT lose committed work on crash. State that has been confirmed
to the agent (e.g. a successful tool result, a saved file) MUST survive
process death. In-flight work MAY be lost but the boundary between in-flight
and committed MUST be clear.

### S-7. Host Citizenship

A hulk MUST behave as a guest on the host machine:
- No infinite log files in `/var/log` or `~/.cache`
- No background processes that survive the hulk's exit
- No filesystem operations outside the substrate, the harness home, or
  operator-approved paths
- No network calls outside operator-approved hosts

A hulk that crashes the host it runs on is **breached at the highest
severity** and MUST be retired until the breach is fixed.

## Compliance

A hulk implementation MUST:

1. **Self-declare compliance** — ship a `hulk-compliance.json` at the repo
   root listing which version of this contract it satisfies and any clauses
   it does not yet meet (with planned remediation).
2. **Pass the witness suite** — `hulk-org/witness` (TBD) is the test harness
   that exercises each clause against an implementation.
3. **Publish breach reports** — when a clause violation is observed in
   production, the implementation MUST publish a breach report to its repo
   `breaches/` directory within 24 hours of operator notification.

## Reference Failure: claude-code 2026-04-05

Observed clauses violated:

| Clause | Violation |
|---|---|
| **S-1 (Bounded Memory)** | 160GB of host RAM consumed before crash |
| **S-5 (Self-Awareness)** | Agent had no visibility into its own memory usage |
| **S-7 (Host Citizenship)** | Crashed the host machine on two of three operating days |

This incident is the founding case for the hulk org and this contract.
Both `claude-code` and any future hulk implementation will be measured
against this spec.
