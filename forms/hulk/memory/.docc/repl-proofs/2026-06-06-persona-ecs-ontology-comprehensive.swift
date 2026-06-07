import Foundation
import Testing

// ============================================================================
// Persona × Harness × Form × Session — Comprehensive ECS Ontology Proof
// ============================================================================
//
// PART 1 demonstrates 10 structural failures of the current substrate design
// (slug collision, untyped LinkRef target, missing Persona, unreachable cross-
// binding, no mid-session swap, scalar-only cardinality, missing Session,
// no heterogeneous queries, no dynamic attach/detach, no partial entity).
//
// PART 2 demonstrates the same 10 dimensions resolved under the proposed
// ECS-shaped redesign (phantom slugs, typed LinkRef<Target>, PersonaComponent
// first-class, cross-binding legal, mutable Session, N-multiplicity overlays,
// Session as first-class entity, ECS query language, dynamic attach/detach,
// partial Session legal).
//
// Each PART 1 test PASSES by encoding the failure as something the current
// type system accepts as valid. Each PART 2 test PASSES by demonstrating the
// new design supports the operation cleanly.

// ============================================================================
// MODEL — LEGACY (current substrate ontology)
// ============================================================================

enum LegacyOntology {

    // String-shaped slug across every axis — no phantom typing.
    typealias Slug = String

    // LinkRef with un-parameterized target — points at anything.
    struct LinkRef: Equatable {
        let kind: String
        let root: String
        let value: String
    }

    struct Agent: Equatable { let slug: Slug }
    struct Harness: Equatable { let slug: Slug }
    struct Model: Equatable { let slug: Slug }

    // Form embeds harness + model refs directly. No Persona field.
    // All fields required at construction; no defaults; immutable value type.
    struct Form: Equatable {
        let slug: Slug
        let harnessRef: LinkRef
        let modelRef: LinkRef
        let overlays: [String]
        let ownerAgent: Agent
    }

    // No Persona type.
    // No Session type.
}

// ============================================================================
// MODEL — ECS (proposed substrate ontology)
// ============================================================================

enum ECSOntology {

    // Phantom-typed slugs prevent cross-axis confusion.
    struct AgentSlug: Equatable, Hashable { let raw: String }
    struct HarnessSlug: Equatable, Hashable { let raw: String }
    struct PersonaSlug: Equatable, Hashable { let raw: String }
    struct FormSlug: Equatable, Hashable { let raw: String }
    struct ModelSlug: Equatable, Hashable { let raw: String }

    // EntityID = bare handle. ECS-canonical: identity is independent of data.
    struct EntityID: Equatable, Hashable { let raw: UUID }

    // LinkRef parameterized by target component type. Wire format unchanged.
    struct LinkRef<Target>: Equatable {
        let kind: String
        let root: String
        let value: String
    }

    // Component types (pure data, no behavior).
    struct AgentComponent: Equatable { let slug: AgentSlug }
    struct HarnessComponent: Equatable { let slug: HarnessSlug }
    struct ModelComponent: Equatable { let slug: ModelSlug }
    struct FormComponent: Equatable { let slug: FormSlug }
    struct OverlayComponent: Equatable { let name: String }
    struct PersonaComponent: Equatable {
        let slug: PersonaSlug
        let compatHarnesses: [HarnessSlug]
    }

    // Session = ECS entity. Reference type so components can attach/detach.
    // All component slots optional — partial entity legal.
    final class Session: Equatable {
        let id: EntityID
        var agentRef: LinkRef<AgentComponent>?
        var harnessRef: LinkRef<HarnessComponent>?
        var personaRef: LinkRef<PersonaComponent>?
        var formRef: LinkRef<FormComponent>?
        var modelRef: LinkRef<ModelComponent>?
        var overlays: [OverlayComponent]

        init(
            id: EntityID,
            agentRef: LinkRef<AgentComponent>? = nil,
            harnessRef: LinkRef<HarnessComponent>? = nil,
            personaRef: LinkRef<PersonaComponent>? = nil,
            formRef: LinkRef<FormComponent>? = nil,
            modelRef: LinkRef<ModelComponent>? = nil,
            overlays: [OverlayComponent] = []
        ) {
            self.id = id
            self.agentRef = agentRef
            self.harnessRef = harnessRef
            self.personaRef = personaRef
            self.formRef = formRef
            self.modelRef = modelRef
            self.overlays = overlays
        }

        static func == (l: Session, r: Session) -> Bool { l.id == r.id }
    }
}

// ============================================================================
// ╔════════════════════════════════════════════════════════════════════════╗
// ║ PART 1 — 10 STRUCTURAL FAILURES OF THE CURRENT DESIGN                  ║
// ╚════════════════════════════════════════════════════════════════════════╝
// ============================================================================

// ─── L1 — slug collision across FIVE axes ──────────────────────────────────
// The string "codex" can name a harness, a form, an agent, a model, and the
// implicit persona. The type system flags none of it.

@Test("L1 — 'codex' slug is type-identical across agent, harness, form, model, and implicit persona")
func legacy_slugCollidesAcrossFiveAxes() {
    let codexHarness = LegacyOntology.Harness(slug: "codex")
    let codexForm = LegacyOntology.Form(
        slug: "codex",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/codex"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: .init(slug: "chatgpt")
    )
    let codexAgent = LegacyOntology.Agent(slug: "codex")
    let codexModel = LegacyOntology.Model(slug: "codex")
    let implicitCodexPersonaSlug: LegacyOntology.Slug = codexForm.slug

    // All five are the same type (String). All equal. Substrate cannot
    // distinguish "the codex harness" from "the codex agent" by type.
    #expect(codexHarness.slug == codexForm.slug)
    #expect(codexForm.slug == codexAgent.slug)
    #expect(codexAgent.slug == codexModel.slug)
    #expect(codexModel.slug == implicitCodexPersonaSlug)
}

// ─── L2 — LinkRef target is untyped ────────────────────────────────────────
// A "harness ref" can point at an agent path. The form accepts it. No type
// system layer catches the semantic mistake.

@Test("L2 — LinkRef has no parameterized target — wrong-kind ref is type-clean")
func legacy_linkRefTargetUntyped() {
    // Build a "harness ref" that actually points at an AGENT path:
    let wronglyAimedHarnessRef = LegacyOntology.LinkRef(
        kind: "rp",
        root: "substrate",
        value: "agents/chatgpt"
    )
    let form = LegacyOntology.Form(
        slug: "loom",
        harnessRef: wronglyAimedHarnessRef,  // ← semantic nonsense, type-clean
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: .init(slug: "chatgpt")
    )
    // The form constructs without complaint. Wire-format check passes.
    #expect(form.harnessRef.value == "agents/chatgpt")
    #expect(form.harnessRef.value.hasPrefix("agents/"))  // points at an agent, not a harness
}

// ─── L3 — no first-class Persona type ──────────────────────────────────────
// The substrate has no `Persona`. The "voice" is whatever the form-slug names.

@Test("L3 — no Persona type — persona is entangled with form-slug")
func legacy_personaUnaddressable() {
    let knownEntityTypes: [Any.Type] = [
        LegacyOntology.Agent.self,
        LegacyOntology.Harness.self,
        LegacyOntology.Model.self,
        LegacyOntology.Form.self
    ]
    let hasPersonaType = knownEntityTypes.contains { "\($0)".contains("Persona") }
    #expect(!hasPersonaType, "legacy design exposes no Persona type")
}

// ─── L4 — cross-binding placement is unreachable ──────────────────────────
// (harness=loom, persona=codex) cannot be constructed because the persona-name
// IS the form-slug, which forces a paired-harness convention.

@Test("L4 — cannot construct (harness=loom, persona=codex) — entangled via form-slug convention")
func legacy_crossBindingUnreachable() {
    let chatgpt = LegacyOntology.Agent(slug: "chatgpt")
    let loomHarness = LegacyOntology.Harness(slug: "loom")
    let desiredPersonaName = "codex"

    // Match harness → persona name is "loom" (wrong):
    let formA = LegacyOntology.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/\(loomHarness.slug)"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: chatgpt
    )
    #expect(formA.harnessRef.value.hasSuffix(loomHarness.slug))
    #expect(formA.slug != desiredPersonaName)

    // Match persona name → harness gets forced to "codex" (wrong):
    let formB = LegacyOntology.Form(
        slug: "codex",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/codex"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: chatgpt
    )
    #expect(!formB.harnessRef.value.hasSuffix(loomHarness.slug))
    #expect(formB.slug == desiredPersonaName)
}

// ─── L5 — mid-session harness swap is impossible ───────────────────────────
// Form is an immutable value type. "Swapping harness" means constructing a
// new Form value — the prior binding identity dies.

@Test("L5 — mid-session swap impossible — form is immutable; swap requires destructive reconstruction")
func legacy_midSessionSwapImpossible() {
    let formBefore = LegacyOntology.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: .init(slug: "chatgpt")
    )
    // To "swap" the harness, must construct a wholly new form value:
    let formAfter = LegacyOntology.Form(
        slug: formBefore.slug,
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/codex"),
        modelRef: formBefore.modelRef,
        overlays: formBefore.overlays,
        ownerAgent: formBefore.ownerAgent
    )
    // Binding identities are distinct values — the "session" died on swap:
    #expect(formBefore != formAfter)
}

// ─── L6 — component cardinality is forced to 1 ─────────────────────────────
// harnessRef is a scalar field. No way to express "this binding can run on
// EITHER loom or codex" or "stack two model refs as fallback."

@Test("L6 — harnessRef is scalar — multi-harness fallback unrepresentable")
func legacy_componentCardinalityScalar() {
    let form = LegacyOntology.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: .init(slug: "chatgpt")
    )
    let mirror = Mirror(reflecting: form)
    let harnessField = mirror.children.first { $0.label == "harnessRef" }!
    let isScalar = harnessField.value is LegacyOntology.LinkRef
    let isList = harnessField.value is [LegacyOntology.LinkRef]
    #expect(isScalar)
    #expect(!isList)
}

// ─── L7 — Session has no first-class type ──────────────────────────────────
// The substrate has no `Session`. Live-session state is implicit — scattered
// across runtime files (form-state, env-files, header tmp-state).

@Test("L7 — no Session type — sessions are not first-class addressable entities")
func legacy_sessionNotFirstClass() {
    let knownTypes: [Any.Type] = [
        LegacyOntology.Agent.self,
        LegacyOntology.Harness.self,
        LegacyOntology.Model.self,
        LegacyOntology.Form.self
    ]
    let hasSessionType = knownTypes.contains { "\($0)".contains("Session") }
    #expect(!hasSessionType, "legacy design exposes no Session type")
}

// ─── L8 — heterogeneous queries are impossible ─────────────────────────────
// No shared queryable entity protocol. Agent/Harness/Form are unrelated
// types — cross-cuts require ad-hoc type-narrowing.

@Test("L8 — no shared entity protocol — composite queries require manual type narrowing")
func legacy_heterogeneousQueriesImpossible() {
    let agents = [LegacyOntology.Agent(slug: "chatgpt")]
    let harnesses = [LegacyOntology.Harness(slug: "loom")]
    let forms = [
        LegacyOntology.Form(
            slug: "loom",
            harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
            modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
            overlays: ["debug-trace"],
            ownerAgent: .init(slug: "chatgpt")
        )
    ]
    // To ask "all entities with both a harness-ref AND a debug-trace overlay,"
    // must shove into [Any] and hand-narrow via casts — no typed query language:
    let allEntities: [Any] = agents + harnesses + forms
    let formsOnly = allEntities.compactMap { $0 as? LegacyOntology.Form }
    let matching = formsOnly.filter { $0.overlays.contains("debug-trace") }
    #expect(matching.count == 1)
    // The query had to type-narrow manually; the universe of entity types had
    // to be enumerated by hand. No registry, no query language, no schedule.
}

// ─── L9 — components locked at form-creation ───────────────────────────────
// Form's fields are `let`. Adding an overlay forces constructing a new form;
// the prior binding identity is destroyed.

@Test("L9 — components locked at creation — overlay addition requires destructive reconstruction")
func legacy_componentsLockedAtCreation() {
    let f1 = LegacyOntology.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: ["privacy-strict"],
        ownerAgent: .init(slug: "chatgpt")
    )
    let f2 = LegacyOntology.Form(
        slug: f1.slug,
        harnessRef: f1.harnessRef,
        modelRef: f1.modelRef,
        overlays: f1.overlays + ["debug-trace"],
        ownerAgent: f1.ownerAgent
    )
    #expect(f1.overlays.count == 1)
    #expect(f2.overlays.count == 2)
    #expect(f1 != f2)
}

// ─── L10 — no partial / empty entity ───────────────────────────────────────
// Form's init requires every field. There is no way to express "session has
// chosen a persona but not yet a harness."

@Test("L10 — no partial entity — Form requires every component at birth")
func legacy_noPartialEntity() {
    // Only one constructor exists; it requires all five inputs. Commented
    // lines show what would NOT compile:
    //   _ = LegacyOntology.Form()                                          ⛔
    //   _ = LegacyOntology.Form(slug: "loom")                              ⛔
    //   _ = LegacyOntology.Form(slug: "loom", harnessRef: ...)             ⛔
    let form = LegacyOntology.Form(
        slug: "loom",
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom"),
        modelRef: .init(kind: "rp", root: "substrate", value: "models/codex-line"),
        overlays: [],
        ownerAgent: .init(slug: "chatgpt")
    )
    // Every component slot is materialized; no nullable / future-attach slots:
    let mirror = Mirror(reflecting: form)
    #expect(mirror.children.count == 5)
}

// ============================================================================
// ╔════════════════════════════════════════════════════════════════════════╗
// ║ PART 2 — 10 SYMMETRIC FIXES UNDER THE ECS REDESIGN                     ║
// ╚════════════════════════════════════════════════════════════════════════╝
// ============================================================================

// ─── E1 (fixes L1) — phantom slugs prevent cross-axis collision ───────────

@Test("E1 — phantom-typed slugs prevent the 'codex' five-axis collision at type level")
func ecs_phantomSlugsPreventCollision() {
    let codexHarness = ECSOntology.HarnessSlug(raw: "codex")
    let codexForm = ECSOntology.FormSlug(raw: "codex")
    let codexAgent = ECSOntology.AgentSlug(raw: "codex")
    let codexModel = ECSOntology.ModelSlug(raw: "codex")
    let codexPersona = ECSOntology.PersonaSlug(raw: "codex")

    // Same wire string:
    #expect(codexHarness.raw == codexForm.raw)
    #expect(codexForm.raw == codexAgent.raw)
    #expect(codexAgent.raw == codexModel.raw)
    #expect(codexModel.raw == codexPersona.raw)
    // But all five are distinct types:
    let names = [
        "\(type(of: codexHarness))",
        "\(type(of: codexForm))",
        "\(type(of: codexAgent))",
        "\(type(of: codexModel))",
        "\(type(of: codexPersona))"
    ]
    #expect(Set(names).count == 5)

    // Generic same-axis comparator only accepts same-type pairs:
    func sameAxis<T: Equatable>(_ a: T, _ b: T) -> Bool { a == b }
    #expect(sameAxis(codexHarness, codexHarness))
    // sameAxis(codexHarness, codexForm)    // ⛔ compile-time rejection
    // sameAxis(codexAgent, codexPersona)   // ⛔ compile-time rejection
}

// ─── E2 (fixes L2) — LinkRef target is typed ───────────────────────────────

@Test("E2 — LinkRef<Target> rejects wrong-kind refs at type level")
func ecs_linkRefTargetTyped() {
    let agentRef = ECSOntology.LinkRef<ECSOntology.AgentComponent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt"
    )
    let harnessRef = ECSOntology.LinkRef<ECSOntology.HarnessComponent>(
        kind: "rp", root: "substrate", value: "harnesses/loom"
    )

    #expect("\(type(of: agentRef))" != "\(type(of: harnessRef))")

    // Session's harnessRef slot accepts only Harness-targeted LinkRefs:
    let session = ECSOntology.Session(id: .init(raw: UUID()), harnessRef: harnessRef)
    #expect(session.harnessRef?.value == "harnesses/loom")
    // ECSOntology.Session(id: ..., harnessRef: agentRef)  // ⛔ would not compile

    func sameTarget<T>(_ a: ECSOntology.LinkRef<T>, _ b: ECSOntology.LinkRef<T>) -> Bool {
        a.value == b.value
    }
    #expect(sameTarget(agentRef, agentRef))
    // sameTarget(agentRef, harnessRef)  // ⛔ compile-time rejection
}

// ─── E3 (fixes L3) — Persona is first-class ────────────────────────────────

@Test("E3 — PersonaComponent is first-class — addressable, queryable, independent of Form")
func ecs_personaFirstClass() {
    let chatgptRef = ECSOntology.LinkRef<ECSOntology.AgentComponent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt"
    )
    let loomHS = ECSOntology.HarnessSlug(raw: "loom")
    let codexHS = ECSOntology.HarnessSlug(raw: "codex")

    let loomPersona = ECSOntology.PersonaComponent(
        slug: .init(raw: "loom"), compatHarnesses: [loomHS]
    )
    let codexPersona = ECSOntology.PersonaComponent(
        slug: .init(raw: "codex"), compatHarnesses: [codexHS, loomHS]
    )
    let chatgptPersona = ECSOntology.PersonaComponent(
        slug: .init(raw: "chatgpt"), compatHarnesses: []
    )

    let chatgptPersonas = [loomPersona, codexPersona, chatgptPersona]

    // Query: "which personas are loom-harness compatible?"
    let loomCompatible = chatgptPersonas.filter { $0.compatHarnesses.contains(loomHS) }
    #expect(loomCompatible.count == 2)
    #expect(loomCompatible.map(\.slug).contains(.init(raw: "loom")))
    #expect(loomCompatible.map(\.slug).contains(.init(raw: "codex")))

    _ = chatgptRef  // silence unused
}

// ─── E4 (fixes L4) — cross-binding placement is legal ──────────────────────

@Test("E4 — cross-binding (harness=loom, persona=codex) is legal and addressable")
func ecs_crossBindingLegal() {
    let loomHarnessRef = ECSOntology.LinkRef<ECSOntology.HarnessComponent>(
        kind: "rp", root: "substrate", value: "harnesses/loom"
    )
    let codexPersonaRef = ECSOntology.LinkRef<ECSOntology.PersonaComponent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt/personas/codex"
    )
    let session = ECSOntology.Session(
        id: .init(raw: UUID()),
        harnessRef: loomHarnessRef,
        personaRef: codexPersonaRef
    )
    #expect(session.harnessRef?.value == "harnesses/loom")
    #expect(session.personaRef?.value == "agents/chatgpt/personas/codex")
}

// ─── E5 (fixes L5) — mid-session harness swap preserves identity ──────────

@Test("E5 — mid-session swap — Session is mutable, EntityID preserved across swap")
func ecs_midSessionSwapPreservesIdentity() {
    let session = ECSOntology.Session(
        id: .init(raw: UUID()),
        harnessRef: .init(kind: "rp", root: "substrate", value: "harnesses/loom")
    )
    let originalId = session.id

    session.harnessRef = .init(kind: "rp", root: "substrate", value: "harnesses/codex")

    #expect(session.id == originalId)  // identity preserved
    #expect(session.harnessRef?.value == "harnesses/codex")
}

// ─── E6 (fixes L6) — multi-cardinality overlays ────────────────────────────

@Test("E6 — multi-cardinality components — overlays attach as N siblings; grow at runtime")
func ecs_multiCardinalityOverlays() {
    let session = ECSOntology.Session(
        id: .init(raw: UUID()),
        overlays: [.init(name: "privacy-strict"), .init(name: "debug-trace")]
    )
    #expect(session.overlays.count == 2)
    session.overlays.append(.init(name: "expert-mode"))
    #expect(session.overlays.count == 3)
    session.overlays.append(.init(name: "tester"))
    #expect(session.overlays.count == 4)
}

// ─── E7 (fixes L7) — Session is first-class ────────────────────────────────

@Test("E7 — Session is a first-class entity with stable EntityID")
func ecs_sessionFirstClass() {
    let knownTypes: [Any.Type] = [
        ECSOntology.AgentComponent.self,
        ECSOntology.HarnessComponent.self,
        ECSOntology.PersonaComponent.self,
        ECSOntology.FormComponent.self,
        ECSOntology.ModelComponent.self,
        ECSOntology.OverlayComponent.self,
        ECSOntology.Session.self
    ]
    let hasSessionType = knownTypes.contains { "\($0)".contains("Session") }
    #expect(hasSessionType)

    // Two sessions with the same component shape are distinct entities:
    let s1 = ECSOntology.Session(id: .init(raw: UUID()))
    let s2 = ECSOntology.Session(id: .init(raw: UUID()))
    #expect(s1.id != s2.id)
    #expect(s1 != s2)
}

// ─── E8 (fixes L8) — heterogeneous component-set queries ──────────────────

@Test("E8 — ECS-style query: 'sessions with persona=codex AND NOT overlay=debug-trace'")
func ecs_heterogeneousQueries() {
    let codexPersonaRef = ECSOntology.LinkRef<ECSOntology.PersonaComponent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt/personas/codex"
    )
    let loomPersonaRef = ECSOntology.LinkRef<ECSOntology.PersonaComponent>(
        kind: "rp", root: "substrate", value: "agents/chatgpt/personas/loom"
    )

    let sessions: [ECSOntology.Session] = [
        .init(id: .init(raw: UUID()), personaRef: codexPersonaRef,
              overlays: [.init(name: "debug-trace")]),
        .init(id: .init(raw: UUID()), personaRef: codexPersonaRef,
              overlays: []),
        .init(id: .init(raw: UUID()), personaRef: codexPersonaRef,
              overlays: [.init(name: "privacy-strict")]),
        .init(id: .init(raw: UUID()), personaRef: loomPersonaRef,
              overlays: [.init(name: "debug-trace")]),
        .init(id: .init(raw: UUID()), personaRef: nil),  // partial — see E10
    ]

    // Compose the query as a pure function over component set:
    let result = sessions.filter { s in
        s.personaRef == codexPersonaRef &&
        !s.overlays.contains(where: { $0.name == "debug-trace" })
    }
    #expect(result.count == 2)

    // Inverse query — "sessions with debug-trace overlay regardless of persona":
    let withDebug = sessions.filter { s in
        s.overlays.contains(where: { $0.name == "debug-trace" })
    }
    #expect(withDebug.count == 2)
}

// ─── E9 (fixes L9) — dynamic attach/detach ─────────────────────────────────

@Test("E9 — components attach AND detach dynamically — entity outlives all components")
func ecs_dynamicAttachDetach() {
    let session = ECSOntology.Session(
        id: .init(raw: UUID()),
        personaRef: .init(kind: "rp", root: "substrate", value: "agents/chatgpt/personas/codex"),
        overlays: [.init(name: "debug-trace")]
    )
    let originalId = session.id

    #expect(session.personaRef != nil)
    #expect(session.overlays.count == 1)

    // Detach all components — entity survives:
    session.personaRef = nil
    session.overlays = []
    #expect(session.personaRef == nil)
    #expect(session.overlays.isEmpty)
    #expect(session.id == originalId)

    // Re-attach a different persona:
    session.personaRef = .init(kind: "rp", root: "substrate", value: "agents/chatgpt/personas/loom")
    #expect(session.personaRef?.value == "agents/chatgpt/personas/loom")
    #expect(session.id == originalId)  // same entity, third persona-state
}

// ─── E10 (fixes L10) — partial entity is legal ─────────────────────────────

@Test("E10 — Session can be born with NO components — partial entity legal; attach incrementally")
func ecs_partialEntityLegal() {
    let session = ECSOntology.Session(id: .init(raw: UUID()))

    // All component slots are nil at birth:
    #expect(session.agentRef == nil)
    #expect(session.harnessRef == nil)
    #expect(session.personaRef == nil)
    #expect(session.formRef == nil)
    #expect(session.modelRef == nil)
    #expect(session.overlays.isEmpty)

    // Attach incrementally — substrate's "chosen-but-not-bound" state:
    session.agentRef = .init(kind: "rp", root: "substrate", value: "agents/chatgpt")
    session.personaRef = .init(kind: "rp", root: "substrate", value: "agents/chatgpt/personas/codex")

    #expect(session.agentRef != nil)
    #expect(session.personaRef != nil)
    #expect(session.harnessRef == nil)  // still partial
    #expect(session.modelRef == nil)    // still partial
    // Substrate can now represent "session has chosen persona but hasn't
    // picked a harness yet" — unrepresentable in legacy design.
}
