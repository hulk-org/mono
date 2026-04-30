---
name: Swift identifiers stay romaji
description: Swift identifiers and source-file names must be romaji ASCII; katakana belongs in human-facing prose only. Source code is fed to Foundation Models.
type: feedback
originSessionId: c5584c6e-7067-4c18-ba07-6e11d5bc5cff
---
Swift identifiers (type names, protocol names, enum cases, file names) must use romaji ASCII (`Digikoma`, not `デジコマ`). Katakana is reserved for human-facing surfaces only — doctrine, mythos, prose, decorative directory headers (アイディ.md, インスト.md, レイ.md), and operator-only files.

**Why:** Source code is effectively fed to Apple's Foundation Models via tool reflection and symbol-graph extraction. Apple's tokenizer and tool-definition validators don't handle non-ASCII Swift identifiers cleanly — non-ASCII names cause warnings or outright rejections at the model boundary. The user's earlier rule "Only files which are fed to AI need to be in english" extends to Swift code itself, because the substrate uses Komo + Tool reflection patterns that surface type names to Foundation Models. We discovered this on 2026-04-29 after scaffolding `デジコマIdentifiable` + 5 sibling katakana types in KomaCore, then immediately swapping to romaji in a follow-up commit.

**How to apply:**
- Swift type identifiers: romaji English (`DigikomaIdentifiable`, `DigikomaIntelligenceProvider`, `AutoDigikomaIntelligence`).
- Swift file names: romaji English matching the type (`DigikomaIdentifiable.swift`, etc.).
- Kebab-case package slugs: romaji lowercase (`digikoma-core`, `digikoma-rename`).
- Doctrine `.md`, mythos vault entries, agent home prose, banner SVGs: katakana OK (`デジコマ`).
- Decorative-named operator files (`アイディ.md`, `インスト.md`, `レイ.md`): katakana stays — those filenames are for the operator, not the model. Their contents may still need to be English when the agent reads them at runtime.
- When in doubt: ask "does this artifact reach a Foundation Model session, tool reflection pipeline, or symbol graph?" → if yes, romaji.

This rule supersedes any prior pattern of writing Swift identifiers in katakana. Tachikoma stays as the canonical Ghost-in-the-Shell organism name (it's already romaji + the canon spelling).
