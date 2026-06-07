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
