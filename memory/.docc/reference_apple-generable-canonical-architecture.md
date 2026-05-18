---
name: apple-generable-canonical-architecture
description: Apple's @Generable macro (FoundationModels, iOS/macOS 26, WWDC25) is the canonical Swift expression of "one declared type → many mechanically-derived projections" — JSON schema, LLM generation contract, decoder, per-field constraints all emitted from one struct annotation.
type: reference
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
Apple's **`@Generable`** macro, introduced in iOS 26 / macOS 26
(WWDC25), is the canonical Swift implementation of the
typed-primitive-to-many-projections architecture the substrate has been
converging on independently.

**What `@Generable` does** when attached to a struct:
- Emits a **JSON schema** describing the shape
- Emits an **LLM-guided generation contract** that constrains
  on-device Foundation Models output to the type
- Emits a **decoder** that parses model output into the typed value
- Per-field **`@Guide`** annotations attach value constraints
  (ranges, regex, descriptions) — a refinement-type slot

**Canonical references:**
- [WWDC25 "Meet the Foundation Models framework"](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25 "Deep dive into the Foundation Models framework"](https://developer.apple.com/videos/play/wwdc2025/301/)
- [Apple Developer: Generable](https://developer.apple.com/documentation/foundationmodels/generable)
- [createwithswift.com walkthrough](https://www.createwithswift.com/exploring-the-foundation-models-framework/)

**Why this matters for the substrate:**
- The substrate's typed-everything investment (LinkRefModel sealed-wrapper
  Targets, NonEmpty<T>, role-named protocols, schema-battle-tested kinds)
  composes directly with `@Generable`. The typed primitive becomes the
  @Generable-annotated struct; the LLM sees the full constraint surface
  at generation time.
- This is the operational shape of the substrate's "ship 10 apps/day via
  FoundationModels" project — one typed model declaration drives
  validation + generation + UI projection.
- Other systems converged on the same architecture: FastAPI + Pydantic
  (Python type hints → OpenAPI → Swagger), react-jsonschema-form
  (JSON Schema → form), v0 by Vercel (prompt → typed React components).
  The substrate is aligning with industry practice, not inventing.

**Consequence for design choices:** when proposing a new typed primitive,
ask "does this compose cleanly with @Generable?" If yes, the primitive is
on the canonical path. If not (e.g., requires runtime context to interpret),
that's a flag — the primitive may need refactoring to live closer to the
declarative-shape end of the spectrum.
