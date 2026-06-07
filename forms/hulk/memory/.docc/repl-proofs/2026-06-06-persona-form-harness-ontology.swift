import Testing

// ============================================================================
// Persona / Form / Harness Ontology Proof — 2026-06-06
// ============================================================================
//
// Claim: The current substrate types conflate three orthogonal axes —
// harness, form, and (implicit) persona — under string-shaped slugs and
// embedded LinkRefs that allow cross-axis confusion at the type-system
// level. The proposed redesign types each axis independently and makes
// the persona axis first-class addressable.
//
// Each @Test below proves ONE structural claim. The three CURRENT-DESIGN
// tests pass even when they encode obviously-wrong semantics, demonstrating
// that the current type system does not catch the conflation. The three
// NEW-DESIGN tests show that the equivalent confusions either no longer
// compile or are now type-distinct.

// ============================================================================
// PART 1 — Model the CURRENT substrate design.
// ============================================================================

enum CurrentDesign {

    // Substrate currently identifies every entity by a kebab-case string slug.
    // No phantom type distinguishes harness-slug from form-slug from
    // (would-be) persona-slug.
    typealias Slug = String

    // Substrate's LinkRefModel v0.3.0 is the canonical reference shape.
    // Correct as a wire format, but at the semantic layer every ref-pointer
    // is shape-identical: the type system cannot say "this LinkRef points
    // at a HarnessModel" vs "this LinkRef points at an AgentModel".
    struct LinkRef: Equatable {
        let kind: String        // "rp" (relative-path), etc.
        let root: String
        let value: String
    }

    struct Agent: Equatable { let slug: Slug }              // agents/<slug>/
    struct Harness: Equatable { let slug: Slug }            // harnesses/<slug>/

    // FormModel — lives at agents/<agent>/forms/<form>/form.json.
    // The harness reference is EMBEDDED here (the `ha` field).
    // There is NO `persona` field — persona is implicit in the form-name.
    struct Form: Equatable {
        let slug: Slug          // `fs` — form-slug
        let harnessRef: LinkRef // `ha` — embedded harness reference
        let modelRef: LinkRef   // `mo` — embedded model reference
        let ownerAgent: Agent   // `ow` — owning agent
    }
}

// ============================================================================
// PART 2 — Model the PROPOSED redesign (harness out, persona in).
// ============================================================================

enum ProposedDesign {

    // Phantom-typed slugs prevent cross-axis confusion at compile time.
    struct AgentSlug: Equatable, Hashable { let raw: String }
    struct HarnessSlug: Equatable, Hashable { let raw: String }
    struct FormSlug: Equatable, Hashable { let raw: String }
    struct PersonaSlug: Equatable, Hashable { let raw: String }

    // LinkRefModel wire format unchanged, but we parameterize the SEMANTIC
    // target type at the API layer so references across axes are typed.
    struct LinkRef<Target>: Equatable {
        let kind: String
        let root: String
        let value: String
    }

    struct Agent: Equatable { let slug: AgentSlug }
    struct Harness: Equatable { let slug: HarnessSlug }
    struct Model: Equatable { let slug: String }

    // PersonaModel v0.1.0 — NEW first-class primitive.
    // Lives at agents/<agent>/personas/<persona-slug>/persona.json.
    struct Persona: Equatable {
        let slug: PersonaSlug
        let owner: LinkRef<Agent>
        let compatHarnesses: [LinkRef<Harness>]  // which harnesses this persona can run on
    }

    // FormModel v0.X+1.0 — REFACTORED.
    // `ha` (embedded harness) REMOVED. `personaRef` ADDED.
    // Form is now a (model × overlay × persona) binding shape. Harness is
    // chosen at SESSION start, not baked into the form.
    struct Form: Equatable {
        let slug: FormSlug
        let modelRef: LinkRef<Model>
        let personaRef: LinkRef<Persona>    // NEW
        let owner: LinkRef<Agent>
    }
}

// ============================================================================
// Test 1 — CURRENT: the "loom" slug overloads three distinct entities.
// ============================================================================
// LOAD-BEARING: the `#expect` lines on Slug equality are CORRECT Swift but
// encode SEMANTIC nonsense — three entities at three ontological positions
// all named "loom". The type system does not flag this because Slug=String
// for every axis.

@Test("current design: 'loom' slug is type-identical across harness, form, and implicit persona")
func currentDesign_slugCollisionAcrossThreeAxes() {
    let loomHarness = CurrentDesign.Harness(slug: "loom")
    let loomForm = CurrentDesign.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        ownerAgent: .init(slug: "chatgpt")
    )

    // Persona is implicit — its name HAS to match the form because there's
    // nowhere else to put it. We model the absent third axis by reusing slug.
    let implicitLoomPersonaSlug: CurrentDesign.Slug = loomForm.slug

    // All three semantic positions compare freely:
    #expect(loomHarness.slug == loomForm.slug)
    #expect(loomForm.slug == implicitLoomPersonaSlug)
    #expect(loomHarness.slug == implicitLoomPersonaSlug)
    // Three different things; the types say they are the same thing.
}

// ============================================================================
// Test 2 — CURRENT: persona is not first-class addressable.
// ============================================================================
// LOAD-BEARING: no `CurrentDesign.Persona` type exists. The closest thing
// to "the loom persona" is the loom form. Asking "what voice does this
// form produce?" has no addressable answer — the form IS the answer.

@Test("current design: no Persona type — persona is entangled with form")
func currentDesign_personaUnaddressable() {
    let knownEntityTypes: [Any.Type] = [
        CurrentDesign.Agent.self,
        CurrentDesign.Harness.self,
        CurrentDesign.Form.self
        // No CurrentDesign.Persona.self — does not exist by design.
    ]
    let hasPersonaType = knownEntityTypes.contains {
        "\($0)".contains("Persona")
    }
    #expect(!hasPersonaType, "current design has no Persona type")

    // Consequence: the only way to ask "which persona is chatgpt-in-loom"
    // is to look up the form. The form-slug IS the persona surface.
    let loomForm = CurrentDesign.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        ownerAgent: .init(slug: "chatgpt")
    )
    let personaSurfaceName = loomForm.slug
    #expect(personaSurfaceName == loomForm.slug)
    // Persona and form share the same slug by construction.
}

// ============================================================================
// Test 3 — CURRENT: cross-binding placement is not expressible.
// ============================================================================
// LOAD-BEARING: you cannot say "run chatgpt in loom-harness wearing the
// codex persona" — because FormModel EMBEDS the harness reference and has
// NO persona field. The (harness, persona) tuple collapses to one form.

@Test("current design: cannot express 'chatgpt in loom-harness with codex persona'")
func currentDesign_crossBindingPlacementUnexpressible() {
    let chatgpt = CurrentDesign.Agent(slug: "chatgpt")
    let loomHarness = CurrentDesign.Harness(slug: "loom")
    let desiredPersonaName = "codex"

    // Option A: pick form-slug to match harness — persona becomes "loom".
    let formChoiceA = CurrentDesign.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/\(loomHarness.slug)"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        ownerAgent: chatgpt
    )
    let aHasRightHarness = formChoiceA.harnessRef.value.hasSuffix(loomHarness.slug)
    let aHasRightPersona = formChoiceA.slug == desiredPersonaName
    #expect(aHasRightHarness)
    #expect(!aHasRightPersona, "form A's implicit persona name is not 'codex'")

    // Option B: pick form-slug to match desired persona — harness gets forced
    // along with it because they share the form-slug convention.
    let formChoiceB = CurrentDesign.Form(
        slug: "codex",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/codex"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        ownerAgent: chatgpt
    )
    let bHasRightHarness = formChoiceB.harnessRef.value.hasSuffix(loomHarness.slug)
    let bHasRightPersona = formChoiceB.slug == desiredPersonaName
    #expect(!bHasRightHarness, "form B's harness ref is not 'loom'")
    #expect(bHasRightPersona)

    // The (harness=loom, persona=codex) combination is UNREACHABLE.
    // Persona and harness are entangled through the form-slug convention.
}

// ============================================================================
// Test 4 — NEW: cross-axis confusion no longer compiles.
// ============================================================================
// LOAD-BEARING: HarnessSlug, FormSlug, PersonaSlug are distinct types.
// A generic same-type comparison function rejects mismatched inputs at
// compile time. Runtime metatype check confirms the type distinction.

@Test("new design: phantom-typed slugs prevent cross-axis confusion at type level")
func newDesign_phantomTypedSlugsPreventCollision() {
    let loomHarness = ProposedDesign.HarnessSlug(raw: "loom")
    let loomForm = ProposedDesign.FormSlug(raw: "loom")
    let loomPersona = ProposedDesign.PersonaSlug(raw: "loom")

    // Raw strings collide — substrate vocabulary still reads "loom" in all three.
    #expect(loomHarness.raw == loomForm.raw)
    #expect(loomForm.raw == loomPersona.raw)

    // Typed metatypes are distinct:
    #expect("\(type(of: loomHarness))" != "\(type(of: loomForm))")
    #expect("\(type(of: loomForm))" != "\(type(of: loomPersona))")
    #expect("\(type(of: loomHarness))" != "\(type(of: loomPersona))")

    // Generic comparator accepts only same-type pairs:
    func sameAxisCompare<T: Equatable>(_ a: T, _ b: T) -> Bool { a == b }
    #expect(sameAxisCompare(loomHarness, loomHarness))
    #expect(sameAxisCompare(loomForm, loomForm))
    #expect(sameAxisCompare(loomPersona, loomPersona))
    // sameAxisCompare(loomHarness, loomForm)    // ⛔ compile-time rejection
    // sameAxisCompare(loomForm, loomPersona)    // ⛔ compile-time rejection
    // sameAxisCompare(loomHarness, loomPersona) // ⛔ compile-time rejection
}

// ============================================================================
// Test 5 — NEW: persona is first-class addressable.
// ============================================================================
// LOAD-BEARING: PersonaModel exists as its own type. Personas can be
// stored, queried, and reasoned about without going through FormModel.

@Test("new design: persona is first-class addressable independent of form")
func newDesign_personaIsFirstClass() {
    let chatgptRef = ProposedDesign.LinkRef<ProposedDesign.Agent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt"
    )
    let loomHarnessRef = ProposedDesign.LinkRef<ProposedDesign.Harness>(
        kind: "rp", root: "substrate", value: "harnesses/loom"
    )
    let codexHarnessRef = ProposedDesign.LinkRef<ProposedDesign.Harness>(
        kind: "rp", root: "substrate", value: "harnesses/codex"
    )

    // Build persona instances directly — no form required.
    let loomPersona = ProposedDesign.Persona(
        slug: .init(raw: "loom"),
        owner: chatgptRef,
        compatHarnesses: [loomHarnessRef]
    )
    let codexPersona = ProposedDesign.Persona(
        slug: .init(raw: "codex"),
        owner: chatgptRef,
        compatHarnesses: [codexHarnessRef, loomHarnessRef]
    )
    let chatgptPersona = ProposedDesign.Persona(
        slug: .init(raw: "chatgpt"),
        owner: chatgptRef,
        compatHarnesses: []
    )

    let chatgptPersonas = [loomPersona, codexPersona, chatgptPersona]

    // Query: "what personas does chatgpt carry?"
    let ownedByChatgpt = chatgptPersonas.filter { $0.owner == chatgptRef }
    #expect(ownedByChatgpt.count == 3)

    // Query: "which personas are loom-harness compatible?"
    let loomCompatible = chatgptPersonas.filter { $0.compatHarnesses.contains(loomHarnessRef) }
    #expect(loomCompatible.count == 2)
    #expect(loomCompatible.map(\.slug).contains(.init(raw: "loom")))
    #expect(loomCompatible.map(\.slug).contains(.init(raw: "codex")))
    #expect(!loomCompatible.map(\.slug).contains(.init(raw: "chatgpt")))

    // Query: "which personas are codex-harness compatible?"
    let codexCompatible = chatgptPersonas.filter { $0.compatHarnesses.contains(codexHarnessRef) }
    #expect(codexCompatible.count == 1)
    #expect(codexCompatible.first?.slug == .init(raw: "codex"))

    // These queries return typed-answer shapes — unrepresentable in current design.
}

// ============================================================================
// Test 6 — NEW: cross-binding placement IS expressible.
// ============================================================================
// LOAD-BEARING: (harness, persona) decouples. A session picks any
// (harness × persona) pair where persona declares harness-compat.
// (harness=loom, persona=codex) — the unreachable combination from
// Test 3 — is now a legal substrate session shape.

@Test("new design: cross-binding 'chatgpt in loom-harness with codex persona' is expressible")
func newDesign_crossBindingPlacementExpressible() {
    let chatgptRef = ProposedDesign.LinkRef<ProposedDesign.Agent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt"
    )
    let loomHarnessRef = ProposedDesign.LinkRef<ProposedDesign.Harness>(
        kind: "rp", root: "substrate", value: "harnesses/loom"
    )
    let codexHarnessRef = ProposedDesign.LinkRef<ProposedDesign.Harness>(
        kind: "rp", root: "substrate", value: "harnesses/codex"
    )

    // codex persona declares compat with BOTH codex AND loom harnesses.
    let codexPersona = ProposedDesign.Persona(
        slug: .init(raw: "codex"),
        owner: chatgptRef,
        compatHarnesses: [codexHarnessRef, loomHarnessRef]
    )

    let codexPersonaRef = ProposedDesign.LinkRef<ProposedDesign.Persona>(
        kind: "rp", root: "substrate", value: "agents/chatgpt/personas/codex"
    )

    // Form carries the codex persona — no harness embedded.
    let form = ProposedDesign.Form(
        slug: .init(raw: "codex"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        personaRef: codexPersonaRef,
        owner: chatgptRef
    )

    // Session: pick (form × harness) at start.
    struct Session {
        let form: ProposedDesign.Form
        let chosenHarness: ProposedDesign.LinkRef<ProposedDesign.Harness>
    }
    let session = Session(form: form, chosenHarness: loomHarnessRef)

    // Compatibility check at session-start:
    let harnessIsCompatible = codexPersona.compatHarnesses.contains(session.chosenHarness)
    #expect(harnessIsCompatible, "codex persona must declare compat with chosen loom-harness")

    // The persona's home and the harness's home are now SEPARATE substrate paths:
    #expect(form.personaRef.value == "agents/chatgpt/personas/codex")
    #expect(session.chosenHarness.value == "harnesses/loom")

    // (harness=loom, persona=codex) — UNREACHABLE in current design, LEGAL here.
}
