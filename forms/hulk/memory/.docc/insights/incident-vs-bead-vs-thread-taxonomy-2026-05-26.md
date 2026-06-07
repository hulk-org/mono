---
name: incident-vs-bead-vs-thread-taxonomy-2026-05-26
description: "Substrate work-item ontology — bead = discrete burn-down, thread = coordinating scope, incident = stop-world reactive crisis with typed IncidentBehaviorContract; legacy .clia/incidents conflated all three; modern incident-schemas v0.1.0 enforces the distinction at the type level"
metadata:
  node_type: memory
  type: insight
  originSessionId: 64a71af5-2c6a-47fa-879c-6e0728995cf8
---

Session 2026-05-26 architectural cut with operator rismay during the
legacy-incident triage. Operator's defining sentence: **"it's a very
specific thing. and it requires changing the entire team's behavior.
that's why we created [incidents]."**

That sentence is the type signature. An incident is not "high priority
work" — it's **work that changes how everyone else operates until it's
resolved.** Type-system enforcement makes "is this really an incident?"
mechanical: if you can't fill the IncidentBehaviorContract, you don't
have an incident.

## The three shapes

### Bead — discrete burn-down work
- Lives at `agents/<slug>/agenda/beads/<id>.issue.json`
- Schema: existing bead JSON shape (id, title, description, assignee,
  issueType, status, priority 1-4, labels, sourceType, ...)
- **Key property**: doesn't change anyone else's behavior. "Someone fixes
  this when convenient."
- Bug fixes, discrete tasks, decisions awaiting operator, investigations.

### Thread — coordinating scope
- Lives at `agents/<slug>/agenda/threads/` (or substrate threads dirs)
- Schema: `system/schema-families/thread-schemas/v0.3.0/` (ThreadModel
  with boundary, crossings, derived[], activities, priority, status)
- **Key property**: coordinates multiple actors/actions toward a goal
  without freezing other work. Multiple beads may derive from one thread.
- Long-running coordination, product launches, schema migrations, sweeps.

### Incident — stop-world reactive crisis (NEW v0.1.0 typed shape)
- Lives at `<incident-store>/<incident-slug>.json`
- Schema: `system/schema-families/incident-schemas/v0.1.0/`
  - `IncidentModel` — top-level record (slug, title, severity, status,
    behaviorContract, declaredBy, ownedBy, service, affectedComponents,
    detectionEvent, relatedThread, relatedBeads, postMortem, ...)
  - `IncidentSeverityOrdinalityTable` — S0/S1/S2/S3 with teamBehaviorRule
  - `IncidentStatusOrdinalityTable` — declared/contained/resolved/post-
    mortem-complete/obsolete
  - **`IncidentBehaviorContract`** — REQUIRED on every incident; carries
    freezeScope + behaviorChanges[] + escalationOwners + resumptionCriteria
- **Key property**: declaring an incident IS declaring what behavior
  changes for whom and until what condition. If the contract can't be
  filled, the record is a bead or thread, not an incident.

## The decision test

When you have a problem and need to choose a work-item shape, ask:

1. **Does anyone else's normal work need to pause / change for this?**
   - Yes → **Incident** (fill IncidentBehaviorContract)
   - No → continue
2. **Does this require coordinating multiple actors or actions toward a
   goal that can be authored as one scope?**
   - Yes → **Thread**
   - No → continue
3. **Is this discrete burn-down work?**
   - Yes → **Bead**

Severity (S0-S3) lives on incidents and indicates how disruptive the
stop-world is. Priority (1-4) lives on beads and indicates burn-down
urgency. They're DIFFERENT scales: an S1 incident is "fast-track
mitigation, owners pause non-critical work"; a priority-1 bead is "urgent
discrete fix, but other work continues."

## Why this is doctrine-level

Legacy `.clia/incidents/` conflated all three: bugs (code-swiftly crash)
got S1 CODE RED; long-running launches (CLIA-ORG INIT) got S1 CODE RED;
real time-bounded crises (demo-tomorrow readiness) also got S1 CODE RED.
Result: the CODE RED designation lost meaning, stale incidents
accumulated for months, the substrate's signal-of-real-crisis degraded.

Typed `IncidentModel` with required `IncidentBehaviorContract` prevents
this regression. You can't author an incident without naming who pauses
and when normal behavior resumes. If you don't have that, you're not in
crisis — you have a thread or a bead.

## Companion files / cross-refs

- Schema: `schema-universal/.../system/schema-families/incident-schemas/v0.1.0/`
- Tests: 13/13 passing as of authoring
- Sibling families: `thread-schemas` (v0.1/v0.3), `workstream-schemas`
  (v0.1/v0.2), `workstream-template-schemas` — all under `system/schema-
  families/`
- Legacy migration: 5 legacy `.clia/incidents/` records triaged in same
  session — 2 close-resolved (schema + toolchain evolution), 2 close-
  obsolete (demo passed / service deprecated), 1 (CLIA-ORG INIT)
  reclassified as org-mission-statement + cascading beads
- Related substrate doctrine: [[bead-vs-thread-vs-beat-shapes]] (the
  shape distinction was already pinned for bead/thread/beat; this insight
  extends it with the incident shape on top)
- Related session work: [[clia-bundle-architecture-2026-05-26]]
  org-mission-statement-schemas — same "typed records make the discipline
  enforceable" cut, applied to a different layer
