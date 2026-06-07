---
name: Always digikoma, never bare koma
description: Use the full `digikoma` prefix in prose, slugs, and types — the standalone `Koma` shorthand is retired. Supersedes the older `Koma not Komo` rule's allowance for bare `Koma`.
type: feedback
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
In prose, slugs, types, and conversation, always write **`digikoma`** (the full prefixed form). The standalone shorthand `Koma` is retired — don't use it on its own.

**Why:** As the substrate matured past the earlier "Koma is the chassis, Logikoma is the chassis+logic class" framing, `digikoma` became the only canonical execution-unit name in the operator's vocabulary. Using bare `Koma` in conversation creates ambiguity (which class? which compound?) and drifts back toward retired naming. Always-`digikoma` is unambiguous.

**How to apply:**
- **In prose / chat**: write "digikoma" not "koma" ("the digikoma fleet," "build a digikoma," not "the koma fleet").
- **In slugs / filesystem**: already `digikoma-<name>` (digikoma-launch-status, digikoma-swift-build) — keep that pattern.
- **In Swift type names**: `DigikomaCore`, `DigikomaIdentifiable`, `DigikomaAction`, `DigikomaSwiftBuildTool`, etc. — already correct, never invent a bare `Koma*` type.
- **Older memory entries** that say "use Koma standalone" (e.g. `feedback_koma-not-komo.md`) are superseded for the standalone-noun rule. The `Koma` → `Komo` spelling guidance still holds where the word appears in older artifacts; just don't generate new `Koma` standalone references.
- **Compound forms** that are NOT digikoma-prefixed (Tachikoma, Logikoma, Fuchikoma) keep their own naming — this rule is about not contracting "digikoma" to "koma" in our own prose.

When in doubt, type out the full word. "digikoma" is short enough.
