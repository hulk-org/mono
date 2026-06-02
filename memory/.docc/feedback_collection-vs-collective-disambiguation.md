---
name: collection-vs-collective-disambiguation
description: "Substrate vocabulary distinction — \"collection\" (atemporal set under kura/) and \"collective\" (organizational unit under collectives/) are DIFFERENT concepts. One letter apart, opposite stances."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0f0230a3-d8da-40c8-bb31-f3800c86474e
---

The substrate now uses both words. They mean different things — do
not conflate.

| word | substrate location | what it is |
|---|---|---|
| **collective** | `private/universal/substrate/collectives/<slug>/` | organizational unit; an org/team/company surface with its own identity, repo, members, projects. Examples: `clia-org`, `wrkstrm-app`, `schema-universal`, `digikoma-org`. Has org-level governance, assignments, agendas. |
| **collection** | `agents/<slug>/kura/collections/<name>/` | atemporal set; an unordered membership-stance set of typed items inside an agent's kura. Examples: forms, glyphs, voices. Has set semantics + typed manifest. |

**Why the distinction matters:**

- Collectives are ORGS — they exist on their own, have their own
  homes, can be commissioned and dissolved, have member relations.
- Collections are SUBSETS OF AN AGENT — they exist inside one agent's
  home, are owned by that agent, don't have their own organizational
  identity.

A `wrkstrm` collective is an organization the substrate works with.
A `forms` collection is part of chatgpt's home — chatgpt's set of
form-variants.

**Naming convention to avoid confusion in code/prose:**

- Use "collective" when referring to org-level surfaces.
- Use "collection" when referring to kura set-stance content.
- When ambiguous, prefer the substrate path: "the wrkstrm collective"
  vs "chatgpt's forms collection."

**Why:** caught during the kura/collections/forms/ doctrine
authoring 2026-05-25. The two words are one letter apart and
substrate now actively uses both. Without the disambiguation,
future-me would conflate them in conversation or code commits.

**How to apply:**

- When writing prose, never use the words interchangeably.
- When authoring code that operates on substrate state, use distinct
  variable/struct names — e.g. `collectivesRoot` vs
  `collectionsRoot`, never just `collections` if you mean orgs.
- The typed primitive surface uses unambiguous names:
  `CollectionManifestModel` (for kura collections) is distinct from
  the org schema family (which has its own typed shape).

See [[kura-collections-atemporal-storehouse-2026-05-25]] for the
collection-stance doctrine.
