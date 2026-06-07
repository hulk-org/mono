---
name: Open-extensible catalogs require three-valued logic — UNKNOWN is first-class
description: Substrate schema-design follow-on from feedback_json-ordinality-tables-not-enums.md. When a substrate consumer references an OPEN-EXTENSIBLE catalog (LinkRef into a vault, not a closed ordinality table), validation outcomes are not binary. Three first-class cases: TRUE (known + valid), FALSE (definitively invalid), UNKNOWN (slug not yet in catalog — could be new signal being added, could be noise needing investigation). Kleene's three-valued logic. SQL NULL is canonical implementation. Substrate has been doing this implicitly via `| null` field declarations; this principle makes it explicit. Every consumer must structurally handle, recover from, and dissect UNKNOWN. Filter-signal-for-noise produces THREE buckets, not two.
type: feedback
originSessionId: 672b7a7f-48f5-4199-9f00-199e5f027e53
---
# Open-extensible catalogs require three-valued logic

**Rule:** When designing a substrate consumer that references an OPEN-EXTENSIBLE catalog (LinkRef into a vault), structurally handle THREE cases — TRUE / FALSE / UNKNOWN — not two. UNKNOWN is a first-class case. Don't crash on it; don't silent-fail it; capture it as a typed substrate event for investigation.

**Why:** Rismay's principle (2026-05-17): 'when we define things to be open and extensible we have to recognize that true and false are no longer the only valid options. unknown is then basically a third option. and all of our cases have to be able to handle that case and then be able to recover and disect why it was unknown.'

The argument:

1. **Closed catalogs are binary.** Ordinality-table-typed values (ideationKind k=1..5) are either valid (the integer matches a known ordinal) or not. Binary outcomes, fine.
2. **Open catalogs aren't binary.** LinkRefs into open vault catalogs (Spark refs, Concept refs, evidence refs, future Role refs) point at slugs that may not yet exist. An unknown slug could be:
   - A NEW value being added (substrate should accommodate it; reference resolves after the new record is materialized)
   - A typo (substrate should flag for correction)
   - A deprecated reference (substrate should surface deprecation history)
   - A wrong-vault-path reference (substrate should suggest the correct path)
   - An out-of-sync schema version reference (substrate should surface version mismatch)
   - A deliberate forward-reference (substrate's canonical fixture pattern; LinkRef targets that 'will eventually be materialized' — fixture file at ideation-schemas/v0.1.0/fixtures/canonical.exploration-this-thread.json explicitly does this)
3. **The same slug can BE all three over time.** A LinkRef to `spark-foo` is UNKNOWN at chronon T1 (not yet materialized), TRUE at T2 (materialized + valid), and could become FALSE at T3 if the spark record is later proven invalid via supersession. Three-valued logic is the temporal-honesty layer.

**Canonical references for the math:**
- Kleene's three-valued logic — formal logical system with TRUE / FALSE / UNKNOWN truth values
- Łukasiewicz logic — another three-valued system
- SQL NULL — canonical practical implementation (`NULL = NULL` returns `NULL` (UNKNOWN), not TRUE)

**Substrate has been doing this implicitly.** Many substrate schema fields use `boolean | null`, `string | null`, `LinkRef | null` — the `| null` is the substrate's implicit UNKNOWN case. Example: `HypothesisModel.fC.tr` (triggered) is `boolean | null` because the falsification check might not have run yet. This principle makes the implicit pattern explicit and gives it design force.

## How to apply

When designing a substrate consumer that references an open catalog:

1. **Declare the field as nullable.** `roleRef: LinkRef | null` instead of `roleRef: LinkRef`. Null means UNKNOWN (no role assigned yet OR the assigned role's record doesn't exist yet).
2. **Handle the UNKNOWN case in consumer code.** Don't crash, don't silent-fail. Capture as a typed substrate event with provenance (which consumer, when, what slug was referenced).
3. **Provide a dissection surface.** Typed investigation pathway: was the unknown a typo? new value being added? deprecated? wrong vault path? out-of-sync schema version? deliberate forward-reference? Each typed dissection outcome lets the substrate progress the UNKNOWN to TRUE or FALSE.
4. **Track stale UNKNOWNs.** UNKNOWNs that don't get investigated within a horizon (e.g., 30 days) become flagged stale-unknowns. Substrate doesn't let UNKNOWN become an escape hatch — uninvestigated UNKNOWNs accumulate as substrate epistemic debt.
5. **In rendering, show UNKNOWN honestly.** Don't hide the unknown case behind 'loading...' or fake confidence. Substrate's brand is honest-uncertainty; UNKNOWN should render visibly differently from TRUE-typed-rich Concepts.

## Pitfalls

- **Combinatorial explosion.** Two booleans is 4 cases; two three-valued is 9. Composing multiple open catalogs grows case analysis fast. Use Kleene min/max propagation rules: any UNKNOWN in a conjunction makes the result UNKNOWN (unless one operand is definitively FALSE); any UNKNOWN in a disjunction with TRUE returns TRUE; any UNKNOWN with UNKNOWN stays UNKNOWN.
- **UNKNOWN as escape hatch.** Without discipline, every uncertain answer gets typed as UNKNOWN and substrate epistemic content devolves into 'we don't know.' Counter: require typed-investigation-progress-tracking; surface stale-unknowns; penalize consumers that produce more UNKNOWNs without investigating them.
- **User-facing rendering risk.** Showing 'we don't know' may make substrate FEEL less authoritative than competitors that fake certainty. Substrate must commit to honest-uncertainty rendering as a brand feature — Vash-the-Stampede-style harshness-with-honesty.

## Cross-references

- `feedback_json-ordinality-tables-not-enums.md` — root principle; closed catalogs (ordinality table) are binary, open catalogs (LinkRef) are three-valued
- `feedback_definitions-are-json-not-markdown.md` — substrate definitions in typed JSON; nullable fields are JSON-native
- substrate doctrine: scientific-method-as-substrate-test-bench Concept — falsification conditions also use `| null` for unchecked state, same pattern
- substrate doctrine: filter-signal-for-noise mantra — filter outputs THREE buckets (signal / noise / unknown-investigation-queue), not two
