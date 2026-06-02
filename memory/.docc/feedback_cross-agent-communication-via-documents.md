---
name: cross-agent-communication-via-documents
description: "Substrate doctrine — agents have PRIVATE agendas; cross-agent coordination flows through typed documents (SOPs, architecture, design, investigations) under substrate-shared collections; shared bead pools are forbidden. This makes inter-agent work a KNOWLEDGE-GRAPH operation, not a WORK-GRAPH operation."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

Operator-locked 2026-05-25 during Kura storage typology Axis 3 decision: *"we need to let agents have their own agency. cross agent communication is done through SOP, architecture documents, design documents, investigation documents, etc."*

## The rule

**Agents have private agendas.** Each agent's beads, threads, and Techo lanes live in that agent's commissioned home (or its personal Kura tree). No agent reaches into another agent's burn-down queue.

**Inter-agent coordination flows through typed documents in the substrate-shared collection tier:**
- **SOPs** (`operating-protocol-schemas`) — how multiple agents handle a recurring kind of work
- **Architecture documents** — substrate-wide structural decisions (DocC indexes, design rationale, doctrine)
- **Design documents** — feature/product designs that downstream agents reference
- **Investigation documents** — exploratory work surfaced for cross-agent reading
- **Decisions** (planned) — captured choices with rationale

## Why this matters — the deeper doctrine

Inter-agent work becomes a **knowledge-graph operation, not a work-graph operation**. When two agents need to coordinate:

- **Wrong way**: agent A drops a bead in a shared "incident-response" pool that agent B picks up. Coordination through ephemeral shared queue.
- **Right way**: agent A authors an SOP / architecture doc / investigation in `private/universal/kura/collections/<doc-slug>/`. Agent B reads it. Each agent then spawns their OWN beads in their OWN agenda based on the document. Coordination through durable typed artifact.

The doctrinal payoffs:
1. **Durability**: the substrate can re-read what was coordinated years later. Bead queues evaporate; documents persist.
2. **Indexability**: typed documents under substrate-shared collections are grep-able + LinkRef-resolvable. Bead pools across agents lose context fast.
3. **Author accountability**: documents have an author + a moment of authoring. Shared bead pools have ambiguous ownership.
4. **Reading discipline**: agents read the document and decide how to act, not just inherit a TODO. Forces interpretation, which is where most coordination bugs hide.
5. **Pairs with the thread bridge**: each agent's threads can `knowledgeRefs[] -> shared-document-X` — threads bridge the agent's private work-graph into the substrate-shared knowledge-graph. The bridge model only works because the KG side is canonical-shared and the WG side is per-agent-private.

## How to apply

1. **When proposing inter-agent coordination, default to authoring a document** in `private/universal/kura/collections/<doc-slug>/`. Pick the shape that fits:
   - SOP for repeatable processes (uses `operating-protocol-schemas`)
   - Architecture doc for structural decisions
   - Design doc for feature/product shape
   - Investigation for exploratory write-ups

2. **Reference documents from agent-private threads via `knowledgeRefs[]`**. The thread is where each agent's local work attaches to the substrate-shared knowledge.

3. **Don't propose shared bead pools or cross-agent work queues**. If two agents need to do related work, both author beads in their OWN agendas with `relatedDocument` LinkRefs pointing at the same shared document.

4. **Closed threads become documents**. When an agent's thread closes (per the thread-close skill), the closed thread itself is a knowledge-graph artifact that other agents can reference. This is the canonical path from "an agent did work" to "the substrate learned something" — capture the lesson via thread close, then the closed thread is indexable cross-agent.

## When NOT to apply

- **Single-agent work**: no document needed. The agent's private agenda + threads are enough.
- **Real-time chat / synchronous interaction**: documents are async durability artifacts. In-the-moment back-and-forth happens elsewhere (operator → agent direct conversation).
- **Ephemeral coordination state** (e.g., "I'm currently editing file X, you wait"): use a lockfile or runtime state mechanism, not a document. Documents are for durable coordination doctrine, not transient locks.

## Related memories

- [[kura-storage-typology]] — names the 5 tiers; documents live in collections (substrate-shared)
- [[threads-bridge-knowledge-and-work-graphs]] — threads bridge per-agent WG to substrate-shared KG via `knowledgeRefs[]`
- [[lens-apps-substrate-pattern-2026-05-18]] — apps as lens functions over vault records; cross-agent surfaces are themselves lensable
- [[summon-vs-forge-two-registers]] — different communication registers; documents are the canonical forge-register substrate communication
- operating-protocol-schemas (substrate-internal) — typed SOP shape
- thread-close skill — the lifecycle event that promotes a closed thread to a stable KG node
