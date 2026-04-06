# AGENDA.md

## Purpose

Track the real onboarding and operating work for the `hulk` organism — the
carrier-shape that holds inference-engine + personality bundles.

## Current work

- **Contract v0.1.0** — initial draft of bones + skin clauses written.
  Refine based on observed breaches.
- **claude-code compliance audit** — measure the Anthropic reference
  implementation against the contract. The first observed breach is the
  S-1 (Bounded Memory) and S-7 (Host Citizenship) failure on 2026-04-04 and
  2026-04-05 (160GB host RAM leak crashing the operator's machine).
- **claw-code bootstrap** — second hulk implementation under `ultraworkers`,
  to be measured against the same contract.
- **Witness suite** — `hulk-org/witness` test harness that exercises each
  contract clause against an implementation. Not yet started.
- **Compliance manifest format** — define `hulk-compliance.json` schema.
- **Breach report format** — define the structure of a breach report for
  publication to an implementation's `breaches/` directory.

## Maintenance rule

When the hulk gains real operating threads (a witness suite, a compliance
audit, a published breach report), update this agenda to reflect active work
instead of generic wishlist items.
