@Metadata {
  @TechnologyRoot
  @PageKind(article)
  @PageColor(green)
  @TitleHeading("Hulk Investigations")
}

# Hulk Investigations

Open-ended investigations into Hulk's identity, contract, branding,
release strategy, witness suite, governance, and other questions that
don't yet have a settled answer.

These are not contracts, decisions, or policies. They are *thinking out
loud* — recorded so future-Hulk and future-rismay can read what we were
weighing on a given day, what we decided to do (or defer), and why.

Each investigation is a dated markdown file. Keep them honest; do not
revise them after the fact. If a later investigation supersedes an
earlier one, write a new file that references the older one — do not
overwrite.

## Index

- [Releasing and Branding (2026-04-08)](release-and-branding-2026-04-08.md)
  — strategic notes on what hulk *is* in shipping terms, the
  hulk-vs-hull naming question, the v0.1.0 → v1.0.0 release ladder,
  where to publish, what hulk should NOT become, and the five
  questions whose answers should drive the next concrete decisions.
- [Buddy vs. S-Type (2026-04-09)](buddy-vs-s-type-2026-04-09.md)
  — reads the actual buddy TypeScript at
  `harnesses/hulk/private/universal/domain/tooling/claude-code/src/buddy/`
  (types, roll engine, sprites, prompt injection, teaser hook) and
  compares it shape-for-shape against the A\* Triads / S-Type
  Contribution System docs in carrie/codex. Confirms Quipsnip is a
  buddy (species `owl`), names the shared "derived-from-seed
  contracts" pattern, and lists what each system could teach the
  other.
- [The Buddy Feature (2026-04-09)](buddy-feature-2026-04-09.md)
  — open investigation into the `buddy` subsystem referenced by the
  upstream claude-code TS snapshot (companion sprite, notification
  hook, separate prompt path), the gap between that reference and the
  placeholder Python package in claw-code, and how it relates to
  Quipsnip and the carrier-vs-persona split. Blocked on locating the
  upstream TS archive and on naming "the persistent agent folder."
- [Tachikoma Design Genesis (2026-04-10)](tachikoma-design-genesis-2026-04-10.md)
  — full reasoning chain from the design conversation that produced
  the CLIA organism ontology: the naming journey (crawler → spider →
  traverser → pet → Tachikoma), the trick abstraction, the five
  organism classes, the key invariants, the anatomy system
  (Ant/Hound/Fox/Spider/Owl mapped to algorithms), the training
  loop, the projection pipeline (compiler analogy), the worker
  contract, the cognition bridge, the execution-world ladder,
  the Fuchikoma boundary (disciplined vs chaotic), the cellular
  automata insight, and Apple Intelligence as Ghost not Pet.
- [The Daemon Menagerie (2026-04-08)](daemon-menagerie-2026-04-08.md)
  — grounded inventory of every daemon-shaped surface in the
  substrate today (ten implementations across two real problem
  shapes), honest pros/cons for each, and a priority-ordered
  consolidation plan that traces back to the unimplemented 2025-10-01
  polling-and-daemon survey. Names the unblocking question:
  does `SwiftDaemon` move out of `wrkstrm/`, or does
  `swift-service-registry` reach in to consume it?
