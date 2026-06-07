@Metadata {
  @PageKind(article)
  @PageColor(green)
}

# components-and-ink

The UI in Claude Code is React rendered through a **vendored Ink
fork** at `src/ink/`. The component tree (`src/components/`) and the
Ink renderer are tightly coupled and worth understanding together.

## `src/ink/` — vendored Ink fork

`src/ink/` is not the upstream Ink package. It is a forked copy with
local layout, optimizer, and reconciler. `src/ink.ts` at root is a
thin re-export shim so the rest of the codebase imports from
`'../ink.js'` and the fork is invisible at call sites.

### Subdirectories

- **`layout/`** — `engine.ts`, `geometry.ts`, `node.ts`, `yoga.ts`.
  Layout engine; the `yoga.ts` shim binds to the in-tree
  `native-ts/yoga-layout/` port.
- **`components/`** — Ink-internal components (`AppContext.ts`, etc.).
- **`hooks/`** — Ink-internal hooks.
- **`events/`** — Input event plumbing.
- **`termio/`** — Terminal IO abstraction.

### Notable root files

- `reconciler.ts` — React reconciler.
- `renderer.ts` + `render-to-screen.ts` + `render-node-to-output.ts`
  — Frame rendering pipeline.
- `optimizer.ts` — Render diff optimizer.
- `frame.ts` — Frame buffer.
- `parse-keypress.ts` — Keypress parser (used by `src/keybindings/`).
- `bidi.ts` — Bidirectional text support.
- `colorize.ts` + `styles.ts` + `Ansi.tsx` — Color and style.
- `wrapAnsi.ts` + `squash-text-nodes.ts` — Text wrapping + node
  squashing.
- `terminal-querier.ts` + `terminal-focus-state.ts`
  `supports-hyperlinks.ts` — Terminal capability detection.
- `measure-element.ts` + `measure-text.ts` + `line-width-cache.ts`
  `node-cache.ts` + `tabstops.ts` + `get-max-width.ts` — Measurement
  caching.
- `hit-test.ts` — Pointer hit testing.
- `selection.ts` — Text selection state.
- `searchHighlight.ts` — Search highlight rendering.
- `clearTerminal.ts` — Terminal clear utility.
- `log-update.ts` — Log line update primitive.
- `instances.ts` + `root.ts` + `ink.tsx` + `dom.ts` — Top-level
  Ink instance management.
- `output.ts` + `render-border.ts` — Output writers.
- `focus.ts` — Focus management.
- `constants.ts` — Ink-internal constants.

## `src/components/` — application components (~144 entries)

Top-level files at `components/` root are screens, dialogs, and
inline widgets. Notable groupings (each with its own directory):

### Core dialogs + onboarding
- `App.tsx`, `Onboarding.tsx`, `ApproveApiKey.tsx`,
  `AutoModeOptInDialog.tsx`, `BridgeDialog.tsx`,
  `BypassPermissionsModeDialog.tsx`, `TrustDialog/`,
  `ManagedSettingsSecurityDialog/`, `InvalidConfigDialog.tsx`,
  `InvalidSettingsDialog.tsx`, `IdleReturnDialog.tsx`,
  `IdeAutoConnectDialog.tsx`, `IdeOnboardingDialog.tsx`,
  `WorktreeExitDialog.tsx`, `ChannelDowngradeDialog.tsx`,
  `DevChannelsDialog.tsx`, `ExportDialog.tsx`,
  `RemoteEnvironmentDialog.tsx`, `WorkflowMultiselectDialog.tsx`.

### Subsystem-specific dirs
- `agents/`, `tasks/`, `messages/`, `permissions/`, `mcp/`,
  `memory/`, `skills/`, `Settings/`, `Passes/`, `teams/`,
  `wizard/`, `sandbox/`, `shell/`, `diff/`, `StructuredDiff/`,
  `PromptInput/`, `HelpV2/`, `LogoV2/`, `Spinner/`, `grove/`,
  `DesktopUpsell/`, `FeedbackSurvey/`, `LspRecommendation/`,
  `ClaudeCodeHint/`, `CustomSelect/`, `HighlightedCode/`,
  `design-system/`, `ui/`, `hooks/`.

### Top-level widgets
- `Markdown.tsx`, `MarkdownTable.tsx`, `Spinner.tsx`,
  `StatusLine.tsx`, `Stats.tsx`, `MessageRow.tsx`,
  `MessageModel.tsx`, `MessageResponse.tsx`, `Messages.tsx`,
  `MessageSelector.tsx`, `MessageTimestamp.tsx`,
  `VirtualMessageList.tsx`, `Message.tsx`, `messageActions.tsx`,
  `MemoryUsageIndicator.tsx`, `TokenWarning.tsx`,
  `ToolUseLoader.tsx`, `Feedback.tsx`, `Markdown.tsx`,
  `EffortIndicator.ts`, `EffortCallout.tsx`, `FastIcon.tsx`,
  `KeybindingWarnings.tsx`, `LanguagePicker.tsx`,
  `ModelPicker.tsx`, `OutputStylePicker.tsx`, `ThemePicker.tsx`,
  `ThinkingToggle.tsx`, `BaseTextInput.tsx`, `TextInput.tsx`,
  `VimTextInput.tsx`, `BashModeProgress.tsx`, `Spinner.tsx`,
  `StructuredDiff.tsx`, `StructuredDiffList.tsx`,
  `MarkdownTable.tsx`.

### Teleport + remote
- `RemoteCallout.tsx`, `TeleportError.tsx`, `TeleportProgress.tsx`,
  `TeleportRepoMismatchDialog.tsx`, `TeleportResumeWrapper.tsx`,
  `TeleportStash.tsx`.

### Diagnostics + dev
- `DevBar.tsx`, `DiagnosticsDisplay.tsx`, `LogSelector.tsx`,
  `SentryErrorBoundary.ts`.

(Not exhaustive — see directory listing for the complete set.)

## `src/screens/` — top-level Ink screens

Three only:
- `Doctor.tsx` — `/doctor` UI.
- `REPL.tsx` — Main interactive screen.
- `ResumeConversation.tsx` — Resume picker.

## Cross-cutting

- **Behavior in `hooks/`, render in `components/`.** Most stateful
  behavior is in the `src/hooks/` cluster (~85 hooks). Components
  consume them. Don't look for state inside `.tsx` files first;
  look for the matching `useFoo` hook.
- **`design-system/` + `ui/` + `LogoV2/` + `HelpV2/`.** The "V2"
  suffix shows the migration in progress. Older sibling components
  may be in the same tree without the V2 suffix.
- **`hooks/` inside `components/` is a separate dir.** It is
  components-local hooks, distinct from `src/hooks/` at root. Don't
  confuse them.

## Open questions

- What `grove/` is (unusual name; likely a layout/forest concept).
- Which "V1" components are still alive vs. retired by their "V2"
  siblings.
- Whether `SentryErrorBoundary.ts` implies a Sentry pipeline beyond
  the analytics service.
- Where the design tokens for `design-system/` come from — possibly
  generated under `types/generated/`.
