---
name: skills-as-inventory-items
description: "Skills are inventory items; `substrate/skills/` IS the root-agent's global inventory / TM shop. Draining = removing items from inventory and shelving them at their right ORG home. Three things ride on this: (1) owning ORG by authorship, consumer-adoption, or drain-entirely; (2) class names are DOMAIN nouns with optional vendor/platform sub-levels; (3) substrate has two main agent-skill catchments — clia-org for AI-runtime abilities, wrkstrm-core for developer tooling. Operator-named 2026-05-26."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dfd7b622-a65b-4621-9e0c-119fdacee483
---

The substrate's flat `private/universal/substrate/skills/` directory is the **root agent's inventory** — the global TM shop. Every entry there (real dir OR symlink — doesn't matter) is something the root agent eagerly knows how to do at session start.

**Operator-stated 2026-05-26:** *"this is like removing items from your inventory and placing them in their right home."*

"Draining" a skill means removing it from the global inventory and shelving it at the **owning ORG's home**. The skill still exists; it's just no longer eagerly broadcast to every agent — it's reachable only through the ORG that owns it, exactly as items in a workshop are reachable when you walk to that workshop.

**Why:** The root agent's inventory has finite attention budget. Cataloging every skill any ORG has ever authored bloats the global TM shop and obscures which skills are genuinely substrate-native vs. ORG-local. The drain re-establishes that the global catalog is **curated publication**, not auto-enumeration.

**How to apply:** Three questions per skill — (1) who OWNS this (which ORG submodule does it travel with)? (2) what DOMAIN does it serve (the class)? (3) should it stay globally cataloged or only be reachable through its ORG?

## Loading skills costs Stamina

**Operator-stated 2026-05-26:** *"loading skills are a drain to Stamina."*

Every skill cataloged in `substrate/skills/` gets eagerly enumerated by the harness at session start — name + description + (often) trigger guidance — and that enumeration costs **context tokens**, which in substrate cost-model terms IS **Stamina**. The global inventory isn't free; it has a runtime price per entry. This is the *mechanical* justification for the drain doctrine that the inventory metaphor alone only motivates aesthetically.

Consequences:

- **Stamina-conscious curation.** The global catalog should contain only skills the root agent legitimately needs eager access to: substrate-native primitives (`wd`, `roster`, `savepoint`, `thread-*`, etc.) plus a curated set of TMs that genuinely earn their Stamina cost (e.g., harness operations the agent runs every turn).
- **Drain ≠ deletion; drain ≠ "this skill isn't useful".** A skill can be excellent AND not deserve global catalog presence. The notion-* skills are useful — they just don't earn their Stamina cost for *every* agent in *every* session; they earn it only when the agent is operating in wrkstrm context, which is why they live at `wrkstrm/skills/notetaking/` without a global symlink.
- **Composition with [[insights/substrate-sync-cost-pattern-2026-05-26]] encumbrance layer.** Skill-loading Stamina is one contributor to the composite (harness × model × operator-policy) stamina ceiling. When `EncumbrancePressureLevel` triggers, the substrate's recourse includes shrinking the global catalog (drain more skills) the same way it shrinks other Stamina-spending surfaces.
- **Pokemon analogy gets mechanical teeth.** TMs in the bag literally cost weight; abilities bound to specific Pokemon don't burden the trainer. Skills work the same way — TMs in `substrate/skills/` cost the root agent Stamina; abilities bound to a specific ORG (sync at hulk's harness, notion-* at wrkstrm) cost the *ORG's* Stamina only when that ORG's context is active, not the root agent's at session start.

**The save side of the ledger is digikomas/supplements.** Skills are the *cost* side of Stamina; [[feedback_supplements-vs-digikomas-during-vs-turn-end]] is the *save* side. Draining skills recovers Stamina that would have been spent at session-start enumeration; routing work through digikomas recovers Stamina that would have been spent on active-turn work. Both moves operate on the same symmetric ledger — see that entry for the full accounting model and the "we need to model that" forward-engineering steps.

## Skill use vs ability use: eager `−stamina` vs deferred `−stamina`

**Operator-stated 2026-05-26:** *"every skill use as: −stamina. and every ability use as a deferred stamina use."*

Same SKILL.md content can be either a **skill** or an **ability** depending on where it lives:

- **Skill** — sits in `substrate/skills/` (the global catalog). Cost is **eager**: the harness enumerates every cataloged entry at session start, paying `−stamina` immediately regardless of whether the skill is used this session.
- **Ability** — sits at its owning ORG's home (e.g., `clia-org/.../audio/speech/`) with no global catalog presence. Cost is **deferred**: `−stamina` is paid only when the agent walks to the ORG's context and acquires the ability for actual use.

**The drain is a timing conversion, not an elimination.** Moving a skill from `substrate/skills/<name>` to `clia-org/.../<class>/<name>/` (without a back-symlink) flips the entry kind from eager `−stamina` to `−stamina_deferred`. Same cost; different *when*. Session-start budget is reclaimed; per-use cost is incurred only when the ability is actually picked up. See [[feedback_substrate-cost-circle]] for the full three-entry-kind ledger spec (`+stamina`, `−stamina`, `−stamina_deferred`).

**The drain has measurable justification: avoidable loss.** Per [[feedback_substrate-cost-circle]]'s avoidable-loss section — operator-stated 2026-05-26: *"if a skill is loaded and NOT used: it's a stamina loss which could have been avoided. but if a skill is used BEFORE a compaction... then it's zero stamina loss."* Skills that are eagerly loaded but never used before the next compaction become **avoidable loss** — pure waste. Skills used before compaction are justified loads (zero net loss). The substrate's drain priority for each cataloged skill is its observed avoidable-loss rate across sessions: high rate = strong drain candidate (convert to deferred ability); low rate = legitimate global-catalog citizen. Drain isn't aesthetic; it's a prediction the cost-circle can verify.

## Finding the owning ORG

Each skill travels with the ORG that owns it (when you submodule the ORG, you get its skills). Three cases, in order:

1. **Authorship** — which substrate ORG authored the SKILL.md and any bundled CLI/scripts? E.g., notion-* lives at `wrkstrm` because that's where `notion-lib` (the canonical Notion library) is authored, even when the SKILL.md bytes resolve through a symlink chain to upstream-bundled content like `maintainers/openai/.curated/`.
2. **Consumer-adoption** — if no substrate ORG authored the skill, an ORG that *uses* the underlying service as critical infrastructure can ADOPT it. Canonical: `vapor-wares-org` adopting `journeychat` because vapor-wares uses JourneyChat as IRC backend. The skill's home is then the consumer ORG.
3. **Drain entirely** — genuine third-party with no substrate consumer (e.g., `cua-driver` installed by a third-party macOS app whose vendor is `trycua`, not a substrate ORG). Remove from inventory; the skill is reachable only by walking to the app bundle if installed.

## Class is a DOMAIN noun (not a consumer-tier)

Inside an ORG's `private/universal/skills/`, group skills by **what kind of work they do**, not by who invokes them. Three shapes coexist:

1. **Single-level activity**: `audio/`, `harness/`, `notetaking/`, `browser-automation/`, `chat/`
2. **Activity → platform** (two-level): `build/apple/`, `scm/github/` — when the broad activity has multiple platform/vendor concretions and you want room for sibling platforms (`build/web/`, `scm/gitlab/`)
3. **Vendor → activity** (two-level, inverted): `digikoma/summarization/` — when ONE vendor is bringing a whole subtree of skills (e.g., digikoma folding into clia-org), the vendor goes FIRST as the umbrella class, then domain underneath

**Operator-stated 2026-05-26:** *"domain is turning into class"* — what I'd been calling "class subgroup" IS the domain identifier. Class names must be activity-shaped nouns (or vendor-family in shape 3), never consumer-tier names like `agent/` or `harness-consumer/`. I made this mistake repeatedly this session and got corrected three times; the rule is sharp.

## Substrate's two main agent-skill catchments

Two ORG homes have emerged as the natural catchments for agent-side skills, splitting along **runtime ability** vs **developer workflow**:

- **`clia-org` = AI-runtime abilities** — things the agent does *at runtime when it's working*. Examples this session: `harness/{sync, header}` (harness operations), `audio/{speech, transcribe}` (audio I/O), `browser-automation/playwright` (driving browsers), `digikoma/summarization/digikoma-chat-summary` (chat summarization).
- **`wrkstrm-core` = developer tooling** — things humans/agents do *as developers building software*. Examples this session: `build/apple/build-macos-apps`, `scm/github/{gh-fix-ci, gh-address-comments}`.

The diagnostic: would the agent run this skill *while working on a user task*, or *while shipping code as a developer*? Runtime-side → clia-org; developer-side → wrkstrm-core. Playwright was the surfacing case — I'd initially batched it with the developer tools, but it's clearly a runtime ability (agents drive browsers to research, scrape, fill forms), so it belongs with audio/ and harness/ in clia-org.

**Predictors for future skills:** `filesystem-automation/`, `shell-automation/`, `image-generation/`, `vector-search/` → clia-org. `linting/`, `dep-management/`, `release-tagging/`, `migration-orchestration/` → wrkstrm-core.

## What stays substrate-native (real dirs, no ORG home)

A short list of skills the substrate keeps directly in `substrate/skills/` as real directories because they ARE substrate-native primitives the root agent owns, not bound to any one ORG:

`wd`, `roster`, `triads-maintainer`, `savepoint`, `formatting-core`, `git-drain-files`, `agent-setup`, `thread-close`, `thread-next`, `thread-spin`

These are the legitimate inventory of the root agent's "always-on" toolkit.

## Companion entries

- [[insights/agent-abilities-pokemon-mechanics-with-topology-2026-05-26]] — the Pokemon TM/HM frame this builds on (TM = situational, HM = mandatory utility for one specific traversal). This entry adds the *operational* drain pattern to that conceptual frame.
- [[feedback_gstack-belongs-in-maintainers]] — third-party tool *collections* like gstack belong in maintainers/. This entry sharpens "third-party content" to mean "no substrate-authored library AND no consumer-org-adoption."
- [[feedback_kura-storage-typology]] — the broader Kura ownership tiers. Skills are a peer to `identity/`, `kura/`, `vaults/`, `spm/` under each ORG's `private/universal/`.
- [[feedback_executable-naming-slug-at-org-dot-form]] — the executable-naming doctrine (`<slug>@<org>.<form>`). Skills travel with the ORG whose name appears in the `@<org>` segment of any CLI they teach.
- [[feedback_substrate-cost-circle]] — the cross-participant synthesis that closes the substrate's economic model. This entry's Stamina-cost framing is the agent-side half; cost-circle extends it to the operator-side (ghost saves operator-Time) so the ledger covers both substrate participants.
