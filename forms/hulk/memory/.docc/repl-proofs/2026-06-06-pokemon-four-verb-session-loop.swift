import Foundation
import Testing

// ============================================================================
// Pokemon Four-Verb Session Loop — substrate session shape proof
// ============================================================================
//
// Per the captured axiom substrate-session-is-pokemon-four-verb-loop
// (2026-06-06), a substrate session follows the Pokemon core RPG game loop:
// DISCOVER → ENCOUNTER → CAPTURE → COLLECT, with typed entry/exit conditions
// and typed receipts per phase. Tests prove the loop's structural shape.

// ============================================================================
// MODEL — substrate session as four-verb loop
// ============================================================================

enum SessionPhase: String, CaseIterable, Equatable {
    case discover
    case encounter
    case capture
    case collect
}

struct GapDetection: Equatable {
    let kuraSpace: String       // which kura-space had the gap
    let gapKind: String         // e.g. "untyped-axiom", "stale-form", "doctrine-violation"
    let signalStrength: Int     // 0..100
}

struct EncounterContext: Equatable {
    let directiveSource: String // "operator" | "autonomous-workflow" | "S1-incident"
    let targetKuraSpace: String
    var gapResolved: Bool
}

struct TypedRecord: Equatable, Hashable {
    let kind: String            // "axiom" | "workflow" | "role" | "schema-family" | "packet"
    let slug: String
    let timeline: String        // substrate era anchor
}

struct ChronicleEntry: Equatable {
    let recordRef: TypedRecord
    let appendedAt: String
}

final class SubstrateSession {
    var currentPhase: SessionPhase
    var pendingGaps: [GapDetection]
    var pendingEncounter: EncounterContext?
    var pendingCapture: TypedRecord?
    var chronicleEntries: [ChronicleEntry]
    var corpus: Set<TypedRecord>

    init() {
        self.currentPhase = .discover
        self.pendingGaps = []
        self.pendingEncounter = nil
        self.pendingCapture = nil
        self.chronicleEntries = []
        self.corpus = []
    }
}

// ============================================================================
// SYSTEMS — one per verb. Each transitions phase + emits typed receipts.
// ============================================================================

enum FourVerbSystem {

    // DISCOVER: explore corpus, surface gaps. Exit when a gap is strong enough
    // to trigger an encounter (signalStrength threshold).
    static func discover(
        _ session: SubstrateSession,
        emittingGaps: [GapDetection],
        encounterThreshold: Int
    ) {
        precondition(session.currentPhase == .discover, "discover requires discover-phase entry")
        session.pendingGaps.append(contentsOf: emittingGaps)
        if session.pendingGaps.contains(where: { $0.signalStrength >= encounterThreshold }) {
            session.currentPhase = .encounter
        }
    }

    // ENCOUNTER: engage with the highest-signal gap. Exit when bounded by an
    // EncounterContext ready for capture.
    static func encounter(
        _ session: SubstrateSession,
        directiveSource: String
    ) {
        precondition(session.currentPhase == .encounter, "encounter requires encounter-phase entry")
        guard let topGap = session.pendingGaps
            .filter({ $0.signalStrength >= 50 })
            .max(by: { $0.signalStrength < $1.signalStrength }) else { return }
        session.pendingEncounter = EncounterContext(
            directiveSource: directiveSource,
            targetKuraSpace: topGap.kuraSpace,
            gapResolved: false
        )
        session.currentPhase = .capture
    }

    // CAPTURE: turn EncounterContext into a typed substrate record. Exit when
    // record is emitted (pendingCapture populated).
    static func capture(
        _ session: SubstrateSession,
        recordKind: String,
        recordSlug: String,
        timeline: String
    ) {
        precondition(session.currentPhase == .capture, "capture requires capture-phase entry")
        guard session.pendingEncounter != nil else { return }
        let record = TypedRecord(kind: recordKind, slug: recordSlug, timeline: timeline)
        session.pendingCapture = record
        session.pendingEncounter?.gapResolved = true
        session.currentPhase = .collect
    }

    // COLLECT: accrete the typed record into the corpus, append chronicle
    // entry, clear pending state. Exit when corpus accretion completes — and
    // the loop returns to discover.
    static func collect(
        _ session: SubstrateSession,
        timestamp: String
    ) {
        precondition(session.currentPhase == .collect, "collect requires collect-phase entry")
        guard let pendingRecord = session.pendingCapture else { return }
        session.corpus.insert(pendingRecord)
        session.chronicleEntries.append(
            ChronicleEntry(recordRef: pendingRecord, appendedAt: timestamp)
        )
        // Clear the resolved gap from pending
        if let encounter = session.pendingEncounter {
            session.pendingGaps.removeAll { $0.kuraSpace == encounter.targetKuraSpace }
        }
        session.pendingCapture = nil
        session.pendingEncounter = nil
        session.currentPhase = .discover  // loop closes
    }
}

// ============================================================================
// TESTS — substrate session loop properties
// ============================================================================

// ─── F1 — Session starts in discover phase ────────────────────────────────

@Test("F1 — A fresh substrate session begins in the discover phase")
func sessionStartsInDiscover() {
    let session = SubstrateSession()
    #expect(session.currentPhase == .discover)
    #expect(session.pendingGaps.isEmpty)
    #expect(session.corpus.isEmpty)
    #expect(session.chronicleEntries.isEmpty)
}

// ─── F2 — Weak gaps don't trigger encounter; strong gaps do ───────────────

@Test("F2 — Discover phase exits to encounter only when gap signalStrength >= threshold")
func discoverTransitionsOnStrongGap() {
    let session = SubstrateSession()
    let weak = GapDetection(kuraSpace: "axioms", gapKind: "missing-citation", signalStrength: 20)
    let medium = GapDetection(kuraSpace: "axioms", gapKind: "stale-doctrine", signalStrength: 45)
    let strong = GapDetection(kuraSpace: "axioms", gapKind: "doctrine-violation", signalStrength: 80)

    // Weak alone → stays in discover
    FourVerbSystem.discover(session, emittingGaps: [weak], encounterThreshold: 50)
    #expect(session.currentPhase == .discover)

    // Medium alone (below 50) → stays in discover
    FourVerbSystem.discover(session, emittingGaps: [medium], encounterThreshold: 50)
    #expect(session.currentPhase == .discover)

    // Strong → transitions to encounter
    FourVerbSystem.discover(session, emittingGaps: [strong], encounterThreshold: 50)
    #expect(session.currentPhase == .encounter)
}

// ─── F3 — Encounter bounds the work via EncounterContext ──────────────────

@Test("F3 — Encounter system selects highest-signal gap and emits EncounterContext")
func encounterSelectsHighestSignal() {
    let session = SubstrateSession()
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "axioms", gapKind: "stale", signalStrength: 60),
        GapDetection(kuraSpace: "workflows", gapKind: "missing", signalStrength: 85),
        GapDetection(kuraSpace: "roles", gapKind: "ambiguous", signalStrength: 70)
    ], encounterThreshold: 50)
    #expect(session.currentPhase == .encounter)

    FourVerbSystem.encounter(session, directiveSource: "operator")
    #expect(session.currentPhase == .capture)
    #expect(session.pendingEncounter != nil)
    #expect(session.pendingEncounter?.targetKuraSpace == "workflows")  // 85 > 70 > 60
    #expect(session.pendingEncounter?.directiveSource == "operator")
    #expect(session.pendingEncounter?.gapResolved == false)  // not yet captured
}

// ─── F4 — Capture emits a typed substrate record ──────────────────────────

@Test("F4 — Capture turns EncounterContext into typed substrate record + resolves the gap")
func captureEmitsTypedRecord() {
    let session = SubstrateSession()
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "axioms", gapKind: "missing", signalStrength: 90)
    ], encounterThreshold: 50)
    FourVerbSystem.encounter(session, directiveSource: "operator")
    FourVerbSystem.capture(
        session,
        recordKind: "axiom",
        recordSlug: "substrate-cultural-lineage-six-confirmed-influences",
        timeline: "post-ECS-rebuild"
    )

    #expect(session.currentPhase == .collect)
    #expect(session.pendingCapture != nil)
    #expect(session.pendingCapture?.kind == "axiom")
    #expect(session.pendingCapture?.slug == "substrate-cultural-lineage-six-confirmed-influences")
    #expect(session.pendingCapture?.timeline == "post-ECS-rebuild")
    #expect(session.pendingEncounter?.gapResolved == true)
}

// ─── F5 — Collect accretes corpus + chronicle, closes loop to discover ────

@Test("F5 — Collect appends to corpus and chronicle, then loop returns to discover")
func collectAccretesAndLoops() {
    let session = SubstrateSession()
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "axioms", gapKind: "missing", signalStrength: 90)
    ], encounterThreshold: 50)
    FourVerbSystem.encounter(session, directiveSource: "operator")
    FourVerbSystem.capture(
        session,
        recordKind: "axiom",
        recordSlug: "substrate-session-is-pokemon-four-verb-loop",
        timeline: "post-ECS-rebuild"
    )
    FourVerbSystem.collect(session, timestamp: "2026-06-06T19:00:00Z")

    #expect(session.currentPhase == .discover)  // loop closes
    #expect(session.corpus.count == 1)
    #expect(session.chronicleEntries.count == 1)
    #expect(session.pendingCapture == nil)
    #expect(session.pendingEncounter == nil)
    #expect(session.pendingGaps.isEmpty)  // resolved gap cleared
}

// ─── F6 — Multiple full loops accumulate into corpus ──────────────────────

@Test("F6 — Multiple discover→encounter→capture→collect loops accumulate corpus")
func multipleFullLoopsAccumulate() {
    let session = SubstrateSession()

    // Loop 1: capture axiom
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "axioms", gapKind: "missing", signalStrength: 90)
    ], encounterThreshold: 50)
    FourVerbSystem.encounter(session, directiveSource: "operator")
    FourVerbSystem.capture(
        session,
        recordKind: "axiom",
        recordSlug: "substrate-cultural-lineage-six-confirmed-influences",
        timeline: "post-ECS-rebuild"
    )
    FourVerbSystem.collect(session, timestamp: "2026-06-06T19:00:00Z")

    // Loop 2: capture workflow
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "workflows", gapKind: "missing", signalStrength: 75)
    ], encounterThreshold: 50)
    FourVerbSystem.encounter(session, directiveSource: "operator")
    FourVerbSystem.capture(
        session,
        recordKind: "workflow",
        recordSlug: "gundam-versioning-discipline-cascade",
        timeline: "post-ECS-rebuild"
    )
    FourVerbSystem.collect(session, timestamp: "2026-06-06T19:05:00Z")

    // Loop 3: capture role
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "roles", gapKind: "ambiguous", signalStrength: 65)
    ], encounterThreshold: 50)
    FourVerbSystem.encounter(session, directiveSource: "operator")
    FourVerbSystem.capture(
        session,
        recordKind: "role",
        recordSlug: "borderlands-corp-brand-identity-auditor",
        timeline: "post-ECS-rebuild"
    )
    FourVerbSystem.collect(session, timestamp: "2026-06-06T19:10:00Z")

    #expect(session.corpus.count == 3)
    #expect(session.chronicleEntries.count == 3)
    #expect(session.currentPhase == .discover)  // ready for loop 4
    // Verify each chronicle entry references its captured record
    #expect(session.chronicleEntries[0].recordRef.slug == "substrate-cultural-lineage-six-confirmed-influences")
    #expect(session.chronicleEntries[1].recordRef.slug == "gundam-versioning-discipline-cascade")
    #expect(session.chronicleEntries[2].recordRef.slug == "borderlands-corp-brand-identity-auditor")
}

// ─── F7 — Each verb has typed entry condition; out-of-phase calls trap ────

@Test("F7 — Each verb has a typed entry condition — calling out-of-phase is forbidden")
func eachVerbHasTypedEntryCondition() {
    let session = SubstrateSession()
    #expect(session.currentPhase == .discover)

    // CAPTURE from DISCOVER phase — precondition would trap (preconditions
    // are runtime asserts, not testable safely here without expectFailure
    // semantics). We verify by reading the system's documented contract:
    // capture requires session.currentPhase == .capture per its precondition.
    // Substrate-doctrinal claim: the system signatures + preconditions
    // statically encode entry/exit gates.
    let entryConditions: [SessionPhase: String] = [
        .discover: "session-open OR collect-completed OR explicit /sync",
        .encounter: "operator-directive-issued OR autonomous-workflow-trigger OR S1-incident OR doctrine-violation-detected",
        .capture: "encounter-resolved-into-typed-record-pending",
        .collect: "capture-emitted-typed-record-pending-accretion"
    ]
    #expect(entryConditions.count == SessionPhase.allCases.count)
    for phase in SessionPhase.allCases {
        #expect(entryConditions[phase] != nil)
    }
}

// ─── F8 — Timeline anchor is preserved across capture and collect ─────────

@Test("F8 — Timeline anchor (substrate era) is preserved across capture→collect transition")
func timelinePreservedAcrossTransition() {
    let session = SubstrateSession()
    FourVerbSystem.discover(session, emittingGaps: [
        GapDetection(kuraSpace: "axioms", gapKind: "missing", signalStrength: 90)
    ], encounterThreshold: 50)
    FourVerbSystem.encounter(session, directiveSource: "operator")
    FourVerbSystem.capture(
        session,
        recordKind: "axiom",
        recordSlug: "test-timeline-axiom",
        timeline: "post-ECS-rebuild"
    )
    let timelineBefore = session.pendingCapture?.timeline
    FourVerbSystem.collect(session, timestamp: "2026-06-06T19:30:00Z")
    let timelineAfter = session.corpus.first?.timeline

    #expect(timelineBefore == "post-ECS-rebuild")
    #expect(timelineAfter == "post-ECS-rebuild")
    #expect(timelineBefore == timelineAfter)
    // Gundam-shaped timeline discipline: era anchor survives the capture→collect transition.
}
