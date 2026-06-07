import Foundation
import Testing

// ============================================================================
// Persona 6 INTERNATIONAL — P5R Mechanics as Typed Substrate ECS Systems
// ============================================================================
//
// Following the captured axiom substrate-is-game-shaped-across-three-framings
// (2026-06-06), this proof corpus models the major P5 Royal mechanics as
// substrate-typed ECS systems and proves that each composes cleanly against
// the substrate's component model.
//
// Each @Test takes a substrate-typed component set, runs a P5R-mechanic
// system against it, and asserts the typed output shape. Tests prove
// mechanic-as-substrate-primitive parity — not P5R replication.

// ============================================================================
// MODEL — Substrate ECS components, shared with comprehensive proof
// ============================================================================

enum Substrate {

    // Phantom-typed slugs
    struct AgentSlug: Equatable, Hashable { let raw: String }
    struct HarnessSlug: Equatable, Hashable { let raw: String }
    struct PersonaSlug: Equatable, Hashable { let raw: String }
    struct ArcanaSlug: Equatable, Hashable { let raw: String }

    enum Arcana: String, CaseIterable {
        case fool = "Fool"
        case magician = "Magician"
        case priestess = "Priestess"
        case empress = "Empress"
        case emperor = "Emperor"
        case hierophant = "Hierophant"
        case lovers = "Lovers"
        case chariot = "Chariot"
        case justice = "Justice"
        case hermit = "Hermit"
        case fortune = "Fortune"
        case strength = "Strength"
        case hangedMan = "Hanged Man"
        case death = "Death"
        case temperance = "Temperance"
        case devil = "Devil"
        case tower = "Tower"
        case star = "Star"
        case moon = "Moon"
        case sun = "Sun"
        case judgement = "Judgement"
        case world = "World"
    }

    // Component types
    struct ConfidantComponent: Equatable {
        let agentSlug: AgentSlug
        let arcana: Arcana
        var rank: Int                          // 0..10 (P5R Confidant rank)
        var chronicleEntryCount: Int           // accumulated relatedChronicleEntry refs
    }

    struct PersonaComponent: Equatable {
        let slug: PersonaSlug
        let owningAgent: AgentSlug
        let compatHarnesses: [HarnessSlug]
        let voiceProfileRef: String            // LinkRef value (typed in v0.4)
    }

    struct PalaceComponent: Equatable {
        let slug: String                       // kura-space slug
        let theme: String                      // territory the Palace represents
        let target: String                     // cognitive distortion addressed
        var treasureExtracted: Bool            // /capture run produced typed record
    }

    struct CallingCardComponent: Equatable {
        let intent: String                     // commit-intent message
        let emittedAt: String                  // ISO timestamp
        var executed: Bool
    }

    struct CalendarComponent: Equatable {
        let dayKey: String                     // YYYY-MM-DD
        let budgetTotal: Int                   // token budget for the day
        var budgetSpent: Int
        var beats: [String]                    // working-beats entries
    }

    struct CascadeWorkstreamComponent: Equatable {
        let id: UUID
        var stagesCompleted: Int
        let totalStages: Int
        var allOutAttackTriggered: Bool        // true when stages all done
    }

    struct VelvetRoomCompositeComponent: Equatable {
        let parentPersonaA: PersonaSlug
        let parentPersonaB: PersonaSlug
        let fusedPersona: PersonaSlug
        let inheritedCompatHarnesses: [HarnessSlug]
    }

    struct ThievesDenComponent: Equatable {
        var collectedReceipts: [String]        // typed-record IDs captured
        var awakeningMoments: [PersonaSlug]    // /capture promotions logged
    }
}

// ============================================================================
// SYSTEMS — P5R mechanics implemented as substrate ECS query+behavior functions
// ============================================================================

enum P6System {

    // Confidant rank-up: given current rank + new chronicle entries, compute
    // the new rank. P5R caps at 10. Threshold: every 3 entries grants 1 rank.
    static func rankUpConfidant(
        _ confidant: inout Substrate.ConfidantComponent,
        newEntries: Int
    ) {
        confidant.chronicleEntryCount += newEntries
        let earnedRanks = confidant.chronicleEntryCount / 3
        confidant.rank = min(10, earnedRanks)
    }

    // Palace heist: take a Palace + Calling Card. If Calling Card was emitted
    // before the heist, the treasure is extracted (typed-record produced).
    static func palaceHeist(
        palace: inout Substrate.PalaceComponent,
        callingCard: Substrate.CallingCardComponent
    ) -> Bool {
        guard !callingCard.intent.isEmpty else { return false }
        palace.treasureExtracted = true
        return true
    }

    // Velvet Room fusion: take two PersonaComponents, emit a fused
    // composite. Inheritance: union of compatHarnesses.
    static func velvetRoomFuse(
        _ a: Substrate.PersonaComponent,
        _ b: Substrate.PersonaComponent,
        fusedSlug: Substrate.PersonaSlug
    ) -> Substrate.VelvetRoomCompositeComponent {
        let union = Array(Set(a.compatHarnesses + b.compatHarnesses))
        return .init(
            parentPersonaA: a.slug,
            parentPersonaB: b.slug,
            fusedPersona: fusedSlug,
            inheritedCompatHarnesses: union
        )
    }

    // Calendar tick: advance budget spent + record a new beat.
    static func calendarTick(
        _ calendar: inout Substrate.CalendarComponent,
        spend: Int,
        beat: String
    ) {
        calendar.budgetSpent += spend
        calendar.beats.append(beat)
    }

    // All-Out Attack: cascade workstream stage complete. When all stages done,
    // trigger the All-Out Attack splash.
    static func cascadeStageComplete(
        _ workstream: inout Substrate.CascadeWorkstreamComponent
    ) {
        workstream.stagesCompleted += 1
        if workstream.stagesCompleted == workstream.totalStages {
            workstream.allOutAttackTriggered = true
        }
    }

    // I Am Thou: a new persona awakens. Log to Thieves' Den.
    static func iAmThouAwakening(
        _ den: inout Substrate.ThievesDenComponent,
        persona: Substrate.PersonaSlug
    ) {
        den.awakeningMoments.append(persona)
    }

    // Showtime: pair two Confidants for a Showtime attack. Requires both
    // confidants at rank >= 4 (substrate's typed gate for paired-agent moves).
    static func showtimeEligible(
        _ a: Substrate.ConfidantComponent,
        _ b: Substrate.ConfidantComponent
    ) -> Bool {
        a.rank >= 4 && b.rank >= 4 && a.agentSlug != b.agentSlug
    }

    // Calling Card emit: create a typed CallingCardComponent. Substrate's
    // savepoint pattern at the type layer.
    static func emitCallingCard(
        intent: String,
        timestamp: String
    ) -> Substrate.CallingCardComponent {
        .init(intent: intent, emittedAt: timestamp, executed: false)
    }
}

// ============================================================================
// TESTS — substrate ECS components composed under P5R mechanic systems
// ============================================================================

// ─── M1 — Confidant rank-up advances on chronicle accumulation ────────────

@Test("M1 — Confidant rank-up system: 3 chronicle entries → 1 rank, cap at 10")
func mechanic_confidantRankUp() {
    var claude = Substrate.ConfidantComponent(
        agentSlug: .init(raw: "claude"),
        arcana: .magician,
        rank: 0,
        chronicleEntryCount: 0
    )
    P6System.rankUpConfidant(&claude, newEntries: 3)
    #expect(claude.rank == 1)
    P6System.rankUpConfidant(&claude, newEntries: 6)
    #expect(claude.rank == 3)
    P6System.rankUpConfidant(&claude, newEntries: 100)
    #expect(claude.rank == 10)  // cap holds
}

// ─── M2 — Palace heist requires a Calling Card ────────────────────────────

@Test("M2 — Palace heist system: Calling Card prerequisite enforced")
func mechanic_palaceHeistRequiresCallingCard() {
    var axiomsPalace = Substrate.PalaceComponent(
        slug: "axioms",
        theme: "substrate doctrine",
        target: "doctrinal drift",
        treasureExtracted: false
    )
    // No Calling Card → heist refused:
    let emptyCard = Substrate.CallingCardComponent(intent: "", emittedAt: "", executed: false)
    let heistBlocked = P6System.palaceHeist(palace: &axiomsPalace, callingCard: emptyCard)
    #expect(!heistBlocked)
    #expect(!axiomsPalace.treasureExtracted)

    // With Calling Card → heist succeeds, treasure extracted:
    let card = P6System.emitCallingCard(
        intent: "capture substrate-is-game-shaped-across-three-framings axiom",
        timestamp: "2026-06-06T18:30:00Z"
    )
    let heistOk = P6System.palaceHeist(palace: &axiomsPalace, callingCard: card)
    #expect(heistOk)
    #expect(axiomsPalace.treasureExtracted)
}

// ─── M3 — Velvet Room fusion unions compatHarnesses ───────────────────────

@Test("M3 — Velvet Room fusion: composite inherits union of parent compat sets")
func mechanic_velvetRoomFusionUnion() {
    let codexPersona = Substrate.PersonaComponent(
        slug: .init(raw: "codex"),
        owningAgent: .init(raw: "chatgpt"),
        compatHarnesses: [.init(raw: "codex"), .init(raw: "loom")],
        voiceProfileRef: "agents/chatgpt/personas/codex/voice.json"
    )
    let claudePersona = Substrate.PersonaComponent(
        slug: .init(raw: "claude-helpful"),
        owningAgent: .init(raw: "claude"),
        compatHarnesses: [.init(raw: "hulk"), .init(raw: "codex")],
        voiceProfileRef: "agents/claude/personas/helpful/voice.json"
    )
    let fused = P6System.velvetRoomFuse(
        codexPersona,
        claudePersona,
        fusedSlug: .init(raw: "codex-claude-hybrid")
    )
    let set = Set(fused.inheritedCompatHarnesses)
    #expect(set.count == 3)
    #expect(set.contains(.init(raw: "codex")))
    #expect(set.contains(.init(raw: "loom")))
    #expect(set.contains(.init(raw: "hulk")))
}

// ─── M4 — Calendar tick advances budget + beats ───────────────────────────

@Test("M4 — Calendar system: tick advances budgetSpent and appends beat")
func mechanic_calendarTick() {
    var day = Substrate.CalendarComponent(
        dayKey: "2026-06-06",
        budgetTotal: 100_000,
        budgetSpent: 0,
        beats: []
    )
    P6System.calendarTick(&day, spend: 5_000, beat: "loom-cycle-symlink-fix")
    P6System.calendarTick(&day, spend: 8_000, beat: "ldt-ontology-proof-26-tests")
    P6System.calendarTick(&day, spend: 12_000, beat: "p6-international-vision-packet")
    #expect(day.budgetSpent == 25_000)
    #expect(day.beats.count == 3)
    #expect(day.beats.last == "p6-international-vision-packet")
    #expect(day.budgetTotal - day.budgetSpent == 75_000)
}

// ─── M5 — All-Out Attack triggers when all cascade stages complete ────────

@Test("M5 — All-Out Attack triggers when cascade stagesCompleted == totalStages")
func mechanic_allOutAttackOnCascadeCompletion() {
    var cascade = Substrate.CascadeWorkstreamComponent(
        id: UUID(),
        stagesCompleted: 0,
        totalStages: 4,
        allOutAttackTriggered: false
    )
    for _ in 0..<3 {
        P6System.cascadeStageComplete(&cascade)
    }
    #expect(!cascade.allOutAttackTriggered)

    P6System.cascadeStageComplete(&cascade)
    #expect(cascade.allOutAttackTriggered)
    #expect(cascade.stagesCompleted == cascade.totalStages)
}

// ─── M6 — "I Am Thou" awakening logs to Thieves' Den ──────────────────────

@Test("M6 — Awakening system logs new persona to Thieves' Den")
func mechanic_awakeningLogged() {
    var den = Substrate.ThievesDenComponent(
        collectedReceipts: [],
        awakeningMoments: []
    )
    P6System.iAmThouAwakening(&den, persona: .init(raw: "loom"))
    P6System.iAmThouAwakening(&den, persona: .init(raw: "codex"))
    P6System.iAmThouAwakening(&den, persona: .init(raw: "chatgpt"))
    #expect(den.awakeningMoments.count == 3)
    #expect(den.awakeningMoments.contains(.init(raw: "loom")))
    #expect(den.awakeningMoments.contains(.init(raw: "codex")))
    #expect(den.awakeningMoments.contains(.init(raw: "chatgpt")))
}

// ─── M7 — Showtime paired-attack eligibility gate ─────────────────────────

@Test("M7 — Showtime requires both Confidants at rank >= 4 and distinct agents")
func mechanic_showtimeEligibility() {
    let claude4 = Substrate.ConfidantComponent(
        agentSlug: .init(raw: "claude"),
        arcana: .magician,
        rank: 4,
        chronicleEntryCount: 12
    )
    let carrie4 = Substrate.ConfidantComponent(
        agentSlug: .init(raw: "carrie"),
        arcana: .lovers,
        rank: 4,
        chronicleEntryCount: 12
    )
    let claude3 = Substrate.ConfidantComponent(
        agentSlug: .init(raw: "claude"),
        arcana: .magician,
        rank: 3,
        chronicleEntryCount: 9
    )
    // Eligible: distinct agents, both >= rank 4
    #expect(P6System.showtimeEligible(claude4, carrie4))
    // Ineligible: same agent (self-pair forbidden)
    #expect(!P6System.showtimeEligible(claude4, claude4))
    // Ineligible: one Confidant below rank 4
    #expect(!P6System.showtimeEligible(claude3, carrie4))
}

// ─── M8 — Full session arc composes M1..M7 cleanly ────────────────────────

@Test("M8 — Full P6R session arc: rank up → emit Calling Card → heist Palace → All-Out Attack → awakening")
func mechanic_fullSessionArc() {
    // 1. Operator works with claude through the day → claude ranks up
    var claude = Substrate.ConfidantComponent(
        agentSlug: .init(raw: "claude"),
        arcana: .magician,
        rank: 3,
        chronicleEntryCount: 9
    )
    P6System.rankUpConfidant(&claude, newEntries: 6)
    #expect(claude.rank == 5)

    // 2. Calendar tick records the work
    var day = Substrate.CalendarComponent(
        dayKey: "2026-06-06",
        budgetTotal: 100_000,
        budgetSpent: 0,
        beats: []
    )
    P6System.calendarTick(&day, spend: 25_000, beat: "p6-international-vision")
    #expect(day.beats.count == 1)

    // 3. Operator emits a Calling Card for the axiom capture
    let card = P6System.emitCallingCard(
        intent: "capture substrate-is-game-shaped axiom",
        timestamp: "2026-06-06T18:30:00Z"
    )

    // 4. Heist the axioms Palace → treasure extracted
    var palace = Substrate.PalaceComponent(
        slug: "axioms",
        theme: "substrate doctrine",
        target: "doctrinal drift",
        treasureExtracted: false
    )
    let heistOk = P6System.palaceHeist(palace: &palace, callingCard: card)
    #expect(heistOk)
    #expect(palace.treasureExtracted)

    // 5. Cascade workstream completes → All-Out Attack fires
    var cascade = Substrate.CascadeWorkstreamComponent(
        id: UUID(),
        stagesCompleted: 0,
        totalStages: 3,
        allOutAttackTriggered: false
    )
    for _ in 0..<3 { P6System.cascadeStageComplete(&cascade) }
    #expect(cascade.allOutAttackTriggered)

    // 6. New persona awakens → Thieves' Den logged
    var den = Substrate.ThievesDenComponent(
        collectedReceipts: [],
        awakeningMoments: []
    )
    P6System.iAmThouAwakening(&den, persona: .init(raw: "substrate-is-game-shaped"))
    #expect(den.awakeningMoments.count == 1)

    // The substrate's full P6R-mechanic arc composed as typed ECS systems — green.
}
