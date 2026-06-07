---
name: substrate-is-digikoma-factory-2026-05-23
description: "Substrate's industrial logic is to produce bounded executors (digikomas) that absorb work agents would otherwise spend tokens/attention on; every well-shaped digikoma multiplies agent leverage"
metadata:
  node_type: memory
  type: insight
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

The substrate is a **digikoma factory**. Its industrial purpose is to produce bounded executors that absorb work agents would otherwise spend tokens / attention / context-window on. Every well-shaped digikoma multiplies what agents can do per session — the agent's surface stays constant while the work delivered grows.

**Canonical proof case** (designed 2026-05-23, savepoint pair):
- Without it: a 16-commit cross-9-repo sweep consumed ~half the agent's context window in commit-message authoring, file enumeration, plus-tag attribution, submodule pin choreography, and per-repo doctor verification.
- With it: agent emits ONE `CommitRequestModel` (~8 fields, session pointer + scope). `digikoma-savepoint` reads the session, summarizes, derives commit messages + groupings + co-authors, executes all the gits, writes back a `CommitArtifactModel`. Agent's per-commit cost drops to constant.

**Why it matters when sizing work**: the right question isn't "does this make the agent slightly easier" — it's "does this absorb a *class* of work the agent currently does inline?" If yes → it's factory output, build it. If no → it's one-off tooling, lower priority.

**The digikoma-factory test for proposed substrate work**:
1. Does this become a reusable bounded executor with a typed contract? (not a one-off script)
2. Does it absorb a repeating agent-side burden? (not a feature only useful once)
3. Does it have a clear handoff surface? (agent emits intent → digikoma applies → ledger records receipt)
4. Can it run independently of the agent's session? (so the agent moves on while it works)

Yes to all four → priority factory output. Otherwise: lower priority, keep agent inline.

**Already in the fleet** (digikoma-X-d siblings observed in `digikoma-org/`): digikoma-iofile-d, digikoma-priclass-d, digikoma-seeksize-d, digikoma-hotspot-d, digikoma-loads-d, digikoma-pathopens-d, digikoma-sigdist-d, digikoma-kill-d, digikoma-setuids-d, digikoma-bitesize-d, digikoma-watcher-kernel. Plus digikoma-git, digikoma-hello-world, digikoma-savepoint (in-flight). The factory has shipped output; the question for any new work is "does this slot into the same production line?"

**How to apply**:
- When the operator describes a pain point, mentally evaluate: is this a digikoma the factory hasn't built yet?
- When designing schemas/services, optimize for digikoma-consumability — typed Codable, LinkRef-based provenance, event-bus-shaped interfaces.
- When the agent (me) catches itself doing high-token inline work that repeats across sessions, surface it as a digikoma candidate, not just an annoyance.
- The substrate's "ship 10 apps/day" velocity goal depends on the factory: more digikomas → more agent capacity → more shippable output.

Related: [[project_common-service-substrate-stack]] (the rails the factory runs on); [[feedback_harnesses-agnostic-models-constrain]] (digikomas are model-constrained workers, not harness-bound); [[insights/intelligence-smoke-passed-2026-05-23]] (proof the factory can produce AI-driven digikomas).
