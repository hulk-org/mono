---
name: digikoma-deep-research-species
description: Deep-research workflow as a digikoma triad — Planner → N parallel Researchers → Synthesizer, mediated by station receipts on disk; closer to OpenAI Swarm (bounded, context-only, no mid-term memory) than to OpenAI Agents SDK; missing capability is Tau-side parallel fan-out scheduling.
type: project
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
Web deep-research as a digikoma capability maps cleanly to a three-species
triad — **Planner → N parallel Researchers → Synthesizer** — with
**station receipts on disk** as the handoff medium (instead of
in-memory baton passing).

**Origin pattern:** OpenAI Agents SDK Deep Research example
([cookbook](https://developers.openai.com/cookbook/examples/deep_research_api/introduction_to_deep_research_api_agents))
and OpenAI Swarm handoff model
([github.com/openai/swarm](https://github.com/openai/swarm)).
The Planner decomposes the question into ~5 structured SubQuery
artifacts; investigators run those in parallel calling web_search
web_fetch; the Synthesizer composes a cited markdown report under a
strict citation contract.

**Why digikoma fits Swarm BETTER than Agents SDK:**
Both Swarm and digikoma insist on bounded units, context-only,
no mid-term memory. Digikoma even improves on Swarm — Swarm's
in-memory baton becomes a durable on-disk station receipt that's
auditable + replayable + parallelizable.

**Concrete digikoma sketch:**
- *Species:* `Researcher` (working name; species naming is provisional
  per `feedback_koma-species-naming-provisional`).
- *Anatomy:* planner-traversal preset visiting `plan → fanout → synth`.
- *Scan actions:* `decompose(question) -> [SubQuery]`,
  `investigate(subquery) -> [Finding]`,
  `synthesize([Finding]) -> Report`.
- *Tools per station:* planner = none (LLM reasoning only);
  investigator = `web_search` + `web_fetch` + `citation_emit`;
  synthesizer = `read_findings_artifact`.
- *Receipts:* planner emits `subqueries.json`; each investigator emits
  `findings-<n>.json` with `{claim, url, snippet, retrieved_at}`;
  synthesizer reads the glob and emits `report.md` + `citations.json`.
- *Handoff:* Tau dispatches investigators in parallel by reading the
  planner receipt — Swarm's handoff pattern, routed through filesystem.

**Capability gap to close:** Tau-side **parallel fan-out scheduling**
("for each SubQuery, mint an investigator") is the only primitive
digikoma doesn't yet have. Swarm doesn't have it either (sequential
loop); LangGraph does. Implement at the Tau layer, not inside any
Koma — keeps Koma bounded.

**Why provenance lives in a separate validator station:** the
synthesizer Koma should NOT self-police citation correctness. Add a
post-synth validator station that asserts every claim in `report.md`
maps to a `findings-*.json` entry. Implements the citation contract
at the type-of-station level, not in synthesizer prompt discipline.
