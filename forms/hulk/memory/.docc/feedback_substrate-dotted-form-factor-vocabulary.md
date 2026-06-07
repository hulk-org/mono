---
name: substrate-dotted-form-factor-vocabulary
description: "Substrate-canonical naming pattern for executable products and form-factor variants — `<slug>.<form>[.<sub-form>]`. The dotted suffix declares the form factor (cli, sd, app, stack.app, etc.) of a logically-same component, decoupled from the hyphenated package-name convention. Hyphenated names stay as backcompat aliases."
metadata:
  node_type: memory
  type: feedback
  originSessionId: aebb7427-94c4-4c15-a344-4b1c9c3dcc59
---

The substrate now has a canonical vocabulary for naming form-factor variants of executable products. The operator named it after the `savepoint.sd` / `savepoint.cli` cut on 2026-05-25.

**Pattern:** `<slug>.<form>[.<sub-form>]`

**Why:** When the same logical component (savepoint) ships in multiple form factors (sleeping daemon, CLI, future app), hyphenated names get awkward (`savepoint-cli`, `savepoint-sd`, `savepoint-app`) and don't read as variants of the same thing. The dotted-suffix convention makes the form factor a first-class part of the name. Generative — any new component automatically inherits the vocabulary.

**Pairs with existing doctrine:** the substrate's typed JSON suffix family (`.identity.json` / `.agenda.json` / `.chronicle.json` / `.organism.json` / etc.) already uses dotted-suffix to declare typed surfaces. The product-name dotted-suffix is the executable-surface counterpart at the SPM layer.

**How to apply:**

1. **Product names use dotted form-factor**:
   - `<slug>.cli` — command-line tool that runs + exits
   - `<slug>.sd` — sleeping daemon (wake → drain → sleep), short-lived
   - `<slug>.d` — long-running classical daemon (vs `.sd`)
   - `<slug>.tui` — terminal UI (vs `.cli`)
   - `<slug>.app` — UI/GUI app surface
   - `<slug>.stack.app` — stack-component app (multiple surfaces composed)
   - `<slug>.web` — web surface
   - `<slug>.worker` — background job worker
   - `<slug>.scheduler` — scheduled-execution variant
   - `<slug>.workspace` — workspace/IDE integration

2. **Target names + filesystem paths stay hyphenated** (kebab-case, lowercase). The dotted name is the public executable; the hyphenated name is the SPM-internal identifier. Swift modules can't contain dots, so paths use hyphens.

   **Three kebab-case extensions added 2026-05-26 by operator rule:**

   a. **Swift source file names are kebab-case**: `HarnessArtifactProjectionModel.swift` → `harness-artifact-projection-model.swift`. Type names INSIDE the files stay PascalCase per Swift convention — only the filenames change.

   b. **`Sources/` and `Tests/` directories are lowercase**: `Sources/` → `sources/`, `Tests/` → `tests/`. Apple's SPM defaults to capitalized `Sources/` and `Tests/`; substrate convention overrides to lowercase via explicit `path:` declarations in `Package.swift`.

   c. **macOS APFS case-insensitivity caveat**: on the default macOS filesystem, `Sources/` and `sources/` resolve to the same path. Renaming case-only via a single `git mv` is a no-op git won't detect. The fix is a temp-folder stepping stone:

      ```bash
      git mv Sources tmp-rename-sources-2026-05-26
      git mv tmp-rename-sources-2026-05-26 sources
      ```

      Same for `Tests` → `tests`. Apply the same pattern when renaming any other case-only path differences (e.g., `Models/` → `models/`).

   In `Package.swift`:

   ```swift
   products: [
     .library(name: "SavepointEmitterCore", targets: ["SavepointEmitterCore"]),
     .executable(name: "savepoint.cli", targets: ["savepoint-cli"]),
   ],
   targets: [
     .executableTarget(
       name: "savepoint-cli",                  // ← hyphenated target name
       dependencies: ["SavepointEmitterCore"],
       path: "Sources/savepoint-cli"          // ← hyphenated filesystem path
     ),
   ]
   ```

3. **No backcompat aliases**: substrate moves forward. Don't keep `savepoint-cli` as a parallel `.executable` product alongside `savepoint.cli`. The dotted name is the only product; the hyphenated name lives only as the internal SPM identifier. Operator's rule from 2026-05-25: "no alias, just move forward."

3. **Reading the name tells you everything**: `<slug>` is the identity (what component), `<form>` is the executable shape (how it runs). `claude.cli` and `claude.app` are two surfaces of the same persona. `openclaw.sd` and `openclaw.cli` would be two execution shapes of the same harness.

4. **`.stack.app` precedent**: compound modifier before `.app` indicates a stack-component variant (multiple surfaces composed under one app shell). General form: `<slug>.<modifier>.<form>`.

5. **Don't reinvent ad-hoc form-factor names per package**: if you're authoring a new daemon and your slug is `widget`, the name is `widget.d` or `widget.sd` — not `widget-daemon` or `widget-server`.

**When NOT to use:**

- Library products (`.library`) stay PascalCase (`SavepointEmitterCore`, `IdentitySchemas_v000_006_000`) — those are Swift module names, not form-factor surfaces.
- Test target names follow SPM convention (`<Module>Tests`).
- The slug itself shouldn't contain dots — dots are reserved for form-factor suffixes.

Related: [[summon-vs-forge-two-registers]] (operator-vs-substrate vocabulary registers — this pattern is in the substrate register); [[lens-apps-substrate-pattern-2026-05-18]] (lens apps as the .app form-factor expressed as audience-specific perspectives); the existing typed JSON suffix family (`.identity.json` / `.agenda.json` / `.chronicle.json`) which is the JSON-layer counterpart.
