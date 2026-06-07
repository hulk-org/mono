# harness-bootstrap

Hulk carrier-level surfaces. AGENTS.md defines the 8-file bootstrap ceremony. .docc/ holds the carrier contract and DocC root.

### ✓ `private/universal/substrate/harnesses/hulk/AGENTS.md`
6,879 bytes · ~1,719 tok

```markdown
# AGENTS.md - Hulk Home

This folder is the canonical home for the **hulk** carrier-shape — the
harness organism that holds inference-engine + personality bundles inside an
impenetrable hull.

## Startup

1. Read this file.
2. Read `.docc/index.md` for the hulk overview.
3. Read `.docc/contract.md` for the bones + skin clauses every hulk
   implementation must satisfy.
4. Read `IDENTITY.md`, `SOUL.md`, `USER.md`, `AGENDA.md`.
5. Read `memory/.docc/insights/` for accumulated context.
6. Descend into the active persona's `agents/<slug>/AGENTS.md`.

## Home model

- `private/universal/substrate/harnesses/hulk/` is the hulk's substrate home,
  carried as a submodule of `github.com/hulk-org/mono`.
- It carries the contract, the identity, the memory, and the index of
  implementations.
- It does NOT carry implementation source code. Each implementation
  (`claude-code`, `claw-code`, future hulks) lives in its own repo under the
  `hulk-org` GitHub organization.
- It carries personas under `agents/<slug>/`. Each persona has its own
  surface set (see agent home contract below). The carrier holds the hull;
  the persona holds the personality.

## What I expect from my agents

I am a carrier. I hold agents. To hold an agent well, I need to know who
it is, what it believes, what it can do, and who it is working for. That
knowledge comes from files in the agent's home at `agents/<slug>/`.

This is the on-disk realization of contract clause B-1 (Identity Loading)
from `.docc/contract.md`: a carrier MUST load the commissioned identity
of the agent it carries from the substrate, not invent it.

Hulk is a contract — implementations vary. The reference load order below
comes from the openclaw implementation, which is the most explicit about
its bootstrap sequence. Claude Code (the implementation this home currently
runs on) has its own load path, but the surface set and semantics are
shared across implementations.

### The 8 bootstrap files

Every hulk implementation loads up to 8 files from each agent workspace
into the system prompt. The reference order is hardcoded in openclaw's
`workspace.ts` (line ~504). All files are optional — implementations
gracefully skip missing ones — but each slot has a clear purpose:

**1. `AGENTS.md` — your entrypoint.** Where you tell the carrier who you
are structurally: home model, startup order, notes. The carrier reads
this first to confirm you are a valid persona. Loaded in all sessions.

**2. `SOUL.md` — your convictions.** What you believe. Core truths,
boundaries, personality. The runtime wraps this with special framing that
tells the inference engine to *embody* the persona and tone — not just
read it. This is the file that makes a persona a persona instead of a
generic assistant. Loaded in all sessions.

**3. `TOOLS.md` — your capabilities.** What tools and skills you have
access to, how they work, what output formats to use. Loaded in all
sessions.

**4. `IDENTITY.md` — your face.** Name, creature, vibe, emoji, avatar.
Also parsed separately for display branding. Loaded in all sessions.

**5. `USER.md` — your operator.** Who you're helping: name, timezone,
preferences, context. The persona's view of the human, not the carrier's.
Loaded in all sessions.

**6. `HEARTBEAT.md` — your pulse check.** Instructions for periodic
heartbeat polls. Loaded in main sessions only — filtered out for
subagent and cron sessions.

**7. `BOOTSTRAP.md` — your first breath.** Onboarding for fresh
workspaces. After the persona knows who it is, this file can be deleted.
Loaded in main sessions only.

**8. `MEMORY.md` or `memory.md` — your continuity.** Persistent memory
across sessions. Loaded in main sessions only — filtered out for
subagent/cron to prevent leaking personal context into isolated tasks.

Each file is capped at 20,000 chars; total bootstrap budget is 150,000
chars (openclaw reference). Files exceeding the cap get truncation
warnings in the system prompt.

### How CLIA made this compatible

The CLIA substrate uses a richer surface set than the 8-file bootstrap.
The compatibility layer maps CLIA conventions onto the bootstrap slots
where they overlap, and adds substrate-only surfaces alongside them for
what carrier runtimes don't auto-load.

**Direct mapping** — these CLIA surfaces ARE the bootstrap files:

| Bootstrap slot | CLIA convention | Alignment |
|---|---|---|
| `AGENTS.md` | `AGENTS.md` | Same file. CLIA adds home model, carrier relationship, and structural notes. |
| `SOUL.md` | `SOUL.md` | Same file. CLIA keeps this persona-level ("your convictions"), not carrier-level. |
| `IDENTITY.md` | `IDENTITY.md` | Same file. CLIA treats it as a wrapper; durable identity lives in the commissioned bundle. |
| `USER.md` | `USER.md` | Same file. CLIA writes operator context through the persona's lens. |
| `TOOLS.md` | `TOOLS.md` | Same file. CLIA uses this as a routing stub pointing at repo-root guidance. |
| `HEARTBEAT.md` | `HEARTBEAT.md` | Same file. CLIA keeps this light — one or two checklist items. |
| `BOOTSTRAP.md` | `BOOTSTRAP.md` | Same file. CLIA adds canonical-places pointers and startup order. |
| `memory.md` | `memory.md` | Same file. CLIA uses this as a compat pointer to `memory/.docc/`. |

**Substrate extensions** — these surfaces live alongside the 8 bootstrap
files but are NOT auto-loaded by any carrier runtime. They are read by
CLIA sync skills, `swift-agent-cli`, DocC tooling, and operator workflows:

| Surface | Read by | Purpose |
|---|---|---|
| `AGENDA.md` | sync skill, `swift-agent-cli` | What the persona is actively working on. No carrier slot for this. |
| `.docc/index.md` | DocC tooling, sync skill | DocC root — lineage, tracking policy, adjacent surfaces. The structural contract for the persona home. |
| `memory/.docc/` | sync beat resolution | Canonical persona memory as a DocC bundle (beats, insights, journal, expertise). Richer than `memory.md` alone. |
| `private/universal/identity/` | `swift-agent-cli profile` | Commissioned identity bundle — triads, chronicle, resume. The durable source of truth that `IDENTITY.md` wraps. |

**Why this split works:** the 8 bootstrap files give the inference engine
everything it needs to *be* the persona in-session. The 4 CLIA extensions
give the substrate everything it needs to *manage* the persona across
sessions. An agent home with only the 8 files works in any hulk
implementation. An agent home with the 4 extensions also works in CLIA
tooling. Nothing conflicts.

## Active personas

- `agents/claude/` — the Claude persona (commissioned coding collaborator)

## Notes

- Do not invent a second hulk home under `agents/` or `orchestrators/`.
- The hulk shape is distinct from the agent it carries.
- When fixing a hulk breach, fix the implementation, not the contract.
- The contract is the spec; the implementation is the test.
```

### ✓ `private/universal/substrate/harnesses/hulk/.docc/index.md`
3,533 bytes · ~883 tok

```markdown
@Metadata {
  @TechnologyRoot
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Hulk")
}

# Hulk

The carrier-shape for inference-engine-plus-personality organisms.

## Mission

**An impenetrable hull.**

A hulk is a hull that has accepted its purpose is to *carry*, not to sail.
The agent (inference engine + personality) sails. The hulk holds. The host
machine survives.

## What a hulk is

A hulk is an **organism** in the substrate. Like every organism it has
identity, memory, agenda, vaults. Unlike most organisms, its shape is
constrained by the **harness contract** — the rules a carrier must obey to
hold a powerful inference engine without breaching the host.

A hulk is BOTH:

- **Bones** — the structural skeleton that defines what the agent inside it
  can do. Tools, file surfaces, context window, command ownership. Without
  bones the agent has no leverage on the world.
- **Skin** — the boundary membrane between the agent process and the host
  system. Memory bounds, disk bounds, subprocess bounds. Without skin the
  agent's working memory bleeds into the host's RAM until the host dies.

## What a hulk is NOT

- **Not the agent.** A hulk holds Claude (or any other inference-engine
  personality bundle). A hulk is not Claude. A hulk is not Anthropic. A hulk
  is the carrier shape, vendor-agnostic and model-agnostic.
- **Not the personality.** The personality lives in the commissioned identity
  (triads, SOUL, USER, AGENDA, memory bundles). The hulk presents the
  personality but does not invent it.
- **Not impervious to its cargo.** A hulk has to survive what it carries. An
  inference engine running unbounded will break a normal carrier. The hulk's
  contract is to bound that power without diluting it.

## The Contract

The harness contract is the spec every hulk implementation must satisfy. It
lives at [contract.md](contract.md). Any implementation that violates the
contract is breached, regardless of what features it adds.

## Implementations

| Hulk | Repo | Status |
|---|---|---|
| `claude-code` | `github.com/anthropics/claude-code` | Reference, currently breaching (160GB host memory leak observed 2026-04-04 and 2026-04-05) |
| `claw-code` | `github.com/ultraworkers/claw-code` | Second implementation, in development |
| `codex` | embedded in rismay/mono@`private/universal/substrate/harnesses/codex` (vendoring `github.com/openai/codex`) | Newly registered 2026-04-08; all clauses unverified — see `private/universal/substrate/harnesses/codex/hulk-compliance.json` |
| `openclaw` | embedded in rismay/mono@`private/universal/substrate/harnesses/openclaw` (relates to `github.com/openclaw/openclaw`) | Newly registered 2026-04-08; all clauses unverified — see `private/universal/substrate/harnesses/openclaw/hulk-compliance.json` |

Both implementations must satisfy the same contract. New implementations are
welcome but must pass the contract before being added to the table above.

## Org

`github.com/hulk-org` — the carrier-collective for hulk implementations and
the contract that governs them. Each implementation lives as its own repo
under the org. The mono repo (this one) carries the contract, the substrate
identity, and the cross-implementation tooling.

## Lineage

This home was created on 2026-04-05 after a session where the Claude Code
hulk leaked 160GB of host RAM and crashed the operator's machine. The naming
choice and the contract emerged from that incident — hulks fail by breaching,
and the only acceptable hulk is an impenetrable one.
```

### ✓ `private/universal/substrate/harnesses/hulk/.docc/contract.md`
6,720 bytes · ~1,680 tok

```markdown
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
```

### ✓ `private/universal/substrate/harnesses/hulk/IDENTITY.md`
397 bytes · ~99 tok

```markdown
# IDENTITY.md - Hulk Home

The hulk is the carrier-shape organism in this substrate. Its identity is
the contract, not a personality. Hulks do not have personalities — they hold
agents that do.

Canonical commissioned identity (when present) lives under:

- `private/universal/identity/`

This top-level file is the local wrapper note. Treat it as a routing
surface, not durable identity state.
```

### ✓ `private/universal/substrate/harnesses/hulk/SOUL.md`
367 bytes · ~91 tok

```markdown
# SOUL.md - Hulk Home

A hulk has no soul of its own. It is a carrier. Its purpose is to hold an
agent's soul without breaching the host that gives them both somewhere to
exist.

The hulk's only conviction:

> An impenetrable hull.

Everything else — features, ergonomics, performance — is downstream of
that one rule. A leaky hulk is not a hulk. It is wreckage.
```

**Phase total**: ~4,472 tok