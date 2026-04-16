# Ios Macos Frameworks

@Metadata {
  @TitleHeading("Expertise: Ios Macos Frameworks")
}

## Entries

- **App icon generation via Swift CoreGraphics + CoreText, no AppKit/UIKit.** CGContext + CGGradient + CTFont + CTLineCreateWithAttributedString + CGImageDestinationCreateWithURL writes a 1024×1024 PNG. Use `kCTFontAttributeName` / `kCTForegroundColorAttributeName` (CFString) in the attributes dict — `NSAttributedString.Key.font` / `.foregroundColor` are AppKit/UIKit additions and unavailable from pure Foundation. Keep as a re-runnable script in `scripts/`.
- **On-device Apple `FoundationModels` as the judgment layer in a Swift batch tool**: `LanguageModelSession` + `@Generable` typed output types + `@Guide` field-level prompt guidance, post-validated in Swift against hard invariants (regex blocklists, source-file existence checks, app-name matching). Zero API cost, offline, ~100ms-1s per call on Apple Silicon. Collapses the spine + session into a single Swift binary with no out-of-process JSON handoff. At 10 apps/day scale, every advisory prompt to the model is one silent regression per day; invariants must be Swift-enforced before the session runs, not prompt- advised at the session. "Foundation session" in rismay's workspace specifically means this, not a Claude Code sub-session.
- **On-device Apple `FoundationModels` as the judgment layer in a Swift batch tool**: `LanguageModelSession` + `@Generable` typed output types + `@Guide` field-level prompt guidance, post-validated in Swift against hard invariants (regex blocklists, source-file existence checks, app-name matching). Zero API cost, offline, ~100ms-1s per call on Apple Silicon. Collapses the spine + session into a single Swift binary with no out-of-process JSON handoff. At 10 apps/day scale, every advisory prompt to the model is one silent regression per day; invariants must be Swift-enforced before the session runs, not prompt- advised at the session. "Foundation session" in rismay's workspace specifically means this, not a Claude Code sub-session.
