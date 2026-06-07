@Metadata {
  @PageKind(article)
  @PageColor(yellow)
  @TitleHeading("Article")
}

# The iTerm Boundary And The Cate Pivot

*A page for 2026-06-03 — narrative of the turn the substrate stopped
pushing lane art into someone else's window and chose to host the
window inside its own canvas.*

---

## Executive summary

A single session-split lane refused to render its background image. The
typed bridge contract reported success; the visible window said
otherwise. After tracing the bridge code, landing a stderr-surfacing
fix, and proving the assignment reached iTerm but did not render,
the substrate recognized this as a typed-contract leak it could not
patch from the outside — and pivoted. The operator's freshly-synced
GitHub stars pool was queried; the answer was named in a single word:
**cate**. An Electron + React + xterm.js + node-pty canvas that hosts
editors, terminals, browsers, and AI agents in spatial panels we own
end-to-end. The substrate gained a new renderer-sibling for the
session-split family and a clean architectural inversion.

---

## The story, told in the substrate's symbolic vocabulary

🪞 The session-split fired and reported success.
   The new iTerm window had no background.
   The bridge had lied.

🔍 The trace, line by line:
   - `ITerm2Bridge.m:56` — `session.backgroundImage = path` (accepted)
   - `ITerm2Bridge.m:58-59` — read-back compared (matched)
   - `ITerm2Bridge.m:316` — `return YES` regardless
   - `main.swift:247` — Swift caller saw `launched = true`
   - `main.swift:268` — never inspected `launchError`
   - The orphan `.png` + `.svg` stayed on disk; no `discardAppearance`.

🔧 The fix that landed —
   `main.swift:268` gained a guard: when `launched && appearance != nil`,
   surface `launchError.localizedDescription` to stderr and `return false`.
   Reinstalled via `swift package experimental-install --product
   'session-split@takumi-org.cli'`.
   Now real bridge failures (NSException, session-not-found) print
   warnings; orphan artifacts get reclaimed.

🎨 But the deeper bug was the boundary itself.
   The AppleScript path *worked*. ScriptingBridge wrote, read back,
   and confirmed. iTerm received the property assignment cleanly.
   It just did not composite the image.
   The contract was structurally leaky: typed at the boundary,
   silent at the render layer.

⭐ So the operator named the move:
   *"easier to solve by syncing my github stars."*
   The github-stars vault hadn't been refreshed since 2026-05-13.
   `swift sync-github-stars-vault.swift` fetched 36 pages, 1751 stars.
   Build, check, triage, summarize all rebuilt.
   1611 unique repos. 600 marked `research_replacement`.

🐱 Then the operator named the answer:
   *"the answer is in cate."*
   `0-AI-UG/cate` — MIT, TypeScript, 1107 ⭐, pushed today.
   *"An infinite zoomable canvas for coding. Editor, terminal, and
   browser panels in a spatial workspace."*
   Starred 2026-05-30, six days before the boundary fired.

🖼️ The inversion the substrate recognized in cate:
   **Stop pushing substrate art INTO iTerm. Host iTerm-shape
   terminals INSIDE the substrate's own canvas.**
   The renderer becomes ours. Backgrounds, layouts, spatial memory,
   detached panels, dock zones — substrate-controlled all the way
   down to the CSS transform.

🌿 The doctrine that named itself —
   - `[[one-truth-many-lenses]]` — terminals are typed entities; iTerm
     and cate are two renderers of the same entity.
   - `[[data-is-one-thing-rendering-is-projection]]` — lane state is
     the typed truth; cate panels are projections.
   - `[[content-lives-in-its-owners-home]]` — substrate's lane art
     belongs in a home substrate owns the renderer of.

📐 The architecture cate ships with —
   - `src/shared/panels.ts` is the centralized panel-definition file.
     New panel types extend cleanly here.
   - `CanvasNode` wrapper gives drag/resize/close/title bar free.
   - `DockTabStack` gives tabs and splits free.
   - Zustand `canvasStore` for nodes/zoom/viewport/focus.
   - `electron-store` for session persistence.
   - IPC channels typed in `src/shared/ipc-channels.ts`.
   - `TerminalPanel` already wraps xterm.js + node-pty; we don't
     have to build the PTY layer.
   - There's already an `AgentPanel` for Claude Code threads.

🪶 The integration shape that compounds —
   `SessionSplitTerminalTarget` is a sum: `iterm | terminal | print`.
   The substrate-shaped move adds a fourth: `cate`.
   The lane brief's existing JSON + PNG + SVG triad becomes a typed
   "open panel pair" request to cate: TerminalPanel for the harness
   CanvasNode background = the PNG, rendered by code we own.
   The fork-resume happens *inside* a single cate canvas instead of
   as a new OS window dance.

📜 The receipts —
   - Cate cloned to `.tmp/cate/` (33 MB, shallow). Provisional working
     surface per CLAUDE.md doctrine. Will graduate to a typed
     vendored home when the substrate's remote-migration story
     settles.
   - Sister investigation page: <doc:cate-substrate-integration-2026-06-03>
     in claude's `memory/.docc/investigation.docc/`.
   - The session-split fix from `main.swift:268` stays useful even
     after the pivot — it catches the *other* class of bridge
     failures that aren't the render-layer leak.

🧭 What this turn proves about the substrate —
   The substrate is not negotiating with consumer-internet contracts
   anymore. When a typed boundary leaks, the substrate doesn't try
   to fix the leak from the outside; it finds (or builds) a renderer
   whose contract is substrate-owned. The github-stars vault is the
   substrate's typed memory of which contracts are worth inheriting.
   *Creative selection* is the substrate's name for the discipline of
   choosing from that memory deliberately, naming the choice, and
   typing the consequence.

---

## Addendum: the refinement to the substrate-shaped renderer

🐈‍⬛ The operator named the refinement minutes later:
   *"another star in there that used swift term that we should use.
   and it's important because we already have that dependency."*

🔍 The substrate inspected its own dep graph —
   `CommonConsoleKit/Package.swift:28` pins
   `https://github.com/migueldeicaza/SwiftTerm.git from 1.0.0`.
   Substrate already imports `SwiftTerm` as a product. The
   transitive surface is paid for.

🌟 The starred match — `CodeEditApp/CodeEdit`. 22,882 stars. MIT.
   Native Mac IDE. Pushed today.
   - `CodeEdit/Features/TerminalEmulator/Views/TerminalEmulatorView.swift`
     wraps `LocalProcessTerminalView` from SwiftTerm in a
     `NSViewRepresentable`.
   - `CEActiveTaskTerminalView`, `CELocalShellTerminalView`,
     `CETerminalView`, `TerminalEmulatorView+Coordinator`,
     `SwiftTerm+Color+Init` — the whole terminal layer is reusable.
   - `TerminalCache` preserves state when the view leaves hierarchy
     — substrate's session-persistence pattern, free.

⚖️ The trade re-rendered —
   - cate: TypeScript + Electron + xterm.js + node-pty. Carries
     Node ≤ 22 LTS ceiling and a full foreign-runtime surface.
   - CodeEdit: Native Mac + SwiftUI + SwiftTerm. Builds on a
     primitive substrate already imports. No new foreign surface.
   Cate carried the *doctrine* — substrate owns the renderer. CodeEdit
   is the doctrine's substrate-shaped *instantiation*.

🔧 The fork divergence to reconcile —
   CodeEdit pins `thecoolwinter/SwiftTerm`. Substrate pins
   `migueldeicaza/SwiftTerm`. Two paths:
   - Switch substrate's pin to match CodeEdit's fork.
   - Lift CodeEdit's terminal source and re-target the upstream pin.
   The substrate-doctrinal preference is the second — own the source
   we ship; minimize forked-upstream entanglement. The fork audit
   is the next typed sub-task.

📜 Receipts —
   - CodeEdit cloned to `.tmp/CodeEdit/` (21 MB shallow).
   - Sister investigation page revised with the CodeEdit-lane vendoring
     plan: <doc:cate-substrate-integration-2026-06-03>.
   - `SessionSplitTerminalTarget`'s new case becomes substrate-Swift-
     native (slug TBD — `codeeditview`, `swiftterm`, or similar),
     not `cate`.

🧬 The deeper doctrine this two-step proved —
   Creative selection is not a single pick. The first pass names the
   doctrine the substrate needs (`substrate owns the renderer`). The
   second pass names the substrate-shaped instantiation of that
   doctrine (`use the dep graph substrate already inherits`). Cate
   was the doctrinal anchor; CodeEdit is the doctrinal yield. The
   substrate's typed memory (the github-stars vault) carried both
   the visionary candidate and the substrate-fit candidate. The
   discipline named both. The substrate took the substrate-fit one.
