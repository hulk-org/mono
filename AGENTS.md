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
