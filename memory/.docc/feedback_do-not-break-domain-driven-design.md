---
name: do-not-break-domain-driven-design
description: "AXIOM (PROMOTED 2026-06-01 to typed AxiomModel at kura-spaces/axioms/do-not-break-domain-driven-design.axiom.su.json — this memory is downstream POINTER) — typed primitives must live in the domain they belong to; CLIA-substrate concepts (ghost, .clia, conversation-protocol) must NOT contaminate primitive domains (common-process, common-shell, swift-subprocess wrappers)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e8ff6a66-d381-4c84-95c3-0495090df941
---

**TYPED-RECORD CANONICAL TRUTH**: This pattern PROMOTED to typed `AxiomModel` instance at:
`private/universal/substrate/collectives/spaces-universal/private/universal/kura-spaces/axioms/do-not-break-domain-driven-design.axiom.su.json` (authored 2026-06-01 under /capture protocol). Composes with the [[ddd-architectural-rehome]] workflow (typed corrective execution-graph) + [[ddd-architect]] role (typed role-surface-manifest). Operator-tagged #axiom = highest-priority promotion candidate; promoted at first /capture opportunity.

---


operator 2026-05-31 (#axiom-tagged) catching me put `GhostProcessGroup` typed primitive inside `common-process` (Unix-primitive process-spawning domain): *"the ghost process group does not belong in common-process. that might be a clia thing."* + *"do not break domain driven design. #axiom"*

**Axiom**: Every substrate-typed primitive lives in EXACTLY ONE domain — the BOUNDED CONTEXT it belongs to per Domain-Driven Design discipline. Cross-domain composition happens via explicit typed contracts (schemas, protocols), NEVER by sneaking concepts from one domain into another's source files.

**Concrete rule for the substrate's process-domain stack**:

| Domain layer | Owns | Does NOT own |
| --- | --- | --- |
| `common-process` (Unix-primitive) | Process spawning, exit status, signals, process groups (kernel-level concept), runner-agnostic typed primitives | NO knowledge of ghosts, conversation turns, CLIA personas, or substrate doctrine |
| `common-shell` | Shell execution + typed ArgumentParser scaffolding | NO knowledge of ghosts or conversation |
| `clia-conversation-kit` / `clia-org` | Ghost personas, typed conversation protocol bindings, ghost-flavored wrappers of primitive types | Process spawning internals; consumes common-process via typed contracts |
| `ghost-shell-org` | Ghost wire protocol (GhostShellIPC), LanguageModelSession glue, ghost-shell binaries | Process spawning internals; consumes common-process |
| Schema family `common-process-schemas` | Typed contract for common-process domain | NO ghost-flavored types |
| Schema family `ghost-schemas` (or clia equivalent) | Typed contract for ghost-flavored composition | NO Unix-primitive types except as references |

**Why**: per Eric Evans' DDD discipline + the substrate's typed-everything investment — each typed-noun molecule belongs to ITS BOUNDED CONTEXT. When I authored `GhostProcessGroup.swift` inside `common-process/sources/common-process/`, I sneaked a CLIA-substrate concept (ghost) into the Unix-primitive layer. This pollutes common-process with knowledge it doesn't need + creates the wrong typed dependency direction (low-level package having a name from a higher-level domain).

**The corrective architecture**:

```
common-process (Unix-primitive)
├── ProcessGroupSpec        ← N-member group spec, ghost-agnostic
├── ProcessGroupAuthority   ← typed enum: singleProcess / selfOwnedGroup / shareGroupWith / observerOnly
├── ProcessTeardownStep     ← typed sequence step, runner-agnostic
└── SafeGroupAuthority      ← safe-pairing proof (Unix-kernel concept)

clia-org or clia-conversation-kit (CLIA-substrate)
└── GhostProcessGroup       ← composes ProcessGroupSpec + ghost identity + ghost authority
                              + chat-turn lifecycle + ghost-receipt shape
```

The CLIA-flavored typed-noun (`GhostProcessGroup`) DEPENDS ON the Unix-primitive (`ProcessGroupSpec`); the reverse direction is forbidden.

**How to apply**:
- BEFORE authoring a new typed Swift file, ask: "what domain does this concept BELONG to?" If multiple, the file lives in the LOWER-LEVEL domain WITHOUT naming the higher-level concept; the higher-level domain authors a typed wrapper that composes it.
- When tempted to use a domain-specific noun (Ghost, Conversation, Workstream, CLIA, etc.) in a primitive-layer file → STOP. Rename to the generic concept; move the named wrapper to the domain that owns the name.
- Schema families honor the same split: `common-process-schemas` carries `ProcessGroupSpecModel`; `ghost-schemas` (or `clia-conversation-kit-schemas`, wherever the ghost-typed-noun lives) carries `GhostProcessGroupModel` referencing the primitive model.
- When primitives need to compose UP (rare — usually composition flows DOWN), use typed protocols + dependency injection at the consumer layer, not direct imports.

**Operational consequences**:
- The 4 files I authored in `common-process/sources/common-process/` (`SafeGroupAuthority.swift`, `GhostProcessAuthority.swift`, `GhostTeardownStep.swift`, `GhostProcessGroup.swift`) need rename — drop the `Ghost` prefix on 3 of them; keep `SafeGroupAuthority` (already ghost-agnostic).
- The `process-group.investigation.docc` I authored inside common-process needs to STRIP the CLIA RPG Trainer↔Team mapping page — that doctrine belongs in clia-org. The Unix-primitive investigation stays.
- The `GhostProcessGroup` typed-noun lives in CLIA domain — likely `clia-conversation-kit` (existing typed surface) OR a new `clia-org/.../clia-ghost-runtime/` package. Bead-track the placement.

**3x-rule promotion candidate**: per [[feedback_substrate-wide-cascade-pattern]] this is the FIRST formally-named "DDD discipline" axiom for the substrate. Future operator-confirmed instances move it toward typed AxiomModel promotion at `spaces-universal/.../kura-spaces/axioms/do-not-break-domain-driven-design.axiom.su.json`.

**Composes with**: [[feedback_typed-primitive-bypass-3x-rule-confirmed]] (the discipline that should have caught this earlier — searching for "where does this concept already live" before authoring) + [[feedback_substrate-composes-typed-idea-molecules]] (typed molecules respect domain boundaries when bonding cross-domain) + [[feedback_operator-intuition-is-substrate-truth-ahead-of-articulation]] (operator caught the DDD violation; substrate-truth was that ghost ≠ Unix-primitive-domain) + [[feedback_rehome-not-archive-substrate-cleanup]] (rehome the ghost-named files to their proper domain home).
